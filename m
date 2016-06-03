Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33835 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcFCCIG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 22:08:06 -0400
Received: by mail-qt0-f196.google.com with SMTP id d51so1819721qte.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 19:08:05 -0700 (PDT)
From: Andrew Armenia <andrew@asquaredlabs.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH] btrfs: chunk_width_limit mount option
Date: Thu,  2 Jun 2016 21:50:15 -0400
Message-Id: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds mount option 'chunk_width_limit=X', which when set forces
the chunk allocator to use only up to X devices when allocating a chunk.
This may help reduce the seek penalties seen in filesystems with large
numbers of devices.

Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
---
 fs/btrfs/ctree.h   |  3 +++
 fs/btrfs/super.c   | 22 +++++++++++++++++++++-
 fs/btrfs/volumes.c | 26 ++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 101c3cf..27b6f8f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -754,6 +754,9 @@ struct btrfs_fs_info {
 	unsigned long pending_changes;
 	unsigned long compress_type:4;
 	int commit_interval;
+
+	int chunk_width_limit;
+
 	/*
 	 * It is a suggestive number, the read side is safe even it gets a
 	 * wrong number because we will write out the data into a regular
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4e59a91..3da5220 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -300,7 +300,7 @@ enum {
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
-	Opt_nologreplay, Opt_norecovery,
+	Opt_nologreplay, Opt_norecovery, Opt_width_limit,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -360,6 +360,7 @@ static const match_table_t tokens = {
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
+	{Opt_width_limit, "chunk_width_limit=%d"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
@@ -782,6 +783,22 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 			}
 			break;
+		case Opt_width_limit:
+			intarg = 0;
+			ret = match_int(&args[0], &intarg);
+			if (ret < 0) {
+				btrfs_err(root->fs_info, "invalid chunk width limit");
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (intarg > 0) {
+				info->chunk_width_limit = intarg;
+			} else {
+				btrfs_info(root->fs_info, "chunk width is unlimited");
+				info->chunk_width_limit = 0;
+			}
+			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:
 			btrfs_info(root->fs_info, "fragmenting all space");
@@ -1207,6 +1224,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
+	if (info->chunk_width_limit != 0)
+		seq_printf(seq, ",chunk_width_limit=%d",
+			info->chunk_width_limit);
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bdc6256..6d0d35d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4558,6 +4558,32 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	devs_increment = btrfs_raid_array[index].devs_increment;
 	ncopies = btrfs_raid_array[index].ncopies;
 
+	/*
+	 * if we have a statically-configured chunk width, and the type doesn't
+	 * specify one, go ahead and use the statically-configured max instead.
+	 *
+	 * If the static value is greater than the BTRFS_MAX_DEVS for the
+	 * chunk tree, we ignore it.
+	 *
+	 * Also, we ignore the static value for system chunks.
+	 */
+	if (
+		devs_max == 0 && info->chunk_width_limit != 0
+		&& !(type & BTRFS_BLOCK_GROUP_SYSTEM)
+		&& info->chunk_width_limit <= BTRFS_MAX_DEVS(info->chunk_root)
+	) {
+		if (info->chunk_width_limit >= devs_min) {
+			devs_max = info->chunk_width_limit;
+		} else {
+			/* warn that the static devs_max is unusable */
+			btrfs_warn(info,
+				"can't satisfy max chunk width of %d; "
+				"minimum %d devices needed",
+				info->chunk_width_limit, devs_max
+			);
+		}
+	}
+
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_stripe_size = SZ_1G;
 		max_chunk_size = 10 * max_stripe_size;
-- 
2.1.4

