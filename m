Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FD8C04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928342083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WeWv5c6c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 928342083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJPLH5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:07:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52936 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbeJPLH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:07:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3J0s1005214;
        Tue, 16 Oct 2018 03:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=nesA5JY6mqKDsd7ZyfRy+faA8oQ5iyhcx7Osw/99+C0=;
 b=WeWv5c6cXTeU0i/GwGf4SbaLHjypMeuaqK0WuQx/MoHxzZQhgFVVSNvaFUsOsd3nu2cZ
 y2IyUO/Iv7PQ6cuTGz99Y1CSgy+d8vPiiTc19DEo+hNcehQtBGM2tlbdYO7hiru4vAty
 y4x39gXjV+UEVr6wCb+u5Rc9DR+/HMSPkR3a+XN23evYshS567twltTixrQziHfNeRx0
 wB5OVptbvk8H6U+Qql8zhA6lXQ3g8Kwv9DOQXy7/TzC49/ngpS6ynKeLnnGL2QEHHpg4
 rU+0iD5aiIL6B/4pKSXmcT/1l98hp+jM/lfSz18xSEVE98Qg/AFSllosvA1mqWtwLPKL Sw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39br5s1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3JZaX016563
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:36 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3JZur010449;
        Tue, 16 Oct 2018 03:19:35 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:19:35 -0700
Subject: [PATCH 14/26] vfs: make remap_file_range functions take and return
 bytes completed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:19:33 -0700
Message-ID: <153965997357.3607.11758898576797485849.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=941
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the remap_file_range functions to take a number of bytes to
operate upon and return the number of bytes they operated on.  This is a
requirement for allowing fs implementations to return short clone/dedupe
results to the user, which will enable us to obey resource limits in a
graceful manner.

A subsequent patch will enable copy_file_range to signal to the
->clone_file_range implementation that it can handle a short length,
which will be returned in the function's return value.  For now the
short return is not implemented anywhere so the behavior won't change --
either copy_file_range manages to clone the entire range or it tries an
alternative.

Neither clone ioctl can take advantage of this, alas.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/vfs.txt |    6 ++---
 fs/btrfs/ctree.h                  |    6 ++---
 fs/btrfs/ioctl.c                  |   13 ++++++----
 fs/cifs/cifsfs.c                  |    6 ++---
 fs/ioctl.c                        |   10 +++++++-
 fs/nfs/nfs4file.c                 |    6 ++---
 fs/nfsd/vfs.c                     |    8 +++++-
 fs/ocfs2/file.c                   |   16 ++++++------
 fs/ocfs2/refcounttree.c           |    2 +-
 fs/ocfs2/refcounttree.h           |    2 +-
 fs/overlayfs/copy_up.c            |    6 ++---
 fs/overlayfs/file.c               |   12 +++++----
 fs/read_write.c                   |   49 ++++++++++++++++++++-----------------
 fs/xfs/xfs_file.c                 |    9 +++++--
 fs/xfs/xfs_reflink.c              |    4 ++-
 fs/xfs/xfs_reflink.h              |    2 +-
 include/linux/fs.h                |   27 +++++++++++---------
 mm/filemap.c                      |    2 +-
 18 files changed, 106 insertions(+), 80 deletions(-)


diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index bb3183334ab9..8ba47d9d6cae 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -883,9 +883,9 @@ struct file_operations {
 	unsigned (*mmap_capabilities)(struct file *);
 #endif
 	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
-	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
-				struct file *file_out, loff_t pos_out,
-				u64 len, unsigned int remap_flags);
+	loff_t (*remap_file_range)(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 };
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 124a05662fc2..771a961d77ad 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3247,9 +3247,9 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
-int btrfs_remap_file_range(struct file *file_in, loff_t pos_in,
-			   struct file *file_out, loff_t pos_out, u64 len,
-			   unsigned int remap_flags);
+loff_t btrfs_remap_file_range(struct file *file_in, loff_t pos_in,
+			      struct file *file_out, loff_t pos_out,
+			      loff_t len, unsigned int remap_flags);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bfd99c66723e..b0c513e10977 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4328,10 +4328,12 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	return ret;
 }
 
