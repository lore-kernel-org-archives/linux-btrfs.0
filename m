Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3453CECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E88213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GpfsTTzn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9E88213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbeJRGo6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:44:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbeJRGo5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:44:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMjJCk190217;
        Wed, 17 Oct 2018 22:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SGDSArbiullpYs/XPOG6T2xvgHyk5haCgm1b67adURI=;
 b=GpfsTTzn2FDJOHVvdOCtMqCeAseCxfMgHNLE+mQwEdG77npdgHddYIEYM2/zi1ISAPsz
 R1VueayZv2tBM8+cEkl4KaeT6O+U0lPnv+Diw7fgZSrYBNQi2h3AVRgf2fKjOcCcPOln
 x7LBzYy72Lzr01waDkzXsU6XUS5fhmNhe9nJKTH6Cne3lb+e/iNbcI/fZOQwe3horA/e
 LVYfol8SX9g2G7c2dkZsQ8+z6G7oIt+lP09n8ih1aj9HxyqCjQD4CAZAlwC+oK5pc5iQ
 KlDXEvLyj0M+NlTzelagWWcojei/EswJTYptda+tlV835Uuo7rIkh9xzkDZrVifjCe6+ XA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2n39brhp9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:47:02 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMl2s7013248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:47:02 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMl1rL031780;
        Wed, 17 Oct 2018 22:47:01 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:47:01 -0700
Subject: [PATCH 23/29] xfs: add a per-xfs trace_printk macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:46:59 -0700
Message-ID: <153981641972.5568.6155004838582569988.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=966
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
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
 fs/xfs/xfs_error.h |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 246d3e989c6c..5caa8bdf6c38 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -76,6 +76,11 @@ extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
 		unsigned int tag_value);
 extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
 extern int xfs_errortag_clearall(struct xfs_mount *mp);
+
+/* trace printk version of xfs_err and friends */
+#define xfs_tprintk(mp, fmt, args...) \
+	trace_printk("dev %d:%d " fmt, MAJOR((mp)->m_super->s_dev), \
+			MINOR((mp)->m_super->s_dev), ##args)
 #else
 #define xfs_errortag_init(mp)			(0)
 #define xfs_errortag_del(mp)
@@ -83,6 +88,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define xfs_errortag_set(mp, tag, val)		(ENOSYS)
 #define xfs_errortag_add(mp, tag)		(ENOSYS)
 #define xfs_errortag_clearall(mp)		(ENOSYS)
+#define xfs_tprintk(mp, fmt, args...)		do { } while (0)
 #endif /* DEBUG */
 
 /*

