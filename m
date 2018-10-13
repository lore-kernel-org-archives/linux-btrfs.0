Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89135C71122
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4524A20895
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gt4rhDPi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4524A20895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbeJMHmA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:42:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeJMHmA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:42:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D04b58163357;
        Sat, 13 Oct 2018 00:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LYjJXc/Xz2cQPU4uS6RQK8uH5X4STYpNRAht3hCzCyg=;
 b=gt4rhDPiV6Zv6EkHwsalthzAuLcjRve84KmHXigLiCGSCA7mBx9jdfnnBn3kXEFlC11/
 7R2h+SZHHfrsjpFJxxTVqSPbLYUC+CGlDQ8buEKGeQremeM0Dih21aQa2OfL+stQwAQ+
 3cyi0ddumtapC7+gvcZViKcBEPPNKe/15ByJPNcUd7wsQNl5IOQNuN50x3JcEerD+TjI
 rKhnNLEug4a3ZcuX1iqPWlDWCrQHk3KDbSq0oRCB1rOk+fe97D8st/IbgpT2ELFmoFt4
 nKLbIlc2KuSkbsck4UAyMIwZ1Q2O7t+9on7+dps6+ulBfPrdo0s43lVUEoORqKdZRCHU 2Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0qnmf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:06 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9D070Rl003509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:00 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9D070tY019573;
        Sat, 13 Oct 2018 00:07:00 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:07:00 +0000
Subject: [PATCH 11/25] vfs: pass remap flags to generic_remap_file_range_prep
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:06:58 -0700
Message-ID: <153938921860.8361.1983470639945895613.stgit@magnolia>
In-Reply-To: <153938912912.8361.13446310416406388958.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9044 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810130000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb the remap flags through the filesystem from the vfs function
dispatcher all the way to the prep function to prepare for behavior
changes in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ocfs2/file.c         |    2 +-
 fs/ocfs2/refcounttree.c |    6 +++---
 fs/ocfs2/refcounttree.h |    2 +-
 fs/read_write.c         |   10 ++++++----
 fs/xfs/xfs_file.c       |    2 +-
 fs/xfs/xfs_reflink.c    |   16 +++++++++-------
 fs/xfs/xfs_reflink.h    |    3 ++-
 include/linux/fs.h      |    5 +++--
 8 files changed, 26 insertions(+), 20 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 852cdfaadd89..53c8676a0daf 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2538,7 +2538,7 @@ static int ocfs2_remap_file_range(struct file *file_in,
 		return -EINVAL;
 
 	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					 len, remap_flags & RFR_SAME_DATA);
+					 len, remap_flags);
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ee1ed11379b3..270a5b1919f6 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4825,7 +4825,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 			      struct file *file_out,
 			      loff_t pos_out,
 			      u64 len,
-			      bool is_dedupe)
+			      unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -4851,7 +4851,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe);
+			&len, remap_flags);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -4859,7 +4859,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	 * Update inode timestamps and remove security privileges before we
 	 * take the ilock.
 	 */
-	ret = generic_remap_file_range_touch(file_out, is_dedupe);
+	ret = generic_remap_file_range_touch(file_out, remap_flags);
 	if (ret)
 		goto out_unlock;
 
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 4af55bf4b35b..d2c5f526edff 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -120,6 +120,6 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 			      struct file *file_out,
 			      loff_t pos_out,
 			      u64 len,
-			      bool is_dedupe);
+			      unsigned int remap_flags);
 
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/read_write.c b/fs/read_write.c
index 7b837d12f75d..5d24e9854765 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1712,18 +1712,20 @@ static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
  * sense, and then flush all dirty data.  Caller must ensure that the
- * inodes have been locked against any other modifications.
+ * inodes have been locked against any other modifications.  This function
+ * takes RFR_* flags in remap_flags.
  *
  * Returns: 0 for "nothing to clone", 1 for "something to clone", or
  * the usual negative error code.
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  u64 *len, bool is_dedupe)
+				  u64 *len, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	u64 blkmask = i_blocksize(inode_in) - 1;
+	bool is_dedupe = (remap_flags & RFR_SAME_DATA);
 	bool same_inode = (inode_in == inode_out);
 	int ret;
 
@@ -1807,12 +1809,12 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 /* Update inode timestamps and remove security privileges when remapping. */
-int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
+int generic_remap_file_range_touch(struct file *file, unsigned int remap_flags)
 {
 	int ret;
 
 	/* If can't alter the file contents, we're done. */
-	if (is_dedupe)
+	if (remap_flags & RFR_SAME_DATA)
 		return 0;
 
 	/* Update the timestamps, since we can alter file contents. */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7cce438f856a..dce01729e522 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -932,7 +932,7 @@ xfs_file_remap_range(
 		return -EINVAL;
 
 	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-			len, remap_flags & RFR_SAME_DATA);
+			len, remap_flags);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 99f2ea4fcaba..ada3b80267c6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -921,10 +921,11 @@ xfs_reflink_update_dest(
 	struct xfs_inode	*dest,
 	xfs_off_t		newlen,
 	xfs_extlen_t		cowextsize,
-	bool			is_dedupe)
+	unsigned int		remap_flags)
 {
 	struct xfs_mount	*mp = dest->i_mount;
 	struct xfs_trans	*tp;
+	bool			is_dedupe = (remap_flags & RFR_SAME_DATA);
 	int			error;
 
 	if (is_dedupe && newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
@@ -1296,13 +1297,14 @@ xfs_reflink_remap_prep(
 	struct file		*file_out,
 	loff_t			pos_out,
 	u64			*len,
-	bool			is_dedupe)
+	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
+	bool			is_dedupe = (remap_flags & RFR_SAME_DATA);
 	u64			blkmask = i_blocksize(inode_in) - 1;
 	ssize_t			ret;
 
@@ -1327,7 +1329,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, is_dedupe);
+			len, remap_flags);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1375,7 +1377,7 @@ xfs_reflink_remap_prep(
 	 * Update inode timestamps and remove security privileges before we
 	 * take the ilock.
 	 */
-	ret = generic_remap_file_range_touch(file_out, is_dedupe);
+	ret = generic_remap_file_range_touch(file_out, remap_flags);
 	if (ret)
 		goto out_unlock;
 
@@ -1395,7 +1397,7 @@ xfs_reflink_remap_range(
 	struct file		*file_out,
 	loff_t			pos_out,
 	u64			len,
-	bool			is_dedupe)
+	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
@@ -1415,7 +1417,7 @@ xfs_reflink_remap_range(
 
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe);
+			&len, remap_flags);
 	if (ret <= 0)
 		return ret;
 
@@ -1442,7 +1444,7 @@ xfs_reflink_remap_range(
 		cowextsize = src->i_d.di_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
-			is_dedupe);
+			remap_flags);
 
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c585ad9552b2..6f82d628bf17 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,7 +28,8 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
+		struct file *file_out, loff_t pos_out, u64 len,
+		unsigned int remap_flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
 		struct xfs_inode *ip, bool *has_shared);
 extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 91fd3c77763b..b67f108932a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1846,8 +1846,9 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
-					 u64 *count, bool is_dedupe);
-extern int generic_remap_file_range_touch(struct file *file, bool is_dedupe);
+					 u64 *count, unsigned int remap_flags);
+extern int generic_remap_file_range_touch(struct file *file,
+					  unsigned int remap_flags);
 extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,

