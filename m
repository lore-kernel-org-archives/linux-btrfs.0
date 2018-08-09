Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43089 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbeHIUhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:16 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 03/12] btrfs-progs: add new HMZONED feature flag
Date: Fri, 10 Aug 2018 03:10:56 +0900
Message-Id: <20180809181105.12856-3-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this feature enabled, a zoned block device aware btrfs allocates block
groups aligned to the device zones and always write in sequential zones at
the zone write pointer position.

Enabling this feature also force disable conversion from ext4 volumes.

Note: this flag can be moved to COMPAT_RO, so that older kernel can read
but not write zoned block devices formatted with btrfs.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 cmds-inspect-dump-super.c | 3 ++-
 ctree.h                   | 4 +++-
 fsfeatures.c              | 8 ++++++++
 fsfeatures.h              | 2 +-
 libbtrfsutil/btrfs.h      | 1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index e965267c..4e365ead 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -228,7 +228,8 @@ static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
 	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
-	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES)
+	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES),
+	DEF_INCOMPAT_FLAG_ENTRY(HMZONED)
 };
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
diff --git a/ctree.h b/ctree.h
index 4719962d..6d805ecd 100644
--- a/ctree.h
+++ b/ctree.h
@@ -489,6 +489,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_HMZONED		(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
@@ -509,7 +510,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_HMZONED)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/fsfeatures.c b/fsfeatures.c
index 7d85d60f..53396dd4 100644
--- a/fsfeatures.c
+++ b/fsfeatures.c
@@ -86,6 +86,14 @@ static const struct btrfs_fs_feature {
 		VERSION_TO_STRING2(4,0),
 		NULL, 0,
 		"no explicit hole extents for files" },
+#ifdef BTRFS_ZONED
+	{ "hmzoned", BTRFS_FEATURE_INCOMPAT_HMZONED,
+		"hmzoned",
+		NULL, 0,
+		NULL, 0,
+		NULL, 0,
+		"support Host-Managed Zoned devices" },
+#endif
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
diff --git a/fsfeatures.h b/fsfeatures.h
index 3cc9452a..0918ee1a 100644
--- a/fsfeatures.h
+++ b/fsfeatures.h
@@ -25,7 +25,7 @@
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
- * Avoid multi-device features (RAID56) and mixed block groups
+ * Avoid multi-device features (RAID56), mixed block groups, and hmzoned device
  */
 #define BTRFS_CONVERT_ALLOWED_FEATURES				\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF			\
diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index c293f6bf..c6a60fbc 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -268,6 +268,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_HMZONED		(1ULL << 10)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.18.0

