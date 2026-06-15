Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB733A1DB
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781499170; cv=none; b=F/FxYKEENspd3pT+7+I/kJ42POCY+qfHpF2prWzLmpTcOoAnuSO8iOp2Qto/PpwWWD4fk/y67x6bCei1hq42CtGU8025OfsyqENxcxL15BNSN6DC+BIcEg3JPSqeR0xYae8N2e89y9Gv18DmghBKAqyZlF8lng4qnXxIF3TYomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781499170; c=relaxed/simple;
	bh=raYI5z5XfHE4DyTusTSwf+UgFKiAztStHB/2CO0ahmc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ek4ZsXFcWXTzX/KRwERCaXequRD1ooo2ClP8n1yC5+qf1OJpdxOknWKVhl7qfVVHKp9CEk74Yv5zCTi6MNrkcCi8PLyrADPnPyvghIrIKihVzzEVPsBiITY64migJCcfrLt0eOCDVPF+q/nAuwr67iHZ0wbQdtpucQuSKtknZrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qEm5kS/J; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qEm5kS/J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qEm5kS/J";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qEm5kS/J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D57C75BDA
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781499167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EM5Zgjq4jBe+1JJE6KysNdHITa2ZaZhuf2jUg975/XI=;
	b=qEm5kS/JJfeZpTTvet3PsiS3zLQWeCzC9KhfgXR+N7C6OFuLU2LLcb5CXyJYYiL49fVYvD
	sZXtGEcLhwACmFeIzT7vjCcc9k9UU2aPnJ6mtriYGXWCD9L6+0QHD3DYJmA9OwmY5w1OcW
	dn+6QJkaHQ2ziqDcOxxu9/gpKldNlmk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781499167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EM5Zgjq4jBe+1JJE6KysNdHITa2ZaZhuf2jUg975/XI=;
	b=qEm5kS/JJfeZpTTvet3PsiS3zLQWeCzC9KhfgXR+N7C6OFuLU2LLcb5CXyJYYiL49fVYvD
	sZXtGEcLhwACmFeIzT7vjCcc9k9UU2aPnJ6mtriYGXWCD9L6+0QHD3DYJmA9OwmY5w1OcW
	dn+6QJkaHQ2ziqDcOxxu9/gpKldNlmk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 383CD779A7
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:52:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vPBvNR2FL2rzLgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:52:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: log swapfile activation/deactivation and warn about pinned block groups
Date: Mon, 15 Jun 2026 14:22:27 +0930
Message-ID: <7c78c0a89b825e6bd3759e425a5e69ea338cf976.1781499135.git.wqu@suse.com>
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

To better communicate those potential long term problems, add the
following output into dmesg:

- Total pinned down block group size during swapfile activation
- Total released block group size during swapfile deactivation
  The above messages have info level.

- The fact that pinned down block groups will not be scrubbed nor
  balanced
  The above message has warning level.

The example output would look like the following, for enabling a 1.2G
swapfile, which pinned down 2G block groups:

 BTRFS info (device dm-3): swapfile activated on root 5 ino 257, pinned down 2147483648 bytes of block groups
 BTRFS warning (device dm-3): any extent in pinned block groups will not be able to be scrubbed nor balanced
 Adding 1257468k swap on /mnt/btrfs/foobar.  Priority:-1 extents:1 across:1257468k
 BTRFS info (device dm-3): swapfile deactivated on root 5 ino 257, released 2147483648 bytes of block groups

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16f097f58acc..288dc323d1c2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10011,6 +10011,7 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct btrfs_swapfile_pin *sp;
 	struct rb_node *node, *next;
+	u64 bg_released = 0;
 
 	spin_lock(&fs_info->swapfile_pins_lock);
 	node = rb_first(&fs_info->swapfile_pins);
@@ -10020,15 +10021,22 @@ static void btrfs_free_swapfile_pins(struct inode *inode)
 		if (sp->inode == inode) {
 			rb_erase(&sp->node, &fs_info->swapfile_pins);
 			if (sp->is_block_group) {
-				btrfs_dec_block_group_swap_extents(sp->ptr,
+				struct btrfs_block_group *bg = sp->ptr;
+
+				bg_released += bg->length;
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
+	"swapfile deactivated on root %llu ino %llu, released %llu bytes of block groups",
+		   btrfs_root_id(BTRFS_I(inode)->root),
+		   btrfs_ino(BTRFS_I(inode)), bg_released);
 }
 
 struct btrfs_swap_info {
@@ -10108,6 +10116,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	int ret = 0;
 	u64 isize;
 	u64 prev_extent_end = 0;
+	u64 pinned_bg_size = 0;
 
 	/*
 	 * Acquire the inode's mmap lock to prevent races with memory mapped
@@ -10357,6 +10366,8 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 				ret = 0;
 			else
 				goto out;
+		} else {
+			pinned_bg_size += bg->length;
 		}
 
 		if (bsi.block_len &&
@@ -10404,6 +10415,14 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (ret)
 		return ret;
 
+	btrfs_info(fs_info,
+"swapfile activated on root %llu ino %llu, pinned down %llu bytes of block groups",
+		   btrfs_root_id(BTRFS_I(inode)->root),
+		   btrfs_ino(BTRFS_I(inode)),
+		   pinned_bg_size);
+	btrfs_warn(fs_info,
+"any extent in pinned block groups will not be able to be scrubbed nor balanced");
+
 	if (device)
 		sis->bdev = device->bdev;
 	*span = bsi.highest_ppage - bsi.lowest_ppage + 1;
-- 
2.54.0

