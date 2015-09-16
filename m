Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36187 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbIPSxV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 14:53:21 -0400
Received: by qkcf65 with SMTP id f65so90681542qkc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 11:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AE93C5.6000505@friedels.name>
References: <55AE93C5.6000505@friedels.name>
Date: Wed, 16 Sep 2015 21:53:19 +0300
Message-ID: <CAOE4rSwfwDuSnqYy86KX1BQik=3UZRggUUG9VGX=ATp1taGreQ@mail.gmail.com>
Subject: Re: kernel BUG at ctree.c:5196
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: Hendrik Friedel <root@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-07-21 21:47 GMT+03:00 Hendrik Friedel <root@friedels.name>:
> Hello,
>
> I recently added a third device to my raid and converted it from raid0 to
> raid 5 via balance (dconvert, mconvert).
> Unfortunately, the new device was faulty. I wrote about this on this List in
> "size 2.73TiB used 240.97GiB after balance".
>
> Initially the system was very unstable when trying to access this volume
> (even with ro, degraded, recovery), but
> now I was able to recover the data from the disk. I think it helped to
> attach the disk directly rather than in its USB-Enclosure.
>
> Now I have two remaining points:
> a) I want to contribute to making btrfs more stable
> b) I would like to repair the volume
>
> When running btrfs check --repair, I get:
> btrfs check --repair /dev/sdb
> enabling repair mode
> Checking filesystem on /dev/sdb
> UUID: b4a6cce6-dc9c-4a13-80a4-ed6bc5b40bb8
> checking extents
> parent transid verify failed on 8300132024320 wanted 114915 found 114837
> parent transid verify failed on 8300132024320 wanted 114915 found 114837
> checksum verify failed on 8300132024320 found C3925FB7 wanted 2771E201
> parent transid verify failed on 8300132024320 wanted 114915 found 114837
> Ignoring transid failure
> parent transid verify failed on 8300132024320 wanted 114915 found 114837
> Ignoring transid failure
> owner ref check failed [8300132024320 16384]
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.
> btrfs[0x442311]
> btrfs(btrfs_reserve_extent+0x8a4)[0x4477f5]
> btrfs(btrfs_alloc_free_block+0x57)[0x447b43]
> btrfs(__btrfs_cow_block+0x163)[0x4389f7]
> btrfs(btrfs_cow_block+0xd0)[0x439304]
> btrfs(btrfs_search_slot+0x16f)[0x43b996]
> btrfs[0x420dcb]
> btrfs[0x4284d6]
> btrfs(cmd_check+0x14a9)[0x42a464]
> btrfs(main+0x153)[0x409f37]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f22b8161ec5]
> btrfs[0x409af9]
>
>
> When now running a balance (dconvert=raid0 mconvert=raid0) this shows up in
> the syslog:
>
> Jul 19 22:43:33 homeserver kernel: [  219.670944] BTRFS: checking UUID tree
> |
> Jul 19 22:43:33 homeserver kernel: [  219.670951] BTRFS info (device sde):
> continuing balance                                   |
> Jul 19 22:43:35 homeserver kernel: [  221.108745] BTRFS info (device sde):
> relocating block group 8175533162496 flags 1         |
> Jul 19 22:43:35 homeserver kernel: [  221.392879] BTRFS (device sde): parent
> transid verify failed on 8300132024320 wanted 11491|
> 5 found 114837 |
> Jul 19 22:43:35 homeserver kernel: [  221.409515] BTRFS (device sde): parent
> transid verify failed on 8300132024320 wanted 11491|
> 5 found 114837 |
> Jul 19 22:43:35 homeserver kernel: [  221.409564] kernel BUG at
> /home/kernel/COD/linux/fs/btrfs/ctree.c:5196!                   |
> Jul 19 22:43:35 homeserver kernel: [  221.409594] Modules linked in:
> ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ip|
> v4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcp|
> udp ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables
> x_tables autofs4 bridge stp llc nfsd auth_rpcgss nf|
> s_acl nfs lockd binfmt_misc grace sunrpc fscache stv6110x lnbp21 intel_rapl
> iosf_mbi x86_pkg_temp_thermal intel_powerclamp coret|
> emp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_gener|
> ic stv090x cryptd snd_hda_intel snd_hda_controller snd_hda_codec
> snd_hda_core serio_raw snd_hwdep ddbridge snd_pcm i915 cxd2099(|
> C) dvb_core snd_seq_midi media snd_seq_midi_event snd_rawmidi snd_seq
> snd_seq_device snd_timer lpc_ich drm_kms_helper snd drm i2|
> c_algo_bit soundcore mei_me shpchp mei video mac_hid lp parport btrfs raid10
> raid456 async_raid6_recov async_memcpy async_pq asy|
> nc_xor async_tx xor raid6_pq raid1 hid_generic raid0 e1000e usbhid multipath
> linear psmouse ptp ahci libahci hid pps_core       |
> Jul 19 22:43:35 homeserver kernel: [  221.409923] CPU: 0 PID: 4529 Comm:
> btrfs-uuid Tainted: G         C      4.1.0-040100rc5-ge|
> neric #201505250235 |
> Jul 19 22:43:35 homeserver kernel: [  221.409989] RIP:
> 0010:[<ffffffffc01687b2>]  [<ffffffffc01687b2>] btrfs_search_forward+0x31|
> 2/0x330 [btrfs] |
> Jul 19 22:43:35 homeserver kernel: [  221.410261] [<ffffffffc0160a47>] ?
> btrfs_release_path+0x77/0xb0 [btrfs]                  |
> Jul 19 22:43:35 homeserver kernel: [  221.410289] [<ffffffffc01b243c>]
> btrfs_uuid_scan_kthread+0xec/0x3b0 [btrfs]              |
> Jul 19 22:43:35 homeserver kernel: [  221.410317] [<ffffffffc01b2700>] ?
> btrfs_uuid_scan_kthread+0x3b0/0x3b0 [btrfs]           |
> Jul 19 22:43:35 homeserver kernel: [  221.410343] [<ffffffffc01b2732>]
> btrfs_uuid_rescan_kthread+0x32/0x70 [btrfs]             |
> Jul 19 22:43:35 homeserver kernel: [  221.410525] RIP [<ffffffffc01687b2>]
> btrfs_search_forward+0x312/0x330 [btrfs]
>
> I can now play a bit with the file-system if valuable for you.
> When being able to recover, I would also profit, because I save a bit of
> time getting all data together again (now spread over drives),  but it's not
> major.
>
> Please advise, if it would be useful to further research this.
>
> Greetings,
> Hendrik
>

