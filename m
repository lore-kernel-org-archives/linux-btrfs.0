Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02DD39FCB5
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487137; cv=none; b=RRkDczypIqTBLgSnVHRwtBqUMx3VzJJG3Muypm5qTN/jQPG1ccGiU9UjHpKvoepq20J1D8Bq4JxFa4PE2uZSTxJc8enEotnovQbuDz3rMCTzpldR4uiNNfg52+2l5wHvUQ5eSLo0rcs6WyNJfkAwS5Pk83iugQdY4MMx60tUk4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487137; c=relaxed/simple;
	bh=udVAXUrG90NHbIAuqCRY1nW7Y9JtNz8sVz5gLH1i9ug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gWzEO2eQvf2Fsn55WupjKvjTTlLIZLE6HMTkJgBN7grorgUjnxuNzX8ip+imZdjklIpUfysAgmLn7jYjp1D6CAdw13LAcHIOhJ9Oqgzx245rsRbKB+NEhJb3dAzBue0H9h1Zq92rafr9QvE0w/VCW3/ta1t+nBEKn7JyEPWP2OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=NBFlembS; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="NBFlembS"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-462342ac290so1169123f8f.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782487134; x=1783091934; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qcspnj9HibuTkiq0OfUlH3L2tuWTbycqLmr4pyIENic=;
        b=NBFlembSwtrr3ph/PNyK4AVP+3Umug4eeCHE6LtatgFT3o/t9cM4A+SbbZeSgjqc67
         HdBbX+gxPkZh+AhCzZXPDB6fI6BgUvZCWOE7egYol8GZrdr6v38aOunKxYBjecZKcRc5
         1mqT7qPN5C+D2fV5rt55Jy8Fj/WFWlKZGHevNo71urYiUMsyg63rYNWzB8lCZJ0fDC3w
         +KlS21QZKOEmw5tzzGwSPO/cvYYMra5pSgr70omyUAqJHcGxNGK8rJP2lQXHAcLJw9HU
         QKQZA43aJ7ywwkwYdNjbGM8MgqlIlc5GijX8WBczxUO6qdWpoUHVGVUbZn+cnp+rr4mY
         sVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487134; x=1783091934;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qcspnj9HibuTkiq0OfUlH3L2tuWTbycqLmr4pyIENic=;
        b=EBFqi/sQZM/v2q2jRgcR1lq7GQBYMpOLpReSejFc8Uu+e8YAmd/xGTRCDbODLlcViY
         IzZNR6rrkwY4grShiFDqq7ZbC+6p4UYgPguYaMW3eZY7236MHPlT3EILSUG/3AcKsio6
         yQ9QqzkNQUaGplFYx0I6qHcqYeU2SrgtU1Wf/UxRXRqhAyGlGa9CEZBy+Rkq5AhWBqFi
         OM5MTtGSBL+yzLYaVeUg0WvUwl+FGPUyg9Vrjx2SLonQ+8FdEdYoMtUSQXUP9vM5/SAQ
         W151FSCCzvvdnGHwvpkkDrpzpZ79lHbxOzm94+JR8XRSCvOltXnSBSHxsXy6nGKvfIdb
         222A==
X-Forwarded-Encrypted: i=1; AFNElJ+t+P4wq8cyIrwRpRq+ZHpWVbCBa+miP8UCCOq1GPEinbR0QGAyiVNvn45pYrn1gmczASQP2BPTvFijtw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/m4IHJelS0gm1tvKERBn5rbtgXc3GxnLAX5B9CUXkVA2ZonUj
	c0BsCykwBQOvGFik9eZ+jGSEu5hNOKAlYDRSBYxB+8y3wB7b/AjboppJ9e6QEvjQdys=
