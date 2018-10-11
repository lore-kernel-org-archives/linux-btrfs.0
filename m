Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285B2C46462
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD9C82077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ecbc6Tcb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD9C82077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbeJKLkJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:40:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbeJKLkJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:40:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B4DspG039247;
        Thu, 11 Oct 2018 04:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=CGsruWwZ9+5W3dIHGIHDPROMqGkFLi0bB5XpuLCATew=;
 b=ecbc6Tcb7OPd+hWU3biSHU9mkSLvXPg74eN4LedTOBjCOpHSv6lbejqBn+xGQo2TtszC
 MZRw0wpLnrqy9M1wZzEpdYSxfqxaVso7ni+77nUdyI0el0cHOUOaULFQmJbA1BefQPbg
 OqKR6PM1eQbRaOqjKAj0N0mo4iY7EVHWZawrwYoieGOq5YwyUPVfTXiQySI9N+aERS0D
 TkfhKG0Zra/aXEzXFj87q9kaGpPNzDq/gOdqOZJHICH4kInFs9Te2LwC4z/+8iNfyFiV
 3oYddk8m/72IeQlww7jilfSYbxDYs1TQ4sjWZwTUPPzDWcxM5410+DL8hgjEy4KEoZDB ig== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mxmfu1g4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:41 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4EepS024243
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:40 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B4Eeqr009582;
        Thu, 11 Oct 2018 04:14:40 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:14:40 +0000
Subject: [PATCH 18/25] vfs: hide file range comparison function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:14:38 -0700
Message-ID: <153923127846.5546.7509528220834177005.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=626
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There are no callers of vfs_dedupe_file_range_compare, so we might as
well make it a static helper and remove the export.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c    |  191 ++++++++++++++++++++++++++--------------------------
 include/linux/fs.h |    3 -
 2 files changed, 95 insertions(+), 99 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 3713893b7e38..c88a443d9eb2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1714,6 +1714,101 @@ static int remap_verify_area(struct file *file, loff_t pos, loff_t len,
 	return security_file_permission(file, write ? MAY_WRITE : MAY_READ);
 }
 
+/*
+ * Read a page's worth of file data into the page cache.  Return the page
+ * locked.
+ */
+static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
+{
+	struct address_space *mapping;
+	struct page *page;
+	pgoff_t n;
+
+	n = offset >> PAGE_SHIFT;
+	mapping = inode->i_mapping;
+	page = read_mapping_page(mapping, n, NULL);
+	if (IS_ERR(page))
+		return page;
+	if (!PageUptodate(page)) {
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+	lock_page(page);
+	return page;
+}
+
+/*
+ * Compare extents of two files to see if they are the same.
+ * Caller must have locked both inodes to prevent write races.
+ */
+static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+					 struct inode *dest, loff_t destoff,
+					 loff_t len, bool *is_same)
+{
+	loff_t src_poff;
+	loff_t dest_poff;
+	void *src_addr;
+	void *dest_addr;
+	struct page *src_page;
+	struct page *dest_page;
+	loff_t cmp_len;
+	bool same;
+	int error;
+
+	error = -EINVAL;
+	same = true;
+	while (len) {
+		src_poff = srcoff & (PAGE_SIZE - 1);
+		dest_poff = destoff & (PAGE_SIZE - 1);
+		cmp_len = min(PAGE_SIZE - src_poff,
+			      PAGE_SIZE - dest_poff);
+		cmp_len = min(cmp_len, len);
+		if (cmp_len <= 0)
+			goto out_error;
+
+		src_page = vfs_dedupe_get_page(src, srcoff);
+		if (IS_ERR(src_page)) {
+			error = PTR_ERR(src_page);
+			goto out_error;
+		}
+		dest_page = vfs_dedupe_get_page(dest, destoff);
+		if (IS_ERR(dest_page)) {
+			error = PTR_ERR(dest_page);
+			unlock_page(src_page);
+			put_page(src_page);
+			goto out_error;
+		}
+		src_addr = kmap_atomic(src_page);
+		dest_addr = kmap_atomic(dest_page);
+
+		flush_dcache_page(src_page);
+		flush_dcache_page(dest_page);
+
+		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+			same = false;
+
+		kunmap_atomic(dest_addr);
+		kunmap_atomic(src_addr);
+		unlock_page(dest_page);
+		unlock_page(src_page);
+		put_page(dest_page);
+		put_page(src_page);
+
+		if (!same)
+			break;
+
+		srcoff += cmp_len;
+		destoff += cmp_len;
+		len -= cmp_len;
+	}
+
+	*is_same = same;
+	return 0;
+
+out_error:
+	return error;
+}
+
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
  * sense, and then flush all dirty data.  Caller must ensure that the
@@ -1912,102 +2007,6 @@ loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(vfs_clone_file_range);
 
-/*
- * Read a page's worth of file data into the page cache.  Return the page
- * locked.
- */
-static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
-{
-	struct address_space *mapping;
-	struct page *page;
-	pgoff_t n;
-
-	n = offset >> PAGE_SHIFT;
-	mapping = inode->i_mapping;
-	page = read_mapping_page(mapping, n, NULL);
-	if (IS_ERR(page))
-		return page;
-	if (!PageUptodate(page)) {
-		put_page(page);
-		return ERR_PTR(-EIO);
-	}
-	lock_page(page);
-	return page;
-}
-
-/*
- * Compare extents of two files to see if they are the same.
- * Caller must have locked both inodes to prevent write races.
- */
-int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
-				  struct inode *dest, loff_t destoff,
-				  loff_t len, bool *is_same)
-{
-	loff_t src_poff;
-	loff_t dest_poff;
-	void *src_addr;
-	void *dest_addr;
-	struct page *src_page;
-	struct page *dest_page;
-	loff_t cmp_len;
-	bool same;
-	int error;
-
-	error = -EINVAL;
-	same = true;
-	while (len) {
-		src_poff = srcoff & (PAGE_SIZE - 1);
-		dest_poff = destoff & (PAGE_SIZE - 1);
-		cmp_len = min(PAGE_SIZE - src_poff,
-			      PAGE_SIZE - dest_poff);
-		cmp_len = min(cmp_len, len);
-		if (cmp_len <= 0)
-			goto out_error;
-
-		src_page = vfs_dedupe_get_page(src, srcoff);
-		if (IS_ERR(src_page)) {
-			error = PTR_ERR(src_page);
-			goto out_error;
-		}
-		dest_page = vfs_dedupe_get_page(dest, destoff);
-		if (IS_ERR(dest_page)) {
-			error = PTR_ERR(dest_page);
-			unlock_page(src_page);
-			put_page(src_page);
-			goto out_error;
-		}
-		src_addr = kmap_atomic(src_page);
-		dest_addr = kmap_atomic(dest_page);
-
-		flush_dcache_page(src_page);
-		flush_dcache_page(dest_page);
-
-		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
-			same = false;
-
-		kunmap_atomic(dest_addr);
-		kunmap_atomic(src_addr);
-		unlock_page(dest_page);
-		unlock_page(src_page);
-		put_page(dest_page);
-		put_page(src_page);
-
-		if (!same)
-			break;
-
-		srcoff += cmp_len;
-		destoff += cmp_len;
-		len -= cmp_len;
-	}
-
-	*is_same = same;
-	return 0;
-
-out_error:
-	return error;
-}
-EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
-
 loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 				 struct file *dst_file, loff_t dst_pos,
 				 loff_t len, unsigned int remap_flags)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 57cb56bbc30a..f0603ed007e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1865,9 +1865,6 @@ extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 extern loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
-extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
-					 struct inode *dest, loff_t destoff,
-					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,

