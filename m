Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BC0C677FF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 16:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42C22204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 16:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sRNvrp1H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42C22204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbeJKXdc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 19:33:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59554 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbeJKXdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:33:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9BFwrwO100523;
        Thu, 11 Oct 2018 16:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gkVhvhJ2FlIJCkRLGBsRJI9E1SulUdIEyvkWVq3Hd8U=;
 b=sRNvrp1HpIdINQ7BZZoj454zbx/vW2qogr4KaN8dRCWM5kQ6JAMEK9QYrEKfvFYVQdq2
 N07FcRpeOjJF2DkOFLhazhZiopEcBPe0og7JMvzTBH6x5tT+8k/DUeyfhxXFr2kMjh8D
 gC7LePcPZFZ0xElMdN8XvfRenBAlEmH2T3gaa81H9H9SYiv5dDoaM3Ay3QDw5W1TEq+D
 51ezOVZ/zb1Q5aCoDHy7rxEJm2AC8kzTOvyk9YZp6iqbEMZ4MzoVJ0KQLYpI5aX2S2K6
 9j+E8ZbLmIFneUkV81d6kpztiY4yhCaR8Qtudzat8zfZniKMS6rErsnkyWEuJOgzilEv RA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mxmfu5g1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 16:05:36 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9BG5UQ3020141
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 16:05:31 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9BG5UrQ016472;
        Thu, 11 Oct 2018 16:05:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 16:05:29 +0000
Date:   Thu, 11 Oct 2018 09:05:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [PATCH v2 17/25] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181011160528.GB28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923126628.5546.3484461137192547927.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923126628.5546.3484461137192547927.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110154
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in a remap flag that enables the filesystem remap handler to
shorten remapping requests for callers that can handle it.  Now
copy_file_range can report partial success (in case we run up against
alignment problems, resource limits, etc.).

We also enable CAN_SHORTEN for fideduperange to maintain existing
userspace-visible behavior where xfs/btrfs shorten the dedupe range to
avoid stale post-eof data exposure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
v2: fix missing WARN_ON_ONCE and update changelog
---
 fs/read_write.c    |   17 ++++++++++-------
 include/linux/fs.h |    7 +++++--
 mm/filemap.c       |   16 ++++++++++++----
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6ec908f9a69b..9d33f0a14720 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1593,7 +1593,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 
 		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
-				min_t(loff_t, MAX_RW_COUNT, len), 0);
+				min_t(loff_t, MAX_RW_COUNT, len),
+				RFR_CAN_SHORTEN);
 		if (cloned > 0) {
 			ret = cloned;
 			goto done;
@@ -1804,16 +1805,18 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		 * If the user is attempting to remap a partial EOF block and
 		 * it's inside the destination EOF then reject it.
 		 *
-		 * We don't support shortening requests, so we can only reject
-		 * them.
+		 * If possible, shorten the request instead of rejecting it.
 		 */
 		if (is_dedupe)
 			ret = -EBADE;
 		else if (pos_out + *len < i_size_read(inode_out))
 			ret = -EINVAL;
 
-		if (ret)
-			return ret;
+		if (ret) {
+			if (!(remap_flags & RFR_CAN_SHORTEN))
+				return ret;
+			*len &= ~blkmask;
+		}
 	}
 
 	return 1;
@@ -2011,7 +2014,7 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 {
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA));
+	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA | RFR_CAN_SHORTEN));
 
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
@@ -2112,7 +2115,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
 		deduped = vfs_dedupe_file_range_one(file, off, dst_file,
 						    info->dest_offset, len,
-						    0);
+						    RFR_CAN_SHORTEN);
 		if (deduped == -EBADE)
 			info->status = FILE_DEDUPE_RANGE_DIFFERS;
 		else if (deduped < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b9c314f9d5a4..57cb56bbc30a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1726,14 +1726,17 @@ struct block_device_operations;
  *
  * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
  * RFR_TO_SRC_EOF: remap to the end of the source file
+ * RFR_CAN_SHORTEN: caller can handle a shortened request
  */
 #define RFR_SAME_DATA		(1 << 0)
 #define RFR_TO_SRC_EOF		(1 << 1)
+#define RFR_CAN_SHORTEN		(1 << 2)
 
-#define RFR_VALID_FLAGS		(RFR_SAME_DATA | RFR_TO_SRC_EOF)
+#define RFR_VALID_FLAGS		(RFR_SAME_DATA | RFR_TO_SRC_EOF | \
+				 RFR_CAN_SHORTEN)
 
 /* Implemented by the VFS, so these are advisory. */
-#define RFR_VFS_FLAGS		(RFR_TO_SRC_EOF)
+#define RFR_VFS_FLAGS		(RFR_TO_SRC_EOF | RFR_CAN_SHORTEN)
 
 /*
  * Filesystem remapping implementations should call this helper on their
diff --git a/mm/filemap.c b/mm/filemap.c
index 369cfd164e90..bccbd3621238 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3051,8 +3051,12 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	if (pos_in + count == size_in) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
-		if (!IS_ALIGNED(count, bs))
-			return -EINVAL;
+		if (!IS_ALIGNED(count, bs)) {
+			if (remap_flags & RFR_CAN_SHORTEN)
+				count = ALIGN_DOWN(count, bs);
+			else
+				return -EINVAL;
+		}
 
 		bcount = count;
 	}
@@ -3063,10 +3067,14 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	    pos_out < pos_in + bcount)
 		return -EINVAL;
 
-	/* For now we don't support changing the length. */
-	if (*req_count != count)
+	/*
+	 * We shortened the request but the caller can't deal with that, so
+	 * bounce the request back to userspace.
+	 */
+	if (*req_count != count && !(remap_flags & RFR_CAN_SHORTEN))
 		return -EINVAL;
 
+	*req_count = count;
 	return 0;
 }
 
