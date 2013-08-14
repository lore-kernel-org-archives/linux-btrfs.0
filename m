Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59503 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415Ab3HNRuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 13:50:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V9fD6-000173-8P
	for linux-btrfs@vger.kernel.org; Wed, 14 Aug 2013 19:50:16 +0200
Received: from 91-119-129-170.dynamic.xdsl-line.inode.at ([91.119.129.170])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:50:16 +0200
Received: from tim by 91-119-129-170.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:50:16 +0200
To: linux-btrfs@vger.kernel.org
From: tim <tim@klingt.org>
Subject: BUG at fs/btrfs/file.c:870
Date: Wed, 14 Aug 2013 19:50:05 +0200
Message-ID: <kugg05$88d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi all,

trying to reproduce [1], i've came across another btrfs bug:

[ 4031.725643] ------------[ cut here ]------------
[ 4031.725647] kernel BUG at fs/btrfs/file.c:870!
[ 4031.725648] invalid opcode: 0000 [#1] PREEMPT SMP
[ 4031.725650] Modules linked in: ecryptfs sha256_generic encrypted_keys
sha1_generic trusted tpm tpm_bios pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) parport_pc ppdev bluetooth nfsd binfmt_misc
auth_rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc fscache
dm_crypt wacom lp parport arc4 rt2800usb rt2x00usb rt2800lib rt2x00lib
snd_hda_codec_hdmi mac80211 cfg80211 snd_hda_codec_realtek crc_ccitt
snd_usb_audio snd_usbmidi_lib snd_hda_intel snd_hda_codec snd_hdsp
coretemp snd_hwdep snd_pcm_oss snd_mixer_oss kvm_intel kvm snd_pcm
snd_seq_dummy snd_page_alloc snd_seq_oss nvidia(PO) snd_seq_midi
snd_seq_midi_event snd_rawmidi microcode mxm_wmi snd_seq snd_seq_device
snd_timer serio_raw snd soundcore lpc_ich btrfs xor zlib_deflate
raid6_pq libcrc32c hid_generic usbhid hid firewire_ohci firewire_core
crc_itu_t ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw
gf128mul ablk_helper cryptd ahci libahci i915 xhci_hcd video r8169
i2c_algo_bit mii drm_kms_helper drm
[ 4031.725680] CPU: 0 PID: 7404 Comm: btrfs-endio-wri Tainted: P
   O 3.10.5+ #6
[ 4031.725681] Hardware name: Gigabyte Technology Co., Ltd.
Z68X-UD3H-B3/Z68X-UD3H-B3, BIOS F3 05/13/2011
[ 4031.725682] task: ffff88035b64c880 ti: ffff880315238000 task.ti:
ffff880315238000
[ 4031.725683] RIP: 0010:[<ffffffffa023c00a>]  [<ffffffffa023c00a>]
__btrfs_drop_extents+0xafa/0xb30 [btrfs]
[ 4031.725692] RSP: 0018:ffff880315239b68  EFLAGS: 00010297
[ 4031.725693] RAX: 0000000000000014 RBX: ffff88041d9991a0 RCX:
ffff88020e732000
[ 4031.725694] RDX: 0000000000000000 RSI: 0000000000000b9f RDI:
ffff88041d9991a0
[ 4031.725695] RBP: ffff880315239c58 R08: 0000000000000001 R09:
00000000ffffffff
[ 4031.725696] R10: 0000000000000000 R11: 0000000b6f90f000 R12:
0000000b6f909000
[ 4031.725696] R13: 0000000000000001 R14: ffff8802685b7be0 R15:
0000000000000b72
[ 4031.725697] FS:  0000000000000000(0000) GS:ffff88042fa00000(0000)
knlGS:0000000000000000
[ 4031.725698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4031.725699] CR2: fffff9802ff00000 CR3: 000000035be86000 CR4:
00000000000427f0
[ 4031.725700] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 4031.725701] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 4031.725701] Stack:
[ 4031.725702]  00000000004f0e82 0000000b6f8e9000 0000000000000000
0000000b00000001
[ 4031.725704]  ffff88041a3a7000 0000000000000008 0000000100001000
0000000000020000
[ 4031.725705]  0000000000000000 ffff880233cd1950 ffff880239cd45d0
00000205b483a000
[ 4031.725706] Call Trace:
[ 4031.725714]  [<ffffffffa023cb26>] btrfs_drop_extents+0x66/0xa0 [btrfs]
[ 4031.725720]  [<ffffffffa022e152>]
insert_reserved_file_extent.constprop.66+0x72/0x2b0 [btrfs]
[ 4031.725726]  [<ffffffffa0229103>] ? start_transaction+0x93/0x460 [btrfs]
[ 4031.725732]  [<ffffffffa02352c0>] btrfs_finish_ordered_io+0x530/0x990
[btrfs]
[ 4031.725735]  [<ffffffff81045d58>] ? try_to_del_timer_sync+0x48/0x60
[ 4031.725737]  [<ffffffff81045dba>] ? del_timer_sync+0x4a/0x60
[ 4031.725738]  [<ffffffff810454c0>] ? usleep_range+0x40/0x40
[ 4031.725744]  [<ffffffffa0235730>] finish_ordered_fn+0x10/0x20 [btrfs]
[ 4031.725750]  [<ffffffffa025423f>] worker_loop+0x14f/0x540 [btrfs]
[ 4031.725756]  [<ffffffffa02540f0>] ? btrfs_queue_worker+0x310/0x310
[btrfs]
[ 4031.725758]  [<ffffffff81058b1b>] kthread+0xbb/0xc0
[ 4031.725760]  [<ffffffff81058a60>] ?
kthread_freezable_should_stop+0x60/0x60
[ 4031.725762]  [<ffffffff815988ec>] ret_from_fork+0x7c/0xb0
[ 4031.725764]  [<ffffffff81058a60>] ?
kthread_freezable_should_stop+0x60/0x60
[ 4031.725764] Code: 00 00 c7 45 8c 00 00 00 00 4d 89 dd e9 49 fb ff ff
c7 85 74 ff ff ff 01 00 00 00 4d 89 df e9 69 fc ff ff 0f 0b 0f 0b 0f 0b
0f 0b <0f> 0b 45 85 c0 4d 89 da 75 06 0f 0b 0f 0b 0f 0b 48 8d 55 b6 4c
[ 4031.725779] RIP  [<ffffffffa023c00a>]
__btrfs_drop_extents+0xafa/0xb30 [btrfs]
[ 4031.725785]  RSP <ffff880315239b68>
[ 4031.725794] ---[ end trace a5973c1aa21c0c01 ]---


this is 3.10.5. is this a known issue? anything i can do to help?

cheers, tim

[1] https://bugzilla.kernel.org/show_bug.cgi?id=60666

