Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E498C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D416A2098A
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UTafA38i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D416A2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbeJEHlm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:41:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbeJEHll (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950icGB047249;
        Fri, 5 Oct 2018 00:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5U4JyjCHEajqV3UK0uH0HPOVrlUriwzUqenNqfb1hII=;
 b=UTafA38iLsrKcCnkxVQMZLtbOG1mIkWRv6UwIWYRRTxl4zBNCQguczoi9qHn7b64HNSZ
 rPRyJwEAQxYYmXapIqZCJ/6xYUgrVwYeoJbsVVD4PF+lYjG3I/UrZ6c3knz7sj9RtbOs
 vrx571q0JYcL+PKPlu7Kfh37FDA45py2apNrstDOmNweDuo3FsHIzrNo/NJzWIaVvdxR
 IYWf4qKeVq/XSjKTeFtXl3hUqF2GRehD0YH+OkJfdOc7CXzGzOieACJb0BDaHUXw6xtH
 9DYzRNpFkbf5f1kkh+106T7zjKN5DqTA7Ycst8SFMd2zLwzdzGN4dng6UjRHQNOpTrAj 2A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mt1bqfkw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:30 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w950jUtN006089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:30 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w950jTpX011715;
        Fri, 5 Oct 2018 00:45:29 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:45:29 +0000
Subject: [PATCH 07/15] vfs: skip zero-length dedupe requests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:21 -0700
Message-ID: <153870032167.29072.11158511021942868400.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=729
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother calling the filesystem for a zero-length dedupe request;
we can return zero and exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index 973d3da78c09..99b2f809180c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1966,6 +1966,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (!dst_file->f_op->dedupe_file_range)
 		goto out_drop_write;
 
+	if (len == 0) {
+		ret = 0;
+		goto out_drop_write;
+	}
+
 	ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
 						dst_file, dst_pos, len);
 out_drop_write:

