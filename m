Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED61BC5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE88A2098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bAITFBpB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE88A2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbeJSC7G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 22:59:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbeJSC6m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 22:58:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9IInMKn143759;
        Thu, 18 Oct 2018 18:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=9Cj+DLe0Sln1e0/R/XAZSWL1COfZTGIQu59QcFECiYk=;
 b=bAITFBpBt7cT5N9nFgczVrdWqQCF0RWbCg6oripYnhQMPpSKLaWRHYtY4sFuzQ/0w7GF
 vfkjSWgXvx/BkRXcm4RMkfSmw4YEqBqZilhe32tpZ3090oOcORj8N5rkpT5WEW4xF9ml
 0ytU+FHBZAb+wOu9RiC0bKL2xgAJQYjf3rILzp1QXBjpake5fUtHY63QsEQAl3H+chpq
 gnQgjDFjDXkFkN0k/F1bBSYB3xN4GnU1pqyo/fmJObWIDQmlkPUALRzbEx8XbkxgK6Sr
 5ROw2ZxrBDKp8zWzFxepz6R/TQza1FNrGMAkd5Bl7wz3DrXxc6epLaRw88wArehUvj6h 8A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384ugjmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 18:56:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9IIuC5I008572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Oct 2018 18:56:12 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9IIuBEd025211;
        Thu, 18 Oct 2018 18:56:11 GMT
Received: from localhost (/10.145.178.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Oct 2018 11:56:10 -0700
Date:   Thu, 18 Oct 2018 11:56:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH v2 04/29] vfs: strengthen checking of file range inputs to
 generic_remap_checks
Message-ID: <20181018185607.GV28243@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981628292.5568.2466587869276881561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153981628292.5568.2466587869276881561.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9050 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810180157
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

File range remapping, if allowed to run past the destination file's EOF,
is an optimization on a regular file write.  Regular file writes that
extend the file length are subject to various constraints which are not
checked by range cloning.

This is a correctness problem because we're never allowed to touch
ranges that the page cache can't support (s_maxbytes); we're not
supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
set; and we must obey resource limits (RLIMIT_FSIZE).

Therefore, add these checks to the new generic_remap_checks function so
that we curtail unexpected behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: restructurings as recommended by Al Viro
---
 mm/filemap.c |   84 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 47e6bfd45a91..aab149fc1faa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2915,6 +2915,42 @@ struct page *read_cache_page_gfp(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page_gfp);
 
+/*
+ * Don't operate on ranges the page cache doesn't support, and don't exceed the
+ * LFS limits.  If pos is under the limit it becomes a short access.  If it
+ * exceeds the limit we return -EFBIG.
+ */
+static int generic_access_check_limits(struct file *file, loff_t pos,
+				       loff_t *count)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t max_size = inode->i_sb->s_maxbytes;
+
+	if (!(file->f_flags & O_LARGEFILE))
+		max_size = MAX_NON_LFS;
+
+	if (unlikely(pos >= max_size))
+		return -EFBIG;
+	*count = min(*count, max_size - pos);
+	return 0;
+}
+
+static int generic_write_check_limits(struct file *file, loff_t pos,
+				      loff_t *count)
+{
+	loff_t limit = rlimit(RLIMIT_FSIZE);
+
+	if (limit != RLIM_INFINITY) {
+		if (pos >= limit) {
+			send_sig(SIGXFSZ, current, 0);
+			return -EFBIG;
+		}
+		*count = min(*count, limit - pos);
+	}
+
+	return generic_access_check_limits(file, pos, count);
+}
+
 /*
  * Performs necessary checks before doing a write
  *
@@ -2926,8 +2962,8 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
-	unsigned long limit = rlimit(RLIMIT_FSIZE);
-	loff_t pos;
+	loff_t count;
+	int ret;
 
 	if (!iov_iter_count(from))
 		return 0;
@@ -2936,40 +2972,15 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_APPEND)
 		iocb->ki_pos = i_size_read(inode);
 
-	pos = iocb->ki_pos;
-
 	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
 		return -EINVAL;
 
-	if (limit != RLIM_INFINITY) {
-		if (iocb->ki_pos >= limit) {
-			send_sig(SIGXFSZ, current, 0);
-			return -EFBIG;
-		}
-		iov_iter_truncate(from, limit - (unsigned long)pos);
-	}
-
-	/*
-	 * LFS rule
-	 */
-	if (unlikely(pos + iov_iter_count(from) > MAX_NON_LFS &&
-				!(file->f_flags & O_LARGEFILE))) {
-		if (pos >= MAX_NON_LFS)
-			return -EFBIG;
-		iov_iter_truncate(from, MAX_NON_LFS - (unsigned long)pos);
-	}
-
-	/*
-	 * Are we about to exceed the fs block limit ?
-	 *
-	 * If we have written data it becomes a short write.  If we have
-	 * exceeded without writing data we send a signal and return EFBIG.
-	 * Linus frestrict idea will clean these up nicely..
-	 */
-	if (unlikely(pos >= inode->i_sb->s_maxbytes))
-		return -EFBIG;
+	count = iov_iter_count(from);
+	ret = generic_write_check_limits(file, iocb->ki_pos, &count);
+	if (ret)
+		return ret;
 
-	iov_iter_truncate(from, inode->i_sb->s_maxbytes - pos);
+	iov_iter_truncate(from, count);
 	return iov_iter_count(from);
 }
 EXPORT_SYMBOL(generic_write_checks);
@@ -2991,6 +3002,7 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	uint64_t bcount;
 	loff_t size_in, size_out;
 	loff_t bs = inode_out->i_sb->s_blocksize;
+	int ret;
 
 	/* The start of both ranges must be aligned to an fs block. */
 	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_out, bs))
@@ -3014,6 +3026,14 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	count = min(count, size_in - (uint64_t)pos_in);
 
+	ret = generic_access_check_limits(file_in, pos_in, &count);
+	if (ret)
+		return ret;
+
+	ret = generic_write_check_limits(file_out, pos_out, &count);
+	if (ret)
+		return ret;
+
 	/*
 	 * If the user wanted us to link to the infile's EOF, round up to the
 	 * next block boundary for this check.
