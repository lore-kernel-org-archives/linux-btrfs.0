Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DBBC71123
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5975920895
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sTyoOz5D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5975920895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJMHna (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:43:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbeJMHna (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:43:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D03xtF104705;
        Sat, 13 Oct 2018 00:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=j1f7F7pQmBhjlVszrIyTzR7x7TmBVWaeEtlT+nNj2qg=;
 b=sTyoOz5DFRwE8hHpFLjJAntrQ/eP82020PpQF3A1xT0QhtpbxfK/IwemWapeHNbPqbdy
 w+MVAhh3wpTLfewOos41Q9+83VHaLYZCG31DaxtdczGPN4Y/YMNRLyUt0MOF1fCmdncq
 5qO6QKeAXCyUcn1EROOqX1jMZfo6ljoKQDQ3W7ibgjgdjScKEku0Ns+WvDUWgQWme78J
 hJtToPlQ8RPOUsMR+dd8QKZ61bAPhsUqWtLuu1KCwfBusdMeW9tGD7idviFM45f+sE6C
 6PG+J/VTGSv/31l3EV3lhLlQFzoV+Qcg5RPKXw719XP4Lqi9PQCgrG2n2ae4FMDDCQlT +A== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mxnprnfnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08YjH027225
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:08:34 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9D08YdJ020284;
        Sat, 13 Oct 2018 00:08:34 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:08:33 +0000
Subject: [PATCH 24/25] xfs: support returning partial reflink results
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:08:32 -0700
Message-ID: <153938931226.8361.7365948775364411156.stgit@magnolia>
In-Reply-To: <153938912912.8361.13446310416406388958.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9044 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810130000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Back when the XFS reflink code only supported clone_file_range, we were
only able to return zero or negative error codes to userspace.  However,
now that copy_file_range (which returns bytes copied) can use XFS'
clone_file_range, we have the opportunity to return partial results.
For example, if userspace sends a 1GB clone request and we run out of
space halfway through, we at least can tell userspace that we completed
512M of that request like a regular write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |    5 +----
 fs/xfs/xfs_reflink.c |   20 +++++++++++++++-----
 fs/xfs/xfs_reflink.h |    2 +-
 3 files changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bc9e94bcb7a3..b2b15b8dc4a1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -928,14 +928,11 @@ xfs_file_remap_range(
 	loff_t		len,
 	unsigned int	remap_flags)
 {
-	int		ret;
-
 	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
 		return -EINVAL;
 
-	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	return ret < 0 ? ret : len;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e1592e751cc2..66a8ddb9c058 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1123,6 +1123,7 @@ xfs_reflink_remap_blocks(
 	struct xfs_inode	*dest,
 	xfs_fileoff_t		destoff,
 	xfs_filblks_t		len,
+	xfs_filblks_t		*remapped_len,
 	xfs_off_t		new_isize)
 {
 	struct xfs_bmbt_irec	imap;
@@ -1130,6 +1131,7 @@ xfs_reflink_remap_blocks(
 	int			error = 0;
 	xfs_filblks_t		range_len;
 
+	*remapped_len = 0;
 	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
 	while (len) {
 		uint		lock_mode;
@@ -1168,6 +1170,7 @@ xfs_reflink_remap_blocks(
 		srcoff += range_len;
 		destoff += range_len;
 		len -= range_len;
+		*remapped_len += range_len;
 	}
 
 	return 0;
@@ -1391,7 +1394,7 @@ xfs_reflink_remap_prep(
 /*
  * Link a range of blocks from one file to another.
  */
-int
+loff_t
 xfs_reflink_remap_range(
 	struct file		*file_in,
 	loff_t			pos_in,
@@ -1406,9 +1409,10 @@ xfs_reflink_remap_range(
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	struct xfs_mount	*mp = src->i_mount;
 	xfs_fileoff_t		sfsbno, dfsbno;
-	xfs_filblks_t		fsblen;
+	xfs_filblks_t		fsblen, remappedfsb = 0;
+	loff_t			remapped_bytes = 0;
 	xfs_extlen_t		cowextsize;
-	ssize_t			ret;
+	int			ret;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return -EOPNOTSUPP;
@@ -1424,11 +1428,17 @@ xfs_reflink_remap_range(
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
+	if (len == 0) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
 	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
 	fsblen = XFS_B_TO_FSB(mp, len);
 	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
-			pos_out + len);
+			&remappedfsb, pos_out + len);
+	remapped_bytes = min_t(int64_t, len, XFS_FSB_TO_B(mp, remappedfsb));
 	if (ret)
 		goto out_unlock;
 
@@ -1451,7 +1461,7 @@ xfs_reflink_remap_range(
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
-	return ret;
+	return remapped_bytes > 0 ? remapped_bytes : ret;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index c3c46c276fe1..cbc26ff79a8f 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -27,7 +27,7 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
-extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
+extern loff_t xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, loff_t len,
 		unsigned int remap_flags);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,

