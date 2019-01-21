Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD80C282DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 08:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DEFC20823
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 08:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="gBi9DYrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfAUIJl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:09:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41073 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbfAUIJk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 03:09:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so22087579wrs.8
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 00:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GYYBAmt096plwKM4npCEoqzw+1f6RWraXYbWmzNbVRE=;
        b=gBi9DYrxmXflRgupowchKydz2b7Ix7jx4swBsupzu2uoTbG9VPBw+8WBR4dWIz5pkT
         VhF1ayZE0Px5aVNDDmMhGlPwl1SuVlknAHX5KENIxhzfmqZcuvBsIPrE+MscHFaKqdzu
         OpvaV37pbXtH7m59wzMLlZ5OAGF13PUn0Ryx+OlGzMBUry10j8vVxTQKwEUbt8E0bH8z
         l4vJ3pWZqCNo/4JZoB+UEIaJJ773TRfxgqiJpqlv8agtp6IZtTkIlWoH1aoK/w1q17JG
         Huyba9L6kQXP96q8j1sjTfNxM2Suy9YSGpUIvuOxiU5jj7GnoGefU4xlKWXLyBV92l+k
         hUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GYYBAmt096plwKM4npCEoqzw+1f6RWraXYbWmzNbVRE=;
        b=kJAceFUZj3D+FHIQTPAmgnDk5RMkp2GraKRVoIzR79E5u8hPcStZrC5m+qTzhraTdB
         0ntrWUQZzJh7F66jWhKZnYV7s+uokTxDvRCi9Vl4Zvl7DGdvpMhWlGMlUw6csdlRzr3f
         eT5spbaiDFr0Y/Mw1/T3Y+wfGiWFj5s4JmkWzkCaVEx9ODIqzbiI01vGf6/hGLcAZ2Gi
         o+5SEhDZD8Dpq00Tl2f9nIaYTlABWXVASyV+mur1j2ZUhJtQbwR5m+JC5AbJi9Tatb1q
         J4ISzBKwDmbnCPK1xHns6l7ClxzXV6e6tJrLJbDCLFncotNwsO+W4ux+M/l7UMkRBKSL
         HASg==
X-Gm-Message-State: AJcUukdMKV6g7yTDPzFP5SXxQBW9XgGAKUbECYKQO4CHr12UF5anzMDC
        kzxgseQweSmPfNzZcvxY429BUZsbB2g+sTXs
X-Google-Smtp-Source: ALg8bN74eRO422skWUOvWaoMEsk+GM8vcysh0Fl3hCKbJSL4zmdrJ9G2kwMpk2qsRORCq5yTP3k/0A==
X-Received: by 2002:adf:f504:: with SMTP id q4mr26510775wro.321.1548032081347;
        Sun, 20 Jan 2019 16:54:41 -0800 (PST)
Received: from pathfinder ([90.222.17.17])
        by smtp.gmail.com with ESMTPSA id o5sm29062574wrw.46.2019.01.20.16.54.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 20 Jan 2019 16:54:40 -0800 (PST)
Date:   Mon, 21 Jan 2019 00:54:39 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     clm@fb.com
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk, jbacik@fb.com,
        dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH v5 09/09] btrfs: use common file type conversion
Message-ID: <20190121005439.GA32379@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Deduplicate the btrfs file type conversion implementation - file systems
that use the same file types as defined by POSIX do not need to define
their own versions and can use the common helper functions decared in
fs_types.h and implemented in fs_types.c

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
index 43eb4535319d..f6ea1cbafd45 100644
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
@@ -5746,10 +5735,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-unsigned char btrfs_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
-
 /*
  * All this infrastructure exists because dir_emit can fault, and we are holding
  * the tree lock when doing readdir.  For now just allocate a buffer and copy
@@ -5888,7 +5873,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
 				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
@@ -6293,7 +6278,20 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
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

