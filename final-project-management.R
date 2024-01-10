googlesheets4::gs4_auth()
ss <- "https://docs.google.com/spreadsheets/d/1Z7rTyOesELNgjst5zFU9uFEAqFqc3I7jB_1j3rKQe9c/edit?usp=sharing"
googlesheets4::read_sheet(ss,
  range = "分組名單!A1:F11"
) -> values

values |>
  tidyr::pivot_longer(
    cols = `member 1`:`member 5`,
    names_to = "type",
    values_to = "member"
  ) -> values_long

googlesheets4::read_sheet(
  ss,
  range = "組員資訊!A1:D"
) -> values2

values2 |>
  dplyr::select(-`group name`) |>
  dplyr::left_join(
    values_long,
    by = c("選單" = "member")
  ) |>
  dplyr::relocate("group name") |>
  dplyr::mutate(
    `Github username` = unlist(`Github username`)
  ) -> values_final

clipr::write_clip(
  values_final,
  object_type = "table"
)

# Attendance grades
ss <- "https://docs.google.com/spreadsheets/d/1kOkjekNjLcdJVvZ5zD3wx3gnY0L7gI1M8sK17xXwkr4/edit#gid=1233661760"
googlesheets4::read_sheet(
  ss,
  "github"
) -> values
googlesheets4::read_sheet(
  ss,
  "最終修課名單"
) -> roster
values |>
  ## remove preparation weeks
  dplyr::select(-c("2023-09-20", "2023-09-27")) |>
  ## make all attedance logical class
  dplyr::mutate(
    dplyr::across(
      `2023-10-11`:`2023-12-20`,
      .fns = function(x) as.logical(x)
    )
  ) |>
  ## count number of attendance
  dplyr::rowwise() |>
  dplyr::mutate(
    `總次數` = length(dplyr::c_across(`2023-10-11`:`2023-12-20`)),
    `出席次數` = sum(dplyr::c_across(`2023-10-11`:`2023-12-20`), na.rm = T),
    ## allow to drop one attendance
    `有效總次數` = `總次數` - 1,
    `計分出席次數` = min(`出席次數`, `有效總次數`),
    `出席分數` = round(`計分出席次數` / `有效總次數` * 20, 2)
  ) |>
  ## drop duplicated name
  dplyr::filter(
    !stringr::str_detect(`(-學號末3碼）姓名`, "dup")
  ) |>
  # Merge with roster
  dplyr::right_join(
    roster |>
      dplyr::select(姓名, 學號) |>
      dplyr::mutate(
        選單 = paste0("(", stringr::str_sub(學號, -3), ")", 姓名)
      ),
    by = c("(-學號末3碼）姓名" = "選單")
  ) |>
  dplyr::select(
    姓名, 學號, `出席次數`, `總次數`
  ) |>
  dplyr::arrange(
    學號
  ) -> attendance

googlesheets4::write_sheet(attendance,
  ss = ss,
  "attendance"
)

## Bonus
groups <-
  googlesheets4::read_sheet(
    ss, "組員資訊"
  )
googlesheets4::read_sheet(
  ss,
  "最終修課名單"
) -> roster
googlesheets4::read_sheet(
  ss,
  "github"
) -> github
roster |>
  dplyr::select(姓名, 學號) |>
  dplyr::mutate(
    選單 = paste0("(", stringr::str_sub(學號, -3), ")", 姓名)
  ) |>
  dplyr::left_join(
    groups,
    by = "選單"
  ) -> roster

## Group bonus
bonus_group <-
  googlesheets4::read_sheet(
    ss, "Group bonus"
  )
bonus_individual <-
  googlesheets4::read_sheet(
    ss, "Individual Bonus"
  )
bonus_group[is.na(bonus_group)] <- FALSE
roster |>
  dplyr::left_join(
    bonus_group,
    by = c("group name" = "group")
  ) -> roster2

