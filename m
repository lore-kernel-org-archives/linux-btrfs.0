Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13773ACA64
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 05:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784785284; cv=none; b=Rm6svEK0YD1MmSYQ5LEnX3c4YRVvLU47gK6ywO2HX022kT2DD4S7I5Njqz0OCHBnsiOoHkIvV5dUZbkG1MTMoSBvrTxROd+G4glbGzQx9XDqcBuSCo0SJgkfFB1ZZB9ceSwPTmQTKpNTODhk5TY6XJJxmkv8K5Qw/53CET8ea6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784785284; c=relaxed/simple;
	bh=CgFnzyeiH3/TiAZgdBl9/26mx7/4tcM3JzHoEOJiPqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BuTjvtnvRc6C4bhKEX55e6/Xq60rJ3ncNDPxgHeI2yfiaMOFGaUkJjPu4u3OAqw16wiYPWPK9DUtP0QN0rUjsk8DjPEsD5S/ayjBgLEN6Pu4u6+axLKAHdCHT+oZlE90pDLU15o3QBsWD6qxq1SBv7z6B+USXfP4CJC0Bv2yknY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gkEQT5TI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gkEQT5TI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gkEQT5TI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gkEQT5TI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B422A3E38;
	Thu, 23 Jul 2026 05:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784785277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eJEZNn3400d095D6oCSLmu9xMdDYVwKtFn+01ufgD64=;
	b=gkEQT5TIPYnv7scLMj424Pn1ENUmg+uL2loCmB9JLPxGt70FWX+yIkbUyNFbKBCJV6JF/+
	VZY6lBw0dIhdoYqzjbaaPG7iGIBpaVTCWUDH1vcBq2SL3k1gM8BWEgi4jbOwtlTIoKarwj
	I5a65l1NNAAqXRptXkORmVprciclbyU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gkEQT5TI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784785277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eJEZNn3400d095D6oCSLmu9xMdDYVwKtFn+01ufgD64=;
	b=gkEQT5TIPYnv7scLMj424Pn1ENUmg+uL2loCmB9JLPxGt70FWX+yIkbUyNFbKBCJV6JF/+
	VZY6lBw0dIhdoYqzjbaaPG7iGIBpaVTCWUDH1vcBq2SL3k1gM8BWEgi4jbOwtlTIoKarwj
	I5a65l1NNAAqXRptXkORmVprciclbyU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6B61779C6;
	Thu, 23 Jul 2026 05:41:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9hQtHnypYWoQXQAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 23 Jul 2026 05:41:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH RFC] btrfs: disable direct IOs to avoid dirty folios without fs knowing
Date: Thu, 23 Jul 2026 15:10:54 +0930
Message-ID: <3c7926222aa6e35b7d6efd381550fe93241fd18e.1784785202.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: B422A3E38
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

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

As a hot fix, disable btrfs direct IOs for non-experimental builds for
now, so this can buy some time before we find out a proper way to address
this.

Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:
I'm not 100% sure if disabling direct IOs can fill all the holes.

We still allow mmapping page cache into user spaces, thus I'm not sure
if this is the only hole.
---
 fs/btrfs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 818c53c445f8..d458ab12e7f5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1420,6 +1420,11 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, struct iov_iter *from,
 	if (encoded && (iocb->ki_flags & IOCB_NOWAIT))
 		return -EOPNOTSUPP;
 
+#ifndef CONFIG_BTRFS_EXPERIMENTAL
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return -EOPNOTSUPP;
+#endif
+
 	if (encoded) {
 		num_written = btrfs_encoded_write(iocb, from, encoded);
 		num_sync = encoded->len;
@@ -3798,6 +3803,11 @@ static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (btrfs_is_shutdown(inode_to_fs_info(file_inode(iocb->ki_filp))))
 		return -EIO;
 
+#ifndef CONFIG_BTRFS_EXPERIMENTAL
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return -EOPNOTSUPP;
+#endif
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = btrfs_direct_read(iocb, to);
 		if (ret < 0 || !iov_iter_count(to) ||
-- 
2.54.0

