Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:57218 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757622AbdJQRTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 13:19:50 -0400
Received: by mail-wm0-f44.google.com with SMTP id l68so5350896wmd.5
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 10:19:49 -0700 (PDT)
Received: from home.thecybershadow.net (CyberShadow-1-pt.tunnel.tserv1.bud1.ipv6.he.net. [2001:470:1f1a:172::2])
        by smtp.gmail.com with ESMTPSA id j4sm6810775wrg.11.2017.10.17.10.19.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Oct 2017 10:19:47 -0700 (PDT)
From: Vladimir Panteleev <thecybershadow@gmail.com>
Subject: 4.13: "error in btrfs_run_delayed_refs:3009: errno=-28 No space left"
 with 1.3TB unallocated / 737G free?
To: linux-btrfs@vger.kernel.org
Message-ID: <5de6f85d-ddff-8448-ebc3-54df455c4961@gmail.com>
Date: Tue, 17 Oct 2017 17:19:45 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm experiencing some issues with a btrfs filesystem - mounting and 
other operations taking forever, a balance that takes hours to start and 
never completes (due to the error in the subject line), and I've also 
seen the NULL pointer dereference in free_reloc_roots which Naohiro Aota 
fixed in 4.13.5 (I was on 4.13.4 at the time).

The output of the relevant commands:

# uname -a
Linux home.thecybershadow.net 4.13.6-1-ARCH #1 SMP PREEMPT Thu Oct 12 
12:42:27 CEST 2017 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.13

# df -h /mnt/a
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdi1       5.5T  4.8T  737G  87% /mnt/a

# btrfs filesystem show /mnt/a
Label: none  uuid: f4162b8e-930d-49fa-bbea-56ea3bb544fa
	Total devices 4 FS bytes used 4.74TiB
	devid    2 size 2.73TiB used 2.73TiB path /dev/sdi1
	devid    3 size 2.73TiB used 2.73TiB path /dev/sdb1
	devid    4 size 2.73TiB used 2.73TiB path /dev/sda1
	devid    7 size 2.73TiB used 2.73TiB path /dev/sde1

# btrfs filesystem df /mnt/a
Data, RAID10: total=5.34TiB, used=4.62TiB
System, RAID1: total=8.00MiB, used=608.00KiB
Metadata, RAID1: total=122.03GiB, used=121.37GiB
GlobalReserve, single: total=512.00MiB, used=149.00MiB

# btrfs filesystem usage /mnt/a
Overall:
     Device size:		  10.92TiB
     Device allocated:		  10.91TiB
     Device unallocated:		   2.00GiB
     Device missing:		     0.00B
     Used:			   9.47TiB
     Free (estimated):		 737.75GiB	(min: 737.75GiB)
     Data ratio:			      2.00
     Metadata ratio:		      2.00
     Global reserve:		 512.00MiB	(used: 149.00MiB)

Data,RAID10: Size:5.34TiB, Used:4.62TiB
    /dev/sda1	   1.33TiB
    /dev/sdb1	   1.33TiB
    /dev/sde1	   1.33TiB
    /dev/sdi1	   1.33TiB

Metadata,RAID1: Size:122.03GiB, Used:121.37GiB
    /dev/sda1	  59.51GiB
    /dev/sdb1	  61.51GiB
    /dev/sde1	  61.52GiB
    /dev/sdi1	  61.52GiB

System,RAID1: Size:8.00MiB, Used:608.00KiB
    /dev/sda1	   8.00MiB
    /dev/sdb1	   8.00MiB

Unallocated:
    /dev/sda1	   1.34TiB
    /dev/sdb1	   1.33TiB
    /dev/sde1	   1.33TiB
    /dev/sdi1	   1.33TiB

# btrfs device usage /mnt/a
/dev/sda1, ID: 4
    Device size:             2.73TiB
    Device slack:            3.50KiB
    Data,RAID10:             1.33TiB
    Metadata,RAID1:         59.51GiB
    System,RAID1:            8.00MiB
    Unallocated:             1.34TiB

/dev/sdb1, ID: 3
    Device size:             2.73TiB
    Device slack:            3.50KiB
    Data,RAID10:             1.33TiB
    Metadata,RAID1:         61.51GiB
    System,RAID1:            8.00MiB
    Unallocated:             1.33TiB

/dev/sde1, ID: 7
    Device size:             2.73TiB
    Device slack:              0.00B
    Data,RAID10:             1.33TiB
    Metadata,RAID1:         61.52GiB
    Unallocated:             1.33TiB

