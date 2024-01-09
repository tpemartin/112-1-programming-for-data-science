googlesheets4::gs4_auth()
ss="https://docs.google.com/spreadsheets/d/1Z7rTyOesELNgjst5zFU9uFEAqFqc3I7jB_1j3rKQe9c/edit?usp=sharing"
googlesheets4::read_sheet(ss,
                          range="分組名單!A1:F11") -> values

values |>
  tidyr::pivot_longer(
    cols = `member 1`:`member 5`,
    names_to = "type",
    values_to = "member"
  ) -> values_long

googlesheets4::read_sheet(
  ss,
  range="組員資訊!A1:D"
) -> values2

values2 |>
  dplyr::select(-`group name`) |>
  dplyr::left_join(
    values_long,
    by=c("選單"='member')
  ) |>
  dplyr::relocate("group name") |>
  dplyr::mutate(
    `Github username`=unlist(`Github username`)
  )-> values_final

clipr::write_clip(
  values_final,
    object_type = "table"
  )

# Attendance grades
ss="https://docs.google.com/spreadsheets/d/1kOkjekNjLcdJVvZ5zD3wx3gnY0L7gI1M8sK17xXwkr4/edit#gid=1233661760"
googlesheets4::read_sheet(ss,
                          "github"
                          ) -> values
googlesheets4::read_sheet(ss,
                          "最終修課名單")-> roster
values |>
  ## remove preparation weeks
  dplyr::select(-c("2023-09-20","2023-09-27")) |>
  ## make all attedance logical class
  dplyr::mutate(
    dplyr::across(
      `2023-10-11`:`2023-12-20`,
      .fns=function(x) as.logical(x)
    )
  ) |>
  ## count number of attendance
  dplyr::rowwise() |>
  dplyr::mutate(
    `總次數`=length(dplyr::c_across(`2023-10-11`:`2023-12-20`)),
    `出席次數`=sum(dplyr::c_across(`2023-10-11`:`2023-12-20`), na.rm=T),
  ## allow to drop one attendance
    `有效總次數`=`總次數`-1,
    `計分出席次數`=min(`出席次數`,`有效總次數`),
    `出席分數`=round(`計分出席次數`/`有效總次數`*20,2)
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
        選單=paste0("(",stringr::str_sub(學號,-3),")",姓名)
      ),
    by =c("(-學號末3碼）姓名"="選單")
  ) |>
  dplyr::select(
    姓名, 學號, `出席次數`, `總次數`
    ) |>
  dplyr::arrange(
    學號
    )-> attendance

googlesheets4::write_sheet(attendance, ss=ss,
                           "attendance")

## Bonus
groups <-
  googlesheets4::read_sheet(
    ss, "組員資訊"
  )
googlesheets4::read_sheet(ss,
                          "最終修課名單")-> roster
googlesheets4::read_sheet(ss,
                          "github"
) -> github
roster |>
  dplyr::select(姓名, 學號) |>
  dplyr::mutate(
    選單=paste0("(",stringr::str_sub(學號,-3),")",姓名)
  ) |>
  dplyr::left_join(
    groups, by="選單"
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
    by=c("group name"="group")
  ) -> roster2

# week14, 15 attendance
github |>
  dplyr::select(
    `(-學號末3碼）姓名`,`2023-12-13`,`2023-12-20`) |>
  dplyr::right_join(
    roster2,
    by = c("(-學號末3碼）姓名"="選單")
  ) |>
  dplyr::mutate(
    issue11_valid = issue11,
    issue13_valid = issue13 & `2023-12-13`,
    issue16_valid = issue16 & `2023-12-20`
  ) -> roster_withGroupBonus

roster_withGroupBonus |>
  dplyr::mutate(
    `Github username`= as.character(`Github username`)
  ) |>
  dplyr::mutate(
    issue8 = `Github username` %in% bonus_individual$issue8
  ) -> roster_withAllBonus

roster_withAllBonus |>
  dplyr::select(
    姓名, 學號, issue8, issue11_valid, issue13_valid, issue16_valid
  ) |>
  dplyr::mutate(
    issue8_individual = issue8*2,
    issue11_group = issue11_valid*1,
    issue13_group = issue13_valid*1,
    issue16_group = issue16_valid*1
  ) |>
  dplyr::select(
    姓名, 學號, issue8_individual, issue11_group, issue13_group, issue16_group
  ) |>
  dplyr::rowwise() |>
  dplyr::mutate(
    學期加分=sum(dplyr::c_across(
      issue8_individual:issue16_group
    ))
  ) |>
  dplyr::arrange(學號)-> bonus_all

bonus_all |>
  googlesheets4::write_sheet(
    ss,
    "學期總成績加分"
  )

# final project
source("support_final_project.R")
ss="https://docs.google.com/spreadsheets/d/1kOkjekNjLcdJVvZ5zD3wx3gnY0L7gI1M8sK17xXwkr4/edit?pli=1#gid=1556663194"
assessment = googlesheets4::read_sheet(ss, sheet="final-project-assessment")
assessment |>
  dplyr::filter(!(user %in% c("(007)Martin", "(008)Fabia")))
roster = googlesheets4::read_sheet(ss, sheet="最終修課名單")
roster$學號 |>
  stringr::str_sub(-3, -1) -> id3digits
namelist <- paste0("(", id3digits, ")", roster$姓名)
grouplist <- paste0("G",1:11)
project_grades = vector("list", 11) |>
  setNames(grouplist)
member_grades = vector("list",length(namelist)) |>
  setNames(namelist)

assessment$`project grades` |>
  purrr::reduce(.f=function(pg, .x){
    pg |>
      record_projectGradesJson(.x, grouplist)
  }, .init=project_grades) -> project_grades

assessment$`member grades` |>
  purrr::reduce(.f=function(pg, .x){
    pg |>
      record_memberGradesJson(.x, namelist)
  }, .init=member_grades) -> member_grades


project_grades |>
  purrr::map(function(.x) mean(.x, na.rm=T)) ->
  project_grades_studentAssessment

member_grades |>
  purrr::map(function(.x){
    if(is.null(.x)) return(0)
    mean(as.numeric(.x))
  }) ->
  member_grades_studentAssessment
