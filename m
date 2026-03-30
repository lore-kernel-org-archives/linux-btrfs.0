Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F84B26AC3
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854623; cv=none; b=JiGbak3uOs5JvhsLcSl6DSZuK84XGf87mnSxWPpKAt0kot7hOjT3tlY+xbsTruUOmF1LkZjoTcpI4cYENxXP7b/YwLcg86aCJ185ynOr6A7XM7LrGUCnTkhSxlj782hm/U+3DMCbJ3i/jLcWDdZHTxbfrbHUerX2sWhe1ArBxz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854623; c=relaxed/simple;
	bh=TQQ6jd4Pk7W/tK/htCDHhRZzkzwyCIs7PEn6HfUhKrY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx8S/YCdbjQTxNifE6AGCR9DsVTQJF8+b8pp0NY9IF568+r5EAi7tztHRiHXZkH1Q3I44ZO/QkzKzFdp/7oQjBk/MmS3aS0Y4PdDi/8A0uUNgYJbhoZxR6zVxpASuZeEzsHiJRxXJnHap0QVnm6lbx7vLm9lhdBnPrJ/b3hbZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oZ9hWN3Z; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oZ9hWN3Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oZ9hWN3Z";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oZ9hWN3Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CE69A4D1F1
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuedCO7KjQVHbKIS/g97zuuVLo7UyUesp9pErFhYSzk=;
	b=oZ9hWN3Z1h/iHaJRdxjOuzQVPhck4eij9paTaoGNAAfjWkTZdXzh2p13bjlQs/bN2Umh0E
	MSJul9b8KO6uUqMsQCbn29TvMUaRV3ad6eaoPV1NPSqmzTzn8npFhZJVCV9bKF+eZK5B6g
	TlPU5CUCXnNQ/u2p7FX55r3h7WhaPY8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=oZ9hWN3Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuedCO7KjQVHbKIS/g97zuuVLo7UyUesp9pErFhYSzk=;
	b=oZ9hWN3Z1h/iHaJRdxjOuzQVPhck4eij9paTaoGNAAfjWkTZdXzh2p13bjlQs/bN2Umh0E
	MSJul9b8KO6uUqMsQCbn29TvMUaRV3ad6eaoPV1NPSqmzTzn8npFhZJVCV9bKF+eZK5B6g
	TlPU5CUCXnNQ/u2p7FX55r3h7WhaPY8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BB664A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aLQsNMshymk8DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: mkfs/rootdir: use fiemap to do prealloc detection
Date: Mon, 30 Mar 2026 17:39:37 +1030
Message-ID: <166421f9f673165c8ad1c7e385bc86eb0b1603b7.1774854459.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774854459.git.wqu@suse.com>
References: <cover.1774854459.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CE69A4D1F1

Introduce a new fiemap ioctl based hole/prealloc detection, which has
the following features:

- Preallocated extent detection
- Hole detection

This allows the resulted image to reflect the source rootdir better,
with proper preallocated extents.

However not all major fses support fiemap, e.g. tmpfs doesn't support
fiemap.

So we still need the existing SEEK_DATA/SEEK_HOLE based solution as a
fallback.

Furthermore, SEEK_DATA/SEEK_HOLE will treat preallocated space as a
hole, thus we have to attempt fiemap before SEEK_DATA/SEEK_HOLE.

Finally there is function defined but not implemented,
btrfs_insert_hole_extent(), remove it and implement a local version
insert_hole_extent() inside rootdir.c to simplify the hole insertion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/file-item.h |   3 -
 mkfs/rootdir.c            | 138 +++++++++++++++++++++++++++++++++++---
 2 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/kernel-shared/file-item.h b/kernel-shared/file-item.h
index 4f24fcb18026..7b721c10c82e 100644
--- a/kernel-shared/file-item.h
+++ b/kernel-shared/file-item.h
@@ -54,9 +54,6 @@ static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, u64 bytenr, u64 len);
 int btrfs_lookup_bio_sums(struct btrfs_bio *bbio);
-int btrfs_insert_hole_extent(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 objectid, u64 pos,
-			     u64 num_bytes);
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid,
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index cc80ef67683f..4c3b4e423385 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -36,6 +36,7 @@
 #if COMPRESSION_LZO
 #include <lzo/lzo1x.h>
 #endif
+#include <linux/fiemap.h>
 #include "kernel-lib/sizes.h"
 #include "kernel-shared/accessors.h"
 #include "kernel-shared/uapi/btrfs_tree.h"
