Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312BA2F8EBE
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782274389; cv=none; b=LYHhOjUXrBk0bObm6oV23g0pLmO4xBVH8BIb4u/kYaqeuQas03wMbB1VejbjeMyWJKUi0Gs4BHbxRc3mzgwclbmA5OwKo6ONAh149fdOg5IbgCWslmnGFM1AsQOBE/aGWw9H3BNEMGeBc5nwPbdsTCgOJ9oOltC8J3Xn8320CD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782274389; c=relaxed/simple;
	bh=eLNpws6ktOYhkYMKILitKV+x7cgsAme4cOD1/Dxy/8o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XWBdJkGtt//z5MARWVLurH0SFPPNGrBS8Ulg62JJr58ydnoImFvW+iOVcqX5WjHAplQvvZW2kuZDjJccN1X+F74G7VnIgx47GJRc4Ns3tv2Xlpn6ixoeFnTTYG7xFmS2/GM/i2gCBblCvUzRDs59v6zuaAV18Uyw5te8HvWEujI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rbjz0JIV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Rbjz0JIV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rbjz0JIV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Rbjz0JIV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DB127101D
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782274386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ePIIppDSTvtiF7O2m03B2uY9e7LrbTnfAF+KMPyqKrM=;
	b=Rbjz0JIVuW2mGLjd0zT1yB3X0LvhPbkb4f4JEsNb8UkE1s1JCD9dUTAivKOpAsMfZ3qzbv
	A5UPrpyW/v5rez6jBlcpSO3zkH47XHxy/w/KSq2H7x0+bAq4MJfiOVPVZRzA8QFGIQq4iY
	uQl1uY5WMEcA0+cECU9EhJQ/lO7C49U=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782274386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ePIIppDSTvtiF7O2m03B2uY9e7LrbTnfAF+KMPyqKrM=;
	b=Rbjz0JIVuW2mGLjd0zT1yB3X0LvhPbkb4f4JEsNb8UkE1s1JCD9dUTAivKOpAsMfZ3qzbv
	A5UPrpyW/v5rez6jBlcpSO3zkH47XHxy/w/KSq2H7x0+bAq4MJfiOVPVZRzA8QFGIQq4iY
	uQl1uY5WMEcA0+cECU9EhJQ/lO7C49U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51677779A8
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:13:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kza+AFFZO2o1NQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:13:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use correct type for sectorsize/nodesize/blocksize
Date: Wed, 24 Jun 2026 13:42:42 +0930
Message-ID: <f12af6d49a5b04bd7ff537bcdabee176b54416f6.1782274357.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Btrfs' nodesize and sectorsize are all u32 values, there is no need to
use u64 for local usage.

Furthermore some call sites also use "blocksize" or "bs" for sectorsize,
also change them to use the minimal type u32 instead.

