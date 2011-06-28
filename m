From: David Sterba <dsterba@suse.cz>
Subject: [PATCH for -rc6] btrfs: add missing options displayed in mount output
Date: Tue, 28 Jun 2011 17:10:37 +0200
Message-ID: <1309273837-27595-1-git-send-email-dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I think this is patch should go into -rc6 series, it fixes a user-visible bug.
I was confused when I did not see the inode_cache in mount output although I
was sure (and verified in my script) that I had passed it to mount.

thanks,
david

---
From: David Sterba <dsterba@suse.cz>

There are three missed mount options settable by user which are not
currently displayed in mount output.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h |    5 +++++
 fs/btrfs/super.c |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3006287..4c840b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1336,6 +1336,11 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_STRING_ITEM_KEY	253
 
+/*
+ * Flags for mount options.
+ *
+ * Note: don't forget to add new options to btrfs_show_options()
+ */
 #define BTRFS_MOUNT_NODATASUM		(1 << 0)
 #define BTRFS_MOUNT_NODATACOW		(1 << 1)
 #define BTRFS_MOUNT_NOBARRIER		(1 << 2)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0bb4ebb..15634d4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -723,6 +723,12 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",clear_cache");
 	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
 		seq_puts(seq, ",user_subvol_rm_allowed");
+	if (btrfs_test_opt(root, ENOSPC_DEBUG))
+		seq_puts(seq, ",enospc_debug");
+	if (btrfs_test_opt(root, AUTO_DEFRAG))
+		seq_puts(seq, ",autodefrag");
+	if (btrfs_test_opt(root, INODE_MAP_CACHE))
+		seq_puts(seq, ",inode_cache");
 	return 0;
 }
 
-- 
1.7.5.2.353.g5df3e

