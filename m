Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:20215 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbLDH7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 02:59:50 -0500
Received: from i5.rohdewald.de (p5B3E0613.dip0.t-ipconnect.de [91.62.6.19])
	by smtp.strato.de (RZmta 37.14 DYNA|AUTH)
	with ESMTPSA id 604712rB47xjrAv
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Fri, 4 Dec 2015 08:59:45 +0100 (CET)
Received: from i5.localnet (localhost.localdomain [127.0.0.1])
	by i5.rohdewald.de (Postfix) with ESMTP id 2A50B5E0CB5
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Dec 2015 08:59:48 +0100 (CET)
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: linux-btrfs@vger.kernel.org
Reply-To: wolfgang.kde@rohdewald.de
Subject: Linux 4.3 call traces for defective disk
Date: Fri, 04 Dec 2015 08:59:47 +0100
Message-ID: <1563605.SnxpqFhaza@i5>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a defect disk which produced kernel backtraces like
(see below).

Are you interested in them, what else do you need to know, do you
prefer things inline or as attachments?

unmodified Linux 4.3 tainted with nvidia driver

disk:WDC WD2002FYPS-02W3B0
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       3
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       2
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       1

I mounted the disk normally (no RAID) and copied files from it.
I know I should have mounted readonly ...
Meanwhile the disk data is really corrupt, even after having it cool down overnight.
btrfs check -sX fails for X in 0..5. So since mounting is no longer possible, 
I cannot produce new call traces.

smartctl still says PASSED.

The data loss is no problem.

Dec  4 08:48:08 s5 kernel: [  114.814022] ata5.00: irq_stat 0x40000008
Dec  4 08:48:08 s5 kernel: [  114.814024] ata5.00: failed command: READ FPDMA QUEUED
Dec  4 08:48:08 s5 kernel: [  114.814028] ata5.00: cmd 60/08:60:07:8e:03/00:00:00:00:00/40 tag 12 ncq 4096 in
Dec  4 08:48:08 s5 kernel: [  114.814028]          res 41/40:00:0e:8e:03/00:00:00:00:00/40 Emask 0x409 (media error) <F>
Dec  4 08:48:08 s5 kernel: [  114.814029] ata5.00: status: { DRDY ERR }
Dec  4 08:48:08 s5 kernel: [  114.814030] ata5.00: error: { UNC }
Dec  4 08:48:08 s5 kernel: [  114.822313] ata5.00: configured for UDMA/133
Dec  4 08:48:08 s5 kernel: [  114.822322] sd 4:0:0:0: [sde] tag#12 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
Dec  4 08:48:08 s5 kernel: [  114.822324] sd 4:0:0:0: [sde] tag#12 Sense Key : 0x3 [current] [descriptor] 
Dec  4 08:48:08 s5 kernel: [  114.822326] sd 4:0:0:0: [sde] tag#12 ASC=0x11 ASCQ=0x4 
Dec  4 08:48:08 s5 kernel: [  114.822328] sd 4:0:0:0: [sde] tag#12 CDB: opcode=0x28 28 00 00 03 8e 07 00 00 08 00
Dec  4 08:48:08 s5 kernel: [  114.822329] blk_update_request: I/O error, dev sde, sector 232974
Dec  4 08:48:08 s5 kernel: [  114.822340] ata5: EH complete
Dec  4 08:48:08 s5 kernel: [  114.822360] BTRFS: failed to read tree root on sde1


And this is one of the six backtrace I got: (BTW all six are diffent)

