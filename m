Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505738F937
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724772; cv=none; b=fuJp+VSWUG9NmX0OXsWUQqihg/XBvPPpCxl/K5EzC6anvFktntrdflNjzdNMcnZWM9vT1SwvYYrkXu+/x90eHofgKrAFzvY0O1u35TsvYcbFtMVoZpRiMDRlkScfSOwo9ARqRh/ogJVeRrT2A1fUnK4/bfaDwo/HY4Fc7c/C0xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724772; c=relaxed/simple;
	bh=l8Wk6OcPlT/JevZb5iAbhFrqAoDhSOw7PliIkSGYP9c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFmmt+88u7i/heaC3KdkM9aBwVN+T7zrY1Nz5gN1JR7QqvIIBmTQZwGSGYIsdCUvnpCf0RgimUmuySSrN9sZVj5Q+yA5XOaBuLIBgqeQapWYm9+UyxRlU7GOTh6wC8dJ3AH2B65FG3QHbV5EVsuPr915g53sfVt66R/l5/EM+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aLXC7bYT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aLXC7bYT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aLXC7bYT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aLXC7bYT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 101794EE59
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X26oVi7yfxBcKuAI+N4/zlNrcTB+ycTBiYM3HuF+TfY=;
	b=aLXC7bYT+Y/iSHR2u79baNrRzJOr/ZHf83qRzDFvpZ82KoqZhyW1q2CVlk4bXPYIza+iAk
	OPPiLgceycQe/vwWy/S8ta85xtD46xPhI00Sbt5CEqH5CJgc/73nnFBcYcK5a4OrGliwq7
	1AEasfCxX9C26ZJIvP6VTF2xpNoAwz8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aLXC7bYT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X26oVi7yfxBcKuAI+N4/zlNrcTB+ycTBiYM3HuF+TfY=;
	b=aLXC7bYT+Y/iSHR2u79baNrRzJOr/ZHf83qRzDFvpZ82KoqZhyW1q2CVlk4bXPYIza+iAk
	OPPiLgceycQe/vwWy/S8ta85xtD46xPhI00Sbt5CEqH5CJgc/73nnFBcYcK5a4OrGliwq7
	1AEasfCxX9C26ZJIvP6VTF2xpNoAwz8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C00E4A0B4
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6PnPKs1o12lUJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:52:29 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 4/5] btrfs-progs: mkfs/rootdir: extract compressed write path
Date: Thu,  9 Apr 2026 18:22:03 +0930
Message-ID: <22fb3493afce20a68bb8b71854fbfdf043f23c5d.1775724568.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775724568.git.wqu@suse.com>
References: <cover.1775724568.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 101794EE59

Currently add_file_item_extent() have several different
optimizations/handlings:

- Hole detection
  Which happens before any writes.
  Thus brings the minimal impact to the remaining methods.

- Compressed write
- Reflink from source fs
- Regular read/writes

The last 3 share the same extent reservation, but with quite some extra
handling.
E.g. for compressed writes if the compression failed, we need to reset
the buffer size and fallback to regular read/writes.

This makes the code much harder to read, and the shared code is minimal,
only sharing the same btrfs_reserve_extent() and
insert_reserved_file_extent() calls.

Extract compressed write into its dedicated helper so that the fallback
logic is much easier to understand.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 249 ++++++++++++++++++++++++++++---------------------
 1 file changed, 141 insertions(+), 108 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 62f7c57c5e4a..5c0bc012a354 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -779,6 +779,125 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 	return 0;
 }
 
