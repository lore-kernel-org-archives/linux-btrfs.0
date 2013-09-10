Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3IJEav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:51 -0400
Message-Id: <20130910043008.468612870@suse.com>
Date: Tue, 10 Sep 2013 00:24:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 7/7] btrfs: use feature attribute names to print better error messages
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have the feature name strings available in the kernel via
the sysfs attributes, we can use them for printing better failure
messages from the ioctl path.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ioctl.c |   35 ++++++++++++++++++++++++++++++-----
 fs/btrfs/sysfs.c |   25 +++++++++++++++++++++++++
 fs/btrfs/sysfs.h |    3 +++
 3 files changed, 58 insertions(+), 5 deletions(-)

--- a/fs/btrfs/ioctl.c	2013-09-09 23:23:34.794883859 -0400
+++ b/fs/btrfs/ioctl.c	2013-09-09 23:24:03.019073609 -0400
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "send.h"
 #include "dev-replace.h"
+#include "sysfs.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -4143,17 +4144,27 @@ static int btrfs_ioctl_get_features(stru
 	return 0;
 }
 
-static int check_feature_bits(struct btrfs_root *root, const char *type,
+static int check_feature_bits(struct btrfs_root *root,
+			      enum btrfs_feature_set set,
 			      u64 change_mask, u64 flags, u64 supported_flags,
 			      u64 safe_set, u64 safe_clear)
 {
+	const char *type = btrfs_feature_set_names[set];
+	char *names;
 	u64 disallowed, unsupported;
 	u64 set_mask = flags & change_mask;
 	u64 clear_mask = ~flags & change_mask;
 
 	unsupported = set_mask & ~supported_flags;
 	if (unsupported) {
-		btrfs_warn(root->fs_info,
+		names = btrfs_printable_features(set, unsupported);
+		if (names) {
+			btrfs_warn(root->fs_info,
+			   "this kernel does not support the %s feature bit%s",
+			   names, strchr(names, ',') ? "s" : "");
+			kfree(names);
+		} else
+			btrfs_warn(root->fs_info,
 			   "this kernel does not support %s bits 0x%llx",
 			   type, unsupported);
 		return -EOPNOTSUPP;
@@ -4161,7 +4172,14 @@ static int check_feature_bits(struct btr
 
 	disallowed = set_mask & ~safe_set;
 	if (disallowed) {
-		btrfs_warn(root->fs_info,
+		names = btrfs_printable_features(set, disallowed);
+		if (names) {
+			btrfs_warn(root->fs_info,
+			   "can't set the %s feature bit%s while mounted",
+			   names, strchr(names, ',') ? "s" : "");
+			kfree(names);
+		} else
+			btrfs_warn(root->fs_info,
 			   "can't set %s bits 0x%llx while mounted",
 			   type, disallowed);
 		return -EPERM;
@@ -4169,7 +4187,14 @@ static int check_feature_bits(struct btr
 
 	disallowed = clear_mask & ~safe_clear;
 	if (disallowed) {
-		btrfs_warn(root->fs_info,
+		names = btrfs_printable_features(set, disallowed);
+		if (names) {
+			btrfs_warn(root->fs_info,
+			   "can't clear the %s feature bit%s while mounted",
+			   names, strchr(names, ',') ? "s" : "");
+			kfree(names);
+		} else
+			btrfs_warn(root->fs_info,
 			   "can't clear %s bits 0x%llx while mounted",
 			   type, disallowed);
 		return -EPERM;
@@ -4179,7 +4204,7 @@ static int check_feature_bits(struct btr
 }
 
 #define check_feature(root, change_mask, flags, mask_base)	\
-check_feature_bits(root, # mask_base, change_mask, flags,	\
+check_feature_bits(root, FEAT_##mask_base, change_mask, flags,	\
 		   BTRFS_FEATURE_ ## mask_base ## _SUPP,	\
 		   BTRFS_FEATURE_ ## mask_base ## _SAFE_SET,	\
 		   BTRFS_FEATURE_ ## mask_base ## _SAFE_CLEAR)
--- a/fs/btrfs/sysfs.c	2013-09-09 23:24:02.991073420 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-09 23:24:03.019073609 -0400
@@ -65,6 +65,31 @@ const char *btrfs_feature_set_names[FEAT
 static char btrfs_feature_names[FEAT_MAX][64][13];
 static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX][64];
 
+char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags)
+{
+	size_t bufsize = 4096; /* safe max, 64 names * 64 bytes */
+	int len = 0;
+	int i;
+	char *str;
+
+	str = kmalloc(bufsize, GFP_KERNEL);
+	if (!str)
+		return str;
+
+	for (i = 0; i < ARRAY_SIZE(btrfs_feature_attrs[set]); i++) {
+		if (!(flags & (1ULL << i)))
+			continue;
+
+		flags &= ~(1ULL << i);
+
+		len += snprintf(str + len, bufsize - len,
+				"%s%s", len ? "," : "",
+				btrfs_feature_attrs[set][i].attr.name);
+	}
+
+	return str;
+}
+
 static void init_feature_set_attrs(enum btrfs_feature_set set)
 {
 	int i;
--- a/fs/btrfs/sysfs.h	2013-09-09 23:23:34.794883859 -0400
+++ b/fs/btrfs/sysfs.h	2013-09-09 23:24:03.019073609 -0400
@@ -53,4 +53,7 @@ static struct btrfs_feature_attr btrfs_a
 #define to_btrfs_feature_attr(a) \
 			container_of(a, struct btrfs_feature_attr, attr)
 
+char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
+extern const char *btrfs_feature_set_names[FEAT_MAX];
+
 #endif /* _BTRFS_SYSFS_H_ */