I think I've hit this same bug on v4.2.0

5119: int btrfs_search_forward(struct btrfs_root *root, struct
btrfs_key *min_key, struct btrfs_path *path, u64 min_trans)
...
5198:        btrfs_set_path_blocking(path);
5199:        cur = read_node_slot(root, cur, slot);
5200:        BUG_ON(!cur); /* -ENOMEM */

kernel: kernel BUG at /mnt/Linux/linux/fs/btrfs/ctree.c:5200!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP
kernel: Modules linked in: fuse nvidia(O) nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_filter
ebtable_broute bridge stp llc ebtable_nat ebtables ip6tabl
kernel:  tveeprom k10temp snd_hda_codec_generic fam15h_power rc_core
snd_hda_intel r8169 ablk_helper serio_raw cryptd edac_core
edac_mce_amd snd_hda_codec videobuf2_dma_sg videobuf2_memops mii
snd_hda_core videobuf2_core v4l2_common snd_hwdep videodev
kernel:  x_tables [last unloaded: drm_kms_helper]
kernel: CPU: 4 PID: 19038 Comm: btrfs Tainted: G        W  O
4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: task: ffff88006d23f000 ti: ffff880100b9c000 task.ti: ffff880100b9c000
kernel: RIP: 0010:[<ffffffffa0590448>]  [<ffffffffa0590448>]
btrfs_search_forward+0x268/0x350 [btrfs]
kernel: RSP: 0018:ffff880100b9fb48  EFLAGS: 00010246
kernel: RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
kernel: RDX: 0000000000000001 RSI: 0000000001410000 RDI: ffff88010e5d47c8
kernel: RBP: ffff880100b9fbb8 R08: 0000000001400000 R09: 0000000001c00000
kernel: R10: ffffffffa05de4f9 R11: 0000000000000125 R12: ffff88004ce5aa20
kernel: R13: 0000000000000001 R14: ffff88004ce5aa24 R15: 0000000000000001
kernel: FS:  00007f7086da78c0(0000) GS:ffff88022ed00000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
kernel: CR2: 00007f7085ee1f20 CR3: 000000014667b000 CR4: 00000000000406e0
kernel: Stack:
kernel:  0000000000000000 ffff880100b9fc0f ffff8800cd950000 0000000000000000
kernel:  0100000000000000 d800000000000000 0000000000000001 00000000cc13abb8
kernel:  ffff880100b9fc78 ffff88004ce5aa20 ffff880100b9fc78 ffff880225330000
kernel: Call Trace:
kernel:  [<ffffffffa05e8bc2>] search_ioctl+0xf2/0x1c0 [btrfs]
kernel:  [<ffffffffa05e8d01>] btrfs_ioctl_tree_search.isra.12+0x71/0xc0 [btrfs]
kernel:  [<ffffffffa05eb771>] btrfs_ioctl+0x451/0x2ac0 [btrfs]
kernel:  [<ffffffff811df61e>] ? filename_lookup+0xbe/0x140
kernel:  [<ffffffff811d53e4>] ? inode_get_bytes+0x44/0x60
kernel:  [<ffffffff811d56e1>] ? cp_new_stat+0x121/0x150
kernel:  [<ffffffff811e2735>] do_vfs_ioctl+0x295/0x480
kernel:  [<ffffffff811d5b59>] ? SyS_newfstat+0x39/0x60
kernel:  [<ffffffff811e2999>] SyS_ioctl+0x79/0x90
kernel:  [<ffffffff8156c4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
kernel: Code: 8b 45 a8 8b 4d 90 4c 89 e6 48 8b 55 98 48 8b 7d a0 e8 3d
fb ff ff 85 c0 0f 85 ca 00 00 00 4c 89 e7 e8 5d 7c ff ff e9 e8 fd ff
ff <0f> 0b 48 8d 04 92 4d 63 ed 48 8d 75 b7 43 89 54 ac 40 b9 11 00
kernel: RIP  [<ffffffffa0590448>] btrfs_search_forward+0x268/0x350 [btrfs]
kernel:  RSP <ffff880100b9fb48>
kernel: ---[ end trace 4d8290e0e7c141fd ]---
kernel: BTRFS error (device sdi2): cleaner transaction attach returned -30
kernel: BTRFS warning (device sdi2): page private not zero on page 21020672
kernel: BTRFS warning (device sdi2): page private not zero on page 21024768
kernel: BTRFS warning (device sdi2): page private not zero on page 21028864
kernel: BTRFS warning (device sdi2): page private not zero on page 21032960
kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: ata21: end_device-7:7: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata21: end_device-7:7: dev error handler
kernel: ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
kernel: ata21.00: failed command: READ SECTOR(S) EXT
kernel: ata21.00: cmd 24/00:01:91:89:c1/00:00:28:00:00/e0 tag 10 pio 512 in
                                           res
51/40:00:91:89:c1/00:00:28:00:00/00 Emask 0x9 (media error)
kernel: ata21.00: status: { DRDY ERR }
kernel: ata21.00: error: { UNC }
kernel: ata21.00: configured for UDMA/133
kernel: ata21: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1



Basically SMART reported that few sectors became unreadable and then after
several reboots and some data usage it happened

kernel: sas: Enter sas_scsi_recover_host busy: 1 failed: 1
kernel: sas: ata14: end_device-7:7: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
kernel: ata14.00: failed command: READ SECTOR(S) EXT
kernel: ata14.00: cmd 24/00:01:73:65:c1/00:00:28:00:00/e0 tag 17 pio 512 in
                                           res
51/40:00:73:65:c1/00:00:28:00:00/00 Emask 0x9 (media error)
kernel: ata14.00: status: { DRDY ERR }
kernel: ata14.00: error: { UNC }
kernel: ata14.00: configured for UDMA/133
kernel: ata14: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: BTRFS: checksum error at logical 345782280192 on dev
/dev/sdi2, sector 620846448, root 257, inode 16555777, offset
28499968, length 4096, links 1 (path: ...)
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical 345782280192
on dev /dev/sdi2
kernel: sas: Enter sas_scsi_recover_host busy: 2 failed: 2
kernel: sas: trying to find task 0xffff88018fb52000
kernel: sas: sas_scsi_find_task: aborting task 0xffff88018fb52000
kernel: sas: sas_scsi_find_task: task 0xffff88018fb52000 is aborted
kernel: sas: sas_eh_handle_sas_errors: task 0xffff88018fb52000 is aborted
kernel: sas: ata14: end_device-7:7: cmd error handler
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata14: end_device-7:7: dev error handler
kernel: ata14.00: exception Emask 0x1 SAct 0x300 SErr 0x0 action 0x6 frozen
kernel: ata14.00: failed command: READ FPDMA QUEUED
kernel: ata14.00: cmd 60/00:00:00:88:c1/04:00:28:00:00/40 tag 8 ncq 524288 in
                                           res
41/04:00:91:89:c1/00:04:28:00:00/00 Emask 0x5 (timeout)
kernel: ata14.00: status: { DRDY ERR }
kernel: ata14.00: error: { ABRT }
kernel: ata14.00: failed command: READ FPDMA QUEUED
kernel: ata14.00: cmd 60/78:00:a8:3e:7f/01:00:04:00:00/40 tag 9 ncq 192512 in
                                           res
41/04:00:91:89:c1/00:04:28:00:00/00 Emask 0x1 (device error)
kernel: ata14.00: status: { DRDY ERR }
kernel: ata14.00: error: { ABRT }
kernel: ata14: hard resetting link
kernel: sas: sas_form_port: phy3 belongs to port7 already(1)!
kernel: ata14.00: failed to IDENTIFY (I/O error, err_mask=0x5)
kernel: ata14.00: revalidation failed (errno=-5)
kernel: ata14: hard resetting link
kernel: sas: sas_form_port: phy3 belongs to port7 already(1)!
kernel: ata14.00: qc timeout (cmd 0xa1)
kernel: ata14.00: failed to IDENTIFY (I/O error, err_mask=0x5)
kernel: ata14.00: revalidation failed (errno=-5)
kernel: ata14: hard resetting link
kernel: sas: sas_form_port: phy3 belongs to port7 already(1)!
kernel: ata14.00: qc timeout (cmd 0xa1)
kernel: ata14.00: failed to IDENTIFY (I/O error, err_mask=0x5)
kernel: ata14.00: revalidation failed (errno=-5)
kernel: ata14.00: disabled
kernel: ata14: hard resetting link
kernel: sas: sas_form_port: phy3 belongs to port7 already(1)!
kernel: ata14: EH complete
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 04 7f 3e a8 00 01 78 00
kernel: blk_update_request: I/O error, dev sdi, sector 75447976
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 1, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#1 CDB: opcode=0x28 28 00 28 c1 88 00 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 683771904
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 c1 88 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683771904
kernel: sd 7:0:7:0: [sdi] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#3 CDB: opcode=0x28 28 00 28 c1 8b 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683772672
kernel: sd 7:0:7:0: [sdi] tag#1 CDB: opcode=0x28 28 00 1e ab a3 a0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 514565024
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 2, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#2 CDB: opcode=0x28 28 00 28 c1 89 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683772160
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 c1 8a 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683772416
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 1e bb a3 a0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 515613600
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 3, flush 0, corrupt 1, gen 0
kernel: BTRFS: i/o error at logical 345786941440 on dev /dev/sdi2,
sector 620855552, root 257, inode 16555777, offset 33161216, length
4096, links 1 (path: ...)
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 4, flush 0, corrupt 1, gen 0
kernel: BTRFS: i/o error at logical 345786810368 on dev /dev/sdi2,
sector 620855296, root 257, inode 16555777, offset 33030144, length
4096, links 1 (path: ...)
kernel: BTRFS: i/o error at logical 345787072512 on dev /dev/sdi2,
sector 620855808, root 257, inode 16555777, offset 33292288, length
4096, links 1 (path: ...)
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 5, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 6, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#1 CDB: opcode=0x28 28 00 28 c1 88 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683771904
kernel: sd 7:0:7:0: [sdi] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: BTRFS: unable to fixup (regular) error at logical 345786810368
on dev /dev/sdi2
kernel: sd 7:0:7:0: [sdi] tag#2 CDB: opcode=0x28 28 00 28 c1 8a 00 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 683772416
kernel: BTRFS: unable to fixup (regular) error at logical 345787072512
on dev /dev/sdi2
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 7, flush 0, corrupt 1, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical 345786941440
on dev /dev/sdi2
kernel: BTRFS: i/o error at logical 345787203584 on dev /dev/sdi2,
sector 620856064, root 257, inode 16555777, offset 33423360, length
4096, links 1 (path: ...)
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 8, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 9, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 0, rd 10, flush 0, corrupt 1, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical 345787203584
on dev /dev/sdi2
kernel: BTRFS: i/o error at logical 345787076608 on dev /dev/sdi2,
sector 620855816, root 257, inode 16555777, offset 33296384, length
4096, links 1 (path: ...)
kernel: BTRFS: i/o error at logical 345786814464 on dev /dev/sdi2,
sector 620855304, root 257, inode 16555777, offset 33034240, length
4096, links 1 (path: ...)
kernel: BTRFS: i/o error at logical 345787207680 on dev /dev/sdi2,
sector 620856072, root 257, inode 16555777, offset 33427456, length
4096, links 1 (path: ...)
kernel: BTRFS: unable to fixup (regular) error at logical 345787076608
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 345787207680
on dev /dev/sdi2
kernel: BTRFS: i/o error at logical 345786945536 on dev /dev/sdi2,
sector 620855560, root 257, inode 16555777, offset 33165312, length
4096, links 1 (path: ...)
kernel: BTRFS: i/o error at logical 345787080704 on dev /dev/sdi2,
sector 620855824, root 257, inode 16555777, offset 33300480, length
4096, links 1 (path: ...)
kernel: BTRFS: unable to fixup (regular) error at logical 345786945536
on dev /dev/sdi2
kernel: BTRFS: i/o error at logical 345787211776 on dev /dev/sdi2,
sector 620856080, root 257, inode 16555777, offset 33431552, length
4096, links 1 (path: ...)
kernel: BTRFS: unable to fixup (regular) error at logical 345787211776
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 345787080704
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 345786949632
on dev /dev/sdi2
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 2 PID: 19188 at
/mnt/Linux/linux/fs/btrfs/extent-tree.c:6264
__btrfs_free_extent.isra.34+0x2ef/0xd70 [btrfs]()
kernel: BTRFS: Transaction aborted (error -5)
kernel: Modules linked in: fuse nvidia(O) nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_filter
ebtable_broute bridge stp llc ebtable_nat ebtables ip6table_security
ip6table_raw ip6table_mangle ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_filter ip6_tables iptable_security
iptable_raw iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter efifb
kvm_amd mousedev joydev input_leds led_class snd_usb_audio
snd_usbmidi_lib kvm snd_rawmidi crct10dif_pclmul hid_generic
crc32_pclmul snd_seq_device ghash_clmulni_intel aesni_intel aes_x86_64
saa7134_alsa lrw gf128mul saa7134 pcspkr snd_hda_codec_hdmi
snd_hda_codec_realtek glue_helper
kernel:  tveeprom k10temp snd_hda_codec_generic fam15h_power rc_core
snd_hda_intel r8169 ablk_helper serio_raw cryptd edac_core
edac_mce_amd snd_hda_codec videobuf2_dma_sg videobuf2_memops mii
snd_hda_core videobuf2_core v4l2_common snd_hwdep videodev snd_pcm
snd_timer tpm_infineon media snd tpm_tis evdev soundcore sp5100_tco
tpm mac_hid shpchp i2c_piix4 acpi_cpufreq processor nfsd auth_rpcgss
sch_fq_codel nfs oid_registry nfs_acl lockd grace sunrpc fscache btrfs
xor raid6_pq usbhid hid sd_mod ata_generic pata_acpi atkbd libps2
crc32c_intel video mxm_wmi i2c_algo_bit ahci firewire_ohci mvsas
firewire_core libahci xhci_pci crc_itu_t libsas xhci_hcd pata_atiixp
ohci_pci ehci_pci ohci_hcd ehci_hcd scsi_transport_sas drm libata
usbcore i2c_core scsi_mod usb_common wmi i8042 serio button ip_tables
kernel:  x_tables [last unloaded: drm_kms_helper]
kernel: CPU: 2 PID: 19188 Comm: kworker/u16:8 Tainted: G           O
 4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
kernel:  0000000000000000 0000000096a217f8 ffff8801011d7a48 ffffffff81566f6a
kernel:  0000000000000000 ffff8801011d7aa0 ffff8801011d7a88 ffffffff810737a6
kernel:  ffff8800cdcf5800 000000005b910000 00000000fffffffb 0000000000000000
kernel: Call Trace:
kernel:  [<ffffffff81566f6a>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
kernel:  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffffa05964bf>] __btrfs_free_extent.isra.34+0x2ef/0xd70 [btrfs]
kernel:  [<ffffffffa059a402>] __btrfs_run_delayed_refs+0x452/0x10e0 [btrfs]
kernel:  [<ffffffffa05b15ee>] ? join_transaction.isra.3+0x10e/0x410 [btrfs]
kernel:  [<ffffffffa059dd13>] btrfs_run_delayed_refs.part.39+0x73/0x250 [btrfs]
kernel:  [<ffffffffa059df8e>] delayed_ref_async_start+0x7e/0x90 [btrfs]
kernel:  [<ffffffffa05e4547>] btrfs_scrubparity_helper+0x77/0x2e0 [btrfs]
kernel:  [<ffffffffa05e47ee>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
kernel:  [<ffffffff8108b4db>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108b818>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108b7d0>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81091478>] kthread+0xd8/0xf0
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8156c8df>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 4d8290e0e7c141e9 ]---
kernel: BTRFS: error (device sdi2) in __btrfs_free_extent:6264:
errno=-5 IO failure
kernel: BTRFS info (device sdi2): forced readonly
kernel: BTRFS: error (device sdi2) in btrfs_run_delayed_refs:2781:
errno=-5 IO failure
kernel: BTRFS: error (device sdi2) in __btrfs_free_extent:6264:
errno=-5 IO failure
kernel: BTRFS: error (device sdi2) in btrfs_run_delayed_refs:2781:
errno=-5 IO failure
kernel: pending csums is 610304
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965199360 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965203456 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965207552 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965211648 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965215744 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965002752 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965219840 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965223936 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965006848 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
345965228032 on dev /dev/sdi2
kernel: scsi_io_completion: 194706 callbacks suppressed
kernel: scrub_handle_errored_block: 96604 callbacks suppressed
kernel: scrub_handle_errored_block: 96768 callbacks suppressed
kernel: blk_update_request: 194743 callbacks suppressed
kernel: BTRFS: unable to fixup (regular) error at logical 346182340608
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346183000064
on dev /dev/sdi2
kernel: blk_update_request: I/O error, dev sdi, sector 684547920
kernel: sd 7:0:7:0: [sdi] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#2 CDB: opcode=0x28 28 00 28 cd 5d d0 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684547536
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 cd 56 b8 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684545720
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 cd 53 60 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684544864
kernel: BTRFS: unable to fixup (regular) error at logical 346182565888
on dev /dev/sdi2
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 cd 53 68 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684544872
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 cd 51 b0 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684544432
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 03 c8 85 40 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 63472960
kernel: btrfs_dev_stat_print_on_error: 97485 callbacks suppressed
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96893, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 03 c8 85 40 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 63472960
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96894, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#1 CDB: opcode=0x28 28 00 28 cd 54 88 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684545160
kernel: BTRFS: unable to fixup (regular) error at logical 346182717440
on dev /dev/sdi2
kernel: sd 7:0:7:0: [sdi] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#2 CDB: opcode=0x28 28 00 28 cd 5f 08 00 00 08 00
kernel: blk_update_request: I/O error, dev sdi, sector 684547848
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 cd 54 90 00 00 08 00
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96895, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96896, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96897, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96898, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96899, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96900, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96901, flush 0, corrupt 1, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical 346184130560
on dev /dev/sdi2
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 96902, flush 0, corrupt 1, gen 0
kernel: BTRFS: unable to fixup (regular) error at logical 346183933952
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346183938048
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346183942144
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346183946240
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346183950336
on dev /dev/sdi2
kernel: scrub_fixup_nodatasum: 118 callbacks suppressed
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601852928 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601984000 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601857024 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601861120 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601865216 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601869312 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601988096 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601873408 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601877504 on dev /dev/sdi2
kernel: BTRFS: unable to fixup (nodatasum) error at logical
346601992192 on dev /dev/sdi2
kernel: scsi_io_completion: 205523 callbacks suppressed
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 df e8 00 04 00 00
kernel: blk_update_request: 205545 callbacks suppressed
kernel: blk_update_request: I/O error, dev sdi, sector 685367272
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 e3 e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685368296
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 e7 e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685369320
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 eb e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685370344
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 ef e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685371368
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 f3 e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685372392
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 f7 e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685373416
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 fb e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685374440
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 d9 ff e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685375464
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 28 da 03 e8 00 04 00 00
kernel: blk_update_request: I/O error, dev sdi, sector 685376488
kernel: scrub_handle_errored_block: 102332 callbacks suppressed
kernel: scrub_handle_errored_block: 102266 callbacks suppressed
kernel: BTRFS: unable to fixup (regular) error at logical 346604032000
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604036096
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604040192
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604044288
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604048384
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604052480
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604056576
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604060672
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604163072
on dev /dev/sdi2
kernel: BTRFS: unable to fixup (regular) error at logical 346604064768
on dev /dev/sdi2
kernel: btrfs_dev_stat_print_on_error: 102500 callbacks suppressed
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199417, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199418, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199419, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199420, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199421, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199422, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199423, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199424, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199425, flush 0, corrupt 1, gen 0
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 199426, flush 0, corrupt 1, gen 0
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: scsi_io_completion: 123510 callbacks suppressed
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a a1 ae c0 00 00 20 00
kernel: blk_update_request: 123534 callbacks suppressed
kernel: blk_update_request: I/O error, dev sdi, sector 178368192
kernel: btrfs_dev_stat_print_on_error: 61506 callbacks suppressed
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260946, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a b1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 179416768
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260947, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a a1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 178368192
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260948, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a b1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 179416768
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260949, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a a1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 178368192
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260950, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a b1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 179416768
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260951, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a a1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 178368192
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260952, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a b1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 179416768
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260953, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a a1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 178368192
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260954, flush 0, corrupt 1, gen 0
kernel: sd 7:0:7:0: [sdi] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x04
driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] tag#0 CDB: opcode=0x28 28 00 0a b1 ae c0 00 00 20 00
kernel: blk_update_request: I/O error, dev sdi, sector 179416768
kernel: BTRFS: bdev /dev/sdi2 errs: wr 620, rd 260955, flush 0, corrupt 1, gen 0
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: program smartctl is using a deprecated SCSI ioctl, please
convert it to SG_IO
kernel: sd 7:0:7:0: [sdi] Synchronizing SCSI cache
kernel: sd 7:0:7:0: [sdi] Synchronize Cache(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: sd 7:0:7:0: [sdi] Stopping disk
kernel: sd 7:0:7:0: [sdi] Start/Stop Unit failed: Result:
hostbyte=0x04 driverbyte=0x00
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 5 PID: 156 at
/mnt/Linux/linux/fs/sysfs/group.c:224 sysfs_remove_group+0x93/0xa0()
kernel: sysfs group ffffffff818a0480 not found for kobject 'end_device-7:7'
kernel: Modules linked in: fuse nvidia(O) nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_filter
ebtable_broute bridge stp llc ebtable_nat ebtables ip6table_security
ip6table_raw ip6table_mangle ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_filter ip6_tables iptable_security
iptable_raw iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter efifb
kvm_amd mousedev joydev input_leds led_class snd_usb_audio
snd_usbmidi_lib kvm snd_rawmidi crct10dif_pclmul hid_generic
crc32_pclmul snd_seq_device ghash_clmulni_intel aesni_intel aes_x86_64
saa7134_alsa lrw gf128mul saa7134 pcspkr snd_hda_codec_hdmi
snd_hda_codec_realtek glue_helper
kernel:  tveeprom k10temp snd_hda_codec_generic fam15h_power rc_core
snd_hda_intel r8169 ablk_helper serio_raw cryptd edac_core
edac_mce_amd snd_hda_codec videobuf2_dma_sg videobuf2_memops mii
snd_hda_core videobuf2_core v4l2_common snd_hwdep videodev snd_pcm
snd_timer tpm_infineon media snd tpm_tis evdev soundcore sp5100_tco
tpm mac_hid shpchp i2c_piix4 acpi_cpufreq processor nfsd auth_rpcgss
sch_fq_codel nfs oid_registry nfs_acl lockd grace sunrpc fscache btrfs
xor raid6_pq usbhid hid sd_mod ata_generic pata_acpi atkbd libps2
crc32c_intel video mxm_wmi i2c_algo_bit ahci firewire_ohci mvsas
firewire_core libahci xhci_pci crc_itu_t libsas xhci_hcd pata_atiixp
ohci_pci ehci_pci ohci_hcd ehci_hcd scsi_transport_sas drm libata
usbcore i2c_core scsi_mod usb_common wmi i8042 serio button ip_tables
kernel:  x_tables [last unloaded: drm_kms_helper]
kernel: CPU: 5 PID: 156 Comm: kworker/u16:7 Tainted: G        W  O
4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000da64764e ffff88021c0a7bf8 ffffffff81566f6a
kernel:  0000000000000000 ffff88021c0a7c50 ffff88021c0a7c38 ffffffff810737a6
kernel:  ffff88021c0a7c38 0000000000000000 ffffffff818a0480 ffff88021d2aac10
kernel: Call Trace:
kernel:  [<ffffffff81566f6a>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
kernel:  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124519c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff81248783>] sysfs_remove_group+0x93/0xa0
kernel:  [<ffffffff813dae37>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ce7e8>] device_del+0x58/0x260
kernel:  [<ffffffff813cea12>] device_unregister+0x22/0x70
kernel:  [<ffffffff812a07f0>] bsg_unregister_queue+0x60/0xb0
kernel:  [<ffffffffa005368c>] sas_rphy_remove+0x4c/0x80 [scsi_transport_sas]
kernel:  [<ffffffffa00536d6>] sas_rphy_delete+0x16/0x30 [scsi_transport_sas]
kernel:  [<ffffffffa02ef8a3>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff8108b4db>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108b818>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108b7d0>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff8108b7d0>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81091478>] kthread+0xd8/0xf0
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8156c8df>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 4d8290e0e7c141ea ]---
kernel: mvsas 0000:07:00.0: Phy3 : No sig fis
kernel: sas: phy-7:7 added to port-7:7, phy_mask:0x8 ( 700000000000000)
kernel: sas: DOING DISCOVERY on port 7, pid:14309
kernel: sas: DONE DISCOVERY on port 7, pid:14309, result:0
kernel: sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata20: end_device-7:7: dev error handler
kernel: ata20.00: ATA-8: MAXTOR STM3500320AS, MX1A, max UDMA/133
kernel: ata20.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
kernel: ata20.00: configured for UDMA/133
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: scsi 7:0:8:0: Direct-Access     ATA      MAXTOR STM350032 MX1A
PQ: 0 ANSI: 5
kernel: sd 7:0:8:0: [sdo] 976773168 512-byte logical blocks: (500 GB/465 GiB)
kernel: sd 7:0:8:0: [sdo] Write Protect is off
kernel: sd 7:0:8:0: [sdo] Mode Sense: 00 3a 00 00
kernel: sd 7:0:8:0: [sdo] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
kernel:  sdo: sdo1 sdo2
kernel: sd 7:0:8:0: [sdo] Attached SCSI disk
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 4 PID: 31049 at
/mnt/Linux/linux/fs/sysfs/group.c:224 sysfs_remove_group+0x93/0xa0()
kernel: sysfs group ffffffff818a0480 not found for kobject '7:0:8:0'
kernel: Modules linked in: fuse nvidia(O) nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_filter
ebtable_broute bridge stp llc ebtable_nat ebtables ip6table_security
ip6table_raw ip6table_mangle ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_filter ip6_tables iptable_security
iptable_raw iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter efifb
kvm_amd mousedev joydev input_leds led_class snd_usb_audio
snd_usbmidi_lib kvm snd_rawmidi crct10dif_pclmul hid_generic
crc32_pclmul snd_seq_device ghash_clmulni_intel aesni_intel aes_x86_64
saa7134_alsa lrw gf128mul saa7134 pcspkr snd_hda_codec_hdmi
snd_hda_codec_realtek glue_helper
kernel:  tveeprom k10temp snd_hda_codec_generic fam15h_power rc_core
snd_hda_intel r8169 ablk_helper serio_raw cryptd edac_core
edac_mce_amd snd_hda_codec videobuf2_dma_sg videobuf2_memops mii
snd_hda_core videobuf2_core v4l2_common snd_hwdep videodev snd_pcm
snd_timer tpm_infineon media snd tpm_tis evdev soundcore sp5100_tco
tpm mac_hid shpchp i2c_piix4 acpi_cpufreq processor nfsd auth_rpcgss
sch_fq_codel nfs oid_registry nfs_acl lockd grace sunrpc fscache btrfs
xor raid6_pq usbhid hid sd_mod ata_generic pata_acpi atkbd libps2
crc32c_intel video mxm_wmi i2c_algo_bit ahci firewire_ohci mvsas
firewire_core libahci xhci_pci crc_itu_t libsas xhci_hcd pata_atiixp
ohci_pci ehci_pci ohci_hcd ehci_hcd scsi_transport_sas drm libata
usbcore i2c_core scsi_mod usb_common wmi i8042 serio button ip_tables
kernel:  x_tables [last unloaded: drm_kms_helper]
kernel: CPU: 4 PID: 31049 Comm: kworker/u16:25 Tainted: G        W  O
  4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel: Workqueue: scsi_wq_7 sas_destruct_devices [libsas]
