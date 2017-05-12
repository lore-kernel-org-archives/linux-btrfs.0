Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33210 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932178AbdELWH6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 18:07:58 -0400
Received: by mail-pf0-f181.google.com with SMTP id e193so36047938pfh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 15:07:58 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Yonghong Song <yhs@fb.com>
Subject: [PATCH] Btrfs: add statx support
Date: Fri, 12 May 2017 15:07:43 -0700
Message-Id: <b67a19fbb3d6e9e483cefd8373b35077d1c2eca3.1494626830.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Yonghong Song <yhs@fb.com>

Return enhanced file attributes from the btrfs, including:
  (1). inode creation time as stx_btime, and
  (2). Certain BTRFS_INODE_xxx flags are mapped to stx_attributes flags.

Example output:
	[root@localhost ~]# cat t.sh
	touch t
	chattr +aic t
	~/linux/samples/statx/test-statx t
	chattr -aic t
	touch t
	echo "========================================"
	~/linux/samples/statx/test-statx t
	/bin/rm t
	[root@localhost ~]# ./t.sh
	statx(t) = 0
	results=fff
  	  Size: 0               Blocks: 0          IO Block: 4096    regular file
	Device: 00:1c           Inode: 63962       Links: 1
	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
	Access: 2017-05-11 16:03:13.999856591-0700
	Modify: 2017-05-11 16:03:13.999856591-0700
	Change: 2017-05-11 16:03:14.000856663-0700
 	 Birth: 2017-05-11 16:03:13.999856591-0700
	Attributes: 0000000000000034 (........ ........ ........ ........ ........ ........ ........ .-ai.c..)
	========================================
	statx(t) = 0
	results=fff
	  Size: 0               Blocks: 0          IO Block: 4096    regular file
	Device: 00:1c           Inode: 63962       Links: 1
	Access: (0644/-rw-r--r--)  Uid:     0   Gid:     0
	Access: 2017-05-11 16:03:14.006857097-0700
	Modify: 2017-05-11 16:03:14.006857097-0700
	Change: 2017-05-11 16:03:14.006857097-0700
 	Birth: 2017-05-11 16:03:13.999856591-0700
	Attributes: 0000000000000000 (........ ........ ........ ........ ........ ........ ........ .---.-..)
	[root@localhost ~]#

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 fs/btrfs/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..5143e4712f93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9564,6 +9564,24 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 	u64 delalloc_bytes;
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = inode->i_sb->s_blocksize;
+	u32 bi_flags = BTRFS_I(inode)->flags;
+
+	stat->result_mask |= STATX_BTIME;
+	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
+	stat->btime.tv_nsec = BTRFS_I(inode)->i_otime.tv_nsec;
+	if (bi_flags & BTRFS_INODE_APPEND)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (bi_flags & BTRFS_INODE_COMPRESS)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (bi_flags & BTRFS_INODE_IMMUTABLE)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (bi_flags & BTRFS_INODE_NODUMP)
+		stat->attributes |= STATX_ATTR_NODUMP;
+
+	stat->attributes_mask |= (STATX_ATTR_APPEND |
+				  STATX_ATTR_COMPRESSED |
+				  STATX_ATTR_IMMUTABLE |
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
-- 
2.13.0

