Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab3B0FWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 00:22:50 -0500
Date: Wed, 27 Feb 2013 00:22:47 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: btrfs crash when low on memory.
Message-ID: <20130227052247.GA20213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Something I've yet to repeat managed to leak a whole bunch of memory
while I was travelling, and locked up my workstation.

When I got home, this was the last thing printed out before it locked up
(it did make it into the logs thankfully) after a bunch of instances of
the oom-killers handywork.



SLUB: Unable to allocate memory on node -1 (gfp=0x50)
  cache: btrfs_extent_state, object size: 176, buffer size: 504, default order: 1, min order: 0
  node 0: slabs: 49, objs: 640, free: 0
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:748!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: xfs vfat fat ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_emu10k1 coretemp snd_hwdep snd_util_mem snd_ac97_codec ac97_bus snd_rawmidi snd_seq snd_seq_device microcode snd_pcm pcspkr snd_page_alloc snd_timer snd soundcore e1000e vhost_net tun macvtap macvlan kvm_intel kvm binfmt_misc nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c lzo_compress zlib_deflate ata_piix usb_storage firewire_ohci firewire_core sata_sil crc_itu_t radeon i2c_algo_bit hwmon drm_kms_helper ttm drm i2c_core floppy
CPU 1 
Pid: 7017, comm: mutt Not tainted 3.8.0+ #67                  /D975XBX
RIP: 0010:[<ffffffffa02502fe>]  [<ffffffffa02502fe>] __set_extent_bit+0x3ae/0x4d0 [btrfs]
RSP: 0000:ffff8800a4c31838  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000001bbfff RCX: 0000000000000000
RDX: 0000000000000001 RSI: 00000000000000b0 RDI: 0000000000000000
RBP: ffff8800a4c318b8 R08: ffffffff81cf0b80 R09: 0000000000000400
R10: 0000000000000001 R11: 0000000000000508 R12: ffff8800ba4ab2c8
R13: ffff8800ba4ab2c8 R14: 0000000000000000 R15: 00000000001bb000
FS:  00007eff96e14800(0000) GS:ffff8800bfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000449cee CR3: 0000000080ebb000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mutt (pid: 7017, threadinfo ffff8800a4c30000, task ffff880025cba4c0)
Stack:
 0000000000002ab2 ffff8800a4c318e0 ffff8800a4c31fd8 0000000000000292
 ffff8800a4c31fd8 0000000000001000 00000000001bbfff 0000100800000008
 00000000034a39a8 ffff8800ba4ab2c8 ffff8800a4c31898 00000000001bbfff
Call Trace:
 [<ffffffffa0251024>] lock_extent_bits+0x74/0xa0 [btrfs]
 [<ffffffffa0251063>] lock_extent+0x13/0x20 [btrfs]
 [<ffffffffa02531c4>] __extent_read_full_page+0xc4/0x720 [btrfs]
 [<ffffffffa02520e0>] ? repair_io_failure+0x440/0x440 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa0254886>] extent_readpages+0x116/0x1f0 [btrfs]
 [<ffffffffa02383cf>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffff8115592a>] __do_page_cache_readahead+0x2aa/0x350
 [<ffffffff81155790>] ? __do_page_cache_readahead+0x110/0x350
 [<ffffffff81147d95>] ? find_get_page+0x5/0x280
 [<ffffffff81155b61>] ra_submit+0x21/0x30
 [<ffffffff81149f07>] filemap_fault+0x267/0x4a0
 [<ffffffff811724fe>] __do_fault+0x6e/0x530
 [<ffffffff8117539f>] handle_pte_fault+0x8f/0x900
 [<ffffffff81176430>] handle_mm_fault+0x210/0x300
 [<ffffffff81693d6c>] __do_page_fault+0x15c/0x4e0
 [<ffffffff811029d7>] ? rcu_eqs_exit_common+0xc7/0x380
 [<ffffffff81102cf5>] ? rcu_eqs_exit+0x65/0xb0
 [<ffffffff8169411b>] do_page_fault+0x2b/0x50
 [<ffffffff81690ccf>] page_fault+0x1f/0x30
Code: c9 0f 85 c7 fc ff ff 66 0f 1f 44 00 00 f6 45 18 10 0f 84 b7 fc ff ff 8b 7d 18 e8 8e f2 ff ff 48 85 c0 48 89 c1 0f 85 a3 fc ff ff <0f> 0b 4d 89 ef 31 c9 eb 89 66 0f 1f 84 00 00 00 00 00 48 83 7b 

