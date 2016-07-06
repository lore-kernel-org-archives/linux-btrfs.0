Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34934 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbcGFVDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 17:03:00 -0400
Received: by mail-oi0-f51.google.com with SMTP id r2so287987909oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 14:01:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <07c35af5-5780-3659-48cc-63bff79548a4@gmail.com>
References: <576CB0DA.6030409@gmail.com> <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au> <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au> <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
 <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au> <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
 <a3ce663f-6df5-e662-f3c2-a11f44f46715@gmail.com> <CAJCQCtR9LqOAHYdyZ5zRJbS53hOuhTKR-7Pkkg_edPSx5UqqRw@mail.gmail.com>
 <3a233116-6954-2071-f272-72cf84a0c35c@gmail.com> <CAJCQCtSpMwksiB=219xg0PVPX=9Qjz4D=T3_Ky3pea5-zN5ejQ@mail.gmail.com>
 <07c35af5-5780-3659-48cc-63bff79548a4@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 15:01:49 -0600
Message-ID: <CAJCQCtTGUQxkOf7VhGS--APJ45BsyuduzqDJcGOM5ihSC3L50w@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 1:15 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-06 14:45, Chris Murphy wrote:

>> I think it's statistically 0 people changing this from default. It's
>> people with drives that have no SCT ERC support, used in raid1+, who
>> happen to stumble upon this very obscure work around to avoid link
>> resets in the face of media defects. Rare.
>
> Not as much as you think, once someone has this issue, they usually put
> preventative measures in place on any system where it applies.  I'd be
> willing to bet that most sysadmins at big companies like RedHat or Oracle
> are setting this.

SCT ERC yes. Changing the kernel's command timer? I think almost zero.



>> Well they have link resets and their file system presumably face
>> plants as a result of a pile of commands in the queue returning as
>> unsuccessful. So they have premature death of their system, rather
>> than it getting sluggish. This is a long standing indicator on Windows
>> to just reinstall the OS and restore data from backups -> the user has
>> an opportunity to freshen up user data backup, and the reinstallation
>> and restore from backup results in freshly written sectors which is
>> how bad sectors get fixed. The marginally bad sectors get new writes
>> and now read fast (or fast enough), and the persistently bad sectors
>> result in the drive firmware remapping to reserve sectors.
>>
>> The main thing in my opinion is less extension of drive life, as it is
>> the user gets to use the system, albeit sluggish, to make a backup of
>> their data rather than possibly losing it.
>
> The extension of the drive's lifetime is a nice benefit, but not what my
> point was here.  For people in this particular case, it will almost
> certainly only make things better (although at first it may make performance
> worse).

I'm not sure why it makes performance worse. The options are, slower
reads vs a file system that almost certainly face plants upon a link
reset.




>> Basically it's:
>>
>> For SATA and USB drives:
>>
>> if data redundant, then enable short SCT ERC time if supported, if not
>> supported then extend SCSI command timer to 200;
>>
>> if data not redundant, then disable SCT ERC if supported, and extend
>> SCSI command timer to 200.
>>
>> For SCSI (SAS most likely these days), keep things the same as now.
>> But that's only because this is a rare enough configuration now I
>> don't know if we really know the problems there. It may be that their
>> error recovery in 7 seconds is massively better and more reliable than
>> consumer drives over 180 seconds.
>
> I don't see why you would think this is not common.

I was not clear. Single device SAS is probably not common. They're
typically being used in arrays where data is redundant. Using such a
drive with short error recovery as a single boot drive? Probably not
that common.



> Separately, USB gets _really_ complicated if you want to cover everything,
> USB drives may or may not present as non-rotational, may or may not show up
> as SATA or SCSI bridges (there are some of the more expensive flash drives
> that actually use SSD controllers plus USB-SAT chips internally), if they do
> show up as such, may or may not support the required commands (most don't,
> but it's seemingly hit or miss which do).

Yup. Well, do what we can instead of just ignoring the problem? They
can still be polled for features including SCT ERC and if it's not
supported or configurable then fallback to increasing the command
timer. I'm not sure what else can be done anyway.

The main obstacle is squaring the device capability (low level) with
storage stack redundancy 0 or 1 (high level). Something has to be
aware of both to ideally get all devices ideally configured.



>> Yep it's imperfect unless there's the proper cross communication
>> between layers. There are some such things like hardware raid geometry
>> that optionally poke through (when supported by hardware raid drivers)
>> so that things like mkfs.xfs can automatically provide the right sunit
>> swidth for optimized layout; which the device mapper already does
>> automatically. So it could be done it's just a matter of how big of a
>> problem is this to build it, vs just going with a new one size fits
>> all default command timer?
>
> The other problem though is that the existing things pass through
> _read-only_ data, while this requires writable data to be passed through,
> which leads to all kinds of complicated issues potentially.

I'm aware. There are also plenty of bugs even if write were to pass
through. I've encountered more drives than not which accept only one
SCT ERC change per poweron. A 2nd change causes the drive to offline
and vanish off the bus. So no doubt this whole area is fragile enough
not even the drive, controller, enclosure vendors are aware of where
all the bodies are buried.

What I think is fairly well established is that at least on Windows
their lower level stuff including kernel tolerates these very high
recovery times. The OS just gets irritatingly slow but doesn't flip
out. Linux is flipping out. And it's not Linux's direct fault, that's
drive manufacturers, but Linux needs to adapt.



>>
>>
>> If it were always 200 instead of 30, the consequence is if there's a
>> link problem that is not related to media errors. But what the hell
>> takes that long to report an explicit error? Even cable problems
>> generate UDMA errors pretty much instantly.
>
> And that is more why I'd suggest changing the kernel default first before
> trying to use special heuristics or anything like that.  The caveat is that
> it would need to be for ATA disks only to not break SCSI (which works fine
> right now) and USB (which has it's own unique issues).


I think you're probably right. Simpler is better.

Thing is, there will be consequences. In the software raid case where
a drive hangs on a media defect, right now this means a link reset at
30 seconds, which results in md reconstructing data and it goes where
needed by pretty much 31 seconds after requested. If that changes to
180 seconds, there will no doubt be some use cases that will be, WTF
just happened? This used to always recover in 30 seconds at the
longest, and now it's causing the network stack to implode while
waiting.

So all kinds of other timeouts might get impacted.

I wonder if it makes sense to change the default SCSI command timer on
a distribution and see what happens - if e.g. Fedora or opensuse would
volunteer to make the change for Rawhide or Tumbleweed. *shrug*
statically the number of users for those rolling releases may not have
a drive with media defects and a delay intolerant workload for maybe
years...


-- 
Chris Murphy
