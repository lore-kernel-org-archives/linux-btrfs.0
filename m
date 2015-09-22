Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32994 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbIVRCs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 13:02:48 -0400
Date: Tue, 22 Sep 2015 20:02:25 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, 00moses.alexander00@gmail.com
Subject: [PATCH v2] btrfs: cleanup btrfs_balance profile validity checks
Message-ID: <20150922200225.GA4138@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Improve readability by generalizing the profile validity checks.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
v2: Followed Dave's suggestion and renamed function to
validate_convert_profile instead of balance_relocate_invalid

 fs/btrfs/volumes.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc73586..d2b8f08 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3466,6 +3466,15 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
 
+/* Non-zero return value signifies invalidity */
+static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
+		u64 allowed)
+{
+	return ((bctl_arg->flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		(!alloc_profile_is_valid(bctl_arg->target, 1) ||
+		 (bctl_arg->target & ~allowed)));
+}
+
 /*
  * Should be called with both balance and volume mutexes held
  */
@@ -3523,27 +3532,21 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if (num_devices > 3)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID10 |
 			    BTRFS_BLOCK_GROUP_RAID6);
-	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
-	     (bctl->data.target & ~allowed))) {
+	if (validate_convert_profile(&bctl->data, allowed)) {
 		btrfs_err(fs_info, "unable to start balance with target "
 			   "data profile %llu",
 		       bctl->data.target);
 		ret = -EINVAL;
 		goto out;
 	}
-	if ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	    (!alloc_profile_is_valid(bctl->meta.target, 1) ||
-	     (bctl->meta.target & ~allowed))) {
+	if (validate_convert_profile(&bctl->meta, allowed)) {
 		btrfs_err(fs_info,
 			   "unable to start balance with target metadata profile %llu",
 		       bctl->meta.target);
 		ret = -EINVAL;
 		goto out;
 	}
-	if ((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	    (!alloc_profile_is_valid(bctl->sys.target, 1) ||
-	     (bctl->sys.target & ~allowed))) {
+	if (validate_convert_profile(&bctl->sys, allowed)) {
 		btrfs_err(fs_info,
 			   "unable to start balance with target system profile %llu",
 		       bctl->sys.target);
-- 
2.5.3