/dev/sdi1, ID: 2
    Device size:             2.73TiB
    Device slack:            3.50KiB
    Data,RAID10:             1.33TiB
    Metadata,RAID1:         61.52GiB
    Unallocated:             1.33TiB

I admit I'm somewhat confused by some of these figures. If I'm reading 
this correctly, the metadata blocks are almost full, however that 
shouldn't be an issue because there seems to be plenty of unallocated 
space - or is there? The "Unallocated" figure in the "Overall:" section 
(2.00GiB) doesn't seem to match that in the "Unallocated:" section 
(1.33TiB), and my gut estimate is that the actual amount of data on the 
disks roughly matches df's output. In any case, I've tried deleting some 
200GiB worth of files (which has not helped the situation in any way 
that I've noticed) and running a balance with -dusage=0 and -dusage=10 
(which never completes due to the errors below).

Here's the timeline (with dmesg excerpts) of trying to mount the 
filesystem. The previous unmount was unclean due to the NULL pointer 
dereference, and it seems to attempt to resume the balance started a few 
mounts ago right after mounting.

(running mount command)

[  128.514335] BTRFS info (device sdb1): disk space caching is enabled
[  128.514340] BTRFS info (device sdb1): has skinny extents
[  128.827147] BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 61870, 
rd 18726, flush 1320, corrupt 0, gen 275
[  128.827154] BTRFS info (device sdb1): bdev /dev/sde1 errs: wr 0, rd 
36, flush 0, corrupt 0, gen 0
[  128.827161] BTRFS info (device sdb1): bdev /dev/sda1 errs: wr 0, rd 
457, flush 0, corrupt 0, gen 0
[  184.666715] BTRFS warning (device sdb1): block group 2378367500288 
has wrong amount of free space
[  184.666717] BTRFS warning (device sdb1): failed to load free space 
cache for block group 2378367500288, rebuilding it now
[  184.732017] BTRFS warning (device sdb1): block group 7880254160896 
has wrong amount of free space
[  184.732018] BTRFS warning (device sdb1): failed to load free space 
cache for block group 7880254160896, rebuilding it now
[  184.790792] BTRFS warning (device sdb1): block group 8582481313792 
has wrong amount of free space
[  184.790794] BTRFS warning (device sdb1): failed to load free space 
cache for block group 8582481313792, rebuilding it now
(...a few more of these...)
[  326.714923] BTRFS warning (device sdb1): block group 15167773474816 
has wrong amount of free space
[  326.714926] BTRFS warning (device sdb1): failed to load free space 
cache for block group 15167773474816, rebuilding it now
[  361.777631] BTRFS warning (device sdb1): block group 9985861877760 
has wrong amount of free space
[  361.777635] BTRFS warning (device sdb1): failed to load free space 
cache for block group 9985861877760, rebuilding it now
[ 1579.535116] BTRFS info (device sdb1): checking UUID tree
[ 1579.535118] BTRFS info (device sdb1): continuing balance
[ 1592.162452] BTRFS info (device sdb1): relocating block group 
15527562706944 flags metadata|raid1

(mount command exits here)

[12624.021210] BTRFS info (device sdb1): relocating block group 
15527562706944 flags metadata|raid1
[13748.745807] perf: interrupt took too long (3143 > 3130), lowering 
kernel.perf_event_max_sample_rate to 63600

(here it seems to be trying to resume the balance, but gets stuck in 
btrfs_shrink_device for a very long time - sysrq-w follows)

[14510.837275] sysrq: SysRq : Show Blocked State
[14510.837277]   task                        PC stack   pid father
[14510.837486] btrfs-transacti D    0  2245      2 0x00000000
[14510.837488] Call Trace:
[14510.837493]  __schedule+0x239/0x890
[14510.837495]  schedule+0x3d/0x90
[14510.837497]  io_schedule+0x16/0x40
[14510.837499]  get_request+0x283/0x800
[14510.837501]  ? ioc_lookup_icq+0x50/0x70
[14510.837503]  ? wait_woken+0x80/0x80
[14510.837505]  blk_queue_bio+0x118/0x410
[14510.837507]  generic_make_request+0x125/0x320
[14510.837508]  ? bio_alloc_bioset+0xcc/0x1e0
[14510.837509]  submit_bio+0x73/0x150
[14510.837510]  ? __bio_clone_fast+0x5f/0x70
[14510.837511]  ? submit_bio+0x73/0x150
[14510.837512]  ? bio_clone_fast+0x31/0x70
[14510.837526]  btrfs_map_bio+0x100/0x300 [btrfs]
[14510.837533]  btree_submit_bio_hook+0x5d/0xd0 [btrfs]
[14510.837541]  ? write_one_eb+0xff/0x260 [btrfs]
[14510.837549]  submit_one_bio+0x67/0x90 [btrfs]
[14510.837556]  flush_epd_write_bio+0x35/0x50 [btrfs]
[14510.837562]  flush_write_bio+0xe/0x10 [btrfs]
[14510.837569]  btree_write_cache_pages+0x3cd/0x420 [btrfs]
[14510.837577]  btree_writepages+0x5d/0x70 [btrfs]
[14510.837579]  do_writepages+0x48/0xd0
[14510.837585]  ? merge_state.part.44+0x44/0x130 [btrfs]
[14510.837587]  ? kmem_cache_alloc+0x165/0x1c0
[14510.837589]  __filemap_fdatawrite_range+0xc1/0x100
[14510.837590]  ? __filemap_fdatawrite_range+0xc1/0x100
[14510.837592]  filemap_fdatawrite_range+0x13/0x20
[14510.837599]  btrfs_write_marked_extents+0x5a/0x120 [btrfs]
[14510.837605] 
btrfs_write_and_wait_marked_extents.constprop.20+0x4f/0x90 [btrfs]
[14510.837612]  btrfs_commit_transaction+0x5b1/0x8e0 [btrfs]
[14510.837618]  ? btrfs_commit_transaction+0x5b1/0x8e0 [btrfs]
[14510.837624]  transaction_kthread+0x193/0x1c0 [btrfs]
[14510.837626]  kthread+0x125/0x140
[14510.837632]  ? btrfs_cleanup_transaction+0x510/0x510 [btrfs]
[14510.837633]  ? kthread_create_on_node+0x70/0x70
[14510.837635]  ret_from_fork+0x25/0x30
[14510.837637] btrfs-balance   D    0  5474      2 0x00000000
[14510.837638] Call Trace:
[14510.837640]  __schedule+0x239/0x890
[14510.837641]  schedule+0x3d/0x90
[14510.837646]  wait_current_trans+0xc4/0xf0 [btrfs]
[14510.837648]  ? wait_woken+0x80/0x80
[14510.837653]  start_transaction+0x33a/0x420 [btrfs]
[14510.837659]  btrfs_start_transaction+0x1e/0x20 [btrfs]
[14510.837667]  relocate_block_group+0x145/0x620 [btrfs]
[14510.837674]  btrfs_relocate_block_group+0x184/0x230 [btrfs]
[14510.837682]  btrfs_relocate_chunk+0x38/0xd0 [btrfs]
[14510.837689]  btrfs_shrink_device+0x1d1/0x4d0 [btrfs]
[14510.837696]  btrfs_balance+0x3ee/0x13d0 [btrfs]
[14510.837698]  ? vprintk_func+0x27/0x60
[14510.837699]  ? printk+0x52/0x6e
[14510.837704]  ? btrfs_printk+0x150/0x160 [btrfs]
[14510.837705]  ? __schedule+0x241/0x890
[14510.837711]  balance_kthread+0x5b/0x80 [btrfs]
[14510.837713]  kthread+0x125/0x140
[14510.837719]  ? btrfs_balance+0x13d0/0x13d0 [btrfs]
[14510.837720]  ? kthread_create_on_node+0x70/0x70
[14510.837722]  ret_from_fork+0x25/0x30

[23590.145036] BTRFS info (device sdb1): relocating block group 
13896429600768 flags data|raid10
[23693.855884] BTRFS info (device sdb1): found 1457 extents

(finally gets out of btrfs_shrink_device after 4 hours:)

[28240.779051] sysrq: SysRq : Show Blocked State
[28240.779054]   task                        PC stack   pid father
[28240.779263] btrfs-balance   D    0  5474      2 0x00000000
[28240.779265] Call Trace:
[28240.779270]  __schedule+0x239/0x890
[28240.779272]  schedule+0x3d/0x90
[28240.779274]  io_schedule+0x16/0x40
[28240.779277]  get_request+0x283/0x800
[28240.779279]  ? wait_woken+0x80/0x80
[28240.779281]  blk_queue_bio+0x118/0x410
[28240.779283]  generic_make_request+0x125/0x320
[28240.779284]  ? bio_alloc_bioset+0xcc/0x1e0
[28240.779285]  submit_bio+0x73/0x150
[28240.779286]  ? __bio_clone_fast+0x5f/0x70
[28240.779287]  ? submit_bio+0x73/0x150
[28240.779288]  ? bio_clone_fast+0x31/0x70
[28240.779302]  btrfs_map_bio+0x100/0x300 [btrfs]
[28240.779309]  btree_submit_bio_hook+0x5d/0xd0 [btrfs]
[28240.779317]  ? write_one_eb+0xff/0x260 [btrfs]
[28240.779324]  submit_one_bio+0x67/0x90 [btrfs]
[28240.779331]  flush_epd_write_bio+0x35/0x50 [btrfs]
[28240.779337]  flush_write_bio+0xe/0x10 [btrfs]
[28240.779344]  btree_write_cache_pages+0x3cd/0x420 [btrfs]
[28240.779351]  ? free_extent_state+0x3e/0xa0 [btrfs]
[28240.779358]  btree_writepages+0x5d/0x70 [btrfs]
[28240.779360]  do_writepages+0x48/0xd0
[28240.779366]  ? merge_state.part.44+0x44/0x130 [btrfs]
[28240.779368]  ? kmem_cache_alloc+0x165/0x1c0
[28240.779370]  __filemap_fdatawrite_range+0xc1/0x100
[28240.779371]  ? __filemap_fdatawrite_range+0xc1/0x100
[28240.779373]  filemap_fdatawrite_range+0x13/0x20
[28240.779380]  btrfs_write_marked_extents+0x5a/0x120 [btrfs]
[28240.779386] 
btrfs_write_and_wait_marked_extents.constprop.20+0x4f/0x90 [btrfs]
[28240.779392]  btrfs_commit_transaction+0x5b1/0x8e0 [btrfs]
[28240.779398]  ? btrfs_commit_transaction+0x5b1/0x8e0 [btrfs]
[28240.779404]  ? btrfs_block_rsv_check+0x5c/0x70 [btrfs]
[28240.779410]  __btrfs_end_transaction+0x2bc/0x2e0 [btrfs]
[28240.779416]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
[28240.779422]  btrfs_drop_snapshot+0x4aa/0x890 [btrfs]
[28240.779430]  merge_reloc_roots+0xe0/0x240 [btrfs]
[28240.779437]  relocate_block_group+0x24c/0x620 [btrfs]
[28240.779444]  btrfs_relocate_block_group+0x184/0x230 [btrfs]
[28240.779451]  btrfs_relocate_chunk+0x38/0xd0 [btrfs]
[28240.779458]  btrfs_balance+0xc10/0x13d0 [btrfs]
[28240.779460]  ? vprintk_func+0x27/0x60
[28240.779467]  balance_kthread+0x5b/0x80 [btrfs]
[28240.779468]  kthread+0x125/0x140
[28240.779474]  ? btrfs_balance+0x13d0/0x13d0 [btrfs]
[28240.779476]  ? kthread_create_on_node+0x70/0x70
[28240.779478]  ret_from_fork+0x25/0x30
[32045.071810] BTRFS info (device sdb1): relocating block group 
13892134633472 flags data|raid10
[32327.848335] BTRFS info (device sdb1): found 5445 extents

(and here's the -28 error:)

[32378.507277] BTRFS: Transaction aborted (error -28)
[32378.507309] ------------[ cut here ]------------
[32378.507322] WARNING: CPU: 10 PID: 31101 at 
fs/btrfs/extent-tree.c:3009 btrfs_run_delayed_refs+0x23d/0x250 [btrfs]
[32378.507322] Modules linked in: fuse nls_utf8 cifs ccm dns_resolver 
fscache xt_nat vhost_net vhost tap xt_CHECKSUM iptable_mangle 
xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp ebtable_filter ebtables 
ip6table_filter ip6_tables iptable_filter devlink tun uinput it87 
hwmon_vid ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
libcrc32c crc32c_generic sit tunnel4 ip_tunnel snd_hda_codec_hdmi 8021q 
mrp snd_hda_codec_realtek snd_hda_codec_generic nls_iso8859_1 nls_cp437 
vfat fat iTCO_wdt iTCO_vendor_support intel_rapl mxm_wmi 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel 
aes_x86_64 crypto_simd glue_helper cryptd intel_cstate nvidia_drm(PO) 
intel_rapl_perf
[32378.507343]  nvidia_modeset(PO) i2c_i801 arc4 ath3k uvcvideo btusb 
videobuf2_vmalloc btrtl videobuf2_memops btbcm btintel videobuf2_v4l2 
nvidia(PO) snd_usb_audio videobuf2_core bluetooth ath9k snd_usbmidi_lib 
videodev snd_rawmidi pl2303 evdev mousedev input_leds ath9k_common 
joydev ecdh_generic crc16 usbserial media snd_seq_device mac_hid cdc_acm 
ath9k_hw ath mac80211 snd_hda_intel drm_kms_helper snd_hda_codec 
snd_hda_core snd_hwdep drm cfg80211 snd_pcm r8169 snd_timer e1000e 
mei_me agpgart lpc_ich snd mii syscopyarea sysfillrect mei rfkill 
sysimgblt fb_sys_fops led_class soundcore ioatdma ptp pps_core dca 
shpchp wmi bridge tpm_infineon tpm_tis tpm_tis_core tpm stp llc button 
sch_fq_codel sg ip_tables x_tables btrfs xor raid6_pq sd_mod sr_mod 
cdrom hid_generic hid_dr ff_memless usbhid hid crc32c_intel
[32378.507368]  xhci_pci isci ehci_pci xhci_hcd libsas ehci_hcd ahci 
scsi_transport_sas libahci usbcore usb_common libata scsi_mod serio
[32378.507374] CPU: 10 PID: 31101 Comm: kworker/u24:11 Tainted: P 
    O    4.13.6-1-ARCH #1
[32378.507375] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./X79S-UP5, BIOS F5f 03/19/2014
[32378.507380] Workqueue: events_unbound 
btrfs_async_reclaim_metadata_space [btrfs]
[32378.507381] task: ffff9301b7cc5a00 task.stack: ffffaa284e1cc000
[32378.507386] RIP: 0010:btrfs_run_delayed_refs+0x23d/0x250 [btrfs]
[32378.507387] RSP: 0018:ffffaa284e1cfc50 EFLAGS: 00010282
[32378.507388] RAX: 0000000000000026 RBX: ffff9301af40f618 RCX: 
0000000000000000
[32378.507388] RDX: 0000000000000000 RSI: ffff9301bf48dc78 RDI: 
ffff9301bf48dc78
[32378.507389] RBP: ffffaa284e1cfca8 R08: 00000000000007b4 R09: 
0000000000000004
[32378.507389] R10: ffffaa284e1cfb40 R11: 0000000000000001 R12: 
00000000ffffffe4
[32378.507390] R13: ffff9301561f0000 R14: ffff92f98fddd800 R15: 
0000000000006090
[32378.507391] FS:  0000000000000000(0000) GS:ffff9301bf480000(0000) 
knlGS:0000000000000000
[32378.507391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[32378.507392] CR2: 00007fe0611e3000 CR3: 0000000f7fa09000 CR4: 
00000000001426e0
[32378.507392] Call Trace:
[32378.507401]  btrfs_commit_transaction+0x9b/0x8e0 [btrfs]
[32378.507407]  ? start_transaction+0x99/0x420 [btrfs]
[32378.507412]  flush_space+0xab/0x570 [btrfs]
[32378.507415]  ? dequeue_entity+0xed/0x4d0
[32378.507417]  ? pick_next_task_fair+0x162/0x560
[32378.507420]  ? __switch_to+0x1fc/0x4d0
[32378.507425]  btrfs_async_reclaim_metadata_space+0xd0/0x490 [btrfs]
[32378.507426]  process_one_work+0x1de/0x430
[32378.507428]  worker_thread+0x47/0x3f0
[32378.507429]  kthread+0x125/0x140
[32378.507430]  ? process_one_work+0x430/0x430
[32378.507432]  ? kthread_create_on_node+0x70/0x70
[32378.507434]  ret_from_fork+0x25/0x30
[32378.507435] Code: 44 89 e1 ba c1 0b 00 00 48 c7 c6 60 78 44 c0 48 89 
df e8 7d a7 09 00 e9 ac fe ff ff 44 89 e6 48 c7 c7 40 e6 44 c0 e8 e4 6e 
d3 d5 <0f> ff eb d1 e8 f7 a8 09 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
[32378.507451] ---[ end trace 148d3f8f75efeefd ]---
[32378.507453] BTRFS: error (device sdb1) in 
btrfs_run_delayed_refs:3009: errno=-28 No space left
[32378.507456] BTRFS info (device sdb1): forced readonly
[32378.508112] BTRFS info (device sdb1): 1 enospc errors during balance

The above seems to repeat every time I mount it no matter the number of 
tries, so whatever work it's doing for the hours leading to the error, 
it seems to want to redo them all again on every mount.

I noticed that this situation looks similar to the one described by 
Tomasz Chmielewski in his thread "4.13: No space left with plenty of 
free space (/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989 
__btrfs_free_extent.isra.62+0xc2c/0xdb0)". There, Josef Bacik suggests 
trying a branch with some fixes. Would it make sense to try these for 
this situation?

Thanks!
