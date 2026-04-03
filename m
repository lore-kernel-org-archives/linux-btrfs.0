Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA1274B5F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775190814; cv=none; b=WvrbxVwY3q2kXRbw9YUuyTrgD7nRaaDhN+S7UZCavD3AYYAfJlcMHTnXJOX4gEipzHjLz4wE7BsNgIZCEGg2N4p+gcG/qPP+WQEN1SghXisi3FOWzLg3BASgmhd9nn3FmOhAUjks/FBhIUN90lRAL70LI+KeiMWaVD8fhKmWpYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775190814; c=relaxed/simple;
	bh=yQkPNW+8KRsE3l2nHdaEdcNcL4iaKaY/+a2l7TP5ywg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kux4SHLFaUTQVWAfEDUmVFUYtsm3ObsulEEbV/u/w8lv9uLKBtH+EZY1/koGStB+4RUgtp8FR+BtEEIUDFpEVj9koYjyR530PprZVkIzp3VGJgOifKii4VMd86iBlOwxQeQiIT3f0YQuV1kxiVtItiTN8M2zQ9MMCev7b7FzsTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a7tgxCh3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hObgTiYg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a7tgxCh3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hObgTiYg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1F5F5BD03
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDxa87im5nZGxB2A8m0A/zJ2K74vBh8MPnNNlIJeNco=;
	b=a7tgxCh3LCz8JIgcfVerP8UYivcoruDMs6dXNg9hE44FUfys9WSVXad/pNfkmZRallfKRI
	XXkeK5LpNh9+mN37QOp1W06hU4dqQ/Abvwx7yCufUB2kgj7NUKAZIPsv1qeGz4xFzrQxaY
	uIwChagDiRLVT49mgc8yAH1kCNB2i9Q=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDxa87im5nZGxB2A8m0A/zJ2K74vBh8MPnNNlIJeNco=;
	b=hObgTiYgrzWn5Od7RBiH1wYZNSHT4CcSKi4RRUOWq1xbU1AQVA97Ei+rjrqztcuzxPI6Fq
	EIbAoNnTOqVIAIXY4wFAk7mEqz/Znwt5nrHxpDHWs82tIcdycI4mKDwf5MvCPV7PCokcM3
	WwyiRkycrLLQTxaO7xlLmBE8L0KF1C4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D2FD4A0B0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UA6wABRDz2nTYQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 04:33:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/6] btrfs-progs: mkfs/rootdir: use fiemap to do prealloc detection
Date: Fri,  3 Apr 2026 15:02:59 +1030
Message-ID: <ffb5986f7e313a61b8686eb8ff2ceb0e0245b972.1775190565.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775190565.git.wqu@suse.com>
References: <cover.1775190565.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

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

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 2 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 5c0bc012a354..5fbbb2f43504 100644
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
@@ -696,11 +697,13 @@ out:
 
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
@@ -898,11 +901,106 @@ static int try_compressed_write(struct btrfs_trans_handle *trans,
 	return length;
 }
 
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
+		length = min_t(u64, length, SZ_1G);
+		ret = btrfs_insert_hole_extent(trans, root, objectid, filepos, length);
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
+		length = min_t(u64, length, SZ_1G);
+		free(fiemap);
+		ret = btrfs_insert_hole_extent(trans, root, objectid, filepos, length);
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
@@ -915,7 +1013,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	bool do_comp = g_compression != BTRFS_COMPRESS_NONE;
 	bool datasum = true;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
-	off_t next;
+	off_t next = file_pos;
 
 	if (g_do_reflink || flags & BTRFS_INODE_NOCOMPRESS)
 		do_comp = false;
@@ -925,6 +1023,14 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
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
 	next = lseek(source->fd, file_pos, SEEK_DATA);
 	/* The current offset is inside a hole to the next of the file. */
 	if (next == (off_t)-1 && errno == ENXIO)
@@ -1475,9 +1581,11 @@ static int add_file_items(struct btrfs_trans_handle *trans,
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

