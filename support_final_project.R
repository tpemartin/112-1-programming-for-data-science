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
