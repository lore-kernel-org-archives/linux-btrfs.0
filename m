Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53908 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbcGDEgK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:36:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644Xfff116611
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:36:09 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23xa5165xf-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:36:09 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:36:08 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 18/19] Btrfs: subpage-blocksize: Disable compression
Date: Mon,  4 Jul 2016 10:04:38 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-19-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/super.c | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ef3c32..d7159db 100644
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
 
@@ -1344,7 +1349,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		return -EINVAL;
 
 	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
-		if (range->compress_type > BTRFS_COMPRESS_TYPES)
+		if ((range->compress_type > BTRFS_COMPRESS_TYPES)
+			|| (root->sectorsize < PAGE_SIZE))
 			return -EINVAL;
 		if (range->compress_type)
 			compress_type = range->compress_type;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cba92e6..ddd4658 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -368,6 +368,17 @@ static const match_table_t tokens = {
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
@@ -477,6 +488,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
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
@@ -484,6 +499,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
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
@@ -806,6 +825,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options,
 			break;
 		}
 	}
+
 check:
 	/*
 	 * Extra check for current option against current flag
-- 
2.5.5

