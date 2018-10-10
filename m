Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5B8C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A1B8214FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kTu3TOIy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A1B8214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJJHcs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:32:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHcs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:32:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08irK119775;
        Wed, 10 Oct 2018 00:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=neB4kQpFJgnl2vzLhhe4wDul9sX90AxeByw/6GBvuH8=;
 b=kTu3TOIyPNzDLWrJ2HB1cStUwxbF5jCW2hd7eAVLBPGm253NlxZPTKmXlGMc0ujVW5m9
 RzczClO3Zrj/qfvYc0k89LoUA8xOuEaOvypP3Vyx5R/5FNTD2XAuKxBDur2skYzVyb91
 CPJ/sxVAOTSf7Rd/O6ri5qix46X9ZHVjUYTakWPoC1YC4+QyHSHdhpgvZLeetyz8PTds
 CeGdrx0k6UJhj+3ECh7E0ypNt5YAbhFDElYgssjfHHOHf0wHptM9OB3QgmsjU8oQwly1
 1iPJR73j3b8wwURfpPy5QXr20kFbeCmV11LwIb5p5Ap4WpB97k+CGlmtQE5JM3Mgo6Hl CQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mxmftrvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:13:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0DGan003420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:13:17 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0DG62005491;
        Wed, 10 Oct 2018 00:13:16 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:13:16 +0000
Subject: [PATCH 12/25] vfs: pass remap flags to generic_remap_file_range_prep
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:13:15 -0700
Message-ID: <153913039499.32295.9599862851836900251.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb the remap flags through the filesystem from the vfs function
dispatcher all the way to the prep function to prepare for behavior
changes in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/file.c         |    2 +-
 fs/ocfs2/refcounttree.c |    6 +++---
 fs/ocfs2/refcounttree.h |    2 +-
 fs/read_write.c         |   10 ++++++----
 fs/xfs/xfs_file.c       |    2 +-
 fs/xfs/xfs_reflink.c    |   15 ++++++++-------
 fs/xfs/xfs_reflink.h    |    3 ++-
 include/linux/fs.h      |    5 +++--
 8 files changed, 25 insertions(+), 20 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5da278edf189..ca41e69c8e68 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2535,7 +2535,7 @@ static int ocfs2_remap_file_range(struct file *file_in,
 				  unsigned int flags)
 {
 	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					 len, flags & RFR_IDENTICAL_DATA);
+					 len, flags);
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
index 020bb7fdf431..47174785a94f 100644
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
 	loff_t isize;
+	bool is_dedupe = (remap_flags & RFR_IDENTICAL_DATA);
 	bool same_inode = (inode_in == inode_out);
 	int ret;
 
@@ -1791,12 +1793,12 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 /* Update inode timestamps and remove security privileges when remapping. */
-int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
+int generic_remap_file_range_touch(struct file *file, unsigned int remap_flags)
 {
 	int ret;
 
 	/* If can't alter the file contents, we're done. */
-	if (is_dedupe)
+	if (remap_flags & RFR_IDENTICAL_DATA)
 		return 0;
 
 	/* Update the timestamps, since we can alter file contents. */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 74ad73231ea4..4c0ae1efb63f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -929,7 +929,7 @@ xfs_file_remap_range(
 	unsigned int	flags)
 {
 	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-			len, flags & RFR_IDENTICAL_DATA);
+			len, flags);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0d67b2d0b3d4..4f5e3923d9c2 100644
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
+	bool			is_dedupe = (remap_flags & RFR_IDENTICAL_DATA);
 	int			error;
 
 	if (is_dedupe && newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
@@ -1274,7 +1275,7 @@ xfs_reflink_remap_prep(
 	struct file		*file_out,
 	loff_t			pos_out,
 	u64			*len,
-	bool			is_dedupe)
+	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
@@ -1304,7 +1305,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, is_dedupe);
+			len, remap_flags);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1334,7 +1335,7 @@ xfs_reflink_remap_prep(
 	 * Update inode timestamps and remove security privileges before we
 	 * take the ilock.
 	 */
-	ret = generic_remap_file_range_touch(file_out, is_dedupe);
+	ret = generic_remap_file_range_touch(file_out, remap_flags);
 	if (ret)
 		goto out_unlock;
 
@@ -1354,7 +1355,7 @@ xfs_reflink_remap_range(
 	struct file		*file_out,
 	loff_t			pos_out,
 	u64			len,
-	bool			is_dedupe)
+	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
@@ -1374,7 +1375,7 @@ xfs_reflink_remap_range(
 
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe);
+			&len, remap_flags);
 	if (ret <= 0)
 		return ret;
 
@@ -1401,7 +1402,7 @@ xfs_reflink_remap_range(
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
index 661b9ef32d2b..0d9bdef0b4ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1832,8 +1832,9 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
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

