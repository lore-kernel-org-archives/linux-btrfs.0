Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0622C64EBC
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52A6220834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pFD+lrxs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52A6220834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbeJEHl2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:41:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbeJEHl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iLXo196576;
        Fri, 5 Oct 2018 00:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=f6Hj+4mK+V2uG65ijbHrPSYrbyxtrOfjOeBVCA9WTcg=;
 b=pFD+lrxsx42D0nlp8vOXn69EFYDLCW1//evRZKeYAR2/e3UyCRyfDMCPCNBXpzGTdS1e
 btFp4NoIO4HSAZVvrXxUW0Ume8vOKA1Z28bhws31VAQas+TiXboZ/k5Q/bKI58WS40fp
 jLNp2umW5B307rQQ/KemBGWurdfBhkRFhm7xj1azB9VORcTE435GTXcSTofVp3VjDo7O
 7u/dC8hEPRsErhjEzhPCp5AEWGTQOncEnXE7IHkREFg0wY0i0gjazfOnYFCI2AFCEcdh
 Hs10ikbPfJcvOK1meud5lsEFJGz7t6fcKE+WcIhs3juHcYLC2IDMslSKuzCDLmGvK5Oc FA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mt21rfjyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:16 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950jA46004769
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:10 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w950jAnh014507;
        Fri, 5 Oct 2018 00:45:10 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:45:09 +0000
Subject: [PATCH 05/15] vfs: check file ranges before cloning files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:08 -0700
Message-ID: <153870030868.29072.14603423813271148877.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the file range checks from vfs_clone_file_prep into a separate
generic_clone_checks function so that all the checks are collected in a
central location.  This forms the basis for adding more checks from
generic_write_checks that will make cloning's input checking more
consistent with write input checking.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    2 +
 fs/read_write.c         |   55 ++++++++++----------------------------
 fs/xfs/xfs_reflink.c    |    2 +
 include/linux/fs.h      |    9 ++++--
 mm/filemap.c            |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 46 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7869622af22a..11e4aad7b783 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4842,7 +4842,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
+	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
 			&len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/fs/read_write.c b/fs/read_write.c
index 39b4a21dd933..973d3da78c09 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1717,12 +1717,13 @@ static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
  * Returns: 0 for "nothing to clone", 1 for "something to clone", or
  * the usual negative error code.
  */
-int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
-			       struct inode *inode_out, loff_t pos_out,
-			       u64 *len, bool is_dedupe)
+int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
+			struct file *file_out, loff_t pos_out,
+			u64 *len, bool is_dedupe)
 {
-	loff_t bs = inode_out->i_sb->s_blocksize;
-	loff_t blen;
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
+	uint64_t nlen;
 	loff_t isize;
 	bool same_inode = (inode_in == inode_out);
 	int ret;
@@ -1740,10 +1741,7 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
-	/* Are we going all the way to the end? */
 	isize = i_size_read(inode_in);
-	if (isize == 0)
-		return 0;
 
 	/* Zero length dedupe exits immediately; reflink goes to EOF. */
 	if (*len == 0) {
@@ -1754,37 +1752,15 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 		*len = isize - pos_in;
 	}
 
-	/* Ensure offsets don't wrap and the input is inside i_size */
-	if (pos_in + *len < pos_in || pos_out + *len < pos_out ||
-	    pos_in + *len > isize)
-		return -EINVAL;
-
-	/* Don't allow dedupe past EOF in the dest file */
-	if (is_dedupe) {
-		loff_t	disize;
-
-		disize = i_size_read(inode_out);
-		if (pos_out >= disize || pos_out + *len > disize)
-			return -EINVAL;
-	}
-
-	/* If we're linking to EOF, continue to the block boundary. */
-	if (pos_in + *len == isize)
-		blen = ALIGN(isize, bs) - pos_in;
-	else
-		blen = *len;
-
-	/* Only reflink if we're aligned to block boundaries */
-	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_in + blen, bs) ||
-	    !IS_ALIGNED(pos_out, bs) || !IS_ALIGNED(pos_out + blen, bs))
+	/* Check that we don't violate system file offset limits. */
+	nlen = *len;
+	ret = generic_clone_checks(file_in, pos_in, file_out, pos_out, &nlen,
+			is_dedupe);
+	if (ret)
+		return ret;
+	if (nlen != *len)
 		return -EINVAL;
 
