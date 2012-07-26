Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab2GZRet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jul 2012 13:34:49 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 0124E9D938
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2012 19:34:48 +0200 (CEST)
Date: Thu, 26 Jul 2012 19:34:46 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [next] kernel BUG at fs/btrfs/relocation.c:2331!
Message-ID: <20120726173446.GI29453@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while testing a branch that'll become the next pull or so, I've hit $subj crash.
(top commit: Chris Mason [cmason/next] Btrfs: uninit variable fixes in send/receive)

# btrfs fi df /mnt/sdc
Data: total=34.01GB, used=26.53GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=8.00GB, used=5.76GB
Metadata: total=8.00MB, used=0.00

# btrfs fi show
Label: none  uuid: 8d2b2e7f-0a7f-4ace-a265-3d6b48c95ace
        Total devices 1 FS bytes used 32.30GB
        devid    1 size 55.89GB used 50.04GB path /dev/sdc

# mount
/dev/sdc on /mnt/sdc type btrfs (rw,relatime,compress-force=lzo,space_cache,autodefrag,inode_cache)

There was an overnight snapshot stress test, running simultaneously:

* untar wikipedia dump (250G) to DIR
* rm DIR (looped)
* snapshot creation
* snapshot deletion

survived; there was one warning

 ------------[ cut here ]------------
 WARNING: at fs/btrfs/inode.c:2440 btrfs_orphan_cleanup+0xb6/0x450 [btrfs]()
 Hardware name: Santa Rosa platform
 Modules linked in: btrfs aoe loop
 Pid: 771, comm: btrfs Not tainted 3.5.0-default+ #163
 Call Trace:
  [<ffffffff8104243f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8104249a>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa00577b6>] btrfs_orphan_cleanup+0xb6/0x450 [btrfs]
  [<ffffffff8136989e>] ? do_raw_spin_unlock+0x5e/0xb0
  [<ffffffffa00787b7>] btrfs_mksubvol+0x2d7/0x350 [btrfs]
  [<ffffffffa007892a>] btrfs_ioctl_snap_create_transid+0xfa/0x190 [btrfs]
  [<ffffffff8111f65c>] ? might_fault+0x9c/0xb0
  [<ffffffff8111f613>] ? might_fault+0x53/0xb0
  [<ffffffffa0078b46>] btrfs_ioctl_snap_create_v2+0x106/0x140 [btrfs]
  [<ffffffffa007a868>] btrfs_ioctl+0x558/0x19d0 [btrfs]
  [<ffffffff8106e0f3>] ? up_read+0x23/0x40
  [<ffffffff818d4080>] ? do_page_fault+0x2d0/0x580
  [<ffffffff81187b1d>] ? fsnotify+0x8d/0x330
  [<ffffffff8115a238>] do_vfs_ioctl+0x98/0x560
  [<ffffffff81099de9>] ? trace_hardirqs_off_caller+0x29/0xc0
  [<ffffffff818d0395>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8115a74f>] sys_ioctl+0x4f/0x80
  [<ffffffff818d8869>] system_call_fastpath+0x16/0x1b
 ---[ end trace 2aefcc77a6ab3bf5 ]---
 btrfs: Error removing orphan entry, stopping orphan cleanup
 btrfs: could not do orphan cleanup -22

--

some hours later, I stopped the stress load, deleted a few snapshots manually, current count is 50+. Started scrub, started balance, cancelled scrub (ok), left balance run.

syslog messages from balance:

[132057.002633] btrfs: relocating block group 44052774912 flags 1
[132057.824512] btrfs: relocating block group 42979033088 flags 1
[132058.849141] btrfs: relocating block group 41905291264 flags 1
[132059.582795] btrfs: relocating block group 40831549440 flags 1
[132060.272957] btrfs: relocating block group 39757807616 flags 1
[132060.983105] btrfs: relocating block group 38684065792 flags 36

After minutes, there were lots of messages followed by a crash:

