Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA14ECDE3B
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37FB213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PpxfeYre"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37FB213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbeJRGm5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:42:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43714 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbeJRGm5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:42:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMiAUC048830;
        Wed, 17 Oct 2018 22:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=DsB/GfHe8rY/6K9TRDqJFG41++LpUZSoAdzvXmeEYVk=;
 b=PpxfeYreEHqJ6vcORlZ7iIwVkK/qS8IqoNykPQqre69vtU4Xd3mMLGx73BLRXmhUj9yE
 bl5c1Zx7soRvcZCcUcIQMnE2d+KFLETNzE4pOv08JEQpQf/oHVRBlnbCp5S7005rk94+
 jZbVYPaCT581APqiBmea6ZvLOALtEaVAPCXC1qMMiQSSr3HdBswEoGShXjh9gfiiUcUo
 /GHq3rrjiXKeak9arZrBjWtjMwkMWw6lGuXzOJbUdGw4SuXR/V6cXduazKzmcFA1UllG
 gCb1qV5B6TddpFw8dHzbdWy4YDxiW04Wxk0+Eu46plkevvvy0jch+urulROVmNFrWl4U AA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2n38nq9srq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:45:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMixj7006278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:44:59 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9HMiwrN028452;
        Wed, 17 Oct 2018 22:44:58 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:44:58 -0700
Subject: [PATCH 06/29] vfs: skip zero-length dedupe requests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:44:56 -0700
Message-ID: <153981629660.5568.10517610908803733732.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=754
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother calling the filesystem for a zero-length dedupe request;
we can return zero and exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index 0f0a6efdd502..f5395d8da741 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2009,6 +2009,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
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

