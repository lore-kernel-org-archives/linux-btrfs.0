Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:60431 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbaLJMRw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 07:17:52 -0500
Message-ID: <548839EE.6080404@pobox.com>
Date: Wed, 10 Dec 2014 04:17:50 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>	<54878210.8030807@pobox.com> <CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
In-Reply-To: <CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 11:19 PM, Patrik Lundquist wrote:
> On 10 December 2014 at 00:13, Robert White <rwhite@pobox.com> wrote:
>> On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
>>>
>>> Label: none  uuid: 770fe01d-6a45-42b9-912e-e8f8b413f6a4
>>>       Total devices 1 FS bytes used 1.35TiB
>>>       devid    1 size 2.73TiB used 1.36TiB path /dev/sdc1
>>>
>>>
>>> Data, single: total=1.35TiB, used=1.35TiB
>>> System, single: total=32.00MiB, used=112.00KiB
>>> Metadata, single: total=3.00GiB, used=1.55GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> Are you trying to convert a filesystem on a single device/partition to RAID
>> 1?
>
> Not yet. I'm stuck at the full balance after the conversion from ext4.
> I haven't added the disks for RAID1 and might need them for starting
> over instead.

You are not "stuck" here as this step is not mandatory. (see below)

>
> A balance with -musage=100 -dusage=99 works but a full fails. It would
> be nice to nail the bug since the fs passes btrfs check and it seems
> to be a clear ENOSPC bug.

Conversion from ext2/3/4 is constrained because it needs to be reversible.

If you are out of space this isn't a "bug", you are just out of space. 
So by telling the system to ignore the 100% full clusters it is free to 
juggle the fragments. But once you get into moving the fully full 
extents the COW features _MUST_ have access to _contiguous_ 1Gib blocks 
to make the new extents int which the Copy will be Written. If your file 
system was nearly full it's completely likely that there are no such 
contiguous blocks available to make the necessary extents.

BUT FIRST UNDERSTAND: you do _not_ need to balance a newly converted 
filesystem. That is, the recommended balance (and recursive defrag) is 
_not_ a useability issue, its an efficiency issue.

Check what you've got. Make sure it is good. Make sure you are cool with 
it all. When you know everything is usable then remove the undo 
information snapshot. That snapshot is pinning a _lot_ of data into 
exact positions on disk. It's memorializing your previous fragmentation 
and the anniversary positions of all the EXT4 data structures. Since 
your system is basically full that undo information has to go.

At that point your balance will probably have the room it needs.

_Then_ you can balance if you feel the desire.

If you are _still_ out of space you'll need to add some, at least 
temporarily, to give the system enough room to work.

Since we all _know_ you are a dilligent system administrator and 
architect with a good, recent, and well tested backup we know we can 
recommend that you just dump the undo partition with a nice btrfs subvol 
delete, right? Because you made a backup and everything yes?

So anyway. Your system isn't "bugged" or "broken" it's "full" but its a 
fragmented fullness that has lots of free sectors but insufficent 
contiguous free sectors, so it cannot satisfy the request.

That Said...

I suspect you _have_ revealed a problem with the error reporting in the 
case of "scary and wrong error message".

The allocator in extent-tree.c just tells you the raw free space on the 
disk and says "hua... there are lots of bytes out there".

Which is _WAY_ different than "there are enough bytes all in one clump 
to satisfy my needs. E.g. there is _not_ a lot of brains behind the message.


         ret = find_free_extent(root, num_bytes, empty_size, hint_byte, ins,
                                flags, delalloc);

         if (ret == -ENOSPC) {
                 if (!final_tried && ins->offset) {
                         num_bytes = min(num_bytes >> 1, ins->offset);
                         num_bytes = round_down(num_bytes, 
root->sectorsize);
                         num_bytes = max(num_bytes, min_alloc_size);
                         if (num_bytes == min_alloc_size)
                                 final_tried = true;
                         goto again;
                 } else if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
                         struct btrfs_space_info *sinfo;

                         sinfo = __find_space_info(root->fs_info, flags);
                         btrfs_err(root->fs_info, "allocation failed 
flags %llu, wanted %llu",
                                 flags, num_bytes);
                         if (sinfo)
                                 dump_space_info(sinfo, num_bytes, 1);
                 }
         }



>
>
> I don't know how to interpret the space_info error. Why is only
> 4773171200 (4,4GiB) free?
> Can I inspect block group 1821099687936 to try to find out what makes
> it problematic?
>
> BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
> BTRFS: space_info 1 has 4773171200 free, is not full
> BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
> reserved=99700736, may_use=2102390784, readonly=241664

So it was looking for a single chunk 2013265920 bytes long and it 
couldn't find one because all the spaces were smaller and there was no 
room to make a new suitable space.

The problem is that it wanted 2013265920 bytes and while the system as a 
whole had no way to satisfy that desire. It asked for something just shy 
of two gigs as a single extent. That's a tough order on a full platter.

Since your entire free size is 2102390784 that is an attempt to allocate 
about 80% of your free space as one contiguous block. That's never going 
to happen. 8-)

I don't even know if 2GiB is normally a legal size for an extent. My 
understanding is that data is allocated in 1G chunks, so I'd expect all 
extents to be smaller than 1G.

Normally...

But... I would bet that this 2gig monster is the image file, or part 
thereof, that btrfs-convert left behind, and it may well be a magical 
allocation of some sort. It may even be beyond the reach of balance et 
al for being so large. But it _is_ within the bounds of the byte offests 
and sizes the file system uses.

After a quick glance at the btrfs-convert, it looks like it might make 
some pretty atypical extents if the underlying donor filesystem needed 
needed them. It wouldn't have had a choice. So it's easily within the 
realm of reason that you'd have some really fascinating data as a result 
of converting a nearly full EXT4 file system of the Terabyte+ size. This 
would be quadruply true if you'd tweaked the block group ratios when you 
made the original file system.

So since you have nice backups... you should probably drop the 
ext2_saved subvolume and then get on with your life for good or ill.

But its do or undo time.

AND UNDO IS NOT A BAD OPTION.

If you've got the media, building a fresh filesystem and copying the 
contents onto it is my preferred method anyway. I get to set the options 
I want (compression, skinny metadata, whatever) and I know I've got a 
good backup on the original media. It's also the perfectly natural way 
to get the subvolume boundaries where I want them and all that stuff.

Think of the time and worry you'd have saved if you'd copied the thing 
in the first place. 8-)

So anyway...

Probably fine.
Probably just very full filesystem.
Clearly got some big whale files that just won't balance due to space.
Probably those files are the leftover EXT4 structures.
Probably okay to revert.
Probably okay to just delete the revert info.
The prior two items are mutually exclusive.

Since you have nice and validated backups you can't go wrong either way.

>
>> P.S. you should re-balance your System and Metadata as "DUP" for now. Two
>> copies of that stuff is better than one as right now you have no real
>> recovery path for that stuff. If you didn't make that change on purpose it
>> probably got down-revved from DUP automagically when you tired to RAID it.
>
> Good point. Maybe btrfs-convert should do that by default? I don't
> think it has ever been DUP.

Eyup.

