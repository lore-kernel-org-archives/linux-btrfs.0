Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DDCECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68467213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q4NysuBL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68467213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbeJRGpP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:45:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbeJRGpP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:45:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMiGVl040211;
        Wed, 17 Oct 2018 22:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LiozndoqC/TzvqN9AZSX3PUuVQc7boe5NscE8EdW/X4=;
 b=q4NysuBLWlyn5Azt58kZ18x53W7uwDuEmMqu1CDI5KXa+AWrw+CeiYqw3+cYFXUzQwd9
 oBqKgi6yAHhBEp+hZYU3Yc7nM0219K3ra0hekc4VijOKpbOujxXFwoXbVsrTwf8ckQ6Q
 7RtWE5pCzdKO9Xz201SEMNDLXkryVXkaMac/K/+xEY4034riBKPEniLJecgnkMi8/rs4
 rGNILnjfCf56jRKr5v2X8xC7LChch+h3BL2JX9RQ0l0dZfnKGdx4O3X0EuhlNDiwUGVK
 VG48MTZp75WfXupTPSpNFfm0a6IGSfwp5AopBqjaJ0ZN3CmzWHZx7g2BBWpKg46EIGnH yQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384ua071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:47:20 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMlFA2008571
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:47:16 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMlF9p031923;
        Wed, 17 Oct 2018 22:47:15 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:47:14 -0700
Subject: [PATCH 25/29] xfs: clean up xfs_reflink_remap_blocks call site
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:47:13 -0700
Message-ID: <153981643329.5568.5878961664707094374.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the offset <-> blocks unit conversions into
xfs_reflink_remap_blocks to make the call site less ugly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e8e86646bb4b..79dec457f7fb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1119,16 +1119,23 @@ xfs_reflink_remap_extent(
 STATIC int
 xfs_reflink_remap_blocks(
 	struct xfs_inode	*src,
-	xfs_fileoff_t		srcoff,
+	loff_t			pos_in,
 	struct xfs_inode	*dest,
-	xfs_fileoff_t		destoff,
-	xfs_filblks_t		len,
-	xfs_off_t		new_isize)
+	loff_t			pos_out,
+	loff_t			remap_len)
 {
 	struct xfs_bmbt_irec	imap;
+	xfs_fileoff_t		srcoff;
+	xfs_fileoff_t		destoff;
+	xfs_filblks_t		len;
+	xfs_filblks_t		range_len;
+	xfs_off_t		new_isize = pos_out + remap_len;
 	int			nimaps;
 	int			error = 0;
-	xfs_filblks_t		range_len;
+
+	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
+	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
+	len = XFS_B_TO_FSB(src->i_mount, remap_len);
 
 	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
 	while (len) {
@@ -1143,7 +1150,7 @@ xfs_reflink_remap_blocks(
 		error = xfs_bmapi_read(src, srcoff, len, &imap, &nimaps, 0);
 		xfs_iunlock(src, lock_mode);
 		if (error)
-			goto err;
+			break;
 		ASSERT(nimaps == 1);
 
 		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_IO_OVERWRITE,
@@ -1157,11 +1164,11 @@ xfs_reflink_remap_blocks(
 		error = xfs_reflink_remap_extent(dest, &imap, destoff,
 				new_isize);
 		if (error)
-			goto err;
+			break;
 
 		if (fatal_signal_pending(current)) {
 			error = -EINTR;
-			goto err;
+			break;
 		}
 
 		/* Advance drange/srange */
@@ -1170,10 +1177,8 @@ xfs_reflink_remap_blocks(
 		len -= range_len;
 	}
 
-	return 0;
-
-err:
-	trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
+	if (error)
+		trace_xfs_reflink_remap_blocks_error(dest, error, _RET_IP_);
 	return error;
 }
 
@@ -1396,8 +1401,6 @@ xfs_reflink_remap_range(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	struct xfs_mount	*mp = src->i_mount;
-	xfs_fileoff_t		sfsbno, dfsbno;
-	xfs_filblks_t		fsblen;
 	xfs_extlen_t		cowextsize;
 	ssize_t			ret;
 
@@ -1415,11 +1418,7 @@ xfs_reflink_remap_range(
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
-	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
-	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
-	fsblen = XFS_B_TO_FSB(mp, len);
-	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
-			pos_out + len);
+	ret = xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len);
 	if (ret)
 		goto out_unlock;
 

