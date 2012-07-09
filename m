Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47902 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GIXs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 19:48:28 -0400
Received: by lbbgm6 with SMTP id gm6so21121671lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 16:48:27 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 09:48:27 +1000
Message-ID: <CALa9hx0waaR7n2iAsSHDrgX5cLgTwWCczuqG12y7=mePpEczMw@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/extent_io.c:1893!
From: Shavi N <shavi64@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have this problem after trying to run btrfsck.
I have new 11 HDDs WD 2tb, on two RAID controllers
Arch Linux, latest kernel. What I was doing was copying and reading
multiple data at the same time
After getting I/O errors while trying to access through samba and
while trying to run a VM with files stored on volume, I ran a btrfsck
but it failed.

[ 7155.485832] ------------[ cut here ]------------
[ 7155.486210] kernel BUG at fs/btrfs/extent_io.c:1893!
[ 7155.486575] invalid opcode: 0000 [#1] PREEMPT SMP
[ 7155.486965] CPU 2
[ 7155.486975] Modules linked in: nfnetlink_log nfnetlink hwmon_vid
reiserfs btrfs zlib_deflate libcrc32c microcode ghash_clmulni_intel
cryptd cx22702 cx88_dvb videobuf_dvb cx88_vp3054_i2c dvb_core
rc_winfast tuner_simple tuner_types eeepc_wmi asus_wmi pci_hotplug
tuner cx88_alsa snd_pcm snd_page_alloc snd_timer snd i915
drm_kms_helper cx8802 cx8800 cx88xx tveeprom btcx_risc videobuf_dma_sg
mei(C) i2c_i801 drm intel_agp soundcore i2c_algo_bit videobuf_core
v4l2_common e1000e videodev media rc_core i2c_core iTCO_wdt
iTCO_vendor_support button acpi_cpufreq mperf processor pcspkr fan
video thermal sparse_keymap rfkill coretemp intel_gtt wmi evdev
vboxnetflt(O) crc32c_intel vboxdrv(O) ext4 crc16 jbd2 mbcache usbhid
hid sd_mod mptsas scsi_transport_sas mptscsih mptbase ahci libahci
libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common
[ 7155.490485]
[ 7155.491187] Pid: 2549, comm: btrfs-delayed-m Tainted: G         C O
3.4.4-2-ARCH #1 System manufacturer System Product Name/P8Z68-V LX
[ 7155.491976] RIP: 0010:[<ffffffffa05f3a0f>]  [<ffffffffa05f3a0f>]
repair_io_failure+0x17f/0x1c0 [btrfs]
[ 7155.492849] RSP: 0018:ffff8803e5a4b740  EFLAGS: 00010246
[ 7155.493679] RAX: ffff8803e5a4b770 RBX: 0000023f77d80000 RCX: 0000023f77d80000
[ 7155.494536] RDX: 0000000000001000 RSI: 0000023f77d80000 RDI: ffff8803fa4a0108
[ 7155.495410] RBP: ffff8803e5a4b7b0 R08: ffffea000f21d400 R09: 0000000000000000
[ 7155.496301] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001000
[ 7155.497206] R13: ffffea000f21d400 R14: ffff8803fa4a0108 R15: 0000000000000000
[ 7155.498128] FS:  0000000000000000(0000) GS:ffff88041f300000(0000)
knlGS:0000000000000000
[ 7155.499096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7155.500062] CR2: 00007f3ea3ee7000 CR3: 000000000180b000 CR4: 00000000000427e0
[ 7155.501059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7155.502073] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7155.503103] Process btrfs-delayed-m (pid: 2549, threadinfo
ffff8803e5a4a000, task ffff880406bb7710)
[ 7155.504168] Stack:
[ 7155.505234]  ffff8803e5a4b740 0000023f77d80000 0000000000000000
0000000000000000
[ 7155.506354]  0000000000000000 0000000000000000 ffff8803e5a4b770
ffff8803e5a4b770
[ 7155.507493]  ffff880300000001 0000023f77d80000 0000000000000000
ffff8803fa4a0108
[ 7155.508663] Call Trace:
[ 7155.509822]  [<ffffffffa05f43b2>] repair_eb_io_failure+0x82/0xb0 [btrfs]
[ 7155.511018]  [<ffffffffa05ca362>]
btree_read_extent_buffer_pages.constprop.111+0x112/0x120 [btrfs]
[ 7155.512249]  [<ffffffffa05cab2a>] read_tree_block+0x3a/0x50 [btrfs]
[ 7155.513491]  [<ffffffffa05b05d3>]
read_block_for_search.isra.32+0x203/0x3d0 [btrfs]
[ 7155.514761]  [<ffffffffa05afceb>] ?
generic_bin_search.constprop.34+0x6b/0x180 [btrfs]
[ 7155.516046]  [<ffffffffa05ac5a9>] ? unlock_up+0x159/0x180 [btrfs]
[ 7155.517344]  [<ffffffffa05b29fc>] btrfs_search_slot+0x3ec/0x900 [btrfs]
[ 7155.518662]  [<ffffffffa05b7ef3>]
lookup_inline_extent_backref+0xa3/0x470 [btrfs]
[ 7155.520001]  [<ffffffffa05b8d83>]
insert_inline_extent_backref+0x63/0x100 [btrfs]
[ 7155.521342]  [<ffffffff81159acf>] ? kmem_cache_alloc+0x13f/0x150
[ 7155.522703]  [<ffffffffa05b9f29>] ? __btrfs_free_extent+0x229/0x7b0 [btrfs]
[ 7155.524083]  [<ffffffffa05b8ec1>] __btrfs_inc_extent_ref+0xa1/0x1f0 [btrfs]
[ 7155.525481]  [<ffffffffa05becc8>] run_clustered_refs+0x5f8/0xa00 [btrfs]
[ 7155.526891]  [<ffffffffa05afceb>] ?
generic_bin_search.constprop.34+0x6b/0x180 [btrfs]
[ 7155.528330]  [<ffffffffa05b5b25>] ? __find_space_info+0x85/0xa0 [btrfs]
[ 7155.529781]  [<ffffffffa05bf245>] btrfs_run_delayed_refs+0x175/0x450 [btrfs]
[ 7155.531254]  [<ffffffffa05b5e1c>] ?
block_rsv_release_bytes+0xec/0x1b0 [btrfs]
[ 7155.532718]  [<ffffffff814675ae>] ? __mutex_lock_slowpath+0x24e/0x340
[ 7155.534153]  [<ffffffffa05d0e9f>] __btrfs_end_transaction+0x9f/0x350 [btrfs]
[ 7155.535560]  [<ffffffffa05d1168>]
btrfs_end_transaction_dmeta+0x18/0x20 [btrfs]
[ 7155.536986]  [<ffffffffa061f49a>]
btrfs_async_run_delayed_node_done+0x16a/0x1b0 [btrfs]
[ 7155.538437]  [<ffffffffa060167d>] worker_loop+0x13d/0x570 [btrfs]
[ 7155.539892]  [<ffffffffa0601540>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
[ 7155.541358]  [<ffffffff810731d3>] kthread+0x93/0xa0
[ 7155.542831]  [<ffffffff8146bbe4>] kernel_thread_helper+0x4/0x10
[ 7155.544314]  [<ffffffff81073140>] ? kthread_freezable_should_stop+0x70/0x70
[ 7155.545819]  [<ffffffff8146bbe0>] ? gs_change+0x13/0x13
[ 7155.547301] Code: 68 f4 ba e0 b8 fb ff ff ff 48 8b 5d d8 4c 8b 65
e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 44 00 00 b8 fb ff
ff ff eb de <0f> 0b 0f 0b 49 8b 45 08 49 8b 8f 88 00 00 00 4d 89 f0 48
8b 55
[ 7155.550585] RIP  [<ffffffffa05f3a0f>] repair_io_failure+0x17f/0x1c0 [btrfs]
[ 7155.552217]  RSP <ffff8803e5a4b740>
[ 7155.560702] ------------[ cut here ]------------
[ 7155.560725] ---[ end trace a9e42293494b43b8 ]---
[ 7155.563435] kernel BUG at fs/btrfs/extent_io.c:1893!
[ 7155.563437] invalid opcode: 0000 [#2] PREEMPT SMP
[ 7155.563439] CPU 1
[ 7155.563439] Modules linked in: nfnetlink_log nfnetlink hwmon_vid
reiserfs btrfs zlib_deflate libcrc32c microcode ghash_clmulni_intel
cryptd cx22702 cx88_dvb videobuf_dvb cx88_vp3054_i2c dvb_core
rc_winfast tuner_simple tuner_types eeepc_wmi asus_wmi pci_hotplug
tuner cx88_alsa snd_pcm snd_page_alloc snd_timer snd i915
drm_kms_helper cx8802 cx8800 cx88xx tveeprom btcx_risc videobuf_dma_sg
mei(C) i2c_i801 drm intel_agp soundcore i2c_algo_bit videobuf_core
v4l2_common e1000e videodev media rc_core i2c_core iTCO_wdt
iTCO_vendor_support button acpi_cpufreq mperf processor pcspkr fan
video thermal sparse_keymap rfkill coretemp intel_gtt wmi evdev
vboxnetflt(O) crc32c_intel vboxdrv(O) ext4 crc16 jbd2 mbcache usbhid
hid sd_mod mptsas scsi_transport_sas mptscsih mptbase ahci libahci
libata xhci_hcd ehci_hcd scsi_mod usbcore usb_common
[ 7155.563469]
[ 7155.563471] Pid: 2550, comm: btrfs-delayed-m Tainted: G      D  C O
3.4.4-2-ARCH #1 System manufacturer System Product Name/P8Z68-V LX
[ 7155.563473] RIP: 0010:[<ffffffffa05f3a0f>]  [<ffffffffa05f3a0f>]
repair_io_failure+0x17f/0x1c0 [btrfs]
[ 7155.563485] RSP: 0018:ffff8802f34bb7d0  EFLAGS: 00010246
[ 7155.563487] RAX: ffff8802f34bb800 RBX: 0000023f77d80000 RCX: 0000023f77d80000
[ 7155.563488] RDX: 0000000000001000 RSI: 0000023f77d80000 RDI: ffff8803fa4a0108
[ 7155.563489] RBP: ffff8802f34bb840 R08: ffffea000f21d400 R09: 0000000000000000
[ 7155.563491] R10: 57ffad78bf21d400 R11: 0000000000000001 R12: 0000000000001000
[ 7155.563492] R13: ffffea000f21d400 R14: ffff8803fa4a0108 R15: 0000000000000000
[ 7155.563494] FS:  0000000000000000(0000) GS:ffff88041f280000(0000)
knlGS:0000000000000000
[ 7155.563496] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7155.563497] CR2: 000000000111dc40 CR3: 000000000180b000 CR4: 00000000000427e0
[ 7155.563498] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7155.563500] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7155.563502] Process btrfs-delayed-m (pid: 2550, threadinfo
ffff8802f34ba000, task ffff8803eac44f60)
[ 7155.563503] Stack:
[ 7155.563504]  ffff8802f34bb7d0 0000023f77d80000 0000000000000000
0000000000000000
[ 7155.563506]  0000000000000000 0000000000000000 ffff8802f34bb800
ffff8802f34bb800
[ 7155.563508]  ffff880200000001 0000023f77d80000 0000000000000000
ffff8803fa4a0108
[ 7155.563511] Call Trace:
[ 7155.563520]  [<ffffffffa05f43b2>] repair_eb_io_failure+0x82/0xb0 [btrfs]
[ 7155.563534]  [<ffffffffa05ca362>]
btree_read_extent_buffer_pages.constprop.111+0x112/0x120 [btrfs]
[ 7155.563539]  [<ffffffffa05cab2a>] read_tree_block+0x3a/0x50 [btrfs]
[ 7155.563544]  [<ffffffffa05b04f4>]
read_block_for_search.isra.32+0x124/0x3d0 [btrfs]
[ 7155.563548]  [<ffffffffa05afceb>] ?
generic_bin_search.constprop.34+0x6b/0x180 [btrfs]
[ 7155.563554]  [<ffffffffa0607e32>] ? btrfs_tree_read_unlock+0x72/0xb0 [btrfs]
[ 7155.563558]  [<ffffffffa05b29fc>] btrfs_search_slot+0x3ec/0x900 [btrfs]
[ 7155.563563]  [<ffffffffa0614a71>] ?
add_delayed_tree_ref.isra.4+0xb1/0x1f0 [btrfs]
[ 7155.563568]  [<ffffffffa0614dbd>] ?
add_delayed_ref_head.isra.1+0xbd/0x1b0 [btrfs]
[ 7155.563573]  [<ffffffffa05ba904>] btrfs_lookup_extent_info+0x84/0x2f0 [btrfs]
[ 7155.563578]  [<ffffffffa05c0e2c>] ?
btrfs_alloc_free_block+0x25c/0x380 [btrfs]
[ 7155.563582]  [<ffffffffa05ae20a>] update_ref_for_cow+0x17a/0x300 [btrfs]
[ 7155.563586]  [<ffffffffa05ae5c0>] __btrfs_cow_block+0x230/0x510 [btrfs]
[ 7155.563591]  [<ffffffffa05cbcdd>] ? btrfs_buffer_uptodate+0x6d/0x80 [btrfs]
[ 7155.563596]  [<ffffffffa05ae997>] btrfs_cow_block+0xf7/0x230 [btrfs]
[ 7155.563600]  [<ffffffffa05b27a3>] btrfs_search_slot+0x193/0x900 [btrfs]
[ 7155.563605]  [<ffffffffa05bf29b>] ?
btrfs_run_delayed_refs+0x1cb/0x450 [btrfs]
[ 7155.563610]  [<ffffffffa05c70ef>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[ 7155.563612]  [<ffffffff814676b6>] ? mutex_lock+0x16/0x30
[ 7155.563617]  [<ffffffffa061e221>]
btrfs_update_delayed_inode+0x71/0x150 [btrfs]
[ 7155.563622]  [<ffffffffa061f45a>]
btrfs_async_run_delayed_node_done+0x12a/0x1b0 [btrfs]
[ 7155.563628]  [<ffffffffa060167d>] worker_loop+0x13d/0x570 [btrfs]
[ 7155.563633]  [<ffffffffa0601540>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
[ 7155.563635]  [<ffffffff810731d3>] kthread+0x93/0xa0
[ 7155.563637]  [<ffffffff8146bbe4>] kernel_thread_helper+0x4/0x10
[ 7155.563638]  [<ffffffff81073140>] ? kthread_freezable_should_stop+0x70/0x70
[ 7155.563640]  [<ffffffff8146bbe0>] ? gs_change+0x13/0x13
[ 7155.563641] Code: 68 f4 ba e0 b8 fb ff ff ff 48 8b 5d d8 4c 8b 65
e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 44 00 00 b8 fb ff
ff ff eb de <0f> 0b 0f 0b 49 8b 45 08 49 8b 8f 88 00 00 00 4d 89 f0 48
8b 55
[ 7155.563652] RIP  [<ffffffffa05f3a0f>] repair_io_failure+0x17f/0x1c0 [btrfs]
[ 7155.563658]  RSP <ffff8802f34bb7d0>
[ 7155.563672] ---[ end trace a9e42293494b43b9 ]---

lspci:
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
Processor Family PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 3 (rev b5)
00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 6 (rev b5)
00:1c.7 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Z68 Express Chipset Family LPC
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
01:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)
02:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)
03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller
05:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI
Bridge (rev 01)
06:02.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
06:02.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [Audio Port] (rev 05)
06:02.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [MPEG Port] (rev 05)