X-Gm-Gg: AfdE7cn21yG1qZykpMGqeVQysNsjgMvaVKmmmjGRPe+nvBt7oPj6ql2/fGac44z3xez
	6onvXOLibHbvwtBy1VfoX8S2vdtbDh23QPGLd4+j2SMIKXpCTRinBaC/4AE6HwciReZYgbJE2Tm
	2L5616qk985RPeZsQMXO6mf43cE6kcvBxP3xRMIPqrz3fAaeh3GHWAnWII3qFkyxgWp6qHCVHqt
	XtOKjmatHuLvVw/nncydCgDWMnsyW8AA1h+Ktvir3i5Hs/10a4sFHGI8jROF8pOVypiR61TArbj
	bH1+rFFo7a5hEdFoFoLHKyl4QZfOg+4ZzSNgbdDPOThnORpJGiGmu7Qs5v+MSQmvzAhrykcnkNT
	xNqT4EWzj0uPIFut1xfxsXuro/IF8jTAwpx1xN8bzkEcDjqCyNviCzsPrU/a2D94Zq7BnRqa2JP
	iTp8069qqx8dI/3Dt7oaKjAahBIQ9HiA==
X-Received: by 2002:a05:600c:620d:b0:492:30f2:963a with SMTP id 5b1f17b1804b1-492667e849fmr108403535e9.0.1782487134121;
        Fri, 26 Jun 2026 08:18:54 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d998esm24860736f8f.24.2026.06.26.08.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 08:18:53 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 26 Jun 2026 19:18:22 +0400
Subject: [PATCH v2 2/2] fs: btrfs: use fs_ls_generic() and drop custom
 implementation
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-btrfs-readdir-v2-2-7dd43f72d1b4@flipper.net>
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
In-Reply-To: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8436; i=alchark@flipper.net;
 h=from:subject:message-id; bh=udVAXUrG90NHbIAuqCRY1nW7Y9JtNz8sVz5gLH1i9ug=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZzQh/kcD9ynmtE6fgMf5bgUd99U4WHjnv7ruUU/lAv
 0Qg1+VJHRNZGMS4GCzFFFnmfltiO9WIb9YuD4+vMHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 oZGOsY4RAxenAEy17mOG/yViaR+SGdpUp2bvTg/b971s4+ML69m1lrVlZGf7Wm2czMLIMFfUb9K
 CGFNHhtwPh4pSb79Tm3NTactGF5f7h//12SSt5AQA
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Now that generic callbacks for opendir/readdir/closedir are implemented,
the custom btrfs_ls() implementation is no longer needed, along with the
btrfs_iter_dir() callback iterator.

