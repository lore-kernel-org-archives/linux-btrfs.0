Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE24C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E3020854
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QTz9ZFIM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37E3020854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbeJEHlT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:41:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJEHlT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iQfn000629;
        Fri, 5 Oct 2018 00:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=kY0nsieWtesE48zOF9JqvasXYZoPogrpyj1Sh14a8r0=;
 b=QTz9ZFIM1x1E1t+M2lrTE5hKnikeU7j16yHEwJc9c9IHzLqn7usDHJv37hAIMyPx0JyT
 FccZEqAB3+9WT7DZE8CX2xdKcnxo7imAbxMAqFGds9ULh/ZxdQo2zrTeCwBFrO7ke+do
 rr3T2f3PLhB3fFmr31qFptr/iaVaS0OOT8HsptlbUp7OGV2blBI5irT6vgs414rLwB3d
 2UjUovtL9MZ9D6o+KTEll8nPBQferW0sucejt496ALtI2MO8D8/0OiiGjNCtMfTW4u9B
 LiwAqnbnZuKU3sOyL9vORk7azS6G1wsLKpUmpoa6gGoLq1iTcxCA1jnsvERmtVDWqR58 sQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mt21rfjxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950j3W3011875
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:04 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w950j3rR014427;
        Fri, 5 Oct 2018 00:45:03 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:45:03 +0000
Subject: [PATCH 04/15] xfs: update ctime and remove suid before cloning files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:00 -0700
Message-ID: <153870030069.29072.11055871953561649172.stgit@magnolia>
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

Before cloning into a file, update the ctime and remove sensitive
attributes like suid, just like we'd do for a regular file write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 55da7e1154f4..d8f209bc8937 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1239,6 +1239,7 @@ xfs_reflink_zero_posteof(
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
  * will be truncated, and any leases on the out file will have been broken.
+ * This function borrows heavily from xfs_file_aio_write_checks.
  */
 STATIC int
 xfs_reflink_remap_prep(
@@ -1302,6 +1303,30 @@ xfs_reflink_remap_prep(
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + len) - 1);
+
+	/* If we're altering the file contents... */
+	if (!is_dedupe) {
+		/*
+		 * ...update the timestamps (which will grab the ilock again
+		 * from xfs_fs_dirty_inode, so we have to call it before we
+		 * take the ilock).
+		 */
+		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+			ret = file_update_time(file_out);
+			if (ret)
+				goto out_unlock;
+		}
+
+		/*
+		 * ...clear the security bits if the process is not being run
+		 * by root.  This keeps people from modifying setuid and setgid
+		 * binaries.
+		 */
+		ret = file_remove_privs(file_out);
+		if (ret)
+			goto out_unlock;
+	}
+
 	return 0;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);

