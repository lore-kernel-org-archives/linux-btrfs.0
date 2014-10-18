Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([198.27.83.45]:59463 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaJRXIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 19:08:51 -0400
Date: Sat, 18 Oct 2014 18:59:22 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Yan Zheng <zheng.yan@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: 3.17.1 kernel BUG at /usr/src/linux/fs/btrfs/relocation.c:2736!
Message-ID: <20141018185922.7fb2a323@Vantage.cJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Yan,


I was attempting to migrate a JBOD drive set to RAID1,
so I did a balance filter, which failed because free space was missing,
then I attempted to remove a device from the set (because I also wanted
to do that more urgently than the RAID1 migration), and got:

[ 6973.725608] kernel BUG at /usr/src/linux/fs/btrfs/relocation.c:2736!
[ 6973.725645] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 6973.725685] Modules linked in: af_packet cfg80211 rfkill coretemp hwmon kvm_intel kvm mousedev hid_generic ipmi_devintf iTCO_wdt iTCO_vendor_support snd_pcm snd_timer usbhid dcdbas microcode 8250 psmouse snd soundcore pcspkr hid ipmi_si tpm_tis tpm ipmi_msghandler serial_core rtc_cmos hed evdev processor lpc_ich mfd_core ipv6 autofs4 unix
[ 6973.725955] CPU: 24 PID: 62454 Comm: btrfs Not tainted 3.17.1-ForYou #6
[ 6973.725992] Hardware name: Dell Inc. PowerEdge R910/0P658H, BIOS 1.2.0 06/22/2010
[ 6973.726050] task: ffff8803d4bdc5c0 ti: ffff8805270b0000 task.ti: ffff8805270b0000
[ 6973.726107] RIP: 0010:[<ffffffff8121d1a2>]  [<ffffffff8121d1a2>] do_relocation+0x3b7/0x3cb
[ 6973.726178] RSP: 0000:ffff8805270b3a40  EFLAGS: 00010246
[ 6973.726214] RAX: 0000000000000000 RBX: ffff8801c8165f00 RCX: 0000007d40000000
[ 6973.726254] RDX: 0000000040000000 RSI: 0000000000000000 RDI: 00000000ffffffff
[ 6973.726293] RBP: ffff8801c8165100 R08: 0000000000004000 R09: 0000000000200000
[ 6973.726332] R10: 0000000000001000 R11: 0000160000000000 R12: ffff8802673dd830
[ 6973.726370] R13: ffff8801066a4000 R14: ffff8808754b3800 R15: 00000000ffffffe4
[ 6973.726409] FS:  00007fa38c4bb880(0000) GS:ffff880277cc0000(0000) knlGS:0000000000000000
[ 6973.726472] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6973.726508] CR2: 0000000003228bd0 CR3: 000000049d5c8000 CR4: 00000000000007e0
[ 6973.726546] Stack:
[ 6973.726572]  ffff8801a6dc9c20 ffff8806763671c0 ffff880676367ca0 0000000176367ca0
[ 6973.726653]  ffff8801c8165140 0000007d6e998000 000000bf00000000 ffff880019ccbc20
[ 6973.726724]  ffff880676367940 ffff8801c8666580 ffff880827fc4c38 ffffffff814cad3e
[ 6973.726793] Call Trace:
[ 6973.726830]  [<ffffffff814cad3e>] ? _raw_spin_lock+0xe/0x17
[ 6973.726871]  [<ffffffff814cadb4>] ? _raw_spin_unlock+0xd/0x1f
[ 6973.726913]  [<ffffffff811cf5d2>] ? btrfs_block_rsv_refill+0x4a/0x85
[ 6973.726952]  [<ffffffff8121d4bd>] ? relocate_tree_blocks+0x307/0x430
[ 6973.726994]  [<ffffffff81218eb5>] ? tree_insert+0x44/0x47
[ 6973.727030]  [<ffffffff8121a3e8>] ? add_tree_block+0x112/0x13c
[ 6973.727069]  [<ffffffff8121e10d>] ? relocate_block_group+0x26d/0x4a6
[ 6973.727111]  [<ffffffff811f4c0a>] ? btrfs_wait_ordered_roots+0x18d/0x1a9
[ 6973.727150]  [<ffffffff8121e49a>] ? btrfs_relocate_block_group+0x154/0x265
[ 6973.727191]  [<ffffffff811fda16>] ? btrfs_relocate_chunk.isra.29+0x4d/0x551
[ 6973.727234]  [<ffffffff811c0d0e>] ? btrfs_item_key_to_cpu+0x12/0x30
[ 6973.727275]  [<ffffffff8104f5d1>] ? get_parent_ip+0x9/0x1b
[ 6973.727310]  [<ffffffff814cadb4>] ? _raw_spin_unlock+0xd/0x1f
[ 6973.727346]  [<ffffffff811f9f5e>] ? release_extent_buffer+0xa4/0xae
[ 6973.727384]  [<ffffffff811ffaf4>] ? btrfs_shrink_device+0x206/0x389
[ 6973.727425]  [<ffffffff81201e2e>] ? btrfs_rm_device+0x2bb/0x781
[ 6973.727464]  [<ffffffff81209e97>] ? btrfs_ioctl+0x863/0x20d9
[ 6973.727504]  [<ffffffff810f1be1>] ? user_path_at_empty+0x72/0xa8
[ 6973.727545]  [<ffffffff810aef31>] ? __lru_cache_add+0x53/0x67
[ 6973.727585]  [<ffffffff8102bfea>] ? __do_page_fault+0x28c/0x304
[ 6973.727625]  [<ffffffff810e9a25>] ? cp_new_stat+0x115/0x128
[ 6973.727668]  [<ffffffff810f334b>] ? do_vfs_ioctl+0x351/0x403
[ 6973.727708]  [<ffffffff810e9b37>] ? SYSC_newstat+0x1f/0x27
[ 6973.727743]  [<ffffffff810f344b>] ? SyS_ioctl+0x4e/0x71
[ 6973.727778]  [<ffffffff814cb4d2>] ? system_call_fastpath+0x16/0x1b
[ 6973.727814] Code: 8b 45 08 49 89 55 08 4c 89 6d 30 48 89 45 38 48 89 10 80 65 71 df 45 31 ff 41 c7 84 24 84 00 00 00 00 00 00 00 41 83 ff e4 75 02 <0f> 0b 48 83 c4 78 44 89 f8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 
[ 6973.728073] RIP  [<ffffffff8121d1a2>] do_relocation+0x3b7/0x3cb
[ 6973.728115]  RSP <ffff8805270b3a40>
[ 6973.728528] ---[ end trace c3c446c714ed4b7a ]---


Regards,

-- 
Jérôme
