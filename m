Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55218 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2LORJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 12:09:09 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so4624652oag.19
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 09:09:08 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 15 Dec 2012 11:09:08 -0600
Message-ID: <CAKcLGm9Dui+WiChx72ft2O4RQhq0vNibuMz8uHPBjsw9QK2ZQA@mail.gmail.com>
Subject: Kernel lockdep WARNING on btrfs-next
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been testing Josef's btrfs-next master branch using a test that
loops through creation, manipulation and destruction of snapshots of
kernel git sources.

The version of btrfs-next I'm using was built as of Friday, December
14th, and the top commit is:
Btrfs: don't take inode delalloc mutex if we're a free space inode
committer	Josef Bacik <jbacik@fusionio.com>	
	Fri, 14 Dec 2012 21:57:39 +0000 (16:57 -0500)
commit	bd2dd0060cf0ae2a81a7b22e9cc23063796fe09c

I've hit a WARN_ON at kernel/lockdep.c:702, which is in the
look_up_lock_class(...) function

	/*
	 * We can walk the hash lockfree, because the hash only
	 * grows, and we are careful when adding entries to the end:
	 */
	list_for_each_entry(class, hash_head, hash_entry) {
		if (class->key == key) {
			/*
			 * Huh! same key, different name? Did someone trample
			 * on some memory? We're most confused.
			 */
Line 702>	WARN_ON_ONCE(class->name != lock->name);
			return class;
		}
	}

It looks like this occurred during the delayed deletion of one of the
subvolumes.

As far as I can tell, no corruption occurred, the file system passes
btrfsck checks, and seems to be otherwise behaving normally.

I was not on the system at the time this occurred, so I can't say if
it noticeably delayed the system.

[ 5260.068074] ------------[ cut here ]------------
[ 5260.068092] WARNING: at kernel/lockdep.c:702
__lock_acquire.isra.29+0xa44/0xab9()
[ 5260.068096] Hardware name: OptiPlex 745
[ 5260.068099] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[ 5260.068124] Pid: 3801, comm: btrfs-cleaner Not tainted 3.7.0-btrfs-next+ #2
[ 5260.068128] Call Trace:
[ 5260.068139]  [<ffffffff8103663a>] warn_slowpath_common+0x74/0xa2
[ 5260.068172]  [<ffffffffa0062805>] ? btrfs_tree_read_unlock+0x7d/0xa9 [btrfs]
[ 5260.068179]  [<ffffffff81036682>] warn_slowpath_null+0x1a/0x1c
[ 5260.068185]  [<ffffffff81084813>] __lock_acquire.isra.29+0xa44/0xab9
[ 5260.068210]  [<ffffffffa0062483>] ? btrfs_tree_lock+0xf7/0x24c [btrfs]
[ 5260.068217]  [<ffffffff81084d8e>] lock_acquire+0x81/0xff
[ 5260.068241]  [<ffffffffa0062483>] ? btrfs_tree_lock+0xf7/0x24c [btrfs]
[ 5260.068248]  [<ffffffff8183d7b5>] _raw_write_lock+0x31/0x40
[ 5260.068271]  [<ffffffffa0062483>] ? btrfs_tree_lock+0xf7/0x24c [btrfs]
[ 5260.068295]  [<ffffffffa0062483>] btrfs_tree_lock+0xf7/0x24c [btrfs]
[ 5260.068319]  [<ffffffffa004eb1d>] ? find_extent_buffer+0x8f/0xd6 [btrfs]
[ 5260.068343]  [<ffffffffa004eaa4>] ? find_extent_buffer+0x16/0xd6 [btrfs]
[ 5260.068360]  [<ffffffffa001ef79>] do_walk_down+0xd2/0x4b6 [btrfs]
[ 5260.068378]  [<ffffffffa001e1ae>] ? btrfs_block_rsv_check+0x29/0x7d [btrfs]
[ 5260.068394]  [<ffffffffa001e1ae>] ? btrfs_block_rsv_check+0x29/0x7d [btrfs]
[ 5260.068411]  [<ffffffffa001f420>] walk_down_tree+0xc3/0xef [btrfs]
[ 5260.068430]  [<ffffffffa0021f4f>] btrfs_drop_snapshot+0x372/0x5c7 [btrfs]
[ 5260.068451]  [<ffffffffa0033ccc>]
btrfs_clean_old_snapshots+0xa6/0x13a [btrfs]
[ 5260.068471]  [<ffffffffa002b1c0>] ? cleaner_kthread+0x8d/0x102 [btrfs]
[ 5260.068490]  [<ffffffffa002b1d4>] cleaner_kthread+0xa1/0x102 [btrfs]
[ 5260.068509]  [<ffffffffa002b133>] ? btree_invalidatepage+0x73/0x73 [btrfs]
[ 5260.068515]  [<ffffffff81058333>] kthread+0xea/0xef
[ 5260.068522]  [<ffffffff81058249>] ? flush_kthread_work+0x19c/0x19c
[ 5260.068528]  [<ffffffff8184549c>] ret_from_fork+0x7c/0xb0
[ 5260.068534]  [<ffffffff81058249>] ? flush_kthread_work+0x19c/0x19c
[ 5260.068538] ---[ end trace 0caa5c9123c1e741 ]---