[133083.028677] btrfs: block rsv returned -28
[133083.028678] ------------[ cut here ]------------
[133083.028688] WARNING: at fs/btrfs/extent-tree.c:6330 btrfs_alloc_free_block+0x367/0x380 [btrfs]()
[133083.028689] Hardware name: Santa Rosa platform
[133083.028694] Pid: 12650, comm: btrfs Tainted: G        W    3.5.0-default+ #163
[133083.028694] Call Trace:
[133083.028695]  [<ffffffff8104243f>] warn_slowpath_common+0x7f/0xc0
[133083.028698]  [<ffffffff8104249a>] warn_slowpath_null+0x1a/0x20
[133083.028700]  [<ffffffffa003a977>] btrfs_alloc_free_block+0x367/0x380 [btrfs]
[133083.028710]  [<ffffffffa0069cf3>] ? read_extent_buffer+0xd3/0x130 [btrfs]
[133083.028723]  [<ffffffffa007c231>] ? btrfs_tree_lock+0x131/0x290 [btrfs]
[133083.028737]  [<ffffffffa00251c4>] __btrfs_cow_block+0x134/0x560 [btrfs]
[133083.028745]  [<ffffffffa00256fa>] btrfs_cow_block+0x10a/0x220 [btrfs]
[133083.028753]  [<ffffffffa008e37f>] do_relocation+0x49f/0x590 [btrfs]
[133083.028767]  [<ffffffffa002e629>] ? block_rsv_add_bytes+0x59/0x80 [btrfs]
[133083.028776]  [<ffffffffa00921fe>] relocate_tree_blocks+0x48e/0x690 [btrfs]
[133083.028789]  [<ffffffffa008c3a4>] ? tree_insert+0x54/0x60 [btrfs]
[133083.028802]  [<ffffffffa0090082>] ? add_tree_block+0xe2/0x180 [btrfs]
[133083.028815]  [<ffffffffa009327b>] relocate_block_group+0x1cb/0x630 [btrfs]
[133083.028828]  [<ffffffffa0093890>] btrfs_relocate_block_group+0x1b0/0x2e0 [btrfs]
[133083.028841]  [<ffffffffa006c497>] btrfs_relocate_chunk+0x87/0x750 [btrfs]
[133083.028854]  [<ffffffffa0068aaf>] ? free_extent_buffer+0x1f/0x90 [btrfs]
[133083.028868]  [<ffffffff8136989e>] ? do_raw_spin_unlock+0x5e/0xb0
[133083.028870]  [<ffffffff818cfb8b>] ? _raw_spin_unlock+0x2b/0x50
[133083.028873]  [<ffffffffa0062b19>] ? release_extent_buffer+0xb9/0xe0 [btrfs]
[133083.028886]  [<ffffffffa0068aaf>] ? free_extent_buffer+0x1f/0x90 [btrfs]
[133083.028899]  [<ffffffffa0068acc>] ? free_extent_buffer+0x3c/0x90 [btrfs]
[133083.028912]  [<ffffffffa0070ab2>] btrfs_balance+0x812/0xcb0 [btrfs]
[133083.028926]  [<ffffffffa0078cb4>] btrfs_ioctl_balance+0x134/0x260 [btrfs]
[133083.028939]  [<ffffffffa007ab54>] btrfs_ioctl+0x844/0x19d0 [btrfs]
[133083.028952]  [<ffffffff8106e0f3>] ? up_read+0x23/0x40
[133083.028954]  [<ffffffff818d4080>] ? do_page_fault+0x2d0/0x580
[133083.028957]  [<ffffffff8115a238>] do_vfs_ioctl+0x98/0x560
[133083.028959]  [<ffffffff81099de9>] ? trace_hardirqs_off_caller+0x29/0xc0
[133083.028962]  [<ffffffff818d0395>] ? retint_swapgs+0x13/0x1b
[133083.028965]  [<ffffffff8115a74f>] sys_ioctl+0x4f/0x80
[133083.028967]  [<ffffffff818d8869>] system_call_fastpath+0x16/0x1b
[133083.028970] ---[ end trace 2aefcc77a6ab3c93 ]---

and the crash came in a quick sequence after the last one:

