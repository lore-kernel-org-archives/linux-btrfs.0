Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66050C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A85020834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lj6RzwWQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A85020834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbeJEHmC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:42:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHmB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950itcv047314;
        Fri, 5 Oct 2018 00:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EiA1/9mtUOhGz+UfuUBmi2WME0xF8a4587ET4ccH3js=;
 b=Lj6RzwWQZahWbe0SqzPTK3r+DtEqCJ4g5i7jsKNGl1qcJ5McyPDV29+cRn7r3eBnS+bC
 JtpvWg46ATsP1Lw821hmbAHBbnm9TNwP5L27U9BiOgY6bmlMX9sw/4xaRXFWijJcLN78
 pfXbvmMZw0dEigjHr5Z1uKBPcDATtyRH5eWNxtKYd+cAo/YUCF3ZvAxFcJLYvx0W1X8G
 1djdOMsh0gFRZxuBfebKTwHFpEKTL10HsirdNG90gDRA7pf11XlBuL7BlmgxIwwOOOg6
 dM/6HOT8Q4IsTTQS/7h2GFPa4Qez6M2oGml/240WOoeSij6ZmU39691qnvYWj/XkUE2J uA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mt1bqfkxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:50 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950jnx5006084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:49 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w950jnoe014773;
        Fri, 5 Oct 2018 00:45:49 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Oct 2018 17:45:49 -0700
Subject: [PATCH 10/15] vfs: make cloning to source file eof more explicit
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:48 -0700
Message-ID: <153870034823.29072.4817036324117498634.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=688
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new CLONE_RANGE_EOF flag to explicitly declare that the caller
wants the clone implementation to set *len appropriately once the files
are locked.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 7cfff497263b..4eaea52f70a8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1747,11 +1747,12 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 
 	isize = i_size_read(inode_in);
 
-	/* Zero length dedupe exits immediately; reflink goes to EOF. */
-	if (*len == 0) {
-		if (is_dedupe || pos_in == isize)
-			return 0;
-		if (pos_in > isize)
+	/*
+	 * If the caller asked to go all the way to the end of the source file,
+	 * set *len now that we have the file locked.
+	 */
+	if ((flags & CLONERANGE_EOF) && *len == 0) {
+		if (pos_in >= isize)
 			return -EINVAL;
 		*len = isize - pos_in;
 	}
@@ -1836,6 +1837,9 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
+	if (len == 0)
+		flags |= CLONERANGE_EOF;
+
 	cloned = file_in->f_op->clone_file_range(file_in, pos_in,
 			file_out, pos_out, len, flags);
 	if (cloned < 0)

