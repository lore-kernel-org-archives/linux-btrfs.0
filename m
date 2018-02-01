Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52352 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755903AbeBABL6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 20:11:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1112I9W190438
        for <linux-btrfs@vger.kernel.org>; Thu, 1 Feb 2018 01:11:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fuqkfr7n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 01:11:57 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w111Bv9J029299
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 1 Feb 2018 01:11:57 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w111Buj5019862
        for <linux-btrfs@vger.kernel.org>; Thu, 1 Feb 2018 01:11:57 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix unexpected cow in run_delalloc_nocow
Date: Wed, 31 Jan 2018 17:09:13 -0700
Message-Id: <20180201000913.27378-1-bo.li.liu@oracle.com>
In-Reply-To: <20180125180256.10844-2-bo.li.liu@oracle.com>
References: <20180125180256.10844-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fstests generic/475 provides a way to fail metadata reads while
checking if checksum exists for the inode inside run_delalloc_nocow(),
and csum_exist_in_range() interprets error (-EIO) as inode having
checksum and makes its caller enters the cow path.

In case of free space inode, this ends up with a warning in
cow_file_range().

The same problem applies for btrfs_cross_ref_exist() since it may also
read metadata in between.

With this, run_delalloc_nocow() bails out when errors occur at the two
places.

cc: <stable@vger.kernel.org> v2.6.28+
Fixes: 17d217fe970d ("Btrfs: fix nodatasum handling in balancing code")
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix error handling after btrfs_cross_ref_exist().

 fs/btrfs/inode.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3c..8f2bd04 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1257,6 +1257,8 @@ static noinline int csum_exist_in_range(struct btrfs_fs_info *fs_info,
 		list_del(&sums->list);
 		kfree(sums);
 	}
+	if (ret < 0)
+		return ret;
 	return 1;
 }
 
@@ -1386,10 +1388,23 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 				goto out_check;
 			if (btrfs_extent_readonly(fs_info, disk_bytenr))
 				goto out_check;
-			if (btrfs_cross_ref_exist(root, ino,
-						  found_key.offset -
-						  extent_offset, disk_bytenr))
+			ret = btrfs_cross_ref_exist(root, ino,
+						    found_key.offset -
+						    extent_offset, disk_bytenr);
+			if (ret) {
+				/*
+				 * ret could be -EIO if the above fails to read
+				 * metadata.
+				 */
+				if (ret < 0) {
+					if (cow_start != (u64)-1)
+						cur_offset = cow_start;
+					goto error;
+				}
+
+				WARN_ON_ONCE(nolock);
 				goto out_check;
+			}
 			disk_bytenr += extent_offset;
 			disk_bytenr += cur_offset - found_key.offset;
 			num_bytes = min(end + 1, extent_end) - cur_offset;
@@ -1407,10 +1422,22 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			 * this ensure that csum for a given extent are
 			 * either valid or do not exist.
 			 */
-			if (csum_exist_in_range(fs_info, disk_bytenr,
-						num_bytes)) {
+			ret = csum_exist_in_range(fs_info, disk_bytenr,
+						  num_bytes);
+			if (ret) {
 				if (!nolock)
 					btrfs_end_write_no_snapshotting(root);
+
+				/*
+				 * ret could be -EIO if the above fails to read
+				 * metadata.
+				 */
+				if (ret < 0) {
+					if (cow_start != (u64)-1)
+						cur_offset = cow_start;
+					goto error;
+				}
+				WARN_ON_ONCE(nolock);
 				goto out_check;
 			}
 			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
-- 
2.9.4

