Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CDA3EB119
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408293; cv=none; b=UzYmvsEHKBy0TSxCiuzBSkgKrWYncdIJ1/8oOfUIgvFfTmjMiDLmx7eLIyVjBYLI60tM3DcEpZ0AkvvUnRt5alaigHak00kgqI9K85APgMwMM5krZffslUxI9hgBXAeoaogBUSbNHILMy5JUBsEmt3mxNFPdFCWqpcm30UYm4aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408293; c=relaxed/simple;
	bh=kXI5wiaoSnj2hlwt4noRC7VoHXl2gfLiESdOeQRQl5o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=li10WjbiAEV3iT9SinEwioPONcKEjYwqZez9V2v9ClPwRtuS+l0543ZqGaOjl7KcBsi9oA/trZU6j0OYZziHD7Xi/Jxf8C/ijuCvSjbsfwBBxS9+ouhuFSX91wPH5CTImGxFe9o2ht2OlRLuuKRiiFJCzpRa3YxNDlBTnmj8S/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=O5ck2jT3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="O5ck2jT3"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b64c8311so1161635e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 10:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782408291; x=1783013091; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=piTTZmamm86ppzEnntpYmsBy+AEInqXutL5xRyLtkBk=;
        b=O5ck2jT33TrB5F+0ZMPe8xLivfqF+YTc9a3Sx8J9dzjPBT8xvdKJurtwKiGOd4zLaK
         JiCKGhpiCsen+iD/757xcF5CPHFnT/WrF3hLNq/1UtzCiHZYWk2VA7E+a6N9jkkFotMK
         0G4h+N8fo7VynsItxqHxVgqZN69z2blfgiDUSaQLtl5cz1KVOKNF/68QIaC2DW3lP12c
         nmxLBzAR9oq8Bq8jDOyfjAl4yiBolhMGBjDRjNKMl6l9onBlFwqfZevB3vLZiDQ8S4wU
         yTXjG7UfPJ+6l+9CCgGX8dnl//+4N3CpTyWBE6aqquLqzDAEi3dBh2LKqiBgL46EpIyM
         AJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782408291; x=1783013091;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=piTTZmamm86ppzEnntpYmsBy+AEInqXutL5xRyLtkBk=;
        b=TsViVt00Mbr4csKDGO1X5qkwOjuOu9w042GARHrm62k6q4hr5dYZbQfF4U8fRlPuHV
         SdVcnOpB/BxwGgAxnQVBQJefPRrKfSZW21l5fwKMUQ3RCqcrFnjOruFvNb2Udw/6/O/P
         CMT3C0xCClhr6wE7IhtY8GOEi1drNJgMEBPK31LntqqG/uQOeUsTUYtc06cgO2BuY5r3
         H9aaSZWAw2351hp+HPUbb7QOA37nPXKRtHmiTcaLnotgtYTow20aAkxCcUJxr495pvZt
         bD5bi9riL2fU6z51siT4sCItHzKyBvIC6ccfZCqjbJp08Kb+ToJS4Wnmk2kjjEbmOukA
         wLeA==
X-Forwarded-Encrypted: i=1; AFNElJ+L6oqOupp4QoHlQr71DV7TrjCiuPALt5upr3+2hxSPKCQTU6gnipuVMQA/hXSud/WwJ8nN+uNHRUMRmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlKdsBsfBDpfJNNIDj0L6HJsBitWdDOXoUCtXSBwFszpMsN4HC
	ds2sAEfzv3c+D3in3LSpvkDd71GdQD2jh12KM6Wctz6UxE8iY04nl49SiTjkNKN9APY=
X-Gm-Gg: AfdE7clbxinSxwPv8nPqWDxxkobkEkZ2xP/YptiHNvws7c+mlI1/D6YxO2xGT/uW00X
	eOzJYCshvlemyR1ZIwTIDMCAlgklWDzatg7KXWsFkm6N0Fl02tGZ/7F71YpNsVXlnuEl/ONelmB
	0xT/zuP5pvEl5PbKtUTlaEpSP924WfXPGBBWAHKM4SXj/5nxrsKwJ3QF7KtkYcTKe7pGVMyGf8d
	a9IiQFxdb9B1EQTiWDM4DKzackyzaw6P1QvR617kaLDGc/iajgKdXpqOl3jiQCYc18leLAGPLM9
	SV/LZ2qwdz/MngxokqBiaJuXnSIMGjCN3ne+f2QprBBgnS1YAidhvVLsBB40w3ZN8NnFVThW8pV
	e92kRa/L2FrFatkjsFK+ECXjS1Y2MnS8ElMqinZWdiHQnyboNexIFMPxvIRYUf0n7mT5VNANi4K
	lHkbn+mY9oQvIJraPGBWZ4Xnh+FxdnbZ31dN/IYBS2
