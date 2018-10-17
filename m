Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F2CECDE3B
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4665D213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xC+PVhCV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4665D213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbeJRGnG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:43:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36816 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbeJRGnF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:43:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMhlJY040059;
        Wed, 17 Oct 2018 22:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EVBOjpjVeZ0uqv5Ytj51D02SOvbvYZvIxgFPH2/97ks=;
 b=xC+PVhCV2MUkoCriIdCTKjieFycCSlQ45RgvqEaWIXaQ2wNgkFqI/WURC6boEo8PeY9z
 uNzBprCxbKBWLJB+qVc5BDXluCEyunTE0FZtN6RydvxsPAhtYCatnA2SK4Rxk/UTY8Cv
 2Zy3D2y9WDokefKWu2fF4/RsAl3ixgAOGUm1dcqpj9Qq6cyr8sViGrj++/mwQ7HhR+AE
 gveqdG6PiDNIyR++6EMlSG+kDIwBO7Z8Zy53G5iD+p24wWlIPD+Uk00rPyK1VlRCHSYc
 6/X8+Oq5SIuC/sK/XCAhZMJolslhxwZNGRE0//RNYRCWuITppm598E3QeuDK2n+bkKLS Hw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2n384u9yx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:45:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMj5MQ011933
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:45:05 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9HMj5ei031599;
        Wed, 17 Oct 2018 22:45:05 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:45:05 -0700
Subject: [PATCH 07/29] vfs: rename vfs_clone_file_prep to be more descriptive
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:45:03 -0700
Message-ID: <153981630347.5568.10618491872993138395.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The vfs_clone_file_prep is a generic function to be called by filesystem
implementations only.  Rename the prefix to generic_ and make it more
clear that it applies to remap operations, not just clones.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ocfs2/refcounttree.c |    2 +-
 fs/read_write.c         |    8 ++++----
 fs/xfs/xfs_reflink.c    |    2 +-
 include/linux/fs.h      |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 19e03936c5e1..36c56dfbe485 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4850,7 +4850,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	    (OCFS2_I(inode_out)->ip_flags & OCFS2_INODE_SYSTEM_FILE))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			&len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/fs/read_write.c b/fs/read_write.c
index f5395d8da741..aca75a97a695 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1745,9 +1745,9 @@ static int generic_remap_check_len(struct inode *inode_in,
  * Returns: 0 for "nothing to clone", 1 for "something to clone", or
  * the usual negative error code.
  */
-int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
-			struct file *file_out, loff_t pos_out,
-			u64 *len, bool is_dedupe)
+int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+				  struct file *file_out, loff_t pos_out,
+				  u64 *len, bool is_dedupe)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1822,7 +1822,7 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 
 	return 1;
 }
-EXPORT_SYMBOL(vfs_clone_file_prep);
+EXPORT_SYMBOL(generic_remap_file_range_prep);
 
 int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			struct file *file_out, loff_t pos_out, u64 len)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 281d5f53f2ec..a7757a128a78 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1326,7 +1326,7 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
-	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
+	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba93a6e7dac4..55729e1c2e75 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1825,9 +1825,9 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
-extern int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
-			       struct file *file_out, loff_t pos_out,
-			       u64 *count, bool is_dedupe);
+extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
+					 struct file *file_out, loff_t pos_out,
+					 u64 *count, bool is_dedupe);
 extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
 			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,