WARNING: at kernel/exit.c:721 do_exit+0x55/0xc70()
Hardware name:         
Modules linked in: xfs vfat fat ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_emu10k1 coretemp snd_hwdep snd_util_mem snd_ac97_codec ac97_bus snd_rawmidi snd_seq snd_seq_device microcode snd_pcm pcspkr snd_page_alloc snd_timer snd soundcore e1000e vhost_net tun macvtap macvlan kvm_intel kvm binfmt_misc nfsd auth_rpcgss nfs_acl lockd sunrpc btrfs libcrc32c lzo_compress zlib_deflate ata_piix usb_storage firewire_ohci firewire_core sata_sil crc_itu_t radeon i2c_algo_bit hwmon drm_kms_helper ttm drm i2c_core floppy
Pid: 7017, comm: mutt Tainted: G      D      3.8.0+ #67
Call Trace:
 [<ffffffff8104b54f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104b5aa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810517c5>] do_exit+0x55/0xc70
 [<ffffffff8133b1b8>] ? __const_udelay+0x28/0x30
 [<ffffffff81075b3c>] ? __rcu_read_unlock+0x5c/0xa0
 [<ffffffff8104f08d>] ? kmsg_dump+0x1bd/0x230
 [<ffffffff8104eef5>] ? kmsg_dump+0x25/0x230
 [<ffffffff81691936>] oops_end+0x96/0xe0
 [<ffffffff81005ff8>] die+0x58/0x90
 [<ffffffff8169116b>] do_trap+0x6b/0x170
 [<ffffffff81002f1a>] do_invalid_op+0x9a/0xc0
 [<ffffffffa02502fe>] ? __set_extent_bit+0x3ae/0x4d0 [btrfs]
 [<ffffffffa024f5ae>] ? alloc_extent_state+0x2e/0x1b0 [btrfs]
 [<ffffffff8133c6ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81690acd>] ? restore_args+0x30/0x30
 [<ffffffff81699965>] invalid_op+0x15/0x20
 [<ffffffffa02502fe>] ? __set_extent_bit+0x3ae/0x4d0 [btrfs]
 [<ffffffffa02502f2>] ? __set_extent_bit+0x3a2/0x4d0 [btrfs]
 [<ffffffffa0251024>] lock_extent_bits+0x74/0xa0 [btrfs]
 [<ffffffffa0251063>] lock_extent+0x13/0x20 [btrfs]
 [<ffffffffa02531c4>] __extent_read_full_page+0xc4/0x720 [btrfs]
 [<ffffffffa02520e0>] ? repair_io_failure+0x440/0x440 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa023adf0>] ? btrfs_submit_direct+0x640/0x640 [btrfs]
 [<ffffffffa0254886>] extent_readpages+0x116/0x1f0 [btrfs]
 [<ffffffffa02383cf>] btrfs_readpages+0x1f/0x30 [btrfs]
 [<ffffffff8115592a>] __do_page_cache_readahead+0x2aa/0x350
 [<ffffffff81155790>] ? __do_page_cache_readahead+0x110/0x350
 [<ffffffff81147d95>] ? find_get_page+0x5/0x280
 [<ffffffff81155b61>] ra_submit+0x21/0x30
 [<ffffffff81149f07>] filemap_fault+0x267/0x4a0
 [<ffffffff811724fe>] __do_fault+0x6e/0x530
 [<ffffffff8117539f>] handle_pte_fault+0x8f/0x900
 [<ffffffff81176430>] handle_mm_fault+0x210/0x300
 [<ffffffff81693d6c>] __do_page_fault+0x15c/0x4e0
 [<ffffffff811029d7>] ? rcu_eqs_exit_common+0xc7/0x380
 [<ffffffff81102cf5>] ? rcu_eqs_exit+0x65/0xb0
 [<ffffffff8169411b>] do_page_fault+0x2b/0x50
 [<ffffffff81690ccf>] page_fault+0x1f/0x30




 746         if (!prealloc && (mask & __GFP_WAIT)) {
 747                 prealloc = alloc_extent_state(mask);
 748                 BUG_ON(!prealloc);
 749         }

	Dave

