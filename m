Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab3IJEau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:50 -0400
Message-Id: <20130910043008.133043596@suse.com>
Date: Tue, 10 Sep 2013 00:24:13 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 5/7] btrfs: Add publishing of unknown features in sysfs
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the compat and compat-ro bits, it's possible for file systems to
exist that have features that aren't supported by the kernel's file system
implementation yet still be mountable.

This patch publishes read-only info on those features using a prefix:number
format, where the number is the bit number rather than the shifted value.
e.g. "compat:12"

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

--- a/fs/btrfs/sysfs.c	2013-09-10 00:10:02.549453084 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-10 00:17:01.813242796 -0400
@@ -56,6 +56,58 @@ static struct attribute *btrfs_supp_feat
 	NULL
 };
 
+const char * const btrfs_feature_set_names[FEAT_MAX] = {
+	[FEAT_COMPAT]	 = "compat",
+	[FEAT_COMPAT_RO] = "compat_ro",
+	[FEAT_INCOMPAT]	 = "incompat",
+};
+
+static char btrfs_feature_names[FEAT_MAX][64][13];
+static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX][64];
+
+static void init_feature_set_attrs(enum btrfs_feature_set set)
+{
+	int i;
+	int len = strlen(btrfs_feature_set_names[set]) + 4;
+
+	for (i = 0; i < 64; i++) {
+		char *name = btrfs_feature_names[set][i];
+		struct btrfs_feature_attr *fa;
+
+		snprintf(name, len, "%s:%u", btrfs_feature_set_names[set], i);
+
+		fa = &btrfs_feature_attrs[set][i];
+		fa->attr.name = name;
+		fa->attr.mode = S_IRUGO;
+		fa->feature_set = set;
+		fa->feature_bit = (1ULL << i);
+	}
+}
+
+static void init_feature_attrs(void)
+{
+	int i;
+
+	init_feature_set_attrs(FEAT_COMPAT);
+	init_feature_set_attrs(FEAT_COMPAT_RO);
+	init_feature_set_attrs(FEAT_INCOMPAT);
+
+	/* Copy the names over for supported features */
+	for (i = 0; btrfs_supp_feature_attrs[i]; i++) {
+		struct btrfs_feature_attr *fa;
+		struct attribute *attr;
+		int n;
+
+		fa = to_btrfs_feature_attr(btrfs_supp_feature_attrs[i]);
+		n = ilog2(fa->feature_bit);
+
+		attr = &btrfs_feature_attrs[fa->feature_set][n].attr;
+		attr->name = fa->attr.name;
+
+		btrfs_feature_names[fa->feature_set][n][0] = '\0';
+	}
+}
+
 static void btrfs_feature_release(struct kobject *kobj)
 {
 	struct btrfs_features *feat;
@@ -148,12 +200,12 @@ static u64 get_features(struct btrfs_fs_
 		return btrfs_super_incompat_flags(disk_super);
 }
 
-static int add_per_fs_features(struct btrfs_fs_info *fs_info)
+static int add_per_fs_feature_set(struct btrfs_fs_info *fs_info,
+				  enum btrfs_feature_set set)
 {
 	int i;
-	for (i = 0; btrfs_supp_feature_attrs[i]; i++) {
-		struct attribute *attr = btrfs_supp_feature_attrs[i];
-		struct btrfs_feature_attr *fa = to_btrfs_feature_attr(attr);
+	for (i = 0; i < ARRAY_SIZE(btrfs_feature_attrs[0]); i++) {
+		struct btrfs_feature_attr *fa = &btrfs_feature_attrs[set][i];
 		u64 features = get_features(fs_info, fa->feature_set);
 		int error;
 
@@ -167,6 +219,21 @@ static int add_per_fs_features(struct bt
 	return 0;
 }
 
+static int add_per_fs_features(struct btrfs_fs_info *fs_info)
+{
+	enum btrfs_feature_set set;
+	int error;
+
+	for (set = FEAT_COMPAT; set < FEAT_MAX; set++) {
+		error = add_per_fs_feature_set(fs_info, set);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+
 int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 {
 	int error;
@@ -276,6 +343,7 @@ int btrfs_init_sysfs(void)
 	if (!btrfs_kset)
 		return -ENOMEM;
 
+	init_feature_attrs();
 	ret = btrfs_init_feat_adverts();
 	if (ret) {
 		kset_unregister(btrfs_kset);


