Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED686C6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9723D20868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rr6AY7BY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9723D20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbeJMHml (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:42:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbeJMHml (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:42:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D04VUQ143988;
        Sat, 13 Oct 2018 00:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hGJg7Mw2eDLP+J7yKVhYwcUJLtxNrIR1f+LqpGNW/UQ=;
 b=rr6AY7BYYBkvd8M4lgeVvqXmQnU6Ue9WmevUeehAkOKabX6x2z4Pu6mwXnUfHtFOfJKw
 svD1AuPIj9oqyd7loGDib3ppsbw6fpX5oBpLNucYdwEuWV05Jgn7Wz7vHv+l5ZRK/tEx
 JahBEhoV6Df1qubV/VrQ2dKpARFNPBxTaj0PZQcDPLgU6pwNben8sUnpsIaLsma+Ab2u
 C0/6u7ANd+bc6/2uXuIzE5LBqfWf/eFTM22uOHHH/3xVqUpvXxdJwlrr42NYnsR+tqEw
 6zeL9IiWsUrN2IBGSuMX3RuPpokHlAAWzj4bpyZophwr54HUcCcMCYjDu/ptesrHExtO 8Q== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mxmfudpyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D07kQR025497
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:46 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9D07kfm018360;
        Sat, 13 Oct 2018 00:07:46 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:07:45 +0000
Subject: [PATCH 17/25] vfs: enable remap callers that can handle short
 operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:07:44 -0700
Message-ID: <153938926421.8361.13101766265446494393.stgit@magnolia>
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
 fs/read_write.c    |   22 +++++++++++++++-------
 include/linux/fs.h |    7 +++++--
 mm/filemap.c       |   16 ++++++++++++----
 3 files changed, 32 insertions(+), 13 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index c02fc5144d15..86a8c2557d18 100644
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
@@ -1797,6 +1798,8 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Are we doing a partial EOF block remapping of some kind? */
 	if (*len & blkmask) {
+		loff_t	new_len = *len;
+
 		/*
 		 * If the dedupe data matches, chop off the partial EOF block
 		 * from the source file so we don't try to dedupe the partial
@@ -1804,11 +1807,16 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		 *
 		 * If the user is attempting to remap a partial EOF block and
 		 * it's inside the destination EOF then reject it.
+		 *
+		 * If possible, shorten the request instead of rejecting it.
 		 */
-		if (is_dedupe)
-			*len &= ~blkmask;
-		else if (pos_out + *len < i_size_read(inode_out))
-			return -EINVAL;
+		if (is_dedupe || pos_out + *len < i_size_read(inode_out))
+			new_len &= ~blkmask;
+
+		if (new_len != *len && !(remap_flags & RFR_CAN_SHORTEN))
+			return is_dedupe ? -EBADE : -EINVAL;
+
+		*len = new_len;
 	}
 
 	return 1;
@@ -2006,7 +2014,7 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 {
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA));
+	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA | RFR_CAN_SHORTEN));
 
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
@@ -2107,7 +2115,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 
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
 

