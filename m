Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30CDC64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ACF920834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vVvWU7WN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ACF920834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbeJEHm0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:42:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHm0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iJ61196548;
        Fri, 5 Oct 2018 00:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QM2Rrp77Yoieah8c6gfe0qs2PRKe81/IdXFPX3G3nws=;
 b=vVvWU7WNFD/LWbbg24u9ewOVIjX36s7XZAfY7SFMM+SqZ6v7iVFue5UVUO2oOtWx+OfU
 E0BzHTQk850aZMtfJUeFELINQJiG275x5JHIRB46cI7+UgiYWUvNrTbcOs07S9qPfOWw
 H21+BRab8lapyikOz+N2BvogzM3b9t6LnVZGpJeM9Oy4ubxcrfCBoPbRoblKa95SZEZ7
 HeSGQQM9ITDpxpJPKYYMZ8ImtJJY7ZqMpWLvz7sAVszovZ8vhz+gb1qNXPhLvHOigCqj
 MvfKG5zKaoeiGD17Ejzimt0+7Oa4FH8sUF6CRgJgk9owDZb0odZjTKkTNjw3KadndbCg CA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mt21rfk25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:46:15 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w950k9di007744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:46:09 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w950k9Va014954;
        Fri, 5 Oct 2018 00:46:09 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:46:08 +0000
Subject: [PATCH 12/15] vfs: implement opportunistic short dedupe
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:46:01 -0700
Message-ID: <153870036143.29072.11970142092673351715.stgit@magnolia>
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

For a given dedupe request, the bytes_deduped field in the control
structure tells userspace if we managed to deduplicate some, but not all
of, the requested regions starting from the file offsets supplied.
However, due to sloppy coding, the current dedupe code returns
FILE_DEDUPE_RANGE_DIFFERS if any part of the range is different.
Fix this so that we can actually support partial request completion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |   44 +++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |    2 +-
 2 files changed, 36 insertions(+), 10 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 292d68c2f47c..9be9f261edd2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1781,13 +1781,11 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 	 * Check that the extents are the same.
 	 */
 	if (is_dedupe) {
-		bool		is_same = false;
-
 		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
-				inode_out, pos_out, *len, &is_same);
+				inode_out, pos_out, len);
 		if (ret)
 			return ret;
-		if (!is_same)
+		if (*len == 0)
 			return -EBADE;
 	}
 
@@ -1872,13 +1870,30 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 	return page;
 }
 
+static unsigned int vfs_dedupe_memcmp(const char *s1, const char *s2,
+				      unsigned int cmp_len)
+{
+	const char *orig_s1 = s1;
+	const char *e1 = s1 + cmp_len;
+	const char *e2 = s2 + cmp_len;
+
+	while (s1 < e1 && s2 < e2) {
+		if (*s1 != *s2)
+			break;
+		s1++;
+		s2++;
+	}
+
+	return s1 - orig_s1;
+}
+
 /*
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
  */
 int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 				  struct inode *dest, loff_t destoff,
-				  loff_t len, bool *is_same)
+				  loff_t *req_len)
 {
 	loff_t src_poff;
 	loff_t dest_poff;
@@ -1886,8 +1901,11 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
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
@@ -1897,7 +1915,7 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		dest_poff = destoff & (PAGE_SIZE - 1);
 		cmp_len = min(PAGE_SIZE - src_poff,
 			      PAGE_SIZE - dest_poff);
-		cmp_len = min(cmp_len, len);
+		cmp_len = min_t(loff_t, cmp_len, len);
 		if (cmp_len <= 0)
 			goto out_error;
 
@@ -1919,7 +1937,10 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		flush_dcache_page(src_page);
 		flush_dcache_page(dest_page);
 
-		if (memcmp(src_addr + src_poff, dest_addr + dest_poff, cmp_len))
+		cmp_same = vfs_dedupe_memcmp(src_addr + src_poff,
+					     dest_addr + dest_poff, cmp_len);
+		same_len += cmp_same;
+		if (cmp_same != cmp_len)
 			same = false;
 
 		kunmap_atomic(dest_addr);
@@ -1937,7 +1958,12 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		len -= cmp_len;
 	}
 
-	*is_same = same;
+	/*
+	 * If less than the whole range matched, we have to back down to the
+	 * nearest block boundary.
+	 */
+	if (*req_len != same_len)
+		*req_len = ALIGN_DOWN(same_len, dest->i_sb->s_blocksize);
 	return 0;
 
 out_error:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index eb35363478e5..490128b84d10 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1840,7 +1840,7 @@ extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
-					 loff_t len, bool *is_same);
+					 loff_t *len);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 extern s64 vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,

