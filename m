Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C6AC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900CA214FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hiaqHpxK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 900CA214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbeJJHd4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:33:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeJJHdz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:33:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A0E25O123304;
        Wed, 10 Oct 2018 00:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=izu6oMi2WH3dJKrh0/K4DYA0ov4dLCE6r3c64m1rEY8=;
 b=hiaqHpxKLXDkHyzghXC0JxNwAbk3XrhUDLnIx0m3srSfpW+iXlo38SIKxa5CBCEM4KlN
 oe0Fuwjk1h60oOMf3b7Vs5SWqxdwTGsOeCPW+LhR4K5mNhtzHGE8Mti4gdbtFahJtjOJ
 y3bg5MPn4Ev+FZDcTNC8MZ3T8Vbk9UCjVNJ4F2tvqEVSCBewblGiNQ6NM6iw1ZD7cjhf
 xhX+LAEWgiZtpOuxNhzMsl3naMHO31mpgtAGQLUB5fW70OEl6OOG89w3DR71x/l2h840
 pFMPVSTcUL22IybzVVZTw67V6mexwTNfDUxGhFSOO1baUmpz9UJA7lMZWJZUpvOHt/Af zA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mxmftrvss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:14:25 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0EJtd031498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:14:19 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9A0EJPb017991;
        Wed, 10 Oct 2018 00:14:19 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:14:19 +0000
Subject: [PATCH 20/25] vfs: implement opportunistic short dedupe
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:14:17 -0700
Message-ID: <153913045787.32295.7018909865132108315.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=982
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100001
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
 fs/read_write.c |   59 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 11 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 57627202bd50..8be3c3add030 100644
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
+		if (!(remap_flags & RFR_CAN_SHORTEN))
+			return -EINVAL;
+
+		*req_len = ALIGN_DOWN(same_len, dest->i_sb->s_blocksize);
+	}
+
 	return 0;
 
 out_error:
@@ -1879,13 +1908,11 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
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
 
@@ -1988,7 +2015,7 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 {
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags & ~(RFR_IDENTICAL_DATA));
+	WARN_ON_ONCE(remap_flags & ~(RFR_IDENTICAL_DATA | RFR_CAN_SHORTEN));
 
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
@@ -2037,6 +2064,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	int i;
 	int ret;
 	u16 count = same->dest_count;
+	unsigned int remap_flags = 0;
 	loff_t deduped;
 
 	if (!(file->f_mode & FMODE_READ))
@@ -2073,6 +2101,15 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		same->info[i].status = FILE_DEDUPE_RANGE_SAME;
 	}
 
+	/*
+	 * We can't allow the dedupe implementation to shorten the request if
+	 * there are multiple dedupe candidates because each candidate might
+	 * shorten the request by a different amount due to EOF and allocation
+	 * block size mismatches.
+	 */
+	if (count == 1)
+		remap_flags |= RFR_CAN_SHORTEN;
+
 	for (i = 0, info = same->info; i < count; i++, info++) {
 		struct fd dst_fd = fdget(info->dest_fd);
 		struct file *dst_file = dst_fd.file;
@@ -2089,7 +2126,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		deduped = vfs_dedupe_file_range_one(file, off, dst_file,
 						    info->dest_offset, len,
-						    0);
+						    remap_flags);
 		if (deduped == -EBADE)
 			info->status = FILE_DEDUPE_RANGE_DIFFERS;
 		else if (deduped < 0)

