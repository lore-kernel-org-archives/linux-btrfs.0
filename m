Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE633242D4
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779099694; cv=none; b=oI1I6jukuPayOJUvEedBEf4jLnxFLv9PjoK9YslD46J1BhQCteMi1DSm6nI+tVrWcYVIlyvxXS1KB/Xxvfld3Ajo5xmDTpmQsIqijjIlJmtafQOWlXqguSsB/c8q4FV8RNGIDsKCZdC2sR7XkEVaKmSzHg7+6Mclk0TtiNH+rHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779099694; c=relaxed/simple;
	bh=o/OQy6oM8f7+LzcbTJHZogWEjnpthr7kA+wHH05Ce0s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScHCsohd/0ePW/TgovtuaQIGjTsB0XHTpdN6LXHdjdelvWnbTBEpgQJ+axLYV3b2/bdr5cle5GiIigexJeI5JLKDrnFd6s5HmcFwHi8grLhyB+qMSeU3SHjhh7BDHYRnkmfKc5ij5h/58j3ycqJ9RqgG/1c2zHxAjGq5lhJcNlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b0azVr4W; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b0azVr4W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b0azVr4W";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b0azVr4W"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 29DBD66D7B
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1GFQseHX8lQu49+FVAdqVkJ4nkTbKLo6ij6kyldZo4=;
	b=b0azVr4WyoGBIdzvpZFNWO7Gvj9hS9I/oiQn/Slimqa/gdQwZ51wHcihOxuYMWJ2WQFpmb
	6pmxNVWq38dh8BL+REtwy0s51rKiAx86rXdkgHpQfsNwqXZH3HWnGdHOWTuErabyCJafIL
	kQXa+FFnQp34z/bjhWYjtUTlEYlOlWo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B1GFQseHX8lQu49+FVAdqVkJ4nkTbKLo6ij6kyldZo4=;
	b=b0azVr4WyoGBIdzvpZFNWO7Gvj9hS9I/oiQn/Slimqa/gdQwZ51wHcihOxuYMWJ2WQFpmb
	6pmxNVWq38dh8BL+REtwy0s51rKiAx86rXdkgHpQfsNwqXZH3HWnGdHOWTuErabyCJafIL
	kQXa+FFnQp34z/bjhWYjtUTlEYlOlWo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD1AD593A8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wIziGx/oCmorFwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: mkfs/rootdir: refactor the last block handling
Date: Mon, 18 May 2026 19:50:58 +0930
Message-ID: <eb8e5973222ac9b8b20d37398c077e1a85c81640.1779099356.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779099356.git.wqu@suse.com>
References: <cover.1779099356.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Currently the function add_file_item_extent() has several call sites
handling the last partial block in different locations, all to handle
reflink and get_csums cases.

Remove those duplication and improve readability by:

- Shrink the range if reflink/get_csums is required
  So that reflink and get_csums handling will no longer needs to bother
  unaligned partial block.

  If the range is already a partial block, disable reflink and get_csums
  for that partial block.

- Add new UASSERT()s in do_reflink_write() and do_get_csums cases

- Introduce a new @do_get_csums to indicate if we need to call get_csums
  ioctl
  This allows us to do a quick local check, and flip the status if the
  range is a partial block.

- Merge read_data: and do_writes: tags into fallback:
  And add a dedicated if () check to determine if we need to read the
  contents, with a proper comment explaining why.

  However this requires all readers of source->buf to check if the
  buffer is already ready. If not they need to read out the buffer.
  This includes the following cases:

  * Non-reflink fallback
    We have to read-out the data before writting them back.

  * Data checksum calculation
    No matter if reflink is done, if we need to generate checksum, we
    have to read out the data anyway.

  Unfortunately I do not have a good way to remove the duplication of
  the above two callsites.

- Remove @write_buf variable
  We always use source->buf.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 155 ++++++++++++++++++++-----------------------------
 1 file changed, 63 insertions(+), 92 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 34163e19e2aa..f2ab8c642f9a 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -710,11 +710,12 @@ struct source_descriptor {
 
 static int do_reflink_write(struct btrfs_fs_info *info,
 			    const struct source_descriptor *source, u64 logical,
-			    u64 file_pos, u64 bytes, const void *buf)
+			    u64 file_pos, u64 bytes)
 {
 	struct btrfs_multi_bio *multi = NULL;
 	struct btrfs_device *device;
-	u64 bytes_left;
+	const u32 blocksize = info->sectorsize;
+	u64 bytes_left = bytes;
 	u64 this_len;
 	u64 total_write = 0;
 	u64 dev_bytenr;
@@ -722,8 +723,10 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 	int ret = 0;
 	struct file_clone_range fcr;
 
+	UASSERT(IS_ALIGNED(file_pos, blocksize));
+	UASSERT(IS_ALIGNED(bytes, blocksize));
+
 	fcr.src_fd = source->fd;
-	bytes_left = round_down(bytes, info->sectorsize);
 
 	while (bytes_left > 0) {
 		this_len = bytes_left;
@@ -770,17 +773,6 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 		multi = NULL;
 	}
 
-	/*
-	 * FICLONERANGE can only handle whole sectors. If the file is not a
-	 * multiple of the sector size, we need to write the last sector
-	 * manually.
-	 */
-	if (bytes % info->sectorsize) {
-		return write_data_to_disk(info,
-			(char *)buf + round_down(bytes, info->sectorsize),
-			logical, info->sectorsize);
-	}
-
 	return 0;
 }
 
