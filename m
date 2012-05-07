From: Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] Add missing printing newlines
Date: Mon,  7 May 2012 13:38:51 +0800
Message-ID: <1336369131-6330-1-git-send-email-daniel@quora.org>
Cc: "Josef Bacik" <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Daniel J Blueman <daniel@quora.org>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix BTRFS messages to print a newline where there should be one.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 fs/btrfs/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5f8fca..c99cb72 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -216,7 +216,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
 {
-	WARN_ONCE(1, KERN_DEBUG "btrfs: Transaction aborted");
+	WARN_ONCE(1, KERN_DEBUG "btrfs: Transaction aborted\n");
 	trans->aborted = errno;
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
@@ -511,11 +511,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag");
+			printk(KERN_INFO "btrfs: enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
 		case Opt_recovery:
-			printk(KERN_INFO "btrfs: enabling auto recovery");
+			printk(KERN_INFO "btrfs: enabling auto recovery\n");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
 		case Opt_skip_balance:
@@ -1501,7 +1501,7 @@ static int btrfs_interface_init(void)
 static void btrfs_interface_exit(void)
 {
 	if (misc_deregister(&btrfs_misc) < 0)
-		printk(KERN_INFO "misc_deregister failed for control device");
+		printk(KERN_INFO "misc_deregister failed for control device\n");
 }
 
 static int __init init_btrfs_fs(void)
-- 
1.7.9.5

