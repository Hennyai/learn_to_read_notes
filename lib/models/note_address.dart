class noteAddress{
  final bool trebleClef;
  final String scale;
  final String noteName;

  noteAddress(this.trebleClef, this.scale, this.noteName);

  bool equals(noteAddress other) {
    return this.trebleClef == other.trebleClef &&
        this.scale == other.scale &&
        this.noteName == other.noteName;
  }

  @override
  String toString() {
    return 'noteAddress{trebleClef: $trebleClef, scale: $scale, noteName: $noteName}';
  }
}

class failedNote{
  final noteAddress note;
  int weight;

  failedNote(this.note, this.weight);

  @override
  String toString() {
    return 'failedNote{note: $note, weight: $weight}';
  }
}