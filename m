Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2430C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A320621502
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jr1HMN44"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A320621502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbeJJHco (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:32:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbeJJHco (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:32:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08bwF083047;
        Wed, 10 Oct 2018 00:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Nl7YIofRRChjcrmNR29R1ufLWDq1ojIHa7FYh4XBYYI=;
 b=Jr1HMN44d0gF/DymgWS2ST5eID/yTRT++1jMdP95477AjHkR2NpINGiZtch+SJSqvPRG
 ZNcz1Vte3xMbO+zwgu/Ng3ni4okCFXEpvOMDs2ZKM25myCmGk1pUX8CvicCphOJ+hUlU
 eoaEDlGnmRvUUprKYGBv30jcQQihlQ7KEzm55qXi5vZXM5nJQSxbyAqhSjjkXjSso30z
 +XDtVtWnLce+cYiNoOvJa35l4LUuNSiNfMT20MPuL17niqKoHwNk8yhJHgPxav+FvvNb
 vrg3gNmX0vVh2TK7agJzETkL/d/NfnLmPP9nKbq0Ky5qsAkhDV0F2L1Eiy1HoBaYmazx hA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mxnpr0p5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:13:15 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0D9Mi013369
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:13:09 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0D8GO003654;
        Wed, 10 Oct 2018 00:13:08 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:13:08 +0000
Subject: [PATCH 11/25] vfs: create generic_remap_file_range_touch to update
 inode metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:13:06 -0700
Message-ID: <153913038664.32295.8625558259109244112.stgit@magnolia>
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

Create a new VFS helper to handle inode metadata updates when remapping
into a file.  If the operation can possibly alter the file contents, we
must update the ctime and mtime and remove security privileges, just
like we do for regular file writes.  Wire up ocfs2 to ensure consistent
behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    8 ++++++++
 fs/read_write.c         |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_reflink.c    |   29 +++++++----------------------
 include/linux/fs.h      |    1 +
 4 files changed, 40 insertions(+), 22 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 36c56dfbe485..ee1ed11379b3 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4855,6 +4855,14 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	if (ret <= 0)
 		goto out_unlock;
 
+	/*
+	 * Update inode timestamps and remove security privileges before we
+	 * take the ilock.
+	 */
+	ret = generic_remap_file_range_touch(file_out, is_dedupe);
+	if (ret)
+		goto out_unlock;
+
 	/* Lock out changes to the allocation maps and remap. */
 	down_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
diff --git a/fs/read_write.c b/fs/read_write.c
index b4acfb45d916..020bb7fdf431 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1790,6 +1790,30 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
+/* Update inode timestamps and remove security privileges when remapping. */
+int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
+{
+	int ret;
+
+	/* If can't alter the file contents, we're done. */
+	if (is_dedupe)
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
+EXPORT_SYMBOL(generic_remap_file_range_touch);
+
 int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			struct file *file_out, loff_t pos_out, u64 len)
 {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4cf1e52efbff..0d67b2d0b3d4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1330,28 +1330,13 @@ xfs_reflink_remap_prep(
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + *len) - 1);
 
-	/* If we're altering the file contents... */
-	if (!is_dedupe) {
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
+	/*
+	 * Update inode timestamps and remove security privileges before we
+	 * take the ilock.
+	 */
+	ret = generic_remap_file_range_touch(file_out, is_dedupe);
+	if (ret)
+		goto out_unlock;
 
 	return 1;
 out_unlock:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8f90bdd34e2..661b9ef32d2b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1833,6 +1833,7 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 u64 *count, bool is_dedupe);
+extern int generic_remap_file_range_touch(struct file *file, bool is_dedupe);
 extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,

