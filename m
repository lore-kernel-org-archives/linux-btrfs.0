Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87552C67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 21:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D28207DD
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 21:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="bxuJlNME"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42D28207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbeJXFmk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 01:42:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45916 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJXFmk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 01:42:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id f17-v6so3217872wrs.12
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 14:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VnD+CLavQLnq9oG7intxx34ZowLx+fsbcrRX+5LIf+I=;
        b=bxuJlNMEGjdkKTmh4lJdvFQ+j/muy8n8crXTE4zbACMsbdUmd9HIEtoDYn5OTMYW7R
         edkejjHUxc4IQjntSBZxkRqNG+2zT2J9iYCx9Upsgpoafxiwyvo+PD2h2Sj9kgmJqems
         jb8bNx8JvAseqyoYLeRBdLgGnHJ+pWFq7ghMwPcSUB7lvZX3LofShdB1YlRi/Qvb2TSV
         o4QP4YJjV/eQJgCJguoLaYZBdQjqFKYhABb7usrbUbMMqybhEb8peOz+9n4EQ1th24TS
         XjrLcRlPN7q774kN+G7OkdN0WT+stZbS/2ncI99yXMcUc86XnlWLxZjrlLfVElucgxIM
         Jf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VnD+CLavQLnq9oG7intxx34ZowLx+fsbcrRX+5LIf+I=;
        b=D6XYrf25pXdeTqQtAqegBSaJkJXfK8JMbIyacaXMvl5ZQO322lKYNGd60Iq7NpCi7/
         W0LKPC5vUgoXwX+HrYhSLCpEEo8AhudeBRISSTz6fJoMnjDXz3ZKv1V1ADUuH+89sTXb
         rRa5AGw2zNoXynbD1dL156usU36/0mvDwJsAFE6n2JcZsLDO5lMEFey1mb+K1S+gI2qQ
         MhF7JCeZv+aLHQQ7EqFgaNTZTRc6XFBMcCeIYvWAFcYU/gadUfevVziiIQKrAbINZAZ9
         kVcqYQf1++zyCpENs0+LqlYcYqJv/KYUN2tV/evdxvNrlpmPoE+p/aHnDy3FR1Wu17CZ
         +T4A==
X-Gm-Message-State: AGRZ1gLh7xwRSZL/5GbUYqnvBcr9rBOgs7Dl1BJvVks1d44L2KQyKncf
        bzYE2xia5gXwF3ILJkLqWLMBYQ==
X-Google-Smtp-Source: AJdET5dhFgrLz5h1q/d6A6wrEH/Mp0I9P41YR+355HRaY223VeGT+xZfnD0DxMGjbK2BbkYwGiI/7Q==
X-Received: by 2002:a5d:6b4f:: with SMTP id x15-v6mr23038176wrw.304.1540329450688;
        Tue, 23 Oct 2018 14:17:30 -0700 (PDT)
Received: from pathfinder (62-64-249-96.dynamic.dsl.as9105.com. [62.64.249.96])
        by smtp.gmail.com with ESMTPSA id j203-v6sm4380200wmd.46.2018.10.23.14.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Oct 2018 14:17:29 -0700 (PDT)
Date:   Tue, 23 Oct 2018 22:17:28 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     clm@fb.com
Cc:     linux-kernel@vger.kernel.org, amir73il@gmail.com,
        viro@zeniv.linux.org.uk, jbacik@fb.com, dsterba@suse.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH v2 10/10] btrfs: use common file type conversion
Message-ID: <20181023211728.GA16584@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Deduplicate the btrfs file type conversion implementation.

Original patch by Amir Goldstein.

v2:
- Rebased against Linux 4.19 by Phillip Potter
- Compile-time checks added by Phillip Potter to make
  sure the BTRFS_FT_x enum values stay same as FT_x values

v1:
- Initial implementation

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/btrfs/btrfs_inode.h          |  2 --
 fs/btrfs/delayed-inode.c        |  2 +-
 fs/btrfs/inode.c                | 35 +++++++++++++++++----------------
 include/uapi/linux/btrfs_tree.h |  2 ++
 4 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1343ac57b438..c7c6db6b4a35 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -196,8 +196,6 @@ struct btrfs_inode {
 	struct inode vfs_inode;
 };
 
-extern unsigned char btrfs_filetype_table[];
-
 static inline struct btrfs_inode *BTRFS_I(const struct inode *inode)
 {
 	return container_of(inode, struct btrfs_inode, vfs_inode);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f51b509f2d9b..c1da34e3a775 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1691,7 +1691,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		name = (char *)(di + 1);
 		name_len = btrfs_stack_dir_name_len(di);
 
-		d_type = btrfs_filetype_table[di->type];
+		d_type = fs_dtype(di->type);
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
 		over = !dir_emit(ctx, name, name_len,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..4cbdcba4799a 100644
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
@@ -5803,10 +5792,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-unsigned char btrfs_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
-
 /*
  * All this infrastructure exists because dir_emit can fault, and we are holding
  * the tree lock when doing readdir.  For now just allocate a buffer and copy
@@ -5945,7 +5930,23 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+
+		/*
+		 * compile-time asserts that generic FT_x types
+		 * still match BTRFS_FT_x types - no need to list
+		 * in other functions as well as build will
+		 * fail either way
+		 */
+		BUILD_BUG_ON(BTRFS_FT_UNKNOWN != FT_UNKNOWN);
+		BUILD_BUG_ON(BTRFS_FT_REG_FILE != FT_REG_FILE);
+		BUILD_BUG_ON(BTRFS_FT_DIR != FT_DIR);
+		BUILD_BUG_ON(BTRFS_FT_CHRDEV != FT_CHRDEV);
+		BUILD_BUG_ON(BTRFS_FT_BLKDEV != FT_BLKDEV);
+		BUILD_BUG_ON(BTRFS_FT_FIFO != FT_FIFO);
+		BUILD_BUG_ON(BTRFS_FT_SOCK != FT_SOCK);
+		BUILD_BUG_ON(BTRFS_FT_SYMLINK != FT_SYMLINK);
+
+		put_unaligned(fs_dtype(btrfs_dir_type(leaf, di)),
 				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
@@ -6350,7 +6351,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 static inline u8 btrfs_inode_type(struct inode *inode)
 {
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+	return fs_umode_to_ftype(inode->i_mode);
 }
 
 /*
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..5747cffa09fa 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -307,6 +307,8 @@
  *
  * Used by:
  * struct btrfs_dir_item.type
+ *
+ * Values 0..7 should match common file type values in file_type.h.
  */
 #define BTRFS_FT_UNKNOWN	0
 #define BTRFS_FT_REG_FILE	1
-- 
2.17.2

