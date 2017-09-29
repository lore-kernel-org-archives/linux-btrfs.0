Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:45965 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbdI2ToP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:15 -0400
Received: by mail-qt0-f193.google.com with SMTP id t46so931516qtj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:15 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 04/21] btrfs: add ref-verify mount option
Date: Fri, 29 Sep 2017 15:43:48 -0400
Message-Id: <1506714245-23072-5-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the infrastructure for turning ref verify on and off for a
mount, to be used by a later patch.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/super.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 93e767e16a43..f1bd12f5f2d5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1334,6 +1334,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
+#define BTRFS_MOUNT_REF_VERIFY		(1 << 28)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f88ac4ebe01a..8e74f7029e12 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -326,6 +326,9 @@ enum {
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	Opt_ref_verify,
+#endif
 	Opt_err,
 };
 
@@ -387,6 +390,9 @@ static const match_table_t tokens = {
 	{Opt_fragment_metadata, "fragment=metadata"},
 	{Opt_fragment_all, "fragment=all"},
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+	{Opt_ref_verify, "ref_verify"},
+#endif
 	{Opt_err, NULL},
 };
 
@@ -827,6 +833,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, FRAGMENT_DATA);
 			break;
 #endif
+#ifdef CONFIG_BTRFS_FS_REF_VERIFY
+		case Opt_ref_verify:
+			btrfs_info(info, "doing ref verification");
+			btrfs_set_opt(info->mount_opt,
+				      REF_VERIFY);
+			break;
+#endif
 		case Opt_err:
 			btrfs_info(info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
@@ -1309,6 +1322,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(info, FRAGMENT_METADATA))
 		seq_puts(seq, ",fragment=metadata");
 #endif
+	if (btrfs_test_opt(info, REF_VERIFY))
+		seq_puts(seq, ",ref_verify");
 	seq_printf(seq, ",subvolid=%llu",
 		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
 	seq_puts(seq, ",subvol=");
-- 
2.7.4

