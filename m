Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33388 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbcF1IRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 04:17:01 -0400
Received: by mail-lf0-f52.google.com with SMTP id f6so5938643lfg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 01:17:00 -0700 (PDT)
MIME-Version: 1.0
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 28 Jun 2016 10:16:58 +0200
Message-ID: <CAEtw4r1OMSwMpoyiaO0oqKM+cWbt0AEo3apwJS5qybG3HsPn-g@mail.gmail.com>
Subject: invalid opcode 0000 / kernel bug with defect HDD
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cause of kernel bugs was a defective HDD (/dev/sdd).

The kernel BUG:

May 16 07:41:38 nas kernel: [37168.832800]
btrfs_dev_stat_print_on_error: 470 callbacks suppressed
May 16 07:41:38 nas kernel: [37168.832806] BTRFS error (device sdd):
bdev /dev/sdb errs: wr 49293, rd 567248, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832843] BTRFS error (device sdd):
bdev /dev/sdf errs: wr 0, rd 537544, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832887] BTRFS error (device sdd):
bdev /dev/sdb errs: wr 49293, rd 567249, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832893] BTRFS error (device sdd):
bdev /dev/sdf errs: wr 0, rd 537545, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832969] BTRFS error (device sdd):
bdev /dev/sdb errs: wr 49293, rd 567250, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832977] BTRFS error (device sdd):
bdev /dev/sdf errs: wr 0, rd 537546, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832987] BTRFS error (device sdd):
bdev /dev/sdb errs: wr 49293, rd 567251, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.832992] BTRFS error (device sdd):
bdev /dev/sdf errs: wr 0, rd 537547, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.862127] BTRFS error (device sdd):
bdev /dev/sdf errs: wr 0, rd 537548, flush 0, corrupt 0, gen 0
May 16 07:41:38 nas kernel: [37168.862188] BTRFS error (device sdd):
bdev /dev/sdb errs: wr 49293, rd 567252, flush 0, corrupt 0, gen 0
May 16 07:41:42 nas kernel: [37173.103386] ------------[ cut here ]------------
May 16 07:41:42 nas kernel: [37173.103414] kernel BUG at
/home/kernel/COD/linux/fs/btrfs/ctree.c:5201!
May 16 07:41:42 nas kernel: [37173.103434] invalid opcode: 0000 [#1] SMP
May 16 07:41:42 nas kernel: [37173.103450] Modules linked in: cpuid
xt_nat veth xt_addrtype xt_conntrack br_netfilter dm_thin_pool
dm_persistent_data dm_bio_prison dm_bufio libcrc32c nvram msr
input_leds joydev hid_generic usbhid hid xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack xt_tcpudp bridge stp
llc iptable_filter ip_tables x_tables autofs4 eeepc_wmi asus_wmi
sparse_keymap intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd
dm_multipath serio_raw snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_codec bnep rfcomm
snd_hda_core bluetooth snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event snd_rawmidi lpc_ich snd_seq snd_seq_device mei_me
snd_timer mei snd soundcore mac_hid shpchp nfsd auth_rpcgss parport_pc
nfs_acl ppdev nfs nct6775 hwmon_vid binfmt_misc coretemp lockd grace
lp parport sunrpc fscache btrfs xor raid6_pq nls_iso8859_1 dm_mirror
dm_region_hash dm_log uas usb_storage i915 e1000e psmouse ahci libahci
i2c_algo_bit drm_kms_helper ptp pps_core syscopyarea sysfillrect
sysimgblt fb_sys_fops drm video fjes wmi
May 16 07:41:42 nas kernel: [37173.103893] CPU: 1 PID: 17784 Comm:
btrfs Tainted: G     U  W       4.5.4-040504-generic #201605120823
May 16 07:41:42 nas kernel: [37173.103916] Hardware name: ASUS All
Series/H87I-PLUS, BIOS 2003 11/05/2014
May 16 07:41:42 nas kernel: [37173.103932] task: ffff88020501c240 ti:
ffff880161f18000 task.ti: ffff880161f18000
May 16 07:41:42 nas kernel: [37173.103950] RIP:
0010:[<ffffffffc02f4bdd>]  [<ffffffffc02f4bdd>]
btrfs_search_forward+0x24d/0x330 [btrfs]
May 16 07:41:42 nas kernel: [37173.103995] RSP: 0018:ffff880161f1bc38
EFLAGS: 00010246
May 16 07:41:42 nas kernel: [37173.104009] RAX: 0000000000000000 RBX:
0000000000000000 RCX: 0000000000000001
May 16 07:41:42 nas kernel: [37173.104029] RDX: 0000000000000001 RSI:
0000091572628000 RDI: ffff8801ff2fa368
May 16 07:41:42 nas kernel: [37173.104048] RBP: ffff880161f1bc98 R08:
0000091571c00000 R09: 00000915b1c00000
May 16 07:41:42 nas kernel: [37173.104067] R10: ffff880161f1ba30 R11:
0000000000000000 R12: ffff8801d71b6930
May 16 07:41:42 nas kernel: [37173.104086] R13: 0000000000000001 R14:
0000000000000000 R15: 0000000000000000
May 16 07:41:42 nas kernel: [37173.104106] FS:  00007ff94d968900(0000)
GS:ffff88021fb00000(0000) knlGS:0000000000000000
May 16 07:41:42 nas kernel: [37173.104129] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May 16 07:41:42 nas kernel: [37173.104144] CR2: 00007ff94ca80a00 CR3:
0000000214a96000 CR4: 00000000000406e0
May 16 07:41:42 nas kernel: [37173.104164] Stack:
May 16 07:41:42 nas kernel: [37173.104173]  00ff880100000000
ffff880161f1bcd7 ffff8800d7699800 c3ff880100000001
May 16 07:41:42 nas kernel: [37173.104203]  0100000000000019
0000000000000000 000000007539a5b8 ffff8801d71b6930
May 16 07:41:42 nas kernel: [37173.104233]  ffff880161f1bd30
0000000000000000 ffff880161f1bcd7 0000000000000000
May 16 07:41:42 nas kernel: [37173.104262] Call Trace:
May 16 07:41:42 nas kernel: [37173.104329]  [<ffffffffc034d81d>]
search_ioctl+0xed/0x1b0 [btrfs]
May 16 07:41:42 nas kernel: [37173.104388]  [<ffffffffc034d952>]
btrfs_ioctl_tree_search+0x72/0xc0 [btrfs]
May 16 07:41:42 nas kernel: [37173.104434]  [<ffffffffc0351f47>]
btrfs_ioctl+0x3f7/0x1ea0 [btrfs]
May 16 07:41:42 nas kernel: [37173.104457]  [<ffffffff811c20d9>] ?
handle_mm_fault+0x1349/0x1ae0
May 16 07:41:42 nas kernel: [37173.104481]  [<ffffffff81228c61>]
do_vfs_ioctl+0xa1/0x5b0
May 16 07:41:42 nas kernel: [37173.104500]  [<ffffffff81228c61>] ?
do_vfs_ioctl+0xa1/0x5b0
May 16 07:41:42 nas kernel: [37173.104521]  [<ffffffff8106aa94>] ?
__do_page_fault+0x1b4/0x400
May 16 07:41:42 nas kernel: [37173.104540]  [<ffffffff812291e9>]
SyS_ioctl+0x79/0x90
May 16 07:41:42 nas kernel: [37173.104562]  [<ffffffff81820f72>]
entry_SYSCALL_64_fastpath+0x16/0x71
May 16 07:41:42 nas kernel: [37173.104579] Code: 8b 4d a0 48 8b 55 a8
4d 89 f8 48 8b 7d b0 4c 89 e6 e8 78 fb ff ff 85 c0 0f 85 bf 00 00 00
4c 89 e7 e8 58 80 ff ff e9 fa fd ff ff <0f> 0b 48 8d 04 92 43 89 54 ac
40 48 8d 75 bf b9 11 00 00 00 48
May 16 07:41:42 nas kernel: [37173.104746] RIP  [<ffffffffc02f4bdd>]
btrfs_search_forward+0x24d/0x330 [btrfs]
May 16 07:41:42 nas kernel: [37173.104804]  RSP <ffff880161f1bc38>
May 16 07:41:42 nas kernel: [37173.111041] ---[ end trace c5e9746835476803 ]---

# uname -a
Linux nas 4.5.4-040504-generic #201605120823 SMP Thu May 12 12:25:28
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

#   btrfs --version
btrfs-progs v4.5.3

#   btrfs fi show
Label: 'RAID'  uuid: 3247737b-87f9-4e8c-8db3-2beed50fb104
Total devices 4 FS bytes used 4.21TiB
devid    1 size 2.73TiB used 1.66TiB path /dev/sde
devid    2 size 2.73TiB used 1.66TiB path /dev/sdb
devid    3 size 2.73TiB used 1.66TiB path /dev/sdd
devid    4 size 4.55TiB used 3.48TiB path /dev/sdc

Label: 'BACKUP'  uuid: 6e20fe0c-d4ea-4583-96e4-4f4b9634cb8f
Total devices 1 FS bytes used 17.44GiB
devid    1 size 232.89GiB used 38.02GiB path /dev/sdf

#   btrfs fi df /media/RAID/
Data, RAID1: total=4.23TiB, used=4.21TiB
System, RAID1: total=32.00MiB, used=624.00KiB
Metadata, RAID1: total=6.00GiB, used=4.67GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs scrub status /media/RAID/
scrub status for 3247737b-87f9-4e8c-8db3-2beed50fb104
scrub started at Mon May 16 15:26:35 2016 and finished after 07:13:34
total bytes scrubbed: 8.42TiB with 266185 errors
error details: verify=354 csum=265831
corrected errors: 266057, uncorrectable errors: 128, unverified errors: 0
