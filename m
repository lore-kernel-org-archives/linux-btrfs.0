Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46599 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2L0JDu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:50 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93nww012958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:50 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93n0e003768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:49 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93nMh026288
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:49 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] Btrfs: use token to avoid times mapping extent buffer
Date: Thu, 27 Dec 2012 17:01:21 +0800
Message-Id: <1356598884-22952-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The API in tree log code has done sort of changes, and it proves that
we can benifit from using token, so do the same thing here.

function_graph tracer's timer shows that it costs nearly half time
of before(39.788us -> 22.391us).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |   63 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..c032f24 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2697,34 +2697,41 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
-	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
-	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
-	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
-	btrfs_set_inode_mode(leaf, item, inode->i_mode);
-	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
-
-	btrfs_set_timespec_sec(leaf, btrfs_inode_atime(item),
-			       inode->i_atime.tv_sec);
-	btrfs_set_timespec_nsec(leaf, btrfs_inode_atime(item),
-				inode->i_atime.tv_nsec);
-
-	btrfs_set_timespec_sec(leaf, btrfs_inode_mtime(item),
-			       inode->i_mtime.tv_sec);
-	btrfs_set_timespec_nsec(leaf, btrfs_inode_mtime(item),
-				inode->i_mtime.tv_nsec);
-
-	btrfs_set_timespec_sec(leaf, btrfs_inode_ctime(item),
-			       inode->i_ctime.tv_sec);
-	btrfs_set_timespec_nsec(leaf, btrfs_inode_ctime(item),
-				inode->i_ctime.tv_nsec);
-
-	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
-	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
-	btrfs_set_inode_sequence(leaf, item, inode->i_version);
-	btrfs_set_inode_transid(leaf, item, trans->transid);
-	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
-	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
-	btrfs_set_inode_block_group(leaf, item, 0);
+	struct btrfs_map_token token;
+
+	btrfs_init_map_token(&token);
+
+	btrfs_set_token_inode_uid(leaf, item, i_uid_read(inode), &token);
+	btrfs_set_token_inode_gid(leaf, item, i_gid_read(inode), &token);
+	btrfs_set_token_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size,
+				   &token);
+	btrfs_set_token_inode_mode(leaf, item, inode->i_mode, &token);
+	btrfs_set_token_inode_nlink(leaf, item, inode->i_nlink, &token);
+
+	btrfs_set_token_timespec_sec(leaf, btrfs_inode_atime(item),
+				     inode->i_atime.tv_sec, &token);
+	btrfs_set_token_timespec_nsec(leaf, btrfs_inode_atime(item),
+				      inode->i_atime.tv_nsec, &token);
+
+	btrfs_set_token_timespec_sec(leaf, btrfs_inode_mtime(item),
+				     inode->i_mtime.tv_sec, &token);
+	btrfs_set_token_timespec_nsec(leaf, btrfs_inode_mtime(item),
+				      inode->i_mtime.tv_nsec, &token);
+
+	btrfs_set_token_timespec_sec(leaf, btrfs_inode_ctime(item),
+				     inode->i_ctime.tv_sec, &token);
+	btrfs_set_token_timespec_nsec(leaf, btrfs_inode_ctime(item),
+				      inode->i_ctime.tv_nsec, &token);
+
+	btrfs_set_token_inode_nbytes(leaf, item, inode_get_bytes(inode),
+				     &token);
+	btrfs_set_token_inode_generation(leaf, item, BTRFS_I(inode)->generation,
+					 &token);
+	btrfs_set_token_inode_sequence(leaf, item, inode->i_version, &token);
+	btrfs_set_token_inode_transid(leaf, item, trans->transid, &token);
+	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
+	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
+	btrfs_set_token_inode_block_group(leaf, item, 0, &token);
 }
 
 /*
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-in
