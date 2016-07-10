Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38598 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcGJHB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jul 2016 03:01:56 -0400
Received: by mail-wm0-f54.google.com with SMTP id o80so13022453wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jul 2016 00:01:56 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
 <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
 <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com>
 <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com>
 <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
 <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com>
 <CAJCQCtSA9TXO5dEZ-77hoFnc3VAa+81KRoEx9CoJhfStvW3O0A@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <31d22f36-b97a-c150-3125-576a830e08c1@gmail.com>
Date: Sun, 10 Jul 2016 09:01:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSA9TXO5dEZ-77hoFnc3VAa+81KRoEx9CoJhfStvW3O0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After every step, I tried mount fs with ro, ro,recovery and
ro,degraded,recovery. If failed, I moved to next step.


sudo btrfs check --repair /dev/sdc
enabling repair mode
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Checking filesystem on /dev/sdc
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
checking extents
parent transid verify failed on 7009468874752 wanted 70180 found 70133
parent transid verify failed on 7009468874752 wanted 70180 found 70133
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
bytenr mismatch, want=7009468874752, have=65536
parent transid verify failed on 7008859045888 wanted 70175 found 70133
parent transid verify failed on 7008859045888 wanted 70175 found 70133
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
bytenr mismatch, want=7008859045888, have=65536
parent transid verify failed on 7008899547136 wanted 70175 found 70133
parent transid verify failed on 7008899547136 wanted 70175 found 70133
checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
parent transid verify failed on 7008899547136 wanted 70175 found 70133
Ignoring transid failure
leaf parent key incorrect 7008899547136
bad block 7008899547136
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536


btrfs check -r <tree root bytenr> --repair

I didn't use any bytenr for recovery. Recovery worked without -t.

sudo btrfs-find-root /dev/sdc
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
Superblock thinks the generation is 70182
Superblock thinks the level is 1
Found tree root at 6062830010368 gen 70182 level 1
Well block 6062434418688(gen: 70181 level: 1) seems good, but
generation/level doesn't match, want gen: 70182 level: 1
Well block 6062497202176(gen: 69186 level: 0) seems good, but
generation/level doesn't match, want gen: 70182 level: 1
Well block 6062470332416(gen: 69186 level: 0) seems good, but
generation/level doesn't match, want gen: 70182 level: 1


sudo btrfs check -r 6062830010368 --repair /dev/sdc
enabling repair mode
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Checking filesystem on /dev/sdc
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
checking extents
parent transid verify failed on 7009468874752 wanted 70180 found 70133
parent transid verify failed on 7009468874752 wanted 70180 found 70133
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
bytenr mismatch, want=7009468874752, have=65536
parent transid verify failed on 7008859045888 wanted 70175 found 70133
parent transid verify failed on 7008859045888 wanted 70175 found 70133
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
bytenr mismatch, want=7008859045888, have=65536
parent transid verify failed on 7008899547136 wanted 70175 found 70133
parent transid verify failed on 7008899547136 wanted 70175 found 70133
checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
parent transid verify failed on 7008899547136 wanted 70175 found 70133
Ignoring transid failure
leaf parent key incorrect 7008899547136
bad block 7008899547136
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536


