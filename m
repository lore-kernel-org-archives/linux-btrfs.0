Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C13BFAE0
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782745762; cv=none; b=iremvJPlSYW+3J3jgCFB/EgxRVmMKE/ZBKASawOFuY3aRfz2QA0WmJeBvzVeK9cPeo7Va5wD48xDemSjyABPnT214V5khVSIcqpKFqoUMXvey3NEvmUNkY4XR+MOuU6cfKR1BDYkPGxRp40Rsvr1ivImJ74GItP7QO6kLslXa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782745762; c=relaxed/simple;
	bh=xbrw9x1WsoLHW5NeooYMAdsqnFzaIdfB6xxsTj4kpw8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QSzKFZcllviY6GUqkvkTGOAV1a8E0qWycMGDJfdpNn20Apv1noTPlJJP6pwGGg6K88V97NPFoNqDoPDuWkf8T/WzBLc9KriVXPQgEojqo2zUIUhi4Ax8uYxwapW51lGTwLcioHXtZj3vEtOMp7DmhyYY7MHN0jp++Y/fcMMS344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=St4HRg/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="St4HRg/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA321F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745761;
	bh=MY05w2wUcl3+tHVtndrgqxZtXJ5kdtxrPXb+au674h8=;
	h=From:To:Subject:Date;
	b=St4HRg/EP8FH4Jv0v+mKGK0uCqC+9jc7S2LeNCmCEsdqDwLj5eCJaj4pVzwSAHkPC
	 hYxSjoaumNiMGDKWAsgb1QQBP7z0SChsPbGswxGtMOkiAqBa9kib423y+f5V8l2t/v
	 D65KQk+rw8dEmIAj7iZXAnN7Zqp5lBAeRUMaZfQFONsfXaXL2umsnJ9olKpsFhV0DN
	 wEkDP9EQ9y2WuZi1T6A8kwkj473YXJY40ERuMS3Yj8qyapRoQSu6w3xntDrXpq4lIV
	 VfvEACoaxjPPz/cdZGyIffm6tUcFMqsXkFCuCXlqCEdHk+iAezGj67Z0/m7cjAkYI+
	 z4bICHf4/GPxA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix NULL pointer deref during assertion in btrfs_backref_free_node()
Date: Mon, 29 Jun 2026 16:09:17 +0100
Message-ID: <8bc196601d6cd471a97a175a3f328425e1efc62f.1782745731.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In btrfs_backref_free_node() we have the following assertion:

  ASSERT(node->eb == NULL, "node->eb->start=%llu", node->eb->start);

and a user reported the following crash:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  CPU: 0 UID: 0 PID: 10422 Comm: syz.0.17 Not tainted 7.1.0-02765-g6b5a2b7d9bc1-dirty #44 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  RIP: 0010:btrfs_backref_free_node fs/btrfs/backref.c:3057 [inline]
  RIP: 0010:btrfs_backref_free_node+0xb9/0x200 fs/btrfs/backref.c:3051
  Code: 00 fc ff (...)
  RSP: 0018:ffa0000006b0f3c0 EFLAGS: 00010246
  RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff840eb78b
  RDX: 0000000000000000 RSI: ffffffff840eafa5 RDI: ff110000742ab768
  RBP: ff110000742ab700 R08: 0000000000000000 R09: 0000000000000000
  R10: ff110000742ab700 R11: 00000000000a81f9 R12: ff11000107a92020
  R13: ff1100005c182ea8 R14: 0000000000000000 R15: dffffc0000000000
  FS:  0000555575536500(0000) GS:ff11000183985000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fa3d0e9d580 CR3: 000000002232a000 CR4: 0000000000753ef0
  PKRU: 00000000
  Call Trace:
   <TASK>
   btrfs_backref_cleanup_node+0x27/0x30 fs/btrfs/backref.c:3133
   relocate_tree_block fs/btrfs/relocation.c:2604 [inline]
   relocate_tree_blocks+0x11b0/0x1a20 fs/btrfs/relocation.c:2707
   relocate_block_group+0x499/0xf30 fs/btrfs/relocation.c:3635
   do_nonremap_reloc fs/btrfs/relocation.c:5323 [inline]
   btrfs_relocate_block_group+0x1749/0x5fb0 fs/btrfs/relocation.c:5490
   btrfs_relocate_chunk+0x12b/0x950 fs/btrfs/volumes.c:3647
   __btrfs_balance fs/btrfs/volumes.c:4586 [inline]
   btrfs_balance+0x1c7f/0x55c0 fs/btrfs/volumes.c:4973
   btrfs_ioctl_balance fs/btrfs/ioctl.c:3474 [inline]
   btrfs_ioctl+0x38a4/0x5d20 fs/btrfs/ioctl.c:5570
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:597 [inline]
   __se_sys_ioctl fs/ioctl.c:583 [inline]
   __x64_sys_ioctl+0x18f/0x210 fs/ioctl.c:583
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x11f/0x860 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   RIP: 0033:0x7fb38e3b56dd
   Code: 02 b8 ff (...)
   RSP: 002b:00007fff04115788 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
   RAX: ffffffffffffffda RBX: 00007fb38f6b0020 RCX: 00007fb38e3b56dd
   RDX: 00002000000003c0 RSI: 00000000c4009420 RDI: 0000000000000004
   RBP: 00007fb38e451b48 R08: 0000000000000000 R09: 0000000000000000
   R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
   R13: 0000000000000000 R14: 00007fb38f6b0020 R15: 00007fb38f6b002c
   </TASK>

It seems that this happens on some systems for some reason, when the
ASSERT() macro calls the inline function verify_assert_printk_format()
to evaluate the format string and arguments, causing the NULL pointer
dereference on node->eb.

So change the assertion to check for a NULL node->eb before dereferencing
it. Also, while at it, make the assertion more useful by printing the
owner of the extent buffer as well as its level.

Reported-by: Yue Sun <samsun1006219@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/20260626065542.38413-1-samsun1006219@gmail.com/
Fixes: c4e7778580d6 ("btrfs: use verbose assertions in backref.c")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/backref.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 23c3eeb58dc1..1be632c742bd 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3054,7 +3054,10 @@ void btrfs_backref_free_node(struct btrfs_backref_cache *cache,
 	if (node) {
 		ASSERT(list_empty(&node->list));
 		ASSERT(list_empty(&node->lower));
-		ASSERT(node->eb == NULL, "node->eb->start=%llu", node->eb->start);
+		ASSERT(node->eb == NULL, "node->eb->start=%llu level=%d owner=%llu",
+		       node->eb ? node->eb->start : 0,
+		       node->eb ? btrfs_header_level(node->eb) : 0,
+		       node->eb ? btrfs_header_owner(node->eb) : 0);
 		cache->nr_nodes--;
 		btrfs_put_root(node->root);
 		kfree(node);
-- 
2.47.2

