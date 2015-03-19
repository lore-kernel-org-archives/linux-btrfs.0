Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbbCSGE7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:59 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/7] Btrfs: qgroup: update quota numbers in btrfs_qgroup_inherit.
Date: Thu, 19 Mar 2015 14:01:02 +0800
Message-ID: <1426744864-7031-10-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original, the all quota numbers are stored in data_info, but
now, we store them separately in data_info and metadata_info.
Then, when we create a snapshot and update the quota number,
we need to update both of the data_info and metadata_info.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 57 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5df8527..9363fd0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2525,34 +2525,57 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		srcgroup = find_qgroup_rb(fs_info, srcid);
 		if (!srcgroup)
 			goto unlock;
-		/*
-		 * FIXME: use the data_info to store all information currently.
-		 * will seperate the information into data and metadata later.
-		 **/
 		dstinfo = &dstgroup->data_info;
 		srcinfo = &srcgroup->data_info;
 
-		/*
-		 * We call inherit after we clone the root in order to make sure
-		 * our counts don't go crazy, so at this point the only
-		 * difference between the two roots should be the root node.
-		 */
-		dstinfo->rfer = srcinfo->rfer;
-		dstinfo->rfer_cmpr = srcinfo->rfer_cmpr;
-		dstinfo->excl = level_size;
-		dstinfo->excl_cmpr = level_size;
-		srcinfo->excl = level_size;
-		srcinfo->excl_cmpr = level_size;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			/*
+			 * We call inherit after we clone the root in order to make sure
+			 * our counts don't go crazy, so at this point the only
+			 * difference between the two roots should be the root node.
+			 */
+			dstinfo->rfer = srcinfo->rfer;
+			dstinfo->rfer_cmpr = srcinfo->rfer_cmpr;
+			dstinfo->excl = level_size;
+			dstinfo->excl_cmpr = level_size;
+			srcinfo->excl = level_size;
+			srcinfo->excl_cmpr = level_size;
+		} else {
+			dstinfo->rfer = srcinfo->rfer;
+			dstinfo->rfer_cmpr = srcinfo->rfer_cmpr;
+			/*
+			 * add the metadata for dstqgroup.
+			 */
+			dstinfo = &dstgroup->metadata_info;
+			dstinfo->rfer = level_size;
+			dstinfo->rfer_cmpr = level_size;
+			dstinfo->excl = level_size;
+			dstinfo->excl_cmpr = level_size;
+			srcinfo->excl = 0;
+			srcinfo->excl_cmpr = 0;
+		}
 
-		dstlimits = &dstgroup->mixed_limits;
-		srclimits = &srcgroup->mixed_limits;
+		if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+			dstlimits = &dstgroup->mixed_limits;
+			srclimits = &srcgroup->mixed_limits;
+		} else {
+			dstlimits = &dstgroup->data_limits;
+			srclimits = &srcgroup->data_limits;
+		}
 		/* inherit the limit info */
+again:
 		dstlimits->lim_flags = srclimits->lim_flags;
 		dstlimits->max_rfer = srclimits->max_rfer;
 		dstlimits->max_excl = srclimits->max_excl;
 		dstlimits->rsv_rfer = srclimits->rsv_rfer;
 		dstlimits->rsv_excl = srclimits->rsv_excl;
 
+		if (dstlimits != &dstgroup->mixed_limits) {
+			dstlimits++;
+			srclimits++;
+			goto again;
+		}
+
 		qgroup_dirty(fs_info, dstgroup);
 		qgroup_dirty(fs_info, srcgroup);
 	}
-- 
1.8.4.2