Use fs_ls_generic() instead.

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 fs/btrfs/btrfs.c    | 129 ----------------------------------------------------
 fs/btrfs/ctree.h    |   5 --
 fs/btrfs/dir-item.c |  59 ++----------------------
 fs/fs.c             |   2 +-
 include/btrfs.h     |   1 -
 5 files changed, 4 insertions(+), 192 deletions(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index 6f034861da90..e663dda12e80 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -17,107 +17,6 @@
 
 struct btrfs_fs_info *current_fs_info;
 
-static int show_dir(struct btrfs_root *root, struct extent_buffer *eb,
-		    struct btrfs_dir_item *di)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_inode_item ii;
-	struct btrfs_key key;
-	static const char* dir_item_str[] = {
-		[BTRFS_FT_REG_FILE]	= "   ",
-		[BTRFS_FT_DIR]		= "DIR",
-		[BTRFS_FT_CHRDEV]	= "CHR",
-		[BTRFS_FT_BLKDEV]	= "BLK",
-		[BTRFS_FT_FIFO]		= "FIF",
-		[BTRFS_FT_SOCK]		= "SCK",
-		[BTRFS_FT_SYMLINK]	= "SYM",
-	};
-	u8 type = btrfs_dir_type(eb, di);
-	char namebuf[BTRFS_NAME_LEN];
-	char *target = NULL;
-	char filetime[32];
-	time_t mtime;
-	int ret = 0;
-
-	/* skip XATTRs in directory listing */
-	if (type == BTRFS_FT_XATTR)
-		return 0;
-
-	btrfs_dir_item_key_to_cpu(eb, di, &key);
-
-	if (key.type == BTRFS_ROOT_ITEM_KEY) {
-		struct btrfs_root *subvol;
-
-		/* It's a subvolume, get its mtime from root item */
-		subvol = btrfs_read_fs_root(fs_info, &key);
-		if (IS_ERR(subvol)) {
-			ret = PTR_ERR(subvol);
-			error("Can't find root %llu", key.objectid);
-			return ret;
-		}
-		mtime = btrfs_stack_timespec_sec(&subvol->root_item.otime);
-	} else {
-		struct btrfs_path path;
-
-		/* It's regular inode, get its mtime from inode item */
-		btrfs_init_path(&path);
-		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-		if (ret > 0)
-			ret = -ENOENT;
-		if (ret < 0) {
-			error("Can't find inode %llu", key.objectid);
-			btrfs_release_path(&path);
-			return ret;
-		}
-		read_extent_buffer(path.nodes[0], &ii,
-			btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
-			sizeof(ii));
-		btrfs_release_path(&path);
-		mtime = btrfs_stack_timespec_sec(&ii.mtime);
-	}
-	ctime_r(&mtime, filetime);
-
-	if (type == BTRFS_FT_SYMLINK) {
-		target = malloc(fs_info->sectorsize);
-		if (!target) {
-			error("Can't alloc memory for symlink %llu",
-				key.objectid);
-			return -ENOMEM;
-		}
-		ret = btrfs_readlink(root, key.objectid, target);
-		if (ret < 0) {
-			error("Failed to read symlink %llu", key.objectid);
-			goto out;
-		}
-		target[ret] = '\0';
-	}
-
-	if (type < ARRAY_SIZE(dir_item_str) && dir_item_str[type])
-		printf("<%s> ", dir_item_str[type]);
-	else
-		printf("?%3u? ", type);
-	if (type == BTRFS_FT_CHRDEV || type == BTRFS_FT_BLKDEV) {
-		ASSERT(key.type == BTRFS_INODE_ITEM_KEY);
-		printf("%4llu,%5llu  ", btrfs_stack_inode_rdev(&ii) >> 20,
-				btrfs_stack_inode_rdev(&ii) & 0xfffff);
-	} else {
-		if (key.type == BTRFS_INODE_ITEM_KEY)
-			printf("%10llu  ", btrfs_stack_inode_size(&ii));
-		else
-			printf("%10llu  ", 0ULL);
-	}
-
-	read_extent_buffer(eb, namebuf, (unsigned long)(di + 1),
-			   btrfs_dir_name_len(eb, di));
-	printf("%24.24s  %.*s", filetime, btrfs_dir_name_len(eb, di), namebuf);
-	if (type == BTRFS_FT_SYMLINK)
-		printf(" -> %s", target ? target : "?");
-	printf("\n");
-out:
-	free(target);
-	return ret;
-}
-
 int btrfs_probe(struct blk_desc *fs_dev_desc,
 		struct disk_partition *fs_partition)
 {
@@ -133,34 +32,6 @@ int btrfs_probe(struct blk_desc *fs_dev_desc,
 	return ret;
 }
 
-int btrfs_ls(const char *path)
-{
-	struct btrfs_fs_info *fs_info = current_fs_info;
-	struct btrfs_root *root = fs_info->fs_root;
-	u64 ino = BTRFS_FIRST_FREE_OBJECTID;
-	u8 type;
-	int ret;
-
-	ASSERT(fs_info);
-	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
-				path, &root, &ino, &type, 40);
-	if (ret < 0) {
-		printf("Cannot lookup path %s\n", path);
-		return ret;
-	}
-
-	if (type != BTRFS_FT_DIR) {
-		error("Not a directory: %s", path);
-		return -ENOENT;
-	}
-	ret = btrfs_iter_dir(root, ino, show_dir);
-	if (ret < 0) {
-		error("An error occurred while listing directory %s", path);
-		return ret;
-	}
-	return 0;
-}
-
 /*
  * The fs layer closes and re-probes btrfs between readdir() calls (see
  * fs_readdir() in fs/fs.c), freeing and reallocating fs_info, so root cannot
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7de35aa7efd5..3fa9a8c9c020 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1220,11 +1220,6 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_path *path, u64 dir,
 					     const char *name, int name_len,
 					     int mod);
-typedef int (*btrfs_iter_dir_callback_t)(struct btrfs_root *root,
-					 struct extent_buffer *eb,
-					 struct btrfs_dir_item *di);
-int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
-		   btrfs_iter_dir_callback_t callback);
 int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset,
 			 char *namebuf, int namebuf_len, u8 *ftype);
 /* inode.c */
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index b12298e20c41..c7b87d60d986 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -114,65 +114,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
 
