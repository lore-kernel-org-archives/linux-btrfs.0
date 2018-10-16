Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBE1C04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 044322083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nsTiqJYf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 044322083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbeJPLJB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:09:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbeJPLJA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:09:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3JgPx051754;
        Tue, 16 Oct 2018 03:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6J/QYq4s6QFaJLMu3nSz4IUXRy/yndbu5A+K+2UxqS4=;
 b=nsTiqJYf8DbHsWPFpINf1TvJ9AQitIAf/Pag+2v7bqSahknDyTk+C4DfY8GMcgbhDrqP
 xn7/6aO6Q9SS5MWKdkIFM7qPIKSS8GKZDET+ITq6sNt4tCL3T1NDkTgsYGez67KDWtlv
 MuhtSriyDv44prRbIBEF5bTsbyZEYI3wHDdsJq9MygcwV+peMOEpZ6rM6Dx9jEtkmOB1
 bdSB4NeE7AISCEdppBceCnV5jA2Yd7nW1TcV1fTQMR6tPoyCyyUDTv0i5z8zBRucZKq/
 q7HWfMLazG05qaMnZIpVihkd5aqxfWi5dDx5gymgbSVIGA4HE/1fiRNj231CE9Vp304l PQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2n384tx2a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KblU005285
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:37 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KaG5012678;
        Tue, 16 Oct 2018 03:20:36 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:20:36 -0700
Subject: [PATCH 22/26] ocfs2: support partial clone range and dedupe range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:20:34 -0700
Message-ID: <153966003484.3607.3682046712485244493.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the ocfs2 remap code to allow for returning partial results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/file.c         |    7 +----
 fs/ocfs2/refcounttree.c |   72 +++++++++++++++++++++++++----------------------
 fs/ocfs2/refcounttree.h |   12 ++++----
 3 files changed, 46 insertions(+), 45 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index fbaeafe44b5f..8125c5ccf821 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2531,14 +2531,11 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 				     struct file *file_out, loff_t pos_out,
 				     loff_t len, unsigned int remap_flags)
 {
-	int ret;
-
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					len, remap_flags);
-	return ret < 0 ? ret : len;
+	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, remap_flags);
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7c709229e108..c7409578657b 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4507,14 +4507,14 @@ static int ocfs2_reflink_update_dest(struct inode *dest,
 }
 
 /* Remap the range pos_in:len in s_inode to pos_out:len in t_inode. */
-static int ocfs2_reflink_remap_extent(struct inode *s_inode,
-				      struct buffer_head *s_bh,
-				      loff_t pos_in,
-				      struct inode *t_inode,
-				      struct buffer_head *t_bh,
-				      loff_t pos_out,
-				      loff_t len,
-				      struct ocfs2_cached_dealloc_ctxt *dealloc)
+static loff_t ocfs2_reflink_remap_extent(struct inode *s_inode,
+					 struct buffer_head *s_bh,
+					 loff_t pos_in,
+					 struct inode *t_inode,
+					 struct buffer_head *t_bh,
+					 loff_t pos_out,
+					 loff_t len,
+					 struct ocfs2_cached_dealloc_ctxt *dealloc)
 {
 	struct ocfs2_extent_tree s_et;
 	struct ocfs2_extent_tree t_et;
@@ -4522,8 +4522,9 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_super *osb;
+	loff_t remapped_bytes = 0;
 	loff_t pstart, plen;
-	u32 p_cluster, num_clusters, slast, spos, tpos;
+	u32 p_cluster, num_clusters, slast, spos, tpos, remapped_clus = 0;
 	unsigned int ext_flags;
 	int ret = 0;
 
@@ -4605,30 +4606,34 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 next_loop:
 		spos += num_clusters;
 		tpos += num_clusters;
+		remapped_clus += num_clusters;
 	}
 
-out:
-	return ret;
+	goto out;
 out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
-	return ret;
+out:
+	remapped_bytes = ocfs2_clusters_to_bytes(t_inode->i_sb, remapped_clus);
+	remapped_bytes = min_t(loff_t, len, remapped_bytes);
+
+	return remapped_bytes > 0 ? remapped_bytes : ret;
 }
 
 /* Set up refcount tree and remap s_inode to t_inode. */
-static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
-				      struct buffer_head *s_bh,
-				      loff_t pos_in,
-				      struct inode *t_inode,
-				      struct buffer_head *t_bh,
-				      loff_t pos_out,
-				      loff_t len)
+static loff_t ocfs2_reflink_remap_blocks(struct inode *s_inode,
+					 struct buffer_head *s_bh,
+					 loff_t pos_in,
+					 struct inode *t_inode,
+					 struct buffer_head *t_bh,
+					 loff_t pos_out,
+					 loff_t len)
 {
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dis;
 	struct ocfs2_dinode *dit;
-	int ret;
+	loff_t ret;
 
 	osb = OCFS2_SB(s_inode->i_sb);
 	dis = (struct ocfs2_dinode *)s_bh->b_data;
@@ -4700,7 +4705,7 @@ static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
 	/* Actually remap extents now. */
 	ret = ocfs2_reflink_remap_extent(s_inode, s_bh, pos_in, t_inode, t_bh,
 					 pos_out, len, &dealloc);
-	if (ret) {
+	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -4820,18 +4825,19 @@ static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
 }
 
 /* Link a range of blocks from one file to another. */
-int ocfs2_reflink_remap_range(struct file *file_in,
-			      loff_t pos_in,
-			      struct file *file_out,
-			      loff_t pos_out,
-			      loff_t len,
-			      unsigned int remap_flags)
+loff_t ocfs2_reflink_remap_range(struct file *file_in,
+				 loff_t pos_in,
+				 struct file *file_out,
+				 loff_t pos_out,
+				 loff_t len,
+				 unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct ocfs2_super *osb = OCFS2_SB(inode_in->i_sb);
 	struct buffer_head *in_bh = NULL, *out_bh = NULL;
 	bool same_inode = (inode_in == inode_out);
+	loff_t remapped = 0;
 	ssize_t ret;
 
 	if (!ocfs2_refcount_tree(osb))
@@ -4866,12 +4872,13 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 				   round_down(pos_out, PAGE_SIZE),
 				   round_up(pos_out + len, PAGE_SIZE) - 1);
 
-	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
-					 out_bh, pos_out, len);
+	remapped = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in,
+			inode_out, out_bh, pos_out, len);
 	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
 		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
-	if (ret) {
+	if (remapped < 0) {
+		ret = remapped;
 		mlog_errno(ret);
 		goto out_unlock;
 	}
@@ -4889,10 +4896,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		goto out_unlock;
 	}
 
-	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
-	return 0;
-
 out_unlock:
 	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
-	return ret;
+	return remapped > 0 ? remapped : ret;
 }
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index eb65c1d0843c..9e64daba395d 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -115,11 +115,11 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 			const char __user *oldname,
 			const char __user *newname,
 			bool preserve);
-int ocfs2_reflink_remap_range(struct file *file_in,
-			      loff_t pos_in,
-			      struct file *file_out,
-			      loff_t pos_out,
-			      loff_t len,
-			      unsigned int remap_flags);
+loff_t ocfs2_reflink_remap_range(struct file *file_in,
+				 loff_t pos_in,
+				 struct file *file_out,
+				 loff_t pos_out,
+				 loff_t len,
+				 unsigned int remap_flags);
 
 #endif /* OCFS2_REFCOUNTTREE_H */

