Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from server1.design-company.com.au ([103.18.108.111]:35677 "EHLO
	server1.design-company.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbbETFFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 01:05:36 -0400
Received: from ful1143003.lnk.telstra.net ([110.143.62.99]:60255 helo=hostd49a20ff8a0a.local)
	by server1.design-company.com.au with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
	(Exim 4.85)
	(envelope-from <hub@spotprint.com.au>)
	id 1YuwCC-0008LC-RC
	for linux-btrfs@vger.kernel.org; Wed, 20 May 2015 15:05:32 +1000
Message-ID: <555C15E5.2070808@spotprint.com.au>
Date: Wed, 20 May 2015 15:04:37 +1000
From: Ryan Bourne <hub@spotprint.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Kernel BUG during balance
References: <555C04BC.9090808@spotprint.com.au>
In-Reply-To: <555C04BC.9090808@spotprint.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a filesystem which triggers a BUG_ON() about 10-20 minutes into a 
balance. At other times it appears to be functioning normally.


[ 1143.881622] kernel BUG at fs/btrfs/extent-tree.c:2248!
[ 1143.882359] invalid opcode: 0000 [#1] SMP
[ 1143.883094] Modules linked in: joydev(E) bonding(E) iTCO_wdt(E) 
iTCO_vendor_support(E) eeepc_wmi(E) asus_wmi(E) sparse_keymap(E) 
rfkill(E) mxm_wmi(E) ppdev(E) ext4(E) mbcache(E) jbd2(E) 
x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) 
kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) 
ghash_clmulni_intel(E) aesni_intel(E) lrw(E) gf128mul(E) glue_helper(E) 
ablk_helper(E) cryptd(E) serio_raw(E) pcspkr(E) i2c_i801(E) lpc_ich(E) 
mfd_core(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) 
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E) 
snd_seq(E) snd_seq_device(E) snd_pcm(E) parport_pc(E) parport(E) 
8250_fintek(E) wmi(E) snd_timer(E) tpm_infineon(E) mei_me(E) snd(E) 
mei(E) soundcore(E) shpchp(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) 
grace(E) sunrpc(E)
[ 1143.887229]  btrfs(E) xor(E) raid6_pq(E) sd_mod(E) ahci(E) libahci(E) 
libata(E) firewire_ohci(E) igb(E) ptp(E) i915(E) pps_core(E) dca(E) 
firewire_core(E) crc_itu_t(E) i2c_algo_bit(E) drm_kms_helper(E) drm(E) 
video(E)
[ 1143.888998] CPU: 0 PID: 4076 Comm: btrfs Tainted: G        W   E 
4.0.1-1.el7.elrepo.x86_64 #1
[ 1143.889900] Hardware name: ASUS All Series/P9D WS, BIOS 2004 06/05/2014
[ 1143.890797] task: ffff88040aabc470 ti: ffff880382f5c000 task.ti: 
ffff880382f5c000
[ 1143.891699] RIP: 0010:[<ffffffffa0338376>]  [<ffffffffa0338376>] 
__btrfs_run_delayed_refs+0x11f6/0x1220 [btrfs]
[ 1143.892632] RSP: 0018:ffff880382f5f7a8  EFLAGS: 00010202
[ 1143.893641] RAX: 0000000000004000 RBX: 0000000000000000 RCX: 
0000000000000069
[ 1143.894566] RDX: ffff8803f7d6f000 RSI: ffff880109319d90 RDI: 
ffff880109319d88
[ 1143.895482] RBP: ffff880382f5f8d8 R08: 0000000000000000 R09: 
ffff88039d9388f0
[ 1143.896379] R10: ffff8803b677e3c8 R11: 0000000000003523 R12: 
ffff8803be941738
[ 1143.897253] R13: 00000205f7a90000 R14: ffff880109319d20 R15: 
0000000000000000
[ 1143.898109] FS:  00007f1ff5b3dc80(0000) GS:ffff88041fa00000(0000) 
knlGS:0000000000000000
[ 1143.898952] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1143.899774] CR2: 00007f6c6ac42000 CR3: 0000000382f52000 CR4: 
00000000001407f0
[ 1143.900584] Stack:
[ 1143.901368]  0000000000000001 0000000000000000 0000020500000001 
0000000000000001
[ 1143.902164]  0000000000000000 fffffffffffffff8 ffff8803f99bfb40 
fffffffffffffff8
[ 1143.902953]  0000000282f5f818 0000000000004000 ffff8803f99bfb40 
ffff8803f99bfb40
[ 1143.903737] Call Trace:
[ 1143.904530]  [<ffffffffa033c4f3>] 
btrfs_run_delayed_refs.part.65+0x73/0x270 [btrfs]
[ 1143.905333]  [<ffffffffa033c707>] btrfs_run_delayed_refs+0x17/0x20 
[btrfs]
[ 1143.906127]  [<ffffffffa034cf57>] 
btrfs_should_end_transaction+0x47/0x60 [btrfs]
[ 1143.906922]  [<ffffffffa033abc2>] btrfs_drop_snapshot+0x492/0x8a0 [btrfs]
[ 1143.907721]  [<ffffffffa03a2a36>] merge_reloc_roots+0x106/0x250 [btrfs]
[ 1143.908522]  [<ffffffffa03a2df1>] relocate_block_group+0x271/0x6a0 
[btrfs]
[ 1143.909321]  [<ffffffffa03a33f6>] 
btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
[ 1143.910126]  [<ffffffffa037689e>] 
btrfs_relocate_chunk.isra.38+0x3e/0xc0 [btrfs]
[ 1143.910927]  [<ffffffffa0377d34>] __btrfs_balance+0x4f4/0x8e0 [btrfs]
[ 1143.911725]  [<ffffffffa03784ca>] btrfs_balance+0x3aa/0x680 [btrfs]
[ 1143.912524]  [<ffffffffa038184b>] ? btrfs_ioctl_balance+0x29b/0x520 
[btrfs]
[ 1143.913323]  [<ffffffffa0381714>] btrfs_ioctl_balance+0x164/0x520 [btrfs]
[ 1143.914123]  [<ffffffffa03866e4>] btrfs_ioctl+0x574/0x2b10 [btrfs]
[ 1143.914916]  [<ffffffff81188cab>] ? 
lru_cache_add_active_or_unevictable+0x2b/0xa0
[ 1143.915711]  [<ffffffff811a9641>] ? handle_pte_fault+0xc61/0x13c0
[ 1143.916505]  [<ffffffff811c8e01>] ? alloc_pages_current+0x91/0x100
[ 1143.917297]  [<ffffffff81068c80>] ? pte_alloc_one+0x30/0x50
[ 1143.918086]  [<ffffffff811ab114>] ? handle_mm_fault+0x234/0x4a0
[ 1143.918874]  [<ffffffff81206e18>] do_vfs_ioctl+0x2f8/0x4f0
[ 1143.919664]  [<ffffffff8111c0a4>] ? __audit_syscall_entry+0xb4/0x110
[ 1143.920452]  [<ffffffff810241cc>] ? do_audit_syscall_entry+0x6c/0x70
[ 1143.921241]  [<ffffffff81207091>] SyS_ioctl+0x81/0xa0
[ 1143.922026]  [<ffffffff816b2a89>] system_call_fastpath+0x12/0x17
[ 1143.922812] Code: ff ff 48 8b 75 b7 45 31 c0 b9 01 00 00 00 41 bf f4 
ff ff ff 8b 90 5c 03 00 00 48 89 c7 e8 f3 b0 ff ff e9 9b ef ff ff 0f 0b 
0f 0b <0f> 0b 48 8b 4d c0 48 8b 55 b7 48 c7 c6 e0 39 3d a0 48 8b bd 38
[ 1143.924516] RIP  [<ffffffffa0338376>] 
__btrfs_run_delayed_refs+0x11f6/0x1220 [btrfs]
[ 1143.925633]  RSP <ffff880382f5f7a8>


--

Regards,
Ryan

