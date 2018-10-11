Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C082C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC2162077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+Q1M5T6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC2162077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbeJKLjf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:39:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbeJKLje (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:39:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B4DtIa058434;
        Thu, 11 Oct 2018 04:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6zkqFIHE464xGeFIjlnSQ0eGfTVJtdWHbkt73gVdvYU=;
 b=i+Q1M5T6Mn5ZmCTgcOBaOBeVnm9AgNGfQLns5tfzLLLX9w/rks8wTraMv07Pqh8TZHCv
 i9eF4FG2sG9iboD4b2chmN8CV+MSeXTpGzJsJDd/8ZuPkw5P7amaaX3pHJYxLbyv1kD8
 uLDDH1CL/yCqvlFNLGh+SC7BUXjm/bcxvbZLc/ebvg8MIdmZV6foP7ar6uq2UxhwDSEf
 3p5sISkV6r1zjOUExu8sZ/YwmH1wfMys8W//qdy/p2sRIdnGqZcK6axM8B1egEOtCD55
 L/4X7aFzY8eCD66hSwujgiXvMfn2GUu2RdLJy0lO0gkvIFVZxgpPkyPKLzmn9wuK3by/ Og== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0q9dyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:08 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4E7aj017979
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:07 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4E62u010901;
        Thu, 11 Oct 2018 04:14:06 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:14:06 +0000
Subject: [PATCH 14/25] vfs: plumb RFR_* remap flags through the vfs clone
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:14:05 -0700
Message-ID: <153923124495.5546.2993415758308396845.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=617
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb a remap_flags argument through the {do,vfs}_clone_file_range
functions so that clone can take advantage of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c             |    2 +-
 fs/nfsd/vfs.c          |    2 +-
 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/file.c    |    6 +++---
 fs/read_write.c        |   13 +++++++++----
 include/linux/fs.h     |    4 ++--
 6 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 72537b68c272..505275ec5596 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -232,7 +232,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		goto fdput;
 	cloned = vfs_clone_file_range(src_file.file, off, dst_file, destoff,
-				      olen);
+				      olen, 0);
 	if (cloned < 0)
 		ret = cloned;
 	else if (olen && cloned != olen)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ac6cb6101cbe..726fc5b2b27a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -543,7 +543,7 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 {
 	loff_t cloned;
 
-	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count);
+	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
 	if (count && cloned != count)
 		cloned = -EINVAL;
 	return nfserrno(cloned < 0 ? cloned : 0);
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8750b7235516..5f82fece64a0 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -142,7 +142,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	}
 
 	/* Try to use clone_file_range to clone up within the same fs */
-	cloned = do_clone_file_range(old_file, 0, new_file, 0, len);
+	cloned = do_clone_file_range(old_file, 0, new_file, 0, len, 0);
 	if (cloned == len)
 		goto out;
 	/* Couldn't clone, so now we try to copy the data */
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 177731b21bad..e5cc17281d0b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -462,7 +462,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 
 	case OVL_CLONE:
 		ret = vfs_clone_file_range(real_in.file, pos_in,
-					   real_out.file, pos_out, len);
+					   real_out.file, pos_out, len, flags);
 		break;
 
 	case OVL_DEDUPE:
@@ -512,8 +512,8 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
 	     !ovl_inode_upper(file_inode(file_out))))
 		return -EPERM;
 
-	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
-			    op);
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len,
+			    remap_flags, op);
 }
 
 const struct file_operations ovl_file_operations = {
diff --git a/fs/read_write.c b/fs/read_write.c
index 461acd5fcc4a..b3f8b4a2bdfc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1842,12 +1842,15 @@ int generic_remap_file_range_touch(struct file *file, unsigned int remap_flags)
 EXPORT_SYMBOL(generic_remap_file_range_touch);
 
 loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
-			   struct file *file_out, loff_t pos_out, loff_t len)
+			   struct file *file_out, loff_t pos_out,
+			   loff_t len, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	loff_t ret;
 
+	WARN_ON_ONCE(remap_flags);
+
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
@@ -1878,7 +1881,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 		return ret;
 
 	ret = file_in->f_op->remap_file_range(file_in, pos_in,
-			file_out, pos_out, len, 0);
+			file_out, pos_out, len, remap_flags);
 	if (ret < 0)
 		return ret;
 
@@ -1889,12 +1892,14 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 EXPORT_SYMBOL(do_clone_file_range);
 
 loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-			    struct file *file_out, loff_t pos_out, loff_t len)
+			    struct file *file_out, loff_t pos_out,
+			    loff_t len, unsigned int remap_flags)
 {
 	loff_t ret;
 
 	file_start_write(file_out);
-	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len);
+	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len,
+				  remap_flags);
 	file_end_write(file_out);
 
 	return ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 035d8a88f633..4acda4809027 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1852,10 +1852,10 @@ extern int generic_remap_file_range_touch(struct file *file,
 					  unsigned int remap_flags);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  loff_t len);
+				  loff_t len, unsigned int remap_flags);
 extern loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 				   struct file *file_out, loff_t pos_out,
-				   loff_t len);
+				   loff_t len, unsigned int remap_flags);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same);

