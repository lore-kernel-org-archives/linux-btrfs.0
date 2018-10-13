Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681BEC6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFFB20868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QLAlO+oU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AFFB20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbeJMHnh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:43:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35644 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbeJMHng (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:43:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D03xw9143588;
        Sat, 13 Oct 2018 00:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0eMENz0xNhmHfEQz6xYs7euXYnzzeWKWI3aBWCtEoDg=;
 b=QLAlO+oUAaMXeV7DCIZKiwC/Y8nT7kt+X2XFrc2aMWjchKzJMosE+wqRl6CyqyD8POb9
 S5i9J6lbYBWP2GjfF7EAhBTJzmljWmK/QVyXKT2Sw25GhOq/yfIEk768cf+1PlxaO+Wt
 QwDyxx/BNzCcM01YJV0wNLyPpsQGu8S5b8ehSH09yQ1FG9mrnehdQ2td8Y1fz505f0s+
 VRI44pPC4mc5C8mLKf7ILkaylwo4j7H0KKdPwQA6c9AMSCQ1++zoONmNlIkrFS6VpmD8
 ak5wmxNU8t2G76GfKSNd4vdTz6y3ahgqkzwCDsmhU79v6UFNsvSnHXy8mdSL2F9a6Yp2 cw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mxmfudq2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:42 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08eBa027485
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:41 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08eqG020410;
        Sat, 13 Oct 2018 00:08:40 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:08:40 +0000
Subject: [PATCH 25/25] xfs: remove redundant remap partial EOF block checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:08:39 -0700
Message-ID: <153938931898.8361.12558032149746338745.stgit@magnolia>
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

Now that we've moved the partial EOF block checks to the VFS helpers, we
can remove the redundantn functionality from XFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c |   20 --------------------
 1 file changed, 20 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 66a8ddb9c058..709735880efb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1307,8 +1307,6 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
-	bool			is_dedupe = (remap_flags & RFR_SAME_DATA);
-	u64			blkmask = i_blocksize(inode_in) - 1;
 	ssize_t			ret;
 
 	/* Lock both files against IO */
@@ -1336,24 +1334,6 @@ xfs_reflink_remap_prep(
 	if (ret <= 0)
 		goto out_unlock;
 
-	/*
-	 * If the dedupe data matches, chop off the partial EOF block
-	 * from the source file so we don't try to dedupe the partial
-	 * EOF block.
-	 */
-	if (is_dedupe) {
-		*len &= ~blkmask;
-	} else if (*len & blkmask) {
-		/*
-		 * The user is attempting to share a partial EOF block,
-		 * if it's inside the destination EOF then reject it.
-		 */
-		if (pos_out + *len < i_size_read(inode_out)) {
-			ret = -EINVAL;
-			goto out_unlock;
-		}
-	}
-
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)

