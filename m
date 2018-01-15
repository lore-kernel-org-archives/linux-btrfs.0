Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40044 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932231AbeAOJAy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 04:00:54 -0500
Date: Mon, 15 Jan 2018 10:00:50 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-15 09:26:27 [+0800], Qu Wenruo wrote:
> Please run the following command too:
> 
> # btrfs inspect dump-tree <device> | grep -C20 \(57923894

~# btrfs inspect dump-tree /dev/sdb4 | grep -C20 \(57923894
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
                block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0xa4(none)
                atime 1513332325.477020047 (2017-12-15 11:05:25)
                ctime 1513332325.477020047 (2017-12-15 11:05:25)
                mtime 1513332325.477020047 (2017-12-15 11:05:25)
                otime 1513332325.477020047 (2017-12-15 11:05:25)
        item 21 key (58191388 INODE_REF 40424284) itemoff 2470 itemsize 21
                index 1094 namelen 11 name: bzImage.tsc
leaf 146426621952 items 46 free space 11 generation 89680 owner 5
leaf 146426621952 flags 0x1(WRITTEN) backref revision 1
fs uuid b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
chunk uuid 732d73c9-d037-4406-8dcb-dfa101bc5a9b
        item 0 key (58191388 EXTENT_DATA 0) itemoff 3942 itemsize 53
                generation 87303 type 1 (regular)

> >                 transid 89142 data_len 0 name_len 40
> >                 name: 2f3f379b2a3d7499471edb74869efe-1948311.d
> >         item 16 key (57648595 DIR_INDEX 1137) itemoff 2914 itemsize 69
> >                 location key (58472210 INODE_ITEM 0) type FILE
> 
> And this command too:
> 
> # btrfs inspect dump-tree <device> | grep -C20 \(58472210

~# btrfs inspect dump-tree /dev/sdb4 | grep -C20 \(58472210
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
                block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0xa4(none)
                atime 1513332325.477020047 (2017-12-15 11:05:25)
                ctime 1513332325.477020047 (2017-12-15 11:05:25)
                mtime 1513332325.477020047 (2017-12-15 11:05:25)
                otime 1513332325.477020047 (2017-12-15 11:05:25)
        item 21 key (58191388 INODE_REF 40424284) itemoff 2470 itemsize 21
                index 1094 namelen 11 name: bzImage.tsc
leaf 146426621952 items 46 free space 11 generation 89680 owner 5
leaf 146426621952 flags 0x1(WRITTEN) backref revision 1
fs uuid b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
chunk uuid 732d73c9-d037-4406-8dcb-dfa101bc5a9b
        item 0 key (58191388 EXTENT_DATA 0) itemoff 3942 itemsize 53
                generation 87303 type 1 (regular)
                extent data disk byte 153024724992 nr 397312
                extent data offset 0 nr 397312 ram 397312
                extent compression 0 (none)
        item 1 key (58472210 INODE_ITEM 0) itemoff 3782 itemsize 160
                generation 89418 transid 89419 size 168464 nbytes 172032
                block group 0 mode 100644 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0x48(none)
                atime 1513868153.15329422 (2017-12-21 15:55:53)
                ctime 1513868153.15329422 (2017-12-21 15:55:53)
                mtime 1513868153.15329422 (2017-12-21 15:55:53)
                otime 1513868153.15329422 (2017-12-21 15:55:53)
        item 2 key (58472210 INODE_REF 57648595) itemoff 3733 itemsize 49
                index 1137 namelen 39 name: 454bf066ddfbf42e0f3b77ea71c82f-878732.o
        item 3 key (58472210 EXTENT_DATA 0) itemoff 3680 itemsize 53
                generation 89419 type 1 (regular)
                extent data disk byte 153083658240 nr 172032
                extent data offset 0 nr 172032 ram 172032
                extent compression 0 (none)
        item 4 key (58477961 INODE_ITEM 0) itemoff 3520 itemsize 160
                generation 89420 transid 89424 size 2 nbytes 0
                block group 0 mode 40755 links 1 uid 1000 gid 1000 rdev 0
                sequence 0 flags 0x1ec(none)
                atime 1513868234.836162788 (2017-12-21 15:57:14)
                ctime 1513868371.49586338 (2017-12-21 15:59:31)
                mtime 1513868371.49586338 (2017-12-21 15:59:31)
                otime 1513868234.836162788 (2017-12-21 15:57:14)
        item 5 key (58477961 INODE_REF 682) itemoff 3509 itemsize 11
                index 59 namelen 1 name: X
        item 6 key (58477961 DIR_ITEM 2828071171) itemoff 3478 itemsize 31
                location key (57643659 INODE_ITEM 0) type DIR
                transid 89420 data_len 0 name_len 1
                name: 4
        item 7 key (58477961 DIR_INDEX 6) itemoff 3447 itemsize 31
                location key (57643659 INODE_ITEM 0) type DIR

> Thanks,
> Qu

Sebastian
