Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB431B4F0A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440812; cv=none; b=YFq4y2DKXoCYyxlWLtnPp6azg34TXT77jRJMfd2oY8upXkQLsKmdJa+WljqG76jTl9CaH5z8KlVsUyyKuqkfPyCjQZU2AkTXprFIdcw7Yofm6Cawh6puq+D40NrkMfzW7pN7NTEOfNULLiZJZMB1WQVT0CwZi/Dm/SN4gn/vSCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440812; c=relaxed/simple;
	bh=u6m8vm9cgwiBEbRq7Q70Reiu56drLkk70rOA8ai/Uno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IttiwchuUteM3grUmAFUqxBIU07E4GSZLT5wO/JZ/YivAti5MfOoKrpomV6etxnG8oC+leLsxCbDHqlpSXtUpPixoY1iBmeTWtI58yu10Lqt0yHTxP0boSh4NBR+T49Ar0iJGqlsBycs91Np63wF11ID+ai+H/vTVqMza4c+p/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QUkChWDr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QUkChWDr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QUkChWDr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QUkChWDr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2FCC21BE0;
	Thu,  8 Oct 2026 06:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5w2TTk6My9aAbjNxT0/bz/BS0jzS4iPSHIAMkTUZV7Y=;
	b=QUkChWDrCQAy/Jk93MdOMuXTSBuKBv9BoHrtJKel+gsfOVoyrqoADq+USyPPBOL8fP5c5J
	YUKvADQW2dRy5WJxEIzQspZI7vMJSiSGuJBJVMY5zmNktxEtWgydavfIDlDAnYrEbbEjSz
	utU17XuGfIUn3Xh32ckOUxfEebP1Oww=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5w2TTk6My9aAbjNxT0/bz/BS0jzS4iPSHIAMkTUZV7Y=;
	b=QUkChWDrCQAy/Jk93MdOMuXTSBuKBv9BoHrtJKel+gsfOVoyrqoADq+USyPPBOL8fP5c5J
	YUKvADQW2dRy5WJxEIzQspZI7vMJSiSGuJBJVMY5zmNktxEtWgydavfIDlDAnYrEbbEjSz
	utU17XuGfIUn3Xh32ckOUxfEebP1Oww=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0CCC1339F;
	Thu,  8 Oct 2026 06:26:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fq1+HqE3x2q6OAAAD6G6ig:T4
	(envelope-from <wqu@suse.com>); Thu, 08 Oct 2026 06:26:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
Subject: [PATCH v2 3/3] btrfs: unlink btrfs_root::dirty_list during btrfs_put_root()
Date: Thu,  8 Oct 2026 16:56:23 +1030
Message-ID: <ac7b24565005b7aef5c0db8d6dc6c3bf499b6990.1791439852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791439852.git.wqu@suse.com>
References: <cover.1791439852.git.wqu@suse.com>
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
	TAGGED_RCPT(0.00)[947286c775f432b073a8];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,gmail.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
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
quota_root structure to be released, while leaving
fs_info->dirty_cowonly_roots still pointing to the released
quota_root->dirty_list.

Later access through fs_info->dirty_cowonly_roots will trigger a
use-after-free bug.

[FIX]
With previous patches doing the preparation work:

- Always hold the trans_lock when modifying btrfs_root::dirty_list
- Unlink all btrfs_root::dirty_list entries from
  btrfs_transaction::switch_commits when a transaction is cleaned up

Now we can just call list_del_init(&root->dirty_list) with proper locking
inside btrfs_put_root().

Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6ac5a5e1.9ad129c8.3ce5b3.0010.GAE@google.com/
Suggested-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c         | 10 ++++++++--
 fs/btrfs/free-space-tree.c |  4 ----
 fs/btrfs/qgroup.c          |  4 ----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 757db0c363b0..7531ebd61e8d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1840,6 +1840,12 @@ void btrfs_put_root(struct btrfs_root *root)
 		return;
 
 	if (refcount_dec_and_test(&root->refs)) {
+		struct btrfs_fs_info *fs_info = root->fs_info;
+
+		spin_lock(&fs_info->trans_lock);
+		list_del_init(&root->dirty_list);
+		spin_unlock(&fs_info->trans_lock);
+
 		if (WARN_ON(!xa_empty(&root->inodes)))
 			xa_destroy(&root->inodes);
 		if (WARN_ON(!xa_empty(&root->delayed_nodes)))
@@ -1849,9 +1855,9 @@ void btrfs_put_root(struct btrfs_root *root)
 			free_anon_bdev(root->anon_dev);
 		free_root_extent_buffers(root);
 #ifdef CONFIG_BTRFS_DEBUG
-		spin_lock(&root->fs_info->fs_roots_radix_lock);
+		spin_lock(&fs_info->fs_roots_radix_lock);
 		list_del_init(&root->leak_list);
-		spin_unlock(&root->fs_info->fs_roots_radix_lock);
+		spin_unlock(&fs_info->fs_roots_radix_lock);
 #endif
 		kfree(root);
 	}
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

