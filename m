Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4F725A655
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791410907; cv=none; b=hvAuw61Xi5acpbftyRbOkyuLSn4Lfi2hl2RRM/wYd1weCGeIjtnG5zX0gDFm2geCeABfCW/7myTfesbJO3C8sYVO2AIhyd1WbQTKgoJ4o2uv3FByC8BwV50wdmc3YSls2ZyT6zZd72dc6eNHosMR3DsEhEQfQMgUPPKDA4GhgcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791410907; c=relaxed/simple;
	bh=Fi5Vo/o8Yqih+A/tNqa8cU/LOJ//NbxLpHCVNdsI6kI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UYx8wTyzYkvL4zEeAtBQYyv5TVItLWNoHh9rEFGvLeH6FuNAFAo04oVNmAWCDuRGKV05nRJ+WhoUubfZFMzOdmzVH7/dz2kDJ6+nuq4m+/VRo3AIwZjxC/S7o6urbr2PD+3/2Jfvcm3kE2yAAzjmumZ/fbje5bTmHv8d5ZkHbZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sixHZWIY; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eUjcQDXn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sixHZWIY";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eUjcQDXn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F3B121B73;
	Wed,  7 Oct 2026 22:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791410903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NwuH+adrERFKTiuupe5EE6Kp3vknOo2Wna7YWpU9zbg=;
	b=sixHZWIYKjImoxkJc0QD/AliQz6F1V20Q6ZklTpaxltThLhkpzJaCFTXiGzKCmHU0DRi17
	4BpLjT5B6c5rGwk9LM84tT/oGFiP66TaT2tneps70TUkZq5+D28E1sDggzyMt7sC2a1ObA
	OfXJDPPHWxoAslB2zm8gBxuHLHLmkd8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791410902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NwuH+adrERFKTiuupe5EE6Kp3vknOo2Wna7YWpU9zbg=;
	b=eUjcQDXnXYNYbH2sGcxxp295b/isolbU+2e8ToeHSKtljcLn4nGjGt2AsPhhZmTMYV7U9B
	xyIFNwqC4z1nyPWSLbZqpHjWHLCcBjE9Pvt2eDVJEXaRUfpSTjjdKIth6GYvLv3DoqGkCg
	0PZydearUV3xlR5NtMcQw5Vc8MltK5c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 154EB13312;
	Wed,  7 Oct 2026 22:08:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 05Y8EdPCxmq3MwAAD6G6ig
	(envelope-from <wqu@suse.com>); Wed, 07 Oct 2026 22:08:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
