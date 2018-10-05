Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD04C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D9720854
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KXiYI9aC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50D9720854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbeJEHmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:42:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iOH7196603;
        Fri, 5 Oct 2018 00:45:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zkql5ut3J1jcIu+37XHzEJHwqfkGhGhPkyB4RXE/GYA=;
 b=KXiYI9aCzS0i0XDJFBdNCICWHeEq+ang4WDG1fG1tPrwvQd4AlpiVa6T0TEWSIhjgAqj
 JlXn4nE+aYNv7Wg84uMD9MlU7N5VnV0WOETu+C+4rLxee+cylCCp8eAgcNMqvp5SnIDB
 2f5TkltfM04QyU0mVxaKSEZDGJYKlke5q0ZLkzGmAxt8Ni8KA20rLLWyOuHlnIj/sDNP
 +wqSVnG4ZwIC4vHPvoq11Df6LKrcmURjtnm8Ig37WrNeSMrP3U2eg1LG/xadNlTwi0cc
 VkcJL37kOSxLK2cRcDYFo97+GQgUY1IkrK36QhSQIOv55F/MEETi7+oVDlMz9SM3ZYLh pA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mt21rfk19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w950jusF007131
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:56 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w950juM5011898;
        Fri, 5 Oct 2018 00:45:56 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Oct 2018 17:45:56 -0700
Subject: [PATCH 11/15] vfs: allow short clone and dedupe operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:54 -0700
Message-ID: <153870035471.29072.15690301164025555492.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=440
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow the clone and dedupe prep function to shorten the request if the
caller can handle it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |    8 ++------
 include/linux/fs.h |    2 +-
 mm/filemap.c       |   19 +++++++++++++++----
 3 files changed, 18 insertions(+), 11 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 4eaea52f70a8..292d68c2f47c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1726,7 +1726,6 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
-	uint64_t nlen;
 	loff_t isize;
 	bool same_inode = (inode_in == inode_out);
 	bool is_dedupe = (flags & CLONERANGE_DEDUPE);
@@ -1758,13 +1757,10 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 	}
 
 	/* Check that we don't violate system file offset limits. */
-	nlen = *len;
-	ret = generic_clone_checks(file_in, pos_in, file_out, pos_out, &nlen,
-			is_dedupe);
+	ret = generic_clone_checks(file_in, pos_in, file_out, pos_out, len,
+			flags);
 	if (ret)
 		return ret;
-	if (nlen != *len)
-		return -EINVAL;
 
 	/* Wait for the completion of any pending IOs on both files */
 	inode_dio_wait(inode_in);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae5685c31270..eb35363478e5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2988,7 +2988,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern int generic_clone_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				uint64_t *count, bool is_dedupe);
+				uint64_t *count, unsigned int flags);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index f74391721234..013451b8017f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2983,7 +2983,7 @@ EXPORT_SYMBOL(generic_write_checks);
  */
 int generic_clone_checks(struct file *file_in, loff_t pos_in,
 			 struct file *file_out, loff_t pos_out,
-			 uint64_t *req_count, bool is_dedupe)
+			 uint64_t *req_count, unsigned int flags)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;
@@ -3005,7 +3005,7 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	size_out = i_size_read(inode_out);
 
 	/* Dedupe requires both ranges to be within EOF. */
-	if (is_dedupe &&
+	if ((flags & CLONERANGE_DEDUPE) &&
 	    (pos_in >= size_in || pos_in + count > size_in ||
 	     pos_out >= size_out || pos_out + count > size_out))
 		return -EINVAL;
@@ -3056,8 +3056,12 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	if (pos_in + count == size_in) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
-		if (!IS_ALIGNED(count, bs))
-			return -EINVAL;
+		if (!IS_ALIGNED(count, bs)) {
+			if (flags & CLONERANGE_SHORT)
+				count = ALIGN_DOWN(count, bs);
+			else
+				return -EINVAL;
+		}
 
 		bcount = count;
 	}
@@ -3068,6 +3072,13 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 	    pos_out < pos_in + bcount)
 		return -EINVAL;
 
+	/*
+	 * We shortened the request but the caller can't deal with that, so
+	 * bounce the request back to userspace.
+	 */
+	if (*req_count != count && !(flags & CLONERANGE_SHORT))
+		return -EINVAL;
+
 	*req_count = count;
 	return 0;
 }