+static s32 read_from_source(const struct btrfs_fs_info *fs_info,
+			    const char *path, int fd,
+			    char *buf, u64 filepos, u32 length)
+{
+	u32 cur = 0;
+
+	UASSERT(IS_ALIGNED(filepos, fs_info->sectorsize));
+	UASSERT(length <= MAX_EXTENT_SIZE);
+
+	while (cur < length) {
+		ssize_t ret;
+
+		ret = pread(fd, buf + cur, length - cur, filepos + cur);
+		if (ret < 0) {
+			error("cannot read %s at offset %llu length %u: %m",
+			      path, filepos + cur, length - cur);
+			return -errno;
+		}
+		cur += ret;
+	}
+	return length;
+}
+
+/*
+ * Return >0 for the number of bytes read from @source and submitted as
+ * compressed write.
+ * Return <0 for errors, including non-fatal ones, e.g. -E2BIG if compression
+ * ratio is bad.
+ */
+static int try_compressed_write(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_inode_item *btrfs_inode,
+				u64 objectid,
+				const struct source_descriptor *source,
+				u64 filepos, u32 length)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_file_extent_item stack_fi = { 0 };
+	struct btrfs_key key;
+	const u32 blocksize = fs_info->sectorsize;
+	const bool first_sector = !(btrfs_stack_inode_flags(btrfs_inode) &
+				    BTRFS_INODE_COMPRESS);
+	u64 inode_flags = btrfs_stack_inode_flags(btrfs_inode);
+	u64 sb_flags = btrfs_super_incompat_flags(fs_info->super_copy);
+	u32 to_write;
+	ssize_t comp_ret;
+	int ret;
+
+	UASSERT(length > 0);
+	length = min_t(u32, length, BTRFS_MAX_COMPRESSED);
+	if (length <= root->fs_info->sectorsize)
+		return -E2BIG;
+	ret = read_from_source(root->fs_info, source->path_name, source->fd,
+			       source->buf, filepos, length);
+	if (ret < 0)
+		return ret;
+	switch (g_compression) {
+	case BTRFS_COMPRESS_ZLIB:
+		comp_ret = zlib_compress_extent(first_sector, blocksize,
+						source->buf, length,
+						source->comp_buf);
+		break;
+#if COMPRESSION_LZO
+	case BTRFS_COMPRESS_LZO:
+		sb_flags |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+		comp_ret = lzo_compress_extent(blocksize, source->buf,
+					       length, source->comp_buf,
+					       source->wrkmem);
+		break;
+#endif
+#if COMPRESSION_ZSTD
+	case BTRFS_COMPRESS_ZSTD:
+		sb_flags |= BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD;
+		comp_ret = zstd_compress_extent(first_sector, blocksize,
+						source->buf, length,
+						source->comp_buf);
+		break;
+#endif
+	default:
+		comp_ret = -EINVAL;
+		break;
+	}
+	if (comp_ret < 0)
+		return comp_ret;
+
+	to_write = round_up(comp_ret, blocksize);
+	memset(source->comp_buf + comp_ret, 0, to_write - comp_ret);
+	inode_flags |= BTRFS_INODE_COMPRESS;
+	btrfs_set_stack_inode_flags(btrfs_inode, inode_flags);
+	btrfs_set_super_incompat_flags(fs_info->super_copy, sb_flags);
+
+	ret = btrfs_reserve_extent(trans, root, to_write, 0, 0, (u64)-1, &key, 1);
+	if (ret < 0)
+		return ret;
+	ret = write_data_to_disk(fs_info, source->comp_buf, key.objectid, to_write);
+	if (ret < 0)
+		return ret;
+	for (unsigned int i = 0; i < to_write / blocksize; i++) {
+		ret = btrfs_csum_file_block(trans, key.objectid + (i * blocksize),
+				BTRFS_EXTENT_CSUM_OBJECTID,
+				root->fs_info->csum_type,
+				source->comp_buf + (i * blocksize));
+		if (ret)
+			return ret;
+	}
+	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_stack_file_extent_disk_bytenr(&stack_fi, key.objectid);
+	btrfs_set_stack_file_extent_disk_num_bytes(&stack_fi, to_write);
+	btrfs_set_stack_file_extent_num_bytes(&stack_fi, round_up(length, blocksize));
+	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, round_up(length, blocksize));
+	btrfs_set_stack_file_extent_compression(&stack_fi, g_compression);
+
+	ret = insert_reserved_file_extent(trans, root, objectid, btrfs_inode,
+					  filepos, &stack_fi);
+	if (ret < 0)
+		return ret;
+	return length;
+}
+
 static int add_file_item_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				struct btrfs_inode_item *btrfs_inode,
@@ -788,14 +907,13 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u32 sectorsize = root->fs_info->sectorsize;
-	u64 bytes_read, first_block, to_read, to_write;
+	u64 first_block, to_read, to_write;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item stack_fi = { 0 };
 	u64 buf_size;
 	char *write_buf;
 	bool do_comp = g_compression != BTRFS_COMPRESS_NONE;
 	bool datasum = true;
-	ssize_t comp_ret;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
 	off_t next;
 
@@ -835,120 +953,35 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	if (next == (off_t)-1 || !IS_ALIGNED(next, sectorsize) || next > source->size)
 		next = source->size;
 