@@ -915,9 +907,11 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_file_extent_item stack_fi = { 0 };
 	u64 buf_size;
-	char *write_buf;
 	bool do_comp = g_compression != BTRFS_COMPRESS_NONE;
 	bool datasum = true;
+	bool data_ready = false;
+	bool do_reflink = g_do_reflink;
+	bool do_get_csums;
 	u64 flags = btrfs_stack_inode_flags(btrfs_inode);
 	off_t next;
 	u8 *fetched_csums = NULL;
@@ -925,7 +919,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	u64 fetched_num_csums = 0;
 	u16 fetched_csum_size = 0;
 
-	if (g_do_reflink || flags & BTRFS_INODE_NOCOMPRESS)
+	if (do_reflink || flags & BTRFS_INODE_NOCOMPRESS)
 		do_comp = false;
 
 	if ((flags & BTRFS_INODE_NODATACOW) || (flags & BTRFS_INODE_NODATASUM)) {
@@ -983,6 +977,22 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	buf_size = MAX_EXTENT_SIZE;
 	to_read = min_t(u64, file_pos + buf_size, next) - file_pos;
 
+	do_get_csums = datasum && !do_comp && g_get_csums_supported != 0;
+	/*
+	 * Reflink and get_csums all require block aligned ranges.
+	 * Shrink the range when possible. If it's the last partial block, disable
+	 * reflink and get_csums ioctl.
+	 */
+	if (do_reflink || do_get_csums) {
+		if (to_read < sectorsize) {
+			do_reflink = false;
+			do_get_csums = false;
+		} else {
+			to_read = round_down(to_read, sectorsize);
+		}
+	}
+	to_write = round_up(to_read, sectorsize);
+
 	/*
 	 * Try to get csums from the source filesystem via BTRFS_IOC_GET_CSUMS
 	 * instead of computing them from the data.  This works when the source
@@ -993,17 +1003,19 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 	 * use the pre-computed csums directly.  For non-reflink, the data is
 	 * still read normally but we skip the checksum computation.
 	 */
-	if (datasum && !do_comp && g_get_csums_supported != 0) {
-		u16 csum_size = btrfs_csum_type_size(root->fs_info->csum_type);
-		u64 ioctl_len = round_up(to_read, sectorsize);
-		u64 num_csums = ioctl_len / sectorsize;
-		u64 csums_bytes = num_csums * csum_size;
+	if (do_get_csums) {
+		const u16 csum_size = btrfs_csum_type_size(root->fs_info->csum_type);
+		const u64 num_csums = to_read / sectorsize;
+		const u64 csums_bytes = num_csums * csum_size;
 		size_t alloc_size = sizeof(struct btrfs_ioctl_get_csums_args) +
 				    sizeof(struct btrfs_ioctl_get_csums_entry) +
 				    csums_bytes;
 		struct btrfs_ioctl_get_csums_args *cargs;
 		struct btrfs_ioctl_get_csums_entry *entry;
 
+		/* The range must be block aligned. */
+		UASSERT(IS_ALIGNED(to_read, sectorsize));
+
 		/*
 		 * Check that the source file's filesystem uses the same
 		 * checksum algorithm as the destination.  Cache the result
@@ -1026,14 +1038,14 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		}
 
 		if (!g_last_csums_dev_ok)
-			goto read_data;
+			goto fallback;
 
 		cargs = calloc(1, alloc_size);
 		if (!cargs)
 			return -ENOMEM;
 
 		cargs->offset = file_pos;
-		cargs->length = ioctl_len;
+		cargs->length = to_read;
 		cargs->buf_size = sizeof(struct btrfs_ioctl_get_csums_entry) +
 				  csums_bytes;
 
@@ -1043,7 +1055,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 			if (errno == ENOTTY) {
 				/* Kernel doesn't support the ioctl. */
 				g_get_csums_supported = 0;
-				goto read_data;
+				goto fallback;
 			}
 			error("BTRFS_IOC_GET_CSUMS failed on %s: %m",
 			      source->path_name);
@@ -1060,9 +1072,9 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 
 		if (cargs->length != 0 || cargs->buf_size < sizeof(*entry) ||
 		    entry->type != BTRFS_GET_CSUMS_HAS_CSUMS ||
-		    entry->length != ioctl_len) {
+		    entry->length != to_read) {
 			free(cargs);
-			goto read_data;
+			goto fallback;
 		}
 
 		/*
@@ -1073,50 +1085,9 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 		fetched_csums_buf = cargs;
 		fetched_num_csums = num_csums;
 		fetched_csum_size = csum_size;
-
-		if (g_do_reflink) {
-			/*
-			 * Reflink fast path: skip reading data entirely.
-			 * Only read the trailing partial sector if needed for
-			 * do_reflink_write()'s zero-padding.
-			 */
-			to_write = ioctl_len;
-			write_buf = source->buf;
-
-			if (to_read % sectorsize) {
-				u64 partial_off = round_down(to_read, sectorsize);
-				ssize_t ret_read;
-
-				memset(source->buf + partial_off, 0, sectorsize);
-				ret_read = pread(source->fd,
-						 source->buf + partial_off,
-						 to_read - partial_off,
-						 file_pos + partial_off);
-				if (ret_read < 0) {
-					error("cannot read %s at offset %llu: %m",
-					      source->path_name,
-					      file_pos + partial_off);
-					free(fetched_csums_buf);
-					fetched_csums_buf = NULL;
-					return -errno;
-				}
-			}
-
-			goto do_write;
-		}
 	}
 