-int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
-		   btrfs_iter_dir_callback_t callback)
-{
-	struct btrfs_path path;
-	struct btrfs_key key;
-	int ret;
-
-	btrfs_init_path(&path);
-	key.objectid = ino;
-	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = 0;
-
-	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0)
-		return ret;
-	/* Should not happen */
-	if (ret == 0) {
-		ret = -EUCLEAN;
-		goto out;
-	}
-	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
-		ret = btrfs_next_leaf(root, &path);
-		if (ret < 0)
-			goto out;
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
-	}
-	do {
-		struct btrfs_dir_item *di;
-
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		if (key.objectid != ino || key.type != BTRFS_DIR_INDEX_KEY)
-			break;
-		di = btrfs_item_ptr(path.nodes[0], path.slots[0],
-				    struct btrfs_dir_item);
-		if (verify_dir_item(root, path.nodes[0], di)) {
-			ret = -EUCLEAN;
-			goto out;
-		}
-		ret = callback(root, path.nodes[0], di);
-		if (ret < 0)
-			goto out;
-	} while (!(ret = btrfs_next_item(root, &path)));
-
-	if (ret > 0)
-		ret = 0;
-out:
-	btrfs_release_path(&path);
-	return ret;
-}
-
 /*
  * btrfs_next_dir_entry() - read one directory entry at or after a cursor
  *
- * Streaming counterpart to btrfs_iter_dir() for the fs-layer readdir, which
- * is re-entered once per entry: returns the first real entry whose
- * BTRFS_DIR_INDEX_KEY offset is >= *offset and advances *offset past it.
+ * Iterator for the fs-layer readdir, which is re-entered once per entry:
+ * returns the first real entry whose BTRFS_DIR_INDEX_KEY offset is
+ * >= *offset and advances *offset past it.
  *
  * @root, @ino:		directory to read
  * @offset:		in/out cursor; DIR_INDEX offset to resume from
diff --git a/fs/fs.c b/fs/fs.c
index 4694a88f776b..1ebda6f4ee2a 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -320,7 +320,7 @@ static struct fstype_info fstypes[] = {
 		.null_dev_desc_ok = false,
 		.probe = btrfs_probe,
 		.close = btrfs_close,
-		.ls = btrfs_ls,
+		.ls = fs_ls_generic,
 		.exists = btrfs_exists,
 		.size = btrfs_size,
 		.read = btrfs_read,
diff --git a/include/btrfs.h b/include/btrfs.h
index 6fff45a497ee..3878b7817ea6 100644
--- a/include/btrfs.h
+++ b/include/btrfs.h
@@ -15,7 +15,6 @@ struct fs_dirent;
 
 int btrfs_probe(struct blk_desc *fs_dev_desc,
 		struct disk_partition *fs_partition);
-int btrfs_ls(const char *);
 int btrfs_exists(const char *);
 int btrfs_size(const char *, loff_t *);
 int btrfs_read(const char *, void *, loff_t, loff_t, loff_t *);

-- 
2.53.0