X-Received: by 2002:a05:600c:a403:b0:490:9782:3eb8 with SMTP id 5b1f17b1804b1-4926689fab5mr40578555e9.25.1782408290529;
        Thu, 25 Jun 2026 10:24:50 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492697ba453sm2585755e9.0.2026.06.25.10.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 10:24:50 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 25 Jun 2026 21:24:21 +0400
Subject: [PATCH 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-btrfs-readdir-v1-1-dd781a2b3965@flipper.net>
References: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
In-Reply-To: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7680; i=alchark@flipper.net;
 h=from:subject:message-id; bh=kXI5wiaoSnj2hlwt4noRC7VoHXl2gfLiESdOeQRQl5o=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZpsQt57KZ1vNr/W5P3vkW02xdk0Pr94mo9xTd/z/9y
 V9VMZ71HRNZGMS4GCzFFFnmfltiO9WIb9YuD4+vMHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 oZGOsY4RAxenAEw15zlGhp4L4bmWG3c2aO4qt0zOsc1K/mpUFBp4Jfp7dvRrnuB3Vxj+CrodWfl
 xxmWZb2e+1el5T3jSeP4FX6b1KpU1Vy494/w9kw8A
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Add support for generic directory iteration with opendir(), readdir() and
closedir() in the btrfs filesystem driver, following the ext4fs
implementation for opendir()/closedir() and the btrfs_iter_dir() function
for readdir().

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 fs/btrfs/btrfs.c    | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h    |  2 ++
 fs/btrfs/dir-item.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fs.c             |  4 ++-
 include/btrfs.h     |  5 +++
 5 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index f3087f690fa4..c647c8dedf4e 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -9,6 +9,7 @@
 #include <malloc.h>
 #include <u-boot/uuid.h>
 #include <linux/time.h>
+#include <fs.h>
 #include "btrfs.h"
 #include "crypto/hash.h"
 #include "disk-io.h"
@@ -159,6 +160,97 @@ int btrfs_ls(const char *path)
 	return 0;
 }
 
+struct btrfs_dir_stream {
+	struct fs_dir_stream parent;
+	struct fs_dirent dirent;
+	char *dirname;
+	u64 offset;
+};
+
+int btrfs_opendir(const char *dirname, struct fs_dir_stream **dirsp)
+{
+	struct btrfs_fs_info *fs_info = current_fs_info;
+	struct btrfs_dir_stream *dirs;
+	struct btrfs_root *root;
+	u64 ino;
+	u8 type;
+	int ret;
+
+	*dirsp = NULL;
+	ASSERT(fs_info);
+
+	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
+				dirname, &root, &ino, &type, 40);
+	if (ret < 0)
+		return ret;
+	if (type != BTRFS_FT_DIR)
+		return -ENOTDIR;
+
+	dirs = calloc(1, sizeof(*dirs));
+	if (!dirs)
+		return -ENOMEM;
+	dirs->dirname = strdup(dirname);
+	if (!dirs->dirname) {
+		free(dirs);
+		return -ENOMEM;
+	}
+
+	*dirsp = (struct fs_dir_stream *)dirs;
+	return 0;
+}
+
+int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
+{
+	struct btrfs_dir_stream *dirs = (struct btrfs_dir_stream *)fs_dirs;
+	struct btrfs_fs_info *fs_info = current_fs_info;
+	struct fs_dirent *dent = &dirs->dirent;
+	struct btrfs_root *root;
+	u64 ino;
+	u8 type;
+	int ret;
+
+	*dentp = NULL;
+	ASSERT(fs_info);
+
+	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
+				dirs->dirname, &root, &ino, &type, 40);
+	if (ret < 0)
+		return ret;
+	if (type != BTRFS_FT_DIR)
+		return -ENOTDIR;
+
+	memset(dent, 0, sizeof(*dent));
+	ret = btrfs_next_dir_entry(root, ino, &dirs->offset, dent->name,
+				   sizeof(dent->name), &type);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		return -ENOENT;
+
+	switch (type) {
+	case BTRFS_FT_DIR:
+		dent->type = FS_DT_DIR;
+		break;
+	case BTRFS_FT_SYMLINK:
+		dent->type = FS_DT_LNK;
+		break;
+	default:
+		dent->type = FS_DT_REG;
+		break;
+	}
+
+	*dentp = dent;
+	return 0;
+}
+
+void btrfs_closedir(struct fs_dir_stream *fs_dirs)
+{
+	struct btrfs_dir_stream *dirs = (struct btrfs_dir_stream *)fs_dirs;
+
+	free(dirs->dirname);
+	free(dirs);
+}
+
 int btrfs_exists(const char *file)
 {
 	struct btrfs_fs_info *fs_info = current_fs_info;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b7be09d5df83..7de35aa7efd5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1225,6 +1225,8 @@ typedef int (*btrfs_iter_dir_callback_t)(struct btrfs_root *root,
 					 struct btrfs_dir_item *di);
 int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
 		   btrfs_iter_dir_callback_t callback);
