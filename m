Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752111AbcJBN0V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:26:21 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNE8P039367
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:26:20 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25t915w34b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:26:20 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:26:19 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 19/19] Btrfs: subpage-blocksize: Disable compression
Date: Sun,  2 Oct 2016 18:54:28 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-20-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subpage-blocksize patchset does not yet support compression. Hence,
the kernel might crash when executing compression code in
subpage-blocksize scenario. This commit disables enabling compression
feature during 'mount' and also when the  user invokes
'chattr +c <filename>' command.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c |  8 +++++++-
 fs/btrfs/super.c | 19 +++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0fdc0a0..862d97b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -322,6 +322,11 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	} else if (flags & FS_COMPR_FL) {
 		const char *comp;
 
+		if (root->sectorsize < PAGE_SIZE) {
+			ret = -EINVAL;
+			goto out_drop;
+		}
+
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
@@ -1342,7 +1347,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		return -EINVAL;
 
 	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
-		if (range->compress_type > BTRFS_COMPRESS_TYPES)
+		if ((range->compress_type > BTRFS_COMPRESS_TYPES)
+			|| (root->sectorsize < PAGE_SIZE))
 			return -EINVAL;
 		if (range->compress_type)
 			compress_type = range->compress_type;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 73a1d8d..3a2e9d7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -392,6 +392,17 @@ static const match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
+static int can_enable_compression(struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_super_sectorsize(fs_info->super_copy) < PAGE_SIZE) {
+		btrfs_err(fs_info,
+			"Compression is not supported for subpage-blocksize");
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
@@ -502,6 +513,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strcmp(args[0].from, "zlib") == 0) {
+				if (!can_enable_compression(info)) {
+					ret = -EINVAL;
+					goto out;
+				}
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
@@ -509,6 +524,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				no_compress = 0;
 			} else if (strcmp(args[0].from, "lzo") == 0) {
+				if (!can_enable_compression(info)) {
+					ret = -EINVAL;
+					goto out;
+				}
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
-- 
2.5.5