Subject: [PATCH] btrfs: unlink btrfs_root::dirty_list during btrfs_put_root()
Date: Thu,  8 Oct 2026 08:38:00 +1030
Message-ID: <cc366881387ac1f041d3b3a5b06eedd666b7c4c0.1791410825.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[947286c775f432b073a8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

[BUG]
There is a syzbot report that a use-after-free bug is triggered after a
failed btrfs_quota_enable():

 loop0: detected capacity change from 32768 to 0
 ==================================================================
 BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
 Read of size 8 at addr ffff888040e0a528 by task syz.0.0/5324

 CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
  print_report+0x58/0x70 mm/kasan/report.c:482
  kasan_report+0x117/0x150 mm/kasan/report.c:595
  __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
  __list_add_valid include/linux/list.h:104 [inline]
  __list_add include/linux/list.h:169 [inline]
  list_add include/linux/list.h:192 [inline]
  list_move include/linux/list.h:345 [inline]
  add_root_to_dirty_list+0x38b/0x470 fs/btrfs/ctree.c:232
  btrfs_force_cow_block+0xf09/0x1bf0 fs/btrfs/ctree.c:553
  btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
  btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
  btrfs_search_prev_slot fs/btrfs/free-space-tree.c:134 [inline]
  remove_free_space_extent fs/btrfs/free-space-tree.c:732 [inline]
  __btrfs_remove_from_free_space_tree fs/btrfs/free-space-tree.c:837 [inline]
  btrfs_remove_from_free_space_tree+0x4d6/0xda0 fs/btrfs/free-space-tree.c:866
  alloc_reserved_extent+0x4a/0x2b0 fs/btrfs/extent-tree.c:4976
  alloc_reserved_tree_block fs/btrfs/extent-tree.c:5155 [inline]
  run_delayed_tree_ref fs/btrfs/extent-tree.c:1815 [inline]
  run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
  btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
  __btrfs_run_delayed_refs+0x18b5/0x43b0 fs/btrfs/extent-tree.c:2134
  btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
  btrfs_commit_transaction+0x28a/0x3170 fs/btrfs/transaction.c:2267
  sync_filesystem+0x1d2/0x240 fs/sync.c:66
  btrfs_reconfigure+0x2dc/0x2100 fs/btrfs/super.c:1511
  reconfigure_super+0x232/0x8f0 fs/super.c:1128
  do_remount fs/namespace.c:3410 [inline]
  path_mount+0xd4e/0x1050 fs/namespace.c:4160
  do_mount fs/namespace.c:4181 [inline]
  __do_sys_mount fs/namespace.c:4397 [inline]
  __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 RIP: 0033:0x7f9c8dd9f3ca
  </TASK>

 Allocated by task 5323:
  kasan_save_stack mm/kasan/common.c:57 [inline]
  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
  poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
  kasan_kmalloc include/linux/kasan.h:263 [inline]
  __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
  _kmalloc_noprof include/linux/slab.h:991 [inline]
  _kzalloc_noprof include/linux/slab.h:1312 [inline]
  btrfs_alloc_root+0x75/0x840 fs/btrfs/disk-io.c:638
  btrfs_create_tree+0xa8/0x5c0 fs/btrfs/disk-io.c:832
  btrfs_quota_enable+0x3d6/0x1e20 fs/btrfs/qgroup.c:1074
  btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:597 [inline]
  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

 Freed by task 5323:
  kasan_save_stack mm/kasan/common.c:57 [inline]
  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
  poison_slab_object mm/kasan/common.c:264 [inline]
  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
  kasan_slab_free include/linux/kasan.h:235 [inline]
  slab_free_hook mm/slub.c:2748 [inline]
  slab_free mm/slub.c:6508 [inline]
  kfree+0x1c5/0x650 mm/slub.c:6801
  btrfs_quota_enable+0x1208/0x1e20 fs/btrfs/qgroup.c:1292
  btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:597 [inline]
  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

[CAUSE]
During btrfs_quota_enable(), a temporary quota_root is created, then
qgroup items are created for each subvolume and inserted into that root.

If there are enough subvolumes, the level of quota_root will be bumped,
and add_root_to_dirty_list() will be called, adding
quota_root->dirty_list into fs_info->dirty_cowonly_roots.

But if a problem is hit during btrfs_quota_enable() later, that
quota_root will be released through btrfs_put_root(), causing the whole
quota_root structure to be released, meanwhile leaving the
dirty_cowonly_roots still pointing to the released quota_root->dirty_list.

Later access through fs_info->dirty_cowonly_roots will trigger a
use-after-free bug.

[FIX]
Call list_del_init(&root->dirty_list) with proper locking inside
btrfs_put_root().

root->dirty_list has two usages:

- Added to fs_info->dirty_cowonly_roots
- Added to cur_trans->switch_commits during transaction commit

For most cases, a root is only released during unmount, and at that time
all roots should have been committed, thus root->dirty_list is just an
empty list, and this won't cause any difference.

The following call sites remove a root from the filesystem. The latter
two already delete dirty_list manually:

- btrfs_quota_enable() failure path
- btrfs_quota_disable()
- btrfs_delete_free_space_tree()

Those call sites are all holding a trans handle, thus no transaction
can be committed at that time. So dirty_list will not be added to
switch_commits.

Thus we are safe to call list_del_init() inside btrfs_put_root(), with
trans_lock held.

Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6ac5a5e1.9ad129c8.3ce5b3.0010.GAE@google.com/
Suggested-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c         | 13 +++++++++++++
 fs/btrfs/free-space-tree.c |  4 ----
 fs/btrfs/qgroup.c          |  4 ----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 66b054eb98c6..2a045f52e637 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1840,6 +1840,19 @@ void btrfs_put_root(struct btrfs_root *root)
 		return;
 
 	if (refcount_dec_and_test(&root->refs)) {
+		/*
+		 * root->dirty_list can be linked into either
+		 * fs_info->dirty_cowonly_roots or, during a transaction
+		 * commit, cur_trans->switch_commits.
+		 *
+		 * All callers removing a root from the fs should hold a
+		 * trans handle, so no transaction can be committing and the
+		 * root can only be on fs_info->dirty_cowonly_roots.
+		 */
+		spin_lock(&root->fs_info->trans_lock);
+		list_del_init(&root->dirty_list);
+		spin_unlock(&root->fs_info->trans_lock);
+
 		if (WARN_ON(!xa_empty(&root->inodes)))
 			xa_destroy(&root->inodes);
 		if (WARN_ON(!xa_empty(&root->delayed_nodes)))
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index b7a4a6ade30f..3660577c286e 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1311,10 +1311,6 @@ int btrfs_delete_free_space_tree(struct btrfs_fs_info *fs_info)
 
 	btrfs_global_root_delete(free_space_root);
 
-	spin_lock(&fs_info->trans_lock);
-	list_del(&free_space_root->dirty_list);
-	spin_unlock(&fs_info->trans_lock);
-
 	btrfs_tree_lock(free_space_root->node);
 	btrfs_clear_buffer_dirty(trans, free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cf8dfd5c692b..38a268b63991 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1433,10 +1433,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		goto out;
 	}
 
-	spin_lock(&fs_info->trans_lock);
-	list_del(&quota_root->dirty_list);
-	spin_unlock(&fs_info->trans_lock);
-
 	btrfs_tree_lock(quota_root->node);
 	btrfs_clear_buffer_dirty(trans, quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
-- 
2.55.0

