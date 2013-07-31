Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35819 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab3GaMUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 08:20:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V4VNq-0004SU-Bs
	for linux-btrfs@vger.kernel.org; Wed, 31 Jul 2013 14:20:02 +0200
Received: from 91-119-90-44.dynamic.xdsl-line.inode.at ([91.119.90.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 14:20:02 +0200
Received: from tim by 91-119-90-44.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 14:20:02 +0200
To: linux-btrfs@vger.kernel.org
From: tim <tim@klingt.org>
Subject: [3.10.3] kernel BUG at fs/btrfs/ctree.c:3000
Date: Wed, 31 Jul 2013 14:19:25 +0200
Message-ID: <ktavc5$htm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

running btrfs on kernel 3.10.3, i got the following two backtraces,
first an info about a hung task and a kernel bug.

are these known issues?

thnx, tim


[  479.949428] INFO: task btrfs-transacti:1761 blocked for more than 120
seconds.
[  479.949430] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.949431] btrfs-transacti D 0000000000000001     0  1761      2
0x00000000
[  479.949433]  ffff88041d195d58 0000000000000002 ffff88041d195fd8
0000000000004000
[  479.949435]  ffff88041d195fd8 ffffffff81a10440 ffff880419fec540
0000000000000000
[  479.949436]  0000000000000010 ffff88041d195cf8 ffffffff8111a8db
0000805000000287
[  479.949437] Call Trace:
[  479.949442]  [<ffffffff8111a8db>] ? cache_alloc_refill+0x1ab/0x2e0
[  479.949456]  [<ffffffffa0201fe1>] ? btrfs_free_path+0x21/0x30 [btrfs]
[  479.949458]  [<ffffffff815927f4>] schedule+0x24/0x70
[  479.949460]  [<ffffffff81590871>] schedule_timeout+0x181/0x1c0
[  479.949466]  [<ffffffffa022811a>]
btrfs_commit_transaction+0x22a/0xac0 [btrfs]
[  479.949469]  [<ffffffff81059960>] ? abort_exclusive_wait+0xb0/0xb0
[  479.949475]  [<ffffffffa0229043>] ? start_transaction+0x93/0x460 [btrfs]
[  479.949481]  [<ffffffffa022024d>] transaction_kthread+0x19d/0x220 [btrfs]
[  479.949486]  [<ffffffffa02200b0>] ? btrfs_alloc_root+0x30/0x30 [btrfs]
[  479.949488]  [<ffffffff81058e0b>] kthread+0xbb/0xc0
[  479.949489]  [<ffffffff81058d50>] ?
kthread_freezable_should_stop+0x60/0x60
[  479.949491]  [<ffffffff8159976c>] ret_from_fork+0x7c/0xb0
[  479.949493]  [<ffffffff81058d50>] ?
kthread_freezable_should_stop+0x60/0x60
[ 1009.450789] warning: `VirtualBox' uses 32-bit capabilities (legacy
support in use)
[ 5847.442443] ------------[ cut here ]------------
[ 5847.442446] kernel BUG at fs/btrfs/ctree.c:3000!
[ 5847.442447] invalid opcode: 0000 [#1] PREEMPT SMP
[ 5847.442449] Modules linked in: ecryptfs sha256_generic encrypted_keys
sha1_generic trusted tpm tpm_bios pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) parport_pc ppdev bluetooth nfsd auth_rpcgss
binfmt_misc oid_registry exportfs nfs_acl nfs lockd sunrpc fscache
dm_crypt wacom lp parport arc4 rt2800usb rt2x00usb rt2800lib rt2x00lib
mac80211 cfg80211 crc_ccitt snd_hda_codec_hdmi nvidia(PO)
snd_hda_codec_realtek coretemp snd_usb_audio kvm_intel snd_usbmidi_lib
kvm snd_seq_dummy snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi
snd_seq_midi_event snd_hdsp snd_hwdep mxm_wmi snd_pcm_oss snd_mixer_oss
snd_rawmidi microcode snd_seq snd_pcm snd_seq_device snd_page_alloc
snd_timer serio_raw snd soundcore lpc_ich btrfs xor zlib_deflate
raid6_pq libcrc32c hid_generic usbhid hid ghash_clmulni_intel
firewire_ohci firewire_core crc_itu_t r8169 aesni_intel i915 aes_x86_64
glue_helper lrw gf128mul ablk_helper video i2c_algo_bit drm_kms_helper
cryptd drm xhci_hcd ahci libahci
[ 5847.442479] CPU: 0 PID: 6645 Comm: btrfs-endio-wri Tainted: P
   O 3.10.3 #4
[ 5847.442480] Hardware name: Gigabyte Technology Co., Ltd.
Z68X-UD3H-B3/Z68X-UD3H-B3, BIOS F3 05/13/2011
[ 5847.442481] task: ffff88031d2040c0 ti: ffff88036afb8000 task.ti:
ffff88036afb8000
[ 5847.442482] RIP: 0010:[<ffffffffa0205299>]  [<ffffffffa0205299>]
btrfs_set_item_key_safe+0x149/0x150 [btrfs]
[ 5847.442490] RSP: 0018:ffff88036afb9b10  EFLAGS: 00010286
[ 5847.442491] RAX: 00000000ffffffff RBX: 000000000000000e RCX:
0000000b6f8ff000
[ 5847.442492] RDX: 00000000ffffffff RSI: ffff88036afb9c0e RDI:
ffff88036afb9aef
[ 5847.442492] RBP: ffff88036afb9b58 R08: 0000000000000000 R09:
0000000000000000
[ 5847.442493] R10: 0000000b6f909000 R11: 0000000000000000 R12:
ffff88036afb9b1f
[ 5847.442494] R13: ffff88038f9480a0 R14: ffff88036afb9c0e R15:
ffff88032c9a4560
[ 5847.442495] FS:  0000000000000000(0000) GS:ffff88042fa00000(0000)
knlGS:0000000000000000
[ 5847.442496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5847.442497] CR2: fffff98060fc2000 CR3: 000000033c618000 CR4:
00000000000427f0
[ 5847.442497] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 5847.442498] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 5847.442499] Stack:
[ 5847.442500]  ffff88041aba7000 8200000000000ce5 6c00000000004f0e
0000000b6f8fa000
[ 5847.442501]  ffff88032c9a4560 0000000000006000 0000000000000000
ffff88038f9480a0
[ 5847.442502]  0000000000000ce5 ffff88036afb9c58 ffffffffa023b9e1
00000000004f0e82
[ 5847.442504] Call Trace:
[ 5847.442512]  [<ffffffffa023b9e1>] __btrfs_drop_extents+0x591/0xb30
[btrfs]
[ 5847.442518]  [<ffffffffa023ca66>] btrfs_drop_extents+0x66/0xa0 [btrfs]
[ 5847.442524]  [<ffffffffa022e092>]
insert_reserved_file_extent.constprop.66+0x72/0x2b0 [btrfs]
[ 5847.442530]  [<ffffffffa0229043>] ? start_transaction+0x93/0x460 [btrfs]
[ 5847.442536]  [<ffffffffa0235200>] btrfs_finish_ordered_io+0x530/0x990
[btrfs]
[ 5847.442538]  [<ffffffff81046048>] ? try_to_del_timer_sync+0x48/0x60
[ 5847.442540]  [<ffffffff810460aa>] ? del_timer_sync+0x4a/0x60
[ 5847.442542]  [<ffffffff810457b0>] ? usleep_range+0x40/0x40
[ 5847.442547]  [<ffffffffa0235670>] finish_ordered_fn+0x10/0x20 [btrfs]
[ 5847.442553]  [<ffffffffa025417f>] worker_loop+0x14f/0x540 [btrfs]
[ 5847.442555]  [<ffffffff81065b2d>] ? default_wake_function+0xd/0x10
[ 5847.442561]  [<ffffffffa0254030>] ? btrfs_queue_worker+0x310/0x310
[btrfs]
[ 5847.442563]  [<ffffffff81058e0b>] kthread+0xbb/0xc0
[ 5847.442565]  [<ffffffff81058d50>] ?
kthread_freezable_should_stop+0x60/0x60
[ 5847.442566]  [<ffffffff8159976c>] ret_from_fork+0x7c/0xb0
[ 5847.442568]  [<ffffffff81058d50>] ?
kthread_freezable_should_stop+0x60/0x60
[ 5847.442569] Code: 00 00 4c 89 e6 48 98 4c 89 ff 48 8d 04 80 48 8d 54
80 65 e8 9a 29 04 00 4c 89 f6 4c 89 e7 e8 8f f2 ff ff 85 c0 0f 8f 5c ff
ff ff <0f> 0b 0f 0b 0f 1f 00 48 b8 00 00 00 00 00 16 00 00 55 48 ba b7
[ 5847.442584] RIP  [<ffffffffa0205299>]
btrfs_set_item_key_safe+0x149/0x150 [btrfs]
[ 5847.442588]  RSP <ffff88036afb9b10>
[ 5847.442589] ---[ end trace fbc9487dfa341622 ]---

