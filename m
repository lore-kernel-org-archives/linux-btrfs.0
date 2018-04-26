Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753748AbeDZH7T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 03:59:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3Q7p8VZ100476
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 07:59:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hfvrc1yes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 07:59:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3Q7xITI017337
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 07:59:18 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3Q7xHeT025465
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 07:59:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: improve balance kernel logs
Date: Thu, 26 Apr 2018 16:01:28 +0800
Message-Id: <20180426080129.3270-2-anand.jain@oracle.com>
In-Reply-To: <20180426080129.3270-1-anand.jain@oracle.com>
References: <20180426080129.3270-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel logs are very important for the forensic investigations of the
issues in general. This patch adds 'balance:' prefix so that it can be
easily be searched and uses the block group names instead of its bitmap.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 14efa98b7183..e688c993197f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3805,7 +3805,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
 			btrfs_err(fs_info,
-				  "with mixed groups data and metadata balance options must be the same");
+				  "balance: mixed groups data and metadata options must be the same");
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3827,23 +3827,26 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		allowed |= (BTRFS_BLOCK_GROUP_RAID10 |
 			    BTRFS_BLOCK_GROUP_RAID6);
 	if (validate_convert_profile(&bctl->data, allowed)) {
+		int index = btrfs_bg_flags_to_raid_index(bctl->data.target);
 		btrfs_err(fs_info,
-			  "unable to start balance with target data profile %llu",
-			  bctl->data.target);
+			  "balance: invalid convert data profile %s",
+			  get_raid_name(index));
 		ret = -EINVAL;
 		goto out;
 	}
 	if (validate_convert_profile(&bctl->meta, allowed)) {
+		int index = btrfs_bg_flags_to_raid_index(bctl->meta.target);
 		btrfs_err(fs_info,
-			  "unable to start balance with target metadata profile %llu",
-			  bctl->meta.target);
+			  "balance: invalid convert metadata profile %s",
+			  get_raid_name(index));
 		ret = -EINVAL;
 		goto out;
 	}
 	if (validate_convert_profile(&bctl->sys, allowed)) {
+		int index = btrfs_bg_flags_to_raid_index(bctl->sys.target);
 		btrfs_err(fs_info,
-			  "unable to start balance with target system profile %llu",
-			  bctl->sys.target);
+			  "balance: invalid convert system profile %s",
+			  get_raid_name(index));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3864,10 +3867,10 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		     !(bctl->meta.target & allowed))) {
 			if (bctl->flags & BTRFS_BALANCE_FORCE) {
 				btrfs_info(fs_info,
-					   "force reducing metadata integrity");
+					   "balance: force reducing metadata integrity");
 			} else {
 				btrfs_err(fs_info,
-					  "balance will reduce metadata integrity, use force if you want this");
+					  "balance: reduces metadata integrity, use force if you want this");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -3881,9 +3884,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		bctl->data.target : fs_info->avail_data_alloc_bits;
 	if (btrfs_get_num_tolerated_disk_barrier_failures(meta_target) <
 		btrfs_get_num_tolerated_disk_barrier_failures(data_target)) {
+		int meta_index = btrfs_bg_flags_to_raid_index(meta_target);
+		int data_index = btrfs_bg_flags_to_raid_index(data_target);
 		btrfs_warn(fs_info,
-			   "metadata profile 0x%llx has lower redundancy than data profile 0x%llx",
-			   meta_target, data_target);
+			   "balance: metadata profile %s has lower redundancy than data profile %s",
+			   get_raid_name(meta_index), get_raid_name(data_index));
 	}
 
 	ret = insert_balance_item(fs_info, bctl);
@@ -3943,7 +3948,7 @@ static int balance_kthread(void *data)
 
 	mutex_lock(&fs_info->balance_mutex);
 	if (fs_info->balance_ctl) {
-		btrfs_info(fs_info, "continuing balance");
+		btrfs_info(fs_info, "balance: resuming");
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 	mutex_unlock(&fs_info->balance_mutex);
@@ -3963,7 +3968,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 	mutex_unlock(&fs_info->balance_mutex);
 
 	if (btrfs_test_opt(fs_info, SKIP_BALANCE)) {
-		btrfs_info(fs_info, "force skipping balance");
+		btrfs_info(fs_info, "balance: resume skipped");
 		return 0;
 	}
 
@@ -4032,7 +4037,7 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	 */
 	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
 		btrfs_warn(fs_info,
-	"cannot set exclusive op status to balance, resume manually");
+	"balance: cannot set exclusive op status, resume manually");
 
 	mutex_lock(&fs_info->balance_mutex);
 	BUG_ON(fs_info->balance_ctl);
@@ -4111,6 +4116,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 		if (fs_info->balance_ctl) {
 			reset_balance_state(fs_info);
 			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
+			btrfs_info(fs_info, "balance: canceled");
 		}
 	}
 
-- 
2.7.0

