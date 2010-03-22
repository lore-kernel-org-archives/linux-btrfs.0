From: Sage Weil <sage@newdream.net>
Subject: [PATCH 5/5] btrfs: add SNAP_DESTROY_ASYNC ioctl
Date: Mon, 22 Mar 2010 12:13:30 -0700
Message-ID: <1269285210-19085-6-git-send-email-sage@newdream.net>
References: <1269285210-19085-1-git-send-email-sage@newdream.net>
 <1269285210-19085-2-git-send-email-sage@newdream.net>
 <1269285210-19085-3-git-send-email-sage@newdream.net>
 <1269285210-19085-4-git-send-email-sage@newdream.net>
 <1269285210-19085-5-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1269285210-19085-5-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

There is no reason (aside from user expectations that space be
freed RIGHT NOW) that transaction removing the root reference
commit immediately.  Add an alternative ioctl that does not
commit immediately for those who don't need it to.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   12 +++++++++---
 fs/btrfs/ioctl.h |    2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd824a7..c8e6470 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1255,7 +1255,8 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 }
 
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
-					     void __user *arg)
+					     void __user *arg,
+					     int async)
 {
 	struct dentry *parent = fdentry(file);
 	struct dentry *dentry;
@@ -1338,7 +1339,10 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 				dest->root_key.objectid);
 	BUG_ON(ret);
 
-	ret = btrfs_commit_transaction(trans, root);
+	if (async)
+		ret = btrfs_end_transaction(trans, root);
+	else
+		ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	inode->i_flags |= S_DEAD;
 out_up_write:
@@ -2037,7 +2041,9 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1, 0);
 	case BTRFS_IOC_SNAP_DESTROY:
-		return btrfs_ioctl_snap_destroy(file, argp);
+		return btrfs_ioctl_snap_destroy(file, argp, 0);
+	case BTRFS_IOC_SNAP_DESTROY_ASYNC:
+		return btrfs_ioctl_snap_destroy(file, argp, 1);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
 		return btrfs_ioctl_default_subvol(file, argp);
 	case BTRFS_IOC_DEFRAG:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 4f7fe37..8109257 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -184,4 +184,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_SNAP_DESTROY_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 24, \
+				   struct btrfs_ioctl_vol_args)
 #endif
-- 
1.6.6.1