sudo btrfs check -r 6062434418688 --repair /dev/sdc
enabling repair mode
parent transid verify failed on 6062434418688 wanted 70182 found 70181
parent transid verify failed on 6062434418688 wanted 70182 found 70181
checksum verify failed on 6062434418688 found F868085E wanted 1C8BB5E8
parent transid verify failed on 6062434418688 wanted 70182 found 70181
Ignoring transid failure
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Checking filesystem on /dev/sdc
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
checking extents
parent transid verify failed on 6063240511488 wanted 70175 found 70132
parent transid verify failed on 6063240511488 wanted 70175 found 70132
checksum verify failed on 6063240511488 found E9831D76 wanted 0D60A0C0
checksum verify failed on 6063240511488 found E9831D76 wanted 0D60A0C0
bytenr mismatch, want=6063240511488, have=65536
parent transid verify failed on 7398301417472 wanted 70180 found 70134
parent transid verify failed on 7398301417472 wanted 70180 found 70134
checksum verify failed on 7398301417472 found B2FA98AB wanted 5619251D
checksum verify failed on 7398301417472 found B2FA98AB wanted 5619251D
bytenr mismatch, want=7398301417472, have=65536
parent transid verify failed on 7398262865920 wanted 70180 found 70133
parent transid verify failed on 7398262865920 wanted 70180 found 70133
checksum verify failed on 7398262865920 found 37B272E5 wanted D351CF53
parent transid verify failed on 7398262865920 wanted 70180 found 70133
Ignoring transid failure
leaf parent key incorrect 7398262865920
parent transid verify failed on 7398398099456 wanted 70180 found 70134
parent transid verify failed on 7398398099456 wanted 70180 found 70134
checksum verify failed on 7398398099456 found 1923B74F wanted FDC00AF9
checksum verify failed on 7398398099456 found 1923B74F wanted FDC00AF9
bytenr mismatch, want=7398398099456, have=65536
parent transid verify failed on 7398398099456 wanted 70180 found 70134
parent transid verify failed on 7398398099456 wanted 70180 found 70134
checksum verify failed on 7398398099456 found 1923B74F wanted FDC00AF9
checksum verify failed on 7398398099456 found 1923B74F wanted FDC00AF9
bytenr mismatch, want=7398398099456, have=65536
parent transid verify failed on 7009449263104 wanted 70180 found 70133
parent transid verify failed on 7009449263104 wanted 70180 found 70133
checksum verify failed on 7009449263104 found AD1A4120 wanted 49F9FC96
checksum verify failed on 7009449263104 found AD1A4120 wanted 49F9FC96
bytenr mismatch, want=7009449263104, have=65536
parent transid verify failed on 7398308003840 wanted 70180 found 70134
parent transid verify failed on 7398308003840 wanted 70180 found 70134
checksum verify failed on 7398308003840 found 9162951D wanted 758128AB
checksum verify failed on 7398308003840 found 9162951D wanted 758128AB
bytenr mismatch, want=7398308003840, have=65536
parent transid verify failed on 7009456766976 wanted 70180 found 70133
parent transid verify failed on 7009456766976 wanted 70180 found 70133
checksum verify failed on 7009456766976 found 0A20BD0C wanted EEC300BA
checksum verify failed on 7009456766976 found 0A20BD0C wanted EEC300BA
bytenr mismatch, want=7009456766976, have=65536
parent transid verify failed on 7398971736064 wanted 70180 found 70134
parent transid verify failed on 7398971736064 wanted 70180 found 70134
checksum verify failed on 7398971736064 found 39868CDB wanted DD65316D
checksum verify failed on 7398971736064 found 39868CDB wanted DD65316D
bytenr mismatch, want=7398971736064, have=65536
parent transid verify failed on 7398171967488 wanted 70180 found 70133
parent transid verify failed on 7398171967488 wanted 70180 found 70133
checksum verify failed on 7398171967488 found 372EF754 wanted D3CD4AE2
checksum verify failed on 7398171967488 found 372EF754 wanted D3CD4AE2
bytenr mismatch, want=7398171967488, have=65536
parent transid verify failed on 7009468596224 wanted 70180 found 70133
parent transid verify failed on 7009468596224 wanted 70180 found 70133
checksum verify failed on 7009468596224 found CE38C9D6 wanted 2ADB7460
parent transid verify failed on 7009468596224 wanted 70180 found 70133
Ignoring transid failure
leaf parent key incorrect 7009468596224
parent transid verify failed on 7398199115776 wanted 70180 found 70133
parent transid verify failed on 7398199115776 wanted 70180 found 70133
checksum verify failed on 7398199115776 found 90F857D8 wanted 741BEA6E
checksum verify failed on 7398199115776 found 90F857D8 wanted 741BEA6E
bytenr mismatch, want=7398199115776, have=65536
parent transid verify failed on 7398207799296 wanted 70180 found 70133
parent transid verify failed on 7398207799296 wanted 70180 found 70133
checksum verify failed on 7398207799296 found 99BAD070 wanted 7D596DC6
checksum verify failed on 7398207799296 found 99BAD070 wanted 7D596DC6
bytenr mismatch, want=7398207799296, have=65536
parent transid verify failed on 7009468874752 wanted 70180 found 70133
parent transid verify failed on 7009468874752 wanted 70180 found 70133
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
bytenr mismatch, want=7009468874752, have=65536
parent transid verify failed on 7008859045888 wanted 70175 found 70133
parent transid verify failed on 7008859045888 wanted 70175 found 70133
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
bytenr mismatch, want=7008859045888, have=65536
parent transid verify failed on 7008899547136 wanted 70175 found 70133
parent transid verify failed on 7008899547136 wanted 70175 found 70133
checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
parent transid verify failed on 7008899547136 wanted 70175 found 70133
Ignoring transid failure
leaf parent key incorrect 7008899547136
bad block 7008899547136
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7398682050560 wanted 70180 found 70134
parent transid verify failed on 7398682050560 wanted 70180 found 70134
checksum verify failed on 7398682050560 found 3B3B2ADC wanted DFD8976A
checksum verify failed on 7398682050560 found 3B3B2ADC wanted DFD8976A
bytenr mismatch, want=7398682050560, have=65536


