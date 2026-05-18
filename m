Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF023016E0
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779099687; cv=none; b=WBT+jGPPTgtUTazxxgOvBzXb9TwBr59OmIsyi2CXcnPgULt44mpnezLYi796GtS3rrbORSkKEXGIOQ7iDDFGcWhPf3fywL2rlFaydCrcbMOjQeKI8DUZgtkFHFxnB+D4JxQ7J+wY32KDkXs+ncgCFeLk32l0WYh13Zxos2sH7xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779099687; c=relaxed/simple;
	bh=zZNY1schvqRBgMKSDXReJeP6tHpbVHhtqgd9b0GzlaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLpxyf23WrHqklyPrUfDEw3JleFPGdyIYmyWtOF/9+IZ2RmZXcCK+WYUtaw5uSWGAlzElabXMteC5bBhpT+7tWsBeGQ7ZkH/5BbJug4ldOEL93dPh3hrU1tMfgmWYbu+Fz9t49nvpuwuqv4vufrwihHNgUwakd6njL9G+mAdBQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eIi5ULeL; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eIi5ULeL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eIi5ULeL";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eIi5ULeL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3AB866715F
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aP1HKikSKQgR+gcK2P3ZYDdq6Knuru68fYPrJJ6UCQw=;
	b=eIi5ULeLIrpOlUrD/5VH7/TfOOp6TwfnS8d+ha+WCP8TjtrCSDsBpC1u07e/lfFmpI8kvw
	k+29h9ppspPRAV+v5OswyRQiCmDVtFagUGv14ezPe5VS9xVHvWhaCUtAh/LQtxpw+T+BR/
	X1YGKYf5wpEVxbLNROEGT8dX0jdfz9U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eIi5ULeL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779099679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aP1HKikSKQgR+gcK2P3ZYDdq6Knuru68fYPrJJ6UCQw=;
	b=eIi5ULeLIrpOlUrD/5VH7/TfOOp6TwfnS8d+ha+WCP8TjtrCSDsBpC1u07e/lfFmpI8kvw
	k+29h9ppspPRAV+v5OswyRQiCmDVtFagUGv14ezPe5VS9xVHvWhaCUtAh/LQtxpw+T+BR/
	X1YGKYf5wpEVxbLNROEGT8dX0jdfz9U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 78651593A8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EL71Dh7oCmorFwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:21:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: rename logical bytenr parameter for add_file_item_extent()
Date: Mon, 18 May 2026 19:50:57 +0930
Message-ID: <aeebe93d8dbae84d49d2ba73cc37a03bed775c68.1779099356.git.wqu@suse.com>
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
X-Spam-Level: 
X-Rspamd-Action: no action
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 3AB866715F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

Inside the function add_file_item_extent(), we use a local variable
@first_block, to record the logical bytenr of the data extent.

However that naming is not common among btrfs, that @first_block looks
more like a block number, other than the logical bytenr in byte.

Change the following variables/parameters to make it more aligned to
btrfs naming:

- @offset parameter of write_data_to_disk()
- @addr parameter of do_reflink_write()
- @logical variable inside add_file_item_extent()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent_io.c | 10 +++++-----
 mkfs/rootdir.c            | 26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel-shared/extent_io.c b/kernel-shared/extent_io.c
index cb48699c2e46..5dcfbd020e75 100644
--- a/kernel-shared/extent_io.c
+++ b/kernel-shared/extent_io.c
@@ -479,7 +479,7 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 logical,
  * Such data will be written to all mirrors and RAID56 P/Q will also be
  * properly handled.
  */