@@ -697,11 +698,13 @@ out:
 
 struct source_descriptor {
 	int fd;
+	u32 blocksize;
 	char *buf;
 	u64 size;
 	const char *path_name;
 	char *comp_buf;
 	char *wrkmem;
+	bool no_fiemap;
 };
 
 static int do_reflink_write(struct btrfs_fs_info *info,
@@ -899,11 +902,123 @@ static int try_compressed_write(struct btrfs_trans_handle *trans,
 	return length;
 }
 
+/*
+ * Return 0 if the hole extent is inserted (or nothing to be done for no-holes feature).
+ * Return <0 for errors.
+ */
+static int insert_hole_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+			      u64 ino, u64 filepos, u64 length)
+{
+	struct btrfs_file_extent_item stack_fi = { 0 };
+	const u32 blocksize = root->fs_info->sectorsize;
+
+	UASSERT(IS_ALIGNED(filepos, blocksize));
+	UASSERT(IS_ALIGNED(length, blocksize));
+	UASSERT(length < INT_MAX);
+
+	btrfs_set_stack_file_extent_num_bytes(&stack_fi, 0);
+	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, 0);
+	return btrfs_insert_file_extent(trans, root, ino, filepos, &stack_fi);
+}
+
+/*
+ * Return 0 if we are unable to use fiemap result to handle any range.
+ * Return >0 for the length of preallocated/hole space we have inserted.
+ * Return <0 for critical errors.
+ */
+static int try_fiemap(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root,
+		      struct btrfs_inode_item *btrfs_inode,
+		      u64 objectid,
+		      struct source_descriptor *source,
+		      u64 filepos)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_file_extent_item stack_fi = { 0 };
+	struct btrfs_key key;
+	const u32 blocksize = fs_info->sectorsize;
+	struct fiemap *fiemap;
+	struct fiemap_extent *extent;
+	u64 length = round_up(source->size, blocksize) - filepos;
+	int ret;
+
+	UASSERT(IS_ALIGNED(filepos, blocksize));
+	length = min_t(u64, length, MAX_EXTENT_SIZE);
+
+	if (blocksize != source->blocksize || source->no_fiemap)
+		return 0;
+	fiemap = malloc(sizeof(struct fiemap) + sizeof(struct fiemap_extent));
+	if (!fiemap)
+		return -ENOMEM;
+
+	fiemap->fm_flags = FIEMAP_FLAG_SYNC;
+	fiemap->fm_extent_count = 1;
+	fiemap->fm_mapped_extents = 0;
+	fiemap->fm_start = filepos;
+	fiemap->fm_length = length;
+
+	ret = ioctl(source->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
+	if (ret < 0) {
+		source->no_fiemap = true;
+		free(fiemap);
+		return 0;
+	}
+	/* This is no more non-hole extent beyond @filepos. */
+	if (fiemap->fm_mapped_extents < 1) {
+		free(fiemap);
+		ret = insert_hole_extent(trans, root, objectid, filepos, length);
+		if (ret < 0)
+			return ret;
+		return length;
+	}
+	/*
+	 * We really only care about the first returned extent which covers
+	 * our block.
+	 */
+	extent = &fiemap->fm_extents[0];
+
+	/*
+	 * Returned range is beyond our @filepos. This means a hole
+	 * between @filepos and @fe_logical.
+	 */
+	if (extent->fe_logical > filepos) {
+		length = extent->fe_logical - filepos;
+		free(fiemap);
+		ret = insert_hole_extent(trans, root, objectid, filepos, length);
+		if (ret < 0)
+			return ret;
+		return length;
+	}
+
+	if (!(extent->fe_flags & FIEMAP_EXTENT_UNWRITTEN)) {
+		free(fiemap);
+		return 0;
+	}
+
+	length = extent->fe_logical + extent->fe_length - filepos;
+	free(fiemap);
+	ret = btrfs_reserve_extent(trans, root, length, 0, 0, (u64)-1, &key, 1);
+	if (ret)
+		return ret;
+
+	btrfs_set_stack_inode_flags(btrfs_inode,
+			btrfs_stack_inode_flags(btrfs_inode) | BTRFS_INODE_PREALLOC);
+	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_PREALLOC);
+	btrfs_set_stack_file_extent_disk_bytenr(&stack_fi, key.objectid);
+	btrfs_set_stack_file_extent_disk_num_bytes(&stack_fi, length);
+	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, length);
+	btrfs_set_stack_file_extent_num_bytes(&stack_fi, length);
+	ret = insert_reserved_file_extent(trans, root, objectid, btrfs_inode, filepos, &stack_fi);
+	if (ret < 0)
+		return ret;
+	return length;
+}
+
 static int add_file_item_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_inode_item *btrfs_inode,
 				u64 objectid,
-				const struct source_descriptor *source,
+				struct source_descriptor *source,
 				u64 file_pos)
 {
 	int ret;
@@ -916,7 +1031,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	bool do_comp = g_compression != BTRFS_COMPRESS_NONE;
 	bool datasum = true;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
-	off64_t next;
+	u64 next = file_pos;
 
 	if (g_do_reflink || flags & BTRFS_INODE_NOCOMPRESS)
 		do_comp = false;
@@ -926,6 +1041,14 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		do_comp = false;
 	}
 
+	/*
+	 * Try prealloc before hole detection, as preallocated space is also treated
+	 * as hole by SEEK_DATA.
+	 */
+	ret = try_fiemap(trans, root, btrfs_inode, objectid, source, file_pos);
+	if (ret)
+		return ret;
+
 	next = lseek64(source->fd, file_pos, SEEK_DATA);
 	/* The current offset is inside a hole to the next of the file. */
 	if (next == (off64_t)-1 && errno == ENXIO)
@@ -937,14 +1060,9 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		 */
 		const u64 length = min_t(u64, next - file_pos, SZ_1G);
 
-		btrfs_set_stack_file_extent_num_bytes(&stack_fi, length);
-		btrfs_set_stack_file_extent_ram_bytes(&stack_fi, length);
-		ret = btrfs_insert_file_extent(trans, root, objectid, file_pos, &stack_fi);
-		if (ret < 0) {
-			error("cannot insert hole for range [%llu, %llu)",
-			      file_pos, file_pos + length);
+		ret = insert_hole_extent(trans, root, objectid, file_pos, length);
+		if (ret < 0)
 			return ret;
-		}
 		return length;
 	}
 
@@ -1469,9 +1587,11 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	source.fd = fd;
 	source.buf = buf;
 	source.size = st->st_size;
+	source.blocksize = st->st_blksize;
 	source.path_name = path_name;
 	source.comp_buf = comp_buf;
 	source.wrkmem = wrkmem;
+	source.no_fiemap = false;
 
 	while (file_pos < st->st_size) {
 		ret = add_file_item_extent(trans, root, btrfs_inode, objectid,
-- 
2.53.0

