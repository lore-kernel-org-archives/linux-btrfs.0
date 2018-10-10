Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33243C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE92921502
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RC0YFI13"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE92921502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbeJJHae (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeJJHad (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08uCI138874;
        Wed, 10 Oct 2018 00:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cmK57nWF3xCycn+Xe37BmfeUz4DrJ92G4aMskuDnZos=;
 b=RC0YFI13Y+/d5uNT3It/7E/9kaExOdqIDbQoyV3metzGJTox2BQ/zNHz/Iqy1XSr/8Rd
 gETWBDOyUTEDlNCuMo0xKoA/rpz57qSduOcDRgPFOPjSnRZ+gBKO0WTICbSf74rKkaIk
 nPCE7QqI+Zwo6grHwFH4od2f71Ncv8KLf401L8Y3soY0x26NYOIqDC8GmrGR2N42sPjS
 QZK9TmByEa6m0AxOFKLhr1xkn+AZTcTnQEzIefZtsqIFUAxg6QgE9MyHVhkf9Nbu9X6X
 xPPuhiuNEfqfmh37cnMksE3PZGFjCMPa1+yehhlnDUkVikbmBfY/mHOE4BQp2rUJ31S1 2w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0q0tge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0B22o025716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:02 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9A0B1ib020601;
        Wed, 10 Oct 2018 00:11:01 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:11:01 +0000
Subject: [PATCH 03/25] xfs: zero posteof blocks when cloning above eof
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:10:59 -0700
Message-ID: <153913025949.32295.17548471289910846210.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ebd65d3e31f3..cbb359e68a72 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1240,6 +1240,26 @@ xfs_reflink_remap_unlock(
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
@@ -1293,15 +1313,12 @@ xfs_reflink_remap_prep(
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

