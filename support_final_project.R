
merge_assessments <- function(studentAssessments, teacherAssessments){
  {
    data.frame(
      `group name` = studentAssessments$project_grades_studentAssessment |> names(),
      `project_grade_byStudents` = unlist(studentAssessments$project_grades_studentAssessment)
    ) |>
      dplyr::right_join(
        roster,
        by = c("group.name" = "group name")
      ) -> finalProject
  }
  {
    data.frame(
      `namelist` = studentAssessments$member_grades_studentAssessment |> names(),
      `member_grade_byStudents` = unlist(studentAssessments$member_grades_studentAssessment)
    ) |>
      dplyr::right_join(
        finalProject,
        by = c("namelist" = "namelist")
      ) -> finalProject
  }
  {

    teacherAssessments$`project grades`[[1]] |>
      jsonlite::fromJSON() -> pg
    pg = unlist(pg)
    groupNames = names(pg)
    data.frame(
      `group name` =  groupNames,
      `project_grade_byTeacher` = unlist(pg[groupNames])
    ) |>
      dplyr::right_join(
        finalProject,
        by = c("group.name" = "group.name")
      ) -> finalProject
  }
  return(finalProject)
}
compute_student_assessment <- function(assessment) {
  grouplist <- paste0("G", 1:11)
  project_grades <- vector("list", 11) |>
    setNames(grouplist)
  member_grades <- vector("list", length(namelist)) |>
    setNames(namelist)

  assessment$`project grades` |>
    purrr::reduce(.f = function(pg, .x) {
      pg |>
        record_projectGradesJson(.x, grouplist)
    }, .init = project_grades) -> project_grades

  assessment$`member grades` |>
    purrr::reduce(.f = function(pg, .x) {
      pg |>
        record_memberGradesJson(.x, namelist)
    }, .init = member_grades) -> member_grades


  project_grades |>
    purrr::map(function(.x) mean(.x, na.rm = T)) ->
    project_grades_studentAssessment

  member_grades |>
    purrr::map(function(.x) {
      if (is.null(.x)) {
        return(0)
      }
      mean(as.numeric(.x))
    }) ->
    member_grades_studentAssessment
  return (list(
    project_grades_studentAssessment=project_grades_studentAssessment,
    member_grades_studentAssessment=member_grades_studentAssessment
  ))
}
record_projectGradesJson <- function(project_grades, projectGradesJson, grouplist) {
  # projectGradesJson <- assessment$`project grades`[[1]]
  jsonlite::fromJSON(projectGradesJson) -> projectGrades
  seq_along(grouplist) |>
    purrr::map(~{
      projectX <- projectGrades[[grouplist[[.x]]]]
      groupX <- grouplist[[.x]]
      if(!is.null(projectX)){
        project_grades[[groupX]] <- c(project_grades[[groupX]], projectX)
      }
      project_grades[[groupX]]
    }) |>
    setNames(grouplist) -> project_grades

  return (project_grades)
}
record_memberGradesJson <- function(member_grades, memberGradesJson, namelist) {
  # memberGradesJson <- assessment$`project grades`[[1]]
  jsonlite::fromJSON(memberGradesJson) -> memberGrades
  seq_along(namelist) |>
    purrr::map(~{
      memberX_grade <- memberGrades[[namelist[[.x]]]]
      memberX <- namelist[[.x]]
      if(!is.null(memberX_grade)){
        member_grades[[memberX]] <- c(member_grades[[memberX]], memberX_grade)
      }
      member_grades[[memberX]]
    }) |>
    setNames(namelist) -> member_grades

  return (member_grades)
}