-int write_data_to_disk(struct btrfs_fs_info *info, const void *buf, u64 offset,
+int write_data_to_disk(struct btrfs_fs_info *info, const void *buf, u64 logical,
 		       u64 bytes)
 {
 	struct btrfs_multi_bio *multi = NULL;
@@ -496,11 +496,11 @@ int write_data_to_disk(struct btrfs_fs_info *info, const void *buf, u64 offset,
 		this_len = bytes_left;
 		dev_nr = 0;
 
-		ret = btrfs_map_block(info, WRITE, offset, &this_len, &multi,
+		ret = btrfs_map_block(info, WRITE, logical, &this_len, &multi,
 				      0, &raid_map);
 		if (ret) {
 			fprintf(stderr, "Couldn't map the block %llu\n",
-				offset);
+				logical);
 			return -EIO;
 		}
 
@@ -519,7 +519,7 @@ int write_data_to_disk(struct btrfs_fs_info *info, const void *buf, u64 offset,
 			}
 
 			memset(eb, 0, sizeof(struct extent_buffer) + this_len);
-			eb->start = offset;
+			eb->start = logical;
 			eb->len = this_len;
 
 			memcpy(eb->data, buf + total_write, this_len);
@@ -562,7 +562,7 @@ int write_data_to_disk(struct btrfs_fs_info *info, const void *buf, u64 offset,
 		BUG_ON(bytes_left < this_len);
 
 		bytes_left -= this_len;
-		offset += this_len;
+		logical += this_len;
 		total_write += this_len;
 
 		kfree(multi);
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 3e77195356dd..34163e19e2aa 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -709,7 +709,7 @@ struct source_descriptor {
 };
 
 static int do_reflink_write(struct btrfs_fs_info *info,
-			    const struct source_descriptor *source, u64 addr,
+			    const struct source_descriptor *source, u64 logical,
 			    u64 file_pos, u64 bytes, const void *buf)
 {
 	struct btrfs_multi_bio *multi = NULL;
@@ -729,9 +729,9 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 		this_len = bytes_left;
 		dev_nr = 0;
 
-		ret = btrfs_map_block(info, WRITE, addr, &this_len, &multi, 0, NULL);
+		ret = btrfs_map_block(info, WRITE, logical, &this_len, &multi, 0, NULL);
 		if (ret) {
-			error("cannot map the block %llu", addr);
+			error("cannot map the block %llu", logical);
 			return -EIO;
 		}
 
@@ -763,7 +763,7 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 		BUG_ON(bytes_left < this_len);
 
 		bytes_left -= this_len;
-		addr += this_len;
+		logical += this_len;
 		total_write += this_len;
 
 		kfree(multi);
@@ -778,7 +778,7 @@ static int do_reflink_write(struct btrfs_fs_info *info,
 	if (bytes % info->sectorsize) {
 		return write_data_to_disk(info,
 			(char *)buf + round_down(bytes, info->sectorsize),
-			addr, info->sectorsize);
+			logical, info->sectorsize);
 	}
 
 	return 0;
@@ -911,7 +911,7 @@ static int add_file_item_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u32 sectorsize = root->fs_info->sectorsize;
-	u64 first_block, to_read, to_write;
+	u64 logical, to_read, to_write;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item stack_fi = { 0 };
 	u64 buf_size;
@@ -1124,13 +1124,13 @@ do_write:
 		return ret;
 	}
 
-	first_block = key.objectid;
+	logical = key.objectid;
 
 	if (g_do_reflink) {
-		ret = do_reflink_write(root->fs_info, source, first_block, file_pos,
+		ret = do_reflink_write(root->fs_info, source, logical, file_pos,
 				       to_read, write_buf);
 	} else {
-		ret = write_data_to_disk(root->fs_info, write_buf, first_block, to_write);
+		ret = write_data_to_disk(root->fs_info, write_buf, logical, to_write);
 	}
 
 	if (ret) {
@@ -1154,7 +1154,7 @@ do_write:
 
 			for (unsigned int i = 0; i < last_full; i++) {
 				ret = btrfs_insert_file_block_csum(trans,
-						first_block + (i * sectorsize),
+						logical + (i * sectorsize),
 						BTRFS_EXTENT_CSUM_OBJECTID,
 						root->fs_info->csum_type,
 						fetched_csums + (i * fetched_csum_size));
@@ -1168,7 +1168,7 @@ do_write:
 				u64 partial_off = round_down(to_read, sectorsize);
 
 				ret = btrfs_csum_file_block(trans,
-						first_block + partial_off,
+						logical + partial_off,
 						BTRFS_EXTENT_CSUM_OBJECTID,
 						root->fs_info->csum_type,
 						source->buf + partial_off);
@@ -1180,7 +1180,7 @@ do_write:
 		} else {
 			for (unsigned int i = 0; i < to_write / sectorsize; i++) {
 				ret = btrfs_csum_file_block(trans,
-						first_block + (i * sectorsize),
+						logical + (i * sectorsize),
 						BTRFS_EXTENT_CSUM_OBJECTID,
 						root->fs_info->csum_type,
 						write_buf + (i * sectorsize));
@@ -1193,7 +1193,7 @@ do_write:
 	free(fetched_csums_buf);
 
 	btrfs_set_stack_file_extent_type(&stack_fi, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_stack_file_extent_disk_bytenr(&stack_fi, first_block);
+	btrfs_set_stack_file_extent_disk_bytenr(&stack_fi, logical);
 	btrfs_set_stack_file_extent_disk_num_bytes(&stack_fi, to_write);
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, round_up(to_read, sectorsize));
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, round_up(to_read, sectorsize));
-- 
2.54.0

