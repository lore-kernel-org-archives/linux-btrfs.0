Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457AD36AB77
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781567694; cv=none; b=DcpNnHocf7Od+EI8Q++bHnFVjNvms50ZL+tp8RQ+Dbru4i8hNvTGY1nKLUYBgKKkucWu7QDvTKwJjIuu6tPQ7vcj7TfJ2u0metfsMWpi72YjbgCas20UpYBODtpz0T2NnFbnAcZxs9FS93FG4eQPfJrLTSVrC87WjjTuS7GCDEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781567694; c=relaxed/simple;
	bh=vOpQ5FSq0brRVWeF0qLOogyF+PKzFv6Vo4aFR1y2yNY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UHGg9jiUlzkd99T0vN/GRG23/AmnFnNnZyS/7jL4aj5WvxOYFQnRRv8F7e5htzbRJz2bSOCRjvn5fKHHLQJ91T+1K8QpXmxOd9DkUKcI8bs0zujojXOlfsWCIC51BNXMUVn2wbijgvcBiJYgVfDMbzvkNC/7aLqqn8Z2T+spk2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kzqrAyFm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sU+TjRsv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kzqrAyFm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sU+TjRsv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 411EF760EF
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781567691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8ars9vio/qSAr7AKI5lp3zhimE31MxX7wCT9foiVQ14=;
	b=kzqrAyFm6OLa+ZiUCepvGkcX5BvYoCTwPA/ghHoLxI7/xXd8RSVqGHxcxmz+14dLUH3QXu
	Y5n/ybrV3rHrtTxGKxMR1xlRGvqv0HIJkOpXysDQPYrWhd+QpmW3NczGsTdOsVfkkrFFGV
	wtp3QqNkWiKpN07JVVxr0m1dcCqClp4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781567690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8ars9vio/qSAr7AKI5lp3zhimE31MxX7wCT9foiVQ14=;
	b=sU+TjRsvlqBZgmprVlKddb+mnVjSEa8MnUkLFHW7qCZtgwBzB3R4zDxlNVBSm4dkDyQmgc
	Ke3TeOuCydsFs2dADtKdXrOCzX0Yy7vtOC8BDytb+qSEMyun86+b1eM+mPxkD6yzjnTn3+
	lAz4kgx4qCZwVlWt2+MLVWlSx7iwnas=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D426779A7
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:54:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v+eWNsiQMGpSDwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:54:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: log swapfile activation/deactivation and warn about pinned block groups
Date: Tue, 16 Jun 2026 09:24:22 +0930
Message-ID: <19331955f516f43fd8da4bae49c7aaaea07e2379.1781567582.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
X-Spam-Score: -2.80

A swap file on btrfs will pin down block groups that cover the swap file
extent.

Pinned down block groups will be skipped for scrub and relocation.

These degradation on critical btrfs maintenance operations is never
properly educated to end users, and have already caused problems
including:

- Scrub finished too quick
  Because the enabled swap file has pinned down most of the block
  groups. Thus any file extents in those block groups, even not utilized
  by the swap file, will be skipped from scrub.

- Unbalanced data and metadata usage, meanwhile relocation won't help
  The same reason, pinned down block groups will not be considered as
  relocation target, thus data extents that are not utilized by the swap
  file can still be skipped from relocation.

Although we already have kernel messages for both scrub and balance, the
balance one is still info level.

To better communicate those potential long term problems, add the
following output into dmesg:

- Change the message level to warn for __btrfs_balance()

- Total pinned down block group number and size during swapfile activation
- Total released block group number and size during swapfile deactivation
  The above messages have info level.

- The fact that pinned down block groups will not be scrubbed nor
  balanced
  The above message has warning level.

The example output would look like the following, for enabling a 1.2G
swapfile, which pinned down 2G block groups:

 BTRFS info (device dm-3): swapfile activated on root 5 ino 257, pinned down 2147483648 bytes from 2 block group(s)
 BTRFS warning (device dm-3): block groups with swapfile extents will not be scrubbed or balanced
 Adding 1257468k swap on /mnt/btrfs/foobar.  Priority:-1 extents:1 across:1257468k
 BTRFS info (device dm-3): swapfile deactivated on root 5 ino 257, released 2147483648 bytes from 2 block group(s)

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Add the total number of block groups pinned down
- Slightly reword the messages
- Unify -ETXTBSY messages to warn level
---
 fs/btrfs/inode.c   | 28 ++++++++++++++++++++++++++--
 fs/btrfs/volumes.c |  2 +-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16f097f58acc..ebd1387fcc76 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10011,6 +10011,8 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct btrfs_swapfile_pin *sp;
 	struct rb_node *node, *next;
+	u64 bg_bytes_released = 0;
+	u32 bg_nr_released = 0;
 
 	spin_lock(&fs_info->swapfile_pins_lock);
 	node = rb_first(&fs_info->swapfile_pins);
@@ -10020,15 +10022,24 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 		if (sp->inode == inode) {
 			rb_erase(&sp->node, &fs_info->swapfile_pins);
 			if (sp->is_block_group) {
-				btrfs_dec_block_group_swap_extents(sp->ptr,
+				struct btrfs_block_group *bg = sp->ptr;
+
+				bg_bytes_released += bg->length;
+				bg_nr_released++;
+				btrfs_dec_block_group_swap_extents(bg,
 							   sp->bg_extent_count);
-				btrfs_put_block_group(sp->ptr);
+				btrfs_put_block_group(bg);
 			}
 			kfree(sp);
 		}
 		node = next;
 	}
 	spin_unlock(&fs_info->swapfile_pins_lock);
+	btrfs_info(fs_info,
+"swapfile deactivated on root %llu ino %llu, released %llu bytes from %u block group(s)",
+		   btrfs_root_id(BTRFS_I(inode)->root),
+		   btrfs_ino(BTRFS_I(inode)), bg_bytes_released,
+		   bg_nr_released);
 }
 
 struct btrfs_swap_info {
@@ -10106,8 +10117,10 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	struct btrfs_backref_share_check_ctx *backref_ctx = NULL;
 	struct btrfs_path *path = NULL;
 	int ret = 0;
+	u32 pinned_bg_nr = 0;
 	u64 isize;
 	u64 prev_extent_end = 0;
+	u64 pinned_bg_size = 0;
 
 	/*
 	 * Acquire the inode's mmap lock to prevent races with memory mapped
@@ -10357,6 +10370,9 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 				ret = 0;
 			else
 				goto out;
+		} else {
+			pinned_bg_size += bg->length;
+			pinned_bg_nr++;
 		}
 
 		if (bsi.block_len &&
@@ -10404,6 +10420,14 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (ret)
 		return ret;
 
+	btrfs_info(fs_info,
+"swapfile activated on root %llu ino %llu, pinned down %llu bytes from %u block group(s)",
+		   btrfs_root_id(BTRFS_I(inode)->root),
+		   btrfs_ino(BTRFS_I(inode)),
+		   pinned_bg_size, pinned_bg_nr);
+	btrfs_warn(fs_info,
+"block groups with swapfile extents will not be scrubbed or balanced");
+
 	if (device)
 		sis->bdev = device->bdev;
 	*span = bsi.highest_ppage - bsi.lowest_ppage + 1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73ce4..2d132c827913 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4588,7 +4588,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if (ret == -ENOSPC) {
 			enospc_errors++;
 		} else if (ret == -ETXTBSY) {
-			btrfs_info(fs_info,
+			btrfs_warn(fs_info,
 	   "skipping relocation of block group %llu due to active swapfile",
 				   found_key.offset);
 			ret = 0;
-- 
2.54.0