133088.565484] ------------[ cut here ]------------
[133088.569072] kernel BUG at fs/btrfs/relocation.c:2331!
[133088.569072] invalid opcode: 0000 [#1] SMP
[133088.569072] CPU 1
[133088.569072] Modules linked in:[133088.569072]  btrfs aoe loop

[133088.569072] Pid: 12650, comm: btrfs Tainted: G        W    3.5.0-default+ #163 Intel Corporation Santa Rosa platform/Matanzas
[133088.569072] RIP: 0010:[<ffffffffa008d4c8>]  [<ffffffffa008d4c8>] select_reloc_root+0x1d8/0x1f0 [btrfs]
[133088.569072] RSP: 0018:ffff8800174b9898  EFLAGS: 00010246
[133088.569072] RAX: ffff8800457b92a8 RBX: ffff8800152df478 RCX: ffff8800457b92e8
[133088.569072] RDX: ffff8800457b92a8 RSI: ffff8800174b9948 RDI: 0000000000000000
[133088.569072] RBP: ffff8800174b98e8 R08: ffff8800457b92e8 R09: ffff8800044f9338
[133088.569072] R10: 09f911029d74e35b R11: 0000000000000000 R12: ffff8800457b92a8
[133088.569072] R13: ffff88001e3e28b8 R14: ffff8800174b9948 R15: 0000000000000000
[133088.569072] FS:  00007fe134440740(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
[133088.569072] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[133088.569072] CR2: 00007f6dc37ff000 CR3: 00000000512ec000 CR4: 00000000000007e0
[133088.569072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[133088.569072] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[133088.569072] Process btrfs (pid: 12650, threadinfo ffff8800174b8000, task ffff88004afe1300)
[133088.569072] Stack:
[133088.569072]  ffff880000000000 ffff8800174b9994 0000160000000000 000000001fc4c740
[133088.569072]  ffff880000000000 ffff8800457b92a8 ffff880078391430 0000000000000000
[133088.569072]  ffff880017a029d8 0000000901e5f000 ffff8800174b99c8 ffffffffa008e15d
[133088.569072] Call Trace:
[133088.569072]  [<ffffffffa008e15d>] do_relocation+0x27d/0x590 [btrfs]
[133088.569072]  [<ffffffffa002e629>] ? block_rsv_add_bytes+0x59/0x80 [btrfs]
[133088.569072]  [<ffffffffa00921fe>] relocate_tree_blocks+0x48e/0x690 [btrfs]
[133088.569072]  [<ffffffffa008c3a4>] ? tree_insert+0x54/0x60 [btrfs]
[133088.569072]  [<ffffffffa0090082>] ? add_tree_block+0xe2/0x180 [btrfs]
[133088.569072]  [<ffffffffa009327b>] relocate_block_group+0x1cb/0x630 [btrfs]
[133088.569072]  [<ffffffffa0093890>] btrfs_relocate_block_group+0x1b0/0x2e0 [btrfs]
[133088.569072]  [<ffffffffa006c497>] btrfs_relocate_chunk+0x87/0x750 [btrfs]
[133088.569072]  [<ffffffffa0068aaf>] ? free_extent_buffer+0x1f/0x90 [btrfs]
[133088.569072]  [<ffffffff8136989e>] ? do_raw_spin_unlock+0x5e/0xb0
[133088.569072]  [<ffffffff818cfb8b>] ? _raw_spin_unlock+0x2b/0x50
[133088.569072]  [<ffffffffa0062b19>] ? release_extent_buffer+0xb9/0xe0 [btrfs]
[133088.569072]  [<ffffffffa0068aaf>] ? free_extent_buffer+0x1f/0x90 [btrfs]
[133088.569072]  [<ffffffffa0068acc>] ? free_extent_buffer+0x3c/0x90 [btrfs]
[133088.569072]  [<ffffffffa0070ab2>] btrfs_balance+0x812/0xcb0 [btrfs]
[133088.569072]  [<ffffffffa0078cb4>] btrfs_ioctl_balance+0x134/0x260 [btrfs]
[133088.569072]  [<ffffffffa007ab54>] btrfs_ioctl+0x844/0x19d0 [btrfs]
[133088.569072]  [<ffffffff8106e0f3>] ? up_read+0x23/0x40
[133088.569072]  [<ffffffff818d4080>] ? do_page_fault+0x2d0/0x580
[133088.569072]  [<ffffffff8115a238>] do_vfs_ioctl+0x98/0x560
[133088.569072]  [<ffffffff81099de9>] ? trace_hardirqs_off_caller+0x29/0xc0
[133088.569072]  [<ffffffff818d0395>] ? retint_swapgs+0x13/0x1b
[133088.569072]  [<ffffffff8115a74f>] sys_ioctl+0x4f/0x80
[133088.569072]  [<ffffffff818d8869>] system_call_fastpath+0x16/0x1b
[133088.569072] Code: 48 89 df 48 89 8b 00 01 00 00 48 89 72 30 48 89 d6 48 89 42 38 48 89 08 e8 26 f2 ff ff 4d 85 ff 0f 85 66 ff ff ff e9 0a ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 6
[133088.569072] RIP  [<ffffffffa008d4c8>] select_reloc_root+0x1d8/0x1f0 [btrfs]
[133088.569072]  RSP <ffff8800174b9898>
[133088.973110] ---[ end trace 2aefcc77a6ab3c94 ]---

2316 static noinline_for_stack
2317 struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
2318                                      struct reloc_control *rc,
2319                                      struct backref_node *node,
2320                                      struct backref_edge *edges[], int *nr)
2321 {
2322         struct backref_node *next;
2323         struct btrfs_root *root;
2324         int index = 0;
2325
2326         next = node;
2327         while (1) {
2328                 cond_resched();
2329                 next = walk_up_backref(next, edges, &index);
2330                 root = next->root;
2331                 BUG_ON(!root);

