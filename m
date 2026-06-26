Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD041391512
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487135; cv=none; b=YbVoBGlzxg0O0xG0kJ2ObFHIlPNlxzaLGvyQhlExEpqq36k/0sY+JzwCCL3+B9bavV+oZ1mwXqnbVArVvU75V71Uv2eBtY8cayY4uTB6QntWLynxjdhiDIsgn5ofT431qx9LAr36Mn5Ahdp5DxL4I5m/D9Q6nthJigYQD1e5aWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487135; c=relaxed/simple;
	bh=9vAmWS9ZXq+LRpD282fup88uVT5fQflHpn5EzE0P40U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HlAfZLlIPInmadrL0cSw0XIHbqSZjef4te5atBhcMXD/NgXy2Xff8C15or6Z8Q9cqsf7QB+VeqPHml2mfLpHLZwbhvddlTL/WHiKUCFqttltTmHEK5vpd2Nv1AN2pCBIhYXLSvtVluyWtJIawm3S3LCSn6VAhDJvruD9YmQ37Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=UOQ6WLIS; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="UOQ6WLIS"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-462342ac290so1169058f8f.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 08:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782487132; x=1783091932; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=35V2vQTLQLhmqsePEl2RESRQ9L4/O/tEro/g7K/1jlQ=;
        b=UOQ6WLISeh1/KMuw5MB0i4N/A6oY39/m5X9IfOb1E0U0+mzQCKcGX1r2W0bGtvr3iP
         DkWhP+7mv7VlxAW7KTehg8KEOcz0cIxZYaWTUMtG3YTadW3rP8NUuD5UaQJleEcnnqYG
         PxV6g3HcvoR/d2Pm5Aa9oTzXk3qOvV0pI8Cf2klW81u67TuGU/38i6PSIvgxkfleY1oC
         kxJGp5glaIO9YvQqfO+l0dY7bp5v1WVr5fdNaZeNO0mxizyhraEZM8/mmd9NUKCEkUbG
         KJK4otRtrfNhL1qMJi45TujvbOdVAWZirzL+IWGaBtDFPwIBOZcfocdgHEeVLc4Fusan
         wovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487132; x=1783091932;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=35V2vQTLQLhmqsePEl2RESRQ9L4/O/tEro/g7K/1jlQ=;
        b=CI+P4/B3xvff7QhgrVzW4p9ieCe2Qr4QgmEVz8v3pcmRgsM3AKOnr69bqfjRcBU4lL
         2X866CIh+HInaw8rmLoqTXSYvEauimBrXKAS86FCrf95FkCoYtdkHpEz4c/PTJHS8fH2
         zskER1WIoMHwbsXvfXvQOsadXMYIxihyUMz3fWH1UKzZKazdNMMwRoDO+EfMlbFcVDmJ
         n8Gkk6k4dIONFdVI3A+G/aSDqxxOICRDLWx9coOqheFqy75805+VDB7+oh8a49bEmcQV
         m37Gp1TsjB93bVPfaeG7MMCg7bcDQmKGjAoMgtKGGNk+rQOo0nmCQv/ouASgPZNAahtG
         h5Wg==
X-Forwarded-Encrypted: i=1; AHgh+Ro6yVls6QtTM2qV4tSFWQ2K9InniRPnL1XEY2v/nBm/iGWblRs6vF0rbzQA+xYucSiRZXe/9g+YKQq/rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZEZ5ZKgdZR3tL6YKWir6tU/M4F/qE9nwUlmYJw+qFzVrTgz64
	RGU97uXkX4Z3F1Uz34QBrxUIFVf88KvGNPHYGBKYNTJ3AdzuHe4DFF5l9v42ijxtWXI=
X-Gm-Gg: AfdE7cnd9QzMQ3Mwvzog4wiBAWXk9LK1yA29ZjgWnVMvlNfTqGfl3D8MFmv/EB0JcFZ
	AhJ1vqNOU7k48w7ht2dV7dCELY367/OkxTDml2fwq/E5DeTllgnyKLZ4a2YLVD1IvN+5nNcgiqa
	g6I4AJ12dDradcbQuKHsJSAnvl199/yHwZB2FusWyvETX3VW1uxB1MQN3Is6jesDgGDYQqFxRUX
	Vqa/XvNhB/Q3LptzO8G7eUJz8tW0aB2eFDDAZkQxc9gNf/hbT3tkX9d5KgHa1h3I492c5PuTHnM
	byHsey9h3MgcN9h2pmDGrk4rqL4bRda8n0SWT4LWjeT5aAF0CjQMq2BwK6dwiz6bcWk6ru6BJWn
	nqzjEIDYbxn6lBj3mi2pcw3+omQEZEgVPHBUvtzewjI9M08ry3H5dc0vT1g9UQ8nVg8QBoVECIq
	I386dDVccjG6MI2xqTdk9RWNSXZ1UjyQ==
