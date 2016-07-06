Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38104 "EHLO
	mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbcGFQF7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 12:05:59 -0400
Received: by mail-it0-f49.google.com with SMTP id h190so111292742ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 09:05:58 -0700 (PDT)
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, antonio@gnu.org
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
 <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
 <12d68c4e-5918-4ed0-9172-be7bd166c020@gmail.com>
 <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de>
Cc: linux-btrfs@vger.kernel.org, bug-tar@gnu.org, adilger@dilger.ca
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <418c9c5c-243c-5395-54c5-8b3975489bfc@gmail.com>
Date: Wed, 6 Jul 2016 12:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <577d2247.A15Oan9M/Ft3zama%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 11:22, Joerg Schilling wrote:
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>
>>> It should be obvious that a file that offers content also has allocated blocks.
>> What you mean then is that POSIX _implies_ that this is the case, but
>> does not say whether or not it is required.  There are all kinds of
>> counterexamples to this too, procfs is a POSIX compliant filesystem
>> (every POSIX certified system has it), yet does not display the behavior
>> that you expect, every single file in /proc for example reports 0 for
>> both st_blocks and st_size, and yet all of them very obviously have content.
>
> You are mistaken.
>
> stat /proc/$$/as
>   File: `/proc/6518/as'
>   Size: 2793472         Blocks: 5456       IO Block: 512    regular file
> Device: 5440000h/88342528d      Inode: 7557        Links: 1
> Access: (0600/-rw-------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
> Access: 2016-07-06 16:33:15.660224934 +0200
> Modify: 2016-07-06 16:33:15.660224934 +0200
> Change: 2016-07-06 16:33:15.660224934 +0200
>
> stat /proc/$$/auxv
>   File: `/proc/6518/auxv'
>   Size: 168             Blocks: 1          IO Block: 512    regular file
> Device: 5440000h/88342528d      Inode: 7568        Links: 1
> Access: (0400/-r--------)  Uid: (   xx/   joerg)   Gid: (  xx/      bs)
> Access: 2016-07-06 16:33:15.660224934 +0200
> Modify: 2016-07-06 16:33:15.660224934 +0200
> Change: 2016-07-06 16:33:15.660224934 +0200
>
> Any correct implementation of /proc returns the expected numbers in st_size as
> well as in st_blocks.
Odd, because I get 0 for both values on all the files in /proc/self and 
all the top level files on all kernels I tested prior to sending that 
e-mail, for reference, they include:
* A direct clone of HEAD on torvalds/linux
* 4.6.3 mainline
* 4.1.27 mainline
* 4.6.3 mainline with a small number of local patches on top
* 4.1.19+ from the Raspberry Pi foundation
* 4.4.6-gentoo (mainline with Gentoo patches on top)
* 4.5.5-linode69 (not certain about the patches on top)
It's probably notable that I don't see /proc/$PID/as on any of these 
systems, which implies you're running some significantly different 
kernel version to begin with, and therefore it's not unreasonable to 
assume that what you see is because of some misguided patch that got 
added to allow tar to archive /proc.
>
>> In all seriousness though, this started out because stuff wasn't cached
>> to anywhere near the degree it is today, and there was no such thing as
>> delayed allocation.  When you said to write, the filesystem allocated
>> the blocks, regardless of when it actually wrote the data.  IOW, the
>> behavior that GNU tar is relying on is an implementation detail, not an
>> API.  Just like df, this breaks under modern designs, not because they
>> chose to break it, but because it wasn't designed for use with such
>> implementations.
>
> This seems to be a strange interpretation if what a standard is.
Except what I'm talking about is the _interpretation_ of the standard, 
not the standard itself.  I said nothing about the standard, all it 
requires is that st_blocks be the number of 512 byte blocks allocated by 
the filesystem for the file.  There is nothing in there about it having 
to reflect the expected size of the allocated content on disk.  In fact, 
there's technically nothing in there about how to handle sparse files 
either.

To further explain what I'm trying to say, here's a rough description of 
what happens in SVR4 UFS (and other non-delayed allocation filesystems) 
when you issue a write:
1. The number of new blocks needed to fulfill the write request is 
calculated.
2. If this number is greater than 0, that many new blocks are allocated, 
and st_blocks for that file is functionally updated (I don't recall if 
it was dynamically calculated per call or not)
3. At some indeterminate point in the future, the decision is made to 
flush the cache.
4. The data is written to the appropriate place in the file.

By comparison, in a delayed allocation scenario, 3 happens before 1 and 
2.  1 and 2 obviously have to be strictly ordered WRT each other and 4, 
but based on the POSIX standard, 3 does not have to be strictly ordered 
with regards to any of them (although it is illogical to have it between 
1 and 2 or after 4).  Because it is not required by the standard to have 
3 be strictly ordered and the ordering isn't part of the API itself, 
where it happens in the sequence is an implementation detail.
>
>>> A new filesystem cannot introduce new rules just because people believe it would
>>> save time.
>> Saying the file has no blocks when there are no blocks allocated for it
>> is not to 'save time', it's absolutely accurate.  Suppose SVR4 UFS had a
>> way to pack file data into the inode if it was small enough.  In that
>> case, it woulod be perfectly reasonable to return 0 for st_blocks
>> because the inode table in UFS is a fixed pre-allocated structure, and
>
> Given that inode size is 128, such a change would not break things as the
> heuristics would not imply a sparse file here.
OK, so change the heuristic then so that there's a reasonable limit on 
small files, or better yet, just get rid of it, as it was introduced to 
save time itself.  The case it optimizes for (large sparse files) is 
mostly irrelevant, because you have to parse the file to figure out 
what's sparse anyway, and anyone who's dealing with completely sparse 
files has other potential issues to deal with (I'm actually curious if 
you know of some legitimate reason to copy a completely empty file in a 
backup anyway, they're almost always either pre-allocated but unused 
files which will just get reallocated by whatever allocated them in the 
first place, lock-files, or something similar in some other way). 
Regardless, the correct way on current Linux systems to determine file 
sparseness is SEEK_DATA and SEEK_HOLE.  You have to read any data that's 
there anyway, so alternating SEEK_DATA and SEEK_HOLE is necessary to 
find where the data is that you need to read.  If the first SEEK_HOLE 
returns the end of the file, then you know it's not sparse.
>
>> therefore nothing is allocated to the file itself except the inode.  The
>> same applies in the case of a file packed into it's own metadata block
>> on BTRFS, nothing is allocated to that file beyond the metadata block it
>> has to have to store the inode.  In the case of delayed allocation where
>> the file hasn't been flushed, there is nothing allocated, so st_blocks
>> based on a strict interpretation of it's description in POSIX _should_
>> be 0, because nothing is allocated yet.
>
> Now you know why BTRFS is still an incomplete filesystem. In a few years when
> it turns 10, this may change. People who implement filesystems of course need
> to learn that they need to hide implementation details from the official user
> space interfaces.
So in other words you think we should be lying about how much is 
actually allocated on disk and thus violating the standard directly (and 
yes, ext4 and everyone else who does this with delayed allocation _is_ 
strictly speaking violating the standard, because _nothing_ is allocated 
yet)?
