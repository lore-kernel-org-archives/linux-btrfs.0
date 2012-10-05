Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38721 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2JERUi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 13:20:38 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so1224539qch.19
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 10:20:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121003205247.GO2370@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
	<CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
	<20121003205247.GO2370@localhost.localdomain>
Date: Fri, 5 Oct 2012 13:20:37 -0400
Message-ID: <CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
Subject: Re: Out of memory condition
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was able to reproduce the problem with the patch, now it fails in
extens_io.c instead of the compression module.

[  243.098892] Out of memory: Kill process 4227 (chrome) score 325 or
sacrifice child
[  243.098895] Killed process 4227 (chrome) total-vm:969800kB,
anon-rss:96824kB, file-rss:1800kB
[  243.146311] chrome: page allocation failure: order:0, mode:0x52
[  243.146315] Pid: 4227, comm: chrome Tainted: G         C O
3.5.0-17-generic #27-Ubuntu
[  243.146317] Call Trace:
[  243.146324]  [<ffffffff811281ab>] warn_alloc_failed+0xeb/0x140
[  243.146329]  [<ffffffff8112bdf9>] __alloc_pages_nodemask+0x659/0x920
[  243.146333]  [<ffffffff81164880>] alloc_pages_current+0xb0/0x120
[  243.146360]  [<ffffffffa01d0cd1>]
btrfs_submit_compressed_read+0x1c1/0x510 [btrfs]
[  243.146375]  [<ffffffffa018ee31>] btrfs_submit_bio_hook+0x141/0x150 [btrfs]
[  243.146387]  [<ffffffffa0191196>] ? btrfs_get_extent+0xf6/0x900 [btrfs]
[  243.146402]  [<ffffffffa01ad237>] submit_one_bio+0x67/0xa0 [btrfs]
[  243.146415]  [<ffffffffa01b0f29>]
submit_extent_page.isra.35+0xa9/0x1f0 [btrfs]
[  243.146427]  [<ffffffffa01b15ae>] __extent_read_full_page+0x46e/0x6a0 [btrfs]
[  243.146439]  [<ffffffffa01b0330>] ? repair_io_failure+0x1e0/0x1e0 [btrfs]
[  243.146452]  [<ffffffffa01910a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[  243.146466]  [<ffffffffa01b2694>] extent_readpages+0xc4/0x100 [btrfs]
[  243.146478]  [<ffffffffa01910a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[  243.146490]  [<ffffffffa018f2ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[  243.146493]  [<ffffffff8112e1c9>] __do_page_cache_readahead+0x1b9/0x260
[  243.146496]  [<ffffffff8112e5d1>] ra_submit+0x21/0x30
[  243.146499]  [<ffffffff81125423>] filemap_fault+0x3f3/0x450
[  243.146503]  [<ffffffff8117bf9f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[  243.146506]  [<ffffffff8114693f>] __do_fault+0x6f/0x530
[  243.146510]  [<ffffffff81149d94>] handle_pte_fault+0x94/0x430
[  243.146514]  [<ffffffff810ab0ab>] ? wake_futex+0x3b/0x60
[  243.146517]  [<ffffffff810ab1db>] ? futex_wake+0x10b/0x130
[  243.146521]  [<ffffffff8114ae89>] handle_mm_fault+0x259/0x320
[  243.146525]  [<ffffffff816856eb>] do_page_fault+0x16b/0x4e0
[  243.146529]  [<ffffffff8108a77f>] ? __dequeue_entity+0x2f/0x50
[  243.146533]  [<ffffffff810125be>] ? __switch_to+0x16e/0x420
[  243.146536]  [<ffffffff810ade1d>] ? sys_futex+0x8d/0x190
[  243.146539]  [<ffffffff81682225>] page_fault+0x25/0x30
[  243.146541] Mem-Info:
[  243.146542] Node 0 DMA per-cpu:
[  243.146545] CPU    0: hi:    0, btch:   1 usd:   0
[  243.146547] CPU    1: hi:    0, btch:   1 usd:   0
[  243.146548] CPU    2: hi:    0, btch:   1 usd:   0
[  243.146550] CPU    3: hi:    0, btch:   1 usd:   0
[  243.146551] Node 0 DMA32 per-cpu:
[  243.146553] CPU    0: hi:  186, btch:  31 usd:   0
[  243.146555] CPU    1: hi:  186, btch:  31 usd:   0
[  243.146557] CPU    2: hi:  186, btch:  31 usd:   0
[  243.146558] CPU    3: hi:  186, btch:  31 usd:   0
[  243.146559] Node 0 Normal per-cpu:
[  243.146562] CPU    0: hi:  186, btch:  31 usd:   0
[  243.146563] CPU    1: hi:  186, btch:  31 usd:   0
[  243.146565] CPU    2: hi:  186, btch:  31 usd:   0
[  243.146566] CPU    3: hi:  186, btch:  31 usd:   0
[  243.146571] active_anon:364240 inactive_anon:77778 isolated_anon:0
[  243.146571]  active_file:2106 inactive_file:3378 isolated_file:64
[  243.146571]  unevictable:7829 dirty:333 writeback:0 unstable:0
[  243.146571]  free:21739 slab_reclaimable:7937 slab_unreclaimable:13177
[  243.146571]  mapped:453114 shmem:85612 pagetables:13858 bounce:0
[  243.146574] Node 0 DMA free:15872kB min:260kB low:324kB high:388kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:32kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[  243.146579] lowmem_reserve[]: 0 2903 3903 3903
[  243.146583] Node 0 DMA32 free:53844kB min:50068kB low:62584kB
high:75100kB active_anon:1212420kB inactive_anon:119980kB
active_file:5836kB inactive_file:9252kB unevictable:32kB
isolated(anon):0kB isolated(file):256kB present:2972960kB mlocked:32kB
dirty:816kB writeback:0kB mapped:1464712kB shmem:143260kB
slab_reclaimable:9892kB slab_unreclaimable:24052kB kernel_stack:2600kB
pagetables:33620kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:33837 all_unreclaimable? yes
[  243.146589] lowmem_reserve[]: 0 0 1000 1000
[  243.146592] Node 0 Normal free:17240kB min:17248kB low:21560kB
high:25872kB active_anon:244540kB inactive_anon:191132kB
active_file:2588kB inactive_file:4260kB unevictable:31284kB
isolated(anon):0kB isolated(file):0kB present:1024128kB
mlocked:31284kB dirty:516kB writeback:0kB mapped:347744kB
shmem:199188kB slab_reclaimable:21856kB slab_unreclaimable:28624kB
kernel_stack:3360kB pagetables:21812kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:20615 all_unreclaimable? yes
[  243.146597] lowmem_reserve[]: 0 0 0 0
[  243.146601] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 2*64kB 1*128kB
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15872kB
[  243.146610] Node 0 DMA32: 693*4kB 928*8kB 1439*16kB 214*32kB
44*64kB 19*128kB 11*256kB 2*512kB 1*1024kB 0*2048kB 1*4096kB = 54276kB
[  243.146618] Node 0 Normal: 212*4kB 832*8kB 379*16kB 25*32kB 4*64kB
1*128kB 2*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 17312kB
[  243.146627] 92727 total pagecache pages
[  243.146628] 0 pages in swap cache
[  243.146630] Swap cache stats: add 0, delete 0, find 0/0
[  243.146631] Free swap  = 0kB
[  243.146632] Total swap = 0kB
[  243.158451] 1046512 pages RAM
[  243.158454] 503707 pages reserved
[  243.158455] 153271 pages shared
[  243.158456] 474900 pages non-shared
[  243.433678] ------------[ cut here ]------------
[  243.433712] kernel BUG at
/build/buildd/linux-3.5.0/fs/btrfs/extent_io.c:2705!
[  243.433755] invalid opcode: 0000 [#1] SMP
[  243.433782] CPU 1
[  243.433798] Modules linked in: pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) joydev snd_hda_codec_hdmi
snd_hda_codec_realtek uvcvideo videobuf2_core videodev
videobuf2_vmalloc videobuf2_memops rts5139(C) asus_nb_wmi asus_wmi
sparse_keymap snd_hda_intel snd_hda_codec snd_hwdep ath3k btusb
snd_pcm coretemp kvm_intel kvm snd_seq_midi snd_rawmidi microcode
snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse serio_raw
lpc_ich snd arc4 ath9k mac80211 mac_hid ath9k_common ath9k_hw
soundcore ath snd_page_alloc mei cfg80211 rfcomm bnep parport_pc
bluetooth ppdev lp parport binfmt_misc btrfs zlib_deflate libcrc32c
dm_crypt hid_generic usbhid hid ghash_clmulni_intel aesni_intel cryptd
aes_x86_64 i915 wmi drm_kms_helper drm i2c_algo_bit video
[  243.434271]
[  243.434275] Pid: 4227, comm: chrome Tainted: G         C O
3.5.0-17-generic #27-Ubuntu ASUSTeK Computer Inc. UX31E/UX31E
[  243.434338] RIP: 0010:[<ffffffffa01b17d0>]  [<ffffffffa01b17d0>]
__extent_read_full_page+0x690/0x6a0 [btrfs]
[  243.434414] RSP: 0000:ffff880065f51a28  EFLAGS: 00010246
[  243.434444] RAX: 00000000fffffff4 RBX: 0000000000001000 RCX: 0000000000000000
[  243.434485] RDX: 0000000000016710 RSI: 0000000000000029 RDI: ffff8801385f4fc0
[  243.434526] RBP: ffff880065f51b28 R08: ffff8801385f40c0 R09: 00000001802a0029
[  243.434568] R10: 0000000000000001 R11: ffffffffa01d0d19 R12: 0000000001e80fff
[  243.434608] R13: 0000000995404000 R14: 0000000001e80000 R15: 0000000000000000
[  243.434649] FS:  00007f9c283a99c0(0000) GS:ffff88013f420000(0000)
knlGS:0000000000000000
[  243.434693] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  243.434725] CR2: 00007ff007238b44 CR3: 000000009ad02000 CR4: 00000000000427e0
[  243.434766] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  243.434809] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  243.434850] Process chrome (pid: 4227, threadinfo ffff880065f50000,
task ffff880065d15c00)
[  243.434895] Stack:
[  243.434908]  ffff88013a411380 ffff880065f51b48 ffffffffa01b0330
ffffffff00000000
[  243.434954]  0000000000020001 0000000000020001 0000000001e9ffff
ffff880065f51b48
[  243.434997]  ffff880065f51fd8 ffff88006d3ef000 0000000000000000
ffff880065f51b50
[  243.435042] Call Trace:
[  243.435076]  [<ffffffffa01b0330>] ? repair_io_failure+0x1e0/0x1e0 [btrfs]
[  243.437097]  [<ffffffffa01910a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[  243.439096]  [<ffffffffa01b2694>] extent_readpages+0xc4/0x100 [btrfs]
[  243.441034]  [<ffffffffa01910a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[  243.443002]  [<ffffffffa018f2ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[  243.444933]  [<ffffffff8112e1c9>] __do_page_cache_readahead+0x1b9/0x260
[  243.446912]  [<ffffffff8112e5d1>] ra_submit+0x21/0x30
[  243.448825]  [<ffffffff81125423>] filemap_fault+0x3f3/0x450
[  243.450815]  [<ffffffff8117bf9f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[  243.452829]  [<ffffffff8114693f>] __do_fault+0x6f/0x530
[  243.454781]  [<ffffffff81149d94>] handle_pte_fault+0x94/0x430
[  243.456685]  [<ffffffff810ab0ab>] ? wake_futex+0x3b/0x60
[  243.458593]  [<ffffffff810ab1db>] ? futex_wake+0x10b/0x130
[  243.460474]  [<ffffffff8114ae89>] handle_mm_fault+0x259/0x320
[  243.462407]  [<ffffffff816856eb>] do_page_fault+0x16b/0x4e0
[  243.464362]  [<ffffffff8108a77f>] ? __dequeue_entity+0x2f/0x50
[  243.466308]  [<ffffffff810125be>] ? __switch_to+0x16e/0x420
[  243.468187]  [<ffffffff810ade1d>] ? sys_futex+0x8d/0x190
[  243.470088]  [<ffffffff81682225>] page_fault+0x25/0x30
[  243.472037] Code: 00 00 00 4c 8b 7d 98 e9 45 fa ff ff 4d 89 ef 41
bc 00 10 00 00 45 31 d2 c7 85 54 ff ff ff 00 00 00 00 e9 e7 fe ff ff
0f 0b 0f 0b <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
e5 41
[  243.476187] RIP  [<ffffffffa01b17d0>]
__extent_read_full_page+0x690/0x6a0 [btrfs]
[  243.478336]  RSP <ffff880065f51a28>
[  243.576497] ---[ end trace a5c4d5d3c1734c46 ]---


On Wed, Oct 3, 2012 at 4:52 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Can you give this a try please?  Thanks,
>
> Josef
