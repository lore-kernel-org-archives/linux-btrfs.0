Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115CAC6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0AB420868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ceoQ1LPJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0AB420868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbeJMHnS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:43:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39414 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbeJMHnS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:43:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D04BYe163285;
        Sat, 13 Oct 2018 00:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hIKY9nQiwanIV2qW41QCGIkoUmtm4iR8ODVGIx3BUpQ=;
 b=ceoQ1LPJ/ELuYN8RPNeSJhGR5K+aHXwAUH9O+ILkxywvD/aett6Qy+U9mNQFOgekKpdI
 W/WBanLSyjYGmPGflshc8OvVxBQpQ9vaFTnDfQaeg25Um1YkIlmkb5X3NyhnSDCsI3MU
 dpLXz+ijILrKEE6kmzz3VZr6Q09suQGWc5PiO+1MfN7h0hOfGHk89RYB2cYV+opRyTZK
 DgGL4TtrxrCKsLiJaSBqcHGTuIjawb9H436lejtxPT4HWc572XKb9KPNI5EhwnuqFRH1
 fX8HG6kvo8j59QIPNWekPPBESygWhDnTHF04Muk/AzXKueT0nOHBJ9OBKN+4dJbS5Bbs vA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mxn0qnmj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:21 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08KJM005499
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:20 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08KtU020123;
        Sat, 13 Oct 2018 00:08:20 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:08:19 +0000
Subject: [PATCH 22/25] ocfs2: support partial clone range and dedupe range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:08:18 -0700
Message-ID: <153938929813.8361.16702022670128567518.stgit@magnolia>
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

Change the ocfs2 remap code to allow for returning partial results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/file.c         |    7 +----
 fs/ocfs2/refcounttree.c |   73 ++++++++++++++++++++++++++---------------------
 fs/ocfs2/refcounttree.h |   12 ++++----
 3 files changed, 48 insertions(+), 44 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e6ffed70398e..061ae2c4bd4a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2531,14 +2531,11 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 				     struct file *file_out, loff_t pos_out,
 				     loff_t len, unsigned int remap_flags)
 {
-	int ret;
-
 	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
 		return -EINVAL;
 
-	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					len, remap_flags);
-	return ret < 0 ? ret : len;
+	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, remap_flags);
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b9e0418a1974..4eacdd703874 100644
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
@@ -4522,6 +4522,7 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_super *osb;
+	loff_t remapped = 0;
 	loff_t pstart, plen;
 	u32 p_cluster, num_clusters, slast, spos, tpos;
 	unsigned int ext_flags;
@@ -4605,30 +4606,32 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 next_loop:
 		spos += num_clusters;
 		tpos += num_clusters;
+		remapped += ocfs2_clusters_to_bytes(t_inode->i_sb,
+				num_clusters);
 	}
 
-out:
-	return ret;
+	return remapped;
 out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
-	return ret;
+out:
+	return remapped > 0 ? remapped : ret;
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
@@ -4700,7 +4703,7 @@ static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
 	/* Actually remap extents now. */
 	ret = ocfs2_reflink_remap_extent(s_inode, s_bh, pos_in, t_inode, t_bh,
 					 pos_out, len, &dealloc);
-	if (ret) {
+	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -4820,18 +4823,19 @@ static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
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
@@ -4855,6 +4859,11 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	if (ret <= 0)
 		goto out_unlock;
 
+	if (len == 0) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	/*
 	 * Update inode timestamps and remove security privileges before we
 	 * take the ilock.
@@ -4874,12 +4883,13 @@ int ocfs2_reflink_remap_range(struct file *file_in,
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
@@ -4897,10 +4907,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
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

