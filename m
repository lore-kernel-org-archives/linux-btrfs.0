Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbcHOQKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 12:10:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AF855AC55
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 16:10:36 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: properly track when rescan worker is running
Message-ID: <cb4fecfa-9b40-d42c-8218-f0e7f7ac7fbb@suse.com>
Date: Mon, 15 Aug 2016 12:10:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The qgroup_flags field is overloaded such that it reflects the on-disk
status of qgroups and the runtime state.  The BTRFS_QGROUP_STATUS_FLAG_RESCAN
flag is used to indicate that a rescan operation is in progress, but if
the file system is unmounted while a rescan is running, the rescan
operation is paused.  If the file system is then mounted read-only,
the flag will still be present but the rescan operation will not have
been resumed.  When we go to umount, btrfs_qgroup_wait_for_completion
will see the flag and interpret it to mean that the rescan worker is
still running and will wait for a completion that will never come.

This patch uses a separate flag to indicate when the worker is
running.  The locking and state surrounding the qgroup rescan worker
needs a lot of attention beyond this patch but this is enough to
avoid a hung umount.

Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by; Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/qgroup.c  |    9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1771,6 +1771,7 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *qgroup_rescan_workers;
 	struct completion qgroup_rescan_completion;
 	struct btrfs_work qgroup_rescan_work;
+	bool qgroup_rescan_running;	/* protected by qgroup_rescan_lock */
 
 	/* filesystem state */
 	unsigned long fs_state;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2275,6 +2275,7 @@ static void btrfs_init_qgroup(struct btr
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
 	fs_info->qgroup_ulist = NULL;
+	fs_info->qgroup_rescan_running = false;
 	mutex_init(&fs_info->qgroup_rescan_lock);
 }
 
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2302,6 +2302,10 @@ static void btrfs_qgroup_rescan_worker(s
 	int err = -ENOMEM;
 	int ret = 0;
 
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	fs_info->qgroup_rescan_running = true;
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		goto out;
@@ -2368,6 +2372,9 @@ out:
 	}
 
 done:
+	mutex_lock(&fs_info->qgroup_rescan_lock);
+	fs_info->qgroup_rescan_running = false;
+	mutex_unlock(&fs_info->qgroup_rescan_lock);
 	complete_all(&fs_info->qgroup_rescan_completion);
 }
 
@@ -2494,7 +2501,7 @@ int btrfs_qgroup_wait_for_completion(str
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	spin_lock(&fs_info->qgroup_lock);
-	running = fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	running = fs_info->qgroup_rescan_running;
 	spin_unlock(&fs_info->qgroup_lock);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 

-- 
Jeff Mahoney
SUSE Labs
