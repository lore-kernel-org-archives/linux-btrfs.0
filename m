Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6B63C2796
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788819496; cv=none; b=RVpUxgcP2cRRqh7iTqhm0hyiQ4Y5a6Bc/bogHivPs2eF5m/JegxvusW29tDhxFXgIMl6V34V7+sIMjvlZzULwiuEUF9xwdG1TnJ69sha7NLY0i4kfWI5IPA8+TkyJmUYohKtN8gEpg66ScRSNBNgrxlwP/A36FBXEpUHtI7P5Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788819496; c=relaxed/simple;
	bh=CwJ79c/dwW3d8uK9M74m/YMaEbFFBrKH5TcpawdpXFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1MKHO+R336uq5lFDjkMhP13tZss9CAEIaHSZwfdjl5v+JkGi1Mtj/ha8fapbddaCJzNuVNdMFUwgyZwfyez4+17DRkzDrho3LtwOkMriaA6fe/EJ10oCtEsXCwS5VbwXvZvWIoQmtDjkmDhMzLrL5PbWTENdPTEoi1Sm75ujoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fwidreoc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ee+ZooPW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fwidreoc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ee+ZooPW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 39601219CE;
	Mon,  7 Sep 2026 22:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788819487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=q2EJ0PaxhiIybrAFvksmM+o/FU6w5vBG7UnF7OsgnrY=;
	b=FwidreocKHU8Zkw8lG/5yXYLhMcs06VAF/F/BU/lHuj5FlbUfrd9f9lm7fIOOLyQAqvqiL
	PC6zxmOGHDstzzWjRfqXd/g1ko2Lh89uqyAQVFacejlToVdTcLoZTbXlrn4NXNP/g5n6Ky
	oteVMnR4Dyr37dAxbX7MhnIA5EKCLZo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788819483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=q2EJ0PaxhiIybrAFvksmM+o/FU6w5vBG7UnF7OsgnrY=;
	b=Ee+ZooPW0vWd5VHylbVZ9CKrdunXrVF9USlIJZchn8/QALzrhaldbUO+68AhoWuza954nM
	PCv9vIZDZ57+XZZgllwmL85imOgLpN7ZZ+VofXuyvB4qQm3oCBuYEihmE3UbPFtWr4UCu/
	0Zwr/0Q3JOJ5A1nSodgBMijlYMc8zx0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD9781339B;
	Mon,  7 Sep 2026 22:18:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1MgnHxk4n2pGYQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 07 Sep 2026 22:18:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
Subject: [PATCH] btrfs: use kvmalloc() for split_item()
Date: Tue,  8 Sep 2026 07:47:39 +0930
Message-ID: <2ab022c5c7e07345a9fc91915836cbd4ab2d25ef.1788819456.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[protonmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,protonmail.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[protonmail.com]

[BUG]
There is a bug report that the kmalloc() call inside split_item() failed
with the following call trace, and triggered a transaction abort:

 kworker/u69:8: page allocation failure: order:4, mode:0x40c40(GFP_NOFS|__GFP_COMP), nodemask=(null)
 CPU: 3 UID: 0 PID: 1154528 Comm: kworker/u69:8 Not tainted 7.0.2 #1 PREEMPTLAZY
 Workqueue: events_unbound btrfs_async_reclaim_metadata_space
 Call Trace:
  <TASK>
  dump_stack_lvl+0x47/0x60
  warn_alloc.cold+0x67/0xec
  __alloc_pages_slowpath.constprop.0+0x9bf/0xed0
  __alloc_frozen_pages_noprof+0x1ac/0x1c0
  ___kmalloc_large_node+0x9d/0xc0
  __kmalloc_noprof+0x17b/0x1f0
  split_item+0x9e/0x2e0
  btrfs_del_csums+0x285/0x400
  __btrfs_free_extent.isra.0+0x6de/0x12b0
  __btrfs_run_delayed_refs+0x522/0x10c0
  btrfs_run_delayed_refs+0x4d/0x1d0
  flush_space+0x34d/0x4e0
  do_async_reclaim_metadata_space+0x89/0x1d0
  btrfs_async_reclaim_metadata_space+0x44/0x60
  process_one_work+0x145/0x230
  worker_thread+0x185/0x2e0
  kthread+0xca/0x100
  ret_from_fork+0x14e/0x200
  ret_from_fork_asm+0x11/0x20
  </TASK>
 BTRFS error (device dm-3 state A): Transaction aborted (error -12)
 BTRFS: error (device dm-3 state A) in btrfs_del_csums:1053: errno=-12 Out of memory
 BTRFS info (device dm-3 state EA): forced readonly
 BTRFS: error (device dm-3 state EA) in do_free_extent_accounting:3168: errno=-12 Out of memory
 BTRFS error (device dm-3 state EA): failed to run delayed ref for logical 1202913873920 num_bytes 274432 type 184 action 2 ref_mod 1: -12
 BTRFS: error (device dm-3 state EA) in btrfs_run_delayed_refs:2247: errno=-12 Out of memory

[CAUSE]
The kmalloc() call is to allocate a buffer to store the full item.
However as shown in the above call trace, the order can be high (4),
and since we're using GFP_NOFS, it's impossible to reclaim memory by
writing back dirty pages.

When there is no physically contiguous memory left, such high order
allocation can easily fail, and if such kmalloc() happens in a critical
path we can trigger a transaction abort.

[FIX]
Instead of kmalloc(), which requires physically contiguous pages, use
kvmalloc().

There is no special requirement for physically contiguous pages here, we
just want virtually contiguous memory as a buffer.

Reported-by: xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>
Link: https://lore.kernel.org/linux-btrfs/250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8fe330d81b8f..fef0e49dd918 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3943,7 +3943,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
 	orig_offset = btrfs_item_offset(leaf, path->slots[0]);
 	item_size = btrfs_item_size(leaf, path->slots[0]);
 
-	buf = kmalloc(item_size, GFP_NOFS);
+	buf = kvmalloc(item_size, GFP_NOFS);
 	if (!buf)
 		return -ENOMEM;
 
@@ -3981,7 +3981,7 @@ static noinline int split_item(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(trans, leaf);
 
 	BUG_ON(btrfs_leaf_free_space(leaf) < 0);
-	kfree(buf);
+	kvfree(buf);
 	return 0;
 }
 
-- 
2.55.0

