Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:32885 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbcA3UKJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 15:10:09 -0500
Received: by mail-lb0-f173.google.com with SMTP id x4so57444224lbm.0
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 12:10:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
Date: Sat, 30 Jan 2016 21:10:07 +0100
Message-ID: <CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Christian Pernegger <pernegger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2016 at 12:59 PM, Christian Pernegger
<pernegger@gmail.com> wrote:
> Hello,
>
> tonight's scrub was cancelled after a "WARNING: device 0 not present".
> No other visible errors or abnormalities.
>
> Google dragged up a linux-btrfs discussion from May 2015, but some of
> it seems to have happend off list and I couldn't find a resolution. As

It i probably this discussion:
 http://www.spinics.net/lists/linux-btrfs/msg43755.html
It is same tools version as you use I see, but newer kernel.

> running btrfs-debug-tree was suggested there and it seemed
> non-invasive, I did:
>
> [...]
> fs tree key (FS_TREE ROOT_ITEM 0)
> leaf 3903828393984 items 10 free space 15539 generation 9938 owner 5
> fs uuid 84a044be-b396-48cf-91dc-c610c0ae11e2
> chunk uuid 7e3f121b-c77f-4d60-a560-897f1aa39d07
>         item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>                 inode generation 3 transid 9938 size 82 block group 0
> mode 40755 links 1 uid 0 gid 0 rdev 0 flags 0x0
>         item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>                 inode ref index 0 namelen 2 name: ..
>         item 2 key (256 DIR_ITEM 243075479) itemoff 16066 itemsize 45
>                 location key (262 ROOT_ITEM -1) type DIR
>                 namelen 15 datalen 0 name: @mohammed-crypt
>         item 3 key (256 DIR_ITEM 606771344) itemoff 16031 itemsize 35
>                 location key (257 ROOT_ITEM -1) type DIR
>                 namelen 5 datalen 0 name: @root
>         item 4 key (256 DIR_ITEM 1793720662) itemoff 15987 itemsize 44
>                 location key (3901 ROOT_ITEM -1) type DIR
>                 namelen 14 datalen 0 name: @backup-legacy
>         item 5 key (256 DIR_ITEM 1811406303) itemoff 15950 itemsize 37
>                 location key (258 ROOT_ITEM -1) type DIR
>                 namelen 7 datalen 0 name: @backup
>         item 6 key (256 DIR_INDEX 5) itemoff 15915 itemsize 35
>                 location key (257 ROOT_ITEM -1) type DIR
>                 namelen 5 datalen 0 name: @root
>         item 7 key (256 DIR_INDEX 6) itemoff 15878 itemsize 37
>                 location key (258 ROOT_ITEM -1) type DIR
>                 namelen 7 datalen 0 name: @backup
>         item 8 key (256 DIR_INDEX 7) itemoff 15833 itemsize 45
>                 location key (262 ROOT_ITEM -1) type DIR
>                 namelen 15 datalen 0 name: @mohammed-crypt
>         item 9 key (256 DIR_INDEX 8) itemoff 15789 itemsize 44
>                 location key (3901 ROOT_ITEM -1) type DIR
>                 namelen 14 datalen 0 name: @backup-legacy
> checksum tree key (CSUM_TREE ROOT_ITEM 0)
> node 4693945303040 level 3 items 5 free 488 generation 14495 owner 7
> fs uuid 84a044be-b396-48cf-91dc-c610c0ae11e2
> chunk uuid 7e3f121b-c77f-4d60-a560-897f1aa39d07
>         key (EXTENT_CSUM EXTENT_CSUM 12582912) block 4693971959808
> (286497312) gen 14495
>         key (EXTENT_CSUM EXTENT_CSUM 1027063414784) block
> 4693997813760 (286498890) gen 14490
>         key (EXTENT_CSUM EXTENT_CSUM 2054823305216) block
> 4693998977024 (286498961) gen 14490
>         key (EXTENT_CSUM EXTENT_CSUM 3077363499008) block
> 4693945729024 (286495711) gen 14495
>         key (EXTENT_CSUM EXTENT_CSUM 4094043148288) block
> 4693992472576 (286498564) gen 14490
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> Ignoring transid failure
> print-tree.c:1074: btrfs_print_tree: Assertion failed.
> btrfs-debug-tree[0x410489]
> btrfs-debug-tree[0x411dbf]
> btrfs-debug-tree[0x402adb]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f925b1ccb45]
> btrfs-debug-tree[0x402d85]

I haven't actively used btrfs-debug-tree myself, but it happens that
these kind of tools crash, sometimes many gigabytes of memory is
used/claimed, maybe that is a reason for the crash.

Can you mount the fs (readonly)?

But you could do a standard check first:
 unmount and run a   btrfs check -p /dev/mapper/sda3_crypt
Its readonly by default, it could give some idea whether the fs is
damaged too much or not.

> This is on a 1-month-old Debian stable (jessie) install and yes, I
> know that means the kernel and btrfs-progs are ancient but I'd still
> very much appreciate some help. It's a backup box, so the data isn't
> critical, but of course I need it stable in the long run. Is it
> possible to fix this and prevent it from happening again? (How) can I
> verify if the data is still good?  If the verdict is that I have to
> re-roll the box I wouldn't go with btrfs again at this time, but still
> be willing to help with debugging first, if anyone is interested.

I think there is a relation between the many ata2 messages and this
scrub failure. It looks like that in this case, scrub want to do its
work, but the drive or some part of the stack is still not out of its
sleep mode. So for some moments, btrfs kernel code state and drive
(devid1) are not in sync. This might have happened also on other
occasions in the last month so the fs might be more damaged than
currently known. Hence the suggestion to do a normal check. You can
use brute-force rsync -c (and more, see manpage) to validate your
data, assuming your sourcedata isn't on btrfs.

A workaround might be to disable PM for the system, or have the
blockdevice only mounted when you backup/write to it. An an obvious
advice is to use a 4.4 kernel and tools. Debian 'stable' doesn't mean
that every piece of the kernel and tooling fits that 'stamp'.

One way to keep a btrfs based backup box stable in the long run is to
use a reasonably new kernel. There is so a lot of improvement for
btrfs from 3.16 to 4.4 and 3.16 is not supported anymore by kernel.org
and this list. Maybe you could switch to a rolling release linux
distro or just update the debian kernel.

But the more fundamental question is why you use btrfs? What features
do you need that ext4 or xfs or reiserfs don't have?

> Regards & TIA
> Christian Pernegger
>
> P.S.: Please CC me, as I'm not on the list.
>
>
>
> Mandatory info:
> chris@mrmackey:~$ uname -a
> Linux mrmackey 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3
> (2016-01-17) x86_64 GNU/Linux
>
> chris@mrmackey:~$ /sbin/btrfs --version
> Btrfs v3.17
>
> chris@mrmackey:~$ sudo btrfs fi show
> Label: 'root'  uuid: 84a044be-b396-48cf-91dc-c610c0ae11e2
>         Total devices 1 FS bytes used 4.46TiB
>         devid    1 size 5.46TiB used 4.68TiB path /dev/mapper/sda3_crypt
>
> Btrfs v3.17
>
> chris@mrmackey:~$ sudo btrfs fi df /mnt/btrfsroot/
> Data, single: total=4.67TiB, used=4.45TiB
> System, DUP: total=8.00MiB, used=528.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=6.50GiB, used=5.07GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
