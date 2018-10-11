Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EA7C46462
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26972077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BSqSq+tr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A26972077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbeJKLjE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:39:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJKLjE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:39:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B49E23191454;
        Thu, 11 Oct 2018 04:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=/3l7N/X857KPTkSp1muxCsYvuhsKcEoEr7NE87oRJI0=;
 b=BSqSq+trbEleQirbu1tgM1FSk0fFdALrWymV5yUCvcDC8onpQEavsKsxUvbOqT3ky3aV
 Mm/zXYWW/BSOSXOMS7n1uJiEVhoD6tKE9/Xq6yweq/RzNytIEb0mjj1xNgalnGGZibuu
 xG9eRGAPdm8OY+ZPaAOdxsZpNQIhega+aohUa6c1PXi9/YeopMPaWPXca5WXOpymdX0c
 4AyJFtBnUK6trvNj0KFTZe5ckm5qqrIe27Qy6xaOfvOfS672dpH4Y18bgIOIcl2Y1ZXo
 X1VB6UBlTzs8FCtUSLpMUxpQdIytUBB1O29GMuqAC7sV5lxuGu+bnG6+YMON3mRyJ6wB 8g== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mxnpr98yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:13:39 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4DbV5020339
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:13:37 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4DboT011825;
        Thu, 11 Oct 2018 04:13:37 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:13:36 +0000
Subject: [PATCH 10/25] vfs: create generic_remap_file_range_touch to update
 inode metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:13:35 -0700
Message-ID: <153923121518.5546.15603284343898988670.stgit@magnolia>
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
 engine=8.0.1-1807170000 definitions=main-1810110039
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
index 60cdfb576d81..b233fe019fae 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1811,6 +1811,30 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
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
index a7757a128a78..99f2ea4fcaba 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1371,28 +1371,13 @@ xfs_reflink_remap_prep(
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
index 686905be04c0..91fd3c77763b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1847,6 +1847,7 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 u64 *count, bool is_dedupe);
+extern int generic_remap_file_range_touch(struct file *file, bool is_dedupe);
 extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,

