Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A33382379
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 06:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787246; cv=none; b=YLH23pW5zORzzq/ekhJuEUlGjr972wqF5VdYYVqg+82pSseJ0Pn+ZiwWFLb+H8E/hiZx2CwKANnjAQzcRdvt8nDhn4VLLHV89lc759dWWm7qe5wXDeXwEjX8g8S+cCXqa9atc0CepQ5zu0ThOfcBQDt4LEN5lYlZCvCYIOgiqY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787246; c=relaxed/simple;
	bh=y1WRn4oG+2eZ6rirtOcKjDe5hkMy5yz5Waurxq2OOF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qsA3NxFVCdSRgucnLKWFANrpgqSwv6jqkDSO5QbLfmUbaSpDm7xtCuoB0mijz7A3tM7hHRL/juwVemaGqGxQhXF6aH1gKEdstFSwdUhCmJ9by1rVZB/WT9oLNfphcK0wn62sSaFLUV1MLTNTba9u2ekOnZ2yKjyxgtWIne7CXhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YSGzCHO8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YSGzCHO8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YSGzCHO8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YSGzCHO8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AADE3E4C;
	Thu, 23 Jul 2026 06:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784787243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=i+m9XRYQL/NHrhnb6CON2KidYa3IhH6lUnBnuh4oBUI=;
	b=YSGzCHO8FIzII4LCeu5aPvrk/InpcoexOv5BunmFMKrdZGCaU7ZHduneXAfg12e1Z1YB7S
	U8Q6Ewy6bDkgic9+6B37d8MihRYfFJVeHrHrXg46tfbvP/2iMNfbXOyzk+YucL/wLfw810
	vcB5MLpdkfbOcnB+ecvNrxsNXvQ4M7I=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784787243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=i+m9XRYQL/NHrhnb6CON2KidYa3IhH6lUnBnuh4oBUI=;
	b=YSGzCHO8FIzII4LCeu5aPvrk/InpcoexOv5BunmFMKrdZGCaU7ZHduneXAfg12e1Z1YB7S
	U8Q6Ewy6bDkgic9+6B37d8MihRYfFJVeHrHrXg46tfbvP/2iMNfbXOyzk+YucL/wLfw810
	vcB5MLpdkfbOcnB+ecvNrxsNXvQ4M7I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06352779B5;
	Thu, 23 Jul 2026 06:14:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 888fLimxYWoxfAAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 23 Jul 2026 06:14:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios without fs knowing
Date: Thu, 23 Jul 2026 15:43:40 +0930
Message-ID: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

There is a bug report that a reproducer which doing the following
workloads in two threads:

- Direct read into memory mapped from page cache
- Sync the above range

This can lead to dirty folios without fs knowing, this can be a huge
problem for btrfs, as even on the very basic bs == ps cases without
large folios, such reproducer can screw up the ordered extent accounting
already:

 ------------[ cut here ]------------
 WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/u42:0/68
 CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            E       7.2.0-rc4-custom+ #415 PREEMPT(full)  74dbeafab12c410178747d5bec9fb200ae56949f
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 Workqueue: btrfs-endio simple_end_io_work [btrfs]
 RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
 Call Trace:
  <TASK>
  btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
  end_bbio_data_write+0x1ff/0x280 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
  btrfs_bio_end_io+0x76/0xf0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
  process_one_work+0x198/0x380
  worker_thread+0x1c8/0x330
  kthread+0xee/0x120
  ret_from_fork+0x28f/0x310
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS critical (device dm-3): bad ordered extent accounting, root=5 ino=257 OE offset=3465216 OE len=2826240 to_dec=319488 left=135168

Unfortunately we have removed cow fixup mechanism, which is to work
around such dirty folios by re-dirtying them and reserve space for them,
across several kernel releases, meaning we can not easily revert a
single commit to bring it back.
And without doubt, that old cow fixup mechanism is not support larger
folios.

As a hot fix, disable btrfs direct reads for non-experimental builds for
now, so this can buy some time before we find out a proper way to address
this.

Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fallback to buffered IO to avoid failing existing direct IO users

- Allow direct writes

Reason for RFC:
I'm not 100% sure if disabling direct IOs can fill all the holes.

We still allow mmapping page cache into user spaces, thus I'm not sure
if this is the only hole.
---
 fs/btrfs/direct-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed1779ccb4de..32b29a4faaf2 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -1093,6 +1093,11 @@ ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	if (check_direct_read(inode_to_fs_info(inode), to, iocb->ki_pos))
 		return 0;
 
+#ifndef CONFIG_BTRFS_EXPERIMENTAL
+	/* To avoid dirty folios without fs knowing through */
+	return 0;
+#endif
+
 	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_SHARED);
 again:
 	/*
-- 
2.54.0

