Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74E939A05C
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 09:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776331184; cv=none; b=mocj1fiC9nzTLpN+Th0bQ/3U4oGQ8ceuvuloLe3Y0/5zlBkAJ3VFkyhThy3LBbR7Oo4uYC8GdS4WZ0LNm9g3eyrwzjNiohmoljK8q+6E1ItMC4xbWRPBKJF14paVtjNzErY2/XQGpQqhA486QrqpBApln9QK30abH+Oh1varNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776331184; c=relaxed/simple;
	bh=4D+zNNjaWXjdz6mcLLbr/w55TyDiMBCosTy5CegoMRs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=e2J+yJryM2XwU4Qk80Qohn9QEyFKretbQ5+4+eHkqRC4VkPtdnoKH69tvu2+1/tx8zt+DowJJdH/uY4ZpMfLaicv8icBOg3A3c0CZOGLbWHajqZkZmYLdWGa2GmqRmKJKCBV4FCqU31LHUO2WJNq12K6ou76diqOILeS6gLd0r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uvMDHdpM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jKGm1jhy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uvMDHdpM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jKGm1jhy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC2D96A7F7
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 09:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776331181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MazVV1ZdCy/YdfLWP3Qx5ynz4qfyQR6qsfuFfZlRYbs=;
	b=uvMDHdpMUEhTydjedtRaXAp5Uuj0SMfde+xOSnYDG4spHnshSFUMUnXxppEDsxonrRhfio
	WJF6zjDRYn/dC9CiCdESQ4d6mr0ojDLAYuXfxxdZR5OrXtYjTgR36kfwn5QajPi4Lrdfs/
	GztITcqzB3vE+v4GzgMq3PyXL/Mk+PU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jKGm1jhy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776331180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MazVV1ZdCy/YdfLWP3Qx5ynz4qfyQR6qsfuFfZlRYbs=;
	b=jKGm1jhyHW9uir7smtzGhD36oN70xs/ggWceByrObTudmiplCyz/RUgKBz/ftwU8Ww6YaX
	r8yQpcA2kcTDMfA+xt3RQ/2oN+mfWm1Fx0751HdV+Sq9V/T2pHUsDzbr/ri9zVtfSSi7To
	UyJX4VSPZc8u7RDXDAleHUyG4a4OoAM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35DFD4BEAB
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 09:19:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oXNwOqup4Gk8YQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 09:19:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: cleanup the ebs when the metadata writeback range failed
Date: Thu, 16 Apr 2026 18:49:14 +0930
Message-ID: <81a6ca07ec1309239e263151a353ef9aa6703469.1776331057.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: EC2D96A7F7
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[WARNING]
With the recent warning added by commit "btrfs: warn about extent buffer
that can not be released", test case generic/388 can trigger the
following warning:

 BTRFS: device fsid afbe908d-e199-4cd5-858c-a52800fed6f2 devid 1 transid 3940 /dev/mapper/test-scratch1 (253:2) scanned by mount (66844)
 BTRFS info (device dm-2): first mount of filesystem afbe908d-e199-4cd5-858c-a52800fed6f2
 BTRFS info (device dm-2): using crc32c checksum algorithm
 BTRFS info (device dm-2): turning on async discard
 BTRFS info (device dm-2): enabling free space tree
 BTRFS critical (device dm-2 state E): emergency shutdown
 BTRFS error (device dm-2 state E): error while writing out transaction: -30
 BTRFS warning (device dm-2 state E): Skipping commit of aborted transaction.
 BTRFS error (device dm-2 state EA): Transaction aborted (error -30)
 BTRFS: error (device dm-2 state EA) in cleanup_transaction:2068: errno=-30 Readonly filesystem
 BTRFS info (device dm-2 state EA): forced readonly
 BTRFS warning (device dm-2 state EA): Skipping commit of aborted transaction.
 BTRFS info (device dm-2 state EA): last unmount of filesystem afbe908d-e199-4cd5-858c-a52800fed6f2
 ------------[ cut here ]------------
 WARNING: fs/btrfs/disk-io.c:3304 at invalidate_btree_folios+0xd5/0x1a6 [btrfs], CPU#6: umount/66872
 CPU: 6 UID: 0 PID: 66872 Comm: umount Tainted: G        W           7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 Call Trace:
  <TASK>
  close_ctree+0x534/0x57a [btrfs 221aeb03de8eb7d91f94bd737554730626a2b838]
  generic_shutdown_super+0x89/0x1a0
  kill_anon_super+0x16/0x40
  btrfs_kill_super+0x16/0x20 [btrfs 221aeb03de8eb7d91f94bd737554730626a2b838]
  deactivate_locked_super+0x2d/0xb0
  cleanup_mnt+0xdc/0x140
  task_work_run+0x5a/0xa0
  exit_to_user_mode_loop+0x123/0x4b0
  do_syscall_64+0x288/0x7d0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 115638272 owner 1 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 115671040 owner 9 refs 2 flags 0x7
 ...
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 116817920 owner 1 refs 2 flags 0x7
 BTRFS warning (device dm-2 state EA): unable to release extent buffer 116834304 owner 1 refs 2 flags 0x7

