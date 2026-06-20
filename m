Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351940D57A
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 05:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781932053; cv=none; b=u44TeTb9Jh7irBKrSr9STjXkGM8ZxXgee3NRlUaeqPCXl889m3ueisPn1gHxKIO9FXNcneACn+9O54RpZrsZ7SZJLEgxwAIVI8q3B016hDSLgaRCMuJKVCxRTgYHliL4H6G2UL6UfcvgBGlUcfGtzDlmNsy0WKkGheUDX2a/93Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781932053; c=relaxed/simple;
	bh=ugShM9MC2QiRn6Os2E3nucizcUtnk7NxKgKrfCOfCzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oOpM07ITQT35jCv0oVUhjwl5ILHhkihM1D1euXOjnwxGnUr9IAI04IbNGM2GI6HeaRfK5wVbZQaAGgy9ruZlTJMswjICILpTEoMh7Z0yaJ1RnErGcdvimlEGRuTuxvXJuC6FjCMuOGRU4p9Z6EMeJDsetMgl0jZXvpWcVkeCyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H0LYAs0a; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Tq94O0L+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H0LYAs0a";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Tq94O0L+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF2BC6DF2A;
	Sat, 20 Jun 2026 05:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781932050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jUv6v4qy0X+E11EMPWU5aCN1qWP9drCrX67heBreBdw=;
	b=H0LYAs0aEt0TOLqrdblL4NkC8OmLPWl7sj0MiUtP1ChK4c79D0FZvAo8PkpznoFviyCynw
	an7DuwGXoTdWoNnKQItL9jll9dKsOY7uZlZd0TH6Pz36eU11ntLtNu+Exo8fJO7gX72Lg6
	U01NzdKhiLiZaM85wVxXx4MOH1a4HnI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Tq94O0L+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781932049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jUv6v4qy0X+E11EMPWU5aCN1qWP9drCrX67heBreBdw=;
	b=Tq94O0L+inbGkyytVTkyhJr7vx0wztguAVWB0ccL4UaBTqTLBjIOdO7lyvq/0lQZvgFAXt
	so0FQy9fInFQuHQLKi2iroMo0B6JEYldsB265wDEfTkZkkEqICdrX83DqZy7hCrzh1axLW
	31WLY3FAXd2SAeQwJZMAayqBPCjjSMg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4A68779A8;
	Sat, 20 Jun 2026 05:07:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pUImFRAgNmoVVwAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 20 Jun 2026 05:07:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <glass.su@suse.com>
Subject: [PATCH] btrfs: make sure EXTENT_BUFFER_READING is cleared under refs_lock
Date: Sat, 20 Jun 2026 14:37:02 +0930
Message-ID: <14aca1944da7170799aea08df9af85728a2f2233.1781932019.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EF2BC6DF2A
X-Spam-Score: -3.01

[FALSE ALERTS]
There is a bug report that the warning inside
invalidate_and_check_btree_folios() got triggered duriong btrfs/298:

 BTRFS info (device sdd): first mount of filesystem f9bf732a-a19b-44b9-99a7-614ddff168e2
 BTRFS info (device sdd): using crc32c checksum algorithm
 BTRFS error (device sdd): failed to find fsid cb2fdb42-b638-4f2f-badd-4127467ba674 when attempting to open seed devices
 BTRFS error (device sdd): failed to read chunk tree: -2
 ------------[ cut here ]------------
 WARNING: disk-io.c:3342 at invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs], CPU#4: mount/125993
 CPU: 4 UID: 0 PID: 125993 Comm: mount Tainted: G        W  OE       7.1.0-rc7-custom+ #1 PREEMPT(full)
 Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/12/2025
 Call trace:
  invalidate_and_check_btree_folios+0x260/0x3c0 [btrfs] (P)
  open_ctree+0x1f50/0x23b0 [btrfs]
  btrfs_get_tree+0x89c/0xc48 [btrfs]
  vfs_get_tree+0x30/0x110
  vfs_cmd_create+0x58/0xe8
  __arm64_sys_fsconfig+0x39c/0x518
  invoke_syscall.constprop.0+0x48/0x120
  el0_svc_common.constprop.0+0x40/0xe8
  do_el0_svc+0x24/0x38
  el0_svc+0x50/0x310
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x198/0x1a0
 ---[ end trace 0000000000000000 ]---
 BTRFS warning (device sdd): unable to release extent buffer 365985792 owner 3 gen 17 refs 3 flags 0x5

[CAUSE]
In that invalidate_and_check_btree_folios() we wait for the eb to finish
its read, then check if it's only held by us and the btree inode.

If not, then do a warning as it may be still held, and could cause
problems.

But there is a small window where the check can lead to false alerts:

    Thread A (Read endio)         |        Thread B (Unmount)
----------------------------------+-------------------------------------
 end_bbio_meta_read()             |
 | The eb has one extra ref held  |
 | by the reader, and has         |
 | EXTENT_BUFFER_READING flag set | invalidate_and_check_btree_folios()
 |                                | |
 |- clear_extent_buffer_reading() | |
 |                                | |- wait_on_bit_io();
 |                                | |  The EXTENT_BUFFER_READING flag is
 |                                | |  cleared
 |                                | |- if (refcount_read(eb->refs) > 2)
 |                                |    The eb is held by the read, us
 |                                |    and btree inode, thus it
 |                                |    will trigger the warning
 |- free_extent_buffer()          |

