Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBA9C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063A12150C
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2eDQHC6W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 063A12150C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbeJJHdn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:33:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHdn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:33:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A0EDxM086695;
        Wed, 10 Oct 2018 00:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Nn9zgG7G0RlSFSy0VLmRndBF9S+1SvCJgEndO9+GibM=;
 b=2eDQHC6WJ553rjahcYxaCchlOIZC2rsx002DnL+bErYIlutVXMEJPwUYWKR035gC1hTZ
 7J0ZhaDWpqg99hxravevj4NxQ/IleUd0yvHkdP14aJCff2HSgCc6I5l63KbCUR2NUH0r
 S0uU9UdpgYNIQyjaC/qCb/bFOeMtbTV9zuxZdbRhL89ZjAl61gmNPHVMHzyaleYoli3T
 BnEoXWc9mXsUSsVpa+W24QzqouzA+yuBX0cTZ+Q0mtBR8m+SLBBzrogEXzVROwR9FIBM
 S7ApEHPqtFJiwbvj9x2Kuie3THLJv2mC1Z+jacGDkKTS0UfF4PKEkDuFqbRcLDRRjtxg sQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mxnpr0p8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:14:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0E6Bc032377
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:14:07 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0E6fg004026;
        Wed, 10 Oct 2018 00:14:06 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:14:05 +0000
Subject: [PATCH 18/25] vfs: enable remap callers that can handle short
 operations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:14:04 -0700
Message-ID: <153913044431.32295.9717425324455762449.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=860
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100001
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in a remap flag that enables the filesystem remap handler to
shorten remapping requests for callers that can handle it.  Now
copy_file_range can report partial success (in case we run up against
alignment problems, resource limits, etc.).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c    |    3 ++-
 include/linux/fs.h |    2 ++
 mm/filemap.c       |   16 ++++++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index a628fd9a47cf..8ed0aed81649 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1593,7 +1593,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 
 		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
-				min_t(loff_t, MAX_RW_COUNT, len), 0);
+				min_t(loff_t, MAX_RW_COUNT, len),
+				RFR_CAN_SHORTEN);
 		if (cloned >= 0) {
 			ret = cloned;
 			goto done;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9f90dcd4df3b..e0494d719ebc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1726,9 +1726,11 @@ struct block_device_operations;
  *
  * RFR_IDENTICAL_DATA: only remap if contents identical (i.e. deduplicate)
  * RFR_TO_SRC_EOF: remap to the end of the source file
+ * RFR_CAN_SHORTEN: caller can handle a shortened request
  */
 #define RFR_IDENTICAL_DATA	(1 << 0)
 #define RFR_TO_SRC_EOF		(1 << 1)
+#define RFR_CAN_SHORTEN		(1 << 2)
 
 struct iov_iter;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 2522737483de..2179d0204ee6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3064,8 +3064,12 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
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
@@ -3076,10 +3080,14 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
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
 

