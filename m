Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47354 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbaAQWMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 17:12:42 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s0HMAnkZ011168
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 14:12:42 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1hf7jasg0g-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 14:12:42 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make fsync latency less sucky V2
Date: Fri, 17 Jan 2014 17:12:38 -0500
Message-ID: <1389996758-3407-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking into some performance related issues with large amounts of metadata
revealed that we can have some pretty huge swings in fsync() performance.  If we
have a lot of delayed refs backed up (as you will tend to do with lots of
metadata) fsync() will wander off and try to run some of those delayed refs
which can result in reading from disk and such.  Since the actual act of fsync()
doesn't create any delayed refs there is no need to make it throttle on delayed
ref stuff, that will be handled by other people.  With this patch we get much
smoother fsync performance with large amounts of metadata.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: fix deadlock with fsync because I thought I was brilliant by changing
btrfs_start_transaction to btrfs_join_transaction.

 fs/btrfs/file.c        | 12 ++++++++++++
 fs/btrfs/transaction.c |  3 ++-
 fs/btrfs/transaction.h |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 030012e..72df63b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1928,12 +1928,24 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (file->private_data)
 		btrfs_ioctl_trans_end(file);
 
+	/*
+	 * We use start here because we will need to wait on the IO to complete
+	 * in btrfs_sync_log, which could require joining a transaction (for
+	 * example checking cross references in the nocow path).  If we use join
+	 * here we could get into a situation where we're waiting on IO to
+	 * happen that is blocked on a transaction trying to commit.  With start
+	 * we inc the extwriter counter, so we wait for all extwriters to exit
+	 * before we start blocking join'ers.  This comment is to keep somebody
+	 * from thinking they are super smart and changing this to
+	 * btrfs_join_transaction *cough*Josef*cough*.
+	 */
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
+	trans->sync = true;
 
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
 	if (ret < 0) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index da2ac4c..b16352c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -474,6 +474,7 @@ again:
 	h->type = type;
 	h->allocating_chunk = false;
 	h->reloc_reserved = false;
+	h->sync = false;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
 	INIT_LIST_HEAD(&h->new_bgs);
 
@@ -713,7 +714,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		btrfs_create_pending_block_groups(trans, root);
 
 	trans->delayed_ref_updates = 0;
-	if (btrfs_should_throttle_delayed_refs(trans, root)) {
+	if (!trans->sync && btrfs_should_throttle_delayed_refs(trans, root)) {
 		cur = max_t(unsigned long, cur, 1);
 		trans->delayed_ref_updates = 0;
 		btrfs_run_delayed_refs(trans, root, cur);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d05b601..6ac037e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -93,6 +93,7 @@ struct btrfs_trans_handle {
 	short adding_csums;
 	bool allocating_chunk;
 	bool reloc_reserved;
+	bool sync;
 	unsigned int type;
 	/*
 	 * this root is only needed to validate that the root passed to
-- 
1.8.3.1

