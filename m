Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DB6C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFDB214FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sbZljqwc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAFDB214FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeJJHa0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeJJHa0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08wZ2138901;
        Wed, 10 Oct 2018 00:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Q7WRM8cm5WCpI5pToKQWHyNcuRIx4G5Ru2lJk9SDSnU=;
 b=sbZljqwctBNHKocMq4GyabetJ7oLp3SXgUT4wD8hRMNEvuCJQdSGlayZdRSpM2PK8nKh
 nleTKcfhSJeTUw7dAsiIq2UFPoLiouVuRmU0p1J1jeEa/wTdrtMkdt53HbOgmT2d9LN5
 8VHgeXX5knLQ+IHqs2ikwvNcxkLgYmQYhforYL1HZnOEtvhfExv7xKjAPfpDdHSI6cxJ
 sh57K0nKKKuVf9g3z6NgjLh+/+HXUqfNFnDqAOF6mQa59EDcRMOD7sGTlrYVqHqXEMFo
 PP+VtZa4mAOkRz8+CM2BpRwIWl8F4ZgUaRjc1aRwbqdsMNh9L2N9Q9X7c/j9H1rkRgbB iA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mxn0q0tfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0Atjv008509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:55 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9A0Askv020568;
        Wed, 10 Oct 2018 00:10:54 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:10:54 +0000
Subject: [PATCH 02/25] xfs: refactor clonerange preparation into a separate
 helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:10:52 -0700
Message-ID: <153913025230.32295.8365539801924505278.stgit@magnolia>
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

Refactor all the reflink preparation steps into a separate helper that
we'll use to land all the upcoming fixes for insufficient input checks.

This rework also moves the invalidation of the destination range to the
prep function so that it is done before the range is remapped.  This
ensures that nobody can access the data in range being remapped until
the remap is complete.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c |  101 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5289e22cb081..ebd65d3e31f3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1220,35 +1220,48 @@ xfs_iolock_two_inodes_and_break_layout(
 	return 0;
 }
 
+/* Unlock both inodes after they've been prepped for a range clone. */
+STATIC void
+xfs_reflink_remap_unlock(
+	struct file		*file_in,
+	struct file		*file_out)
+{
+	struct inode		*inode_in = file_inode(file_in);
+	struct xfs_inode	*src = XFS_I(inode_in);
+	struct inode		*inode_out = file_inode(file_out);
+	struct xfs_inode	*dest = XFS_I(inode_out);
+	bool			same_inode = (inode_in == inode_out);
+
+	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+	if (!same_inode)
+		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
+	inode_unlock(inode_out);
+	if (!same_inode)
+		inode_unlock_shared(inode_in);
+}
+
 /*
- * Link a range of blocks from one file to another.
+ * Prepare two files for range cloning.  Upon a successful return both inodes
+ * will have the iolock and mmaplock held, the page cache of the out file
+ * will be truncated, and any leases on the out file will have been broken.
+ * Returns negative for error, 0 for nothing to do, and 1 for success.
  */
-int
-xfs_reflink_remap_range(
+STATIC int
+xfs_reflink_remap_prep(
 	struct file		*file_in,
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			len,
+	u64			*len,
 	bool			is_dedupe)
 {
 	struct inode		*inode_in = file_inode(file_in);
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
-	struct xfs_mount	*mp = src->i_mount;
 	bool			same_inode = (inode_in == inode_out);
-	xfs_fileoff_t		sfsbno, dfsbno;
-	xfs_filblks_t		fsblen;
-	xfs_extlen_t		cowextsize;
 	ssize_t			ret;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return -EOPNOTSUPP;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
 	/* Lock both files against IO */
 	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
 	if (ret)
@@ -1270,7 +1283,7 @@ xfs_reflink_remap_range(
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
-			&len, is_dedupe);
+			len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1279,8 +1292,6 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
-
 	/*
 	 * Clear out post-eof preallocations because we don't have page cache
 	 * backing the delayed allocations and they'll never get freed on
@@ -1297,6 +1308,51 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
+	/* Zap any page cache for the destination file's range. */
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + *len) - 1);
+	return 1;
+out_unlock:
+	xfs_reflink_remap_unlock(file_in, file_out);
+	return ret;
+}
+
+/*
+ * Link a range of blocks from one file to another.
+ */
+int
+xfs_reflink_remap_range(
+	struct file		*file_in,
+	loff_t			pos_in,
+	struct file		*file_out,
+	loff_t			pos_out,
+	u64			len,
+	bool			is_dedupe)
+{
+	struct inode		*inode_in = file_inode(file_in);
+	struct xfs_inode	*src = XFS_I(inode_in);
+	struct inode		*inode_out = file_inode(file_out);
+	struct xfs_inode	*dest = XFS_I(inode_out);
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		sfsbno, dfsbno;
+	xfs_filblks_t		fsblen;
+	xfs_extlen_t		cowextsize;
+	ssize_t			ret;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	/* Prepare and then clone file data. */
+	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
+			&len, is_dedupe);
+	if (ret <= 0)
+		return ret;
+
+	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
+
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
@@ -1305,10 +1361,6 @@ xfs_reflink_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
-
 	/*
 	 * Carry the cowextsize hint from src to dest if we're sharing the
 	 * entire source file to the entire destination file, the source file
@@ -1325,12 +1377,7 @@ xfs_reflink_remap_range(
 			is_dedupe);
 
 out_unlock:
-	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-	if (!same_inode)
-		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
-	inode_unlock(inode_out);
-	if (!same_inode)
-		inode_unlock_shared(inode_in);
+	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return ret;

