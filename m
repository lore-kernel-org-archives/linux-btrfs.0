Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC0BC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 211DA2150D
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nfOS5n41"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 211DA2150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbeJJHab (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeJJHab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08wZ1138901;
        Wed, 10 Oct 2018 00:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=89x/kON88z0SWLBhLOQF02OXzgiCMuZXQJYo9kVK6z4=;
 b=nfOS5n41uY8VFNV1Dqq86DJ6FjJJDSrNYuZdCYjzRZHTIi1CmUcQsjEtk3TVrh1klc75
 In8sMLziz4DbzwtZtLgCpr8JNn+GgXPgwJN7Fy8Ho95jFZN3JfaksPWf170UB50qVbYl
 3pjL3W6JIh3S5WuuHOSllQ2l1WBT7ST0qoWGzAnMxMA6H5mGf0VTOV5V49dYJIKHQI/g
 SB/fEYBMLvxduLDTqa2YExii0U+p26uOYXqtlaM6jGfIdKEEWl0O8EZJX5eFWXtfefFu
 mLHlG0Gef8Dosk4QDuYXmtDpwqsrIZUyhOdwuGaRm+l8OJ0ragrShZF0YQ+rjgF4pq5d hQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mxn0q0tfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0AlUT030521
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:10:47 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0Al7g002699;
        Wed, 10 Oct 2018 00:10:47 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:10:47 +0000
Subject: [PATCH 01/25] xfs: add a per-xfs trace_printk macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:10:45 -0700
Message-ID: <153913024554.32295.8692450593333636905.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a "xfs_tprintk" macro so that developers can use trace_printk to
print out arbitrary debugging information with the XFS device name
attached to the trace output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 246d3e989c6c..c3d9546b138c 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -99,4 +99,9 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
 #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
 
+/* trace printk version of xfs_err and friends */
+#define xfs_tprintk(mp, fmt, args...) \
+	trace_printk("dev %d:%d " fmt, MAJOR((mp)->m_super->s_dev), \
+			MINOR((mp)->m_super->s_dev), ##args)
+
 #endif	/* __XFS_ERROR_H__ */