-int btrfs_remap_file_range(struct file *src_file, loff_t off,
-		struct file *dst_file, loff_t destoff, u64 len,
+loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
+		struct file *dst_file, loff_t destoff, loff_t len,
 		unsigned int remap_flags)
 {
+	int ret;
+
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
@@ -4349,10 +4351,11 @@ int btrfs_remap_file_range(struct file *src_file, loff_t off,
 			return -EINVAL;
 		}
 
-		return btrfs_extent_same(src, off, len, dst, destoff);
+		ret = btrfs_extent_same(src, off, len, dst, destoff);
+	} else {
+		ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
 	}
-
-	return btrfs_clone_files(dst_file, src_file, off, len, destoff);
+	return ret < 0 ? ret : len;
 }
 
 static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e8144d0dcde2..5ca71c6c8be2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -975,8 +975,8 @@ const struct inode_operations cifs_symlink_inode_ops = {
 	.listxattr = cifs_listxattr,
 };
 
-static int cifs_remap_file_range(struct file *src_file, loff_t off,
-		struct file *dst_file, loff_t destoff, u64 len,
+static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
+		struct file *dst_file, loff_t destoff, loff_t len,
 		unsigned int remap_flags)
 {
 	struct inode *src_inode = file_inode(src_file);
@@ -1029,7 +1029,7 @@ static int cifs_remap_file_range(struct file *src_file, loff_t off,
 	unlock_two_nondirectories(src_inode, target_inode);
 out:
 	free_xid(xid);
-	return rc;
+	return rc < 0 ? rc : len;
 }
 
 ssize_t cifs_file_copychunk_range(unsigned int xid,
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2005529af560..72537b68c272 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -223,6 +223,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 			     u64 off, u64 olen, u64 destoff)
 {
 	struct fd src_file = fdget(srcfd);
+	loff_t cloned;
 	int ret;
 
 	if (!src_file.file)
@@ -230,7 +231,14 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 	ret = -EXDEV;
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		goto fdput;
-	ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
+	cloned = vfs_clone_file_range(src_file.file, off, dst_file, destoff,
+				      olen);
+	if (cloned < 0)
+		ret = cloned;
+	else if (olen && cloned != olen)
+		ret = -EINVAL;
+	else
+		ret = 0;
 fdput:
 	fdput(src_file);
 	return ret;
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index ae5780ce41dc..46d691ba04bc 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -180,8 +180,8 @@ static long nfs42_fallocate(struct file *filep, int mode, loff_t offset, loff_t
 	return nfs42_proc_allocate(filep, offset, len);
 }
 
-static int nfs42_remap_file_range(struct file *src_file, loff_t src_off,
-		struct file *dst_file, loff_t dst_off, u64 count,
+static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
+		struct file *dst_file, loff_t dst_off, loff_t count,
 		unsigned int remap_flags)
 {
 	struct inode *dst_inode = file_inode(dst_file);
@@ -244,7 +244,7 @@ static int nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 		inode_unlock(src_inode);
 	}
 out:
-	return ret;
+	return ret < 0 ? ret : count;
 }
 #endif /* CONFIG_NFS_V4_2 */
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b53e76391e52..ac6cb6101cbe 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -541,8 +541,12 @@ __be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
 __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 		u64 dst_pos, u64 count)
 {
-	return nfserrno(vfs_clone_file_range(src, src_pos, dst, dst_pos,
-					     count));
+	loff_t cloned;
+
+	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count);
+	if (count && cloned != count)
+		cloned = -EINVAL;
+	return nfserrno(cloned < 0 ? cloned : 0);
 }
 
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9809b0e5746f..fbaeafe44b5f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2527,18 +2527,18 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 	return offset;
 }
 
