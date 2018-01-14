Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37894 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751239AbeANQjA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 11:39:00 -0500
Date: Sun, 14 Jan 2018 17:38:55 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-14 08:36:41 [+0800], Qu Wenruo wrote:
> Still needs more. (and maybe even more depending on the output)
> 
> The original mode doesn't report error clear enough, so it would help if
> --mode=lowmem can be used.
> 
> # btrfs check --mode=lowmem /dev/sdb4

~# btrfs check --mode=lowmem /dev/sdb4
Checking filesystem on /dev/sdb4
UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
checking extents
checking free space cache
Wanted bytes 4096, found 8192 for off 159178047488
Wanted bytes 1073725440, found 8192 for off 159178047488
cache appears valid but isn't 159178031104
ERROR: errors found in free space cache
found 63691210752 bytes used, error(s) found
total csum bytes: 61339388
total tree bytes: 860540928
total fs tree bytes: 688816128
total extent tree bytes: 84549632
btree space waste bytes: 224428280
file data blocks allocated: 62890483712
 referenced 62828957696

> And the tree dump of the affected dir inode would help too:
> 
> # btrfs inspect dump-tree /dev/sdb4 | grep -C 20 \(57648595

~# btrfs inspect dump-tree /dev/sdb4 | grep -C 20 \(57648595
                generation 88831 type 1 (regular)
                extent data disk byte 193705541632 nr 134217728
                extent data offset 0 nr 134217728 ram 134217728
                extent compression 0 (none)
        item 4 key (57022249 EXTENT_DATA 402653184) itemoff 3769 itemsize 53
                generation 88831 type 1 (regular)
                extent data disk byte 190035439616 nr 60600320
                extent data offset 0 nr 60600320 ram 60600320
                extent compression 0 (none)
        item 5 key (57643659 INODE_ITEM 0) itemoff 3609 itemsize 160
                generation 89044 transid 89423 size 2 nbytes 0
                block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0x150be(none)
                atime 1513266994.264310920 (2017-12-14 16:56:34)
                ctime 1513868332.369178014 (2017-12-21 15:58:52)
                mtime 1513868332.369178014 (2017-12-21 15:58:52)
                otime 1513266994.264310920 (2017-12-14 16:56:34)
        item 6 key (57643659 INODE_REF 58477961) itemoff 3598 itemsize 11
                index 6 namelen 1 name: 4
        item 7 key (57643659 DIR_ITEM 4189400016) itemoff 3567 itemsize 31
                location key (57648595 INODE_ITEM 0) type DIR
                transid 89045 data_len 0 name_len 1
                name: d
        item 8 key (57643659 DIR_INDEX 113) itemoff 3536 itemsize 31
                location key (57648595 INODE_ITEM 0) type DIR
                transid 89045 data_len 0 name_len 1
                name: d
        item 9 key (57643872 INODE_ITEM 0) itemoff 3376 itemsize 160
                generation 89044 transid 89699 size 0 nbytes 0
                block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0x603b3(none)
                atime 1513266995.540343055 (2017-12-14 16:56:35)
                ctime 1515602448.66422211 (2018-01-10 17:40:48)
                mtime 1515602448.66422211 (2018-01-10 17:40:48)
                otime 1513266995.540343055 (2017-12-14 16:56:35)
        item 10 key (57643872 INODE_REF 682) itemoff 3363 itemsize 13
                index 58 namelen 3 name: tmp
        item 11 key (57648595 INODE_ITEM 0) itemoff 3203 itemsize 160
                generation 89045 transid 89423 size 8350 nbytes 0
                block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0xc90(none)
                atime 1513267009.164686143 (2017-12-14 16:56:49)
                ctime 1513868329.753150507 (2017-12-21 15:58:49)
                mtime 1513868329.753150507 (2017-12-21 15:58:49)
                otime 1513267009.164686143 (2017-12-14 16:56:49)
        item 12 key (57648595 INODE_REF 57643659) itemoff 3192 itemsize 11
                index 113 namelen 1 name: d
        item 13 key (57648595 DIR_ITEM 3331247447) itemoff 3123 itemsize 69
                location key (58472210 INODE_ITEM 0) type FILE
                transid 89418 data_len 0 name_len 8231
                name: 454bf066ddfbf42e0f3b77ea71c82f-878732.oq
        item 14 key (57648595 DIR_ITEM 3363354030) itemoff 3053 itemsize 70
                location key (57923894 INODE_ITEM 0) type DIR_ITEM.33
                transid 89142 data_len 0 name_len 40
                name: 2f3f379b2a3d7499471edb74869efe-1948311.d
        item 15 key (57648595 DIR_INDEX 435) itemoff 2983 itemsize 70
                location key (57923894 INODE_ITEM 0) type FILE
                transid 89142 data_len 0 name_len 40
                name: 2f3f379b2a3d7499471edb74869efe-1948311.d
        item 16 key (57648595 DIR_INDEX 1137) itemoff 2914 itemsize 69
                location key (58472210 INODE_ITEM 0) type FILE
                transid 89418 data_len 0 name_len 39
                name: 454bf066ddfbf42e0f3b77ea71c82f-878732.o
        item 17 key (57923894 INODE_ITEM 0) itemoff 2754 itemsize 160
                generation 89142 transid 89142 size 36092 nbytes 36864
                block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0x91(none)
                atime 1513278413.460486168 (2017-12-14 20:06:53)
                ctime 1513278413.460486168 (2017-12-14 20:06:53)
                mtime 1513278413.460486168 (2017-12-14 20:06:53)
                otime 1513278413.460486168 (2017-12-14 20:06:53)
        item 18 key (57923894 INODE_REF 57648595) itemoff 2704 itemsize 50
                index 435 namelen 40 name: 2f3f379b2a3d7499471edb74869efe-1948311.d
        item 19 key (57923894 EXTENT_DATA 0) itemoff 2651 itemsize 53
                generation 89142 type 1 (regular)
                extent data disk byte 123290755072 nr 36864
                extent data offset 0 nr 36864 ram 36864
                extent compression 0 (none)
        item 20 key (58191388 INODE_ITEM 0) itemoff 2491 itemsize 160
                generation 89259 transid 89259 size 395280 nbytes 397312
> Thanks,
> Qu

Sebastian