+int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset,
+			 char *namebuf, int namebuf_len, u8 *ftype);
 /* inode.c */
 int btrfs_lookup_path(struct btrfs_root *root, u64 ino, const char *filename,
 			struct btrfs_root **root_ret, u64 *ino_ret,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 5f81d6414f06..8cf5be3790e7 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -166,3 +166,94 @@ out:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * btrfs_next_dir_entry() - read one directory entry at or after a cursor
+ *
+ * Streaming counterpart to btrfs_iter_dir() for the fs-layer readdir, which
+ * is re-entered once per entry: returns the first real entry whose
+ * BTRFS_DIR_INDEX_KEY offset is >= *offset and advances *offset past it.
+ *
+ * @root, @ino:		directory to read
+ * @offset:		in/out cursor; DIR_INDEX offset to resume from
+ * @namebuf:		caller buffer that receives the NUL-terminated name
+ * @namebuf_len:	size of @namebuf in bytes
+ * @ftype:		receives the BTRFS_FT_* type of the entry
+ *
+ * Return: 0 if an entry was returned, 1 when the directory is exhausted,
+ *	   -ve on error.
+ */
+int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset,
+			 char *namebuf, int namebuf_len, u8 *ftype)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	int ret;
+
+	btrfs_init_path(&path);
+	key.objectid = ino;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = *offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		struct btrfs_dir_item *di;
+		int name_len;
+		u8 type;
+
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {		/* end of tree */
+				ret = 1;
+				goto out;
+			}
+		}
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.objectid != ino || key.type != BTRFS_DIR_INDEX_KEY) {
+			ret = 1;		/* no more entries for this dir */
+			goto out;
+		}
+
+		di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				    struct btrfs_dir_item);
+		if (verify_dir_item(root, path.nodes[0], di)) {
+			ret = -EUCLEAN;
+			goto out;
+		}
+
+		*offset = key.offset + 1;
+		type = btrfs_dir_type(path.nodes[0], di);
+
+		/* XATTRs share the key space but are not directory entries. */
+		if (type == BTRFS_FT_XATTR) {
+			ret = btrfs_next_item(root, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {
+				ret = 1;
+				goto out;
+			}
+			continue;
+		}
+
+		name_len = btrfs_dir_name_len(path.nodes[0], di);
+		if (name_len > namebuf_len - 1)
+			name_len = namebuf_len - 1;
+		read_extent_buffer(path.nodes[0], namebuf,
+				   (unsigned long)(di + 1), name_len);
+		namebuf[name_len] = '\0';
+		*ftype = type;
+		ret = 0;
+		goto out;
+	}
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
diff --git a/fs/fs.c b/fs/fs.c
index 8ea50a6c13c4..4694a88f776b 100644
--- a/fs/fs.c
+++ b/fs/fs.c
@@ -326,7 +326,9 @@ static struct fstype_info fstypes[] = {
 		.read = btrfs_read,
 		.write = fs_write_unsupported,
 		.uuid = btrfs_uuid,
-		.opendir = fs_opendir_unsupported,
+		.opendir = btrfs_opendir,
+		.readdir = btrfs_readdir,
+		.closedir = btrfs_closedir,
 		.unlink = fs_unlink_unsupported,
 		.mkdir = fs_mkdir_unsupported,
 		.ln = fs_ln_unsupported,
diff --git a/include/btrfs.h b/include/btrfs.h
index 2d73add18e09..6fff45a497ee 100644
--- a/include/btrfs.h
+++ b/include/btrfs.h
@@ -10,6 +10,8 @@
 
 struct blk_desc;
 struct disk_partition;
+struct fs_dir_stream;
+struct fs_dirent;
 
 int btrfs_probe(struct blk_desc *fs_dev_desc,
 		struct disk_partition *fs_partition);
@@ -20,5 +22,8 @@ int btrfs_read(const char *, void *, loff_t, loff_t, loff_t *);
 void btrfs_close(void);
 int btrfs_uuid(char *);
 void btrfs_list_subvols(void);
+int btrfs_opendir(const char *filename, struct fs_dir_stream **dirsp);
+int btrfs_readdir(struct fs_dir_stream *dirs, struct fs_dirent **dentp);
+void btrfs_closedir(struct fs_dir_stream *dirs);
 
 #endif /* __U_BOOT_BTRFS_H__ */

-- 
2.53.0

