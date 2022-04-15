class LabelViewModel {
  String userId = "";
  String labelId = "";
  String labelName = "";
  String profileImagePath = "";
  int labelRole = 0;

  LabelViewModel.withFields(
      this.userId,
      this.labelId,
      this.labelName,
      this.profileImagePath,
      this.labelRole);
}
