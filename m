Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab3HAQO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 12:14:57 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: sbehrens@giantdisaster.de, zab@redhat.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: add mount option to set commit interval
Date: Thu,  1 Aug 2013 18:14:52 +0200
Message-Id: <1375373692-14676-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1375371734-19581-1-git-send-email-dsterba@suse.cz>
References: <1375371734-19581-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'ts hardcoded to 30 seconds which is fine for most users. Higher values
defer data being synced to permanent storage with obvious consequences
when the system crashes. The upper bound is not forced, but a warning is
printed if it's more than 300 seconds (5 minutes).

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v2:
* Stefan pointed out a missing break and that /proc/mounts does not show
  the option.
* fixed missing goto and extra printk parameter after failed match_int

 fs/btrfs/ctree.h   |  3 +++
 fs/btrfs/disk-io.c |  6 ++++--
 fs/btrfs/super.c   | 27 +++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..edeb058 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1350,6 +1350,7 @@ struct btrfs_fs_info {
 	u64 last_trans_log_full_commit;
 	unsigned long mount_opt;
 	unsigned long compress_type:4;
+	int commit_interval;
 	/*
 	 * It is a suggestive number, the read side is safe even it gets a
 	 * wrong number because we will write out the data into a regular
@@ -1968,6 +1969,8 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 
+#define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
+
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
 #define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6b092a1..48390b1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1737,7 +1737,7 @@ static int transaction_kthread(void *arg)
 
 	do {
 		cannot_commit = false;
-		delay = HZ * 30;
+		delay = HZ * root->fs_info->commit_interval;
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 		spin_lock(&root->fs_info->trans_lock);
@@ -1749,7 +1749,8 @@ static int transaction_kthread(void *arg)
 
 		now = get_seconds();
 		if (cur->state < TRANS_STATE_BLOCKED &&
-		    (now < cur->start_time || now - cur->start_time < 30)) {
+		    (now < cur->start_time ||
+		     now - cur->start_time < root->fs_info->commit_interval)) {
 			spin_unlock(&root->fs_info->trans_lock);
 			delay = HZ * 5;
 			goto sleep;
@@ -2189,6 +2190,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
+	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 
 	/* readahead state */
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8eb6191..cfb916d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -321,6 +321,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_commit_interval,
 	Opt_err,
 };
 
@@ -361,6 +362,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
+	{Opt_commit_interval, "commit=%d"},
 	{Opt_err, NULL},
 };
 
@@ -626,6 +628,29 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_commit_interval:
+			intarg = 0;
+			ret = match_int(&args[0], &intarg);
+			if (ret < 0) {
+				printk(KERN_ERR
+					"btrfs: invalid commit interval\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			if (intarg > 0) {
+				if (intarg > 300) {
+					printk(KERN_WARNING
+					    "btrfs: excessive commit interval %d\n",
+							intarg);
+				}
+				info->commit_interval = intarg;
+			} else {
+				printk(KERN_INFO
+				    "btrfs: using default commit interval %ds\n",
+				    BTRFS_DEFAULT_COMMIT_INTERVAL);
+				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
+			}
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -942,6 +967,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
+		seq_printf(seq, ",commit=%d", info->commit_interval);
 	return 0;
 }
 
-- 
1.8.1.4

