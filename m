Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478B1C71122
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0936220895
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rd75H4KU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0936220895
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbeJMHmg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:42:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbeJMHmf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:42:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D04KRw143951;
        Sat, 13 Oct 2018 00:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XyX+a0OwgmoCuUQlM5FRUIUGIs9diILaZiWpCujlIew=;
 b=Rd75H4KUtot55vJqqDqttjfoxizywdaBfCSQ3pbPE2n5xYGzt88Nt4sOiKC1M37g5tvl
 KwOXVbALvV6SHPvyjOzUJEvq0K/e7niDLzLkRL5s2ZjmfxfTyXYAYIVzdoesKRAy+03L
 0NKr9eUxoNlb+06UOetcYnXX2Xui4aX5SN3t5EtwcRixx6cqWb5R6pISy37nlvt3v6+M
 zz2N/i6Xtw05Waa38g2C2MookBW4m6nDLpuRSjRuFhPF/sLqItZ7OyOIrj/m7xM3Rmo6
 zfedQhPZZKPk0kvmw/mPCz5nEtDVxptnMjtHfBfIpKHvc2huP24mf/4VGYCHfYXp+j6h sQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mxmfudpym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D07dOu019930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:07:40 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9D07dWM019143;
        Sat, 13 Oct 2018 00:07:39 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:07:39 +0000
Subject: [PATCH 16/25] vfs: make remapping to source file eof more explicit
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:07:37 -0700
Message-ID: <153938925737.8361.3995899966552253527.stgit@magnolia>
In-Reply-To: <153938912912.8361.13446310416406388958.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9044 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=637
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810130000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
the remap implementation to remap to the end of the source file, once
the files are locked.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c         |    3 ++-
 fs/nfsd/vfs.c      |    4 +++-
 fs/read_write.c    |   13 ++++++++-----
 include/linux/fs.h |    8 +++++++-
 4 files changed, 20 insertions(+), 8 deletions(-)


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 505275ec5596..088cf240ca10 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -224,6 +224,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 {
 	struct fd src_file = fdget(srcfd);
 	loff_t cloned;
+	unsigned int remap_flags = olen == 0 ? RFR_TO_SRC_EOF : 0;
 	int ret;
 
 	if (!src_file.file)
@@ -232,7 +233,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		goto fdput;
 	cloned = vfs_clone_file_range(src_file.file, off, dst_file, destoff,
-				      olen, 0);
+				      olen, remap_flags);
 	if (cloned < 0)
 		ret = cloned;
 	else if (olen && cloned != olen)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 726fc5b2b27a..0dc65047df1a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -542,8 +542,10 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 		u64 dst_pos, u64 count)
 {
 	loff_t cloned;
+	unsigned int remap_flags = count == 0 ? RFR_TO_SRC_EOF : 0;
 
-	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count, 0);
+	cloned = vfs_clone_file_range(src, src_pos, dst, dst_pos, count,
+				      remap_flags);
 	if (count && cloned != count)
 		cloned = -EINVAL;
 	return nfserrno(cloned < 0 ? cloned : 0);
diff --git a/fs/read_write.c b/fs/read_write.c
index 81e0f969da59..c02fc5144d15 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1746,15 +1746,18 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
-	/* Zero length dedupe exits immediately; reflink goes to EOF. */
-	if (*len == 0) {
+	/*
+	 * If the caller asked to go all the way to the end of the source file,
+	 * set *len now that we have the file locked.
+	 */
+	if (remap_flags & RFR_TO_SRC_EOF) {
 		loff_t isize = i_size_read(inode_in);
 
-		if (is_dedupe || pos_in == isize)
-			return 0;
 		if (pos_in > isize)
 			return -EINVAL;
 		*len = isize - pos_in;
+		if (*len == 0)
+			return 0;
 	}
 
 	/* Check that we don't violate system file offset limits. */
@@ -1844,7 +1847,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags);
+	WARN_ON_ONCE(remap_flags & ~(RFR_TO_SRC_EOF));
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d77b8d90d65e..b9c314f9d5a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1725,10 +1725,15 @@ struct block_device_operations;
  * These flags control the behavior of the remap_file_range function pointer.
  *
  * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
+ * RFR_TO_SRC_EOF: remap to the end of the source file
  */
 #define RFR_SAME_DATA		(1 << 0)
+#define RFR_TO_SRC_EOF		(1 << 1)
 
-#define RFR_VALID_FLAGS		(RFR_SAME_DATA)
+#define RFR_VALID_FLAGS		(RFR_SAME_DATA | RFR_TO_SRC_EOF)
+
+/* Implemented by the VFS, so these are advisory. */
+#define RFR_VFS_FLAGS		(RFR_TO_SRC_EOF)
 
 /*
  * Filesystem remapping implementations should call this helper on their
@@ -1739,6 +1744,7 @@ struct block_device_operations;
 static inline bool remap_check_flags(unsigned int remap_flags,
 				     unsigned int supported_flags)
 {
+	remap_flags &= ~RFR_VFS_FLAGS;
 	return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
 }
 

