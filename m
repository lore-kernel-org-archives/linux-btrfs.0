Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C640D57C
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jun 2026 02:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781921245; cv=none; b=TCTpu7OjaVJl102GX3+wB8TSdzNbz2RsmXN3elEtAoeD/EggAZoOqf92klmRA5KjGGRZV1361CIEeRwgUjm1JFt9B3O576XRM0z2PmTT5zfzCLLZFG0mYOe27RjJDKALjVPh7SzWe58mooH59AYoZBghAIdFvc39Rtcp8mDqS4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781921245; c=relaxed/simple;
	bh=GRaH6PDy9wxijNLRts/VbMyi61v2Tya932AMKfDKH/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DklaecitgtH+2ArU+DKnsJrI1O+4sDTMWxUcBCvyt3go1NPI6dL4EEeYM4qPNQYAk4uMN0yg6KnOG4PLdkjUtDSNQVYyzNaFW+gbdA5xTnYzGJcUd5RRMRHa/qfu0U3c8fOzRpeSapwdd3FhcZ2Z+cvXyBBKyqCmZAtSpZUBuRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EICtP0sT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Hho9/1DL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EICtP0sT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Hho9/1DL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D425375ED4;
	Sat, 20 Jun 2026 02:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781921242; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NQhgVIoC3wxbYhMsjPHC0EE7s6zbQbrpSVEPmvC2nUo=;
	b=EICtP0sTgkcW3X35kSnvr21IrQgFt5uf3DKUX73rErFIC+qLeddL9Ok99QDnze2NwyvcbJ
	HiW6ZQYMddfbk+9Ke9b/SSSxii9DF4F+qEtd3ZyrrgHbl0qBt6bQ7gfBJ8hKFUnmOBkhLr
	ilReprB3FJGvWvHpmLlBvV6oPHxd7u8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781921240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NQhgVIoC3wxbYhMsjPHC0EE7s6zbQbrpSVEPmvC2nUo=;
	b=Hho9/1DL6Xv3/iGnsiE6/KJkYwtyIUmR9xBiS05QYUF4SaLZmlW1z52tjHw8eY1fLNlsp2
	mX/AKNDOAvcQW5s5spMQCBXmyF3QY3sZo23PsEznXgJ3pv6mha+AliM1qaSHHyhv50Y6XO
	kpWDeoS+UYCoyLzLrEUrwzCqmxrIR9Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C33C779A8;
	Sat, 20 Jun 2026 02:07:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id upUID9f1NWqGMgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 20 Jun 2026 02:07:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Glass Su <glass.su@suse.com>
Subject: [PATCH] btrfs: do not check eb->refs to determine if the eb is still held
Date: Sat, 20 Jun 2026 11:37:01 +0930
Message-ID: <8b5fd5214014615765dfdc66f89347c4ea8b2654.1781921185.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

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

[WORKAROUND]
Unfortunately EXTENT_BUFFER_READING flag clearing is always before
extent buffer put, thus there is no simple way to make sure the read is
finished along with eb put.

For now just remove the eb->refs check until a proper protection is
introduced for clearing EXTENT_BUFFER_READING and updates of eb->refs.

Reported-by: Glass Su <glass.su@suse.com>
Link: https://lore.kernel.org/linux-btrfs/DC0C775E-13B3-47D9-9AB2-895BB11C029D@suse.com/
Fixes: 83f7e52b7ed1 ("btrfs: warn about extent buffer that can not be released")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0a7d80da9c94..39a389cdbdd4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3328,10 +3328,14 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
 				       TASK_UNINTERRUPTIBLE);
 		/*
-		 * The refs threshold is 2, one held by us at the beginning
-		 * of the loop, one for the ownership in the buffer tree.
+		 * EXTENT_BUFFER_READING is cleared then the eb refs is put during
+		 * end_bbio_meta_read(), which leaves a window where above wait
+		 * finished but eb ref is still hold by endio.
+		 *
+		 * Thus we can not use eb->refs to determine if the eb is hold
+		 * by someone else. Just check if the eb is still under IO.
 		 */
-		if (unlikely(refcount_read(&eb->refs) > 2 || extent_buffer_under_io(eb))) {
+		if (unlikely(extent_buffer_under_io(eb))) {
 			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
 			btrfs_warn(fs_info,
 			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
-- 
2.54.0

