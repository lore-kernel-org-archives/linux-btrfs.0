Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35190 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbcAIHSF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 02:18:05 -0500
Received: by mail-qg0-f53.google.com with SMTP id o11so369190451qge.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jan 2016 23:18:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANevpVivaAu4Ok8w8a3f90t8OJCZY7yuzzskQ-jPkHw-Jh0GWg@mail.gmail.com>
References: <CANevpVj4kfGg2KEhpbvjS7UUhRQMUy_84PFy85+=fo7EqCVbcQ@mail.gmail.com>
	<CANevpVhULZ6EXzMBaZNJ29s89_m3SvUqEO61wdRrktekNOH-fw@mail.gmail.com>
	<568DFF73.7080705@cn.fujitsu.com>
	<CANevpVjvvcQJPWd5oTGuSZ-hLe9Ca89GbkDHUpPq_Aqxn-JjSQ@mail.gmail.com>
	<568F158A.30601@cn.fujitsu.com>
	<CANevpViuuBLgbwuOYd0UiYQaSoKZ6zgPcJKukqFOu8xhkkJU3w@mail.gmail.com>
	<568F1E3E.2050504@cn.fujitsu.com>
	<CANevpVivaAu4Ok8w8a3f90t8OJCZY7yuzzskQ-jPkHw-Jh0GWg@mail.gmail.com>
Date: Sat, 9 Jan 2016 00:18:03 -0700
Message-ID: <CANevpVi+-8heRLJxF7jYgWZMTiKrzey5WxeLGWA1J16HUMtMuQ@mail.gmail.com>
Subject: Re: Recovery of a raid1 FS
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just for fun, I tried btrfs check --repair, but no dice:

[root@archiso ~]# btrfs check --repair /dev/mapper/rootvol_1
enabling repair mode
warning, device 2 is missing
warning devid 2 not found already
bad key ordering 49 50
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x44161e]
btrfs(btrfs_reserve_extent+0xa7b)[0x4463db]
btrfs(btrfs_alloc_free_block+0x5f)[0x44649f]
btrfs(__btrfs_cow_block+0xc4)[0x437d64]
btrfs(btrfs_cow_block+0x35)[0x438365]
btrfs[0x43d3d6]
btrfs(btrfs_commit_transaction+0x95)[0x43f125]
btrfs(cmd_check+0x5ec)[0x429cdc]
btrfs(main+0x82)[0x40ef32]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f265ba38610]
btrfs(_start+0x29)[0x40f039]

Seems to be the same point at which they both fail. I have no idea
what might be the cause.