sudo btrfs check -r 6062497202176 --repair /dev/sdc
enabling repair mode
parent transid verify failed on 6062497202176 wanted 70182 found 69186
parent transid verify failed on 6062497202176 wanted 70182 found 69186
checksum verify failed on 6062497202176 found 41994FE1 wanted A57AF257
checksum verify failed on 6062497202176 found 41994FE1 wanted A57AF257
bytenr mismatch, want=6062497202176, have=65536
Couldn't read tree root
Couldn't open file system


sudo btrfs check -r 6062470332416 --repair /dev/sdc
enabling repair mode
parent transid verify failed on 6062470332416 wanted 70182 found 69186
parent transid verify failed on 6062470332416 wanted 70182 found 69186
checksum verify failed on 6062470332416 found 46F2EC59 wanted A21151EF
checksum verify failed on 6062470332416 found 46F2EC59 wanted A21151EF
bytenr mismatch, want=6062470332416, have=65536
Couldn't read tree root
Couldn't open file system


sudo btrfs check --repair --init-csum-tree /dev/sdc
enabling repair mode
Creating a new CRC tree
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Checking filesystem on /dev/sdc
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
Reinit crc root
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs(btrfs_reserve_extent+0x8f9)[0x45140a]
btrfs(btrfs_alloc_free_block+0x60)[0x451794]
btrfs[0x41d2d5]
btrfs(cmd_check+0xfe8)[0x42d0f5]
btrfs(main+0x155)[0x40a433]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7ffa55325830]
btrfs(_start+0x29)[0x40a029]


sudo btrfs check --repair --init-extent-tree /dev/sdc
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
Creating a new extent tree
Failed to find [6062434598912, 168, 16384]
btrfs unable to find ref byte nr 6062830010368 parent 0 root 1  owner 1
offset 0
Failed to find [6062434615296, 168, 16384]
btrfs unable to find ref byte nr 6062830174208 parent 0 root 1  owner 0
offset 1
parent transid verify failed on 7398212452352 wanted 70180 found 70133
parent transid verify failed on 7398212452352 wanted 70180 found 70133
checksum verify failed on 7398212452352 found B2C4F638 wanted 56274B8E
checksum verify failed on 7398212452352 found B2C4F638 wanted 56274B8E
bytenr mismatch, want=7398212452352, have=65536
Error reading data reloc tree
error resetting the pending balance
transaction.h:42: btrfs_start_transaction: Assertion
`fs_info->running_transaction` failed.
btrfs[0x4468e6]
btrfs(close_ctree_fs_info+0x184)[0x448d59]
btrfs(cmd_check+0x3010)[0x42f11d]
btrfs(main+0x155)[0x40a433]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f34be581830]
btrfs(_start+0x29)[0x40a029]


I believe you meant rescue command:

sudo btrfs rescue chunk-recover -v /dev/sdc
All Devices:
        Device: id = 1, name = /dev/sdd
        Device: id = 3, name = /dev/sdb
        Device: id = 2, name = /dev/sdc

Scanning: 2808088981504 in dev0, 2759780548608 in dev1, 2978000535552 in
dev2scan chunk headers error
Chunk tree recovery aborted


sudo btrfs rescue zero-log /dev/sdc
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Clearing log on /dev/sdc, previous log_root 0, level 0
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs(btrfs_reserve_extent+0x8f9)[0x45140a]
btrfs(btrfs_alloc_free_block+0x60)[0x451794]
btrfs(__btrfs_cow_block+0x1a7)[0x4406dc]
btrfs(btrfs_cow_block+0x102)[0x441161]
btrfs[0x446ce3]
btrfs(btrfs_commit_transaction+0xec)[0x448ac7]
btrfs[0x432d3d]
btrfs(handle_command_group+0x5d)[0x40a2d9]
btrfs(cmd_rescue+0x15)[0x432d71]
btrfs(main+0x155)[0x40a433]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7fb21969b830]
btrfs(_start+0x29)[0x40a029]


So far, no luck. I can't still mount.

Thank you
Tomas

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Saturday, July 09, 2016 8:33PM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

btrfs check --repair


---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

