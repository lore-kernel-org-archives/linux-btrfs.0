Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbeD3JrI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 05:47:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3U9k20m127822
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:47:07 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hmgxfkcr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:47:07 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3U9l6eo030328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:47:06 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3U9l6R9000324
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:47:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: rename btrfs_balance_control::flags to b_flags
Date: Mon, 30 Apr 2018 17:49:13 +0800
Message-Id: <20180430094913.26309-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As flags is a generic name, its often difficult to search, rename
btrfs_balance_control::flags to btrfs_balance_control::b_flags.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c   | 10 +++++-----
 fs/btrfs/volumes.c | 30 +++++++++++++++---------------
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e1dedc78d1ad..dbfb6d691275 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4310,7 +4310,7 @@ void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 
-	bargs->flags = bctl->flags;
+	bargs->flags = bctl->b_flags;
 
 	if (test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags))
 		bargs->state |= BTRFS_BALANCE_STATE_RUNNING;
@@ -4408,7 +4408,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 
 			bctl = fs_info->balance_ctl;
 			spin_lock(&fs_info->balance_lock);
-			bctl->flags |= BTRFS_BALANCE_RESUME;
+			bctl->b_flags |= BTRFS_BALANCE_RESUME;
 			spin_unlock(&fs_info->balance_lock);
 
 			goto do_balance;
@@ -4434,13 +4434,13 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		memcpy(&bctl->meta, &bargs->meta, sizeof(bctl->meta));
 		memcpy(&bctl->sys, &bargs->sys, sizeof(bctl->sys));
 
-		bctl->flags = bargs->flags;
+		bctl->b_flags = bargs->flags;
 	} else {
 		/* balance everything - no filters */
-		bctl->flags |= BTRFS_BALANCE_TYPE_MASK;
+		bctl->b_flags |= BTRFS_BALANCE_TYPE_MASK;
 	}
 
-	if (bctl->flags & ~(BTRFS_BALANCE_ARGS_MASK | BTRFS_BALANCE_TYPE_MASK)) {
+	if (bctl->b_flags & ~(BTRFS_BALANCE_ARGS_MASK | BTRFS_BALANCE_TYPE_MASK)) {
 		ret = -EINVAL;
 		goto out_bctl;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 64bcaf25908b..1326e8e5fc88 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3136,7 +3136,7 @@ static int insert_balance_item(struct btrfs_fs_info *fs_info,
 	btrfs_cpu_balance_args_to_disk(&disk_bargs, &bctl->sys);
 	btrfs_set_balance_sys(leaf, item, &disk_bargs);
 
-	btrfs_set_balance_flags(leaf, item, bctl->flags);
+	btrfs_set_balance_flags(leaf, item, bctl->b_flags);
 
 	btrfs_mark_buffer_dirty(leaf);
 out:
@@ -3435,7 +3435,7 @@ static int should_balance_chunk(struct btrfs_fs_info *fs_info,
 
 	/* type filter */
 	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
-	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
+	      (bctl->b_flags & BTRFS_BALANCE_TYPE_MASK))) {
 		return 0;
 	}
 
@@ -3872,27 +3872,27 @@ static void print_balance_start_or_resume(struct btrfs_fs_info *fs_info)
 		return;
 	}
 
-	if (bctl->flags & BTRFS_BALANCE_ARGS_SOFT) {
+	if (bctl->b_flags & BTRFS_BALANCE_ARGS_SOFT) {
 		strcat(args, "soft ");
 	}
 
-	if (bctl->flags & BTRFS_BALANCE_FORCE) {
+	if (bctl->b_flags & BTRFS_BALANCE_FORCE) {
 		strcat(args, "force ");
 	}
 
-	if (bctl->flags & BTRFS_BALANCE_DATA) {
+	if (bctl->b_flags & BTRFS_BALANCE_DATA) {
 		strcat(args, "data ");
 		get_balance_args(&bctl->data, args);
 	}
 
-	if (bctl->flags & BTRFS_BALANCE_METADATA) {
+	if (bctl->b_flags & BTRFS_BALANCE_METADATA) {
 		if (strlen(args) > 0)
 			strcat(args, " ");
 		strcat(args, "metadata ");
 		get_balance_args(&bctl->meta, args);
 	}
 
-	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
+	if (bctl->b_flags & BTRFS_BALANCE_SYSTEM) {
 		if (strlen(args) > 0)
 			strcat(args, " ");
 		strcat(args, "system ");
@@ -3901,7 +3901,7 @@ static void print_balance_start_or_resume(struct btrfs_fs_info *fs_info)
 
 	BUG_ON(strlen(args) > log_size);
 	btrfs_info(fs_info, "%s %s",
-		   bctl->flags & BTRFS_BALANCE_RESUME ?\
+		   bctl->b_flags & BTRFS_BALANCE_RESUME ?\
 		   "balance: resume":"balance: start", args);
 
 	kfree(args);
@@ -3937,9 +3937,9 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	 * and identical options should be given for both of them.
 	 */
 	allowed = BTRFS_BALANCE_DATA | BTRFS_BALANCE_METADATA;
-	if (mixed && (bctl->flags & allowed)) {
-		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
-		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
+	if (mixed && (bctl->b_flags & allowed)) {
+		if (!(bctl->b_flags & BTRFS_BALANCE_DATA) ||
+		    !(bctl->b_flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
 			btrfs_err(fs_info,
 				  "balance: mixed groups data and metadata options must be the same");
@@ -4002,7 +4002,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 		     (fs_info->avail_metadata_alloc_bits & allowed) &&
 		     !(bctl->meta.target & allowed))) {
-			if (bctl->flags & BTRFS_BALANCE_FORCE) {
+			if (bctl->b_flags & BTRFS_BALANCE_FORCE) {
 				btrfs_info(fs_info,
 					   "balance: force reducing metadata integrity");
 			} else {
@@ -4032,7 +4032,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if (ret && ret != -EEXIST)
 		goto out;
 
-	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
+	if (!(bctl->b_flags & BTRFS_BALANCE_RESUME)) {
 		BUG_ON(ret == -EEXIST);
 		BUG_ON(fs_info->balance_ctl);
 		spin_lock(&fs_info->balance_lock);
@@ -4077,7 +4077,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 
 	return ret;
 out:
-	if (bctl->flags & BTRFS_BALANCE_RESUME)
+	if (bctl->b_flags & BTRFS_BALANCE_RESUME)
 		reset_balance_state(fs_info);
 	else
 		kfree(bctl);
@@ -4157,7 +4157,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
 
 	bctl->fs_info = fs_info;
-	bctl->flags = btrfs_balance_flags(leaf, item);
+	bctl->b_flags = btrfs_balance_flags(leaf, item);
 
 	btrfs_balance_data(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3a6dbbce650a..f1c2f7c96926 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -358,7 +358,7 @@ struct btrfs_balance_control {
 	struct btrfs_balance_args meta;
 	struct btrfs_balance_args sys;
 
-	u64 flags;
+	u64 b_flags;
 
 	struct btrfs_balance_progress stat;
 };
-- 
2.7.0