[CAUSE]
Inside btrfs_write_marked_extents(), we clear the @mark from
@dirty_pages io tree.

For the above warning example, it's clearing EXTENT_DIRTY flag from
transaction->dirty_pages io tree, which is utilized to track dirty
metadata pages belonging to the current transaction.

But the EXTENT_DIRTY flag is converted to EXTENT_NEED_WAIT immediately,
before we even started metadata writeback.

And furthermore, we rely on filemap_fdatawrite_range() ->
btree_writepages() -> lock_extent_buffer_for_io() to clear the
EXTENT_BUFFER_DIRTY flag for the involved extent buffers.
Normally this call chain succeeds, so the involved ebs also have their
DIRTY flag cleared.

But if filemap_fdatawrite_range() failed, there is no guarantee that all
involved EBs are properly submitted, thus they may still have
EXTENT_BUFFER_DIRTY flag left.

Those dirty EBs will stay there until detected by the recently
introduced invalidate_btree_folios() and trigger the warning.

[FIX]
Introduce a helper, btrfs_btree_cleanup_range(), to not only
wait for any submitted ebs, but also call btrfs_clear_buffer_dirty()
for any ebs inside the target range.

This will ensure transaction->dirty_pages have its EXTENT_DIRTY flag
matching the underlying extent buffers' EXTENT_BUFFER_DIRTY flag, and
avoid the warning inside invalidate_btree_folios().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c   | 44 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/transaction.c | 11 ++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4eab0f9909e3..ea0f1a73d3e2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2308,6 +2308,50 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
 	}
 }
 
+void __cold btrfs_btree_cleanup_range(struct btrfs_fs_info *fs_info,
+					 u64 start, u64 end)
+{
+	struct eb_batch batch;
+	unsigned long start_index = (start >> fs_info->nodesize_bits);
+	const unsigned long end_index = (end >> fs_info->nodesize_bits);
+
+	eb_batch_init(&batch);
+	/* Wait for writeback ebs first. */
+	while (start_index <= end_index) {
+		struct extent_buffer *eb;
+		unsigned int nr_ebs;
+
+		nr_ebs = buffer_tree_get_ebs_tag(fs_info, &start_index, end_index,
+						 PAGECACHE_TAG_WRITEBACK, &batch);
+		if (!nr_ebs)
+			break;
+
+		while ((eb = eb_batch_next(&batch)) != NULL)
+			wait_on_extent_buffer_writeback(eb);
+		eb_batch_release(&batch);
+		cond_resched();
+	}
+	/* Clear remaining dirty ebs. */
+	start_index = (start >> fs_info->nodesize_bits);
+	while (start_index <= end_index) {
+		struct extent_buffer *eb;
+		unsigned int nr_ebs;
+
+		nr_ebs = buffer_tree_get_ebs_tag(fs_info, &start_index, end_index,
+						 PAGECACHE_TAG_DIRTY, &batch);
+		if (!nr_ebs)
+			break;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			btrfs_tree_lock(eb);
+			btrfs_clear_buffer_dirty(NULL, eb);
+			btrfs_tree_unlock(eb);
+		}
+		eb_batch_release(&batch);
+		cond_resched();
+	}
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b284aee1bfb0..cf7afde0a78b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -262,6 +262,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 int btrfs_writepages(struct address_space *mapping, struct writeback_control *wbc);
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
+void __cold btrfs_btree_cleanup_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
 void btrfs_readahead(struct readahead_control *rac);
 int set_folio_extent_mapped(struct folio *folio);
 void clear_folio_extent_mapped(struct folio *folio);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785051..b19f64db9518 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1185,8 +1185,17 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 		if (!ret && wait_writeback)
 			btrfs_btree_wait_writeback_range(fs_info, start, end);
 		btrfs_free_extent_state(cached_state);
-		if (ret)
+		if (ret) {
+			/*
+			 * The original mark of dirty_pages is cleared, but
+			 * we hit an error, there is no guarantee the corresponding
+			 * ebs have been submitted.
+			 * So we need to wait for writeback range and also clear
+			 * dirty extent buffers for the range.
+			 */
+			btrfs_btree_cleanup_range(fs_info, start, end);
 			break;
+		}
 		cached_state = NULL;
 		cond_resched();
 		start = end + 1;
-- 
2.53.0

