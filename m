Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38579 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbbAIMDL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 07:03:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9YEW-0000Jt-8U
	for linux-btrfs@vger.kernel.org; Fri, 09 Jan 2015 13:00:04 +0100
Received: from 178-83-247-145.dynamic.hispeed.ch ([178.83.247.145])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 13:00:04 +0100
Received: from remy.blank by 178-83-247-145.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 13:00:04 +0100
To: linux-btrfs@vger.kernel.org
From: Remy Blank <remy.blank@pobox.com>
Subject: Segfault in "btrfs balance start" due to kernel page allocation failure
Date: Fri, 09 Jan 2015 12:19:23 +0100
Message-ID: <m8odfs$rv2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem that shows the following errors. This happens
either when writing to the FS or when snapshotting, I'm not sure (this
FS holds my backup, and I write to it with rsync and snapshot afterward).

Jan  8 13:54:33 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 3828 (root 317): -28
Jan  8 13:54:38 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 17939 (root 317): -28
Jan  8 13:54:49 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 26564 (root 317): -28
Jan  8 14:01:07 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 34014 (root 317): -28
Jan  8 14:01:08 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 34515 (root 317): -28
Jan  8 14:01:08 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 34519 (root 317): -28
Jan  8 14:01:19 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 53644 (root 317): -28
Jan  8 14:01:19 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 53649 (root 317): -28
Jan  8 14:01:25 twin kernel: BTRFS error (device dm-2): error inheriting
props for ino 56783 (root 317): -28

I ran "btrfs balance start" on the FS, and it terminated with a
segfault, apparently due to a page allocation failure. The machine is
x86_64, running 3.17.7, and has more than enough memory (it's currently
using 600 MiB out of 16 GiB). The kernel log is pasted below. Issuing a
"btrfs balance cancel" blocks in non-interruptible mode, so I'll
probably have trouble unmounting this FS.

Any help appreciated.

-- Remy


