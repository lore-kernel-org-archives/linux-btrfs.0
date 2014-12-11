Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:57697 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbaLKKSO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 05:18:14 -0500
Message-ID: <54896F65.20708@pobox.com>
Date: Thu, 11 Dec 2014 02:18:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC after conversion [Was: Fixing Btrfs Filesystem Full Problems
 typo?]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
In-Reply-To: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So far I don't see a "bug".

On 12/11/2014 12:18 AM, Patrik Lundquist wrote:
> I'll reboot the thread with a recap and my latest findings.
>
> * Half full 3TB disk converted from ext4 to Btrfs, after first
> verifying it with fsck.
> * Undo subvolume deleted after being happy with the conversion.
> * Recursive defrag.
> * Full balance, that ended with "98 enospc errors during balance."

This is running out of space to allocate a disk extent. Not running out 
of space to allocate a file.

> In that order, nothing in between. No snapshots or other subvolumes.
> Loads of real free space.

Space for files is not space for extents.

> Btrfs check reports a clean filesystem.

So not a "bug", just out of raw space.

> Btrfs balance -musage=100 -dusage=99 works, but not -dusage=100.

Ibid.

> Conversion of metadata (~1.55 GiB) to DUP worked fine.

More evidence that things are fine.


> A theory, based on the error messages, is that some of the converted
> files, even after defrag, still have extents larger than 1GiB and
> hence don't fit in a native Btrfs extent.

You are conflating file extents with storage extents.

Here is a clean example:

Gust t # mkfs.btrfs -f /dev/loop0
Btrfs v3.17.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (2.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
fs created label (null) on /dev/loop0
         nodesize 16384 leafsize 16384 sectorsize 4096 size 2.00GiB
Gust t # mount /dev/loop0 /mnt/src
Gust t # btrfs balance start /mnt/src
Done, had to relocate 5 out of 5 chunks
Gust t # btrfs fi df /mnt/src
Data, single: total=208.00MiB, used=128.00KiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=104.00MiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
Gust t # dd if=/dev/urandom of=/mnt/src/scratch bs=1M count=40
40+0 records in
40+0 records out
41943040 bytes (42 MB) copied, 3.91674 s, 10.7 MB/s
Gust t # btrfs fi sync /mnt/src
FSSync '/mnt/src'
Gust t # btrfs fi df /mnt/src
Data, single: total=208.00MiB, used=40.12MiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=104.00MiB, used=160.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B


Notice this sequence...
brand new clean and balanced file system
Data, single: total=208.00MiB, used=128.00KiB

Created a 40Meg non-compressable non-empty file
Gust t # dd if=/dev/urandom of=/mnt/src/scratch bs=1M count=40

Flushed the file system to update the metadata and then I have
Data, single: total=208.00MiB, used=40.12MiB

The 40Meg of random data bytes didn't change the total data extent(s) 
allocated, it only changed the total amount of the allocated data 
extents that is in use.

> Running defrag several more times and balance again doesn't help.

That sounds correct as defrag defrags files, it does not reallocate 
extents.

> An error looks like:
> BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
> BTRFS: space_info 1 has 4773171200 free, is not full
> BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
> reserved=99700736, may_use=2102390784, readonly=241664

As explained in the other thread, the extent-tree.c extent allocator 
could not find 2013265920 contiguous bytes in order to make a new extent 
into which it would sort the old extent's file fragments.


> The following script returned 46 filenames (looking up the block group
> in the error):
> grep -B 1 "BTRFS error" /var/log/syslog | grep relocating | cut -d ' ' -f 14 | \
> while read block
> do
>      echo "Block group: $block"
>      btrfs inspect-internal logical-resolve $block /mnt
> done
>
> The files are ranging from 41KiB to 6.6GiB in size, which doesn't seem
> to support the theory of too large extents.

Sure it does, the 2013265920 _bytes_ of the extent in the error is 
bigger than some files in the extent (see 41KiB less than 2-ish gigs) 
but smaller than others files which reside only partly in the extent 
(see 6.6GiB greater than 2-ish gigs).

This is because data extents are not file specific, which is why there 
was more than one file in that extent.


> Moving the 46 files to another disk (no errors reported) and running
> balance again resulted in "64 enospc errors during balance" - down
> from 98 errors.

So by moving and deleting all the files in that extent reduced it to 
usage=0, and balance could then recover that space once it noticed it 
was empty.

There's a good chance that if you balanced again and again the number of 
no space errors might decrease. With only one 2-ish gig empty slot 
sliding around like one of those puzzles where you have to sort the 
numbers from 1 to 15 by sliding them around in the 4x4=16 element grid.


> Running the above script again gives this error for about half of the
> block groups:
> ioctl ret=-1, error: No such file or directory
>
> I had no such errors the first time I looked up block groups.

Because the first time the files were there and the second time they had 
been moved to a different disk and therefore deleted. Leaving little 
gaps with no file in them at all. Then the subsequent balance events may 
have moved other files into those locations and whatnot.


> What's the next step in zeroing in on the bug, before I start over?
> And I will start over.

The first step is admitting that you _don't_ have a problem.

You are out of raw space in which to construct new extents. This is not 
a "bug" this is a fact.

You are _not_ out of space in which to create files. (or so I presume, 
you still haven't posted the output of /bin/df or btrfs filesystem df).

You are confusing ext4 "file extents" with btrfs storage extents. A 
btrfs storage extent is analogous to the non-inode portion of an ext4 
"block group".

EXT4 allocates fixed size block groups with a ratio of inode-space to 
data-space.

BTRFS allocates data-space (for data) and metadata-space (for inodes, 
the data for very small files, chcksums, and overhead that the system 
may need because the whole file system wasn't pre-carved up 
geographically like with EXT4.)

Your next step is to either add storage in accordance with your plan of 
adding four more volumes to make a RAID (as expressed elsewhere), or 
make a clean filesystem and copy your files over.

Both options are equal give or take things like any desire to use skinny 
metadata, compression, or other advanced options that may only be 
available at file or filesystem creation time.


