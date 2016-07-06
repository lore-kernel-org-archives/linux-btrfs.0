Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33265 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFSpW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:45:22 -0400
Received: by mail-oi0-f41.google.com with SMTP id u201so282532062oie.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:45:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3a233116-6954-2071-f272-72cf84a0c35c@gmail.com>
References: <576CB0DA.6030409@gmail.com> <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au> <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au> <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
 <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au> <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
 <a3ce663f-6df5-e662-f3c2-a11f44f46715@gmail.com> <CAJCQCtR9LqOAHYdyZ5zRJbS53hOuhTKR-7Pkkg_edPSx5UqqRw@mail.gmail.com>
 <3a233116-6954-2071-f272-72cf84a0c35c@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 12:45:18 -0600
Message-ID: <CAJCQCtSpMwksiB=219xg0PVPX=9Qjz4D=T3_Ky3pea5-zN5ejQ@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 11:18 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-06 12:43, Chris Murphy wrote:

>> So does it make sense to just set the default to 180? Or is there a
>> smarter way to do this? I don't know.
>
> Just thinking about this:
> 1. People who are setting this somewhere will be functionally unaffected.

I think it's statistically 0 people changing this from default. It's
people with drives that have no SCT ERC support, used in raid1+, who
happen to stumble upon this very obscure work around to avoid link
resets in the face of media defects. Rare.


> 2. People using single disks which have lots of errors may or may not see an
> apparent degradation of performance, but will likely have the life
> expectancy of their device extended.

Well they have link resets and their file system presumably face
plants as a result of a pile of commands in the queue returning as
unsuccessful. So they have premature death of their system, rather
than it getting sluggish. This is a long standing indicator on Windows
to just reinstall the OS and restore data from backups -> the user has
an opportunity to freshen up user data backup, and the reinstallation
and restore from backup results in freshly written sectors which is
how bad sectors get fixed. The marginally bad sectors get new writes
and now read fast (or fast enough), and the persistently bad sectors
result in the drive firmware remapping to reserve sectors.

The main thing in my opinion is less extension of drive life, as it is
the user gets to use the system, albeit sluggish, to make a backup of
their data rather than possibly losing it.


> 3. Individuals who are not setting this but should be will on average be no
> worse off than before other than seeing a bigger performance hit on a disk
> error.
> 4. People with single disks which are new will see no functional change
> until the disk has an error.

I follow.


>
> In an ideal situation, what I'd want to see is:
> 1. If the device supports SCT ERC, set scsi_command_timer to  reasonable
> percentage over that (probably something like 25%, which would give roughly
> 10 seconds for the normal 7 second ERC timer).
> 2. If the device is actually a SCSI device, keep the 30 second timer (IIRC<
> this is reasonable for SCSI disks).
> 3. Otherwise, set the timer to 200 (we need a slight buffer over the
> expected disk timeout to account for things like latency outside of the
> disk).

Well if it's a non-redundant configuration, you'd want those long
recoveries permitted, rather than enable SCT ERC. The drive has the
ability to relocate sector data on a marginal (slow) read that's still
successful. But clearly many manufacturers tolerate slow reads that
don't result in immediate reallocation or overwrite or we wouldn't be
in this situation in the first place. I think this auto reallocation
is thwarted by enabling SCT ERC. It just flat out gives up and reports
a read error. So it is still data loss in the non-redundant
configuration and thus not an improvement.

Basically it's:

For SATA and USB drives:

if data redundant, then enable short SCT ERC time if supported, if not
supported then extend SCSI command timer to 200;

if data not redundant, then disable SCT ERC if supported, and extend
SCSI command timer to 200.

For SCSI (SAS most likely these days), keep things the same as now.
But that's only because this is a rare enough configuration now I
don't know if we really know the problems there. It may be that their
error recovery in 7 seconds is massively better and more reliable than
consumer drives over 180 seconds.




>
>>
>>
>>>> I suspect, but haven't tested, that ZFS On Linux would be equally
>>>> affected, unless they're completely reimplementing their own block
>>>> layer (?) So there are quite a few parties now negatively impacted by
>>>> the current default behavior.
>>>
>>>
>>> OTOH, I would not be surprised if the stance there is 'you get no support
>>> if
>>> your not using enterprise drives', not because of the project itself, but
>>> because it's ZFS.  Part of their minimum recommended hardware
>>> requirements
>>> is ECC RAM, so it wouldn't surprise me if enterprise storage devices are
>>> there too.
>>
>>
>> http://open-zfs.org/wiki/Hardware
>> "Consistent performance requires hard drives that support error
>> recovery control. "
>>
>> "Drives that lack such functionality can be expected to have
>> arbitrarily high limits. Several minutes is not impossible. Drives
>> with this functionality typically default to 7 seconds. ZFS does not
>> currently adjust this setting on drives. However, it is advisable to
>> write a script to set the error recovery time to a low value, such as
>> 0.1 seconds until ZFS is modified to control it. This must be done on
>> every boot. "
>>
>> They do not explicitly require enterprise drives, but they clearly
>> expect SCT ERC enabled to some sane value.
>>
>> At least for Btrfs and ZFS, the mkfs is in a position to know all
>> parameters for properly setting SCT ERC and the SCSI command timer for
>> every device. Maybe it could create the udev rule? Single and raid0
>> profiles need to permit long recoveries; where raid1, 5, 6 need to set
>> things for very short recoveries.
>>
>> Possibly mdadm and lvm tools do the same thing.
>
> I"m pretty certain they don't create rules, or even try to check the drive
> for SCT ERC support.

They don't. That's a suggested change in behavior. Sorry "should do
the same thing" instead of "do the same thing".


> The problem with doing this is that you can't be
> certain that your underlying device is actually a physical storage device or
> not, and thus you have to check more than just the SCT ERC commands, and
> many people (myself included) don't like tools doing things that modify the
> persistent functioning of their system that the tool itself is not intended
> to do (and messing with block layer settings falls into that category for a
> mkfs tool).

Yep it's imperfect unless there's the proper cross communication
between layers. There are some such things like hardware raid geometry
that optionally poke through (when supported by hardware raid drivers)
so that things like mkfs.xfs can automatically provide the right sunit
swidth for optimized layout; which the device mapper already does
automatically. So it could be done it's just a matter of how big of a
problem is this to build it, vs just going with a new one size fits
all default command timer?

If it were always 200 instead of 30, the consequence is if there's a
link problem that is not related to media errors. But what the hell
takes that long to report an explicit error? Even cable problems
generate UDMA errors pretty much instantly.


-- 
Chris Murphy
