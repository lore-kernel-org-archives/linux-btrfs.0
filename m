Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49705 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933841AbcKNTGg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:06:36 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAEJ4NWr028058
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:06:35 -0800
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 26qjtr8445-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:06:35 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 2/2] Btrfs: abort transaction if fill_holes() fails
Date: Mon, 14 Nov 2016 14:06:22 -0500
Message-ID: <1479150382-19273-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1479150382-19273-1-git-send-email-jbacik@fb.com>
References: <1479150382-19273-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At this point we will have dropped extent entries from the file, so if we fail
to insert the new hole entries then we are leaving the fs in a corrupt state
(albeit an easily fixed one).  Abort the transaciton if this happens so we can
avoid corrupting the fs.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/file.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1c15a98..d6fc719 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2234,9 +2234,14 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	key.offset = offset;
 
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
-	if (ret < 0)
+	if (ret <= 0) {
+		/* We should have dropped this offset, so if we find it then
+		 * something has gone horribly wrong.
+		 */
+		if (ret == 0)
+			ret = -EINVAL;
 		return ret;
-	BUG_ON(!ret);
+	}
 
 	leaf = path->nodes[0];
 	if (hole_mergeable(inode, leaf, path->slots[0]-1, offset, end)) {
@@ -2539,6 +2544,12 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			ret = fill_holes(trans, inode, path, cur_offset,
 					 drop_end);
 			if (ret) {
+				/* If we failed then we didn't insert our hole
+				 * entries for the area we dropped, so now the
+				 * fs is corrupted, so we must abort the
+				 * transaction.
+				 */
+				btrfs_abort_transaction(trans, ret);
 				err = ret;
 				break;
 			}
@@ -2603,6 +2614,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (cur_offset < ino_size && cur_offset < drop_end) {
 		ret = fill_holes(trans, inode, path, cur_offset, drop_end);
 		if (ret) {
+			/* Same comment as above. */
+			btrfs_abort_transaction(trans, ret);
 			err = ret;
 			goto out_trans;
 		}
-- 
2.7.4

