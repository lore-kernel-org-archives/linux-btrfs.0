Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48428 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdKQPuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:50:21 -0500
Date: Fri, 17 Nov 2017 07:50:09 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20171117155009.po4wxaqlyqnzqpom@merlins.org>
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
 <20171117073046.ehdlw5essf7lhw7k@merlins.org>
 <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered,
 value -17
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 17, 2017 at 04:12:07PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年11月17日 15:30, Marc MERLIN wrote:
> > Here's the whole output:
> > gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 1919805647
> 
> Sorry, I missed "-C10" parameter for grep.
 
                generation 2231977 transid 2237084 size 64 nbytes 0
                block group 0 mode 40755 links 1 uid 33 gid 33 rdev 0
                sequence 0 flags 0x1710(none)
                atime 1510290002.516060162 (2017-11-09 21:00:02)
                ctime 1510477350.88506455 (2017-11-12 01:02:30)
                mtime 1510477350.88506455 (2017-11-12 01:02:30)
                otime 1510290002.516060162 (2017-11-09 21:00:02)
        item 26 key (1919785864 INODE_REF 1919785862) itemoff 14683 itemsize 12
                index 2 namelen 2 name: 00
        item 27 key (1919785864 DIR_ITEM 2591417872) itemoff 14637 itemsize 46
                location key (1919805647 INODE_ITEM 0) type FILE
                transid 2231988 data_len 0 name_len 16
                name: 1955-capture.jpg
        item 28 key (1919785864 DIR_ITEM 3406016191) itemoff 14591 itemsize 46
                location key (1919805657 INODE_ITEM 0) type FILE
                transid 2231988 data_len 0 name_len 16
                name: 1956-capture.jpg
        item 29 key (1919785864 DIR_INDEX 1957) itemoff 14575 itemsize 16
                location key (7383370114097217536 UNKNOWN.211 15651972432879681580) type DIR_ITEM.0
                transid 72057594045427176 data_len 0 name_len 0
                name: 
        item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 160
                generation 2231988 transid 2231989 size 81701 nbytes 81920
                block group 0 mode 100644 links 1 uid 33 gid 33 rdev 0
                sequence 8 flags 0x14(NOCOMPRESS)
                atime 1510290392.703320623 (2017-11-09 21:06:32)
                ctime 1510290392.715320477 (2017-11-09 21:06:32)
                mtime 1510290392.715320477 (2017-11-09 21:06:32)
                otime 1510290392.703320623 (2017-11-09 21:06:32)
        item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 itemsize 26
                index 1957 namelen 16 name: 1955-capture.jpg
        item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize 53
                generation 2231989 type 1 (regular)
                extent data disk byte 2381649588224 nr 81920
                extent data offset 0 nr 81920 ram 81920
                extent compression 0 (none)
        item 33 key (1919805657 INODE_ITEM 0) itemoff 14176 itemsize 160
                generation 2231988 transid 2231989 size 81856 nbytes 81920
                block group 0 mode 100644 links 1 uid 33 gid 33 rdev 0
                sequence 8 flags 0x14(NOCOMPRESS)
                atime 1510290392.919317997 (2017-11-09 21:06:32)
                ctime 1510290392.931317852 (2017-11-09 21:06:32)


> Although what we could try is to avoid BUG_ON(), but I'm afraid the
> problem is more severe than my expectation.
 
How does it look now?

> Any idea how such corruption happened?

Sigh, I wish I knew.

It feels like every btrfs filesystem I've had between my 3 systems has
gotten inexplicably corrupted at least once.
This one is not even using bcache, just dmcrypt underneath.

It's my only one using btrfs raid (1):
gargamel:~# btrfs fi show /dev/mapper/raid0d1 
Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
        Total devices 2 FS bytes used 1.12TiB
        devid    1 size 836.13GiB used 722.03GiB path /dev/mapper/raid0d1
        devid    2 size 836.13GiB used 722.03GiB path /dev/mapper/raid0d2

Data, RAID0: total=1.38TiB, used=1.11TiB
System, RAID1: total=32.00MiB, used=128.00KiB
Metadata, RAID1: total=13.00GiB, used=8.54GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Now, I didn't get errors or warnings, or even scrub warnings on it, I just ran 
btrfs check to see what would happen.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