dmesg is full of these:

[ 7155.272024] btrfs read error corrected: ino 1 off 2472225316864
(dev /dev/sdm sector 74266192)
[ 7155.275364] btrfs read error corrected: ino 1 off 2471362695168
(dev /dev/sdm sector 76775688)
[ 7155.286108] btrfs read error corrected: ino 1 off 2470874312704
(dev /dev/sdm sector 75821816)
[ 7155.286959] btrfs read error corrected: ino 1 off 2472225488896
(dev /dev/sdm sector 74266528)
[ 7155.298972] btrfs bad tree block start 0 2474459721728
[ 7155.300341] btrfs read error corrected: ino 1 off 2473829842944
(dev /dev/sdm sector 73205728)
[ 7155.300414] btrfs read error corrected: ino 1 off 2472282689536
(dev /dev/sdm sector 74378248)
[ 7155.300468] btrfs read error corrected: ino 1 off 2474459721728
(dev /dev/sdm sector 70241656)
[ 7155.303746] btrfs read error corrected: ino 1 off 2473829855232
(dev /dev/sdm sector 73205752)
[ 7155.305621] btrfs read error corrected: ino 1 off 2472225542144
(dev /dev/sdm sector 74266632)
[ 7155.312990] btrfs read error corrected: ino 1 off 2471364288512
(dev /dev/sdm sector 76778800)
[ 7155.313640] btrfs read error corrected: ino 1 off 2471516639232
(dev /dev/sdm sector 77076360)
[ 7155.317596] btrfs bad tree block start 0 2474412007424
[ 7155.321487] btrfs read error corrected: ino 1 off 2472231632896
(dev /dev/sdm sector 74278528)
[ 7155.334831] btrfs read error corrected: ino 1 off 2474412007424
(dev /dev/sdm sector 70148464)
[ 7155.358335] btrfs read error corrected: ino 1 off 2471288111104
(dev /dev/sdm sector 76630016)
[ 7155.358804] btrfs read error corrected: ino 1 off 2471288115200
(dev /dev/sdm sector 76630024)
[ 7155.361375] btrfs read error corrected: ino 1 off 2471364329472
(dev /dev/sdm sector 76778880)
[ 7155.366515] btrfs read error corrected: ino 1 off 2473813258240
(dev /dev/sdm sector 73173336)
[ 7155.378599] btrfs read error corrected: ino 1 off 2472690577408
(dev /dev/sdm sector 75174904)
[ 7155.390901] btrfs read error corrected: ino 1 off 2472751919104
(dev /dev/sdm sector 75294712)
[ 7155.391920] btrfs read error corrected: ino 1 off 2471365332992
(dev /dev/sdm sector 76780840)
[ 7155.404434] btrfs read error corrected: ino 1 off 2471746420736
(dev /dev/sdm sector 77525152)

Most errors seems to occur on /dev/sdi, /dev/sdj, /dev/sdk, /dev/sdl, /dev/sdm.
All HDDs are new.

If more info is needed I'll provide

Anyway to fix it? There is data on there which I prefer to keep.

Thanks,