X-Received: by 2002:a05:6000:4698:b0:46f:a0f1:c33f with SMTP id ffacd0b85a97d-46fa0f1c3e4mr1591478f8f.32.1782487131738;
        Fri, 26 Jun 2026 08:18:51 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d998esm24860736f8f.24.2026.06.26.08.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 08:18:51 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 26 Jun 2026 19:18:21 +0400
Subject: [PATCH v2 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-btrfs-readdir-v2-1-7dd43f72d1b4@flipper.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7680; i=alchark@flipper.net;
 h=from:subject:message-id; bh=9vAmWS9ZXq+LRpD282fup88uVT5fQflHpn5EzE0P40U=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZzQjPjv8ks26JkZ5bxS+jab+NT32dIO2ZoLbH+JDAf
 e7NE+emdUxkYRDjYrAUU2SZ+22J7VQjvlm7PDy+wsxhZQIZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkY6xjpGDFycAjDVbHcZGd7JLBPlc9TkfNP5hWX/wR0au6dmlx+8mrLwSsyJapF1nW8YGVaFBoi
 9PKzV5F9/+GWCj0JIOTvfg+j/EZeunlbr28kQxQMA
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Add support for generic directory iteration with opendir(), readdir() and
closedir() in the btrfs filesystem driver.

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
 fs/btrfs/btrfs.c    | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h    |  2 ++
 fs/btrfs/dir-item.c | 73 +++++++++++++++++++++++++++++++++++++++
 fs/fs.c             |  4 ++-
 include/btrfs.h     |  5 +++
 5 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
index f3087f690fa4..6f034861da90 100644
--- a/fs/btrfs/btrfs.c
+++ b/fs/btrfs/btrfs.c
@@ -8,7 +8,9 @@
 #include <config.h>
 #include <malloc.h>
 #include <u-boot/uuid.h>
+#include <linux/kernel.h>
 #include <linux/time.h>
+#include <fs.h>
 #include "btrfs.h"
 #include "crypto/hash.h"
 #include "disk-io.h"
@@ -159,6 +161,102 @@ int btrfs_ls(const char *path)
 	return 0;
 }
 
+/*
+ * The fs layer closes and re-probes btrfs between readdir() calls (see
+ * fs_readdir() in fs/fs.c), freeing and reallocating fs_info, so root cannot
+ * be stored directly. The subvolume id and inode number are stable though, so
+ * re-resolve the root from the current fs_info by subvolume id, which avoids
+ * a full path walk and is much faster.
+ */
+struct btrfs_dir_stream {
+	struct fs_dir_stream parent;
+	struct fs_dirent dirent;
+	u64 subvolid;
+	u64 ino;
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
+	dirs->subvolid = root->root_key.objectid;
+	dirs->ino = ino;
+
+	*dirsp = &dirs->parent;
+	return 0;
+}
+
+static unsigned int btrfs_dirent_type_to_fs_type(u8 dirent_type)
+{
+	switch (dirent_type) {
+	case BTRFS_FT_DIR:
+		return FS_DT_DIR;
+	case BTRFS_FT_SYMLINK:
+		return FS_DT_LNK;
+	default:
+		return FS_DT_REG;
+	}
+}
+
+int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
+{
+	struct btrfs_dir_stream *dirs = container_of(fs_dirs, struct btrfs_dir_stream, parent);
+	struct btrfs_fs_info *fs_info = current_fs_info;
+	struct fs_dirent *dent = &dirs->dirent;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	u8 type;
+	int ret;
+
+	*dentp = NULL;
+	ASSERT(fs_info);
+
+	key.objectid = dirs->subvolid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	memset(dent, 0, sizeof(*dent));
+	ret = btrfs_next_dir_entry(root, dirs->ino, &dirs->offset, dent->name,
+				   sizeof(dent->name), &type);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		return -ENOENT;
+
+	dent->type = btrfs_dirent_type_to_fs_type(type);
+	*dentp = dent;
+	return 0;
+}
+
+void btrfs_closedir(struct fs_dir_stream *fs_dirs)
+{
+	struct btrfs_dir_stream *dirs = container_of(fs_dirs, struct btrfs_dir_stream, parent);
+
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
index 5f81d6414f06..b12298e20c41 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -166,3 +166,76 @@ out:
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
+	struct btrfs_dir_item *di;
+	int name_len;
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
+	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+		ret = btrfs_next_leaf(root, &path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {		/* end of tree */
+			ret = 1;
+			goto out;
+		}
+	}
+
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	if (key.objectid != ino || key.type != BTRFS_DIR_INDEX_KEY) {
+		ret = 1;		/* no more entries for this dir */
+		goto out;
+	}
+
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dir_item);
+	if (verify_dir_item(root, path.nodes[0], di)) {
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	*offset = key.offset + 1;
+
+	name_len = btrfs_dir_name_len(path.nodes[0], di);
+	if (name_len > namebuf_len - 1)
+		name_len = namebuf_len - 1;
+	read_extent_buffer(path.nodes[0], namebuf,
+			   (unsigned long)(di + 1), name_len);
+	namebuf[name_len] = '\0';
+	*ftype = btrfs_dir_type(path.nodes[0], di);
+	ret = 0;
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