-static int ocfs2_remap_file_range(struct file *file_in,
-				  loff_t pos_in,
-				  struct file *file_out,
-				  loff_t pos_out,
-				  u64 len,
-				  unsigned int remap_flags)
+static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
+				     struct file *file_out, loff_t pos_out,
+				     loff_t len, unsigned int remap_flags)
 {
+	int ret;
+
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					 len, remap_flags);
+	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+					len, remap_flags);
+	return ret < 0 ? ret : len;
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index df9781567ec0..6a42c04ac0ab 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4824,7 +4824,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 			      loff_t pos_in,
 			      struct file *file_out,
 			      loff_t pos_out,
-			      u64 len,
+			      loff_t len,
 			      unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index d2c5f526edff..eb65c1d0843c 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -119,7 +119,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 			      loff_t pos_in,
 			      struct file *file_out,
 			      loff_t pos_out,
-			      u64 len,
+			      loff_t len,
 			      unsigned int remap_flags);
 
 #endif /* OCFS2_REFCOUNTTREE_H */
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 1cc797a08a5b..8750b7235516 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -125,6 +125,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	struct file *new_file;
 	loff_t old_pos = 0;
 	loff_t new_pos = 0;
+	loff_t cloned;
 	int error = 0;
 
 	if (len == 0)
@@ -141,11 +142,10 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	}
 
 	/* Try to use clone_file_range to clone up within the same fs */
-	error = do_clone_file_range(old_file, 0, new_file, 0, len);
-	if (!error)
+	cloned = do_clone_file_range(old_file, 0, new_file, 0, len);
+	if (cloned == len)
 		goto out;
 	/* Couldn't clone, so now we try to copy the data */
-	error = 0;
 
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index fffb36fd5920..6c3fec6168e9 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -434,14 +434,14 @@ enum ovl_copyop {
 	OVL_DEDUPE,
 };
 
-static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
+static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
-			    u64 len, unsigned int flags, enum ovl_copyop op)
+			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
 	struct inode *inode_out = file_inode(file_out);
 	struct fd real_in, real_out;
 	const struct cred *old_cred;
-	ssize_t ret;
+	loff_t ret;
 
 	ret = ovl_real_fdget(file_out, &real_out);
 	if (ret)
@@ -489,9 +489,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
 			    OVL_COPY);
 }
 
-static int ovl_remap_file_range(struct file *file_in, loff_t pos_in,
-				struct file *file_out, loff_t pos_out,
-				u64 len, unsigned int remap_flags)
+static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   loff_t len, unsigned int remap_flags)
 {
 	enum ovl_copyop op;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 3f6392f1d5d4..906e78be5001 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1589,10 +1589,13 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * more efficient if both clone and copy are supported (e.g. NFS).
 	 */
 	if (file_in->f_op->remap_file_range) {
-		ret = file_in->f_op->remap_file_range(file_in, pos_in,
-				file_out, pos_out, len, 0);
-		if (ret == 0) {
-			ret = len;
+		loff_t cloned;
+
+		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
+				file_out, pos_out,
+				min_t(loff_t, MAX_RW_COUNT, len), 0);
+		if (cloned > 0) {
+			ret = cloned;
 			goto done;
 		}
 	}
@@ -1686,11 +1689,12 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 	return ret;
 }
 
-static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
+static int remap_verify_area(struct file *file, loff_t pos, loff_t len,
+			     bool write)
 {
 	struct inode *inode = file_inode(file);
 
-	if (unlikely(pos < 0))
+	if (unlikely(pos < 0 || len < 0))
 		return -EINVAL;
 
 	 if (unlikely((loff_t) (pos + len) < 0))
@@ -1721,7 +1725,7 @@ static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 static int generic_remap_check_len(struct inode *inode_in,
 				   struct inode *inode_out,
 				   loff_t pos_out,
-				   u64 *len,
+				   loff_t *len,
 				   unsigned int remap_flags)
 {
 	u64 blkmask = i_blocksize(inode_in) - 1;
@@ -1771,7 +1775,7 @@ static int generic_remap_file_range_target(struct file *file,
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  u64 *len, unsigned int remap_flags)
+				  loff_t *len, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1852,12 +1856,12 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
-int do_clone_file_range(struct file *file_in, loff_t pos_in,
-			struct file *file_out, loff_t pos_out, u64 len)
+loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
+			   struct file *file_out, loff_t pos_out, loff_t len)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
-	int ret;
+	loff_t ret;
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
@@ -1890,19 +1894,19 @@ int do_clone_file_range(struct file *file_in, loff_t pos_in,
 
 	ret = file_in->f_op->remap_file_range(file_in, pos_in,
 			file_out, pos_out, len, 0);
-	if (!ret) {
-		fsnotify_access(file_in);
-		fsnotify_modify(file_out);
-	}
+	if (ret < 0)
+		return ret;
 
+	fsnotify_access(file_in);
+	fsnotify_modify(file_out);
 	return ret;
 }
 EXPORT_SYMBOL(do_clone_file_range);
 
-int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-			 struct file *file_out, loff_t pos_out, u64 len)
+loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
+			    struct file *file_out, loff_t pos_out, loff_t len)
 {
-	int ret;
+	loff_t ret;
 
 	file_start_write(file_out);
 	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len);
