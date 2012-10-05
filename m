Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54303 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEUX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 16:23:26 -0400
Received: by mail-qc0-f174.google.com with SMTP id d3so1373013qch.19
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Oct 2012 13:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121005174316.GQ2370@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
	<CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
	<20121003205247.GO2370@localhost.localdomain>
	<CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
	<20121005174316.GQ2370@localhost.localdomain>
Date: Fri, 5 Oct 2012 16:23:25 -0400
Message-ID: <CALJXSJpxgjy6cEGhpnKQby0b_GE0XgajN9B5PSrLm7kZv7jtZw@mail.gmail.com>
Subject: Re: Out of memory condition
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I guess I'll be the guy who will test out of memory conditions! Here's
another stack further down the code.

[ 1027.492250] Out of memory: Kill process 7674 (Chrome_ChildIOT)
score 322 or sacrifice child
[ 1027.492252] Killed process 7674 (Chrome_ChildIOT)
total-vm:960208kB, anon-rss:86952kB, file-rss:2244kB
[ 1027.510808] Chrome_ChildIOT: page allocation failure: order:0, mode:0x50
[ 1027.510814] Pid: 7674, comm: Chrome_ChildIOT Tainted: G      D  C O
3.5.0-17-generic #27-Ubuntu
[ 1027.510816] Call Trace:
[ 1027.510825]  [<ffffffff811281ab>] warn_alloc_failed+0xeb/0x140
[ 1027.510829]  [<ffffffff8112bdf9>] __alloc_pages_nodemask+0x659/0x920
[ 1027.510836]  [<ffffffff81164880>] alloc_pages_current+0xb0/0x120
[ 1027.510840]  [<ffffffff81122d0f>] __page_cache_alloc+0xaf/0xd0
[ 1027.510844]  [<ffffffff81123bfc>] find_or_create_page+0x4c/0xb0
[ 1027.510872]  [<ffffffffa01af341>] ? __alloc_extent_buffer+0xd1/0x150 [btrfs]
[ 1027.510889]  [<ffffffffa01b4b41>] alloc_extent_buffer+0x111/0x440 [btrfs]
[ 1027.510903]  [<ffffffffa01891a5>]
btrfs_find_create_tree_block+0x25/0x30 [btrfs]
[ 1027.510916]  [<ffffffffa018929f>] readahead_tree_block+0x1f/0x60 [btrfs]
[ 1027.510926]  [<ffffffffa016ea0d>]
read_block_for_search.isra.43+0x32d/0x3f0 [btrfs]
[ 1027.510941]  [<ffffffffa01c6f90>] ? btrfs_tree_read_unlock+0x50/0xa0 [btrfs]
[ 1027.510952]  [<ffffffffa0170cd0>] btrfs_search_slot+0x360/0x8f0 [btrfs]
[ 1027.510965]  [<ffffffffa0184198>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[ 1027.510978]  [<ffffffffa0193251>] btrfs_get_extent+0x1b1/0x900 [btrfs]
[ 1027.510994]  [<ffffffffa01ae690>] ?
btrfs_lookup_ordered_extent+0x90/0xd0 [btrfs]
[ 1027.511008]  [<ffffffffa01b3418>] __extent_read_full_page+0x2d8/0x6b0 [btrfs]
[ 1027.511012]  [<ffffffff8117b92b>] ? mem_cgroup_charge_common+0x6b/0xa0
[ 1027.511026]  [<ffffffffa01930a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[ 1027.511040]  [<ffffffffa01b46a4>] extent_readpages+0xc4/0x100 [btrfs]
[ 1027.511054]  [<ffffffffa01930a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[ 1027.511067]  [<ffffffffa01912ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[ 1027.511070]  [<ffffffff8112e1c9>] __do_page_cache_readahead+0x1b9/0x260
[ 1027.511074]  [<ffffffff8112e5d1>] ra_submit+0x21/0x30
[ 1027.511077]  [<ffffffff81125423>] filemap_fault+0x3f3/0x450
[ 1027.511081]  [<ffffffff8117bf9f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[ 1027.511085]  [<ffffffff8114693f>] __do_fault+0x6f/0x530
[ 1027.511089]  [<ffffffff81149d94>] handle_pte_fault+0x94/0x430
[ 1027.511093]  [<ffffffff8114ae89>] handle_mm_fault+0x259/0x320
[ 1027.511097]  [<ffffffff816856eb>] do_page_fault+0x16b/0x4e0
[ 1027.511101]  [<ffffffff812b2c12>] ? security_file_permission+0x92/0xb0
[ 1027.511105]  [<ffffffff81682225>] page_fault+0x25/0x30
[ 1027.511106] Mem-Info:
[ 1027.511108] Node 0 DMA per-cpu:
[ 1027.511111] CPU    0: hi:    0, btch:   1 usd:   0
[ 1027.511112] CPU    1: hi:    0, btch:   1 usd:   0
[ 1027.511114] CPU    2: hi:    0, btch:   1 usd:   0
[ 1027.511116] CPU    3: hi:    0, btch:   1 usd:   0
[ 1027.511118] Node 0 DMA32 per-cpu:
[ 1027.511121] CPU    0: hi:  186, btch:  31 usd:   0
[ 1027.511122] CPU    1: hi:  186, btch:  31 usd:   0
[ 1027.511125] CPU    2: hi:  186, btch:  31 usd:   0
[ 1027.511126] CPU    3: hi:  186, btch:  31 usd:   0
[ 1027.511128] Node 0 Normal per-cpu:
[ 1027.511130] CPU    0: hi:  186, btch:  31 usd:   0
[ 1027.511132] CPU    1: hi:  186, btch:  31 usd:   0
[ 1027.511134] CPU    2: hi:  186, btch:  31 usd:   0
[ 1027.511136] CPU    3: hi:  186, btch:  31 usd:   0
[ 1027.511140] active_anon:427066 inactive_anon:67353 isolated_anon:0
[ 1027.511140]  active_file:2896 inactive_file:3397 isolated_file:293
[ 1027.511140]  unevictable:7846 dirty:2164 writeback:0 unstable:0
[ 1027.511140]  free:21630 slab_reclaimable:8990 slab_unreclaimable:12773
[ 1027.511140]  mapped:406065 shmem:90702 pagetables:14073 bounce:0
[ 1027.511144] Node 0 DMA free:15332kB min:260kB low:324kB high:388kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB
mlocked:0kB dirty:0kB writeback:0kB mapped:516kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:32kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[ 1027.511151] lowmem_reserve[]: 0 2903 3903 3903
[ 1027.511155] Node 0 DMA32 free:53948kB min:50068kB low:62584kB
high:75100kB active_anon:1472984kB inactive_anon:201832kB
active_file:9848kB inactive_file:11632kB unevictable:32kB
isolated(anon):0kB isolated(file):276kB present:2972960kB mlocked:32kB
dirty:6412kB writeback:0kB mapped:1123804kB shmem:265684kB
slab_reclaimable:14932kB slab_unreclaimable:23196kB
kernel_stack:2920kB pagetables:36432kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:56952 all_unreclaimable? yes
[ 1027.511162] lowmem_reserve[]: 0 0 1000 1000
[ 1027.511166] Node 0 Normal free:17240kB min:17248kB low:21560kB
high:25872kB active_anon:235280kB inactive_anon:67580kB
active_file:1736kB inactive_file:2056kB unevictable:31352kB
isolated(anon):0kB isolated(file):768kB present:1024128kB
mlocked:31352kB dirty:2244kB writeback:0kB mapped:499940kB
shmem:97124kB slab_reclaimable:21028kB slab_unreclaimable:27864kB
kernel_stack:3016kB pagetables:19860kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:83114 all_unreclaimable? no
[ 1027.511173] lowmem_reserve[]: 0 0 0 0
[ 1027.511177] Node 0 DMA: 1*4kB 0*8kB 0*16kB 1*32kB 1*64kB 1*128kB
1*256kB 1*512kB 0*1024kB 1*2048kB 3*4096kB = 15332kB
[ 1027.511187] Node 0 DMA32: 4202*4kB 3381*8kB 411*16kB 2*32kB 1*64kB
0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 54400kB
[ 1027.511198] Node 0 Normal: 3232*4kB 89*8kB 3*16kB 4*32kB 4*64kB
1*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 17272kB
[ 1027.511208] 98814 total pagecache pages
[ 1027.511210] 0 pages in swap cache
[ 1027.511212] Swap cache stats: add 0, delete 0, find 0/0
[ 1027.511213] Free swap  = 0kB
[ 1027.511215] Total swap = 0kB
[ 1027.524135] 1046512 pages RAM
[ 1027.524139] 457115 pages reserved
[ 1027.524140] 154033 pages shared
[ 1027.524141] 523655 pages non-shared
[ 1027.524144] ------------[ cut here ]------------
[ 1027.524175] WARNING: at
/usr/src/linux-source-3.5.0/linux-source-3.5.0-btrfs-oom/fs/btrfs/extent_io.c:4165
alloc_extent_buffer+0x321/0x440 [btrfs]()
[ 1027.524176] Hardware name: UX31E
[ 1027.524178] Modules linked in: pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) joydev snd_hda_codec_hdmi
snd_hda_codec_realtek rfcomm parport_pc ppdev bnep lp parport
binfmt_misc uvcvideo videobuf2_core videodev videobuf2_vmalloc
videobuf2_memops coretemp kvm_intel kvm rts5139(C) asus_nb_wmi
asus_wmi sparse_keymap snd_hda_intel snd_hda_codec snd_hwdep ath3k
btusb bluetooth snd_pcm snd_seq_midi microcode snd_rawmidi psmouse
serio_raw lpc_ich snd_seq_midi_event mac_hid arc4 snd_seq snd_timer
snd_seq_device ath9k mac80211 snd ath9k_common ath9k_hw ath soundcore
cfg80211 snd_page_alloc mei btrfs(O) zlib_deflate libcrc32c dm_crypt
hid_generic usbhid hid ghash_clmulni_intel aesni_intel cryptd
aes_x86_64 i915 wmi drm_kms_helper drm i2c_algo_bit video
[ 1027.524233] Pid: 7674, comm: Chrome_ChildIOT Tainted: G      D  C O
3.5.0-17-generic #27-Ubuntu
[ 1027.524235] Call Trace:
[ 1027.524242]  [<ffffffff81051c4f>] warn_slowpath_common+0x7f/0xc0
[ 1027.524245]  [<ffffffff81051caa>] warn_slowpath_null+0x1a/0x20
[ 1027.524260]  [<ffffffffa01b4d51>] alloc_extent_buffer+0x321/0x440 [btrfs]
[ 1027.524273]  [<ffffffffa01891a5>]
btrfs_find_create_tree_block+0x25/0x30 [btrfs]
[ 1027.524285]  [<ffffffffa018929f>] readahead_tree_block+0x1f/0x60 [btrfs]
[ 1027.524295]  [<ffffffffa016ea0d>]
read_block_for_search.isra.43+0x32d/0x3f0 [btrfs]
[ 1027.524309]  [<ffffffffa01c6f90>] ? btrfs_tree_read_unlock+0x50/0xa0 [btrfs]
[ 1027.524319]  [<ffffffffa0170cd0>] btrfs_search_slot+0x360/0x8f0 [btrfs]
[ 1027.524332]  [<ffffffffa0184198>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[ 1027.524345]  [<ffffffffa0193251>] btrfs_get_extent+0x1b1/0x900 [btrfs]
[ 1027.524361]  [<ffffffffa01ae690>] ?
btrfs_lookup_ordered_extent+0x90/0xd0 [btrfs]
[ 1027.524375]  [<ffffffffa01b3418>] __extent_read_full_page+0x2d8/0x6b0 [btrfs]
[ 1027.524379]  [<ffffffff8117b92b>] ? mem_cgroup_charge_common+0x6b/0xa0
[ 1027.524393]  [<ffffffffa01930a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[ 1027.524407]  [<ffffffffa01b46a4>] extent_readpages+0xc4/0x100 [btrfs]
[ 1027.524420]  [<ffffffffa01930a0>] ? btrfs_real_readdir+0x620/0x620 [btrfs]
[ 1027.524432]  [<ffffffffa01912ef>] btrfs_readpages+0x1f/0x30 [btrfs]
[ 1027.524436]  [<ffffffff8112e1c9>] __do_page_cache_readahead+0x1b9/0x260
[ 1027.524439]  [<ffffffff8112e5d1>] ra_submit+0x21/0x30
[ 1027.524443]  [<ffffffff81125423>] filemap_fault+0x3f3/0x450
[ 1027.524447]  [<ffffffff8117bf9f>] ? mem_cgroup_update_page_stat+0x1f/0x60
[ 1027.524451]  [<ffffffff8114693f>] __do_fault+0x6f/0x530
[ 1027.524456]  [<ffffffff81149d94>] handle_pte_fault+0x94/0x430
[ 1027.524459]  [<ffffffff8114ae89>] handle_mm_fault+0x259/0x320
[ 1027.524464]  [<ffffffff816856eb>] do_page_fault+0x16b/0x4e0
[ 1027.524468]  [<ffffffff812b2c12>] ? security_file_permission+0x92/0xb0
[ 1027.524471]  [<ffffffff81682225>] page_fault+0x25/0x30
[ 1027.524474] ---[ end trace 6f136eb0e3515ae1 ]---
[ 1099.700074] vboxnetflt: dropped 0 out of 709 packets


On Fri, Oct 5, 2012 at 1:43 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Oct 05, 2012 at 11:20:37AM -0600, Jérôme Poulin wrote:
>> I was able to reproduce the problem with the patch, now it fails in
>> extens_io.c instead of the compression module.
>>
>
> Yeah so I fixed the compression side, and now it's erroring out further down.
> So leave the patch I gave you applied as it is correct, and apply this patch and
> see if it helps.  Thanks,
>
> Josef
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b82d244..8c37cb6 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2751,12 +2751,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>                                          end_bio_extent_readpage, mirror_num,
>                                          *bio_flags,
>                                          this_bio_flag);
> -                       BUG_ON(ret == -ENOMEM);
> -                       nr++;
> -                       *bio_flags = this_bio_flag;
> +                       if (!ret) {
> +                               nr++;
> +                               *bio_flags = this_bio_flag;
> +                       }
>                 }
> -               if (ret)
> +               if (ret) {
>                         SetPageError(page);
> +                       unlock_extent(tree, cur, cur + iosize - 1);
> +               }
>                 cur = cur + iosize;
>                 pg_offset += iosize;
>         }
