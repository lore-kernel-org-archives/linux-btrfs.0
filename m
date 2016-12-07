Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43342 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932883AbcLGVhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] Btrfs: add mount option for dax
Date: Wed,  7 Dec 2016 13:45:05 -0800
Message-Id: <1481147110-20048-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/super.c | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b8ce2b..e54c6e6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1317,6 +1317,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_root *root)
 #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
+#define BTRFS_MOUNT_DAX		(1 << 28)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74ed5aa..9b18f3d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,7 +323,7 @@ enum {
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
-	Opt_nologreplay, Opt_norecovery,
+	Opt_nologreplay, Opt_norecovery, Opt_dax,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -383,6 +383,7 @@ static const match_table_t tokens = {
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
+	{Opt_dax, "dax"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
@@ -410,6 +411,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 	enum btrfs_compression_type saved_compress_type;
 	bool saved_compress_force;
 	int no_compress = 0;
+	int set_bdev = 0;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (btrfs_fs_compat_ro(root->fs_info, FREE_SPACE_TREE))
@@ -470,6 +472,40 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 			btrfs_clear_opt(info->mount_opt, NODATACOW);
 			btrfs_clear_opt(info->mount_opt, NODATASUM);
 			break;
+#ifdef CONFIG_FS_DAX
+		case Opt_dax:
+			btrfs_set_and_info(info, DAX, "setting dax");
+			/*
+			 * sb->s_blocksize is set to root->sectorsize
+			 * sb->s_bdev is required, but btrfs doesn't set it
+			 * because of multi-device, so here we set it
+			 * temporarily.
+			 * We allows only one device in dax case.
+			 */
+			if (!info->sb->s_bdev) {
+				info->sb->s_bdev = info->fs_devices->latest_bdev;
+				set_bdev = 1;
+			}
+			ret = bdev_dax_supported(info->sb, info->sb->s_blocksize);
+			if (set_bdev)
+				info->sb->s_bdev = NULL;
+			if (ret)
+				goto out;
+
+			/* dax inode doesn't need inline. */
+			info->max_inline = 0;
+			btrfs_info(info, "max_inline at %llu", info->max_inline);
+
+			btrfs_clear_opt(info->mount_opt, COMPRESS);
+			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+			btrfs_set_opt(info->mount_opt, NODATACOW);
+			btrfs_set_opt(info->mount_opt, NODATASUM);
+			btrfs_info(info,
+				   "setting nodatacow, compression disabled");
+
+			/* dax doesn't expect other fancy options. */
+			goto out;
+#endif
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(info, NODATACOW)) {
 				if (!btrfs_test_opt(info, COMPRESS) ||
@@ -1232,6 +1268,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",nodatasum");
 	if (btrfs_test_opt(info, NODATACOW))
 		seq_puts(seq, ",nodatacow");
+	if (btrfs_test_opt(info, DAX))
+		seq_puts(seq, ",dax");
 	if (btrfs_test_opt(info, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (info->max_inline != BTRFS_DEFAULT_MAX_INLINE)
-- 
2.5.5