[FIX]
Introduce a helper, free_extent_buffer_clear_reading().

If the new parameter, @clear_reading, is set, we will hold the spinlock
at the beginning of free_extent_buffer_clear_reading() to make sure the
READING flag is cleared inside the same critical of decreasing refs.

Now free_extent_buffer() will just call
free_extent_buffer_clear_reading() with @clear_reading set to false, so
no behavior change.

But for end_bbio_meta_read(), it will not clear_extent_buffer_reading()
directly, but pass @clear_reading as true.

Then inside invalidate_and_check_btree_folios(), hold the refs_lock
before reading refs.
So that we eliminate the race window completely.

Reported-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/linux-btrfs/DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com/
Fixes: 83f7e52b7ed1 ("btrfs: warn about extent buffer that can not be released")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   | 15 +++++++++++++--
 fs/btrfs/extent_io.c | 42 ++++++++++++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0a7d80da9c94..c4143c847827 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3318,6 +3318,8 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 	 */
 	rcu_read_lock();
 	xa_for_each(&fs_info->buffer_tree, index, eb) {
+		unsigned int refs;
+
 		/* Increase the ref so that the eb won't disappear. */
 		if (!refcount_inc_not_zero(&eb->refs))
 			continue;
@@ -3327,17 +3329,26 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
 			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
 				       TASK_UNINTERRUPTIBLE);
+		/*
+		 * We hold the spinlock to make sure above READING is
+		 * cleared with the held ref dropped.
+		 * Or we can hit a race window and lead to false alerts.
+		 */
+		spin_lock(&eb->refs_lock);
+		refs = refcount_read(&eb->refs);
+		spin_unlock(&eb->refs_lock);
+
 		/*
 		 * The refs threshold is 2, one held by us at the beginning
 		 * of the loop, one for the ownership in the buffer tree.
 		 */
-		if (unlikely(refcount_read(&eb->refs) > 2 || extent_buffer_under_io(eb))) {
+		if (unlikely(refs > 2 || extent_buffer_under_io(eb))) {
 			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
 			btrfs_warn(fs_info,
 			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
 				   eb->start, btrfs_header_owner(eb),
 				   btrfs_header_generation(eb),
-				   refcount_read(&eb->refs), eb->bflags);
+				   refs, eb->bflags);
 		}
 		free_extent_buffer(eb);
 		rcu_read_lock();
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0edd532174fa..33f50cb89a81 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3709,12 +3709,30 @@ static int release_extent_buffer(struct extent_buffer *eb)
 	return 0;
 }
 
-void free_extent_buffer(struct extent_buffer *eb)
+static void clear_extent_buffer_reading(struct extent_buffer *eb)
+{
+	clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
+}
+
+static void free_extent_buffer_clear_reading(struct extent_buffer *eb,
+					     bool clear_reading)
 {
 	int refs;
+
 	if (!eb)
 		return;
 
+	/*
+	 * We want to clear READING flag and decrease refs in the same
+	 * critical section.
+	 * This will make sure invalidate_and_check_btree_folios() won't
+	 * see an eb with READING cleared but refs not yet decreased.
+	 */
+	if (clear_reading) {
+		spin_lock(&eb->refs_lock);
+		clear_extent_buffer_reading(eb);
+	}
+
 	refs = refcount_read(&eb->refs);
 	while (1) {
 		if (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
@@ -3725,11 +3743,16 @@ void free_extent_buffer(struct extent_buffer *eb)
 		}
 
 		/* Optimization to avoid locking eb->refs_lock. */
-		if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1))
+		if (atomic_try_cmpxchg(&eb->refs.refs, &refs, refs - 1)) {
+			if (clear_reading)
+				spin_unlock(&eb->refs_lock);
 			return;
+		}
 	}
 
-	spin_lock(&eb->refs_lock);
+	if (!clear_reading)
+		spin_lock(&eb->refs_lock);
+
 	if (refcount_read(&eb->refs) == 2 &&
 	    test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
 	    !extent_buffer_under_io(eb) &&
@@ -3743,6 +3766,11 @@ void free_extent_buffer(struct extent_buffer *eb)
 	release_extent_buffer(eb);
 }
 
+void free_extent_buffer(struct extent_buffer *eb)
+{
+	return free_extent_buffer_clear_reading(eb, false);
+}
+
 void free_extent_buffer_stale(struct extent_buffer *eb)
 {
 	if (!eb)
@@ -3868,11 +3896,6 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 		btrfs_meta_folio_set_uptodate(eb->folios[i], eb);
 }
 
-static void clear_extent_buffer_reading(struct extent_buffer *eb)
-{
-	clear_and_wake_up_bit(EXTENT_BUFFER_READING, &eb->bflags);
-}
-
 static void end_bbio_meta_read(struct btrfs_bio *bbio)
 {
 	struct extent_buffer *eb = bbio->private;
@@ -3896,8 +3919,7 @@ static void end_bbio_meta_read(struct btrfs_bio *bbio)
 	else
 		clear_extent_buffer_uptodate(eb);
 
-	clear_extent_buffer_reading(eb);
-	free_extent_buffer(eb);
+	free_extent_buffer_clear_reading(eb, true);
 
 	bio_put(&bbio->bio);
 }
-- 
2.54.0

