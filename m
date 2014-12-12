Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:59603 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbaLLAgJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 19:36:09 -0500
Message-ID: <548A3873.4060407@pobox.com>
Date: Thu, 11 Dec 2014 16:36:03 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC after conversion [Was: Fixing Btrfs Filesystem Full Problems
 typo?]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>	<54896F65.20708@pobox.com> <CAA7pwKNTS770TZ9ENxMMQA9-50tfrr2aRb5BWJRFheVy9NOWtQ@mail.gmail.com>
In-Reply-To: <CAA7pwKNTS770TZ9ENxMMQA9-50tfrr2aRb5BWJRFheVy9NOWtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 03:01 PM, Patrik Lundquist wrote:
> On 11 December 2014 at 11:18, Robert White <rwhite@pobox.com> wrote:
>> So far I don't see a "bug".
>
> Fair enough, lets call it a huge problem with btrfs convert. I think
> it warrants a note in the wiki.
>
>
>> On 12/11/2014 12:18 AM, Patrik Lundquist wrote:
>>>
>>> Running defrag several more times and balance again doesn't help.
>>
>> That sounds correct as defrag defrags files, it does not reallocate extents.
>
>>From https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>
> "A notable caveat is that a balance can fail with "ENOSPC" if the
> defragment is skipped. This is usually due to large extents on ext
> being larger than the maximum size btrfs normally operates with (1
> GB). A defrag of all large files will avoid this:"
>
> I interpreted it as breaking down large extents and reallocating them,
> thus avoiding my current situation.
>
>
>> There's a good chance that if you balanced again and again the number of no
>> space errors might decrease. With only one 2-ish gig empty slot sliding
>> around like one of those puzzles where you have to sort the numbers from 1
>> to 15 by sliding them around in the 4x4=16 element grid.
>
> I was never fond of those puzzles.
>
>
>> The first step is admitting that you _don't_ have a problem.
>
> I've got 99 problems and balance is one of them (the other are block
> groups). :-)
>
> Of course the filesystem is in a problematic state after the
> conversion, even if it's not a bug. ~1.5TB of free space and yet out
> of space and it can't be fixed with a balance. It might not be wrong
> per se but it's very problematic from a user perspective.
>
> Anyway, this thread has turned up lots of good information.
>
>
>> You are _not_ out of space in which to create files. (or so I presume, you
>> still haven't posted the output of /bin/df or btrfs filesystem df).
>
> I'm not; creating new files works.

Exactly!

I know you are not, thats why the DF below doesn't say you are out of 
space. You have 1526389096 one-K blocks available on the drive for file 
storage.

You just don't have enough _contiguous_ unallocated _raw_ storage to 
copy a 2-gig-ish extent.

Until you "get" this idea you are not going to understand what is happening.

When you make an EXT4/3/2 file system it goes out and allocates _all_ 
_the_ _space_ to the file system's structures. It goes out and writes 
block groups where all the block groups go, with zero-ed out allocation 
bitmaps and zeroed-out inodes. (Actually the kernel does most of that 
work on "first mount" in the modern cases, which is way a mkfs.ext4 
takes _way_ _less_ _time_ than an mkfs.ext2 on the same expanse of disk).

BTRFS, on the other hand, does something _completely_ _different_. It 
just writes a few things. One is the superblock(s) [up to three per 
physical disk,depending on media size]. One is the metadata chunk(s) 
that contain those blocks. One is the raw space storage tree. And so on. 
It never _touches_ the bulk of the disk(s).

As you fill your metadata and data extents, the raw storage manager 
makes new ones on-demand. This requires space from the "raw storage".

In EXT4 speak it would be like if EXT4 only wrote the _first_ block 
group and then only added the second block group once the first was 
filled. Then a third when the second and first were both filled.

There will come a point when BTRFS has allocated _all_ the raw storage. 
And at that point it will fail to allocate new storage for block groups 
because there is no more raw storage. At that moment, the BTRFS 
filesystem is "just like" the freshly built EXT4 in that 100% of the raw 
storage has "initialized file system bits" written on it.

Recent kernel patches have added a feature to BTRFS that says "if this 
file system bit is completely empty, lets de-initialize it and return it 
to the raw pool". This was added because one could fill ones file system 
with "large files" (and so data extents) then delete all those and fill 
the same space wiht tiny files (and so need metadata extents). If there 
was no way to "remove the empty data extent" so that it could be 
replaced by one or more metadata extents, you could end up in the very 
same jam you can end up wiht in EXT4, which is running out of inodes 
when you've got plenty of "storage space".

So BTRFS has this give-and-take. But when it comes to "relocating" 
something, as in "balancing it", you have to be able to make the new 
space before you can move the files over and remove the old space. 
That's the core idea behind Copy On Write. In COW there is no "move" 
operation for storage. You have only "copy" and "delete".

So when the raw storage pool gets full you run out of space to make more 
BTRFS. When the allocated storage space gets full, you run out of space 
to make files.

Its unlike other filesystems. Every byte is allocated twice. First it 
has to be allocated to the file system, then the file system has to 
allocate it to the individual files.

This double layer makes it more adaptable as described above.

So Is There A Precedent?

Yes.

ITEM: A normal program running in a system has an address space (on a 
32-bit linux box this is typically 2G for code, and 2G for data). No 
matter how "big" the program is, it gets the same 4G of "space" in its 
virtual memory map. That is, the map is _capable_ _of_ containing 4G in 
tww 2G regions. This map is assembled by the kernel when it calls exec, 
and it is assembled _before_ the code of the program is even read off 
the disk.

This is very like what happens in a mkfs.btrfs. We point it at a region 
of disk and it builds the _ability_ to make the map by setting up the 
minimal necessary structures needed to maintain the map that will be built.

ITEM: The kernel then loads the core executable into the start of the 2G 
space by using mmap(). But because of dynamic linking, this load may 
bring in lots of other files, each will take up some of that 2G of code 
space. Many will take up some of the 2G of data space since most code 
requires data.

This is like how BTRFS makes the first extents for data and whtnot.

ITEM: As the program runs it may dynamically load even more code (like 
say loading the flash player extension into your web browser when you go 
to a site that has some stupid advert or movie); but what it's really 
going to start doing is using the data area. You want to look at that 
picture of that kitten, you are going to need to take a chunk out of 
that 2G of data and "realize it", that is access after doing an 
anynonymous mmap() or just make your effective amount of "ram in use" 
bigger with setbrk().

This is like how BTRFS allocates metadata (analogous to code space) and 
data space extents.

ITEM: If you go to another page with a picture of a puppy instead of a 
kitten, the space for the kitten picture has been freed up and if the 
puppy picture can fit there then no additional mmap() or setbrk() calls 
need to be made. This sort of thing is normally dealt-with/controlled at 
the deepest level by the memory allocation library. I don't have to know 
when setbrk() or mmap() is being called for this data memory, I just 
call malloc() when I need more and free() when I am done with something 
I got from malloc(). Under the hood there are linked list structures, 
and trees, and bitmaps for small allocations too small to be worth 
calling setbrk() for each one. etc.

This is normal runtime behavior for BTRFS. It serves up already 
controlled bits when it can, and it goes out and allocates and 
initialized more when the need arises.

This all happens under the hood, and normally the only way you'd ever 
see an out of space error ("ENOSPC") is if you asked for a bit and it 
didn't have the right kind of space, so it went to allocate more space 
on the disk and that failed as well.

In the same sense a program could fill up its 2G for data, and still 
have nearly 2G available for code, but its the wrong kind of space, so a 
malloc would return "out of memory".

==== SO WTF HERE THEN, AM I RIGHT? ====

EXT4 had already allocated all the raw space and decided what kind of 
storage each segment was for.

You ran btrfs-convert, and it went in and adopted all those spaces for 
all those purposes. Then it did "what it could" to free up as much of 
that allocated space as was possible.

Since your EXT4 file system had been full-to-busting at least once in 
the past, there was very little the convert program to could to free up 
those data extents because on the average the now half-empty file system 
consisted of "all the data extents, each half empty at best".

If you original EXT4 image had been less something-is-everywhere, the 
convert process, and the balance process thereafter, would have had more 
raw space to do the "sliding block puzzle" that is a balance operation.

By adding another storage volume (disk/partition/etc) you would be 
giving it that room.

Where the EXT4/3/2 raw storage map looks like a fully built brick wall 
made with fixed sized bricks, a BTRFS raw storage layout looks like a 
sliding block puzzle.

To really understand what balance is trying to do, play this game for a 
while

   http://www.agame.com/game/sliding-block-puzzle

Only imagine that each block had to be copied to the new location before 
it could be removed from the old one. And keep in mind that the little 
blocks are the metadata, the medium blocks are partly full data blocks, 
and the big blocks are the giant 2-gig-ish extents crammed full of files 
that you were asking balance to juggle around.


>
> $ df
> Filesystem      1K-blocks       Used  Available Use% Mounted on
> /dev/sdc1      2930265088 1402223656 1526389096  48% /mnt

See, there's your space.

It's not "lost" its just not on hand in 2Gig contiguous chunks that 
balance can copy around. Chances are there a good number of 1 gig chunks 
for future data, and lots more 256M chunks for future metadata (and the 
small files that fit wholly therein).

Nothing broken here. No "mising space" just a sliding block puzzle with 
no current solution that would be easily solvable if more raw space was 
available.

>
> $ btrfs fi df /mnt
> Data, single: total=1.41TiB, used=1.30TiB
> System, DUP: total=32.00MiB, used=124.00KiB
> Metadata, DUP: total=2.50GiB, used=1.49GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
>> Your next step is to either add storage in accordance with your plan of
>> adding four more volumes to make a RAID (as expressed elsewhere), or make a
>> clean filesystem and copy your files over.
>
> I've already decided to start over with a clean filesystem to get rid
> of the ext4 legacy. I'm only curious about how to solve the balance
> problem, and now I know how.

You solve the balance problem by adding enough working space for it to 
proceed, or by removing enough files that it can coalesce enough to 
delete a few of those big extents, thus providing enough working space 
to proceed.


