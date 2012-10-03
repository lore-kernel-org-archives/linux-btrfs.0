Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43842 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JCOZM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 10:25:12 -0400
Received: by qchd3 with SMTP id d3so5590629qch.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 07:25:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
Date: Wed, 3 Oct 2012 10:25:11 -0400
Message-ID: <CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
Subject: Out of memory condition
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know how to diagnose the problem, but now it is the second
time. After starting a VM in VirtualBox and filling the memory, Chrome
stopped loading any pages. After logging out and on, it still wasn't
working, reboot fixed it.

This time, I've had the same problem and took the backtrace. Chrome
starts but doesn't load any pages, I guess it is stuck reading a file
as many chrome process are in state 'Ds' but are still killable,
Chrome seems really hard to strace bu anyway strace freezes in D state
too when attached to a running process.

The whole filesystem is BTRFS.

Here is the trace:

[51484.566104] Out of memory: Kill process 23108 (chrome) score 330 or
sacrifice child
[51484.566107] Killed process 23108 (chrome) total-vm:995880kB,
anon-rss:111548kB, file-rss:8616kB
[51484.579761] chrome: page allocation failure: order:0, mode:0x52
[51484.579765] Pid: 23108, comm: chrome Tainted: G         C O
3.5.0-16-generic #25-Ubuntu
[51484.579767] Call Trace:
[51484.579775]  [<ffffffff8112838b>] warn_alloc_failed+0xeb/0x140
[51484.579779]  [<ffffffff8112bfc9>] __alloc_pages_nodemask+0x659/0x920
[51484.579783]  [<ffffffff81164a30>] alloc_pages_current+0xb0/0x120
[51484.579812]  [<ffffffffa01a3cd1>]
btrfs_submit_compressed_read+0x1c1/0x510 [btrfs]
[51484.579828]  [<ffffffffa0161e31>] btrfs_submit_bio_hook+0x141/0x150 [btrfs]
[51484.579843]  [<ffffffffa0164196>] ? btrfs_get_extent+0xf6/0x900 [btrfs]
[51484.579859]  [<ffffffffa0180237>] submit_one_bio+0x67/0xa0 [btrfs]
[51484.579874]  [<ffffffffa0183f29>]
submit_extent_page.isra.35+0xa9/0x1f0 [btrfs]
[51484.579889]  [<ffffffffa01845ae>] __extent_read_full_page+0x46e/0x6a0 [btrfs]
[51484.579902]  [<ffffffffa0183330>] ? repair_io_failure+0x1e0/0x1e0 [btrfs]
[51484.579917]  [<ffffffffa01640a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[51484.579932]  [<ffffffffa0185694>] extent_readpages+0xc4/0x100 [btrfs]
[51484.579945]  [<ffffffffa01640a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[51484.579958]  [<ffffffffa01622ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[51484.579961]  [<ffffffff8112e399>] __do_page_cache_readahead+0x1b9/0x260
[51484.579964]  [<ffffffff8112e7a1>] ra_submit+0x21/0x30
[51484.579967]  [<ffffffff81125603>] filemap_fault+0x3f3/0x450
[51484.579971]  [<ffffffff8117c14f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[51484.579974]  [<ffffffff81146aef>] __do_fault+0x6f/0x530
[51484.579978]  [<ffffffff81149f44>] handle_pte_fault+0x94/0x430
[51484.579982]  [<ffffffff810ab33b>] ? wake_futex+0x3b/0x60
[51484.579985]  [<ffffffff810ab46b>] ? futex_wake+0x10b/0x130
[51484.579988]  [<ffffffff8114b039>] handle_mm_fault+0x259/0x320
[51484.579992]  [<ffffffff81684eeb>] do_page_fault+0x16b/0x4e0
[51484.579997]  [<ffffffff8108a83f>] ? __dequeue_entity+0x2f/0x50
[51484.580000]  [<ffffffff810125be>] ? __switch_to+0x16e/0x420
[51484.580005]  [<ffffffff81083d1a>] ? finish_task_switch+0x4a/0xf0
[51484.580009]  [<ffffffff8167fcaf>] ? __schedule+0x3cf/0x7c0
[51484.580013]  [<ffffffff81681a25>] page_fault+0x25/0x30
[51484.580014] Mem-Info:
[51484.580016] Node 0 DMA per-cpu:
[51484.580019] CPU    0: hi:    0, btch:   1 usd:   0
[51484.580020] CPU    1: hi:    0, btch:   1 usd:   0
[51484.580022] CPU    2: hi:    0, btch:   1 usd:   0
[51484.580024] CPU    3: hi:    0, btch:   1 usd:   0
[51484.580025] Node 0 DMA32 per-cpu:
[51484.580027] CPU    0: hi:  186, btch:  31 usd:   0
[51484.580029] CPU    1: hi:  186, btch:  31 usd:   0
[51484.580031] CPU    2: hi:  186, btch:  31 usd:   0
[51484.580032] CPU    3: hi:  186, btch:  31 usd:   0
[51484.580033] Node 0 Normal per-cpu:
[51484.580035] CPU    0: hi:  186, btch:  31 usd:   0
[51484.580037] CPU    1: hi:  186, btch:  31 usd:   0
[51484.580039] CPU    2: hi:  186, btch:  31 usd:   0
[51484.580040] CPU    3: hi:  186, btch:  31 usd:   0
[51484.580045] active_anon:585616 inactive_anon:73483 isolated_anon:0
[51484.580045]  active_file:3212 inactive_file:4724 isolated_file:240
[51484.580045]  unevictable:7848 dirty:50 writeback:0 unstable:0
[51484.580045]  free:21762 slab_reclaimable:10065 slab_unreclaimable:13900
[51484.580045]  mapped:234726 shmem:138714 pagetables:14211 bounce:0
[51484.580048] Node 0 DMA free:15832kB min:260kB low:324kB high:388kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB
mlocked:0kB dirty:0kB writeback:0kB mapped:20kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:48kB kernel_stack:0kB
pagetables:4kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[51484.580054] lowmem_reserve[]: 0 2903 3903 3903
[51484.580058] Node 0 DMA32 free:53968kB min:50068kB low:62584kB
high:75100kB active_anon:1699228kB inactive_anon:199784kB
active_file:12328kB inactive_file:17844kB unevictable:64kB
isolated(anon):0kB isolated(file):960kB present:2972960kB mlocked:64kB
dirty:156kB writeback:0kB mapped:873720kB shmem:380064kB
slab_reclaimable:20736kB slab_unreclaimable:29028kB
kernel_stack:2880kB pagetables:36924kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:46978 all_unreclaimable? yes
[51484.580064] lowmem_reserve[]: 0 0 1000 1000
[51484.580067] Node 0 Normal free:17248kB min:17248kB low:21560kB
high:25872kB active_anon:643236kB inactive_anon:94148kB
active_file:520kB inactive_file:1052kB unevictable:31328kB
isolated(anon):0kB isolated(file):0kB present:1024128kB
mlocked:31328kB dirty:44kB writeback:0kB mapped:65164kB shmem:174792kB
slab_reclaimable:19524kB slab_unreclaimable:26524kB
kernel_stack:2808kB pagetables:19916kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:14119 all_unreclaimable? yes
[51484.580073] lowmem_reserve[]: 0 0 0 0
[51484.580076] Node 0 DMA: 0*4kB 1*8kB 1*16kB 2*32kB 0*64kB 1*128kB
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15832kB
[51484.580086] Node 0 DMA32: 5065*4kB 2474*8kB 481*16kB 72*32kB 8*64kB
2*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 54148kB
[51484.580095] Node 0 Normal: 3314*4kB 61*8kB 3*16kB 0*32kB 0*64kB
1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 17248kB
[51484.580105] 148529 total pagecache pages
[51484.580107] 0 pages in swap cache
[51484.580108] Swap cache stats: add 0, delete 0, find 0/0
[51484.580110] Free swap  = 0kB
[51484.580111] Total swap = 0kB
[51484.593000] 1046512 pages RAM
[51484.593003] 283984 pages reserved
[51484.593005] 166593 pages shared
[51484.593006] 680575 pages non-shared
[51484.593024] BUG: unable to handle kernel paging request at ffffeb880004355c
[51484.593077] IP: [<ffffffff8112aea9>] __free_pages+0x9/0x40
[51484.593118] PGD 0
[51484.593133] Oops: 0002 [#1] SMP
[51484.593156] CPU 3
[51484.593170] Modules linked in: rtl8187 eeprom_93cx6 nls_iso8859_1
usb_storage pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) joydev
hid_generic usbhid hid vboxdrv(O) snd_hda_codec_hdmi
snd_hda_codec_realtek coretemp kvm_intel kvm asus_nb_wmi asus_wmi
sparse_keymap rts5139(C) ath3k btusb uvcvideo videobuf2_core videodev
videobuf2_vmalloc videobuf2_memops snd_hda_intel snd_hda_codec
snd_hwdep microcode snd_pcm psmouse serio_raw snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq arc4 mac_hid snd_timer ath9k snd_seq_device
mac80211 snd ath9k_common rfcomm ath9k_hw ath lpc_ich soundcore mei
snd_page_alloc cfg80211 bnep parport_pc ppdev bluetooth lp parport
binfmt_misc btrfs zlib_deflate libcrc32c dm_crypt ghash_clmulni_intel
aesni_intel cryptd aes_x86_64 wmi i915 drm_kms_helper drm i2c_algo_bit
video
[51484.593710]
[51484.593713] Pid: 23108, comm: chrome Tainted: G         C O
3.5.0-16-generic #25-Ubuntu ASUSTeK Computer Inc. UX31E/UX31E
[51484.593784] RIP: 0010:[<ffffffff8112aea9>]  [<ffffffff8112aea9>]
__free_pages+0x9/0x40
[51484.593838] RSP: 0018:ffff8801202eb878  EFLAGS: 00010282
[51484.593872] RAX: 0000018800043540 RBX: ffff880136eb15c0 RCX: 0000000000000000
[51484.593917] RDX: ffffffff7fffffff RSI: 0000000000000000 RDI: ffffeb8800043540
[51484.593962] RBP: ffff8801202eb878 R08: 0000000000001637 R09: 0000000000000000
[51484.594007] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000001
[51484.594051] R13: 0000000000000010 R14: 000000000000000f R15: 0000000000000010
[51484.594097] FS:  00007fac9823a9c0(0000) GS:ffff88013f460000(0000)
knlGS:0000000000000000
[51484.594148] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[51484.594185] CR2: ffffeb880004355c CR3: 0000000137b66000 CR4: 00000000000427e0
[51484.594231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[51484.594276] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[51484.594321] Process chrome (pid: 23108, threadinfo
ffff8801202ea000, task ffff880137c39700)
[51484.594373] Stack:
[51484.596457]  ffff8801202eb898 ffffffff8112af1d 000000000000000f
0000000000000000
[51484.598565]  ffff8801202eb928 ffffffffa01a3d03 ffff8801202eb8f8
ffff880067da9720
[51484.600700]  ffff880138f63000 ffff8801366f1380 00000000202eb8f8
0000000002100000
[51484.602853] Call Trace:
[51484.604996]  [<ffffffff8112af1d>] free_pages+0x3d/0x40
[51484.607167]  [<ffffffffa01a3d03>]
btrfs_submit_compressed_read+0x1f3/0x510 [btrfs]
[51484.609379]  [<ffffffffa0161e31>] btrfs_submit_bio_hook+0x141/0x150 [btrfs]
[51484.611589]  [<ffffffffa0164196>] ? btrfs_get_extent+0xf6/0x900 [btrfs]
[51484.613785]  [<ffffffffa0180237>] submit_one_bio+0x67/0xa0 [btrfs]
[51484.615992]  [<ffffffffa0183f29>]
submit_extent_page.isra.35+0xa9/0x1f0 [btrfs]
[51484.618173]  [<ffffffffa01845ae>] __extent_read_full_page+0x46e/0x6a0 [btrfs]
[51484.620372]  [<ffffffffa0183330>] ? repair_io_failure+0x1e0/0x1e0 [btrfs]
[51484.622571]  [<ffffffffa01640a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[51484.624772]  [<ffffffffa0185694>] extent_readpages+0xc4/0x100 [btrfs]
[51484.626954]  [<ffffffffa01640a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[51484.629137]  [<ffffffffa01622ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[51484.631310]  [<ffffffff8112e399>] __do_page_cache_readahead+0x1b9/0x260
[51484.633476]  [<ffffffff8112e7a1>] ra_submit+0x21/0x30
[51484.635636]  [<ffffffff81125603>] filemap_fault+0x3f3/0x450
[51484.637795]  [<ffffffff8117c14f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[51484.639979]  [<ffffffff81146aef>] __do_fault+0x6f/0x530
[51484.642160]  [<ffffffff81149f44>] handle_pte_fault+0x94/0x430
[51484.644328]  [<ffffffff810ab33b>] ? wake_futex+0x3b/0x60
[51484.646491]  [<ffffffff810ab46b>] ? futex_wake+0x10b/0x130
[51484.648672]  [<ffffffff8114b039>] handle_mm_fault+0x259/0x320
[51484.650788]  [<ffffffff81684eeb>] do_page_fault+0x16b/0x4e0
[51484.652823]  [<ffffffff8108a83f>] ? __dequeue_entity+0x2f/0x50
[51484.654807]  [<ffffffff810125be>] ? __switch_to+0x16e/0x420
[51484.656768]  [<ffffffff81083d1a>] ? finish_task_switch+0x4a/0xf0
[51484.658744]  [<ffffffff8167fcaf>] ? __schedule+0x3cf/0x7c0
[51484.660702]  [<ffffffff81681a25>] page_fault+0x25/0x30
[51484.662643] Code: 00 30 d2 48 89 de 4c 89 45 c8 e8 83 f3 ff ff 4c
8b 45 c8 e9 5f ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
66 66 66 90 <f0> ff 4f 1c 0f 94 c0 84 c0 74 09 85 f6 74 10 e8 13 fd ff
ff 5d
[51484.666879] RIP  [<ffffffff8112aea9>] __free_pages+0x9/0x40
[51484.669018]  RSP <ffff8801202eb878>
[51484.671076] CR2: ffffeb880004355c
[51484.714384] ---[ end trace 024de8de83cf4958 ]---
