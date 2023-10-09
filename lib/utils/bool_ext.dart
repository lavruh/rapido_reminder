extension Compare on bool {
  int compareTo(bool b) {
    if (this && b) {
      return 0;
    }
    if (this) {
      return -1;
    }
    return 1;
  }
}
