Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alpha.solidcluster.net ([195.228.155.188]:50580 "EHLO
        beta.reon.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751765AbcJJVuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 17:50:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 10 Oct 2016 23:50:14 +0200
From: aron@aron.ws
To: <bo.li.liu@oracle.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: corrupt leaf, slot offset bad
In-Reply-To: <20161010210346.GA8381@localhost.localdomain>
References: <57e7870b981160be5fabc63c4967e90f@aron.ws>
 <20161010210346.GA8381@localhost.localdomain>
Message-ID: <dadc0ef66b1ee3f85446e602ac2e8468@aron.ws>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

item 109 has a few strange chars in its name (and it's truncated): 
1-x86_64.pkg.tar.xz 0x62 0x14 0x0a 0x0a

	item 105 key (261 DIR_ITEM 54556048) itemoff 11723 itemsize 72
		location key (606286 INODE_ITEM 0) type FILE
		namelen 42 datalen 0 name: python2-gobject-3.20.1-1-x86_64.pkg.tar.xz
	item 106 key (261 DIR_ITEM 56363628) itemoff 11660 itemsize 63
		location key (894298 INODE_ITEM 0) type FILE
		namelen 33 datalen 0 name: unrar-1:5.4.5-1-x86_64.pkg.tar.xz
	item 107 key (261 DIR_ITEM 66963651) itemoff 11600 itemsize 60
		location key (1178 INODE_ITEM 0) type FILE
		namelen 30 datalen 0 name: glibc-2.23-5-x86_64.pkg.tar.xz
	item 108 key (261 DIR_ITEM 68561395) itemoff 11532 itemsize 68
		location key (660578 INODE_ITEM 0) type FILE
		namelen 38 datalen 0 name: squashfs-tools-4.3-4-x86_64.pkg.tar.xz
	item 109 key (261 DIR_ITEM 76859450) itemoff 11483 itemsize 65
		location key (2397184 UNKNOWN.0 7091317839824617472) type 45
		namelen 13102 datalen 13358 name: 1-x86_64.pkg.tar.xzb

		data
	item 110 key (261 DIR_ITEM 9799832789237604651) itemoff 11405 itemsize 
62
		location key (388547 INODE_ITEM 0) type FILE
		namelen 32 datalen 0 name: intltool-0.51.0-1-any.pkg.tar.xz
	item 111 key (261 DIR_ITEM 81211850) itemoff 11344 itemsize 131133
		location key (893669 INODE_ITEM 0) type FILE
		namelen 31 datalen 0 name: babl-0.1.16-1-x86_64.pkg.tar.xz
		location key (388547 INODE_ITEM 0) type FILE

Thanks,
Aron

On 2016-10-10 23:03, Liu Bo wrote:

> On Mon, Oct 10, 2016 at 08:57:19PM +0200, aron@aron.wswrote:
>
>> Hi all, I've been using btrfs for a few months now, without any
>> problems. During work, I've noticed segfaults, when accessing my 
>> root
>> directory. As my home directory contents was readable, I've decided 
>> to
>> reboot. That was the worst decision, as now I can't copy my data off
>> the SSD. It seems like a memory isse. I have backups, but its ~2 
>> weeks
>> old. What I did is a dd dump immediately. Have latest kernel and 
>> latest
>> progs built from source now, but :S ... This is what I've got: When
>> mounting: BTRFS critical (device: sdb2): corrupt leaf, slot offset 
>> bad:
>> block=610107392,root=1, slot=108
>
> This indicates that leaf 610107392 is corrupted somehow because its 
> slot
> 108's 'start offset in leaf' and slot 109's 'end offset in leaf' 
> doesn't
> match with each other, the cause is not shown though.
>
>> find-root prints nothing to the stdout ofter 2 hours. running btrfs
>> inspect-internal dump-tre> 92 /dev/sdb2 leaf 610107392 items 188 
>> free
> spac
> tion 90792 owner 5
>
> owner 5 means that it's not a tree root leaf, > ee leaf. fs uuid
> 2cc75a87-b22b-448e-80d4-383a9f42deed chunk uuid
>> a5b09a2a-da3d-4049-91ba-4fe66932907b item 0 key (256 INODE_ITEM 0)
>> itemoff 16123 itemsize 160 inode generation 3 transid 90769 size 144
>> nbytes 16384 block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0 
>> flags
>> 0x0(none) item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>> inode ref index 0 namelen 2 name: .. item 2 key (256 DIR_ITEM
>> 145260132) itemoff 16078 itemsize 33 location key (265 INODE_ITEM 0)
>> type DIR namelen 3 datalen 0 name: dev item 3 key (256 DIR_ITEM
>> 217684952) itemoff 16045 itemsize 33 location key (266 INODE_ITEM 0)
>> type DIR namelen 3 datalen 0 name: run item 4 key (256 DIR_ITEM
>> 308198373) itemoff 16011 itemsize 34 location key (257
> ) type DIR ...
>
> Maybe we can check the content of item 108 and item 109 in this 
> output
> from
> 'dump-tree'?
>
> Thanks,
>
> -liubo
>
>> item 111 key (261 DIR_ITEM 81211850) itemoff 11344 itemsize 131133
>> location key (893669 INODE_ITEM 0) type FILE namelen 31 datalen 0 
>> name:
>> babl-0.1.16-1-x86_64.pkg.tar.xz location key (388547 INODE_ITEM 0) 
>> type
>> FILE namelen 32 datalen 0 name: intltool-0.51.0-1-any.pkg.tar.xz ...
>> namelen 30 datalen 0 name: glibc-2.24-2-x86_64.pkg.tar.xz location 
>> key
>> (893658 INODE_ITEM 0) type FILE namelen 36 datalen 0 name:
>> procps-ng-3.3.12-1-x86_64.pkg.tar.xz location key (EXTENT_TREE
>> UNKNOWN.3 36094832640) type 12 namelen 0 datalen 0 name: location 
>> key
>> (291 UNKNOWN.0 0) type 0 namelen 0 datalen 0 name: location key
>> (18556457741975552 UNKNOWN.0 0) type 0 namelen 0 datalen 7134 name:
>> data location key (0 UNKNOWN.0 0) type 0 namelen 0 datalen 0 name:
>> location key (0 UNKNOWN.0 0) type 0 namelen 0 datalen 0 name: 
>> location
>> key (0 UNKNOWN.0 0) type 0 namelen 0 datalen 0 name: location key (0
>> UNKNOWN.0 0) type 0 namelen 0 datalen 0 name: location key (0 
>> UNKNOWN.0
>> 0) type 0 namelen 0 datalen 0 name: location key (0 UNKNOWN.0 0) 
>> type 0
>> namelen 0 datalen 0 name: location key (0 UNKNOWN.0 0) type 0 
>> namelen 0
>> datalen 0 name: location key (0 UNKNOWN.0 0) type 0 namelen 0 
>> datalen 0
>> name: location key (0 UNKNOWN.0 0) type 0 namelen 0 datalen 0 name:
>> .... segfault running restore: incorrect offsets 11532 11548 Error
>> searching -1 Tried every rescue, check commands, in different
>> variations ... nothing. It seems that the root leaf (?) has some
>> garbage, tried using the corrupt-block utility, to mark the item 
>> dirty
>> got the same error: incorrect offsets. The only thing I've managed 
>> is
>> to restore a part of the /etc directory, with: btrfs restore -i -f
>> 610123776 -vvvv -d /dev/sdb2 /mnt/restore I'm still trying to learn 
>> how
>> the data is structured now, but my problem is that I can't figure 
>> out
>> how to calculate the leaf positions, using the dump-tree output ... 
>> I
>> need some kind tool/script that can recursively rescue the structure
>> from a defined leaf. (can this be done?) Any help would be 
>> appreciated!
>> :) Thanks! Yours, Aron -- To unsubscribe from this list: send the 
>> line
>> "unsubscribe linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html [1]
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html [1]



Links:
------
[1] http://vger.kernel.org/majordomo-info.html
