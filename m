Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07B9C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF212077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SEHdlmBH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CF212077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbeJKLie (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:38:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJKLie (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:38:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B496X1052689;
        Thu, 11 Oct 2018 04:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rYNys5t3mXrXHQI06sCGnidadi3Ilenga8cPevys5pA=;
 b=SEHdlmBHl1PEWtBx1kYYvDGijkTeRKt9mbK37pkwKSlP+xzGA8BzBE9l4HgH8pubHTCG
 3pXIVN3BGCuKto224oA4Qn7ERYh8BkALgWgbicwGwWlvGjw5lvRU7+0F4nvI9thzFSOf
 JVqSFtVuTgk+V/MQZKKqBncyCdybDsM8v1A2ijWRF+IrfraawhY3Sf9KsQULQ+tlK+pu
 wB8nr1eYYVV88+rBysG5TcdoeLzofefES9SVeYE3Im/yPvTfx/95sJ8bK0DFUcNRpbzN
 hOHuvbQCDVkknI0XktzKEZKNPlq9H9oZARJwaJ6ZNfdVXat/LSX2gc0MNhq6BqNixwoG nQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mxn0q9dub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:13:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4D2jD001922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:13:02 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4D1cT011595;
        Thu, 11 Oct 2018 04:13:01 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:13:01 +0000
Subject: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:12:54 -0700
Message-ID: <153923117420.5546.13317703807467393934.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=625
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110039
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A deduplication data corruption is exposed by fstests generic/505 on
XFS. It is caused by extending the block match range to include the
partial EOF block, but then allowing unknown data beyond EOF to be
considered a "match" to data in the destination file because the
comparison is only made to the end of the source file. This corrupts the
destination file when the source extent is shared with it.

The VFS remapping prep functions  only support whole block dedupe, but
we still need to appear to support whole file dedupe correctly.  Hence
if the dedupe request includes the last block of the souce file, don't
include it in the actual dedupe operation. If the rest of the range
dedupes successfully, then reject the entire request.  A subsequent
patch will enable us to shorten dedupe requests correctly.

When reflinking sub-file ranges, a data corruption can occur when the
source file range includes a partial EOF block. This shares the unknown
data beyond EOF into the second file at a position inside EOF, exposing
stale data in the second file.

If the reflink request includes the last block of the souce file, only
proceed with the reflink operation if it lands at or past the
destination file's current EOF. If it lands within the destination file
EOF, reject the entire request with -EINVAL and make the caller go the
hard way.  A subsequent patch will enable us to shorten reflink requests
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index d6e8e242a15f..8498991e2f33 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1723,6 +1723,7 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
+	u64 blkmask = i_blocksize(inode_in) - 1;
 	bool same_inode = (inode_in == inode_out);
 	int ret;
 
@@ -1785,6 +1786,27 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 			return -EBADE;
 	}
 
+	/* Are we doing a partial EOF block remapping of some kind? */
+	if (*len & blkmask) {
+		/*
+		 * If the dedupe data matches, don't try to dedupe the partial
+		 * EOF block.
+		 *
+		 * If the user is attempting to remap a partial EOF block and
+		 * it's inside the destination EOF then reject it.
+		 *
+		 * We don't support shortening requests, so we can only reject
+		 * them.
+		 */
+		if (is_dedupe)
+			ret = -EBADE;
+		else if (pos_out + *len < i_size_read(inode_out))
+			ret = -EINVAL;
+
+		if (ret)
+			return ret;
+	}
+
 	return 1;
 }
 EXPORT_SYMBOL(vfs_clone_file_prep);

