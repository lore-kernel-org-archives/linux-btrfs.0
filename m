Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37293 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbeAVFvL (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 22 Jan 2018 00:51:11 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
Subject: [PATCH v2] btrfs: Add chunk allocation ENOSPC debug message for enospc_debug mount option
Date: Mon, 22 Jan 2018 13:50:54 +0800
Message-Id: <20180122055054.7933-1-wqu@suse.com>
In-Reply-To: <20180115061352.13799-1-wqu@suse.com>
References: <20180115061352.13799-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enospc_debug makes extent allocator to print more debug messages,
however for chunk allocation, there is no debug message for enospc_debug
at all.

This patch will add message for the following parts of chunk allocator:

1) No rw device at all
   Quite rare, but at least output one message for this case.

2) No enough space for some device
   This debug message is quite handy for unbalanced disks with stripe
   based profiles (RAID0/10/5/6).

3) Not enough free devices
   This debug message should tell us if current chunk allocator is
   working correctly on minimal device requirement.

Although under most case, we will hit other ENOSPC before we even hit a
chunk allocator ENOSPC, but such debug info won't help.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Unify all message level to btrfs_debug().
  More meaningful message if we don't have enough device.
---
 fs/btrfs/volumes.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a25684287501..86cae6a15b1e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4622,8 +4622,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!alloc_profile_is_valid(type, 0));
 
-	if (list_empty(&fs_devices->alloc_list))
+	if (list_empty(&fs_devices->alloc_list)) {
+		if (btrfs_test_opt(info, ENOSPC_DEBUG))
+			btrfs_debug(info, "%s: No writable device", __func__);
 		return -ENOSPC;
+	}
 
 	index = __get_raid_index(type);
 
@@ -4705,8 +4708,14 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		if (ret == 0)
 			max_avail = max_stripe_size * dev_stripes;
 
-		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
+		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes) {
+			if (btrfs_test_opt(info, ENOSPC_DEBUG))
+				btrfs_debug(info,
+			"%s: devid %llu has no free space, have=%llu want=%u",
+					    __func__, device->devid, max_avail,
+					    BTRFS_STRIPE_LEN * dev_stripes);
 			continue;
+		}
 
 		if (ndevs == fs_devices->rw_devices) {
 			WARN(1, "%s: found more than %llu devices\n",
@@ -4731,6 +4740,12 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
 		ret = -ENOSPC;
+		if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
+			btrfs_debug(info,
+		"%s: not enough devices with free space: have=%d minimal required=%d",
+				    __func__, ndevs, min(devs_min,
+				    devs_increment * sub_stripes));
+		}
 		goto error;
 	}
 
-- 
2.15.1

