Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2CE39E197
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854617; cv=none; b=lJAE/0Hx3sTF3y/RegliJye/GIbgclnsX5mEEF9SZO2a7fpKeJjFChr75qQE1ROOS9vdIxkRJmlGm0VlSvNgnAc6qvaRaW12O0qiavFcz5t+y6SGP9q00lHdwnOiLDfHx/sIducZnJ3JDGiHYUGspALgHCR4xTxXHl3dKJ/HuTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854617; c=relaxed/simple;
	bh=tElHq/CjLmCggeFmRB0S4NVFAOIJdCPKrTUAV6dzzAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb1QJ0Nu7rdD3K43zybEVthfNyoN5iePyy3W4d2Kz3X3Ftn5rNVECOB7pOAnDawwI1WGYmYY52kcMtG2Uuaj8K+vwxXTxtHy04hkkLMHxP4h5Hbv4CirvzA4KnQvFnOcAqVQmKQqf2WiCIovS+6JT0naFpDXBTpLXulQcrtxohA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Omvfymjz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Omvfymjz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Omvfymjz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Omvfymjz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F6B14D20D
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vkD/G7yIR7pPcFbztp9firmEPpcsMzXPGQR2bEb5rA=;
	b=OmvfymjzoACBla4RxNkmUSSg3/zTuMahIJN/SgdIBxIME+1FiTbGYIiPYMTlszdsojw+mK
	0bi+RxWZckSLo429vsdMtjBCmntSTqUNmG5n7uixs4vjmQD+L8AogN6XuQe/l4GBMiqqy+
	ypvubP7sm38GD7JYt1yxGmCauaEv7cs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774854603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vkD/G7yIR7pPcFbztp9firmEPpcsMzXPGQR2bEb5rA=;
	b=OmvfymjzoACBla4RxNkmUSSg3/zTuMahIJN/SgdIBxIME+1FiTbGYIiPYMTlszdsojw+mK
	0bi+RxWZckSLo429vsdMtjBCmntSTqUNmG5n7uixs4vjmQD+L8AogN6XuQe/l4GBMiqqy+
	ypvubP7sm38GD7JYt1yxGmCauaEv7cs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0C984A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qGWwKMohymk8DgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 07:10:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: mkfs/rootdir: extract compressed write path
Date: Mon, 30 Mar 2026 17:39:36 +1030
Message-ID: <aa9f61869c51782ea4ae7496d1ca3c5863e3d16e.1774854459.git.wqu@suse.com>
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
 mkfs/rootdir.c | 193 ++++++++++++++++++++++++++++---------------------
 1 file changed, 112 insertions(+), 81 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index f7712d75aa6f..cc80ef67683f 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -803,6 +803,102 @@ static int read_from_source(const struct btrfs_fs_info *fs_info,
 	return length;
 }
 
+/*
+ * Return >0 for the number of bytes read from @source and submittted as
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
+		comp_ret = lzo_compress_extent(first_sector, source->buf,
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
@@ -819,7 +915,6 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	char *write_buf;
 	bool do_comp = g_compression != BTRFS_COMPRESS_NONE;
 	bool datasum = true;
-	ssize_t comp_ret;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
 	off64_t next;
 
@@ -861,92 +956,28 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	if (next == (off64_t)-1 || !IS_ALIGNED(next, sectorsize) || next > source->size)
 		next = source->size;
 
-	buf_size = do_comp ? BTRFS_MAX_COMPRESSED : MAX_EXTENT_SIZE;
+	if (do_comp && next - file_pos > sectorsize) {
+		ret = try_compressed_write(trans, root, btrfs_inode, objectid,
+					   source, file_pos, next - file_pos);
+		if (ret > 0)
+			return ret;
+		if (ret < 0 && ret != -E2BIG)
+			return ret;
+		flags |= BTRFS_INODE_NOCOMPRESS;
+		btrfs_set_stack_inode_flags(btrfs_inode, flags);
+		/* Fallback to other methods. */
+	}
+
+	buf_size = MAX_EXTENT_SIZE;
 	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
 	ret = read_from_source(root->fs_info, source->path_name, source->fd,
 			       source->buf, file_pos, to_read);
 	if (ret < 0)
 		return ret;
-	if (to_read <= sectorsize)
-		do_comp = false;
 
-	if (do_comp) {
-		bool first_sector = !(flags & BTRFS_INODE_COMPRESS);
-
-		switch (g_compression) {
-		case BTRFS_COMPRESS_ZLIB:
-			comp_ret = zlib_compress_extent(first_sector, sectorsize,
-							source->buf, to_read,
-							source->comp_buf);
-			break;
-#if COMPRESSION_LZO
-		case BTRFS_COMPRESS_LZO:
-			comp_ret = lzo_compress_extent(sectorsize, source->buf,
-						       to_read, source->comp_buf,
-						       source->wrkmem);
-			break;
-#endif
-#if COMPRESSION_ZSTD
-		case BTRFS_COMPRESS_ZSTD:
-			comp_ret = zstd_compress_extent(first_sector, sectorsize,
-							source->buf, to_read,
-							source->comp_buf);
-			break;
-#endif
-		default:
-			comp_ret = -EINVAL;
-			break;
-		}
-
-		/*
-		 * If the function returned -E2BIG, the extent is incompressible.
-		 * If this is the first sector, add the nocompress flag,
-		 * increase the buffer size, and read the rest of the extent.
-		 */
-		if (comp_ret == -E2BIG)
-			do_comp = false;
-		else if (comp_ret < 0)
-			return comp_ret;
-
-		if (comp_ret == -E2BIG && first_sector) {
-			flags |= BTRFS_INODE_NOCOMPRESS;
-			btrfs_set_stack_inode_flags(btrfs_inode, flags);
-
-			buf_size = MAX_EXTENT_SIZE;
-			to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
-			ret = read_from_source(root->fs_info, source->path_name, source->fd,
-					       source->buf, file_pos, to_read);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	if (do_comp) {
-		u64 features;
-
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