-read_data:
-	ret = read_from_source(root->fs_info, source->path_name, source->fd,
-			       source->buf, file_pos, to_read);
-	if (ret < 0)
-		return ret;
-
-	to_write = round_up(to_read, sectorsize);
-	write_buf = source->buf;
-	memset(write_buf + to_read, 0, to_write - to_read);
-
-do_write:
+fallback:
 	ret = btrfs_reserve_extent(trans, root, to_write, 0, 0,
 				   (u64)-1, &key, 1);
 	if (ret) {
@@ -1126,11 +1097,21 @@ do_write:
 
 	logical = key.objectid;
 
-	if (g_do_reflink) {
+	if (do_reflink) {
 		ret = do_reflink_write(root->fs_info, source, logical, file_pos,
-				       to_read, write_buf);
+				       to_read);
 	} else {
-		ret = write_data_to_disk(root->fs_info, write_buf, logical, to_write);
+		if (!data_ready) {
+			ret = read_from_source(root->fs_info, source->path_name,
+					       source->fd, source->buf, file_pos, to_read);
+			if (ret < 0) {
+				free(fetched_csums_buf);
+				return ret;
+			}
+			memset(source->buf + to_read, 0, to_write - to_read);
+			data_ready = true;
+		}
+		ret = write_data_to_disk(root->fs_info, source->buf, logical, to_write);
 	}
 
 	if (ret) {
@@ -1143,15 +1124,6 @@ do_write:
 		if (fetched_csums) {
 			unsigned int last_full = fetched_num_csums;
 
-			/*
-			 * For the trailing partial sector, compute the csum
-			 * from the data we actually wrote (zero-padded) rather
-			 * than from the ioctl.  The source extent may have
-			 * different data after the file end.
-			 */
-			if (to_read % sectorsize)
-				last_full = fetched_num_csums - 1;
-
 			for (unsigned int i = 0; i < last_full; i++) {
 				ret = btrfs_insert_file_block_csum(trans,
 						logical + (i * sectorsize),
@@ -1163,27 +1135,26 @@ do_write:
 					return ret;
 				}
 			}
-
-			if (last_full < fetched_num_csums) {
-				u64 partial_off = round_down(to_read, sectorsize);
-
-				ret = btrfs_csum_file_block(trans,
-						logical + partial_off,
-						BTRFS_EXTENT_CSUM_OBJECTID,
-						root->fs_info->csum_type,
-						source->buf + partial_off);
-				if (ret) {
+		} else {
+			/* Reflink without prefetched-csums. */
+			if (!data_ready) {
+				ret = read_from_source(root->fs_info,
+						       source->path_name,
+						       source->fd, source->buf,
+						       file_pos, to_read);
+				if (ret < 0) {
 					free(fetched_csums_buf);
 					return ret;
 				}
+				memset(source->buf + to_read, 0, to_write - to_read);
+				data_ready = true;
 			}
-		} else {
 			for (unsigned int i = 0; i < to_write / sectorsize; i++) {
 				ret = btrfs_csum_file_block(trans,
 						logical + (i * sectorsize),
 						BTRFS_EXTENT_CSUM_OBJECTID,
 						root->fs_info->csum_type,
-						write_buf + (i * sectorsize));
+						source->buf + (i * sectorsize));
 				if (ret)
 					return ret;
 			}
-- 
2.54.0

