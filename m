Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5857C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 21:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7110720811
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 21:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="wWkff93g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731840AbfCZVjj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 17:39:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34965 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732800AbfCZVjj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 17:39:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id w1so16170485wrp.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 14:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Y8qHN2e/LSRSsoZ5oUVQLg6J0+syCMcTY6xQrqKRL70=;
        b=wWkff93g4DFq1gBlxPjvW3Fq9jBSHxOkADg0pK9uLw2RBj7JEc0YgAxsMKiKgK+LgG
         MDh+a3isAOjQUTVLq2ZWceob/P5veK7J+5SNm/aGi7xaXUrmcrYbqrPqhjLhgtIwXujs
         kYVKRqvy2U/PvM7TDgyS40/JphaOFoTHYMMBC+kRPo1Ot3RMqk8L2zWK09o2g/lPAwlL
         Fj+Wr7+FiPIWJLntGcX18OeOMYdRE994DdoibZjLflxmH0HxyEg9SxUM9TjDN4sj78og
         H49evmewJpCBrMAL5Wwww1KagYkF5MpbdZ5S862edZhZUUKyssdzNUIIYwzXRaQPSba5
         FzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Y8qHN2e/LSRSsoZ5oUVQLg6J0+syCMcTY6xQrqKRL70=;
        b=OOpcj5qbU1QiC2XAkpMMM5fpjLITQkTCyas217276v9Pp69avsCSX8OV+ds4AN4Dxz
         osO+8m8oU9BM2nqegzJ5kQ40TGQkU8e+AJxBjLiGKT7LcQ/PSSA7cbw6XJ4IsdPxCtQJ
         w/lTVmSHpRHV6M0sjLnYiDGBaSzjnc8It11pH4xP3qWgocil6Gr9Q3cXdSasO20BpOZ5
         joTGJyZWbCUentF7AqvFMHXT30pZHZW/FB7pMukHSONY2eLAHVzgk6Kqu0qn48++w+7D
         0OLXR88my2dGF6Yf5L/OdW7Tvn1mgIAUNZK0rD1b1xsXO6/oXtgqqGC7GMFzWnEqete7
         zaOQ==
X-Gm-Message-State: APjAAAW206++dpdAblm7HCrs0ik7W/gYiCfLMqBl7j8h2NHU4Dxi7OGL
        SV7sqyskWlrsF2FDeKIONdg5Lw==
X-Google-Smtp-Source: APXvYqyRX2nOJB0M5GOgMqtRmKBqo9tQrXtO2TT89VgjEsGEeN2SnDWmoltcpKRQSoejT8UqX/bQTg==
X-Received: by 2002:a5d:6b0d:: with SMTP id v13mr22875690wrw.284.1553636376719;
        Tue, 26 Mar 2019 14:39:36 -0700 (PDT)
Received: from pathfinder ([90.195.158.41])
        by smtp.gmail.com with ESMTPSA id k4sm13704832wro.33.2019.03.26.14.39.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 26 Mar 2019 14:39:36 -0700 (PDT)
Date:   Tue, 26 Mar 2019 21:39:34 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     clm@fb.com
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk, jbacik@fb.com,
        dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v6 07/07] btrfs: use common file type conversion
Message-ID: <20190326213934.GA20882@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Deduplicate the btrfs file type conversion implementation - file systems
that use the same file types as defined by POSIX do not need to define
their own versions and can use the common helper functions decared in
fs_types.h and implemented in fs_types.c

Common implementation can be found via commit:
bbe7449e2599 "fs: common implementation of file type"

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/btrfs_inode.h          |  2 --
 fs/btrfs/delayed-inode.c        |  2 +-
 fs/btrfs/inode.c                | 32 +++++++++++++++-----------------
 include/uapi/linux/btrfs_tree.h |  2 ++
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6f5d07415dab..b16c13d51be0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -203,8 +203,6 @@ struct btrfs_inode {
 	struct inode vfs_inode;
 };
 
-extern unsigned char btrfs_filetype_table[];
-
 static inline struct btrfs_inode *BTRFS_I(const struct inode *inode)
 {
 	return container_of(inode, struct btrfs_inode, vfs_inode);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c669f250d4a0..e61947f5eb76 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1692,7 +1692,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		name = (char *)(di + 1);
 		name_len = btrfs_stack_dir_name_len(di);
 
-		d_type = btrfs_filetype_table[di->type];
+		d_type = fs_ftype_to_dtype(di->type);
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
 		over = !dir_emit(ctx, name, name_len,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 82fdda8ff5ab..047609c27913 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -73,17 +73,6 @@ struct kmem_cache *btrfs_trans_handle_cachep;
 struct kmem_cache *btrfs_path_cachep;
 struct kmem_cache *btrfs_free_space_cachep;
 
-#define S_SHIFT 12
-static const unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
-	[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= BTRFS_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= BTRFS_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
-};
-
 static int btrfs_setsize(struct inode *inode, struct iattr *attr);
 static int btrfs_truncate(struct inode *inode, bool skip_writeback);
 static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
@@ -5797,10 +5786,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-unsigned char btrfs_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
-
 /*
  * All this infrastructure exists because dir_emit can fault, and we are holding
  * the tree lock when doing readdir.  For now just allocate a buffer and copy
@@ -5939,7 +5924,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
 				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
@@ -6344,7 +6329,20 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 static inline u8 btrfs_inode_type(struct inode *inode)
 {
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+	/*
+	 * compile-time asserts that generic FT_* types still match
+	 * BTRFS_FT_* types
+	 */
+	BUILD_BUG_ON(BTRFS_FT_UNKNOWN != FT_UNKNOWN);
+	BUILD_BUG_ON(BTRFS_FT_REG_FILE != FT_REG_FILE);
+	BUILD_BUG_ON(BTRFS_FT_DIR != FT_DIR);
+	BUILD_BUG_ON(BTRFS_FT_CHRDEV != FT_CHRDEV);
+	BUILD_BUG_ON(BTRFS_FT_BLKDEV != FT_BLKDEV);
+	BUILD_BUG_ON(BTRFS_FT_FIFO != FT_FIFO);
+	BUILD_BUG_ON(BTRFS_FT_SOCK != FT_SOCK);
+	BUILD_BUG_ON(BTRFS_FT_SYMLINK != FT_SYMLINK);
+
+	return fs_umode_to_ftype(inode->i_mode);
 }
 
 /*
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index e974f4bb5378..421239b98db2 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -307,6 +307,8 @@
  *
  * Used by:
  * struct btrfs_dir_item.type
+ *
+ * Values 0..7 must match common file type values in fs_types.h.
  */
 #define BTRFS_FT_UNKNOWN	0
 #define BTRFS_FT_REG_FILE	1
-- 
2.20.1

