Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0FEC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111A9214FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zijFNAT9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 111A9214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbeJJHay (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeJJHax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08ekx138543;
        Wed, 10 Oct 2018 00:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=UPZ0d5EyyxBIdyb+/QZEk2VIco+d0Uqne8UVSJH846Y=;
 b=zijFNAT9z+gw/MI8d1eVXf3jMsCTgjhryhyCdeq6HhqEzQ1EtXkYHagwhAVTNqJJkaJo
 R9ZE0JZiE0Oa9smd0U066iCUML432vrYFnjzYfCnsHQQ2Fluq1zANB0SuT8talkjS/l4
 AFwIV8HLs5vBTY3V1YHgZjNfCfU1t6OqLbqHEtwrd6k+ccJbluWbQblZSFU6KORkLLfW
 jm4l9tdM+OSKrpky4EitobilSWcztg/PUhzQuPrteT8r3d+SjXkkgDXXr6KS1ZmuFuXP
 EA5ILI/AeOFLm4ZtxS/FQAvuiHvAo1X5y5+WkhJnAOYg9RlqNDQsbSSuDg16hhMqOU9x Ew== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0q0tgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0BMFB023816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:23 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9A0BMw9020784;
        Wed, 10 Oct 2018 00:11:22 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:11:21 +0000
Subject: [PATCH 06/25] vfs: strengthen checking of file range inputs to
 generic_remap_checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:11:20 -0700
Message-ID: <153913028015.32295.15993665528948323051.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
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
---
 mm/filemap.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)


diff --git a/mm/filemap.c b/mm/filemap.c
index 14041a8468ba..59056bd9c58a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2974,6 +2974,27 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 }
 EXPORT_SYMBOL(generic_write_checks);
 
+static int
+generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	/* Don't exceed the LFS limits. */
+	if (unlikely(pos + *count > MAX_NON_LFS &&
+				!(file->f_flags & O_LARGEFILE))) {
+		if (pos >= MAX_NON_LFS)
+			return -EFBIG;
+		*count = min(*count, MAX_NON_LFS - (uint64_t)pos);
+	}
+
+	/* Don't operate on ranges the page cache doesn't support. */
+	if (unlikely(pos >= inode->i_sb->s_maxbytes))
+		return -EFBIG;
+
+	*count = min(*count, inode->i_sb->s_maxbytes - (uint64_t)pos);
+	return 0;
+}
+
 /*
  * Performs necessary checks before doing a clone.
  *
@@ -2992,6 +3013,7 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	uint64_t bcount;
 	loff_t size_in, size_out;
 	loff_t bs = inode_out->i_sb->s_blocksize;
+	int ret;
 
 	/* The start of both ranges must be aligned to an fs block. */
 	if (!IS_ALIGNED(pos_in, bs) || !IS_ALIGNED(pos_out, bs))
@@ -3015,6 +3037,23 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	count = min(count, size_in - (uint64_t)pos_in);
 
+	/* Don't exceed RLMIT_FSIZE in the file we're writing into. */
+	if (limit != RLIM_INFINITY) {
+		if (pos_out >= limit) {
+			send_sig(SIGXFSZ, current, 0);
+			return -EFBIG;
+		}
+		count = min(count, limit - (uint64_t)pos_out);
+	}
+
+	ret = generic_remap_check_limits(file_in, pos_in, &count);
+	if (ret)
+		return ret;
+
+	ret = generic_remap_check_limits(file_out, pos_out, &count);
+	if (ret)
+		return ret;
+
 	/*
 	 * If the user wanted us to link to the infile's EOF, round up to the
 	 * next block boundary for this check.

