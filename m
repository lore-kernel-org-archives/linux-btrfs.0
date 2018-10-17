Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D150CECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902F92145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XkzBMUrj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 902F92145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbeJRGow (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:44:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbeJRGov (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:44:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMhlRn048467;
        Wed, 17 Oct 2018 22:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yAZ/1PPkeVRlAU93kCg6O9O78UCd/8KO5hoqJKQC2Ek=;
 b=XkzBMUrjUQPItWcMWh9bCxGMsusGcWZH2/89KLTzbHsn0Sxox7g96r0900zUbyPluRqi
 4V6yDkCuPD9t0zjeo+g3HUPYKo+b9nLdjNdqEqFcoc1wB3gGnRi4wPiz3AihgR55YUFw
 FjMhJhBHwh+1j3eMbWbk8bjzx+qW3Lzwc0Ht42cRK1L77g/JAjl/CSPrfusqsUtEUN7W
 utWEpuJzJoOYKdzPdHw8HnoWPHMJFvI/H8goOckfpZNkj4eeE0KBldzy1l1ezB+eicR8
 pB+xDGZNSEZEimLJkNyCusI8EfqZKMNt/OC+yqyOMKljHfaMzTDi1NgkbG83Jtynsvnx KA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n38nq9t1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:46:56 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMks1r012915
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:46:55 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9HMksDh032314;
        Wed, 17 Oct 2018 22:46:54 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:46:54 -0700
Subject: [PATCH 22/29] ocfs2: remove ocfs2_reflink_remap_range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:46:53 -0700
Message-ID: <153981641295.5568.12054121625513548926.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since ocfs2_remap_file_range is a thin shell around
ocfs2_remap_remap_range, move everything from the latter into the
former.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/file.c         |   68 +++++++++++++++++++++++++++-
 fs/ocfs2/refcounttree.c |  113 +++++++----------------------------------------
 fs/ocfs2/refcounttree.h |   24 +++++++---
 3 files changed, 102 insertions(+), 103 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8125c5ccf821..fe570824b991 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2531,11 +2531,75 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 				     struct file *file_out, loff_t pos_out,
 				     loff_t len, unsigned int remap_flags)
 {
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	struct ocfs2_super *osb = OCFS2_SB(inode_in->i_sb);
+	struct buffer_head *in_bh = NULL, *out_bh = NULL;
+	bool same_inode = (inode_in == inode_out);
+	loff_t remapped = 0;
+	ssize_t ret;
+
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
+	if (!ocfs2_refcount_tree(osb))
+		return -EOPNOTSUPP;
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
 
-	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+	/* Lock both files against IO */
+	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
+	if (ret)
+		return ret;
+
+	/* Check file eligibility and prepare for block sharing. */
+	ret = -EINVAL;
+	if ((OCFS2_I(inode_in)->ip_flags & OCFS2_INODE_SYSTEM_FILE) ||
+	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
+		goto out_unlock;
+
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
+			&len, remap_flags);
+	if (ret < 0 || len == 0)
+		goto out_unlock;
+
+	/* Lock out changes to the allocation maps and remap. */
+	down_write(&OCFS2_I(inode_in)->ip_alloc_sem);
+	if (!same_inode)
+		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
+				  SINGLE_DEPTH_NESTING);
+
+	/* Zap any page cache for the destination file's range. */
+	truncate_inode_pages_range(&inode_out->i_data,
+				   round_down(pos_out, PAGE_SIZE),
+				   round_up(pos_out + len, PAGE_SIZE) - 1);
+
+	remapped = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in,
+			inode_out, out_bh, pos_out, len);
+	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
+	if (!same_inode)
+		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
+	if (remapped < 0) {
+		ret = remapped;
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	/*
+	 * Empty the extent map so that we may get the right extent
+	 * record from the disk.
+	 */
+	ocfs2_extent_map_trunc(inode_in, 0);
+	ocfs2_extent_map_trunc(inode_out, 0);
+
+	ret = ocfs2_reflink_update_dest(inode_out, out_bh, pos_out + len);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+out_unlock:
+	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
+	return remapped > 0 ? remapped : ret;
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c7409578657b..dc66b80585ec 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4468,9 +4468,9 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 }
 
 /* Update destination inode size, if necessary. */
-static int ocfs2_reflink_update_dest(struct inode *dest,
-				     struct buffer_head *d_bh,
-				     loff_t newlen)
+int ocfs2_reflink_update_dest(struct inode *dest,
+			      struct buffer_head *d_bh,
+			      loff_t newlen)
 {
 	handle_t *handle;
 	int ret;
@@ -4621,13 +4621,13 @@ static loff_t ocfs2_reflink_remap_extent(struct inode *s_inode,
 }
 
 /* Set up refcount tree and remap s_inode to t_inode. */
-static loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
-					 struct buffer_head *s_bh,
-					 loff_t pos_in,
-					 struct inode *t_inode,
-					 struct buffer_head *t_bh,
-					 loff_t pos_out,
-					 loff_t len)
+loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
+				  struct buffer_head *s_bh,
+				  loff_t pos_in,
+				  struct inode *t_inode,
+				  struct buffer_head *t_bh,
+				  loff_t pos_out,
+				  loff_t len)
 {
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_super *osb;
@@ -4720,10 +4720,10 @@ static loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
 }
 
 /* Lock an inode and grab a bh pointing to the inode. */
