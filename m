Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:44024 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab2LDI6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Dec 2012 03:58:32 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 3F20A85FB7B
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2012 09:50:48 +0100 (CET)
Message-ID: <50BDB967.9070400@siedziba.pl>
Date: Tue, 04 Dec 2012 09:50:47 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: various problems converting to RAID1
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On saturday I added another disk to my BTRFS filesystem. I started a 
rebalance to convert it from m:DUP/d:single to m:RAID1/d:RAID1.

I quickly noticed it started filling my logs with: "btrfs: block rsv 
returned -28", and "slowpath" warnings from "use_block_rsv+0x198/0x1a0 
[btrfs]" (http://pastebin.com/HF6u3g31).

It was also seemingly stuck. After around 2 hours with no progress at 
all from "balance status" command, I went to #btrfs IRC channel to ask 
what should I do. I've been told to cancel it, I run "balance cancel" 
but it was stuck too. Then I noticed from "fi df" output, that metadata 
DUP usage is slowly going down, while RAID1 is slowly going up. Very 
slowly. So I waited. Finally cancel worked.

I decided to resume the conversion (adding "soft" to the command like 
this: "balance start -mconvert=raid1,soft -dconvert=raid1,soft"), and 
leave it working over night.

On sunday balance suddenly stopped, but it wasn't finished. Turns out, 
it run out of space, due to metadata total space exploding from less 
than 7 GB to above 50GB:

Data, RAID1: total=395.96GB, used=395.82GB
Data: total=8.00MB, used=8.00MB
System, DUP: total=8.00MB, used=72.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=51.50GB, used=6.35GB
Metadata, DUP: total=1.00GB, used=501.86MB
Metadata: total=8.00MB, used=0.00

There were also some worrying messages in the log: 
http://pastebin.com/ceka12NM.

I rebooted my computer and the balance started continuing its work by 
itself. After a while it stopped again. No messages it the log, but it 
didn't finish either.

I started it again, and after a while the command stopped with "No such 
file or directory" error. Started again, same error. In the log there's 
only:

[83690.889986] btrfs: relocating block group 29360128 flags 36
[87480.359914] btrfs: relocating block group 29360128 flags 36
[88893.850409] btrfs: relocating block group 29360128 flags 36

I unmounted the FS and run btrfsck. It found some extent errors:

checking extents
ref mismatch on [711069696 4096] extent item 1, found 0
Backref 711069696 root 8 not referenced back 0x1e6d0590
Incorrect global backref count on 711069696 found 1 wanted 0
backpointer mismatch on [711069696 4096]
owner ref check failed [711069696 4096]
ref mismatch on [848388096 4096] extent item 1, found 0
Backref 848388096 root 8 not referenced back 0x36311b90
Incorrect global backref count on 848388096 found 1 wanted 0
backpointer mismatch on [848388096 4096]
owner ref check failed [848388096 4096]
Errors found in extent allocation tree

...and a lot of these errors:

checking fs roots
root 823 inode 222165 errors 400
root 823 inode 390623 errors 400
root 838 inode 1261335 errors 400
[...]

Full error log here: http://pastebin.com/HyjmWBNA

What should I do next? I'd like to repair it in place if possible. The 
FS contains mostly daily backups, not important virtual machine images, 
Steam with games etc. Repairing it would save me redownloading gigabytes 
of data over the internet (I can just run my next rsync backups with 
"--checksum", verify my Steam game files, and that's it), or looking for 
another hard disk to copy it somewhere.

Regards
