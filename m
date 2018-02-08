Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbeBHHy0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 02:54:26 -0500
Subject: Re: Crash when unraring large archives on btrfs-filesystem
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        linux-btrfs@vger.kernel.org
References: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6901d5a8-a8a2-d9fb-35db-4c1415d9d473@suse.com>
Date: Thu, 8 Feb 2018 09:54:24 +0200
MIME-Version: 1.0
In-Reply-To: <CAA3ktqnd8_kmiVNq_7L6G0ekiqGzSrfVbzTTc_5aUU9AygE02A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.02.2018 21:57, Stefan Malte Schumacher wrote:
> Hello,
> 
> 
> I have encountered what I think is a problem with btrfs, which causes
> my file server to become unresponsive. But let‘s start with the basic
> information:
> 
> uname -a = Linux mars 4.9.0-5-amd64 #1 SMP Debian 4.9.65-3+deb9u2
> (2018-01-04) x86_64 GNU/Linux
> 
> btrfs –version = btrfs-progs v4.7.3
> 
> 
> Label: none uuid: 1609e4e1-4037-4d31-bf12-f84a691db5d8
> 
> Total devices 5 FS bytes used 7.15TiB
> 
> devid 1 size 3.64TiB used 2.90TiB path /dev/sda
> 
> devid 2 size 3.64TiB used 2.90TiB path /dev/sdb
> 
> devid 3 size 3.64TiB used 2.90TiB path /dev/sdc
> 
> devid 4 size 3.64TiB used 2.90TiB path /dev/sdd
> 
> devid 5 size 3.64TiB used 2.90TiB path /dev/sde
> 
> 
> Data, RAID1: total=7.25TiB, used=7.14TiB
> 
> System, RAID1: total=40.00MiB, used=1.02MiB
> 
> Metadata, RAID1: total=9.00GiB, used=7.75GiB
> 
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> The following entry in kern.log seems to be the point where it all
> started and which causes me to believe that the problem is related to
> btrfs. At that time the server was unraring
> 
> a large archive stored on the btrfs filesystem.
> 
> 
> Feb 5 21:22:42 mars kernel: [249979.829318] BTRFS info (device sda):
> The free space cache file (4701944807424) is invalid. skip it

This tells you that your freespace cahe is likely corrupted, this is not
that critical but it's highly recommended you rebuild it. You can do
that by mounting your file system with the 'clear_cache' mount option.
For more information check
https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs(5)

> 
> Feb 5 21:22:42 mars kernel: [249979.829318]
> 
> Feb 5 21:25:12 mars kernel: [250090.149452] unrar: page allocation
> stalls for 12104ms, order:0, mode:0x24200ca(GFP_HIGHUSER_MOVABLE)
> 
> Feb 5 21:25:12 mars kernel: [250116.605420] [<ffffffffb4dd86ce>] ?
> alloc_pages_vma+0xae/0x260
> 
> Feb 5 21:25:12 mars kernel: [250116.605422] [<ffffffffb4dc8e28>] ?
> __read_swap_cache_async+0x118/0x1c0
> 
> Feb 5 21:25:12 mars kernel: [250116.605423] [<ffffffffb4dc8ef4>] ?
> read_swap_cache_async+0x24/0x60
> 
> Feb 5 21:25:12 mars kernel: [250116.605425] [<ffffffffb4dc90d9>] ?
> swapin_readahead+0x1a9/0x210
> 
> Feb 5 21:25:12 mars kernel: [250116.605427] [<ffffffffb4f2f6de>] ?
> radix_tree_lookup_slot+0x1e/0x50
> 
> Feb 5 21:25:12 mars kernel: [250116.605429] [<ffffffffb4d7c48b>] ?
> find_get_entry+0x1b/0x100
> 
> Feb 5 21:25:12 mars kernel: [250116.605431] [<ffffffffb4d7c960>] ?
> pagecache_get_page+0x30/0x2b0
> 
> Feb 5 21:25:12 mars kernel: [250116.605434] [<ffffffffb4db23c3>] ?
> do_swap_page+0x2a3/0x750
> 
> Feb 5 21:25:12 mars kernel: [250116.605436] [<ffffffffb4db3932>] ?
> handle_mm_fault+0x892/0x12d0
> 
> Feb 5 21:25:12 mars kernel: [250116.605438] [<ffffffffb4c5ee5c>] ?
> __do_page_fault+0x25c/0x500
> 
> Feb 5 21:25:12 mars kernel: [250116.605440] [<ffffffffb5208b58>] ?
> page_fault+0x28/0x30
> 
> Feb 5 21:25:12 mars kernel: [250116.605442] [<ffffffffb4f36efb>] ?
> __get_user_8+0x1b/0x25
> 
> Feb 5 21:25:12 mars kernel: [250116.605445] [<ffffffffb4cf7b50>] ?
> exit_robust_list+0x30/0x110
> 
> Feb 5 21:25:12 mars kernel: [250116.605447] [<ffffffffb4c739b8>] ?
> mm_release+0xf8/0x130
> 
> Feb 5 21:25:12 mars kernel: [250116.605449] [<ffffffffb4c7a8a0>] ?
> do_exit+0x150/0xae0
> 
> Feb 5 21:25:12 mars kernel: [250116.605450] [<ffffffffb4c7b2aa>] ?
> do_group_exit+0x3a/0xa0
> 
> Feb 5 21:25:12 mars kernel: [250116.605452] [<ffffffffb4c861e7>] ?
> get_signal+0x297/0x640
> 
> Feb 5 21:25:12 mars kernel: [250116.605454] [<ffffffffb4c254b6>] ?
> do_signal+0x36/0x6a0
> 
> Feb 5 21:25:12 mars kernel: [250116.605457] [<ffffffffb4c03251>] ?
> exit_to_usermode_loop+0x71/0xb0
> 
> Feb 5 21:25:12 mars kernel: [250116.605459] [<ffffffffb4c03a94>] ?
> syscall_return_slowpath+0x54/0x60
> 
> Feb 5 21:25:12 mars kernel: [250116.605461] [<ffffffffb52076c7>] ?
> system_call_fast_compare_end+0xb5/0xb7