Dec  3 11:39:45 s5 kernel: [ 8393.928639] ata5: link is slow to respond, please be patient (ready=0)
Dec  3 11:39:46 s5 kernel: [ 8395.160246] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  3 11:39:46 s5 kernel: [ 8395.164216] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Dec  3 11:39:46 s5 kernel: [ 8395.164219] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Dec  3 11:39:46 s5 kernel: [ 8395.164220] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  3 11:39:46 s5 kernel: [ 8395.185378] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Dec  3 11:39:46 s5 kernel: [ 8395.185381] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Dec  3 11:39:46 s5 kernel: [ 8395.185383] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  3 11:39:46 s5 kernel: [ 8395.190195] ata5.00: configured for UDMA/133
Dec  3 11:39:46 s5 kernel: [ 8395.204218] ata5: EH complete
Dec  3 11:39:57 s5 kernel: [ 8406.044742] ata5.00: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
Dec  3 11:39:57 s5 kernel: [ 8406.044746] ata5.00: irq_stat 0x00400040, connection status changed
Dec  3 11:39:57 s5 kernel: [ 8406.044747] ata5: SError: { HostInt PHYRdyChg 10B8B DevExch }
Dec  3 11:39:57 s5 kernel: [ 8406.044749] ata5.00: failed command: FLUSH CACHE EXT
Dec  3 11:39:57 s5 kernel: [ 8406.044752] ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 2
Dec  3 11:39:57 s5 kernel: [ 8406.044752]          res 40/00:0c:bf:8f:03/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
Dec  3 11:39:57 s5 kernel: [ 8406.044753] ata5.00: status: { DRDY }
Dec  3 11:39:57 s5 kernel: [ 8406.044756] ata5: hard resetting link
Dec  3 11:40:03 s5 kernel: [ 8411.806856] ata5: link is slow to respond, please be patient (ready=0)
Dec  3 11:40:04 s5 kernel: [ 8413.038465] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec  3 11:40:04 s5 kernel: [ 8413.043051] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Dec  3 11:40:04 s5 kernel: [ 8413.043054] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Dec  3 11:40:04 s5 kernel: [ 8413.043056] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  3 11:40:04 s5 kernel: [ 8413.064667] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
Dec  3 11:40:04 s5 kernel: [ 8413.064670] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Dec  3 11:40:04 s5 kernel: [ 8413.064671] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  3 11:40:04 s5 kernel: [ 8413.069177] ata5.00: configured for UDMA/133
Dec  3 11:40:04 s5 kernel: [ 8413.069180] ata5.00: retrying FLUSH 0xea Emask 0x50
Dec  3 11:40:04 s5 kernel: [ 8413.082443] ata5: EH complete
Dec  3 11:40:35 s5 kernel: [ 8443.399817] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:35 s5 kernel: [ 8443.399822] ------------[ cut here ]------------
Dec  3 11:40:35 s5 kernel: [ 8443.399837] WARNING: CPU: 1 PID: 489 at fs/btrfs/inode.c:930 cow_file_range+0x3f7/0x410 [btrfs]()
Dec  3 11:40:35 s5 kernel: [ 8443.399838] Modules linked in: snd_hda_codec_hdmi(E) joydev(E) rc_tt_1500(E) stb6100(E) lnbp22(E) x86_pkg_temp_thermal(E) intel_power
clamp(E) coretemp(E) kvm_intel(E) stb0899(E) kvm(E) nvidia(POE) crct10dif_pclmul(E) dvb_usb_pctv452e(E) ttpci_eeprom(E) dvb_usb(E) dvb_core(E) crc32_pclmul(E) rc_c
ore(E) ftdi_sio(E) hid_logitech_hidpp(E) usbserial(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) rfcomm(E) bnep(E) cryptd(E) blu
etooth(E) microcode(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) serio_raw(E) snd_hda_intel(E) snd_seq_midi(E) snd_hda_codec(E) snd_seq_midi_event(E) snd_h
da_core(E) snd_hwdep(E) snd_rawmidi(E) snd_pcm(E) snd_seq(E) snd_seq_device(E) snd_timer(E) tpm_tis(E) snd(E) soundcore(E) mei_me(E) shpchp(E) mei(E) lpc_ich(E) nf
sd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) btrfs(E) xor(E) raid6_pq(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) sd_mod
(E) psmouse(E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E) video(E)
Dec  3 11:40:35 s5 kernel: [ 8443.399875] CPU: 1 PID: 489 Comm: btrfs-transacti Tainted: P           OE   4.3.0+55 #1
Dec  3 11:40:35 s5 kernel: [ 8443.399876] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0323.2013.1204.1726 12/04/2013
Dec  3 11:40:35 s5 kernel: [ 8443.399877]  ffffffffa01b7cd2 ffff8800d8813720 ffffffff8136cce5 0000000000000000
Dec  3 11:40:35 s5 kernel: [ 8443.399879]  ffff8800d8813758 ffffffff8106c206 00000000ffffffea ffff8800d8813a40
Dec  3 11:40:35 s5 kernel: [ 8443.399881]  ffff8800d88139c4 0000000000000000 ffff88006ac3c800 ffff8800d8813768
Dec  3 11:40:35 s5 kernel: [ 8443.399883] Call Trace:
Dec  3 11:40:35 s5 kernel: [ 8443.399888]  [<ffffffff8136cce5>] dump_stack+0x4e/0x79
Dec  3 11:40:35 s5 kernel: [ 8443.399892]  [<ffffffff8106c206>] warn_slowpath_common+0x86/0xc0
Dec  3 11:40:35 s5 kernel: [ 8443.399894]  [<ffffffff8106c2fa>] warn_slowpath_null+0x1a/0x20
Dec  3 11:40:35 s5 kernel: [ 8443.399903]  [<ffffffffa01434b7>] cow_file_range+0x3f7/0x410 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399907]  [<ffffffff81095f2d>] ? get_parent_ip+0xd/0x50
Dec  3 11:40:35 s5 kernel: [ 8443.399916]  [<ffffffffa015e16b>] ? release_extent_buffer+0x2b/0xc0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399925]  [<ffffffffa015e64b>] ? free_extent_buffer+0x4b/0x90 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399932]  [<ffffffffa0143842>] run_delalloc_nocow+0x372/0xab0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399939]  [<ffffffffa0143fe5>] run_del alloc_range+0x65/0x3b0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399948]  [<ffffffffa015a8bc>] ? find_lock_delalloc_range.constprop.41+0x1ac/0x1e0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399956]  [<ffffffffa015a9de>] writepage_delalloc.isra.31+0xee/0x140 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399963]  [<ffffffffa015ba8b>] __extent_writepage+0xbb/0x2e0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399966]  [<ffffffff813934e6>] ? __percpu_counter_add+0x86/0xb0
Dec  3 11:40:35 s5 kernel: [ 8443.399974]  [<ffffffffa015bfc7>] extent_write_cache_pages.isra.28.constprop.46+0x317/0x3d0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399981]  [<ffffffffa015db4d>] extent_writepages+0x4d/0x70 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399989]  [<ffffffffa0140ef0>] ? btrfs_real_readdir+0x530/0x530 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.399992]  [<ffffffff81729fba>] ? _raw_spin_unlock+0x1a/0x40
Dec  3 11:40:35 s5 kernel: [ 8443.399999]  [<ffffffffa013e7c8>] btrfs_writepages+0x28/0x30 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400001]  [<ffffffff8116498e>] do_writepages+0x1e/0x30
Dec  3 11:40:35 s5 kernel: [ 8443.400003]  [<ffffffff8115a1aa>] __filemap_fdatawrite_range+0xaa/0xf0
Dec  3 11:40:35 s5 kernel: [ 8443.400005]  [<ffffffff8115a2b3>] filemap_fdatawrite_range+0x13/0x20
Dec  3 11:40:35 s5 kernel: [ 8443.400012]  [<ffffffffa0151da0>] btrfs_fdatawrite_range+0x20/0x50 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400020]  [<ffffffffa017f26c>] __btrfs_write_out_cache.isra.24+0x3ac/0x400 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400028]  [<ffffffffa017fab7>] btrfs_write_out_cache+0x87/0xf0 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400034]  [<ffffffffa0128c1e>] btrfs_write_dirty_block_groups+0x1ee/0x290 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400042]  [<ffffffffa01af8eb>] commit_cowonly_roots+0x21f/0x2c2 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400050]  [<ffffffffa013ca0c>] btrfs_commit_transaction+0x57c/0xb20 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400056]  [<ffffffffa0137a6e>] transaction_kthread+0x19e/0x220 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400062]  [<ffffffffa01378d0>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.400064]  [<ffffffff81089e79>] kthread+0xc9/0xe0
Dec  3 11:40:35 s5 kernel: [ 8443.400066]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  3 11:40:35 s5 kernel: [ 8443.400068]  [<ffffffff8172ac4f>] ret_from_fork+0x3f/0x70
Dec  3 11:40:35 s5 kernel: [ 8443.400069]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  3 11:40:35 s5 kernel: [ 8443.400070] ---[ end trace be7e07e73682720a ]---
Dec  3 11:40:35 s5 kernel: [ 8443.402164] BTRFS (device sde1): parent transid verify failed on 119447552 wanted 33856 found 31288
Dec  3 11:40:35 s5 kernel: [ 8443.402168] ------------[ cut here ]------------
Dec  3 11:40:35 s5 kernel: [ 8443.402176] WARNING: CPU: 1 PID: 489 at fs/btrfs/extent-tree.c:2851 btrfs_run_delayed_refs+0x239/0x290 [btrfs]()
Dec  3 11:40:35 s5 kernel: [ 8443.402177] BTRFS: Transaction aborted (error -5)
Dec  3 11:40:35 s5 kernel: [ 8443.402178] Modules linked in: snd_hda_codec_hdmi(E) joydev(E) rc_tt_1500(E) stb6100(E) lnbp22(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) stb0899(E) kvm(E) nvidia(POE) crct10dif_pclmul(E) dvb_usb_pctv452e(E) ttpci_eeprom(E) dvb_usb(E) dvb_core(E) crc32_pclmul(E) rc_core(E) ftdi_sio(E) hid_logitech_hidpp(E) usbserial(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) rfcomm(E) bnep(E) cryptd(E) bluetooth(E) microcode(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) serio_raw(E) snd_hda_intel(E) snd_seq_midi(E) snd_hda_codec(E) snd_seq_midi_event(E) snd_hda_core(E) snd_hwdep(E) snd_rawmidi(E) snd_pcm(E) snd_seq(E) snd_seq_device(E) snd_timer(E) tpm_tis(E) snd(E) soundcore(E) mei_me(E) shpchp(E) mei(E) lpc_ich(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) btrfs(E) xor(E) raid6_pq(E) hid_logitech_dj(E) hid_generic(E) usbhid(E) hid(E) sd_mod(E) psmouse(E) ahci(E) libahci(E) e1000e(E) ptp(E) pps_core(E) video(E)
Dec  3 11:40:35 s5 kernel: [ 8443.402212] CPU: 1 PID: 489 Comm: btrfs-transacti Tainted: P        W  OE   4.3.0+55 #1
Dec  3 11:40:35 s5 kernel: [ 8443.402213] Hardware name:                  /DH87RL, BIOS RLH8710H.86A.0323.2013.1204.1726 12/04/2013
Dec  3 11:40:35 s5 kernel: [ 8443.402214]  ffffffffa01b73ca ffff8800d8813c50 ffffffff8136cce5 ffff8800d8813c98
Dec  3 11:40:35 s5 kernel: [ 8443.402216]  ffff8800d8813c88 ffffffff8106c206 ffff88020d650170 ffff880214ce6800
Dec  3 11:40:35 s5 kernel: [ 8443.402218]  ffff8801ddea3080 00000000fffffffb 0000000000000000 ffff8800d8813ce8
Dec  3 11:40:35 s5 kernel: [ 8443.402220] Call Trace:
Dec  3 11:40:35 s5 kernel: [ 8443.402224]  [<ffffffff8136cce5>] dump_stack+0x4e/0x79
Dec  3 11:40:35 s5 kernel: [ 8443.402227]  [<ffffffff8106c206>] warn_slowpath_common+0x86/0xc0
Dec  3 11:40:35 s5 kernel: [ 8443.402229]  [<ffffffff8106c28c>] warn_slowpath_fmt+0x4c/0x50
Dec  3 11:40:35 s5 kernel: [ 8443.402235]  [<ffffffffa0127f59>] btrfs_run_delayed_refs+0x239/0x290 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402241]  [<ffffffffa0128b2f>] btrfs_write_dirty_block_groups+0xff/0x290 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402249]  [<ffffffffa01af8eb>] commit_cowonly_roots+0x21f/0x2c2 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402257]  [<ffffffffa013ca0c>] btrfs_commit_transaction+0x57c/0xb20 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402264]  [<ffffffffa0137a6e>] transaction_kthread+0x19e/0x220 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402270]  [<ffffffffa01378d0>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Dec  3 11:40:35 s5 kernel: [ 8443.402273]  [<ffffffff81089e79>] kthread+0xc9/0xe0
Dec  3 11:40:35 s5 kernel: [ 8443.402275]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  3 11:40:35 s5 kernel: [ 8443.402276]  [<ffffffff8172ac4f>] ret_from_fork+0x3f/0x70
Dec  3 11:40:35 s5 kernel: [ 8443.402278]  [<ffffffff81089db0>] ? kthread_create_on_node+0x180/0x180
Dec  3 11:40:35 s5 kernel: [ 8443.402279] ---[ end trace be7e07e73682720b ]---
Dec  3 11:40:35 s5 kernel: [ 8443.402282] BTRFS: error (device sde1) in btrfs_run_delayed_refs:2851: errno=-5 IO failure
Dec  3 11:40:35 s5 kernel: [ 8443.402284] BTRFS info (device sde1): forced readonly
Dec  3 11:40:35 s5 kernel: [ 8443.402296] BTRFS warning (device sde1): Skipping commit of aborted transaction.
Dec  3 11:40:35 s5 kernel: [ 8443.402297] BTRFS: error (device sde1) in cleanup_transaction:1741: errno=-5 IO failure
Dec  3 11:40:59 s5 kernel: [ 8467.302985] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.303003] BTRFS info (device sde1): no csum found for inode 121013263 start 0
Dec  3 11:40:59 s5 kernel: [ 8467.310868] BTRFS warning (device sde1): csum failed ino 121013263 off 0 csum 1824992749 expected csum 0
Dec  3 11:40:59 s5 kernel: [ 8467.313151] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.313157] BTRFS info (device sde1): no csum found for inode 121013263 start 8192
Dec  3 11:40:59 s5 kernel: [ 8467.313460] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.313476] BTRFS info (device sde1): no csum found for inode 121013263 start 12288
Dec  3 11:40:59 s5 kernel: [ 8467.313642] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.313658] BTRFS info (device sde1): no csum found for inode 121013263 start 16384
Dec  3 11:40:59 s5 kernel: [ 8467.313829] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.313845] BTRFS info (device sde1): no csum found for inode 121013263 start 20480
Dec  3 11:40:59 s5 kernel: [ 8467.314070] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.314086] BTRFS info (device sde1): no csum found for inode 121013263 start 24576
Dec  3 11:40:59 s5 kernel: [ 8467.314245] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.314247] BTRFS info (device sde1): no csum found for inode 121013263 start 28672
Dec  3 11:40:59 s5 kernel: [ 8467.314418] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.314420] BTRFS info (device sde1): no csum found for inode 121013263 start 32768
Dec  3 11:40:59 s5 kernel: [ 8467.314651] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.314653] BTRFS info (device sde1): no csum found for inode 121013263 start 36864
Dec  3 11:40:59 s5 kernel: [ 8467.314808] BTRFS (device sde1): parent transid verify failed on 119382016 wanted 33856 found 31287
Dec  3 11:40:59 s5 kernel: [ 8467.314810] BTRFS info (device sde1): no csum found for inode 121013263 start 40960
Dec  3 11:40:59 s5 kernel: [ 8467.315007] BTRFS info (device sde1): no csum found for inode 121013263 start 45056
Dec  3 11:40:59 s5 kernel: [ 8467.315213] BTRFS info (device sde1): no csum found for inode 121013263 start 49152
Dec  3 11:40:59 s5 kernel: [ 8467.315394] BTRFS info (device sde1): no csum found for inode 121013263 start 53248
Dec  3 11:40:59 s5 kernel: [ 8467.315531] BTRFS info (device sde1): no csum found for inode 121013263 start 57344
Dec  3 11:40:59 s5 kernel: [ 8467.315731] BTRFS info (device sde1): no csum found for inode 121013263 start 61440
Dec  3 11:40:59 s5 kernel: [ 8467.315820] BTRFS info (device sde1): no csum found for inode 121013263 start 65536
Dec  3 11:40:59 s5 kernel: [ 8467.315909] BTRFS info (device sde1): no csum found for inode 121013263 start 69632
Dec  3 11:40:59 s5 kernel: [ 8467.316119] BTRFS info (device sde1): no csum found for inode 121013263 start 73728
Dec  3 11:40:59 s5 kernel: [ 8467.316212] BTRFS info (device sde1): no csum found for inode 121013263 start 77824
Dec  3 11:40:59 s5 kernel: [ 8467.316310] BTRFS info (device sde1): no csum found for inode 121013263 start 81920
Dec  3 11:40:59 s5 kernel: [ 8467.316407] BTRFS info (device sde1): no csum found for inode 121013263 start 86016
Dec  3 11:40:59 s5 kernel: [ 8467.316619] BTRFS info (device sde1): no csum found for inode 121013263 start 90112
Dec  3 11:40:59 s5 kernel: [ 8467.316703] BTRFS info (device sde1): no csum found for inode 121013263 start 94208
Dec  3 11:40:59 s5 kernel: [ 8467.316793] BTRFS info (device sde1): no csum found for inode 121013263 start 98304
Dec  3 11:40:59 s5 kernel: [ 8467.317012] BTRFS info (device sde1): no csum found for inode 121013263 start 102400
Dec  3 11:40:59 s5 kernel: [ 8467.317102] BTRFS info (device sde1): no csum found for inode 121013263 start 106496
Dec  3 11:40:59 s5 kernel: [ 8467.331920] BTRFS info (device sde1): no csum found for inode 121013263 start 118784
Dec  3 11:40:59 s5 kernel: [ 8467.332199] BTRFS info (device sde1): no csum found for inode 121013263 start 131072
Dec  3 11:40:59 s5 kernel: [ 8467.344243] BTRFS warning (device sde1): csum failed ino 121013263 off 8192 csum 1179143129 expected csum 0
Dec  3 11:40:59 s5 kernel: [ 8467.344302] BTRFS warning (device sde1): csum failed ino 121013263 off 20480 csum 4208104202 expected csum 0

-- 
Wolfgang
