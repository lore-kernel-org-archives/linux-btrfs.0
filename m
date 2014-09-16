Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53203 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752884AbaIPU5J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 16:57:09 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with unmountable filesystem.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54184BD2.7000300@gmail.com>
Date: Tue, 16 Sep 2014 14:57:01 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
References: <54184BD2.7000300@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 16, 2014, at 8:40 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> Based on the kernel messages, the primary issue is log corruption, and
> in theory btrfs-zero-log should fix it.

Can you provide a complete dmesg somewhere for this initial failure, just for reference? I'm curious what this indication looks like compared to other problems.

>  The actual issue however, is
> that the primary superblock appears to be pointing at a corrupted root
> tree, which causes pretty much everything that does anything other than
> just read the sb to fail.  The first backup sb does point to a good
> tree, but only btrfs check and btrfs restore have any option to ignore
> the first sb and use one of the backups instead.

Maybe use wipefs -a on this volume, which removes the magic from only the first superblock by default (you can specify another location). And then try btrfs-show-super -F which "dumps" supers with bad magic.

I just tried this:
# wipefs -a /dev/sdb
/dev/sdb: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48 52 66 53 5f 4d
# btrfs-show-super -F /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x5c1196d7 [DON'T MATCH]
bytenr			65536
flags			0x1
magic			........ [DON'T MATCH]
[…]
# btrfs-show-super -i1 /dev/sdb
superblock: bytenr=67108864, device=/dev/sdb
---------------------------------------------------------
csum			0xfc70be19 [match]
bytenr			67108864
flags			0x1
magic			_BHRfS_M [match]

So the mirror is definitely there and valid.
# btrfs rescue super-recover -yv /dev/sdb
No valid Btrfs found on /dev/sdb
Usage or syntax errors

Not expected at all, man page says "Recover bad superblocks from good copies." There's a good copy, it's not being found by btrfs rescue super-recover. Seems like a bug.


# btrfs check /dev/sdb
No valid Btrfs found on /dev/sdb
Couldn't open file system

# btrfs check -s1 /dev/sdb
using SB copy 1, bytenr 67108864
Checking filesystem on /dev/sdb
UUID: 9acf13de-5b98-4f28-9992-533e4a99d348
[snip]
OK it finds it, maybe a --repair will fix the bad first one?
# btrfs check -s1 /dev/sdb
using SB copy 1, bytenr 67108864
enabling repair mode
Checking filesystem on /dev/sdb
UUID: 9acf13de-5b98-4f28-9992-533e4a99d348
[snip]
No indication of repair
# btrfs check /dev/sdb
No valid Btrfs found on /dev/sdb
Couldn't open file system
# btrfs check /dev/sdb
No valid Btrfs found on /dev/sdb
Couldn't open file system
[root@f21v ~]# btrfs-show-super -F /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x5c1196d7 [DON'T MATCH]
bytenr			65536
flags			0x1
magic			........ [DON'T MATCH]


Still not fixed. Maybe I needed to corrupt something else in the superblock other than the magic and this behavior is intentional, otherwise wipefs -a, followed by btrfsck would resurrect an intentionally wiped btrfs fs, potentially wiping out some newer file system in the process.



> I'm fine using dd to replace the primary sb with one of the
> backups, but don't know the exact parameters that would be needed.

Here's an idea:

# btrfs-show-super /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x92aa51ab [match]
[snip]
So I know what I'm looking for starts at LBA 65536/512

# dd if=/dev/sdb skip=128 count=4 2>/dev/null | hexdump -C
00000000  92 aa 51 ab 00 00 00 00  00 00 00 00 00 00 00 00  |..Q…..........|
[snip]

And as it turns out the csum is right at the beginning, 4 bytes. So use bs of 4 bytes, seek 65536/4, count of 1. This should zero just 4 bytes starting at 65536 bytes in.

# dd if=/dev/zero of=/dev/sdb bs=4 seek=16384 count=1

Checked it with the earlier skip=128 command and it looks like everything else is intact.

# btrfs-show-super -F /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x00000000 [DON'T MATCH]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
[snip]
OK so the csum is bad, the magic is good. Now see if btrfs rescue super-recover does anything
# btrfs rescue super-recover /dev/sdb
Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure? [y/N]: Y
Recovered bad superblocks successful
*** Error in `btrfs': corrupted double-linked list: 0x0000000002289e40 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x7a77e)[0x7f388663977e]
/lib64/libc.so.6(+0x80b03)[0x7f388663fb03]
/lib64/libc.so.6(+0x81c88)[0x7f3886640c88]
/lib64/libc.so.6(cfree+0x4c)[0x7f38866456ec]
btrfs[0x425ec6]
btrfs[0x406902]
/lib64/libc.so.6(__libc_start_main+0xf0)[0x7f38865df0e0]
btrfs[0x406a04]
======= Memory m
[snip]

kaboom!

But was it really successful?
# btrfs-show-super -F /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum			0x92aa51ab [match]
[skip]
Looks fixed. And it mounts.

NOW, I didn't actually have my first superblock pointing to a corrupt root tree. So it's possible that while the csum was fixed in my case, that the subsequent crash has not properly copied all good parts of superblock1 to superblock0. *shrug*

And since it crashes, looks like I found a bug.

> I'm using btrfs-progs 3.16 and
> kernel 3.16.1.

So did I for all of the above.


Chris Murphy

