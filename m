Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE1BC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1AB214FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3UbwYI6o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE1AB214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJJHbU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:31:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHbT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:31:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08Z06138530;
        Wed, 10 Oct 2018 00:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=MFRIwz6CBqFVERKzCNBTAbGcC1anU5teARhXCpG9dhQ=;
 b=3UbwYI6o8zuAm1YHNg4j48vh8tw6hhgMDh2mod00P5l18lD+iIErI+hNvaWVN1TvtZyM
 S9Exu7FsQvCNPXzShBzsJbtxAqRIceiWCO+8K3WpgmWtcI7apLpXfKzyJSgTndHJWrK/
 CMp9R/I1d1tk8f/t7wPC8R2h6sQS5GdYcPwMPo7ecc9gXc3KBPVXNH/NJvrw1bRCrV1l
 3oyFb0jFqBhxsEjKVS9xR8irJSNa9r0SJczzImMCeH0KhS+ePOJ1bmCvqfLWberEHPVc
 KXnn1rKiSbn0uF6Wf7zyIW8UUPYGHQRDEyF6muwVyeBr1kdBuN51qfYn3szujmGDar4V xg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mxn0q0tj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0Bm5q032650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:48 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9A0BlMu020940;
        Wed, 10 Oct 2018 00:11:47 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:11:47 +0000
Subject: [PATCH 09/25] vfs: rename vfs_clone_file_prep to be more descriptive
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:11:45 -0700
Message-ID: <153913030578.32295.3542082209724064016.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=782
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The vfs_clone_file_prep is a generic function to be called by filesystem
implementations only.  Rename the prefix to generic_ and make it more
clear that it applies to remap operations, not just clones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    2 +-
 fs/read_write.c         |    8 ++++----
 fs/xfs/xfs_reflink.c    |    2 +-
 include/linux/fs.h      |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 19e03936c5e1..36c56dfbe485 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4850,7 +4850,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			&len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/fs/read_write.c b/fs/read_write.c
index a33c8503f12e..4ea81ea7d78d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1717,9 +1717,9 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
  * Returns: 0 for "nothing to clone", 1 for "something to clone", or
  * the usual negative error code.
  */
-int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
-			struct file *file_out, loff_t pos_out,
-			u64 *len, bool is_dedupe)
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  u64 *len, bool is_dedupe)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1788,7 +1788,7 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 
 	return 1;
 }
-EXPORT_SYMBOL(vfs_clone_file_prep);
+EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			struct file *file_out, loff_t pos_out, u64 len)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a4a7b2d9c8a1..4cf1e52efbff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1303,7 +1303,7 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6fedfe4fb5ef..d8f90bdd34e2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1830,9 +1830,9 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
-extern int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
-			       struct file *file_out, loff_t pos_out,
-			       u64 *count, bool is_dedupe);
+extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+					 struct file *file_out, loff_t pos_out,
+					 u64 *count, bool is_dedupe);
 extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,

