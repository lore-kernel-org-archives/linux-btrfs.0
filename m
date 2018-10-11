Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34105C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A0F2077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jiaPMQek"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6A0F2077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbeJKLk5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:40:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbeJKLk5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:40:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B4DsHP002714;
        Thu, 11 Oct 2018 04:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=GtHOAv/QF0y7KDuBC7HZvhRe0zfnNWbV0kEOmXhecBY=;
 b=jiaPMQekkirLHjdnXajmGlZYaH6AI90VeT9yzBHvNtkNFPFeOMCGxenmXX8If2+YeXQX
 QrOaiy1nnibe1CJ9gHV/8yR/ibiw2qh4XqgJtD9k5H2qu+pD8jvp+dpmsAV2B1FRWlZt
 5CLbIyDNqL+lhms66iPnQ29ghqBQJtqR9URBwyVgSjGHKeTUCjRDZouV3Za/mNOX2vom
 7tzCyt1CqRTl8OrrJaocWA7rGoZGR2Uk4xMgVcJ5Yf64Yfsc5Zw4wmkhVlh7e0KQEQ5J
 pcNS4WJtPiT863q3yPY5PseJfOvUocfrdP+3CBejMb/wtQm9vY9U6L3WQgnrfFuGzut/ nA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mxnpr996g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:15:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4FSHv023078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:15:28 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B4FS0j010121;
        Thu, 11 Oct 2018 04:15:28 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:15:27 +0000
Subject: [PATCH 25/25] xfs: remove redundant remap partial EOF block checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:15:26 -0700
Message-ID: <153923132645.5546.97372209609060021.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've moved the partial EOF block checks to the VFS helpers, we
can remove the redundantn functionality from XFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   20 --------------------
 1 file changed, 20 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 12a1fe92454e..4450443f1148 100644
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

