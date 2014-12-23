Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48643 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbaLWDkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 22:40:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y3GKE-0004sg-01
	for linux-btrfs@vger.kernel.org; Tue, 23 Dec 2014 04:39:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 04:39:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 04:39:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fuzz tester: delete/chmod etc won't work due to "No space left
 on device"
Date: Tue, 23 Dec 2014 03:39:46 +0000 (UTC)
Message-ID: <pan$c7f40$f5e13822$2642bf7d$396a6590@cox.net>
References: <54982AE8.2080602@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Toralf Förster posted on Mon, 22 Dec 2014 15:30:00 +0100 as excerpted:

> I created within a x86 KVM guest at a tmpfs file system under 3.19.0-rc1
> a 257 MB file, created within that abtrfs file system and run the fuzzer
> trinity using that fs for its victim files:
> 
> $ mkdir /mnt/ramdisk/btrfs; truncate -s 257M /mnt/ramdisk/btrfs.fs;
> /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o
> loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777
> /mnt/ramdisk/btrfs"
> SMALL VOLUME: forcing mixed metadata/data groups
> 
> WARNING! - Btrfs v3.14.2 IS EXPERIMENTAL WARNING! - see
> http://btrfs.wiki.kernel.org before using

FWIW, that's an old userspace.  Current btrfs userspace is btrfs-progs 
v3.17.3, last I checked (last nite).  Your kernel is current, at least, 
which is the big thing for operational checks.

> Turning ON incompat feature 'mixed-bg':
> mixed data and metadata block groups
> Turning ON incompat feature 'extref':
> increased hardlink limit per file to 65536
> Created a data/metadata chunk of size 8388608 fs
> created label (null) on /mnt/ramdisk/btrfs.fs
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 257.00MiB
> Btrfs v3.14.2

[Whitespacing to make the below readable.]

> $ D=/mnt/ramdisk/btrfs
> while [[ : ]]; do
> 	cd ~
> 	sudo rm -rf $D/t3 &&
> 		mkdir $D/t3 ||
> 			break
> 	cd $D/t3
>	mkdir -p v1/v2
>	for i in $(seq 0 99); do
> 		touch v1/v2/f$i
>		mkdir v1/v2/d$i
>	done
> 	trinity -C 2 -N 100000 -V $D/t3/v1/v2 -q
> 	echo
> 	echo " done"
>	echo
>	sleep 4
> done
> 
> After a while I got :
> 
> $ sudo rm -rf /mnt/ramdisk/btrfs/t3/
> rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d63’:
> No space left on device
> rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/d10’:
> No space left on device
> rm: cannot remove ‘/mnt/ramdisk/btrfs/t3/v1/v2/f98’:
> No space left on device

[etc]

So where's the unexpected problem?

Btrfs is a COW-based (Copy On Write) filesystem, including metadata, 
which means to do an rm requires available space to write the new copy of 
the directory without the rmed file, before it deletes the existing copy 
of the directory that has the existing file you're trying to rm.

Apparently you filled all the space up, so there's no place to write that 
new copy of the directory, which means the rm fails.

If you had run the appropriate btrfs commands as suggested on the wiki
[1], namely the output from...

btrfs fi show /mnt/ramdisk/btrfs

and...

btrfs fi df /mnt/ramdisk/btrfs

..., then we'd have confirmation of the problem.  Presumably the show 
output will list the same value for total and used space on the device 
line, meaning all available space has been chunk-allocated, and the 
(btrfs) df output will list most of that as Data+Metadata (due to the 
mixed-bg chunk default because the filesystem is under 1 GiB in size, 
otherwise it'd be separate data and metadata chunks), DUP mode 
(duplicated so it'll hold less than half that due to the system and 
global-reserve reservations), again with total and used reasonably near 
equivalent.

FWIW, here's the output for my (NOT full) 256 MiB /bt (basically /boot, 
$>> is the last line of my prompt):

$>>sudo btrfs fi sh /bt
Label: 'bt0238gcn1+35l0'  uuid: d6539322-0834-4eeb-928d-a13eb32dcbb2
        Total devices 1 FS bytes used 67.06MiB
        devid    1 size 256.00MiB used 192.00MiB path /dev/sda3

Btrfs v3.17.3

$>>sudo btrfs fi df /bt
System, DUP: total=16.00MiB, used=4.00KiB
Data+Metadata, DUP: total=80.00MiB, used=67.06MiB
GlobalReserve, single: total=4.00MiB, used=0.00B

$>>

Total Chunk-allocation (from show): 192 MiB of 256 MiB used (so 64 MiB 
still unallocated).

Of that 192 MiB (from (btrfs) df):

System: 16 MiB (dup mode so double):

32 MiB

Data+Metadata: 80 MiB allocated (dup mode so doubled):

160 MiB

160+32=192 MiB allocated.

(The global reserve will probably show up as unknown on yours, given your 
older userspace with a new kernel.  That obviously isn't included in the 
total given in show.)

Of that 80 MiB data+metadata chunk allocation, 67.06 MiB is actually used 
by data and metadata (matching between show and df), so there's just 
under 13 MiB of free space in (each copy of the pair-copies of) the 
current mixed-mode chunks before another pair of data+metadata chunks 
must be allocated.

Yours will probably look much closer to something like this:

Show:

Total devices 1 FS bytes used 240 MiB
devid    1 size 257 MiB used 257 MiB

Df:

System, DUP: total=16.00MiB, Used=x.xxKiB
Data+Metadata, DUP: total=240.00MiB, Used=241.00MiB
Unknown: .....


IOW: All space chunk-allocated, all data/metadata chunk-space used.  No 
place to put the new copy of the directory table with that rm done, so it 
can't be written.

However, I've actually run into a corner-case occasionally here (when I 
redo my /boot, which I've not done for a couple kernels so with a bit of 
luck the bug is gone now) where there was still unallocated space that 
could be allocated to new chunks, but btrfs was for some reason failing 
to actually allocate those new chunks, and the existing chunks being 
full, I was getting ENOSPC.  It's /possible/ you're running into that bug 
as well.  In my case, I was able to copy over (from backup) certain 
(small) sized files but not others (bigger), and by trying different copy 
order, etc, I eventually got it to trigger a chunk-allocate which gave me 
the room to copy the others.  I'm not sure how you'd trigger the 
allocation if getting the ENOSPC on a rm, however.


How to get out of that bind?  Try /truncating/ one or more files.  This 
can often be done where a normal rm ENOSPCs, with a bit of luck and 
perhaps a few more file truncates, freeing enough space to do that rm 
properly.

echo > /path/to/file

The details are on the wiki (see the questions on space in the FAQ).  
Which I'd suggest you spend some time reading if you're going to be 
dealing with btrfs, as it'll answer a bunch of questions. As I said, an 
ENOSPC on file rm, when the filesystem is full, isn't entirely unusual or 
unexpected because btrfs is COW-based, and thus requires space to write 
the new copy when it changes something, including when it does a rm.  If 
you're entirely out of space, that rm will fail, and that's entirely 
expected.  The idea is not to run THAT close to out of space in the first 
place, and in the event that you do, knowing how to get out of the hole 
you dug yourself into, by using truncate or temporarily adding a device.  
It's on the wiki! =:^)

---
[1] Btrfs wiki home page, suitable for bookmarking or memorizing:

https://btrfs.wiki.kernel.org

What info to provide when asking a support question?  See the bottom 
section of the page here:

https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