-static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
-				     struct buffer_head **bh1,
-				     struct inode *t_inode,
-				     struct buffer_head **bh2)
+int ocfs2_reflink_inodes_lock(struct inode *s_inode,
+			      struct buffer_head **bh1,
+			      struct inode *t_inode,
+			      struct buffer_head **bh2)
 {
 	struct inode *inode1;
 	struct inode *inode2;
@@ -4808,10 +4808,10 @@ static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
 }
 
 /* Unlock both inodes and release buffers. */
-static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
-					struct buffer_head *s_bh,
-					struct inode *t_inode,
-					struct buffer_head *t_bh)
+void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
+				 struct buffer_head *s_bh,
+				 struct inode *t_inode,
+				 struct buffer_head *t_bh)
 {
 	ocfs2_inode_unlock(s_inode, 1);
 	ocfs2_rw_unlock(s_inode, 1);
@@ -4823,80 +4823,3 @@ static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
 	}
 	unlock_two_nondirectories(s_inode, t_inode);
 }
-
-/* Link a range of blocks from one file to another. */
-loff_t ocfs2_reflink_remap_range(struct file *file_in,
-				 loff_t pos_in,
-				 struct file *file_out,
-				 loff_t pos_out,
-				 loff_t len,
-				 unsigned int remap_flags)
-{
-	struct inode *inode_in = file_inode(file_in);
-	struct inode *inode_out = file_inode(file_out);
-	struct ocfs2_super *osb = OCFS2_SB(inode_in->i_sb);
-	struct buffer_head *in_bh = NULL, *out_bh = NULL;
-	bool same_inode = (inode_in == inode_out);
-	loff_t remapped = 0;
-	ssize_t ret;
-
-	if (!ocfs2_refcount_tree(osb))
-		return -EOPNOTSUPP;
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
-
-	/* Lock both files against IO */
-	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
-	if (ret)
-		return ret;
-
-	/* Check file eligibility and prepare for block sharing. */
-	ret = -EINVAL;
-	if ((OCFS2_I(inode_in)->ip_flags & OCFS2_INODE_SYSTEM_FILE) ||
-	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
-		goto out_unlock;
-
-	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			&len, remap_flags);
-	if (ret < 0 || len == 0)
-		goto out_unlock;
-
-	/* Lock out changes to the allocation maps and remap. */
-	down_write(&OCFS2_I(inode_in)->ip_alloc_sem);
-	if (!same_inode)
-		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
-				  SINGLE_DEPTH_NESTING);
-
-	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data,
-				   round_down(pos_out, PAGE_SIZE),
-				   round_up(pos_out + len, PAGE_SIZE) - 1);
-
-	remapped = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in,
-			inode_out, out_bh, pos_out, len);
-	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
-	if (!same_inode)
-		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
-	if (remapped < 0) {
-		ret = remapped;
-		mlog_errno(ret);
-		goto out_unlock;
-	}
-
-	/*
-	 * Empty the extent map so that we may get the right extent
-	 * record from the disk.
-	 */
-	ocfs2_extent_map_trunc(inode_in, 0);
-	ocfs2_extent_map_trunc(inode_out, 0);
-
-	ret = ocfs2_reflink_update_dest(inode_out, out_bh, pos_out + len);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_unlock;
-	}
-
-out_unlock:
-	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
-	return remapped > 0 ? remapped : ret;
-}
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 9e64daba395d..e9e862be4a1e 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -115,11 +115,23 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 			const char __user *oldname,
 			const char __user *newname,
 			bool preserve);
-loff_t ocfs2_reflink_remap_range(struct file *file_in,
-				 loff_t pos_in,
-				 struct file *file_out,
-				 loff_t pos_out,
-				 loff_t len,
-				 unsigned int remap_flags);
+loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
+				  struct buffer_head *s_bh,
+				  loff_t pos_in,
+				  struct inode *t_inode,
+				  struct buffer_head *t_bh,
+				  loff_t pos_out,
+				  loff_t len);
+int ocfs2_reflink_inodes_lock(struct inode *s_inode,
+			      struct buffer_head **bh1,
+			      struct inode *t_inode,
+			      struct buffer_head **bh2);
+void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
+				 struct buffer_head *s_bh,
+				 struct inode *t_inode,
+				 struct buffer_head *t_bh);
+int ocfs2_reflink_update_dest(struct inode *dest,
+			      struct buffer_head *d_bh,
+			      loff_t newlen);
 
 #endif /* OCFS2_REFCOUNTTREE_H */

