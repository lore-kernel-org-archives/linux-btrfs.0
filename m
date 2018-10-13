Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826E7C6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF6F20868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ic968xdb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FF6F20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbeJMHm4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:42:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34842 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbeJMHm4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:42:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D0428p143613;
        Sat, 13 Oct 2018 00:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=y5SA1q09PlxlYakQ5hgDwBmKYx7ptm+DDCmNZyuOEOQ=;
 b=Ic968xdb9NHeSzipxiKfpzW8wt6h1oOp/woIQkavl98yJvoC8zasjZFjRpoUC4ahoKMJ
 fBA+BEAT3N9mEwtvDbarHh3shXwCDtwPyTV3GNn1VDVzJvDFfKSIXzhmN5w8E9MDxdLG
 q/OvcjT9hDAnurMH6yWgTxt5t3Ha6C+wACMqRxPh0UTCCYY86nq80PXXJAuhGixLm81y
 WngZXQHd+sm7efNxSxtruYtUxtaCKvQndYvc2YLaYOTXFlcZSH1wXOLCnepdR3mstYdr
 sEqiYeQTV6xeu+7jQjDfu30tLNXsAn8EQO7v98UBDFUN6GL1n+hwLzgStPUEFk0V1Jcj aQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mxmfudq07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:01 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D080ZC020625
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:00 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9D07xkx019300;
        Sat, 13 Oct 2018 00:07:59 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:07:59 +0000
Subject: [PATCH 19/25] vfs: implement opportunistic short dedupe
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:07:57 -0700
Message-ID: <153938927786.8361.10345203650384514542.stgit@magnolia>
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

For a given dedupe request, the bytes_deduped field in the control
structure tells userspace if we managed to deduplicate some, but not all
of, the requested regions starting from the file offsets supplied.
However, due to sloppy coding, the current dedupe code returns
FILE_DEDUPE_RANGE_DIFFERS if any part of the range is different.
Fix this so that we can actually support partial request completion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c    |   48 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h |    7 +++++--
 2 files changed, 43 insertions(+), 12 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index ce3d5c4b1d34..edd2e9ceb71b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1737,13 +1737,26 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 	return page;
 }
 
+static unsigned int vfs_dedupe_memcmp(const char *s1, const char *s2,
+				      unsigned int len)
+{
+	const char *orig_s1;
+
+	for (orig_s1 = s1; len > 0; s1++, s2++, len--)
+		if (*s1 != *s2)
+			break;
+
+	return s1 - orig_s1;
+}
+
 /*
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
  */
 static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
-					 loff_t len, bool *is_same)
+					 loff_t *req_len,
+					 unsigned int remap_flags)
 {
 	loff_t src_poff;
 	loff_t dest_poff;
@@ -1751,8 +1764,11 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 	void *dest_addr;
 	struct page *src_page;
 	struct page *dest_page;
-	loff_t cmp_len;
+	loff_t len = *req_len;
+	loff_t same_len = 0;
 	bool same;
+	unsigned int cmp_len;
+	unsigned int cmp_same;
 	int error;
 
 	error = -EINVAL;
@@ -1762,7 +1778,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		dest_poff = destoff & (PAGE_SIZE - 1);
 		cmp_len = min(PAGE_SIZE - src_poff,
 			      PAGE_SIZE - dest_poff);
-		cmp_len = min(cmp_len, len);
+		cmp_len = min_t(loff_t, cmp_len, len);
 		if (cmp_len <= 0)
 			goto out_error;
 
@@ -1784,7 +1800,10 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		flush_dcache_page(src_page);
 		flush_dcache_page(dest_page);
 
-		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+		cmp_same = vfs_dedupe_memcmp(src_addr + src_poff,
+					     dest_addr + dest_poff, cmp_len);
+		same_len += cmp_same;
+		if (cmp_same != cmp_len)
 			same = false;
 
 		kunmap_atomic(dest_addr);
@@ -1802,7 +1821,17 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		len -= cmp_len;
 	}
 
-	*is_same = same;
+	/*
+	 * If less than the whole range matched, we have to back down to the
+	 * nearest block boundary.
+	 */
+	if (*req_len != same_len) {
+		if (!(remap_flags & RFR_SHORT_DEDUPE))
+			return -EBADE;
+
+		*req_len = ALIGN_DOWN(same_len, dest->i_sb->s_blocksize);
+	}
+
 	return 0;
 
 out_error:
@@ -1881,13 +1910,11 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	 * Check that the extents are the same.
 	 */
 	if (is_dedupe) {
-		bool		is_same = false;
-
 		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
-				inode_out, pos_out, *len, &is_same);
+				inode_out, pos_out, len, remap_flags);
 		if (ret)
 			return ret;
-		if (!is_same)
+		if (*len == 0)
 			return -EBADE;
 	}
 
@@ -2013,7 +2040,8 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 {
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA | RFR_CAN_SHORTEN));
+	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA | RFR_CAN_SHORTEN |
+				     RFR_SHORT_DEDUPE));
 
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f0603ed007e9..18b6db85ab64 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1727,16 +1727,19 @@ struct block_device_operations;
  * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
  * RFR_TO_SRC_EOF: remap to the end of the source file
  * RFR_CAN_SHORTEN: caller can handle a shortened request
+ * RFR_SHORT_DEDUPE: deduplicate from byte 0 until the file data don't match
  */
 #define RFR_SAME_DATA		(1 << 0)
 #define RFR_TO_SRC_EOF		(1 << 1)
 #define RFR_CAN_SHORTEN		(1 << 2)
+#define RFR_SHORT_DEDUPE	(1 << 3)
 
 #define RFR_VALID_FLAGS		(RFR_SAME_DATA | RFR_TO_SRC_EOF | \
-				 RFR_CAN_SHORTEN)
+				 RFR_CAN_SHORTEN | RFR_SHORT_DEDUPE)
 
 /* Implemented by the VFS, so these are advisory. */
-#define RFR_VFS_FLAGS		(RFR_TO_SRC_EOF | RFR_CAN_SHORTEN)
+#define RFR_VFS_FLAGS		(RFR_TO_SRC_EOF | RFR_CAN_SHORTEN | \
+				 RFR_SHORT_DEDUPE)
 
 /*
  * Filesystem remapping implementations should call this helper on their

