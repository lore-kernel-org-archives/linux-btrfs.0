Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:58875 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbbLEJQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 04:16:03 -0500
Received: from i5.rohdewald.de (p5B3E1236.dip0.t-ipconnect.de [91.62.18.54])
	by smtp.strato.de (RZmta 37.14 DYNA|AUTH)
	with ESMTPSA id x051ffrB599g8MA
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sat, 5 Dec 2015 10:09:42 +0100 (CET)
Received: from i5.localnet (localhost.localdomain [127.0.0.1])
	by i5.rohdewald.de (Postfix) with ESMTP id 0345E5E0C9A
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Dec 2015 10:09:48 +0100 (CET)
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs balance: Kernel BUG
Date: Sat, 05 Dec 2015 10:09:47 +0100
Message-ID: <1795110.jZOk3ROKzF@i5>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unmodified Linux 4.3 tainted with nvidia

after adding disk #4 to RAID1, I did

btrfs filesystem balance /t4

Dec  5 08:07:26 s5 kernel: [55868.756847] BTRFS info (device sdc): relocating block group 10768619667456 flags 17
Dec  5 08:07:35 s5 kernel: [55878.297200] BTRFS info (device sdc): found 10 extents
Dec  5 08:07:40 s5 kernel: [55882.713437] BTRFS info (device sdc): found 10 extents
Dec  5 08:07:40 s5 kernel: [55883.219850] BTRFS info (device sdc): relocating block group 10767545925632 flags 17
Dec  5 08:07:57 s5 kernel: [55899.736052] BTRFS info (device sdc): found 11 extents
Dec  5 08:07:58 s5 kernel: [55901.082464] ------------[ cut here ]------------
Dec  5 08:07:58 s5 kernel: [55901.082468] Kernel BUG at ffffffffa012ef06 [verbose debug info unavailable]
Dec  5 08:07:58 s5 kernel: [55901.082470] invalid opcode: 0000 [#1] PREEMPT SMP 
Dec  5 08:07:58 s5 kernel: [55901.082472] Modules linked in: snd_hda_codec_hdmi(E) joydev(E) rc_tt_1500(E) stb6100(E) lnbp22(E) x86_pkg_temp_thermal(E) intel_powercl
amp(E) coretemp(E) nvidia(POE) stb0899(E) kvm_intel(E) kvm(E) dvb_usb_pctv452e(E) snd_hda_codec_realtek(E) ttpci_eeprom(E) snd_hda_codec_generic(E) crct10dif_pclmul(
E) dvb_usb(E) crc32_pclmul(E) dvb_core(E) rc_core(E) ftdi_sio(E) snd_hda_intel(E) hid_logitech_hidpp(E) usbserial(E) snd_hda_codec(E) snd_hda_core(E) aesni_intel(E) 
snd_hwdep(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) snd_pcm(E) ablk_helper(E) cryptd(E) bnep(E) rfcomm(E) snd_seq_midi(E) snd_seq_midi_event(E) bluetooth(E)
 snd_rawmidi(E) microcode(E) snd_seq(E) snd_seq_device(E) snd_timer(E) serio_raw(E) snd(E) soundcore(E) lpc_ich(E) tpm_tis(E) mei_me(E) mei(E) shpchp(E) nfsd(E) auth
_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) btrfs(E) xor(E) raid6_pq(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) sd_mod(E) psmouse(
E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E) video(E)
Dec  5 08:07:58 s5 kernel: [55901.082502] CPU: 2 PID: 8553 Comm: btrfs Tainted: P           OE   4.3.0+55 #1
Dec  5 08:07:58 s5 kernel: [55901.082503] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0323.2013.1204.1726 12/04/2013
Dec  5 08:07:58 s5 kernel: [55901.082504] task: ffff8800d5e08000 ti: ffff8800305e8000 task.ti: ffff8800305e8000
Dec  5 08:07:58 s5 kernel: [55901.082505] RIP: 0010:[<ffffffffa012ef06>]  [<ffffffffa012ef06>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082518] RSP: 0018:ffff8800305eb868  EFLAGS: 00010293
Dec  5 08:07:58 s5 kernel: [55901.082519] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8800305eb898
Dec  5 08:07:58 s5 kernel: [55901.082520] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
Dec  5 08:07:58 s5 kernel: [55901.082521] RBP: ffff8800305eb8c8 R08: 0000000000004000 R09: ffff8800305eb780
Dec  5 08:07:58 s5 kernel: [55901.082522] R10: 0000000000000000 R11: 0000000000000002 R12: ffff8800d95c6800
Dec  5 08:07:58 s5 kernel: [55901.082523] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800960cc1b0
Dec  5 08:07:58 s5 kernel: [55901.082524] FS:  00007f78bd8da880(0000) GS:ffff88021ec80000(0000) knlGS:0000000000000000
Dec  5 08:07:58 s5 kernel: [55901.082525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  5 08:07:58 s5 kernel: [55901.082526] CR2: 000000000932e000 CR3: 00000001428b1000 CR4: 00000000001406e0
Dec  5 08:07:58 s5 kernel: [55901.082527] Stack:
Dec  5 08:07:58 s5 kernel: [55901.082528]  0000000000000000 0000000000000005 0000000000000000 0000000000000000
Dec  5 08:07:58 s5 kernel: [55901.082530]  0000000000000001 ffff880214e11000 000000000000209e ffff880214e11000
Dec  5 08:07:58 s5 kernel: [55901.082532]  ffff8800575ceac8 ffff8800960cc1b0 0000000000000005 ffff880214c96000
Dec  5 08:07:58 s5 kernel: [55901.082533] Call Trace:
Dec  5 08:07:58 s5 kernel: [55901.082541]  [<ffffffffa012efa8>] __btrfs_inc_extent_ref.isra.49+0x98/0x250 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082545]  [<ffffffff81095f2d>] ? get_parent_ip+0xd/0x50
Dec  5 08:07:58 s5 kernel: [55901.082551]  [<ffffffffa0134e2d>] __btrfs_run_delayed_refs.constprop.68+0xd1d/0x10a0 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082556]  [<ffffffff8172a537>] ? _raw_write_lock+0x17/0x40
Dec  5 08:07:58 s5 kernel: [55901.082558]  [<ffffffff81729fba>] ? _raw_spin_unlock+0x1a/0x40
Dec  5 08:07:58 s5 kernel: [55901.082565]  [<ffffffffa0137da2>] btrfs_run_delayed_refs+0x82/0x290 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082573]  [<ffffffffa014c4d3>] btrfs_commit_transaction+0x43/0xb20 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082583]  [<ffffffffa019bff3>] prepare_to_merge+0x213/0x240 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082592]  [<ffffffffa019cb5a>] relocate_block_group+0x3ea/0x600 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082599]  [<ffffffffa019cf15>] btrfs_relocate_block_group+0x1a5/0x290 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082607]  [<ffffffffa0173c07>] btrfs_relocate_chunk.isra.34+0x47/0xd0 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082615]  [<ffffffffa0175371>] btrfs_balance+0x7d1/0xe90 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082623]  [<ffffffffa0181b70>] btrfs_ioctl_balance+0x400/0x540 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082626]  [<ffffffff811bde6d>] ? memcg_check_events+0x2d/0x1a0
Dec  5 08:07:58 s5 kernel: [55901.082633]  [<ffffffffa0183a97>] btrfs_ioctl+0x567/0x2450 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082636]  [<ffffffff81729fba>] ? _raw_spin_unlock+0x1a/0x40
Dec  5 08:07:58 s5 kernel: [55901.082638]  [<ffffffff811866f0>] ? handle_mm_fault+0xbd0/0x17d0
Dec  5 08:07:58 s5 kernel: [55901.082640]  [<ffffffff8118aa57>] ? __vma_link_rb+0xb7/0xd0
Dec  5 08:07:58 s5 kernel: [55901.082643]  [<ffffffff811dea8d>] do_vfs_ioctl+0x2cd/0x4c0
Dec  5 08:07:58 s5 kernel: [55901.082645]  [<ffffffff8105982d>] ? __do_page_fault+0x17d/0x3a0
Dec  5 08:07:58 s5 kernel: [55901.082647]  [<ffffffff811decf9>] SyS_ioctl+0x79/0x90
Dec  5 08:07:58 s5 kernel: [55901.082649]  [<ffffffff8172a8b6>] entry_SYSCALL_64_fastpath+0x16/0x75
Dec  5 08:07:58 s5 kernel: [55901.082650] Code: 45 10 49 89 d9 48 8b 55 d0 4c 89 34 24 4c 89 e9 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 3e e4 ff ff 
31 c0 eb bb <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 
Dec  5 08:07:58 s5 kernel: [55901.082669] RIP  [<ffffffffa012ef06>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]
Dec  5 08:07:58 s5 kernel: [55901.082674]  RSP <ffff8800305eb868>
Dec  5 08:07:58 s5 kernel: [55901.082676] ---[ end trace 1d59cb77367fac45 ]---
Dec  5 08:07:58 s5 kernel: [55901.082678] note: btrfs[8553] exited with preempt_count 1
Dec  5 08:08:31 s5 kernel: [55934.290958] ------------[ cut here ]------------
Dec  5 08:08:31 s5 kernel: [55934.290962] Kernel BUG at ffffffffa012ef06 [verbose debug info unavailable]
Dec  5 08:08:31 s5 kernel: [55934.290964] invalid opcode: 0000 [#2] PREEMPT SMP 
Dec  5 08:08:31 s5 kernel: [55934.290967] Modules linked in: snd_hda_codec_hdmi(E) joydev(E) rc_tt_1500(E) stb6100(E) lnbp22(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) nvidia(POE) stb0899(E) kvm_intel(E) kvm(E) dvb_usb_pctv452e(E) snd_hda_codec_realtek(E) ttpci_eeprom(E) snd_hda_codec_generic(E) crct10dif_pclmul(E) dvb_usb(E) crc32_pclmul(E) dvb_core(E) rc_core(E) ftdi_sio(E) snd_hda_intel(E) hid_logitech_hidpp(E) usbserial(E) snd_hda_codec(E) snd_hda_core(E) aesni_intel(E) snd_hwdep(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) snd_pcm(E) ablk_helper(E) cryptd(E) bnep(E) rfcomm(E) snd_seq_midi(E) snd_seq_midi_event(E) bluetooth(E) snd_rawmidi(E) microcode(E) snd_seq(E) snd_seq_device(E) snd_timer(E) serio_raw(E) snd(E) soundcore(E) lpc_ich(E) tpm_tis(E) mei_me(E) mei(E) shpchp(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) btrfs(E) xor(E) raid6_pq(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) sd_mod(E) psmouse(E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E) video(E)
Dec  5 08:08:31 s5 kernel: [55934.290998] CPU: 3 PID: 465 Comm: btrfs-transacti Tainted: P      D    OE   4.3.0+55 #1
Dec  5 08:08:31 s5 kernel: [55934.290999] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0323.2013.1204.1726 12/04/2013
Dec  5 08:08:31 s5 kernel: [55934.291000] task: ffff880214b13a00 ti: ffff880213d2c000 task.ti: ffff880213d2c000
Dec  5 08:08:31 s5 kernel: [55934.291001] RIP: 0010:[<ffffffffa012ef06>]  [<ffffffffa012ef06>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291013] RSP: 0018:ffff880213d2fbb0  EFLAGS: 00010293
Dec  5 08:08:31 s5 kernel: [55934.291014] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880213d2fbe0
Dec  5 08:08:31 s5 kernel: [55934.291015] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
Dec  5 08:08:31 s5 kernel: [55934.291016] RBP: ffff880213d2fc10 R08: 0000000000004000 R09: ffff880213d2fac8
Dec  5 08:08:31 s5 kernel: [55934.291018] R10: 0000000000000000 R11: 0000000000000002 R12: ffff8800d95c6800
Dec  5 08:08:31 s5 kernel: [55934.291019] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88019d795240
Dec  5 08:08:31 s5 kernel: [55934.291020] FS:  0000000000000000(0000) GS:ffff88021ecc0000(0000) knlGS:0000000000000000
Dec  5 08:08:31 s5 kernel: [55934.291022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  5 08:08:31 s5 kernel: [55934.291023] CR2: 00000000082eb000 CR3: 0000000001c10000 CR4: 00000000001406e0
Dec  5 08:08:31 s5 kernel: [55934.291024] Stack:
Dec  5 08:08:31 s5 kernel: [55934.291025]  0000000000000000 0000000000000005 0000000000000000 0000000000000000
Dec  5 08:08:31 s5 kernel: [55934.291027]  ffff880200000001 ffff880214e11000 0000000000002bf9 ffff880214e11000
Dec  5 08:08:31 s5 kernel: [55934.291029]  ffff88005fd2e8a0 ffff88019d795240 0000000000000005 ffff880214c96000
Dec  5 08:08:31 s5 kernel: [55934.291030] Call Trace:
Dec  5 08:08:31 s5 kernel: [55934.291037]  [<ffffffffa012efa8>] __btrfs_inc_extent_ref.isra.49+0x98/0x250 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291041]  [<ffffffff81095f2d>] ? get_parent_ip+0xd/0x50
Dec  5 08:08:31 s5 kernel: [55934.291047]  [<ffffffffa0134e2d>] __btrfs_run_delayed_refs.constprop.68+0xd1d/0x10a0 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291051]  [<ffffffff810cca34>] ? lock_timer_base.isra.33+0x54/0x70
Dec  5 08:08:31 s5 kernel: [55934.291058]  [<ffffffffa0137da2>] btrfs_run_delayed_refs+0x82/0x290 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291065]  [<ffffffffa014c4d3>] btrfs_commit_transaction+0x43/0xb20 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291074]  [<ffffffffa0147a6e>] transaction_kthread+0x19e/0x220 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291080]  [<ffffffffa01478d0>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291082]  [<ffffffff81089e79>] kthread+0xc9/0xe0
Dec  5 08:08:31 s5 kernel: [55934.291084]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  5 08:08:31 s5 kernel: [55934.291086]  [<ffffffff8172ac4f>] ret_from_fork+0x3f/0x70
Dec  5 08:08:31 s5 kernel: [55934.291088]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  5 08:08:31 s5 kernel: [55934.291089] Code: 45 10 49 89 d9 48 8b 55 d0 4c 89 34 24 4c 89 e9 4c 89 fe 4c 89 e7 48 89 44 24 10 8b 45 28 89 44 24 08 e8 3e e4 ff ff 31 c0 eb bb <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 57 
Dec  5 08:08:31 s5 kernel: [55934.291108] RIP  [<ffffffffa012ef06>] insert_inline_extent_backref+0xc6/0xd0 [btrfs]
Dec  5 08:08:31 s5 kernel: [55934.291113]  RSP <ffff880213d2fbb0>
Dec  5 08:08:31 s5 kernel: [55934.291115] ---[ end trace 1d59cb77367fac46 ]---
Dec  5 08:08:31 s5 kernel: [55934.291117] note: btrfs-transacti[465] exited with preempt_count 1

-- 
Wolfgang