THis call trace essentially tells you that your server sort of run out
of memory and you began to swap in i.e. read from the disk and it took a
rather long time (12s). Here no btrfs it is involved at all.

> 
> Feb 5 21:25:12 mars kernel: [250116.605462] Mem-Info:
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] active_anon:44
> inactive_anon:69 isolated_anon:0
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] active_file:3557188
> inactive_file:407932 isolated_file:1024
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] unevictable:0 dirty:409214
> writeback:62 unstable:0
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] slab_reclaimable:37022
> slab_unreclaimable:10475
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] mapped:2329 shmem:21
> pagetables:3522 bounce:0
> 
> Feb 5 21:25:12 mars kernel: [250116.605466] free:34036 free_pcp:291 free_cma:0
> 
> Feb 5 21:25:12 mars kernel: [250116.605471] Node 0 active_anon:176kB
> inactive_anon:276kB active_file:14228752kB inactive_file:1631728kB
> unevictable:0kB isolated(anon):0kB isolated(file):4096kB mapped:9316kB
> dirty:1636856kB writeback:248kB shmem:84kB shmem_thp: 0kB
> shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB
> pages_scanned:13631918 all_unreclaimable? no
> 
> 
> Searching for "btrfs" in kern.log shows a lot of entries for kern.log
> and kern.log.1 but but none before that point of time. I think that
> there is a relation between upgrading to kernel 4.9.0.5 and the start
> of these problems. What follows is the output of of "zless kern.log |
> grep btrfs".
> 
> Feb  5 21:25:21 mars kernel: [250128.490899] Workqueue: writeback
> wb_workfn (flush-btrfs-1)
> 
> Feb  5 21:25:21 mars kernel: [250128.490940]  [<ffffffffc074eefc>] ?
> io_ctl_prepare_pages+0x4c/0x180 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.490953]  [<ffffffffc07521cb>] ?
> __load_free_space_cache+0x1eb/0x6d0 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.490966]  [<ffffffffc0752799>] ?
> load_free_space_cache+0xe9/0x190 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.490975]  [<ffffffffc06e40d2>] ?
> cache_block_group+0x1c2/0x3c0 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.490989]  [<ffffffffc06f27bd>] ?
> find_free_extent+0x66d/0x10d0 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.490999]  [<ffffffffc06f32c1>] ?
> btrfs_reserve_extent+0xa1/0x210 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491011]  [<ffffffffc070d537>] ?
> cow_file_range.isra.59+0x167/0x500 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491022]  [<ffffffffc070e85b>] ?
> run_delalloc_range+0x38b/0x3c0 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491034]  [<ffffffffc07277c9>] ?
> writepage_delalloc.isra.44+0x109/0x170 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491046]  [<ffffffffc072a1a3>] ?
> __extent_writepage+0xd3/0x330 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491059]  [<ffffffffc072a650>] ?
> extent_write_cache_pages.isra.40.constprop.57+0x250/0x380 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491070]  [<ffffffffc072ab6e>] ?
> extent_writepages+0x5e/0x90 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491081]  [<ffffffffc070b040>] ?
> btrfs_releasepage+0x40/0x40 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.491092]  [<ffffffffc06fc804>] ?
> btree_writepages+0x44/0x60 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.494718]  [<ffffffffc0757f54>] ?
> btrfs_add_delayed_tree_ref+0x144/0x1f0 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.494748]  [<ffffffffc0756f7f>] ?
> add_delayed_ref_tail_merge+0x5f/0x320 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.494761]  [<ffffffffc0756f7f>] ?
> add_delayed_ref_tail_merge+0x5f/0x320 [btrfs]
> 
> Feb  5 21:25:21 mars kernel: [250128.494774]  [<ffffffffc072122c>] ?
> btrfs_get_token_32+0x10c/0x130 [btrfs]
> 

So here what's happening is that delalloc writing causes free cache to
be read from disk i.e. the load_free_space_cache function is called,
however it's stuck at io_ctl_prepare_pages whose main job is to find the
appropriate number of free pages to read the free space cache into it.
This function calls find_or_create_page-> pagecache_get_page and those
are generic kernel functions and not specifically related to BTRFS.

Given the page alloc stalls before the btrfs stacktrace I'd say you have
a problem with slow or not working storage (likely the former) which
causes your swap operations to lag.

> 
> 
> Am I correct in assuming that this is a problem with btrfs? If yes,
> how can I fix this?
> 
> 
> Yours sincerely
> 
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