kernel:  0000000000000000 00000000c31d8495 ffff88012317bb68 ffffffff81566f6a
kernel:  0000000000000000 ffff88012317bbc0 ffff88012317bba8 ffffffff810737a6
kernel:  ffff88012317bba8 0000000000000000 ffffffff818a0480 ffff880224223410
kernel: Call Trace:
kernel:  [<ffffffff81566f6a>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
kernel:  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffff8124519c>] ? kernfs_find_and_get_ns+0x4c/0x60
kernel:  [<ffffffff81248783>] sysfs_remove_group+0x93/0xa0
kernel:  [<ffffffff813dae37>] dpm_sysfs_remove+0x57/0x60
kernel:  [<ffffffff813ce7e8>] device_del+0x58/0x260
kernel:  [<ffffffff813cea12>] device_unregister+0x22/0x70
kernel:  [<ffffffff812a07f0>] bsg_unregister_queue+0x60/0xb0
kernel:  [<ffffffffa00a9846>] __scsi_remove_device+0xa6/0xd0 [scsi_mod]
kernel:  [<ffffffffa00a9896>] scsi_remove_device+0x26/0x40 [scsi_mod]
kernel:  [<ffffffffa00a9a3f>] scsi_remove_target+0x15f/0x230 [scsi_mod]
kernel:  [<ffffffffa00536a8>] sas_rphy_remove+0x68/0x80 [scsi_transport_sas]
kernel:  [<ffffffffa00536d6>] sas_rphy_delete+0x16/0x30 [scsi_transport_sas]
kernel:  [<ffffffffa02ef8a3>] sas_destruct_devices+0x63/0x90 [libsas]
kernel:  [<ffffffff8108b4db>] process_one_work+0x14b/0x440
kernel:  [<ffffffff8108b818>] worker_thread+0x48/0x4a0
kernel:  [<ffffffff8108b7d0>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff8108b7d0>] ? process_one_work+0x440/0x440
kernel:  [<ffffffff81091478>] kthread+0xd8/0xf0
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8156c8df>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace 4d8290e0e7c141ee ]---
kernel: mvsas 0000:07:00.0: Phy3 : No sig fis
kernel: sas: phy-7:7 added to port-7:7, phy_mask:0x8 ( 700000000000000)
kernel: sas: DOING DISCOVERY on port 7, pid:18556
kernel: sas: DONE DISCOVERY on port 7, pid:18556, result:0
kernel: sas: Enter sas_scsi_recover_host busy: 0 failed: 0
kernel: sas: ata7: end_device-7:0: dev error handler
kernel: sas: ata8: end_device-7:1: dev error handler
kernel: sas: ata9: end_device-7:2: dev error handler
kernel: sas: ata10: end_device-7:3: dev error handler
kernel: sas: ata11: end_device-7:4: dev error handler
kernel: sas: ata13: end_device-7:6: dev error handler
kernel: sas: ata12: end_device-7:5: dev error handler
kernel: sas: ata21: end_device-7:7: dev error handler
kernel: ata21.00: ATA-8: MAXTOR STM3500320AS, MX1A, max UDMA/133
kernel: ata21.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
kernel: ata21.00: configured for UDMA/133
kernel: sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
kernel: scsi 7:0:9:0: Direct-Access     ATA      MAXTOR STM350032 MX1A
PQ: 0 ANSI: 5
kernel: sd 7:0:9:0: [sdo] 976773168 512-byte logical blocks: (500 GB/465 GiB)
kernel: sd 7:0:9:0: [sdo] Write Protect is off
kernel: sd 7:0:9:0: [sdo] Mode Sense: 00 3a 00 00
kernel: sd 7:0:9:0: [sdo] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
kernel:  sdo: sdo1 sdo2
kernel: sd 7:0:9:0: [sdo] Attached SCSI disk
kernel:  sdo: sdo1 sdo2
kernel: ------------[ cut here ]------------
kernel: kernel BUG at /mnt/Linux/linux/fs/btrfs/ctree.c:5200!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP


