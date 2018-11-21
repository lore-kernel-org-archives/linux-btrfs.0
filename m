Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75356C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB64206BB
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="OMYbg7JZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EB64206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387698AbeKVFmn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:42:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50920 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387696AbeKVFmn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:42:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id 125so6659120wmh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=sJLnXDsHznYw/y9+C7wzShyN9Wwvr5DZWWyzY2HDX0I=;
        b=OMYbg7JZSmDEAg2btyiC4uhV4ufqzXeOyrn8WVZprSoKb8ZIzFxCaecgzx6xPMOGbo
         siTtSv+WJoLa+kuIZNkoTWgPUtx7Wt0JddxV0iz2+F4//K/Pl5OD8Rv6jePxyHC+6vXg
         1G2s8FXUU4wt9GxXIs1DFdtbEZiZrOH3fbnxMss3COAbYFbUaITO8Er6ew7ql70Lyt4E
         nSWx2WSslAGcQH9aAsmncbrnNQb0LKXDIsF9zxbOhYSgQRcl5vlEZytygczt0UeAksPh
         6X0QLOUZwf5enjSKbvKkLkYrsNVuwH8gXpaxeoxLguEUBuyV4VGEiQ9w8ZZS+kHsTqwg
         maeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=sJLnXDsHznYw/y9+C7wzShyN9Wwvr5DZWWyzY2HDX0I=;
        b=rvH8akObMlU/7R7XMAFAYB31xTFRt73tv+0DoE5LF7HqxFGTy/+R45ZdvrYFs5GD8p
         M3Gry25+4Z4j7+WJpjQJL95V7pQHmLoUUKcLZLz3V0tQlNFfn1DlPTiNsmQGIorkHZr1
         rWLdEkrI5tLylXWBshpD3j28CpyZJMr5xWIzMWATu1qNzcvVM31ulMPEMHFz5iMru85G
         fxlfUrVXJ6NBWKWengRBJrBFxh3djWhrHJnczfCtWJ39viknf85I/reLdegKxG1Ax9yv
         dI34CWtM/z1gn7C7VuvHxIEqiDoAL0T2rHPY+irsqjykvMnxeRB/4Gcbf670hua8NeO4
         hmqg==
X-Gm-Message-State: AA+aEWYCCqK8tUuTR8J2Ieu9gMV5cR+gZK+gRK1Xl1z7xZ96L8Yz8/ip
        mMdOSeLuee5JikAy8fb6KSuVuA==
X-Google-Smtp-Source: AJdET5c+AY+IB9B2qHxzIpqC1lwDLldJ1F1raub0NfwxmDQJ1gREmkbAxWpo6XTOy+LqnNOYNihBkw==
X-Received: by 2002:a1c:2304:: with SMTP id j4mr6831819wmj.14.1542827228217;
        Wed, 21 Nov 2018 11:07:08 -0800 (PST)
Received: from pathfinder (62-64-249-96.dynamic.dsl.as9105.com. [62.64.249.96])
        by smtp.gmail.com with ESMTPSA id y8sm1903282wmg.13.2018.11.21.11.07.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:07:07 -0800 (PST)
Date:   Wed, 21 Nov 2018 19:07:06 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     clm@fb.com
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk, jbacik@fb.com,
        dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH v4 09/09] btrfs: use common file type conversion
Message-ID: <20181121190706.GA7745@pathfinder>
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
---
 fs/btrfs/btrfs_inode.h          |  2 --
 fs/btrfs/delayed-inode.c        |  2 +-
 fs/btrfs/inode.c                | 32 +++++++++++++++-----------------
 include/uapi/linux/btrfs_tree.h |  2 ++
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 97d91e55b70a..bb01c804485f 100644
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
index 9ea4c6f0352f..8b7b1b29e2ad 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -72,17 +72,6 @@ struct kmem_cache *btrfs_trans_handle_cachep;
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
@@ -5793,10 +5782,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-unsigned char btrfs_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
-
 /*
  * All this infrastructure exists because dir_emit can fault, and we are holding
  * the tree lock when doing readdir.  For now just allocate a buffer and copy
@@ -5935,7 +5920,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
 				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
@@ -6340,7 +6325,20 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 static inline u8 btrfs_inode_type(struct inode *inode)
 {
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+	/*
+	 * compile-time asserts that generic FT_x types still match
+	 * BTRFS_FT_x types
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
index aff1356c2bb8..4126ed7ee89a 100644
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
2.19.1

