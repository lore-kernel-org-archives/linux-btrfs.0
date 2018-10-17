Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A733DECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DA9D2145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lVtnE4It"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DA9D2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbeJRGqa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:46:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbeJRGqa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:46:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMiZQA040586;
        Wed, 17 Oct 2018 22:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=KzS1YpGdWiJRTm/Yeg6QnEh5g6eeuSdILXoQJhMO7DM=;
 b=lVtnE4It0+qQyj8BXkhNWaG0Xp5U867+NBJr7ZE5Po5ANUyHDC1U2SIMXlPpa+Pybwvb
 +kcNZ6l95Kk75J4l3OGR50Y6v0OFuIpCgFVQdTVeR3J5acjGxsj2YpJYI4HpLpRnodUD
 oMGCTgDRV56pNni+LUaYHWqwHZ+XQykCTS/sKkE3NbHDpRlOXaGFySJoNC9pZVfP0pm1
 Wds0+jJTZGA1DgMu4E23+OfhPa09jdgFYYNC2cnwO39emNVFK6b6ZsovtTbdPWnkQJJ8
 iZsUVGuinun6jYa40ZVrfK98mOeeeGmG30EuKtB3BHBm3dU3eunIzvb1YSx81Lk7uT76 tA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384ua02q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:46:21 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMkKnp006053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:46:21 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMkKB5015316;
        Wed, 17 Oct 2018 22:46:20 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:46:20 -0700
Subject: [PATCH 17/29] vfs: hide file range comparison function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:46:19 -0700
Message-ID: <153981637899.5568.11427312080035617896.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=638
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There are no callers of vfs_dedupe_file_range_compare, so we might as
well make it a static helper and remove the export.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c    |  187 +++++++++++++++++++++++++---------------------------
 include/linux/fs.h |    3 -
 2 files changed, 91 insertions(+), 99 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index c0bcc1a20650..e4d295d0d236 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1752,6 +1752,97 @@ static int generic_remap_check_len(struct inode *inode_in,
 	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
 }
 
+/*
+ * Read a page's worth of file data into the page cache.  Return the page
+ * locked.
+ */
+static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
+{
+	struct page *page;
+
+	page = read_mapping_page(inode->i_mapping, offset >> PAGE_SHIFT, NULL);
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
@@ -1923,102 +2014,6 @@ loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
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
index 0b750e3f8f20..403860b25725 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1849,9 +1849,6 @@ extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 extern loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
-extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
-					 struct inode *dest, loff_t destoff,
-					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,

