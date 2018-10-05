Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A22C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8602D20854
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WLZ7Jw0g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8602D20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbeJEHlI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:41:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50678 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJEHlI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iITN029786;
        Fri, 5 Oct 2018 00:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=z5hrQwXNZpLcKPbjjCgBYGifQPO1xqGnU/7OLSOkauU=;
 b=WLZ7Jw0gRpEBI2wPgo8i3lkSlNZBHsAK+bqH+E4obCuZ/HS5uAmxZP1pITIHFmN7ZB58
 a73fgt6eS8iqCMVfko2p9erQ/GvgmYW7ZpGlIgYYnC2UdjEH/UJbI8yTaIGWH0Sj/Ewa
 Np9kDfBA/L60G+Ds0wWIa+muvv5wpAelbnbQNXMkLNe54lpif4gErmAK7YSnYR2Vg+PC
 7xDh2DBM3sqDaqKBFa/g8qSInh8oia4EvR3RvrNVfqsdwJUcV7/EJA73+UhPZu3hGAaD
 0F2fawNj11CgYIwdy+sQFelDXL8ZvS2BAMDXS0HxJLqMtpXPNYoxwvPH5V8aDgRLf3tq mA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mt0tu7neg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:44:56 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950itGX011434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:44:56 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w950itaL011323;
        Fri, 5 Oct 2018 00:44:55 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:44:55 +0000
Subject: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, Zorro Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date:   Thu, 04 Oct 2018 17:44:54 -0700
Message-ID: <153870029414.29072.6572683664719818617.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're reflinking between two files and the destination file range
is well beyond the destination file's EOF marker, zero any posteof
speculative preallocations in the destination file so that we don't
expose stale disk contents.  The previous strategy of trying to clear
the preallocations does not work if the destination file has the
PREALLOC flag set.

Uncovered by shared/010.

Reported-by: Zorro Lang <zlang@redhat.com>
Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 80ca9b6793cd..55da7e1154f4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1215,6 +1215,26 @@ xfs_reflink_remap_unlock(
 		inode_unlock_shared(inode_in);
 }
 
+/*
+ * If we're reflinking to a point past the destination file's EOF, we must
+ * zero any speculative post-EOF preallocations that sit between the old EOF
+ * and the destination file offset.
+ */
+static int
+xfs_reflink_zero_posteof(
+	struct xfs_inode	*ip,
+	loff_t			pos)
+{
+	loff_t			isize = i_size_read(VFS_I(ip));
+
+	if (pos <= isize)
+		return 0;
+
+	trace_xfs_zero_eof(ip, isize, pos - isize);
+	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
+			&xfs_iomap_ops);
+}
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
@@ -1267,15 +1287,12 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	/*
-	 * Clear out post-eof preallocations because we don't have page cache
-	 * backing the delayed allocations and they'll never get freed on
-	 * their own.
+	 * Zero existing post-eof speculative preallocations in the destination
+	 * file.
 	 */
-	if (xfs_can_free_eofblocks(dest, true)) {
-		ret = xfs_free_eofblocks(dest);
-		if (ret)
-			goto out_unlock;
-	}
+	ret = xfs_reflink_zero_posteof(dest, pos_out);
+	if (ret)
+		goto out_unlock;
 
 	/* Set flags and remap blocks. */
 	ret = xfs_reflink_set_inode_flag(src, dest);