-	buf_size = do_comp ? BTRFS_MAX_COMPRESSED : MAX_EXTENT_SIZE;
-	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
-	bytes_read = 0;
-
-	while (bytes_read < to_read) {
-		ssize_t ret_read;
-
-		ret_read = pread(source->fd, source->buf + bytes_read,
-				 to_read - bytes_read, file_pos + bytes_read);
-		if (ret_read < 0) {
-			error("cannot read %s at offset %llu length %llu: %m",
-			      source->path_name, file_pos + bytes_read,
-			      to_read - bytes_read);
-			return -errno;
-		}
-
-		bytes_read += ret_read;
-	}
-
-	if (bytes_read <= sectorsize)
-		do_comp = false;
-
-	if (do_comp) {
-		bool first_sector = !(flags & BTRFS_INODE_COMPRESS);
-
-		switch (g_compression) {
-		case BTRFS_COMPRESS_ZLIB:
-			comp_ret = zlib_compress_extent(first_sector, sectorsize,
-							source->buf, bytes_read,
-							source->comp_buf);
-			break;
-#if COMPRESSION_LZO
-		case BTRFS_COMPRESS_LZO:
-			comp_ret = lzo_compress_extent(sectorsize, source->buf,
-						       bytes_read,
-						       source->comp_buf,
-						       source->wrkmem);
-			break;
-#endif
-#if COMPRESSION_ZSTD
-		case BTRFS_COMPRESS_ZSTD:
-			comp_ret = zstd_compress_extent(first_sector, sectorsize,
-							source->buf, bytes_read,
-							source->comp_buf);
-			break;
-#endif
-		default:
-			comp_ret = -EINVAL;
-			break;
-		}
-
+	if (do_comp && next - file_pos > sectorsize) {
+		ret = try_compressed_write(trans, root, btrfs_inode, objectid,
+					   source, file_pos, next - file_pos);
+		if (ret > 0)
+			return ret;
+		if (ret < 0 && ret != -E2BIG)
+			return ret;
 		/*
-		 * If the function returned -E2BIG, the extent is incompressible.
-		 * If this is the first sector, add the nocompress flag,
-		 * increase the buffer size, and read the rest of the extent.
+		 * If the inode doesn't have INODE_COMPRESS flag set, it means
+		 * the compression failed at the first block.
+		 * Set the NOCOMPRESS flag indicating bad compression ratio.
 		 */
-		if (comp_ret == -E2BIG)
-			do_comp = false;
-		else if (comp_ret < 0)
-			return comp_ret;
-
-		if (comp_ret == -E2BIG && first_sector) {
+		if (!(btrfs_stack_inode_flags(btrfs_inode) & BTRFS_INODE_COMPRESS)) {
 			flags |= BTRFS_INODE_NOCOMPRESS;
 			btrfs_set_stack_inode_flags(btrfs_inode, flags);
-
-			buf_size = MAX_EXTENT_SIZE;
-			to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
-
-			while (bytes_read < to_read) {
-				ssize_t ret_read;
-
-				ret_read = pread(source->fd,
-						 source->buf + bytes_read,
-						 to_read - bytes_read,
-						 file_pos + bytes_read);
-				if (ret_read < 0) {
-					error("cannot read %s at offset %llu length %llu: %m",
-					      source->path_name,
-					      file_pos + bytes_read,
-					      to_read - bytes_read);
-					return -errno;
-				}
-
-				bytes_read += ret_read;
-			}
 		}
+		/* Fallback to other methods. */
 	}
 
-	if (do_comp) {
-		u64 features;
+	buf_size = MAX_EXTENT_SIZE;
+	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
+	ret = read_from_source(root->fs_info, source->path_name, source->fd,
+			       source->buf, file_pos, to_read);
+	if (ret < 0)
+		return ret;
 
-		to_write = round_up(comp_ret, sectorsize);
-		write_buf = source->comp_buf;
-		memset(write_buf + comp_ret, 0, to_write - comp_ret);
-
-		flags |= BTRFS_INODE_COMPRESS;
-		btrfs_set_stack_inode_flags(btrfs_inode, flags);
-
-		if (g_compression == BTRFS_COMPRESS_ZSTD) {
-			features = btrfs_super_incompat_flags(trans->fs_info->super_copy);
-			features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_ZSTD;
-			btrfs_set_super_incompat_flags(trans->fs_info->super_copy,
-						       features);
-		} else if (g_compression == BTRFS_COMPRESS_LZO) {
-			features = btrfs_super_incompat_flags(trans->fs_info->super_copy);
-			features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-			btrfs_set_super_incompat_flags(trans->fs_info->super_copy,
-						       features);
-		}
-	} else {
-		to_write = round_up(to_read, sectorsize);
-		write_buf = source->buf;
-		memset(write_buf + to_read, 0, to_write - to_read);
-	}
+	to_write = round_up(to_read, sectorsize);
+	write_buf = source->buf;
+	memset(write_buf + to_read, 0, to_write - to_read);
 
 	ret = btrfs_reserve_extent(trans, root, to_write, 0, 0,
 				   (u64)-1, &key, 1);
-- 
2.53.0