then later some more sectors became unreadable and it didn't mount anymore

kernel: BTRFS info (device sdi2): enabling auto defrag
kernel: BTRFS info (device sdi2): disk space caching is enabled
kernel: BTRFS: has skinny extents
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 32483 at
/mnt/Linux/linux/fs/btrfs/extent-tree.c:2781
btrfs_run_delayed_refs.part.39+0x223/0x250 [btrfs]()
kernel: BTRFS: Transaction aborted (error -17)
kernel: Modules linked in: fuse nvidia(O) nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_filter
ebtable_broute bridge stp llc ebtable_nat ebtables ip6table_security
ip6table_raw ip6table_mangle ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_filter ip6_tables iptable_security
iptable_raw iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter efifb
kvm_amd mousedev joydev input_leds led_class snd_usb_audio
snd_usbmidi_lib kvm snd_rawmidi crct10dif_pclmul hid_generic
crc32_pclmul snd_seq_device ghash_clmulni_intel aesni_intel aes_x86_64
saa7134_alsa lrw gf128mul saa7134 pcspkr snd_hda_codec_hdmi
snd_hda_codec_realtek glue_helper
kernel:  tveeprom k10temp snd_hda_codec_generic fam15h_power rc_core
snd_hda_intel r8169 ablk_helper serio_raw cryptd edac_core
edac_mce_amd snd_hda_codec videobuf2_dma_sg videobuf2_memops mii
snd_hda_core videobuf2_core v4l2_common snd_hwdep videodev snd_pcm
snd_timer tpm_infineon media snd tpm_tis evdev soundcore sp5100_tco
tpm mac_hid shpchp i2c_piix4 acpi_cpufreq processor nfsd auth_rpcgss
sch_fq_codel nfs oid_registry nfs_acl lockd grace sunrpc fscache btrfs
xor raid6_pq usbhid hid sd_mod ata_generic pata_acpi atkbd libps2
crc32c_intel video mxm_wmi i2c_algo_bit ahci firewire_ohci mvsas
firewire_core libahci xhci_pci crc_itu_t libsas xhci_hcd pata_atiixp
ohci_pci ehci_pci ohci_hcd ehci_hcd scsi_transport_sas drm libata
usbcore i2c_core scsi_mod usb_common wmi i8042 serio button ip_tables
kernel:  x_tables [last unloaded: drm_kms_helper]
kernel: CPU: 0 PID: 32483 Comm: umount Tainted: G      D W  O
4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 000000008c029f46 ffff88013823fb38 ffffffff81566f6a
kernel:  0000000000000000 ffff88013823fb90 ffff88013823fb78 ffffffff810737a6
kernel:  ffffffffffffffff ffff8801a6f3b508 ffff88019bc06e70 ffff88021b2e8000
kernel: Call Trace:
kernel:  [<ffffffff81566f6a>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
kernel:  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffffa059dec3>] btrfs_run_delayed_refs.part.39+0x223/0x250 [btrfs]
kernel:  [<ffffffffa059df05>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
kernel:  [<ffffffffa062cf3c>] commit_cowonly_roots+0x8b/0x2c2 [btrfs]
kernel:  [<ffffffffa059de64>] ?
btrfs_run_delayed_refs.part.39+0x1c4/0x250 [btrfs]
kernel:  [<ffffffffa061c793>] ? btrfs_qgroup_account_extents+0x83/0x130 [btrfs]
kernel:  [<ffffffffa05b2c6c>] btrfs_commit_transaction+0x5fc/0xca0 [btrfs]
kernel:  [<ffffffffa05b33a1>] ? start_transaction+0x91/0x580 [btrfs]
kernel:  [<ffffffffa05b8544>] ? btrfs_run_delayed_iputs+0x64/0x140 [btrfs]
kernel:  [<ffffffffa05ac603>] btrfs_commit_super+0x93/0xa0 [btrfs]
kernel:  [<ffffffffa05ae115>] close_ctree+0x295/0x340 [btrfs]
kernel:  [<ffffffff811eb578>] ? evict_inodes+0x128/0x150
kernel:  [<ffffffffa0582559>] btrfs_put_super+0x19/0x20 [btrfs]
kernel:  [<ffffffff811d2886>] generic_shutdown_super+0x76/0x100
kernel:  [<ffffffff811d2bb6>] kill_anon_super+0x16/0x30
kernel:  [<ffffffffa0581e58>] btrfs_kill_super+0x18/0x120 [btrfs]
kernel:  [<ffffffff811d2f83>] deactivate_locked_super+0x43/0x70
kernel:  [<ffffffff811d33c4>] deactivate_super+0x64/0x70
kernel:  [<ffffffff811ef113>] cleanup_mnt+0x43/0x90
kernel:  [<ffffffff811ef1b2>] __cleanup_mnt+0x12/0x20
kernel:  [<ffffffff8108f6fb>] task_work_run+0x9b/0xb0
kernel:  [<ffffffff81014b09>] do_notify_resume+0x69/0x70
kernel:  [<ffffffff8156c6bc>] int_signal+0x12/0x17
kernel: ---[ end trace 4d8290e0e7c1420a ]---
kernel: BTRFS: error (device sdi2) in btrfs_run_delayed_refs:2781:
errno=-17 Object already exists
kernel: BTRFS info (device sdi2): forced readonly
kernel: BTRFS warning (device sdi2): Skipping commit of aborted transaction.
kernel: BTRFS: error (device sdi2) in cleanup_transaction:1710:
errno=-17 Object already exists
kernel: BTRFS error (device sdi2): commit super ret -17
kernel: BTRFS error (device sdi2): cleaner transaction attach returned -30



I did

$ btrfs check --repair

then mounted it, deleted affected file and executed scrub which
completed succesfully without any errors,
now filesystem seems to be working fine.