@@ -2008,10 +2012,11 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
-int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
-			      struct file *dst_file, loff_t dst_pos, u64 len)
+loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+				 struct file *dst_file, loff_t dst_pos,
+				 loff_t len)
 {
-	s64 ret;
+	loff_t ret;
 
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
@@ -2060,7 +2065,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	int i;
 	int ret;
 	u16 count = same->dest_count;
-	int deduped;
+	loff_t deduped;
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EINVAL;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 20314eb4677a..38fde4e11714 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -919,20 +919,23 @@ xfs_file_fallocate(
 	return error;
 }
 
-STATIC int
+STATIC loff_t
 xfs_file_remap_range(
 	struct file	*file_in,
 	loff_t		pos_in,
 	struct file	*file_out,
 	loff_t		pos_out,
-	u64		len,
+	loff_t		len,
 	unsigned int	remap_flags)
 {
+	int		ret;
+
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
-	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
+	return ret < 0 ? ret : len;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 2d7dd8b28d7c..3dbe5fb7e9c0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1296,7 +1296,7 @@ xfs_reflink_remap_prep(
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			*len,
+	loff_t			*len,
 	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
@@ -1387,7 +1387,7 @@ xfs_reflink_remap_range(
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			len,
+	loff_t			len,
 	unsigned int		remap_flags)
 {
 	struct inode		*inode_in = file_inode(file_in);
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 6f82d628bf17..c3c46c276fe1 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,7 +28,7 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, u64 len,
+		struct file *file_out, loff_t pos_out, loff_t len,
 		unsigned int remap_flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
 		struct xfs_inode *ip, bool *has_shared);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1aa3bc1bb092..f1d082af34d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1772,9 +1772,9 @@ struct file_operations {
 #endif
 	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
 			loff_t, size_t, unsigned int);
-	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
-				struct file *file_out, loff_t pos_out,
-				u64 len, unsigned int remap_flags);
+	loff_t (*remap_file_range)(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
 } __randomize_layout;
 
@@ -1839,19 +1839,22 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
-					 u64 *count, unsigned int remap_flags);
-extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
-			       struct file *file_out, loff_t pos_out, u64 len);
-extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-				struct file *file_out, loff_t pos_out, u64 len);
+					 loff_t *count,
+					 unsigned int remap_flags);
+extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  loff_t len);
+extern loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   loff_t len);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
-extern int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
-				     struct file *dst_file, loff_t dst_pos,
-				     u64 len);
+extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
+					struct file *dst_file, loff_t dst_pos,
+					loff_t len);
 
 
 struct super_operations {
@@ -2981,7 +2984,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				uint64_t *count, unsigned int remap_flags);
+				loff_t *count, unsigned int remap_flags);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index b0f1f6d93d9c..1e93269efafe 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3001,7 +3001,7 @@ EXPORT_SYMBOL(generic_write_checks);
  */
 int generic_remap_checks(struct file *file_in, loff_t pos_in,
 			 struct file *file_out, loff_t pos_out,
-			 uint64_t *req_count, unsigned int remap_flags)
+			 loff_t *req_count, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;

