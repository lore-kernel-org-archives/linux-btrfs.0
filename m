Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73476C04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C9AA2083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QyfeosX1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C9AA2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbeJPLHr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:07:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbeJPLHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:07:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3JMpO060270;
        Tue, 16 Oct 2018 03:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2Mwz+Jm1Vv6DSly8RfSjLjmTysY9FOE+4U51VEcOuGA=;
 b=QyfeosX11lkm+R6FJaSex5a7QxpympeeUy+dEEs9LKcGmvkOjbmr5b5J42Y4L8kKr8jP
 MWHQFqrh7+0Btd+SC4wQED5K+Z7Qao9bJJuFGTprbpx7sofYa7z8KCZXd+7Ij4P7EK7K
 Cf8tB5t/gAlpy1jcqWV+QKaLlLUtV1HRm9m+rcUt90RHgqeIcq3QMawvy3a2XTE4v0UE
 Oo3BAZ/uV/C3sUdMJ0/03DTL9bkT0Klnm3D4tD8cmX79Rf3eoAVBfw6w+O18hAEHE40G
 5qhtdTc/xjY9MDG3MQXzblfJtk8pVlt2ZitpFkBAoaLtI84yG1vMR1/rdJltfHCrfRYQ /w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2n38npwvev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3JTuR003181
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:19:29 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9G3JSGX007232;
        Tue, 16 Oct 2018 03:19:28 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:19:28 -0700
Subject: [PATCH 13/26] vfs: create generic_remap_file_range_touch to update
 inode metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:19:26 -0700
Message-ID: <153965996673.3607.133184523000924340.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=853
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new VFS helper to handle inode metadata updates when remapping
into a file.  If the operation can possibly alter the file contents, we
must update the ctime and mtime and remove security privileges, just
like we do for regular file writes.  Wire up ocfs2 to ensure consistent
behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c      |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.c |   23 -----------------------
 2 files changed, 28 insertions(+), 23 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index ebcbfc4f2907..3f6392f1d5d4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1737,6 +1737,30 @@ static int generic_remap_check_len(struct inode *inode_in,
 	return 0;
 }
 
+/* Update inode timestamps and remove security privileges when remapping. */
+static int generic_remap_file_range_target(struct file *file,
+					   unsigned int remap_flags)
+{
+	int ret;
+
+	/* If can't alter the file contents, we're done. */
+	if (remap_flags & REMAP_FILE_DEDUP)
+		return 0;
+
+	/* Update the timestamps, since we can alter file contents. */
+	if (!(file->f_mode & FMODE_NOCMTIME)) {
+		ret = file_update_time(file);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Clear the security bits if the process is not being run by root.
+	 * This keeps people from modifying setuid and setgid binaries.
+	 */
+	return file_remove_privs(file);
+}
+
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
  * sense, and then flush all dirty data.  Caller must ensure that the
@@ -1820,6 +1844,10 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
+	ret = generic_remap_file_range_target(file_out, remap_flags);
+	if (ret)
+		return ret;
+
 	return 1;
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 29aab196ce7e..2d7dd8b28d7c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1372,29 +1372,6 @@ xfs_reflink_remap_prep(
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + *len) - 1);
 
-	/* If we're altering the file contents... */
-	if (!(remap_flags & REMAP_FILE_DEDUP)) {
-		/*
-		 * ...update the timestamps (which will grab the ilock again
-		 * from xfs_fs_dirty_inode, so we have to call it before we
-		 * take the ilock).
-		 */
-		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
-			ret = file_update_time(file_out);
-			if (ret)
-				goto out_unlock;
-		}
-
-		/*
-		 * ...clear the security bits if the process is not being run
-		 * by root.  This keeps people from modifying setuid and setgid
-		 * binaries.
-		 */
-		ret = file_remove_privs(file_out);
-		if (ret)
-			goto out_unlock;
-	}
-
 	return 1;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);

