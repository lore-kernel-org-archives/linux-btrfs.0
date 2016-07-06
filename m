Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32935 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbcGFQoB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 12:44:01 -0400
Received: by mail-oi0-f47.google.com with SMTP id u201so277908033oie.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 09:44:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3ce663f-6df5-e662-f3c2-a11f44f46715@gmail.com>
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <ab23dea9-4fee-feef-cc7a-5f58cfd4067f@gmail.com>
 <7bad0370-ac01-2280-d8b1-e31b0ae9cffe@crc.id.au> <154fc0b3-8c39-eff6-48c9-5d2667e967b1@gmail.com>
 <31207cfc-245f-1b6e-4ef9-b8bf04b65e70@crc.id.au> <CAJCQCtTto04fz_=z0P0rBVX7sVqe1+LG-kbq7D1djXyB=tRdLQ@mail.gmail.com>
 <70f12c1b-8d30-c5f7-faa8-10a86a49c332@crc.id.au> <CAJCQCtR+S7mVSKiDSLOnJ+CjCwtmpj9w=pFDK_chHCqpcV-+Ww@mail.gmail.com>
 <a3ce663f-6df5-e662-f3c2-a11f44f46715@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 10:43:57 -0600
Message-ID: <CAJCQCtR9LqOAHYdyZ5zRJbS53hOuhTKR-7Pkkg_edPSx5UqqRw@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 5:51 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-05 19:05, Chris Murphy wrote:
>>
>> Related:
>> http://www.spinics.net/lists/raid/msg52880.html
>>
>> Looks like there is some traction to figuring out what to do about
>> this, whether it's a udev rule or something that happens in the kernel
>> itself. Pretty much the only hardware setup unaffected by this are
>> those with enterprise or NAS drives. Every configuration of a consumer
>> drive, single, linear/concat, and all software (mdadm, lvm, Btrfs)
>> RAID Levels are adversely affected by this.
>
> The thing I don't get about this is that while the per-device settings on a
> given system are policy, the default value is not, and should be expected to
> work correctly (but not necessarily optimally) on as many systems as
> possible, so any claim that this should be fixed in udev are bogus by the
> regular kernel rules.

Sure. But changing it in the kernel leads to what other consequences?
It fixes the problem under discussion but what problem will it
introduce? I think it's valid to explore this, at the least so
affected parties can be informed.

Also, the problem isn't instigated by Linux, rather by drive
manufacturers introducing a whole new kind of error recovery, with an
order of magnitude longer recovery time. Now probably most hardware in
the field are such drives. Even SSDs like my Samsung 840 EVO that
support SCT ERC have it disabled, therefore the top end recovery time
is undiscoverable in the device itself. Maybe it's buried in a spec.

So does it make sense to just set the default to 180? Or is there a
smarter way to do this? I don't know.


>> I suspect, but haven't tested, that ZFS On Linux would be equally
>> affected, unless they're completely reimplementing their own block
>> layer (?) So there are quite a few parties now negatively impacted by
>> the current default behavior.
>
> OTOH, I would not be surprised if the stance there is 'you get no support if
> your not using enterprise drives', not because of the project itself, but
> because it's ZFS.  Part of their minimum recommended hardware requirements
> is ECC RAM, so it wouldn't surprise me if enterprise storage devices are
> there too.

http://open-zfs.org/wiki/Hardware
"Consistent performance requires hard drives that support error
recovery control. "

"Drives that lack such functionality can be expected to have
arbitrarily high limits. Several minutes is not impossible. Drives
with this functionality typically default to 7 seconds. ZFS does not
currently adjust this setting on drives. However, it is advisable to
write a script to set the error recovery time to a low value, such as
0.1 seconds until ZFS is modified to control it. This must be done on
every boot. "

They do not explicitly require enterprise drives, but they clearly
expect SCT ERC enabled to some sane value.

At least for Btrfs and ZFS, the mkfs is in a position to know all
parameters for properly setting SCT ERC and the SCSI command timer for
every device. Maybe it could create the udev rule? Single and raid0
profiles need to permit long recoveries; where raid1, 5, 6 need to set
things for very short recoveries.

Possibly mdadm and lvm tools do the same thing.


-- 
Chris Murphy