Jan  9 12:06:33 twin kernel: btrfs: page allocation failure: order:1,
mode:0x204020
Jan  9 12:06:33 twin kernel: CPU: 1 PID: 3188 Comm: btrfs Not tainted
3.17.7-gentoo #2
Jan  9 12:06:33 twin kernel: Hardware name: Shuttle Inc. DS47D/FS47D,
BIOS 1.00 04/10/2013
Jan  9 12:06:33 twin kernel: ffff8800057f76a0 ffffffff816b0429
0000000000204020 ffffffff811647d7
Jan  9 12:06:33 twin kernel: ffffffff810fd2b9 ffff88041f5e7e00
0000000000000000 0000000200000001
Jan  9 12:06:33 twin kernel: ffff88041f5ea2a8 0000000000000046
0000000000000000 0000000000000000
Jan  9 12:06:33 twin kernel: Call Trace:
Jan  9 12:06:33 twin kernel: [<ffffffff816b0429>] ? dump_stack+0x49/0x6a
Jan  9 12:06:33 twin kernel: [<ffffffff811647d7>] ?
warn_alloc_failed+0xd7/0x130
Jan  9 12:06:33 twin kernel: [<ffffffff810fd2b9>] ?
autoremove_wake_function+0x9/0x30
Jan  9 12:06:33 twin kernel: [<ffffffff81168378>] ?
__alloc_pages_nodemask+0x778/0xb20
Jan  9 12:06:33 twin kernel: [<ffffffff811a8c2c>] ? kmem_getpages+0x6c/0x190
Jan  9 12:06:33 twin kernel: [<ffffffff811aa80f>] ?
fallback_alloc+0x1bf/0x200
Jan  9 12:06:33 twin kernel: [<ffffffff811aaa08>] ?
kmem_cache_alloc+0xf8/0x1a0
Jan  9 12:06:33 twin kernel: [<ffffffff8140aa10>] ? ida_pre_get+0x60/0xe0
Jan  9 12:06:33 twin kernel: [<ffffffff811c0da1>] ? get_anon_bdev+0x21/0x100
Jan  9 12:06:33 twin kernel: [<ffffffff8142f0d8>] ?
__percpu_counter_init+0x68/0x80
Jan  9 12:06:33 twin kernel: [<ffffffff8130f56c>] ?
btrfs_init_fs_root+0xec/0x180
Jan  9 12:06:33 twin kernel: [<ffffffff81310a46>] ?
btrfs_get_fs_root+0xb6/0x240
Jan  9 12:06:33 twin kernel: [<ffffffff8135e6b4>] ? read_fs_root+0x34/0x40
Jan  9 12:06:33 twin kernel: [<ffffffff8135f8e1>] ?
build_backref_tree+0x671/0x1210
Jan  9 12:06:33 twin kernel: [<ffffffff8130d480>] ?
free_root_pointers+0x50/0x50
Jan  9 12:06:33 twin kernel: [<ffffffff81361723>] ?
relocate_tree_blocks+0x1e3/0x600
Jan  9 12:06:33 twin kernel: [<ffffffff8135c2bc>] ? tree_insert+0x4c/0x50
Jan  9 12:06:33 twin kernel: [<ffffffff81362f12>] ?
relocate_block_group+0x3f2/0x670
Jan  9 12:06:33 twin kernel: [<ffffffff81363347>] ?
btrfs_relocate_block_group+0x1b7/0x2c0
Jan  9 12:06:33 twin kernel: [<ffffffff8133a028>] ?
btrfs_relocate_chunk.isra.31+0x58/0x6a0
Jan  9 12:06:33 twin kernel: [<ffffffff812eea71>] ?
btrfs_set_path_blocking+0x31/0x70
Jan  9 12:06:33 twin kernel: [<ffffffff812f3ecd>] ?
btrfs_search_slot+0x4dd/0xae0
Jan  9 12:06:33 twin kernel: [<ffffffff81336478>] ?
read_extent_buffer+0xc8/0x120
Jan  9 12:06:33 twin kernel: [<ffffffff8132ca20>] ?
btrfs_get_token_64+0x50/0xe0
Jan  9 12:06:33 twin kernel: [<ffffffff81335451>] ?
release_extent_buffer+0x21/0xc0
Jan  9 12:06:33 twin kernel: [<ffffffff8133d07e>] ?
btrfs_balance+0x82e/0xe20
Jan  9 12:06:33 twin kernel: [<ffffffff813438ef>] ?
btrfs_ioctl_balance+0x14f/0x340
Jan  9 12:06:33 twin kernel: [<ffffffff81348cfc>] ? btrfs_ioctl+0x58c/0x2b10
Jan  9 12:06:33 twin kernel: [<ffffffff811ba90e>] ?
mem_cgroup_commit_charge+0x5e/0xa0
Jan  9 12:06:33 twin kernel: [<ffffffff81188798>] ?
handle_mm_fault+0x9a8/0xe90
Jan  9 12:06:33 twin kernel: [<ffffffff81036e58>] ?
__do_page_fault+0x1b8/0x450
Jan  9 12:06:33 twin kernel: [<ffffffff8118b9f1>] ? vma_link+0xb1/0xc0
Jan  9 12:06:33 twin kernel: [<ffffffff811cfda7>] ? do_vfs_ioctl+0x2d7/0x4b0
Jan  9 12:06:33 twin kernel: [<ffffffff811cfff9>] ? SyS_ioctl+0x79/0x90
Jan  9 12:06:33 twin kernel: [<ffffffff816b7948>] ? page_fault+0x28/0x30
Jan  9 12:06:33 twin kernel: [<ffffffff816b60ad>] ?
system_call_fastpath+0x1a/0x1f
Jan  9 12:06:33 twin kernel: Mem-Info:
Jan  9 12:06:33 twin kernel: Node 0 DMA per-cpu:
Jan  9 12:06:33 twin kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan  9 12:06:33 twin kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan  9 12:06:33 twin kernel: Node 0 DMA32 per-cpu:
Jan  9 12:06:33 twin kernel: CPU    0: hi:  186, btch:  31 usd: 154
Jan  9 12:06:33 twin kernel: CPU    1: hi:  186, btch:  31 usd: 191
Jan  9 12:06:33 twin kernel: Node 0 Normal per-cpu:
Jan  9 12:06:33 twin kernel: CPU    0: hi:  186, btch:  31 usd:  50
Jan  9 12:06:33 twin kernel: CPU    1: hi:  186, btch:  31 usd: 222
Jan  9 12:06:33 twin kernel: active_anon:8855 inactive_anon:14090
isolated_anon:0
Jan  9 12:06:33 twin kernel: active_file:916356 inactive_file:2991941
isolated_file:32
Jan  9 12:06:33 twin kernel: unevictable:1783 dirty:13950 writeback:0
unstable:0
Jan  9 12:06:33 twin kernel: free:41920 slab_reclaimable:75729
slab_unreclaimable:8399
Jan  9 12:06:33 twin kernel: mapped:4758 shmem:196 pagetables:839 bounce:0
Jan  9 12:06:33 twin kernel: free_cma:0
Jan  9 12:06:33 twin kernel: Node 0 DMA free:15360kB min:60kB low:72kB
high:88kB active_anon:0kB inactive_anon:0kB active_file:0kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
present:15984kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Jan  9 12:06:33 twin kernel: lowmem_reserve[]: 0 3390 15953 15953
Jan  9 12:06:33 twin kernel: Node 0 DMA32 free:72612kB min:14348kB
low:17932kB high:21520kB active_anon:4496kB inactive_anon:8456kB
active_file:740880kB inactive_file:2562448kB unevictable:1820kB
isolated(anon):0kB isolated(file):112kB present:3549456kB
managed:3473772kB mlocked:1820kB dirty:11400kB writeback:0kB
mapped:4012kB shmem:164kB slab_reclaimable:71368kB
slab_unreclaimable:6740kB kernel_stack:1152kB pagetables:536kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:112
all_unreclaimable? no
Jan  9 12:06:33 twin kernel: lowmem_reserve[]: 0 0 12563 12563
Jan  9 12:06:33 twin kernel: Node 0 Normal free:79808kB min:53168kB
low:66460kB high:79752kB active_anon:30924kB inactive_anon:47904kB
active_file:2924544kB inactive_file:9405204kB unevictable:5312kB
isolated(anon):0kB isolated(file):0kB present:13096960kB
managed:12864588kB mlocked:5312kB dirty:44400kB writeback:0kB
mapped:15020kB shmem:620kB slab_reclaimable:231548kB
slab_unreclaimable:26856kB kernel_stack:2784kB pagetables:2820kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Jan  9 12:06:33 twin kernel: lowmem_reserve[]: 0 0 0 0
Jan  9 12:06:33 twin kernel: Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB
0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) =
15360kB
Jan  9 12:06:33 twin kernel: Node 0 DMA32: 18157*4kB (EM) 1*8kB (M)
0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
= 72636kB
Jan  9 12:06:33 twin kernel: Node 0 Normal: 18897*4kB (M) 0*8kB 0*16kB
0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) =
79684kB
Jan  9 12:06:33 twin kernel: Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
Jan  9 12:06:33 twin kernel: 3910139 total pagecache pages
Jan  9 12:06:33 twin kernel: 92 pages in swap cache
Jan  9 12:06:33 twin kernel: Swap cache stats: add 822, delete 730, find
1864/1962
Jan  9 12:06:33 twin kernel: Free swap  = 2096004kB
Jan  9 12:06:33 twin kernel: Total swap = 2097148kB
Jan  9 12:06:33 twin kernel: 4165600 pages RAM
Jan  9 12:06:33 twin kernel: 0 pages HighMem/MovableOnly
Jan  9 12:06:33 twin kernel: 58093 pages reserved
Jan  9 12:06:33 twin kernel: ------------[ cut here ]------------
Jan  9 12:06:33 twin kernel: kernel BUG at fs/btrfs/relocation.c:242!
Jan  9 12:06:33 twin kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jan  9 12:06:33 twin kernel: Modules linked in: fuse af_packet bnep
bluetooth ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 nf_nat xt_limit
nf_log_ipv4 nf_log_common xt_LOG ipt_REJECT nf_conntrack_ipv4
nf_defrag_ipv4 xt_tcpudp xt_conntrack nf_conntrack ip6table_filter
iptable_filter ip6_tables ip_tables x_tables snd_aloop vfat fat nls_utf8
cryptoloop x86_pkg_temp_thermal loop intel_powerclamp coretemp tun
intel_rapl ipv6 kvm_intel kvm cpufreq_stats uas fbcon usb_storage
bitblit softcursor font i915 rtl8192ce rtl_pci drm_kms_helper rtlwifi
drm rtl8192c_common evdev mac80211 cfbfillrect cfbimgblt cfg80211
cfbcopyarea lpc_ich i2c_i801 rfkill r8169 i2c_algo_bit mfd_core mii
i2c_core fan fb snd_hda_codec_hdmi thermal xhci_hcd fbdev intel_gtt
snd_hda_codec_realtek agpgart snd_hda_codec_generic battery button video
acpi_cpufreq backlight snd_hda_intel ehci_pci snd_hda_controller
ehci_hcd snd_hda_codec usbcore snd_hwdep usb_common processor snd_pcm
thermal_sys hwmon rtc_cmos snd_timer snd shpchp soundcore [last
unloaded: microcode]
Jan  9 12:06:33 twin kernel: CPU: 1 PID: 3188 Comm: btrfs Not tainted
3.17.7-gentoo #2
Jan  9 12:06:33 twin kernel: Hardware name: Shuttle Inc. DS47D/FS47D,
BIOS 1.00 04/10/2013
Jan  9 12:06:33 twin kernel: task: ffff8800d53dabd0 ti: ffff8800057f4000
task.ti: ffff8800057f4000
Jan  9 12:06:33 twin kernel: RIP: 0010:[<ffffffff81363181>]
[<ffffffff81363181>] relocate_block_group+0x661/0x670
Jan  9 12:06:33 twin kernel: RSP: 0018:ffff8800057f7b10  EFLAGS: 00010202
Jan  9 12:06:33 twin kernel: RAX: ffff880404f318f8 RBX: ffff880404f31908
RCX: ffff8801b6fe2640
Jan  9 12:06:33 twin kernel: RDX: 0000000000000001 RSI: ffff880404f318e8
RDI: 0000000000000286
Jan  9 12:06:33 twin kernel: RBP: ffff8802439d1260 R08: 0000000000000000
R09: 0000000000000000
Jan  9 12:06:33 twin kernel: R10: ffff880136fe2640 R11: ffff8800021639c0
R12: ffff880404f318e8
Jan  9 12:06:33 twin kernel: R13: 00000000fffffff4 R14: ffff880404f31800
R15: 00000000fffffff4
Jan  9 12:06:33 twin kernel: FS:  00007fa633045b40(0000)
GS:ffff88041e300000(0000) knlGS:0000000000000000
Jan  9 12:06:33 twin kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jan  9 12:06:33 twin kernel: CR2: 00000000012ee18c CR3: 0000000407012000
CR4: 00000000000407e0
Jan  9 12:06:33 twin kernel: Stack:
Jan  9 12:06:33 twin kernel: ffff880404f31820 0000000000000102
00000000ffffffff 0000000000000000
Jan  9 12:06:33 twin kernel: ffff880114d9c848 00ff880114d9c600
a9000000055d5480 0000000000000001
Jan  9 12:06:33 twin kernel: ffff880404f31800 0000000000000000
ffff880404c2f800 ffff880114d9c580
Jan  9 12:06:33 twin kernel: Call Trace:
Jan  9 12:06:33 twin kernel: [<ffffffff81363347>] ?
btrfs_relocate_block_group+0x1b7/0x2c0
Jan  9 12:06:33 twin kernel: [<ffffffff8133a028>] ?
btrfs_relocate_chunk.isra.31+0x58/0x6a0
Jan  9 12:06:33 twin kernel: [<ffffffff812eea71>] ?
btrfs_set_path_blocking+0x31/0x70
Jan  9 12:06:33 twin kernel: [<ffffffff812f3ecd>] ?
btrfs_search_slot+0x4dd/0xae0
Jan  9 12:06:33 twin kernel: [<ffffffff81336478>] ?
read_extent_buffer+0xc8/0x120
Jan  9 12:06:33 twin kernel: [<ffffffff8132ca20>] ?
btrfs_get_token_64+0x50/0xe0
Jan  9 12:06:33 twin kernel: [<ffffffff81335451>] ?
release_extent_buffer+0x21/0xc0
Jan  9 12:06:33 twin kernel: [<ffffffff8133d07e>] ?
btrfs_balance+0x82e/0xe20
Jan  9 12:06:33 twin kernel: [<ffffffff813438ef>] ?
btrfs_ioctl_balance+0x14f/0x340
Jan  9 12:06:33 twin kernel: [<ffffffff81348cfc>] ? btrfs_ioctl+0x58c/0x2b10
Jan  9 12:06:33 twin kernel: [<ffffffff811ba90e>] ?
mem_cgroup_commit_charge+0x5e/0xa0
Jan  9 12:06:33 twin kernel: [<ffffffff81188798>] ?
handle_mm_fault+0x9a8/0xe90
Jan  9 12:06:33 twin kernel: [<ffffffff81036e58>] ?
__do_page_fault+0x1b8/0x450
Jan  9 12:06:33 twin kernel: [<ffffffff8118b9f1>] ? vma_link+0xb1/0xc0
Jan  9 12:06:33 twin kernel: [<ffffffff811cfda7>] ? do_vfs_ioctl+0x2d7/0x4b0
Jan  9 12:06:33 twin kernel: [<ffffffff811cfff9>] ? SyS_ioctl+0x79/0x90
Jan  9 12:06:33 twin kernel: [<ffffffff816b7948>] ? page_fault+0x28/0x30
Jan  9 12:06:33 twin kernel: [<ffffffff816b60ad>] ?
system_call_fastpath+0x1a/0x1f
Jan  9 12:06:33 twin kernel: Code: 8e fc ff ff 66 0f 1f 44 00 00 49 89
dc e9 e8 fe ff ff 45 31 ff 49 89 dc e9 dd fe ff ff 0f 0b 0f 0b 41 89 c5
e9 51 fc ff ff 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00 00 00 41
57 41 56 41 55
Jan  9 12:06:33 twin kernel: RIP  [<ffffffff81363181>]
relocate_block_group+0x661/0x670
Jan  9 12:06:33 twin kernel: RSP <ffff8800057f7b10>
Jan  9 12:06:33 twin kernel: ---[ end trace eabc51a5837da913 ]---

