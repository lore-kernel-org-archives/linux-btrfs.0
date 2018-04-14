Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.18.29]:57528 "EHLO
        smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeDNHjf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 03:39:35 -0400
Received: from [95.91.212.17] (helo=[192.168.0.13])
        by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <timo@nentwig.biz>)
        id 1f7Fev-0005Nk-Uo
        for linux-btrfs@vger.kernel.org; Sat, 14 Apr 2018 09:31:42 +0200
To: linux-btrfs@vger.kernel.org
From: Timo Nentwig <btrfs@nentwig.biz>
Subject: remounted ro during operation, unmountable since
Message-ID: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
Date: Sat, 14 Apr 2018 09:31:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

btrfs remounted itself ro during operation (don't have the dmesg) and 
fails to mount after reboot.

Any advice?


4.15.15-1-ARCH #1 SMP PREEMPT Sat Mar 31 23:59:25 UTC 2018 x86_64 GNU/Linux
btrfs-progs v4.16
Label: '830'  uuid: 22e778f7-2499-4379-99d2-cdd399d1cc6e
         Total devices 1 FS bytes used 34.39GiB
         devid    1 size 59.49GiB used 58.98GiB path /dev/sda2

[  867.041397] BTRFS info (device sda2): disk space caching is enabled
[  867.185357] BTRFS info (device sda2): bdev /dev/sda2 errs: wr 0, rd 
158, flush 0, corrupt 0, gen 0
[  868.423427] BTRFS error (device sda2): parent transid verify failed 
on 166030671872 wanted 1702074 found 1705980
[  868.425400] BTRFS error (device sda2): failed to read block groups: -5
[  868.464259] BTRFS error (device sda2): open_ctree failed

# sudo mount -o usebackuproot /dev/sda2 /mnt/sda2/
mount: /mnt/sda2: wrong fs type, bad option, bad superblock on 
/dev/sda2, missing codepage or helper program, or other error.

# sudo btrfs check /dev/sda2
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
ERROR: cannot open file system

# sudo btrfs-image /dev/sda2 /mnt/sda2/img
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
ERROR: open ctree failed
ERROR: create failed: Success

# sudo btrfs rescue zero-log /dev/sda2
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
ERROR: could not open ctree

# sudo btrfs rescue super-recover /dev/sda2
All supers are valid, no need to recover

# sudo btrfs check -s 0 /dev/sda2
using SB copy 0, bytenr 65536
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
ERROR: cannot open file system

# sudo btrfs check -s 1 /dev/sda2
using SB copy 1, bytenr 67108864
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
ERROR: cannot open file system

# sudo btrfs check -s 2 /dev/sda2
using SB copy 2, bytenr 274877906944
ERROR: superblock bytenr 274877906944 is larger than device size 63879249920
ERROR: cannot open file system

# sudo btrfs-debug-tree -b 166030671872 /dev/sda2
btrfs-progs v4.16
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
leaf 166030671872 items 60 free space 95 generation 1705980 owner TREE_LOG
leaf 166030671872 flags 0x1(WRITTEN) backref revision 1
fs uuid 22e778f7-2499-4379-99d2-cdd399d1cc6e
chunk uuid bee8ad15-e128-45f1-a3d7-e2fda17806ce
     item 0 key (46475 DIR_ITEM 2335543231) itemoff 3955 itemsize 40
         location key (1973554 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002443.sst
     item 1 key (46475 DIR_ITEM 2338985614) itemoff 3915 itemsize 40
         location key (1972743 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001638.sst
     item 2 key (46475 DIR_ITEM 2339658528) itemoff 3875 itemsize 40
         location key (1973225 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002115.sst
     item 3 key (46475 DIR_ITEM 2341002938) itemoff 3835 itemsize 40
         location key (311255 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000500.sst
     item 4 key (46475 DIR_ITEM 2344385674) itemoff 3795 itemsize 40
         location key (1945180 INODE_ITEM 0) type FILE
         transid 1700747 data_len 0 name_len 10
         name: 001135.sst
     item 5 key (46475 DIR_ITEM 2349120094) itemoff 3755 itemsize 40
         location key (1973190 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002081.sst
     item 6 key (46475 DIR_ITEM 2350418065) itemoff 3715 itemsize 40
         location key (1973097 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001988.sst
     item 7 key (46475 DIR_ITEM 2351846848) itemoff 3675 itemsize 40
         location key (311153 INODE_ITEM 0) type FILE
         transid 1640127 data_len 0 name_len 10
         name: 000399.sst
     item 8 key (46475 DIR_ITEM 2357554177) itemoff 3635 itemsize 40
         location key (1973519 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002409.sst
     item 9 key (46475 DIR_ITEM 2364430080) itemoff 3595 itemsize 40
         location key (310998 INODE_ITEM 0) type FILE
         transid 1640127 data_len 0 name_len 10
         name: 000247.sst
     item 10 key (46475 DIR_ITEM 2365079492) itemoff 3555 itemsize 40
         location key (311249 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000494.sst
     item 11 key (46475 DIR_ITEM 2368322937) itemoff 3515 itemsize 40
         location key (1973374 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002264.sst
     item 12 key (46475 DIR_ITEM 2369253591) itemoff 3475 itemsize 40
         location key (1972654 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001549.sst
     item 13 key (46475 DIR_ITEM 2372430310) itemoff 3435 itemsize 40
         location key (1974045 INODE_ITEM 0) type FILE
         transid 1705980 data_len 0 name_len 10
         name: 002732.sst
     item 14 key (46475 DIR_ITEM 2376216877) itemoff 3395 itemsize 40
         location key (1973045 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001936.sst
     item 15 key (46475 DIR_ITEM 2379561187) itemoff 3355 itemsize 40
         location key (311428 INODE_ITEM 0) type FILE
         transid 1640129 data_len 0 name_len 10
         name: 000671.sst
     item 16 key (46475 DIR_ITEM 2383235388) itemoff 3315 itemsize 40
         location key (311411 INODE_ITEM 0) type FILE
         transid 1640129 data_len 0 name_len 10
         name: 000654.sst
     item 17 key (46475 DIR_ITEM 2383361629) itemoff 3275 itemsize 40
         location key (1944914 INODE_ITEM 0) type FILE
         transid 1700746 data_len 0 name_len 10
         name: 000870.sst
     item 18 key (46475 DIR_ITEM 2384142840) itemoff 3235 itemsize 40
         location key (46497 INODE_ITEM 0) type FILE
         transid 1627949 data_len 0 name_len 10
         name: 000087.sst
     item 19 key (46475 DIR_ITEM 2390376690) itemoff 3195 itemsize 40
         location key (1973020 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001913.sst
     item 20 key (46475 DIR_ITEM 2393905209) itemoff 3155 itemsize 40
         location key (1974030 INODE_ITEM 0) type FILE
         transid 1705980 data_len 0 name_len 10
         name: 002717.sst
     item 21 key (46475 DIR_ITEM 2397545570) itemoff 3115 itemsize 40
         location key (1973603 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002492.sst
     item 22 key (46475 DIR_ITEM 2398211238) itemoff 3075 itemsize 40
         location key (1973351 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002241.sst
     item 23 key (46475 DIR_ITEM 2399306991) itemoff 3035 itemsize 40
         location key (1972762 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001657.sst
     item 24 key (46475 DIR_ITEM 2408282074) itemoff 2995 itemsize 40
         location key (1973431 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002321.sst
     item 25 key (46475 DIR_ITEM 2409732164) itemoff 2955 itemsize 40
         location key (46487 INODE_ITEM 0) type FILE
         transid 1627949 data_len 0 name_len 10
         name: 000039.sst
     item 26 key (46475 DIR_ITEM 2411890223) itemoff 2915 itemsize 40
         location key (1972896 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001789.sst
     item 27 key (46475 DIR_ITEM 2417649652) itemoff 2875 itemsize 40
         location key (1973379 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002269.sst
     item 28 key (46475 DIR_ITEM 2425215343) itemoff 2835 itemsize 40
         location key (1973141 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002032.sst
     item 29 key (46475 DIR_ITEM 2429698142) itemoff 2795 itemsize 40
         location key (1967068 INODE_ITEM 0) type FILE
         transid 1705293 data_len 0 name_len 10
         name: 001249.sst
     item 30 key (46475 DIR_ITEM 2435535388) itemoff 2755 itemsize 40
         location key (1973094 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001985.sst
     item 31 key (46475 DIR_ITEM 2444670604) itemoff 2715 itemsize 40
         location key (1973514 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002404.sst
     item 32 key (46475 DIR_ITEM 2446058825) itemoff 2675 itemsize 40
         location key (311254 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000499.sst
     item 33 key (46475 DIR_ITEM 2448908819) itemoff 2635 itemsize 40
         location key (1973262 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002152.sst
     item 34 key (46475 DIR_ITEM 2459058889) itemoff 2595 itemsize 40
         location key (46482 INODE_ITEM 0) type FILE
         transid 1627949 data_len 0 name_len 10
         name: 000034.sst
     item 35 key (46475 DIR_ITEM 2463340118) itemoff 2555 itemsize 40
         location key (311317 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000562.sst
     item 36 key (46475 DIR_ITEM 2464625766) itemoff 2515 itemsize 40
         location key (1945202 INODE_ITEM 0) type FILE
         transid 1700747 data_len 0 name_len 10
         name: 001157.sst
     item 37 key (46475 DIR_ITEM 2465291426) itemoff 2475 itemsize 40
         location key (1972891 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001784.sst
     item 38 key (46475 DIR_ITEM 2466387179) itemoff 2435 itemsize 40
         location key (1973502 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002392.sst
     item 39 key (46475 DIR_ITEM 2481519029) itemoff 2395 itemsize 40
         location key (46518 INODE_ITEM 0) type FILE
         transid 1627949 data_len 0 name_len 10
         name: 000154.sst
     item 40 key (46475 DIR_ITEM 2490561941) itemoff 2355 itemsize 40
         location key (1973316 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002206.sst
     item 41 key (46475 DIR_ITEM 2495271487) itemoff 2315 itemsize 40
         location key (1967045 INODE_ITEM 0) type FILE
         transid 1705293 data_len 0 name_len 10
         name: 001226.sst
     item 42 key (46475 DIR_ITEM 2503390930) itemoff 2275 itemsize 40
         location key (1944933 INODE_ITEM 0) type FILE
         transid 1700746 data_len 0 name_len 10
         name: 000889.sst
     item 43 key (46475 DIR_ITEM 2508307932) itemoff 2235 itemsize 40
         location key (1972715 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001610.sst
     item 44 key (46475 DIR_ITEM 2512415043) itemoff 2195 itemsize 40
         location key (1972228 INODE_ITEM 0) type FILE
         transid 1705306 data_len 0 name_len 10
         name: 001346.sst
     item 45 key (46475 DIR_ITEM 2519513772) itemoff 2155 itemsize 40
         location key (1718075 INODE_ITEM 0) type FILE
         transid 1691379 data_len 0 name_len 10
         name: 000756.sst
     item 46 key (46475 DIR_ITEM 2520437352) itemoff 2115 itemsize 40
         location key (46533 INODE_ITEM 0) type FILE
         transid 1627949 data_len 0 name_len 10
         name: 000185.sst
     item 47 key (46475 DIR_ITEM 2521268653) itemoff 2075 itemsize 40
         location key (1973228 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002118.sst
     item 48 key (46475 DIR_ITEM 2522467331) itemoff 2035 itemsize 40
         location key (1972740 INODE_ITEM 0) type FILE
         transid 1705436 data_len 0 name_len 10
         name: 001635.sst
     item 49 key (46475 DIR_ITEM 2525996551) itemoff 1995 itemsize 40
         location key (1945183 INODE_ITEM 0) type FILE
         transid 1700747 data_len 0 name_len 10
         name: 001138.sst
     item 50 key (46475 DIR_ITEM 2526145449) itemoff 1955 itemsize 40
         location key (1973734 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002615.sst
     item 51 key (46475 DIR_ITEM 2529581042) itemoff 1915 itemsize 40
         location key (1973709 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002590.sst
     item 52 key (46475 DIR_ITEM 2535683967) itemoff 1875 itemsize 40
         location key (1972861 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 001755.sst
     item 53 key (46475 DIR_ITEM 2556559590) itemoff 1835 itemsize 40
         location key (311128 INODE_ITEM 0) type FILE
         transid 1640127 data_len 0 name_len 10
         name: 000374.sst
     item 54 key (46475 DIR_ITEM 2574110005) itemoff 1795 itemsize 40
         location key (1972455 INODE_ITEM 0) type FILE
         transid 1705434 data_len 0 name_len 10
         name: 001377.sst
     item 55 key (46475 DIR_ITEM 2577787551) itemoff 1755 itemsize 40
         location key (1973467 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002357.sst
     item 56 key (46475 DIR_ITEM 2578678363) itemoff 1715 itemsize 40
         location key (1973703 INODE_ITEM 0) type FILE
         transid 1705438 data_len 0 name_len 10
         name: 002584.sst
     item 57 key (46475 DIR_ITEM 2580468126) itemoff 1675 itemsize 40
         location key (311274 INODE_ITEM 0) type FILE
         transid 1640128 data_len 0 name_len 10
         name: 000519.sst
     item 58 key (46475 DIR_ITEM 2596325957) itemoff 1635 itemsize 40
         location key (310980 INODE_ITEM 0) type FILE
         transid 1640126 data_len 0 name_len 10
         name: 000231.sst
     item 59 key (46475 DIR_ITEM 2599036379) itemoff 1595 itemsize 40
         location key (1973239 INODE_ITEM 0) type FILE
         transid 1705437 data_len 0 name_len 10
         name: 002129.sst

# sudo btrfs-find-root /dev/sda2
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
parent transid verify failed on 166030671872 wanted 1702074 found 1705980
Ignoring transid failure
leaf parent key incorrect 166030671872
Superblock thinks the generation is 1706541
Superblock thinks the level is 1
Found tree root at 167104118784 gen 1706541 level 1
Well block 167103098880(gen: 1706540 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167103057920(gen: 1706540 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167101816832(gen: 1706539 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167101779968(gen: 1706539 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167098847232(gen: 1706537 level: 1) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167097327616(gen: 1706536 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167095885824(gen: 1706535 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167095169024(gen: 1706534 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167093563392(gen: 1706533 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167092989952(gen: 1706533 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167092891648(gen: 1706533 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
Well block 167090151424(gen: 1706532 level: 0) seems good, but 
generation/level doesn't match, want gen: 1706541 level: 1
...

# sudo btrfs check --init-extent-tree /dev/sda2
Checking filesystem on /dev/sda2
UUID: 22e778f7-2499-4379-99d2-cdd399d1cc6e
repair mode will force to clear out log tree, are you sure? [y/N]: y
Unable to find block group for 0
Unable to find block group for 0
Unable to find block group for 0
extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -28
btrfs(+0x28412)[0x560716775412]
btrfs(btrfs_alloc_free_block+0x204)[0x56071677ab94]
btrfs(__btrfs_cow_block+0x186)[0x56071676b496]
btrfs(btrfs_cow_block+0x104)[0x56071676bca4]
btrfs(commit_tree_roots+0x88)[0x56071679aaf8]
btrfs(btrfs_commit_transaction+0xad)[0x56071679aead]
btrfs(cmd_check+0xe23)[0x5607167af8c3]
btrfs(main+0x81)[0x560716769eb1]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f34b9834f4a]
btrfs(_start+0x2a)[0x560716769fca]
fish: 'sudo btrfs check --init-extent-…' terminated by signal SIGABRT 
(Abort)


