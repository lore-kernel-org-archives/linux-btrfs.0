From: Sage Weil <sage@newdream.net>
Subject: [PATCH 3/6] Btrfs: add START_SYNC, WAIT_SYNC ioctls
Date: Mon, 25 Oct 2010 12:07:39 -0700
Message-ID: <1288033662-21464-4-git-send-email-sage@newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <1288033662-21464-2-git-send-email-sage@newdream.net>
 <1288033662-21464-3-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-3-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

START_SYNC will start a sync/commit, but not wait for it to
complete.  Any modification started after the ioctl returns is
guaranteed not to be included in the commit.  If a non-NULL
pointer is passed, the transaction id will be returned to
userspace.

WAIT_SYNC will wait for any in-progress commit to complete.  If a
transaction id is specified, the ioctl will block and then
return (success) when the specified transaction has committed.
If it has already committed when we call the ioctl, it returns
immediately.  If the specified transaction doesn't exist, it
returns EINVAL.

If no transaction id is specified, WAIT_SYNC will wait for the
currently committing transaction to finish it's commit to disk.
If there is no currently committing transaction, it returns
success.

These ioctls are useful for applications which want to impose an
ordering on when fs modifications reach disk, but do not want to
wait for the full (slow) commit process to do so.

Picky callers can take the transid returned by START_SYNC and
feed it to WAIT_SYNC, and be certain to wait only as long as
necessary for the transaction _they_ started to reach disk.

Sloppy callers can START_SYNC and WAIT_SYNC without a transid,
and provided they didn't wait too long between the calls, they
will get the same result.  However, if a second commit starts
before they call WAIT_SYNC, they may end up waiting longer for
it to commit as well.  Even so, a START_SYNC+WAIT_SYNC still
guarantees that any operation completed before the START_SYNC
reaches disk.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c       |   34 +++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h       |    2 +
 fs/btrfs/transaction.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |    1 +
 4 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..6306051 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1984,6 +1984,36 @@ long btrfs_ioctl_trans_end(struct file *file)
 	return 0;
 }
 
+static noinline long btrfs_ioctl_start_sync(struct file *file, void __user *argp)
+{
+	struct btrfs_root *root = BTRFS_I(file->f_dentry->d_inode)->root;
+	struct btrfs_trans_handle *trans;
+	u64 transid;
+
+	trans = btrfs_start_transaction(root, 0);
+	transid = trans->transid;
+	btrfs_commit_transaction_async(trans, root, 0);
+
+	if (argp)
+		if (copy_to_user(argp, &transid, sizeof(transid)))
+			return -EFAULT;
+	return 0;
+}
+
+static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
+{
+	struct btrfs_root *root = BTRFS_I(file->f_dentry->d_inode)->root;
+	u64 transid;
+
+	if (argp) {
+		if (copy_from_user(&transid, argp, sizeof(transid)))
+			return -EFAULT;
+	} else {
+		transid = 0;  /* current trans */
+	}
+	return btrfs_wait_for_commit(root, transid);
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2034,6 +2064,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_START_SYNC:
+		return btrfs_ioctl_start_sync(file, argp);
+	case BTRFS_IOC_WAIT_SYNC:
+		return btrfs_ioctl_wait_sync(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..e9a2f7e 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -178,4 +178,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 21, __u64)
+#define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d720106..932bc03 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -270,6 +270,58 @@ static noinline int wait_for_commit(struct btrfs_root *root,
 	return 0;
 }
 
+int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
+{
+	struct btrfs_transaction *cur_trans = NULL, *t;
+	int ret;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+
+	ret = 0;
+	if (transid) {
+		if (transid <= root->fs_info->last_trans_committed)
+			goto out_unlock;
+
+		/* find specified transaction */
+		list_for_each_entry(t, &root->fs_info->trans_list, list) {
+			if (t->transid == transid) {
+				cur_trans = t;
+				break;
+			}
+			if (t->transid > transid)
+				break;
+		}
+		ret = -EINVAL;
+		if (!cur_trans)
+			goto out_unlock;  /* bad transid */
+	} else {
+		/* find newest transaction that is committing | committed */
+		list_for_each_entry_reverse(t, &root->fs_info->trans_list,
+					    list) {
+			if (t->in_commit) {
+				if (t->commit_done)
+					goto out_unlock;
+				cur_trans = t;
+				break;
+			}
+		}
+		if (!cur_trans)
+			goto out_unlock;  /* nothing committing|committed */
+	}
+
+	cur_trans->use_count++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	wait_for_commit(root, cur_trans);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	put_transaction(cur_trans);
+	ret = 0;
+out_unlock:
+	mutex_unlock(&root->fs_info->trans_mutex);
+	return ret;
+}
+
 #if 0
 /*
  * rate limit against the drop_snapshot code.  This helps to slow down new
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 8972c62..33dec24 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -93,6 +93,7 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						  int num_blocks);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 							 int num_blocks);
+int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
-- 
1.6.6.1