# week14, 15 attendance
github |>
  dplyr::select(
    `(-學號末3碼）姓名`, `2023-12-13`, `2023-12-20`
  ) |>
  dplyr::right_join(
    roster2,
    by = c("(-學號末3碼）姓名" = "選單")
  ) |>
  dplyr::mutate(
    issue11_valid = issue11,
    issue13_valid = issue13 & `2023-12-13`,
    issue16_valid = issue16 & `2023-12-20`
  ) -> roster_withGroupBonus

roster_withGroupBonus |>
  dplyr::mutate(
    `Github username` = as.character(`Github username`)
  ) |>
  dplyr::mutate(
    issue8 = `Github username` %in% bonus_individual$issue8
  ) -> roster_withAllBonus

roster_withAllBonus |>
  dplyr::select(
    姓名, 學號, issue8, issue11_valid, issue13_valid, issue16_valid
  ) |>
  dplyr::mutate(
    issue8_individual = issue8 * 2,
    issue11_group = issue11_valid * 1,
    issue13_group = issue13_valid * 1,
    issue16_group = issue16_valid * 1
  ) |>
  dplyr::select(
    姓名, 學號, issue8_individual, issue11_group, issue13_group, issue16_group
  ) |>
  dplyr::rowwise() |>
  dplyr::mutate(
    學期加分 = sum(dplyr::c_across(
      issue8_individual:issue16_group
    ))
  ) |>
  dplyr::arrange(學號) -> bonus_all

bonus_all |>
  googlesheets4::write_sheet(
    ss,
    "學期總成績加分"
  )

# final project -----
source("support_final_project.R")
ss <- "https://docs.google.com/spreadsheets/d/1kOkjekNjLcdJVvZ5zD3wx3gnY0L7gI1M8sK17xXwkr4/edit?pli=1#gid=1556663194"
assessment_all <- googlesheets4::read_sheet(ss, sheet = "final-project-assessment")
assessment_all |>
  dplyr::filter(!(user %in% c("(007)Martin", "(008)Fabia"))) -> assessment
roster <- googlesheets4::read_sheet(ss, sheet = "最終修課名單")
roster$學號 |>
  stringr::str_sub(-3, -1) -> id3digits
namelist <- paste0("(", id3digits, ")", roster$姓名)
roster$namelist <- namelist

studentAssessments <- compute_student_assessment(assessment)

groupSheet <- googlesheets4::read_sheet(
  ss, "組員資訊"
)
roster |>
  dplyr::left_join(
    groupSheet,
    by = c("namelist" = "選單")
  ) -> roster

teacherAssessments <-
  assessment_all |>
  dplyr::filter(
    user=="(007)Martin"
  )

finalProjectGrade <- merge_assessments(studentAssessments, teacherAssessments)

# special case
finalProjectGrade |>
  split(
    finalProjectGrade$group.name=="G9"
  ) -> split_finalProjectGrade
df <- split_finalProjectGrade$`TRUE`
split_finalProjectGrade$`TRUE`[
  df$namelist=="(087)陳雲凱",
  "member_grade_byStudents"
] <- 5

split_finalProjectGrade$`TRUE`[
  df$namelist!="(087)陳雲凱",
  c("project_grade_byTeacher","project_grade_byStudents")
] <- 0

finalProjectGrade <- unsplit(
  split_finalProjectGrade,
  finalProjectGrade$group.name=="G9"
)

finalProjectGrade |>
  dplyr::select(
    group.name, namelist, 學號, member_grade_byStudents,
    project_grade_byStudents, project_grade_byTeacher
  ) -> finalProjectGrade

finalProjectGrade |>
  dplyr::mutate(
    finalProject = 10*(member_grade_byStudents/5)+
      10*(project_grade_byStudents/5)+
      20*(project_grade_byTeacher/5)
  ) -> finalProjectGrade

finalProjectGrade[is.na(finalProjectGrade)] <- 0

View(finalProjectGrade)

finalProjectGrade |>
  googlesheets4::write_sheet(
    ss, "final project grades"
  )

# final project assessment bonus -----
check_assessmentNotNull <- function(jsonassessment) {
  jsonassessment |>
    jsonlite::fromJSON() |>
    unlist() |>
    is.null() -> noBonus
  !noBonus
}

assessment$`project grades` |>
  purrr::map_lgl(
    check_assessmentNotNull
  ) |>
  as.integer() -> assessment$參與作品評分