-	/* Don't allow overlapped reflink within the same file */
-	if (same_inode) {
-		if (pos_out + blen > pos_in && pos_out < pos_in + blen)
-			return -EINVAL;
-	}
-
 	/* Wait for the completion of any pending IOs on both files */
 	inode_dio_wait(inode_in);
 	if (!same_inode)
@@ -1816,7 +1792,7 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 
 	return 1;
 }
-EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
+EXPORT_SYMBOL(vfs_clone_file_prep);
 
 int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len)
@@ -1854,9 +1830,6 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	if (pos_in + len > i_size_read(inode_in))
-		return -EINVAL;
-
 	ret = file_in->f_op->clone_file_range(file_in, pos_in,
 			file_out, pos_out, len);
 	if (!ret) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d8f209bc8937..1955e093e9ea 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1277,7 +1277,7 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
+	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
 			&len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c0b4a1c22ff..2a4141d36ebf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1825,9 +1825,9 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
-extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
-				      struct inode *inode_out, loff_t pos_out,
-				      u64 *len, bool is_dedupe);
+extern int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
+			       struct file *file_out, loff_t pos_out,
+			       u64 *count, bool is_dedupe);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
@@ -2978,6 +2978,9 @@ extern int sb_min_blocksize(struct super_block *, int);
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
+extern int generic_clone_checks(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out,
+				uint64_t *count, bool is_dedupe);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 52517f28e6f4..68ec91d05c7b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2974,6 +2974,74 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 }
 EXPORT_SYMBOL(generic_write_checks);
 
+/*
+ * Performs necessary checks before doing a clone.
+ *
+ * Can adjust amount of bytes to clone.
+ * Returns appropriate error code that caller should return or
+ * zero in case the clone should be allowed.
+ */
+int generic_clone_checks(struct file *file_in, loff_t pos_in,
+			 struct file *file_out, loff_t pos_out,
+			 uint64_t *req_count, bool is_dedupe)
+{
+	struct inode *inode_in = file_in->f_mapping->host;
+	struct inode *inode_out = file_out->f_mapping->host;
+	unsigned long limit = rlimit(RLIMIT_FSIZE);
+	uint64_t count = *req_count;
+	uint64_t bcount;
+	loff_t size_in, size_out;
+	loff_t bs = inode_out->i_sb->s_blocksize;
+
+	/* The start of both ranges must be aligned to an fs block. */
+	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_out, bs))
+		return -EINVAL;
+
+	/* Ensure offsets don't wrap. */
+	if (pos_in + count < pos_in || pos_out + count < pos_out)
+		return -EINVAL;
+
+	size_in = i_size_read(inode_in);
+	size_out = i_size_read(inode_out);
+
+	/* Dedupe requires both ranges to be within EOF. */
+	if (is_dedupe &&
+	    (pos_in >= size_in || pos_in + count > size_in ||
+	     pos_out >= size_out || pos_out + count > size_out))
+		return -EINVAL;
+
+	/* Ensure the infile range is within the infile. */
+	if (pos_in >= size_in)
+		return -EINVAL;
+	count = min(count, size_in - (uint64_t)pos_in);
+
+	/*
+	 * If the user wanted us to link to the infile's EOF, round up to the
+	 * next block boundary for this check.
+	 *
+	 * Otherwise, make sure the count is also block-aligned, having
+	 * already confirmed the starting offsets' block alignment.
+	 */
+	if (pos_in + count == size_in) {
+		bcount = ALIGN(size_in, bs) - pos_in;
+	} else {
+		if (!IS_ALIGNED(count, bs))
+			return -EINVAL;
+
+		bcount = count;
+	}
+
+	/* Don't allow overlapped cloning within the same file. */
+	if (inode_in == inode_out &&
+	    pos_out + bcount > pos_in &&
+	    pos_out < pos_in + bcount)
+		return -EINVAL;
+
+	*req_count = count;
+	return 0;
+}
+EXPORT_SYMBOL(generic_clone_checks);
+
 int pagecache_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)

