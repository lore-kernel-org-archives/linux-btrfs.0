Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32015 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbKIK5v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:51 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9Avpoo015180
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvoDg004977
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:50 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvoWk018224
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/15] btrfs: check for failed device and hot replace
Date: Mon,  9 Nov 2015 18:56:29 +0800
Message-Id: <1447066589-3835-16-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch creates casualty_kthread to check for the failed
devices, and triggers device replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |  3 ++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4d25fd8..3e706ff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1613,6 +1613,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
+	struct task_struct *casualty_kthread;
 	int thread_pool_size;
 
 	struct kobject *space_info_kobj;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3662c0a..beefe35 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1836,6 +1836,64 @@ sleep:
 	return 0;
 }
 
+/*
+ * A kthread to check if any auto maintenance be required. This is
+ * multithread safe, and kthread is running only if
+ * fs_info->casualty_kthread is not NULL, fixme: atomic ?
+ */
+static int casualty_kthread(void *arg)
+{
+	struct btrfs_root *root = arg;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	int found = 0;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		goto out;
+
+	btrfs_dev_replace_lock(&fs_info->dev_replace);
+	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
+		btrfs_dev_replace_unlock(&fs_info->dev_replace);
+		goto out;
+	}
+	btrfs_dev_replace_unlock(&fs_info->dev_replace);
+
+	/*
+	 * Find failed device, if any. After the replace the failed
+	 * device is removed, so any failed device found here is new and
+	 * will be a candidate for the replace, if FS can't work without
+	 * the failed device then btrfs_std_error() will have put FS into
+	 * readonly
+	 */
+	/*
+	 * fixme: introduce a priority order to find failed device,
+	 * chronological order ?
+	 */
+	mutex_lock(&fs_devices->device_list_mutex);
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
+		if (device->failed) {
+			found = 1;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	/*
+	 * We are using the replace code which should be interrupt-able
+	 * during unmount, and as of now there is no user land stop
+	 * request that we support
+	 */
+	if (found)
+		btrfs_auto_replace_start(root, device);
+
+out:
+	fs_info->casualty_kthread = NULL;
+	return 0;
+}
+
 static void btrfs_check_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
@@ -1924,6 +1982,10 @@ static int transaction_kthread(void *arg)
 		}
 sleep:
 		btrfs_check_devices(root->fs_info->fs_devices);
+		if (!root->fs_info->casualty_kthread)
+			root->fs_info->casualty_kthread =
+				kthread_run(casualty_kthread, root,
+							"btrfs-casualty");
 
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
@@ -3159,6 +3221,9 @@ fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 	btrfs_cleanup_transaction(fs_info->tree_root);
 	btrfs_free_fs_roots(fs_info);
+	if (fs_info->casualty_kthread)
+		kthread_stop(fs_info->casualty_kthread);
+
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3807,6 +3872,8 @@ void close_ctree(struct btrfs_root *root)
 
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
+	if (fs_info->casualty_kthread)
+		kthread_stop(fs_info->casualty_kthread);
 
 	fs_info->closing = 2;
 	smp_mb();
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 76354bb..ef4aaf5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2187,7 +2187,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
 	if (current != root->fs_info->transaction_kthread &&
-	    current != root->fs_info->cleaner_kthread)
+	    current != root->fs_info->cleaner_kthread &&
+	    current != root->fs_info->casualty_kthread)
 		btrfs_run_delayed_iputs(root);
 
 	return ret;
-- 
2.4.1

