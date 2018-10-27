Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD36ECDE46
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 00:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C763D20843
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 00:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="Zs4sCQ04"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C763D20843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbeJ0Jed (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 05:34:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37073 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbeJ0JdC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 05:33:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id g9-v6so2961027wrq.4
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 17:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=+IPHwtDg25aGwsv5fq54JsS+mjXOcSigJAt50TVqX/Y=;
        b=Zs4sCQ0481xtJyiDmmAkajqegEMiXmjHKnyPfK04WUL6OFIeh2oHcgKodJf7+CC7r1
         Cyd13fNjofuJdNMQXBSdUw64v4ZTwNYOUjE7ArQ9+ipzkWqUl52OQ7a2JbIslvUJH0dR
         IPDK7HkmzNvL0+cnkb5AT96Mwq8G49wl/kRu+4+ckHwS9l/r8OetBX+yaD4M2kNTZ608
         ChgqwYIf3RnoE1TGBGUbDIMYeKj42tndhWbd8M9VoPmQG7pDbjMDIjZrHf7GdJRzcnKH
         /82rz5f238/4AaXc9FC5fRzLSNLqTrMbdBqsig53NeLtTgcyFKyVC9H6sW365ueD8VqJ
         U/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=+IPHwtDg25aGwsv5fq54JsS+mjXOcSigJAt50TVqX/Y=;
        b=Vwt587WG9uCyYBWP7ZNj56z/WpSGUgNaaXecq60lVABSUQz98SXEjsRzxrJpuRbg9e
         ybbWQFLmMi0Pr8Ma7Qcex4zPih1XfpKbTXzd8F4DfYnmGXqAnSp3EIp7Q6TDtzR2HFsJ
         G2y5qhHtDp/FBb8A5iic10iYJr7hR3ZdwX3Fb8FKeJSYzGpTp7+wt7j19j6FDYpfrcGl
         u7gISSKmoyRa2QP1clqqpHLhwCbnbUsek3yOcDOnyVbRCQ5TzArWt8VuIiq+xTmhq1ms
         9V9kuO35CbhXAdKqFLs1Biss0l5B566k9CxyQ16tFD9OTS9VTLEzAmgvlrgumOdttaG1
         VILQ==
X-Gm-Message-State: AGRZ1gLQf4DtqL2nPb4mpbtBHHcu/3WhieUw0AsKu87w/VyEzpday58E
        p+lq2DZ6u6UUNDdU6uttdhmS9w==
X-Google-Smtp-Source: AJdET5cQIVXhol8DUKW9uf5hyNPIOPoKd/PDOoQrl073sW4yh/M2KKnS/nuIFygI773KAGzhnCzt+Q==
X-Received: by 2002:adf:dd8f:: with SMTP id x15-v6mr3006378wrl.29.1540601629475;
        Fri, 26 Oct 2018 17:53:49 -0700 (PDT)
Received: from pathfinder (62-64-249-96.dynamic.dsl.as9105.com. [62.64.249.96])
        by smtp.gmail.com with ESMTPSA id c2-v6sm10488546wrt.77.2018.10.26.17.53.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 17:53:48 -0700 (PDT)
Date:   Sat, 27 Oct 2018 01:53:48 +0100
From:   Phillip Potter <phil@philpotter.co.uk>
To:     clm@fb.com
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk, jbacik@fb.com,
        dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH v3 10/10] btrfs: use common file type conversion
Message-ID: <20181027005348.GA9996@pathfinder>
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

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/btrfs/btrfs_inode.h          |  2 --
 fs/btrfs/delayed-inode.c        |  2 +-
 fs/btrfs/inode.c                | 32 +++++++++++++++-----------------
 include/uapi/linux/btrfs_tree.h |  2 ++
 4 files changed, 18 insertions(+), 20 deletions(-)

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
+		d_type = fs_ftype_to_dtype(di->type);
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
 		over = !dir_emit(ctx, name, name_len,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..089638719842 100644
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
@@ -5879,6 +5864,19 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	bool put = false;
 	struct btrfs_key location;
 
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
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
@@ -5945,7 +5943,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
+		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
 				&entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
@@ -6350,7 +6348,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 static inline u8 btrfs_inode_type(struct inode *inode)
 {
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+	return fs_umode_to_ftype(inode->i_mode);
 }
 
 /*
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..a4f5fb56a45b 100644
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
2.17.2