On Thu, Jan 7, 2016 at 8:46 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
>> You can try this method.
>> But after that, *NEVER* put all the two devices online *TOGETHER*.
>
> Tried this, with only one disk of the volume plugged in. Results:
>
> [root@archiso ~]# btrfs check --init-extent-tree /dev/mapper/rootvol_1
> warning, device 2 is missing
> warning devid 2 not found already
> repair mode will force to clear out log tree, Are you sure? [y/N]: y
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.
> btrfs[0x44161e]
> btrfs(btrfs_reserve_extent+0xa7b)[0x4463db]
> btrfs(btrfs_alloc_free_block+0x5f)[0x44649f]
> btrfs(__btrfs_cow_block+0xc4)[0x437d64]
> btrfs(btrfs_cow_block+0x35)[0x438365]
> btrfs[0x43d3d6]
> btrfs(btrfs_commit_transaction+0x95)[0x43f125]
> btrfs(cmd_check+0x5ec)[0x429cdc]
> btrfs(main+0x82)[0x40ef32]
> /usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7fe478ef0610]
> btrfs(_start+0x29)[0x40f039]
>
> On Thu, Jan 7, 2016 at 7:26 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Tom Hunt wrote on 2016/01/07 19:02 -0700:
>>>>
>>>> Does the sudden end means a segfault?
>>>
>>>
>>> The sudden end means an end. The program terminated without any
>>> further output or error indication.
>>>
>>>> And what's the output of btrfs-debug-tree /dev/mapper/rootvol_1 -b
>>>> 6210223521792?
>>>
>>>
>>> [root@archiso ~]# btrfs-debug-tree /dev/mapper/rootvol_1 -b 6210223521792
>>> bad key ordering 49 50
>>> leaf 6210223521792 items 123 free space 55 generation 257371 owner 1
>>> fs uuid 91f7e058-1142-4036-b1f7-4f64163dc8ae
>>> chunk uuid 6abf465c-c677-4879-a4ca-d632e43e01e4
>>>          item 0 key (7302 INODE_ITEM 0) itemoff 16123 itemsize 160
>>>                  inode generation 37573 transid 37573 size 262144 nbytes
>>> 1048576
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 1 key (7302 EXTENT_DATA 0) itemoff 16070 itemsize 53
>>>                  extent data disk byte 7564439363584 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 2 key (7303 INODE_ITEM 0) itemoff 15910 itemsize 160
>>>                  inode generation 37573 transid 37573 size 262144 nbytes
>>> 786432
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 3 key (7303 EXTENT_DATA 0) itemoff 15857 itemsize 53
>>>                  extent data disk byte 7564439662592 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 4 key (7304 INODE_ITEM 0) itemoff 15697 itemsize 160
>>>                  inode generation 36550 transid 36550 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 5 key (7304 EXTENT_DATA 0) itemoff 15644 itemsize 53
>>>                  extent data disk byte 7517322158080 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 6 key (7305 INODE_ITEM 0) itemoff 15484 itemsize 160
>>>                  inode generation 37573 transid 37573 size 262144 nbytes
>>> 524288
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 7 key (7305 EXTENT_DATA 0) itemoff 15431 itemsize 53
>>>                  extent data disk byte 7564439941120 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 8 key (7306 INODE_ITEM 0) itemoff 15271 itemsize 160
>>>                  inode generation 37573 transid 37573 size 262144 nbytes
>>> 786432
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 9 key (7306 EXTENT_DATA 0) itemoff 15218 itemsize 53
>>>                  extent data disk byte 7564440219648 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 10 key (7307 INODE_ITEM 0) itemoff 15058 itemsize 160
>>>                  inode generation 37576 transid 37576 size 262144 nbytes
>>> 1310720
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 11 key (7307 EXTENT_DATA 0) itemoff 15005 itemsize 53
>>>                  extent data disk byte 7564425949184 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 12 key (7308 INODE_ITEM 0) itemoff 14845 itemsize 160
>>>                  inode generation 36586 transid 36586 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 13 key (7308 EXTENT_DATA 0) itemoff 14792 itemsize 53
>>>                  extent data disk byte 7355300618240 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 14 key (7309 INODE_ITEM 0) itemoff 14632 itemsize 160
>>>                  inode generation 257365 transid 257365 size 262144
>>> nbytes 11781537792
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 15 key (7309 EXTENT_DATA 0) itemoff 14579 itemsize 53
>>>                  extent data disk byte 7770707218432 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 16 key (7310 INODE_ITEM 0) itemoff 14419 itemsize 160
>>>                  inode generation 37590 transid 37590 size 262144 nbytes
>>> 786432
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 17 key (7310 EXTENT_DATA 0) itemoff 14366 itemsize 53
>>>                  extent data disk byte 7569787527168 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 18 key (7311 INODE_ITEM 0) itemoff 14206 itemsize 160
>>>                  inode generation 37591 transid 37591 size 262144 nbytes
>>> 1048576
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 19 key (7311 EXTENT_DATA 0) itemoff 14153 itemsize 53
>>>                  extent data disk byte 7569797865472 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 20 key (7312 INODE_ITEM 0) itemoff 13993 itemsize 160
>>>                  inode generation 36625 transid 36625 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 21 key (7312 EXTENT_DATA 0) itemoff 13940 itemsize 53
>>>                  extent data disk byte 7517400543232 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 22 key (7313 INODE_ITEM 0) itemoff 13780 itemsize 160
>>>                  inode generation 36634 transid 36634 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 23 key (7313 EXTENT_DATA 0) itemoff 13727 itemsize 53
>>>                  extent data disk byte 7531318194176 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 24 key (7314 INODE_ITEM 0) itemoff 13567 itemsize 160
>>>                  inode generation 239734 transid 239734 size 262144
>>> nbytes 2359558144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 25 key (7314 EXTENT_DATA 0) itemoff 13514 itemsize 53
>>>                  extent data disk byte 8005861564416 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 26 key (7315 INODE_ITEM 0) itemoff 13354 itemsize 160
>>>                  inode generation 36652 transid 36652 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 27 key (7315 EXTENT_DATA 0) itemoff 13301 itemsize 53
>>>                  extent data disk byte 4990757240832 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 28 key (7316 INODE_ITEM 0) itemoff 13141 itemsize 160
>>>                  inode generation 36661 transid 36661 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 29 key (7316 EXTENT_DATA 0) itemoff 13088 itemsize 53
>>>                  extent data disk byte 7066322538496 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 30 key (7317 INODE_ITEM 0) itemoff 12928 itemsize 160
>>>                  inode generation 36672 transid 36672 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 31 key (7317 EXTENT_DATA 0) itemoff 12875 itemsize 53
>>>                  extent data disk byte 7278922661888 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 32 key (7318 INODE_ITEM 0) itemoff 12715 itemsize 160
>>>                  inode generation 36682 transid 36682 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 33 key (7318 EXTENT_DATA 0) itemoff 12662 itemsize 53
>>>                  extent data disk byte 7313284538368 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 34 key (7319 INODE_ITEM 0) itemoff 12502 itemsize 160
>>>                  inode generation 36692 transid 36692 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 35 key (7319 EXTENT_DATA 0) itemoff 12449 itemsize 53
>>>                  extent data disk byte 7184434880512 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 36 key (7320 INODE_ITEM 0) itemoff 12289 itemsize 160
>>>                  inode generation 36702 transid 36702 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 37 key (7320 EXTENT_DATA 0) itemoff 12236 itemsize 53
>>>                  extent data disk byte 7518426820608 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 38 key (7321 INODE_ITEM 0) itemoff 12076 itemsize 160
>>>                  inode generation 36711 transid 36711 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 39 key (7321 EXTENT_DATA 0) itemoff 12023 itemsize 53
>>>                  extent data disk byte 7372338782208 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 40 key (7322 INODE_ITEM 0) itemoff 11863 itemsize 160
>>>                  inode generation 36720 transid 36720 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 41 key (7322 EXTENT_DATA 0) itemoff 11810 itemsize 53
>>>                  extent data disk byte 7526872854528 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 42 key (7323 INODE_ITEM 0) itemoff 11650 itemsize 160
>>>                  inode generation 36729 transid 36729 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 43 key (7323 EXTENT_DATA 0) itemoff 11597 itemsize 53
>>>                  extent data disk byte 4990756978688 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 44 key (7324 INODE_ITEM 0) itemoff 11437 itemsize 160
>>>                  inode generation 36739 transid 36739 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 45 key (7324 EXTENT_DATA 0) itemoff 11384 itemsize 53
>>>                  extent data disk byte 7520553996288 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 46 key (7325 INODE_ITEM 0) itemoff 11224 itemsize 160
>>>                  inode generation 36749 transid 36749 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 47 key (7325 EXTENT_DATA 0) itemoff 11171 itemsize 53
>>>                  extent data disk byte 7531508781056 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 48 key (7326 INODE_ITEM 0) itemoff 11011 itemsize 160
>>>                  inode generation 251050 transid 251050 size 262144
>>> nbytes 8435793920
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 49 key (7326 EXTENT_DATA 0) itemoff 10958 itemsize 53
>>>                  extent data disk byte 7747063099392 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 50 key (7327 INODE_ITEM 0) itemoff 10798 itemsize 160
>>>                  inode generation 36767 transid 36767 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 51 key (7327 EXTENT_DATA 0) itemoff 10745 itemsize 53
>>>                  extent data disk byte 7517323468800 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 52 key (7328 INODE_ITEM 0) itemoff 10585 itemsize 160
>>>                  inode generation 36777 transid 36777 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 53 key (7328 EXTENT_DATA 0) itemoff 10532 itemsize 53
>>>                  extent data disk byte 7529166970880 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 54 key (7329 INODE_ITEM 0) itemoff 10372 itemsize 160
>>>                  inode generation 40097 transid 40097 size 262144 nbytes
>>> 82313216
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 55 key (7329 EXTENT_DATA 0) itemoff 10319 itemsize 53
>>>                  extent data disk byte 7370190655488 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 56 key (3234 INODE_ITEM 0) itemoff 10159 itemsize 160
>>>                  inode generation 36795 transid 36795 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 57 key (7346 EXTENT_DATA 0) itemoff 10106 itemsize 53
>>>                  extent data disk byte 7521490550784 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>
>> Item 56 and 57 are corrupted.
>> Their inode number should be 7330, but they are not.
>>
>> If the output is valid, especially for the owner, then it means your free
>> space cache is damaged, but that's a very small problem though.
>>
>>>          item 58 key (7331 INODE_ITEM 0) itemoff 9946 itemsize 160
>>>                  inode generation 36804 transid 36804 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 59 key (7331 EXTENT_DATA 0) itemoff 9893 itemsize 53
>>>                  extent data disk byte 7526874955776 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 60 key (7332 INODE_ITEM 0) itemoff 9733 itemsize 160
>>>                  inode generation 257363 transid 257363 size 262144
>>> nbytes 13501202432
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 61 key (7332 EXTENT_DATA 0) itemoff 9680 itemsize 53
>>>                  extent data disk byte 7747053572096 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 62 key (7333 INODE_ITEM 0) itemoff 9520 itemsize 160
>>>                  inode generation 257371 transid 257371 size 262144
>>> nbytes 16589520896
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 63 key (7333 EXTENT_DATA 0) itemoff 9467 itemsize 53
>>>                  extent data disk byte 7775023665152 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 64 key (7334 INODE_ITEM 0) itemoff 9307 itemsize 160
>>>                  inode generation 239755 transid 239755 size 262144
>>> nbytes 13442482176
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 65 key (7334 EXTENT_DATA 0) itemoff 9254 itemsize 53
>>>                  extent data disk byte 7896225873920 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 66 key (7335 INODE_ITEM 0) itemoff 9094 itemsize 160
>>>                  inode generation 239755 transid 239755 size 262144
>>> nbytes 1324613632
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 67 key (7335 EXTENT_DATA 0) itemoff 9041 itemsize 53
>>>                  extent data disk byte 7896226185216 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 68 key (7336 INODE_ITEM 0) itemoff 8881 itemsize 160
>>>                  inode generation 240953 transid 240953 size 262144
>>> nbytes 3632529408
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 69 key (7336 EXTENT_DATA 0) itemoff 8828 itemsize 53
>>>                  extent data disk byte 5919597350912 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 70 key (7337 INODE_ITEM 0) itemoff 8668 itemsize 160
>>>                  inode generation 243010 transid 243010 size 262144
>>> nbytes 2379481088
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 71 key (7337 EXTENT_DATA 0) itemoff 8615 itemsize 53
>>>                  extent data disk byte 5918852136960 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 72 key (7338 INODE_ITEM 0) itemoff 8455 itemsize 160
>>>                  inode generation 79477 transid 79477 size 262144 nbytes
>>> 24117248
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 73 key (7338 EXTENT_DATA 0) itemoff 8402 itemsize 53
>>>                  extent data disk byte 7715922624512 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 74 key (7339 INODE_ITEM 0) itemoff 8242 itemsize 160
>>>                  inode generation 81958 transid 81958 size 262144 nbytes
>>> 78381056
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 75 key (7339 EXTENT_DATA 0) itemoff 8189 itemsize 53
>>>                  extent data disk byte 7721189564416 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 76 key (7340 INODE_ITEM 0) itemoff 8029 itemsize 160
>>>                  inode generation 83591 transid 83591 size 262144
>>> nbytes 165150720
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 77 key (7340 EXTENT_DATA 0) itemoff 7976 itemsize 53
>>>                  extent data disk byte 7744960389120 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 78 key (7341 INODE_ITEM 0) itemoff 7816 itemsize 160
>>>                  inode generation 47076 transid 47076 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 79 key (7341 EXTENT_DATA 0) itemoff 7763 itemsize 53
>>>                  extent data disk byte 7518415810560 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 80 key (7342 INODE_ITEM 0) itemoff 7603 itemsize 160
>>>                  inode generation 47085 transid 47085 size 262144 nbytes
>>> 1048576
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 81 key (7342 EXTENT_DATA 0) itemoff 7550 itemsize 53
>>>                  extent data disk byte 7532088664064 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 82 key (7343 INODE_ITEM 0) itemoff 7390 itemsize 160
>>>                  inode generation 47077 transid 47077 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 83 key (7343 EXTENT_DATA 0) itemoff 7337 itemsize 53
>>>                  extent data disk byte 7517316259840 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 84 key (7344 INODE_ITEM 0) itemoff 7177 itemsize 160
>>>                  inode generation 47196 transid 47196 size 262144 nbytes
>>> 22282240
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 85 key (7344 EXTENT_DATA 0) itemoff 7124 itemsize 53
>>>                  extent data disk byte 6878509641728 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 86 key (7345 INODE_ITEM 0) itemoff 6964 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 87 key (7345 EXTENT_DATA 0) itemoff 6911 itemsize 53
>>>                  extent data disk byte 7517369085952 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 88 key (7346 INODE_ITEM 0) itemoff 6751 itemsize 160
>>>                  inode generation 47235 transid 47235 size 262144 nbytes
>>> 23592960
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 89 key (7346 EXTENT_DATA 0) itemoff 6698 itemsize 53
>>>                  extent data disk byte 6878511214592 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 90 key (7347 INODE_ITEM 0) itemoff 6538 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 91 key (7347 EXTENT_DATA 0) itemoff 6485 itemsize 53
>>>                  extent data disk byte 7520553472000 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 92 key (7348 INODE_ITEM 0) itemoff 6325 itemsize 160
>>>                  inode generation 47228 transid 47228 size 262144 nbytes
>>> 22020096
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 93 key (7348 EXTENT_DATA 0) itemoff 6272 itemsize 53
>>>                  extent data disk byte 6878522159104 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 94 key (7349 INODE_ITEM 0) itemoff 6112 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 95 key (7349 EXTENT_DATA 0) itemoff 6059 itemsize 53
>>>                  extent data disk byte 7531921424384 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 96 key (7350 INODE_ITEM 0) itemoff 5899 itemsize 160
>>>                  inode generation 47181 transid 47181 size 262144 nbytes
>>> 13631488
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 97 key (7350 EXTENT_DATA 0) itemoff 5846 itemsize 53
>>>                  extent data disk byte 6878515281920 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 98 key (7351 INODE_ITEM 0) itemoff 5686 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 99 key (7351 EXTENT_DATA 0) itemoff 5633 itemsize 53
>>>                  extent data disk byte 7538744426496 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 100 key (7352 INODE_ITEM 0) itemoff 5473 itemsize 160
>>>                  inode generation 47183 transid 47183 size 262144 nbytes
>>> 11796480
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 101 key (7352 EXTENT_DATA 0) itemoff 5420 itemsize 53
>>>                  extent data disk byte 6878518218752 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 102 key (7353 INODE_ITEM 0) itemoff 5260 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 103 key (7353 EXTENT_DATA 0) itemoff 5207 itemsize 53
>>>                  extent data disk byte 7540909154304 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 104 key (7354 INODE_ITEM 0) itemoff 5047 itemsize 160
>>>                  inode generation 47196 transid 47196 size 262144 nbytes
>>> 15466496
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 105 key (7354 EXTENT_DATA 0) itemoff 4994 itemsize 53
>>>                  extent data disk byte 6878513303552 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 106 key (7355 INODE_ITEM 0) itemoff 4834 itemsize 160
>>>                  inode generation 47078 transid 47078 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 107 key (7355 EXTENT_DATA 0) itemoff 4781 itemsize 53
>>>                  extent data disk byte 7564487045120 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 108 key (7356 INODE_ITEM 0) itemoff 4621 itemsize 160
>>>                  inode generation 47210 transid 47210 size 262144 nbytes
>>> 19660800
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 109 key (7356 EXTENT_DATA 0) itemoff 4568 itemsize 53
>>>                  extent data disk byte 6878541139968 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 110 key (7357 INODE_ITEM 0) itemoff 4408 itemsize 160
>>>                  inode generation 47079 transid 47079 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 111 key (7357 EXTENT_DATA 0) itemoff 4355 itemsize 53
>>>                  extent data disk byte 7538756612096 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 112 key (7358 INODE_ITEM 0) itemoff 4195 itemsize 160
>>>                  inode generation 47079 transid 47079 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 113 key (7358 EXTENT_DATA 0) itemoff 4142 itemsize 53
>>>                  extent data disk byte 7582721437696 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 114 key (7359 INODE_ITEM 0) itemoff 3982 itemsize 160
>>>                  inode generation 82232 transid 82232 size 262144 nbytes
>>> 44564480
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 115 key (7359 EXTENT_DATA 0) itemoff 3929 itemsize 53
>>>                  extent data disk byte 7724558057472 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 116 key (7360 INODE_ITEM 0) itemoff 3769 itemsize 160
>>>                  inode generation 47080 transid 47080 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 117 key (7360 EXTENT_DATA 0) itemoff 3716 itemsize 53
>>>                  extent data disk byte 4658994225152 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 118 key (7361 INODE_ITEM 0) itemoff 3556 itemsize 160
>>>                  inode generation 47080 transid 47080 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 119 key (7361 EXTENT_DATA 0) itemoff 3503 itemsize 53
>>>                  extent data disk byte 6905566703616 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 120 key (7362 INODE_ITEM 0) itemoff 3343 itemsize 160
>>>                  inode generation 79539 transid 79539 size 262144 nbytes
>>> 38535168
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>          item 121 key (7362 EXTENT_DATA 0) itemoff 3290 itemsize 53
>>>                  extent data disk byte 7720056217600 nr 262144
>>>                  extent data offset 0 nr 262144 ram 262144
>>>                  extent compression 0
>>>          item 122 key (7363 INODE_ITEM 0) itemoff 3130 itemsize 160
>>>                  inode generation 47080 transid 47080 size 262144 nbytes
>>> 262144
>>>                  block group 0 mode 100600 links 1 uid 0 gid 0
>>>                  rdev 0 flags 0x1b
>>>
>>>> If btrfs-debug-tree can still output things like below, and the leaf's
>>>> owner is still 2, I'd recommend to run btrfsck --init-extent-tree, which
>>>> should has a good chance to fix it.
>>>
>>>
>>>> Although even in that case, I'm not 100% sure if it will work, or do more
>>>> damage...
>>>
>>>
>>> Would it be a sensible precaution to unplug one disk and attempt
>>> recovery on a single one? If I understand correctly, all the data
>>> should be available on either. This disk is quite significant to me,
>>> and the other option is restoring from a week-old backup; annoying, if
>>> not fatal.
>>
>>
>> You can try this method.
>> But after that, *NEVER* put all the two devices online *TOGETHER*.
>>
>> Thanks,
>> Qu
>>>
>>>
>>> For the record, I've also already bought new disks and will be
>>> operating with those going forward, so a transfer of data will be
>>> necessary in any case. (There was the possibility of hardware damage
>>> from a flood a little while ago, and even if this is unrelated, I'm
>>> paranoid about this volume.)
>>>
>>> On Thu, Jan 7, 2016 at 6:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>
>>>>
>>>>
>>>> Tom Hunt wrote on 2016/01/07 18:43 -0700:
>>>>>
>>>>>
>>>>> I had done this already, but somehow forgot to include it. (Internet
>>>>> suggests 'btrfs check' is synonym for 'btrfsck'; if this is not the
>>>>> case, please advise.)
>>>>>
>>>>> [root@archiso ~]# btrfs check /dev/mapper/rootvol_1
>>>>> bad key ordering 49 50
>>>>> Checking filesystem on /dev/mapper/rootvol_1
>>>>> UUID: 91f7e058-1142-4036-b1f7-4f64163dc8ae
>>>>> checking extents
>>>>> bad key ordering 55 56
>>>>> bad block 6210223521792
>>>>> Errors found in extent allocation tree or chunk allocation
>>>>> bad key ordering 55 56
>>>>
>>>>
>>>>
>>>> Does the sudden end means a segfault?
>>>>
>>>>>
>>>>> And the other:
>>>>>
>>>>> [root@archiso ~]# btrfs-debug-tree /dev/mapper/rootvol_1 -b
>>>>> 6210228551680
>>>>> bad key ordering 49 50
>>>>> leaf 6210228551680 items 195 free space 244 generation 257371 owner 2
>>>>
>>>>
>>>>
>>>> That's extent tree, not a big problem as the whole extent tree can be
>>>> easily
>>>> rebuilt.
>>>>
>>>> And what's the output of btrfs-debug-tree /dev/mapper/rootvol_1 -b
>>>> 6210223521792?
>>>>
>>>> If btrfs-debug-tree can still output things like below, and the leaf's
>>>> owner
>>>> is still 2, I'd recommend to run btrfsck --init-extent-tree, which should
>>>> has a good chance to fix it.
>>>>
>>>> Although even in that case, I'm not 100% sure if it will work, or do more
>>>> damage...
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>> fs uuid 91f7e058-1142-4036-b1f7-4f64163dc8ae
>>>>> chunk uuid 6abf465c-c677-4879-a4ca-d632e43e01e4
>>>>>           item 0 key (7777093095424 EXTENT_ITEM 4096) itemoff 16217
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96498 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 16289792 count 1
>>>>>                   shared data backref parent 7588669325312 count 1
>>>>>           item 1 key (7777093099520 EXTENT_ITEM 4096) itemoff 16151
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96498 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 20484096 count 1
>>>>>                   shared data backref parent 7588669325312 count 1
>>>>>           item 2 key (7777093103616 EXTENT_ITEM 4096) itemoff 16085
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96498 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 22581248 count 1
>>>>>                   shared data backref parent 7588669325312 count 1
>>>>>           item 3 key (7777093107712 EXTENT_ITEM 4096) itemoff 16019
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96501 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 56135680 count 1
>>>>>                   shared data backref parent 7343916351488 count 1
>>>>>           item 4 key (7777093111808 EXTENT_ITEM 4096) itemoff 15953
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96501 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 58232832 count 1
>>>>>                   shared data backref parent 7343916351488 count 1
>>>>>           item 5 key (7777093115904 EXTENT_ITEM 4096) itemoff 15887
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96511 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 35164160 count 1
>>>>>                   shared data backref parent 7588669325312 count 1
>>>>>           item 6 key (7777093120000 EXTENT_ITEM 4096) itemoff 15821
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96511 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 37261312 count 1
>>>>>                   shared data backref parent 7588669325312 count 1
>>>>>           item 7 key (7777093124096 EXTENT_ITEM 4096) itemoff 15755
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96521 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 45649920 count 1
>>>>>                   shared data backref parent 7343916351488 count 1
>>>>>           item 8 key (7777093128192 EXTENT_ITEM 4096) itemoff 15689
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 96521 flags DATA
>>>>>                   extent data backref root 258 objectid 1319842 offset
>>>>> 47747072 count 1
>>>>>                   shared data backref parent 7343916351488 count 1
>>>>>           item 9 key (7777093132288 EXTENT_ITEM 4096) itemoff 15636
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128816 flags DATA
>>>>>                   extent data backref root 258 objectid 1747043 offset
>>>>> 208896 count 1
>>>>>           item 10 key (7777093136384 EXTENT_ITEM 4096) itemoff 15583
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128816 flags DATA
>>>>>                   extent data backref root 258 objectid 1747043 offset
>>>>> 1191936 count 1
>>>>>           item 11 key (7777093140480 EXTENT_ITEM 4096) itemoff 15530
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128816 flags DATA
>>>>>                   extent data backref root 258 objectid 1747043 offset
>>>>> 1896448 count 1
>>>>>           item 12 key (7777093144576 EXTENT_ITEM 4096) itemoff 15477
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128824 flags DATA
>>>>>                   extent data backref root 258 objectid 1746670 offset
>>>>> 3141632 count 1
>>>>>           item 13 key (7777093148672 EXTENT_ITEM 4096) itemoff 15424
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128824 flags DATA
>>>>>                   extent data backref root 258 objectid 1746670 offset
>>>>> 7335936 count 1
>>>>>           item 14 key (7777093152768 EXTENT_ITEM 4096) itemoff 15371
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128827 flags DATA
>>>>>                   extent data backref root 258 objectid 1746598 offset
>>>>> 2142208 count 1
>>>>>           item 15 key (7777093156864 EXTENT_ITEM 4096) itemoff 15318
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 128827 flags DATA
>>>>>                   extent data backref root 258 objectid 1746598 offset
>>>>> 6336512 count 1
>>>>>           item 16 key (7777093160960 EXTENT_ITEM 1167360) itemoff 15265
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 148358 flags DATA
>>>>>                   extent data backref root 258 objectid 800697 offset
>>>>> 219987968 count 1
>>>>>           item 17 key (7777094328320 EXTENT_ITEM 4096) itemoff 15212
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 152899 flags DATA
>>>>>                   extent data backref root 258 objectid 2111468 offset
>>>>> 909312 count 1
>>>>>           item 18 key (7777094332416 EXTENT_ITEM 20480) itemoff 15159
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 185891 flags DATA
>>>>>                   extent data backref root 7565 objectid 135103 offset 0
>>>>> count 1
>>>>>           item 19 key (7777094356992 EXTENT_ITEM 18608128) itemoff 15106
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93646 flags DATA
>>>>>                   extent data backref root 257 objectid 1798430 offset 0
>>>>> count 1
>>>>>           item 20 key (7777112965120 EXTENT_ITEM 2465792) itemoff 15053
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798304 offset 0
>>>>> count 1
>>>>>           item 21 key (7777115430912 EXTENT_ITEM 2441216) itemoff 15000
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798413 offset 0
>>>>> count 1
>>>>>           item 22 key (7777117872128 EXTENT_ITEM 2617344) itemoff 14947
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798416 offset 0
>>>>> count 1
>>>>>           item 23 key (7777120489472 EXTENT_ITEM 2592768) itemoff 14894
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798419 offset 0
>>>>> count 1
>>>>>           item 24 key (7777123082240 EXTENT_ITEM 2355200) itemoff 14841
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798422 offset 0
>>>>> count 1
>>>>>           item 25 key (7777125437440 EXTENT_ITEM 2469888) itemoff 14788
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798425 offset 0
>>>>> count 1
>>>>>           item 26 key (7777127907328 EXTENT_ITEM 2646016) itemoff 14735
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798428 offset 0
>>>>> count 1
>>>>>           item 27 key (7777130553344 EXTENT_ITEM 2461696) itemoff 14682
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798446 offset 0
>>>>> count 1
>>>>>           item 28 key (7777133015040 EXTENT_ITEM 2637824) itemoff 14629
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798449 offset 0
>>>>> count 1
>>>>>           item 29 key (7777135652864 EXTENT_ITEM 2609152) itemoff 14576
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798452 offset 0
>>>>> count 1
>>>>>           item 30 key (7777138262016 EXTENT_ITEM 2375680) itemoff 14523
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798455 offset 0
>>>>> count 1
>>>>>           item 31 key (7777140637696 EXTENT_ITEM 2490368) itemoff 14470
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798458 offset 0
>>>>> count 1
>>>>>           item 32 key (7777143128064 EXTENT_ITEM 2666496) itemoff 14417
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 93647 flags DATA
>>>>>                   extent data backref root 257 objectid 1798461 offset 0
>>>>> count 1
>>>>>           item 33 key (7777145794560 EXTENT_ITEM 348160) itemoff 14364
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 148361 flags DATA
>>>>>                   extent data backref root 258 objectid 800697 offset
>>>>> 221151232 count 1
>>>>>           item 34 key (7777146142720 EXTENT_ITEM 913408) itemoff 14311
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 152889 flags DATA
>>>>>                   extent data backref root 258 objectid 2111468 offset 0
>>>>> count 1
>>>>>           item 35 key (7777147056128 EXTENT_ITEM 32768) itemoff 14258
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 185891 flags DATA
>>>>>                   extent data backref root 7565 objectid 135085 offset 0
>>>>> count 1
>>>>>           item 36 key (7777147088896 EXTENT_ITEM 12288) itemoff 14205
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 185891 flags DATA
>>>>>                   extent data backref root 7565 objectid 135105 offset 0
>>>>> count 1
>>>>>           item 37 key (7777147105280 EXTENT_ITEM 10260480) itemoff 14152
>>>>> itemsize 53
>>>>>                   extent refs 3 gen 128803 flags DATA
>>>>>                   extent data backref root 258 objectid 1746598 offset 0
>>>>> count 3
>>>>>           item 38 key (7777157365760 EXTENT_ITEM 4096) itemoff 14099
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 257306 flags DATA
>>>>>                   extent data backref root 258 objectid 839874 offset
>>>>> 1716224 count 1
>>>>>           item 39 key (7777157369856 EXTENT_ITEM 262144) itemoff 14046
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239739 flags DATA
>>>>>                   extent data backref root 1 objectid 4315 offset 0
>>>>> count 1
>>>>>           item 40 key (7777157632000 EXTENT_ITEM 4096) itemoff 13993
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 257306 flags DATA
>>>>>                   extent data backref root 258 objectid 839874 offset
>>>>> 1724416 count 1
>>>>>           item 41 key (7777157636096 EXTENT_ITEM 28672) itemoff 13940
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239755 flags DATA
>>>>>                   extent data backref root 7565 objectid 218350 offset 0
>>>>> count 1
>>>>>           item 42 key (7777157672960 EXTENT_ITEM 262144) itemoff 13887
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 251770 flags DATA
>>>>>                   extent data backref root 1 objectid 7446 offset 0
>>>>> count 1
>>>>>           item 43 key (7777157947392 EXTENT_ITEM 12288) itemoff 13834
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 257266 flags DATA
>>>>>                   extent data backref root 258 objectid 839874 offset
>>>>> 1716224 count 1
>>>>>           item 44 key (7777157963776 EXTENT_ITEM 204800) itemoff 13781
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239712 flags DATA
>>>>>                   extent data backref root 7565 objectid 151704 offset 0
>>>>> count 1
>>>>>           item 45 key (7777158168576 EXTENT_ITEM 8192) itemoff 13728
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239755 flags DATA
>>>>>                   extent data backref root 7565 objectid 218364 offset 0
>>>>> count 1
>>>>>           item 46 key (7777158176768 EXTENT_ITEM 8192) itemoff 13675
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158076 offset 0
>>>>> count 1
>>>>>           item 47 key (7777158184960 EXTENT_ITEM 24576) itemoff 13622
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158077 offset 0
>>>>> count 1
>>>>>           item 48 key (7777158209536 EXTENT_ITEM 262144) itemoff 13569
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 250487 flags DATA
>>>>>                   extent data backref root 1 objectid 7042 offset 0
>>>>> count 1
>>>>>           item 49 key (7777159520256 EXTENT_ITEM 868352) itemoff 13516
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 218523 flags DATA
>>>>>                   extent data backref root 258 objectid 3429613 offset 0
>>>>> count 1
>>>>>           item 50 key (7777159340032 EXTENT_ITEM 262144) itemoff 13463
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 252003 flags DATA
>>>>>                   extent data backref root 1 objectid 6709 offset 0
>>>>> count 1
>>>>>           item 51 key (7777159602176 EXTENT_ITEM 8192) itemoff 13410
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158078 offset 0
>>>>> count 1
>>>>>           item 52 key (7777159610368 EXTENT_ITEM 8192) itemoff 13357
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158082 offset 0
>>>>> count 1
>>>>>           item 53 key (7777159618560 EXTENT_ITEM 20480) itemoff 13304
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 253796 flags DATA
>>>>>                   extent data backref root 258 objectid 839874 offset
>>>>> 1708032 count 1
>>>>>           item 54 key (7777159770112 EXTENT_ITEM 53248) itemoff 13251
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239735 flags DATA
>>>>>                   extent data backref root 7565 objectid 180984 offset 0
>>>>> count 1
>>>>>           item 55 key (7777159823360 EXTENT_ITEM 28672) itemoff 13198
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239735 flags DATA
>>>>>                   extent data backref root 7565 objectid 181027 offset 0
>>>>> count 1
>>>>>           item 56 key (7777159852032 EXTENT_ITEM 20480) itemoff 13145
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239735 flags DATA
>>>>>                   extent data backref root 7565 objectid 181029 offset 0
>>>>> count 1
>>>>>           item 57 key (7777159872512 EXTENT_ITEM 8192) itemoff 13092
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239736 flags DATA
>>>>>                   extent data backref root 7565 objectid 181418 offset 0
>>>>> count 1
>>>>>           item 58 key (7777159880704 EXTENT_ITEM 12288) itemoff 13039
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158079 offset 0
>>>>> count 1
>>>>>           item 59 key (7777159892992 EXTENT_ITEM 131072) itemoff 12986
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 152898 flags DATA
>>>>>                   extent data backref root 258 objectid 2111468 offset
>>>>> 913408 count 1
>>>>>           item 60 key (7777160024064 EXTENT_ITEM 8192) itemoff 12933
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158085 offset 0
>>>>> count 1
>>>>>           item 61 key (7777160040448 EXTENT_ITEM 12288) itemoff 12880
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158081 offset 0
>>>>> count 1
>>>>>           item 62 key (7777160052736 EXTENT_ITEM 16384) itemoff 12827
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158083 offset 0
>>>>> count 1
>>>>>           item 63 key (7777160069120 EXTENT_ITEM 12288) itemoff 12774
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158084 offset 0
>>>>> count 1
>>>>>           item 64 key (7777160081408 EXTENT_ITEM 8192) itemoff 12721
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158086 offset 0
>>>>> count 1
>>>>>           item 65 key (7777160093696 EXTENT_ITEM 4096) itemoff 12668
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 191200 flags DATA
>>>>>                   extent data backref root 258 objectid 839874 offset
>>>>> 1728512 count 1
>>>>>           item 66 key (7777160097792 EXTENT_ITEM 8192) itemoff 12615
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158088 offset 0
>>>>> count 1
>>>>>           item 67 key (7777160105984 EXTENT_ITEM 24576) itemoff 12562
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158090 offset 0
>>>>> count 1
>>>>>           item 68 key (7777160130560 EXTENT_ITEM 16384) itemoff 12509
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158092 offset 0
>>>>> count 1
>>>>>           item 69 key (7777160146944 EXTENT_ITEM 8192) itemoff 12456
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158093 offset 0
>>>>> count 1
>>>>>           item 70 key (7777160155136 EXTENT_ITEM 8192) itemoff 12403
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158095 offset 0
>>>>> count 1
>>>>>           item 71 key (7777160163328 EXTENT_ITEM 8192) itemoff 12350
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158099 offset 0
>>>>> count 1
>>>>>           item 72 key (7777160171520 EXTENT_ITEM 8192) itemoff 12297
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 239734 flags DATA
>>>>>                   extent data backref root 7565 objectid 158101 offset 0
>>>>> count 1
>>>>>           item 73 key (7777160179712 EXTENT_ITEM 32768) itemoff 12244
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 185891 flags DATA
>>>>>                   extent data backref root 7565 objectid 135098 offset 0
>>>>> count 1
>>>>>           item 74 key (7777160212480 EXTENT_ITEM 9064448) itemoff 12191
>>>>> itemsize 53
>>>>>                   extent refs 3 gen 128804 flags DATA
>>>>>                   extent data backref root 258 objectid 1746670 offset 0
>>>>> count 3
>>>>>           item 75 key (7777169276928 EXTENT_ITEM 5619712) itemoff 12138
>>>>> itemsize 53
>>>>>                   extent refs 4 gen 128815 flags DATA
>>>>>                   extent data backref root 258 objectid 1747043 offset 0
>>>>> count 4
>>>>>           item 76 key (7777174896640 EXTENT_ITEM 49152) itemoff 12085
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 185891 flags DATA
>>>>>                   extent data backref root 7565 objectid 135087 offset 0
>>>>> count 1
>>>>>           item 77 key (7777174945792 EXTENT_ITEM 268435456) itemoff
>>>>> 12019 itemsize 66
>>>>>                   extent refs 4 gen 86553 flags DATA
>>>>>                   extent data backref root 258 objectid 1257818 offset 0
>>>>> count 2
>>>>>                   shared data backref parent 3804574728192 count 2
>>>>>           item 78 key (7777174945792 BLOCK_GROUP_ITEM 1073741824)
>>>>> itemoff 11995 itemsize 24
>>>>>                   block group used 1073135616 chunk_objectid 256 flags
>>>>> DATA|RAID1
>>>>>           item 79 key (7777443381248 EXTENT_ITEM 211255296) itemoff
>>>>> 11929 itemsize 66
>>>>>                   extent refs 2 gen 86553 flags DATA
>>>>>                   extent data backref root 258 objectid 1257818 offset
>>>>> 268435456 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 80 key (7777654636544 EXTENT_ITEM 268435456) itemoff
>>>>> 11863 itemsize 66
>>>>>                   extent refs 147 gen 86553 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset 0
>>>>> count 101
>>>>>                   shared data backref parent 3804574728192 count 46
>>>>>           item 81 key (7777923072000 EXTENT_ITEM 211009536) itemoff
>>>>> 11797 itemsize 66
>>>>>                   extent refs 167 gen 86553 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 268435456 count 96
>>>>>                   shared data backref parent 5253034229760 count 71
>>>>>           item 82 key (7778134081536 EXTENT_ITEM 4096) itemoff 11731
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86555 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 341114880 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 83 key (7778134085632 EXTENT_ITEM 4096) itemoff 11665
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86557 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 402767872 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 84 key (7778134089728 EXTENT_ITEM 4096) itemoff 11599
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86560 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 13631488 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 85 key (7778134093824 EXTENT_ITEM 4096) itemoff 11533
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86560 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 13975552 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 86 key (7778134097920 EXTENT_ITEM 4096) itemoff 11467
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86560 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 16236544 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 87 key (7778134102016 EXTENT_ITEM 4096) itemoff 11401
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86560 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 16351232 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 88 key (7778134106112 EXTENT_ITEM 4096) itemoff 11335
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86564 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 406962176 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 89 key (7778134110208 EXTENT_ITEM 4096) itemoff 11269
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 46923776 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 90 key (7778134114304 EXTENT_ITEM 4096) itemoff 11203
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 47644672 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 91 key (7778134118400 EXTENT_ITEM 4096) itemoff 11137
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 49020928 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 92 key (7778134122496 EXTENT_ITEM 4096) itemoff 11071
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 49037312 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 93 key (7778134126592 EXTENT_ITEM 4096) itemoff 11018
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 180797440 count 1
>>>>>           item 94 key (7778134130688 EXTENT_ITEM 4096) itemoff 10965
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 182140928 count 1
>>>>>           item 95 key (7778134134784 EXTENT_ITEM 4096) itemoff 10912
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 182222848 count 1
>>>>>           item 96 key (7778134138880 EXTENT_ITEM 4096) itemoff 10859
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 201441280 count 1
>>>>>           item 97 key (7778134142976 EXTENT_ITEM 4096) itemoff 10806
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 205635584 count 1
>>>>>           item 98 key (7778134147072 EXTENT_ITEM 4096) itemoff 10753
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 209829888 count 1
>>>>>           item 99 key (7778134151168 EXTENT_ITEM 4096) itemoff 10700
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 210206720 count 1
>>>>>           item 100 key (7778134155264 EXTENT_ITEM 4096) itemoff 10647
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 212451328 count 1
>>>>>           item 101 key (7778134159360 EXTENT_ITEM 4096) itemoff 10594
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 212467712 count 1
>>>>>           item 102 key (7778134163456 EXTENT_ITEM 4096) itemoff 10541
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86565 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 213712896 count 1
>>>>>           item 103 key (7778134167552 EXTENT_ITEM 4096) itemoff 10488
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86567 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 176275456 count 1
>>>>>           item 104 key (7778134171648 EXTENT_ITEM 4096) itemoff 10435
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86567 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 180469760 count 1
>>>>>           item 105 key (7778134175744 EXTENT_ITEM 4096) itemoff 10369
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86571 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 365379584 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 106 key (7778134179840 EXTENT_ITEM 4096) itemoff 10303
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86571 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 368951296 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 107 key (7778134183936 EXTENT_ITEM 4096) itemoff 10237
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86572 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 12697600 count 1
>>>>>                   shared data backref parent 3804574728192 count 1
>>>>>           item 108 key (7778134188032 EXTENT_ITEM 4096) itemoff 10184
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86572 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 151109632 count 1
>>>>>           item 109 key (7778134192128 EXTENT_ITEM 4096) itemoff 10131
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86572 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 255967232 count 1
>>>>>           item 110 key (7778134196224 EXTENT_ITEM 4096) itemoff 10078
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 148488192 count 1
>>>>>           item 111 key (7778134200320 EXTENT_ITEM 4096) itemoff 10025
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 148635648 count 1
>>>>>           item 112 key (7778134204416 EXTENT_ITEM 4096) itemoff 9972
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 149684224 count 1
>>>>>           item 113 key (7778134208512 EXTENT_ITEM 4096) itemoff 9919
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 150077440 count 1
>>>>>           item 114 key (7778134212608 EXTENT_ITEM 4096) itemoff 9866
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 252444672 count 1
>>>>>           item 115 key (7778134216704 EXTENT_ITEM 4096) itemoff 9813
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 252608512 count 1
>>>>>           item 116 key (7778134220800 EXTENT_ITEM 4096) itemoff 9760
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 254263296 count 1
>>>>>           item 117 key (7778134224896 EXTENT_ITEM 4096) itemoff 9707
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86574 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 254541824 count 1
>>>>>           item 118 key (7778134228992 EXTENT_ITEM 4096) itemoff 9641
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86576 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 411156480 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 119 key (7778134233088 EXTENT_ITEM 4096) itemoff 9588
>>>>> itemsize 53
>>>>>                   extent refs 1 gen 86577 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 297910272 count 1
>>>>>           item 120 key (7778134237184 EXTENT_ITEM 4096) itemoff 9522
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86577 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>>>>> 411811840 count 1
>>>>>                   shared data backref parent 5253034229760 count 1
>>>>>           item 121 key (7778134241280 EXTENT_ITEM 4096) itemoff 9456
>>>>> itemsize 66
>>>>>                   extent refs 2 gen 86577 flags DATA
>>>>>                   extent data backref root 258 objectid 1257819 offset
>
>
>
> --
> Tom Dickson-Hunt



-- 
Tom Dickson-Hunt
