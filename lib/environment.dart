class Environment {
  final EnvironmentKind kind;
  final String iosAdmobBannerUnitID;
  final String androidAdmobBannerUnitID;

  factory Environment() {
    const env = String.fromEnvironment('env');
    return env == 'prod' ? const Environment.prod() : const Environment.dev();
  }

  const Environment._({
    required this.kind,
    required this.iosAdmobBannerUnitID,
    required this.androidAdmobBannerUnitID
  });

  const Environment.prod()
      : this._(
    kind: EnvironmentKind.prod,
    iosAdmobBannerUnitID: "ca-app-pub-4395078331214572/5958752150",
    androidAdmobBannerUnitID: "ca-app-pub-4395078331214572/6157167470"
  );

  const Environment.dev()
      : this._(
    kind: EnvironmentKind.dev,
    iosAdmobBannerUnitID: "ca-app-pub-3940256099942544/2934735716",
    androidAdmobBannerUnitID: "ca-app-pub-3940256099942544/6300978111"
  );
}

enum EnvironmentKind {
  dev,
  prod,
}