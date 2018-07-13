Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:34367
        "EHLO know-smtprelay-omc-3.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730601AbeGMHtL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 03:49:11 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
From: Pete <pete@petezilla.co.uk>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
 <44fabb78-f0ec-d79c-be20-8689bd00d2cd@suse.com>
 <881e443e-60fe-9615-dd8e-7f935761d3af@petezilla.co.uk>
 <1ef30bf4-091d-cc4f-c081-9db262ebc7a8@suse.com>
 <b89a3cdc-aaad-a927-1967-d4c32ad66b08@petezilla.co.uk>
 <85565a70-9111-0fe7-b1af-80febe5f3c1e@petezilla.co.uk>
Message-ID: <6f07d802-2033-09da-f472-8c05dce73517@petezilla.co.uk>
Date: Fri, 13 Jul 2018 08:35:44 +0100
MIME-Version: 1.0
In-Reply-To: <85565a70-9111-0fe7-b1af-80febe5f3c1e@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/12/2018 11:12 PM, Pete wrote:

> Nothing seen, though I recently had the disks go read-only.  I'll wait
> and see what happens.

OK, it went read only - here is the relevent section of the logs.

BTRFS: block rsv returned -28
Jul 12 06:10:09 phoenix kernel: [30637.427155] WARNING: CPU: 3 PID: 1364
at fs/btrfs/extent-tree.c:8429 btrfs_alloc_tree_block+0x416/0x540
Jul 12 06:10:09 phoenix kernel: [30637.427156] Modules linked in:
ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_physdev br_netfilter xt_tcpudp
xt_conntrack iptable_mangle iptable_nat veth tun iptable_filter
ip_tables x_tables pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) nfsd bridge stp llc ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack algif_skcipher af_alg btusb btrtl btbcm
btintel bluetooth uas ecdh_generic radeon r8822be(C)
snd_hda_codec_realtek kvm_amd ttm mac80211 snd_hda_codec_generic
snd_hda_codec_hdmi kvm drm_kms_helper snd_hda_intel eeepc_wmi
snd_hda_codec asus_wmi drm sparse_keymap snd_hda_core cfg80211 video
irqbypass snd_hwdep mxm_wmi i2c_dev igb wmi_bmof agpgart snd_pcm
crct10dif_pclmul fb_sys_fops snd_timer evdev crc32_pclmul syscopyarea
snd sysfillrect crc32c_intel dca k10temp sysimgblt
Jul 12 06:10:09 phoenix kernel: [30637.427195]  ghash_clmulni_intel
serio_raw soundcore hwmon ccp i2c_algo_bit rfkill i2c_piix4 wmi button
shpchp acpi_cpufreq hid_multitouch hid_microsoft hid_lenovo
hid_logitech_hidpp hid_logitech_dj hid_logitech hid_cherry hid_generic
i2c_hid i2c_core usbhid hid uhci_hcd ohci_pci ohci_hcd
Jul 12 06:10:09 phoenix kernel: [30637.427209] CPU: 3 PID: 1364 Comm:
btrfs-transacti Tainted: G        WC O      4.17.4 #2
Jul 12 06:10:09 phoenix kernel: [30637.427210] Hardware name: System
manufacturer System Product Name/ROG CROSSHAIR VII HERO (WI-FI), BIOS
0509 04/17/2018
Jul 12 06:10:09 phoenix kernel: [30637.427213] RIP:
0010:btrfs_alloc_tree_block+0x416/0x540
Jul 12 06:10:09 phoenix kernel: [30637.427214] RSP:
0018:ffffb07880bc7980 EFLAGS: 00010282
Jul 12 06:10:09 phoenix kernel: [30637.427216] RAX: 000000000000001d
RBX: ffff88c570276128 RCX: 0000000000000006
Jul 12 06:10:09 phoenix kernel: [30637.427217] RDX: 0000000000000007
RSI: 0000000000000086 RDI: ffff88c59ecd5510
Jul 12 06:10:09 phoenix kernel: [30637.427218] RBP: 0000000000000001
R08: 0000000000000708 R09: 0000000000000003
Jul 12 06:10:09 phoenix kernel: [30637.427219] R10: 0000000000000000
R11: 0000000000000001 R12: ffff88c5897d3800
Jul 12 06:10:09 phoenix kernel: [30637.427220] R13: ffff88c570276000
R14: 0000000000004000 R15: 0000000000004000
Jul 12 06:10:09 phoenix kernel: [30637.427221] FS:
0000000000000000(0000) GS:ffff88c59ecc0000(0000) knlGS:0000000000000000
Jul 12 06:10:09 phoenix kernel: [30637.427222] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 12 06:10:09 phoenix kernel: [30637.427223] CR2: 00007fc33078b000
CR3: 00008003cb318000 CR4: 00000000003406e0
Jul 12 06:10:09 phoenix kernel: [30637.427224] Call Trace:
Jul 12 06:10:09 phoenix kernel: [30637.427230]  ?
set_extent_buffer_dirty+0x6f/0xa0
Jul 12 06:10:09 phoenix kernel: [30637.427233]
__btrfs_cow_block+0x120/0x4f0
Jul 12 06:10:09 phoenix kernel: [30637.427235]  btrfs_cow_block+0xf7/0x1b0
Jul 12 06:10:09 phoenix kernel: [30637.427238]
btrfs_search_slot+0x327/0xa00
Jul 12 06:10:09 phoenix kernel: [30637.427240]  ?
btrfs_leaf_free_space+0x5a/0xb0
Jul 12 06:10:09 phoenix kernel: [30637.427241]
lookup_inline_extent_backref+0xfa/0x630
Jul 12 06:10:09 phoenix kernel: [30637.427245]  ?
__set_page_dirty_nobuffers+0xe4/0x160
Jul 12 06:10:09 phoenix kernel: [30637.427247]
insert_inline_extent_backref+0x6d/0x110
Jul 12 06:10:09 phoenix kernel: [30637.427249]  ? _cond_resched+0x15/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427252]  ?
kmem_cache_alloc+0x1bc/0x1f0
Jul 12 06:10:09 phoenix kernel: [30637.427253]
__btrfs_inc_extent_ref.isra.64+0xa3/0x290
Jul 12 06:10:09 phoenix kernel: [30637.427255]
__btrfs_run_delayed_refs+0x81d/0x11f0
Jul 12 06:10:09 phoenix kernel: [30637.427258]  ? _cond_resched+0x15/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427259]
btrfs_run_delayed_refs+0xf5/0x190
Jul 12 06:10:09 phoenix kernel: [30637.427262]
btrfs_commit_transaction+0x2cd/0x8a0
Jul 12 06:10:09 phoenix kernel: [30637.427263]  ?
start_transaction+0x9d/0x3d0
Jul 12 06:10:09 phoenix kernel: [30637.427265]
transaction_kthread+0x145/0x170
Jul 12 06:10:09 phoenix kernel: [30637.427266]  ?
btrfs_cleanup_transaction+0x540/0x540
Jul 12 06:10:09 phoenix kernel: [30637.427269]  kthread+0x113/0x130
Jul 12 06:10:09 phoenix kernel: [30637.427271]  ?
kthread_create_worker_on_cpu+0x40/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427274]  ret_from_fork+0x22/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427275] Code: b4 48 c7 c7 20 43
29 b5 89 44 24 58 e8 44 9d 5a 00 85 c0 8b 54 24 58 0f 84 78 ff ff ff 89
d6 48 c7 c7 78 22 0b b5 e8 8a 6a cc ff <0f> 0b e9 63 ff ff ff b9 10 00
00 00 e8 29 3e 03 00 e9 dc fd ff
Jul 12 06:10:09 phoenix kernel: [30637.427301] ---[ end trace
aee029f1f2423cdd ]---
Jul 12 06:10:09 phoenix kernel: [30637.427305] BTRFS info (device dm-2):
space_info 4 has 0 free, is not full
Jul 12 06:10:09 phoenix kernel: [30637.427307] BTRFS info (device dm-2):
space_info total=45097156608, used=43848450048, pinned=495042560,
reserved=749469696, may_use=4194304, readonly=0
Jul 12 06:10:09 phoenix kernel: [30637.427309] use_block_rsv: Not using
global blockrsv! Current blockrsv->type = 1 blockrsv->space_info =
00000000b257fed2 global_rsv->space_info = 00000000b257fed2
Jul 12 06:10:09 phoenix kernel: [30637.427310] ------------[ cut here
]------------
Jul 12 06:10:09 phoenix kernel: [30637.427310] BTRFS: Transaction
aborted (error -28)
Jul 12 06:10:09 phoenix kernel: [30637.427318] WARNING: CPU: 3 PID: 1364
at fs/btrfs/extent-tree.c:3076 btrfs_run_delayed_refs+0x163/0x190
Jul 12 06:10:09 phoenix kernel: [30637.427318] Modules linked in:
ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_physdev br_netfilter xt_tcpudp
xt_conntrack iptable_mangle iptable_nat veth tun iptable_filter
ip_tables x_tables pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) nfsd bridge stp llc ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack algif_skcipher af_alg btusb btrtl btbcm
btintel bluetooth uas ecdh_generic radeon r8822be(C)
snd_hda_codec_realtek kvm_amd ttm mac80211 snd_hda_codec_generic
snd_hda_codec_hdmi kvm drm_kms_helper snd_hda_intel eeepc_wmi
snd_hda_codec asus_wmi drm sparse_keymap snd_hda_core cfg80211 video
irqbypass snd_hwdep mxm_wmi i2c_dev igb wmi_bmof agpgart snd_pcm
crct10dif_pclmul fb_sys_fops snd_timer evdev crc32_pclmul syscopyarea
snd sysfillrect crc32c_intel dca k10temp sysimgblt
Jul 12 06:10:09 phoenix kernel: [30637.427342]  ghash_clmulni_intel
serio_raw soundcore hwmon ccp i2c_algo_bit rfkill i2c_piix4 wmi button
shpchp acpi_cpufreq hid_multitouch hid_microsoft hid_lenovo
hid_logitech_hidpp hid_logitech_dj hid_logitech hid_cherry hid_generic
i2c_hid i2c_core usbhid hid uhci_hcd ohci_pci ohci_hcd
Jul 12 06:10:09 phoenix kernel: [30637.427352] CPU: 3 PID: 1364 Comm:
btrfs-transacti Tainted: G        WC O      4.17.4 #2
Jul 12 06:10:09 phoenix kernel: [30637.427352] Hardware name: System
manufacturer System Product Name/ROG CROSSHAIR VII HERO (WI-FI), BIOS
0509 04/17/2018
Jul 12 06:10:09 phoenix kernel: [30637.427354] RIP:
0010:btrfs_run_delayed_refs+0x163/0x190
Jul 12 06:10:09 phoenix kernel: [30637.427355] RSP:
0018:ffffb07880bc7e28 EFLAGS: 00010292
Jul 12 06:10:09 phoenix kernel: [30637.427356] RAX: 0000000000000026
RBX: ffff88c58c2511a0 RCX: 0000000000000006
Jul 12 06:10:09 phoenix kernel: [30637.427357] RDX: 0000000000000007
RSI: 0000000000000096 RDI: ffff88c59ecd5510
Jul 12 06:10:09 phoenix kernel: [30637.427358] RBP: ffff88c4101c9000
R08: 0000000000000734 R09: 0000000000000003
Jul 12 06:10:09 phoenix kernel: [30637.427358] R10: 0000000000000000
R11: 0000000000000001 R12: ffff88c4101c9000
Jul 12 06:10:09 phoenix kernel: [30637.427359] R13: ffffffffffffffff
R14: 0000000000000000 R15: ffff88c570276c18
Jul 12 06:10:09 phoenix kernel: [30637.427360] FS:
0000000000000000(0000) GS:ffff88c59ecc0000(0000) knlGS:0000000000000000
Jul 12 06:10:09 phoenix kernel: [30637.427361] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 12 06:10:09 phoenix kernel: [30637.427362] CR2: 00007fc33078b000
CR3: 00008003cb318000 CR4: 00000000003406e0
Jul 12 06:10:09 phoenix kernel: [30637.427363] Call Trace:
Jul 12 06:10:09 phoenix kernel: [30637.427365]
btrfs_commit_transaction+0x2cd/0x8a0
Jul 12 06:10:09 phoenix kernel: [30637.427366]  ?
start_transaction+0x9d/0x3d0
Jul 12 06:10:09 phoenix kernel: [30637.427368]
transaction_kthread+0x145/0x170
Jul 12 06:10:09 phoenix kernel: [30637.427369]  ?
btrfs_cleanup_transaction+0x540/0x540
Jul 12 06:10:09 phoenix kernel: [30637.427371]  kthread+0x113/0x130
Jul 12 06:10:09 phoenix kernel: [30637.427373]  ?
kthread_create_worker_on_cpu+0x40/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427374]  ret_from_fork+0x22/0x40
Jul 12 06:10:09 phoenix kernel: [30637.427375] Code: 1f 40 00 eb c7 48
8b 53 50 f0 48 0f ba aa 30 11 00 00 02 72 1b 83 f8 fb 74 16 89 c6 48 c7
c7 40 1a 0b b5 89 04 24 e8 ad ae cc ff <0f> 0b 8b 04 24 89 c1 ba 04 0c
00 00 48 c7 c6 20 03 e6 b4 48 89
Jul 12 06:10:09 phoenix kernel: [30637.427401] ---[ end trace
aee029f1f2423cde ]---
Jul 12 06:10:09 phoenix kernel: [30637.427407] BTRFS: error (device
dm-2) in btrfs_run_delayed_refs:3076: errno=-28 No space left
Jul 12 06:10:09 phoenix kernel: [30637.427410] BTRFS info (device dm-2):
forced readonly
Jul 12 06:10:09 phoenix kernel: [30637.427412] BTRFS warning (device
dm-2): Skipping commit of aborted transaction.
Jul 12 06:10:09 phoenix kernel: [30637.427414] BTRFS: error (device
dm-2) in cleanup_transaction:1854: errno=-28 No space left
Jul 12 06:15:42 phoenix kernel: [30969.851309] ------------[ cut here
]------------
Jul 12 06:15:42 phoenix kernel: [30969.851311] BTRFS: block rsv returned -28
Jul 12 06:15:42 phoenix kernel: [30969.851323] WARNING: CPU: 7 PID:
25495 at fs/btrfs/extent-tree.c:8429 btrfs_alloc_tree_block+0x416/0x540
Jul 12 06:15:42 phoenix kernel: [30969.851324] Modules linked in:
ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_physdev br_netfilter xt_tcpudp
xt_conntrack iptable_mangle iptable_nat veth tun iptable_filter
ip_tables x_tables pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O)
vboxdrv(O) nfsd bridge stp llc ipv6 nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack algif_skcipher af_alg btusb btrtl btbcm
btintel bluetooth uas ecdh_generic radeon r8822be(C)
snd_hda_codec_realtek kvm_amd ttm mac80211 snd_hda_codec_generic
snd_hda_codec_hdmi kvm drm_kms_helper snd_hda_intel eeepc_wmi
snd_hda_codec asus_wmi drm sparse_keymap snd_hda_core cfg80211 video
irqbypass snd_hwdep mxm_wmi i2c_dev igb wmi_bmof agpgart snd_pcm
crct10dif_pclmul fb_sys_fops snd_timer evdev crc32_pclmul syscopyarea
snd sysfillrect crc32c_intel dca k10temp sysimgblt
Jul 12 06:15:42 phoenix kernel: [30969.851370]  ghash_clmulni_intel
serio_raw soundcore hwmon ccp i2c_algo_bit rfkill i2c_piix4 wmi button
shpchp acpi_cpufreq hid_multitouch hid_microsoft hid_lenovo
hid_logitech_hidpp hid_logitech_dj hid_logitech hid_cherry hid_generic
i2c_hid i2c_core usbhid hid uhci_hcd ohci_pci ohci_hcd
Jul 12 06:15:42 phoenix kernel: [30969.851391] CPU: 7 PID: 25495 Comm:
kworker/u32:1 Tainted: G        WC O      4.17.4 #2
Jul 12 06:15:42 phoenix kernel: [30969.851393] Hardware name: System
manufacturer System Product Name/ROG CROSSHAIR VII HERO (WI-FI), BIOS
0509 04/17/2018
Jul 12 06:15:42 phoenix kernel: [30969.851398] Workqueue:
btrfs-endio-write btrfs_endio_write_helper
Jul 12 06:15:42 phoenix kernel: [30969.851402] RIP:
0010:btrfs_alloc_tree_block+0x416/0x540
Jul 12 06:15:42 phoenix kernel: [30969.851403] RSP:
0018:ffffb07888777ab0 EFLAGS: 00010282
Jul 12 06:15:42 phoenix kernel: [30969.851406] RAX: 000000000000001d
RBX: ffff88c46526e3d8 RCX: 0000000000000006
Jul 12 06:15:42 phoenix kernel: [30969.851407] RDX: 0000000000000007
RSI: 0000000000000086 RDI: ffff88c59edd5510
Jul 12 06:15:42 phoenix kernel: [30969.851408] RBP: 0000000000000000
R08: 0000000000000753 R09: 0000000000000003
Jul 12 06:15:42 phoenix kernel: [30969.851409] R10: 0000000000000000
R11: 0000000000000001 R12: ffff88c5892f4000
Jul 12 06:15:42 phoenix kernel: [30969.851411] R13: ffff88c5876e2000
R14: 0000000000004000 R15: 0000000000004000
Jul 12 06:15:42 phoenix kernel: [30969.851413] FS:
0000000000000000(0000) GS:ffff88c59edc0000(0000) knlGS:0000000000000000
Jul 12 06:15:42 phoenix kernel: [30969.851414] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 12 06:15:42 phoenix kernel: [30969.851415] CR2: 00007f31e1fe0000
CR3: 0000800130350000 CR4: 00000000003406e0
Jul 12 06:15:42 phoenix kernel: [30969.851417] Call Trace:
Jul 12 06:15:42 phoenix kernel: [30969.851422]  ? leaf_space_used+0xe9/0x110
Jul 12 06:15:42 phoenix kernel: [30969.851424]  ?
btrfs_leaf_free_space+0x5a/0xb0
Jul 12 06:15:42 phoenix kernel: [30969.851426]
__btrfs_cow_block+0x120/0x4f0
Jul 12 06:15:42 phoenix kernel: [30969.851429]  btrfs_cow_block+0xf7/0x1b0
Jul 12 06:15:42 phoenix kernel: [30969.851431]
btrfs_search_slot+0x327/0xa00
Jul 12 06:15:42 phoenix kernel: [30969.851433]  btrfs_lookup_csum+0x50/0x150
Jul 12 06:15:42 phoenix kernel: [30969.851436]
btrfs_csum_file_blocks+0x146/0x570
Jul 12 06:15:42 phoenix kernel: [30969.851438]  add_pending_csums+0x50/0x70
Jul 12 06:15:42 phoenix kernel: [30969.851440]
btrfs_finish_ordered_io+0x2dd/0x820
Jul 12 06:15:42 phoenix kernel: [30969.851442]
normal_work_helper+0x80/0x320
Jul 12 06:15:42 phoenix kernel: [30969.851445]  process_one_work+0x1c5/0x3f0
Jul 12 06:15:42 phoenix kernel: [30969.851446]  worker_thread+0x2b/0x410
Jul 12 06:15:42 phoenix kernel: [30969.851448]  ?
process_one_work+0x3f0/0x3f0
Jul 12 06:15:42 phoenix kernel: [30969.851450]  kthread+0x113/0x130
Jul 12 06:15:42 phoenix kernel: [30969.851452]  ?
kthread_create_worker_on_cpu+0x40/0x40
Jul 12 06:15:42 phoenix kernel: [30969.851455]  ret_from_fork+0x22/0x40
Jul 12 06:15:42 phoenix kernel: [30969.851456] Code: b4 48 c7 c7 20 43
29 b5 89 44 24 58 e8 44 9d 5a 00 85 c0 8b 54 24 58 0f 84 78 ff ff ff 89
d6 48 c7 c7 78 22 0b b5 e8 8a 6a cc ff <0f> 0b e9 63 ff ff ff b9 10 00
00 00 e8 29 3e 03 00 e9 dc fd ff
Jul 12 06:15:42 phoenix kernel: [30969.851483] ---[ end trace
aee029f1f2423cdf ]---
Jul 12 06:19:47 phoenix kernel: [31215.199199] BTRFS info (device dm-2):
disk space caching is enabled
Jul 12 06:19:47 phoenix kernel: [31215.199201] BTRFS error (device
dm-2): Remounting read-write after error is not allowed
Jul 12 06:45:11 phoenix kernel: [32739.552477] use_block_rsv: 1
callbacks suppressed

Usage, as it stands, for the filesystem in question:
root@phoenix:~# btrfs fi usage /home_data
Overall:
    Device size:                   9.10TiB
    Device allocated:              6.38TiB
    Device unallocated:            2.71TiB
    Device missing:                  0.00B
    Used:                          5.51TiB
    Free (estimated):              1.79TiB      (min: 1.79TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:3.15TiB, Used:2.71TiB
   /dev/mapper/data_disk_1         1.80TiB
   /dev/mapper/data_disk_2         1.80TiB
   /dev/mapper/data_disk_3         2.70TiB

Metadata,RAID1: Size:42.00GiB, Used:40.57GiB
   /dev/mapper/data_disk_1        25.00GiB
   /dev/mapper/data_disk_2        26.00GiB
   /dev/mapper/data_disk_3        33.00GiB

System,RAID1: Size:64.00MiB, Used:480.00KiB
   /dev/mapper/data_disk_1        64.00MiB
   /dev/mapper/data_disk_2        32.00MiB
   /dev/mapper/data_disk_3        32.00MiB


Unallocated:

   /dev/mapper/data_disk_1       926.46GiB

   /dev/mapper/data_disk_2       925.49GiB

   /dev/mapper/data_disk_3       924.99GiB

root@phoenix:~#

