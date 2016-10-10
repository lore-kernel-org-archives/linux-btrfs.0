Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alpha.solidcluster.net ([195.228.155.188]:59630 "EHLO
        beta.reon.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751100AbcJJTU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 15:20:58 -0400
Received: from localhost ([127.0.0.1] helo=mail.reondigital.hu)
        by beta.reon.hu with esmtp (Exim 4.87)
        (envelope-from <aron@aron.ws>)
        id 1btflH-0007eX-52
        for linux-btrfs@vger.kernel.org; Mon, 10 Oct 2016 20:57:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 10 Oct 2016 20:57:19 +0200
From: aron@aron.ws
To: <linux-btrfs@vger.kernel.org>
Subject: corrupt leaf, slot offset bad
Message-ID: <57e7870b981160be5fabc63c4967e90f@aron.ws>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've been using btrfs for a few months now, without any problems. 
During work, I've noticed segfaults, when accessing my root directory. 
As my home directory contents was readable, I've decided to reboot. That 
was the worst decision, as now I can't copy my data off the SSD. It 
seems like a memory isse. I have backups, but its ~2 weeks old. What I 
did is a dd dump immediately. Have latest kernel and latest progs built 
from source now, but :S ...

This is what I've got:

When mounting:

BTRFS critical (device: sdb2): corrupt leaf, slot offset bad: 
block=610107392,root=1, slot=108

find-root prints nothing to the stdout ofter 2 hours.

running btrfs inspect-internal dump-tree -b 610107392 /dev/sdb2

leaf 610107392 items 188 free space 1690 generation 90792 owner 5
fs uuid 2cc75a87-b22b-448e-80d4-383a9f42deed
chunk uuid a5b09a2a-da3d-4049-91ba-4fe66932907b
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 3 transid 90769 size 144 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0
		rdev 0 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..
	item 2 key (256 DIR_ITEM 145260132) itemoff 16078 itemsize 33
		location key (265 INODE_ITEM 0) type DIR
		namelen 3 datalen 0 name: dev
	item 3 key (256 DIR_ITEM 217684952) itemoff 16045 itemsize 33
		location key (266 INODE_ITEM 0) type DIR
		namelen 3 datalen 0 name: run
	item 4 key (256 DIR_ITEM 308198373) itemoff 16011 itemsize 34
		location key (257 INODE_ITEM 0) type DIR

...
	item 111 key (261 DIR_ITEM 81211850) itemoff 11344 itemsize 131133
		location key (893669 INODE_ITEM 0) type FILE
		namelen 31 datalen 0 name: babl-0.1.16-1-x86_64.pkg.tar.xz
		location key (388547 INODE_ITEM 0) type FILE
		namelen 32 datalen 0 name: intltool-0.51.0-1-any.pkg.tar.xz
...
		namelen 30 datalen 0 name: glibc-2.24-2-x86_64.pkg.tar.xz
		location key (893658 INODE_ITEM 0) type FILE
		namelen 36 datalen 0 name: procps-ng-3.3.12-1-x86_64.pkg.tar.xz
		location key (EXTENT_TREE UNKNOWN.3 36094832640) type 12
		namelen 0 datalen 0 name:
		location key (291 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (18556457741975552 UNKNOWN.0 0) type 0
		namelen 0 datalen 7134 name:
		data
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:
		location key (0 UNKNOWN.0 0) type 0
		namelen 0 datalen 0 name:

....

segfault


running restore:

incorrect offsets 11532 11548
Error searching -1

Tried every rescue, check commands, in different variations ... 
nothing. It seems that the root leaf (?) has some garbage, tried using 
the corrupt-block utility, to mark the item dirty got the same error: 
incorrect offsets.

The only thing I've managed is to restore a part of the /etc directory, 
with: btrfs restore -i -f 610123776 -vvvv -d /dev/sdb2 /mnt/restore

I'm still trying to learn how the data is structured now, but my 
problem is that I can't figure out how to calculate the leaf positions, 
using the dump-tree output ...

I need some kind tool/script that can recursively rescue the structure 
from a defined leaf. (can this be done?)

Any help would be appreciated! :)

Thanks!

Yours,
Aron

