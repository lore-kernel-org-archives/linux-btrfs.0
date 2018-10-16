Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7F8C04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B532083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w28UYpsZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0B532083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbeJPLIG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:08:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbeJPLIF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:08:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3Jk1p051787;
        Tue, 16 Oct 2018 03:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=NXYVyyHmVmlKAp63WiEk80Yd1QK+kCWi9LT++yfOJrk=;
 b=w28UYpsZn0QESdH6ooyHsPZ7SFyfEzPzSns19jRH38/Vee7C0yf6PuVnceIkXt/lejSE
 sFCuXREQc7f8VH6Scyue7ZbjOQlRLd4nrvOZOshg5xFzrNMgJXASe8SnorqNcl5bWmwr
 2jL5WT8MSyJzm8ajHTvhDJFQZ7dtyxBKfSJ5fzVvx84/cWkhc4yEisGY+pvXrhgowCtu
 1JEoEe0D9X56WLyCn4TMVgBZGS79kIVIEAFtkf6P51FW0KuZjGd/gDxfM1Pq38FpAGAQ
 D/ZY/8H605hj020q4u2aGX6Jjn+Dc3BJS99i9WWeZF6z78hu8od1tdmiNtJASyVA4a0C Zw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2n384tx27s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3Jheg003413
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:43 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3JgO5012319;
        Tue, 16 Oct 2018 03:19:42 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:19:42 -0700
Subject: [PATCH 15/26] vfs: plumb remap flags through the vfs clone functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:19:40 -0700
Message-ID: <153965998059.3607.7952535159459274693.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=584
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
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
index 6c3fec6168e9..0393815c8971 100644
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
index 906e78be5001..791b406e8264 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1857,12 +1857,15 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
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
@@ -1893,7 +1896,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 		return ret;
 
 	ret = file_in->f_op->remap_file_range(file_in, pos_in,
-			file_out, pos_out, len, 0);
+			file_out, pos_out, len, remap_flags);
 	if (ret < 0)
 		return ret;
 
@@ -1904,12 +1907,14 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
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
index f1d082af34d0..bc353a5224a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1843,10 +1843,10 @@ extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
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