Since we're here, also reorder those local variables so that they won't
cause extra holes for stack memory, and consitify the
sectorsize/nodesize/blocksize/bs usage.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 12 ++++++------
 fs/btrfs/fiemap.c  |  4 ++--
 fs/btrfs/file.c    |  4 ++--
 fs/btrfs/inode.c   |  4 ++--
 fs/btrfs/reflink.c |  8 ++++----
 fs/btrfs/send.c    |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0a7d80da9c94..fa5922a21e51 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2390,8 +2390,8 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 			 const struct btrfs_super_block *sb, int mirror_num)
 {
-	u64 nodesize = btrfs_super_nodesize(sb);
-	u64 sectorsize = btrfs_super_sectorsize(sb);
+	const u32 nodesize = btrfs_super_nodesize(sb);
+	const u32 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
 	const bool ignore_flags = btrfs_test_opt(fs_info, IGNORESUPERFLAGS);
 
@@ -2433,24 +2433,24 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 	 */
 	if (unlikely(!is_power_of_2(sectorsize) || sectorsize < BTRFS_MIN_BLOCKSIZE ||
 		     sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
-		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
+		btrfs_err(fs_info, "invalid sectorsize %u", sectorsize);
 		ret = -EINVAL;
 	}
 
 	if (unlikely(!btrfs_supported_blocksize(sectorsize))) {
 		btrfs_err(fs_info,
-			"sectorsize %llu not yet supported for page size %lu",
+			"sectorsize %u not yet supported for page size %lu",
 			sectorsize, PAGE_SIZE);
 		ret = -EINVAL;
 	}
 
 	if (unlikely(!is_power_of_2(nodesize) || nodesize < sectorsize ||
 		     nodesize > BTRFS_MAX_METADATA_BLOCKSIZE)) {
-		btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
+		btrfs_err(fs_info, "invalid nodesize %u", nodesize);
 		ret = -EINVAL;
 	}
 	if (unlikely(nodesize != le32_to_cpu(sb->__unused_leafsize))) {
-		btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
+		btrfs_err(fs_info, "invalid leafsize %u, should be %u",
 			  le32_to_cpu(sb->__unused_leafsize), nodesize);
 		ret = -EINVAL;
 	}
diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 6263e837093e..1da1ccea5b03 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -641,9 +641,9 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	u64 prev_extent_end;
 	u64 range_start;
 	u64 range_end;
-	const u64 sectorsize = inode->root->fs_info->sectorsize;
-	bool stopped = false;
+	const u32 sectorsize = inode->root->fs_info->sectorsize;
 	int ret;
+	bool stopped = false;
 
 	cache.entries_size = PAGE_SIZE / sizeof(struct btrfs_fiemap_entry);
 	cache.entries = kmalloc_objs(struct btrfs_fiemap_entry,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a2a2df2df786..df8f6f565070 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2888,8 +2888,8 @@ enum {
 static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
 						 u64 offset)
 {
-	const u64 sectorsize = inode->root->fs_info->sectorsize;
 	struct extent_map *em;
+	const u32 sectorsize = inode->root->fs_info->sectorsize;
 	int ret;
 
 	offset = round_down(offset, sectorsize);
@@ -2916,9 +2916,9 @@ static int btrfs_zero_range(struct inode *inode,
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_map *em;
 	struct extent_changeset *data_reserved = NULL;
+	const u32 sectorsize = fs_info->sectorsize;
 	int ret;
 	u64 alloc_hint = 0;
-	const u64 sectorsize = fs_info->sectorsize;
 	const u64 orig_start = offset;
 	const u64 orig_end = offset + len - 1;
 	u64 alloc_start = round_down(offset, sectorsize);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ebd1387fcc76..ea772ec788f9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -860,11 +860,11 @@ static void compress_file_range(struct btrfs_work *work)
 	struct btrfs_inode *inode = async_chunk->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct compressed_bio *cb = NULL;
-	u64 blocksize = fs_info->sectorsize;
 	u64 start = async_chunk->start;
 	u64 end = async_chunk->end;
 	u64 actual_end;
 	u64 i_size;
+	const u32 blocksize = fs_info->sectorsize;
 	u32 cur_len;
 	int ret = 0;
 	unsigned long total_compressed = 0;
@@ -2865,7 +2865,6 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 qgroup_reserved)
 {
 	struct btrfs_root *root = inode->root;
-	const u64 sectorsize = root->fs_info->sectorsize;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key ins;
@@ -2875,6 +2874,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
+	const u32 sectorsize = root->fs_info->sectorsize;
 	int ret;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 9a49d2ecb949..5205b508127c 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -691,7 +691,7 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
 	const u64 end = dst_loff + len - 1;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_fs_info *fs_info = src->root->fs_info;
-	const u64 bs = fs_info->sectorsize;
+	const u32 bs = fs_info->sectorsize;
 	int ret;
 
 	/*
@@ -760,10 +760,10 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	struct inode *inode = file_inode(file);
 	struct inode *src = file_inode(file_src);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	int ret;
 	u64 len = olen;
-	u64 bs = fs_info->sectorsize;
 	u64 end;
+	const u32 bs = fs_info->sectorsize;
+	int ret;
 
 	/*
 	 * VFS's generic_remap_file_range_prep() protects us from cloning the
@@ -841,8 +841,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 {
 	struct btrfs_inode *inode_in = BTRFS_I(file_inode(file_in));
 	struct btrfs_inode *inode_out = BTRFS_I(file_inode(file_out));
-	u64 bs = inode_out->root->fs_info->sectorsize;
 	u64 wb_len;
+	const u32 bs = inode_out->root->fs_info->sectorsize;
 	int ret;
 
 	if (!(remap_flags & REMAP_FILE_DEDUP)) {
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d664e470fd77..48a6667053d8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6038,9 +6038,9 @@ static int send_write_or_clone(struct send_ctx *sctx,
 			       struct clone_root *clone_root)
 {
 	int ret = 0;
+	const u32 bs = sctx->send_root->fs_info->sectorsize;
 	u64 offset = key->offset;
 	u64 end;
-	u64 bs = sctx->send_root->fs_info->sectorsize;
 	struct btrfs_file_extent_item *ei;
 	u64 disk_byte;
 	u64 data_offset;
-- 
2.54.0