assessment$`member grades` |>
  purrr::map_lgl(
    check_assessmentNotNull
  ) |>
  as.integer() -> assessment$參與組員互評

googlesheets4::read_sheet(
  ss, "學期總成績加分"
) -> semesterBonus

assessment |>
  dplyr::select(user,參與作品評分,參與組員互評) |>
  dplyr::right_join(
    roster |>
      dplyr::select(namelist, 學號),
    by=c("user"="namelist")
  ) |>
  dplyr::right_join(
    semesterBonus,
    by="學號"
  ) -> semesterBonus

names(semesterBonus)

semesterBonus[,
              c(
                "姓名", "學號", "issue8_individual", "issue11_group", "issue13_group",
                "issue16_group", "參與作品評分", "參與組員互評", "學期加分")] ->
  semesterBonusFinal
semesterBonusFinal |>
  dplyr::rowwise() |>
  dplyr::mutate(
    學期加分=sum(dplyr::c_across(issue8_individual:參與組員互評))
  ) -> semesterBonusFinal
semesterBonusFinal[is.na(semesterBonusFinal)] <-0
googlesheets4::write_sheet(
  semesterBonusFinal,
  ss, "學期總成績加分"
)

googlesheets4::read_sheet(
  ss,
  "attendance"
) -> attendance

attendance |>
  dplyr::mutate(
    學期出席成績=20* pmin(出席次數,7)/7
  ) -> attendanceFinal

googlesheets4::write_sheet(
  attendanceFinal,
  ss,
  "attendance"
)

# Semester grade ----
ss <- "https://docs.google.com/spreadsheets/d/1kOkjekNjLcdJVvZ5zD3wx3gnY0L7gI1M8sK17xXwkr4/edit#gid=1868367100"

googlesheets4::read_sheet(
  ss,
  "Midterm-上傳"
) -> midterm
googlesheets4::read_sheet(
  ss,
  "final project grades"
) -> finalProject
googlesheets4::read_sheet(
  ss,
  "attendance"
) -> attendance
googlesheets4::read_sheet(
  ss,
  "學期總成績加分"
) -> bonus

roster <- googlesheets4::read_sheet(ss, sheet = "最終修課名單")
roster$學號 |>
  stringr::str_sub(-3, -1) -> id3digits
namelist <- paste0("(", id3digits, ")", roster$姓名)
roster$namelist <- namelist

library(dplyr)
midterm |>
  select(代號,Total) |>
  rename(
    "學號"="代號",
    "期中考(原始分數, 滿分100)"="Total"
  ) |>
  mutate(
    `期中考學期分數(滿分40)`=`期中考(原始分數, 滿分100)`/100*40
  ) -> midtermFinal
finalProject |>
  select(學號, finalProject) |>
  rename(
    "期末專期學期分數(滿分40)"="finalProject"
  ) -> finalProjectFinal
attendance |>
  select(學號,學期出席成績) |>
  rename(
    "學期出席成績(滿分20)"="學期出席成績"
  ) -> attendanceFinal
roster |>
  left_join(
    midtermFinal,
    by="學號"
  ) |>
  left_join(
    finalProjectFinal,
    by="學號"
  ) |>
  left_join(
    attendanceFinal,
    by="學號"
  ) |>
  mutate(
    "學期總成績(不含加分)"=`期中考學期分數(滿分40)`+
      `期末專期學期分數(滿分40)`+
      `學期出席成績(滿分20)`
  ) |>
  select(
    學號,`期中考學期分數(滿分40)`,
      `期末專期學期分數(滿分40)`,
      `學期出席成績(滿分20)`,
    `學期總成績(不含加分)`
  ) -> semesterFinal

bonus |>
  select(姓名,學號,學期加分) -> bonusFinal

semesterFinal |>
  left_join(
    bonusFinal,
    by = "學號"
  ) |>
  relocate("姓名")-> semesterFinal2


semesterFinal2[is.na(semesterFinal2)] <- 0

googlesheets4::write_sheet(
  semesterFinal2,
  ss,
  "學期成績"
)
