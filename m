Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:32985 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbcF1CjY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 22:39:24 -0400
Received: by mail-oi0-f44.google.com with SMTP id u201so4646356oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 19:39:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628015245.GI14667@hungrycats.org>
References: <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org> <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
 <20160628015245.GI14667@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 20:39:21 -0600
Message-ID: <CAJCQCtTQTo7JRBuWgTWZ=T+EA5P-uRLjoiknTzv9gwy4Z290XQ@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 7:52 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Jun 27, 2016 at 04:30:23PM -0600, Chris Murphy wrote:
>> On Mon, Jun 27, 2016 at 3:57 PM, Zygo Blaxell
>> <ce3g8jdj@umail.furryterror.org> wrote:
>> > On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
>> > If anything, I want the timeout to be shorter so that upper layers with
>> > redundancy can get an EIO and initiate repair promptly, and admins can
>> > get notified to evict chronic offenders from their drive slots, without
>> > having to pay extra for hard disk firmware with that feature.
>>
>> The drive totally thwarts this. It doesn't report back to the kernel
>> what command is hung, as far as I'm aware. It just hangs and goes into
>> a so called "deep recovery" there is no way to know what sector is
>> causing the problem
>
> I'm proposing just treat the link reset _as_ an EIO, unless transparent
> link resets are required for link speed negotiation or something.

That's not one EIO, that's possibly 31 items in the command queue that
get knocked over when the link is reset. I don't have the expertise to
know whether it's sane to interpret many EIO all at once as an
implicit indication of bad sectors. Off hand I think that's probably
specious.

> The drive wouldn't be thwarting anything, the host would just ignore it
> (unless the drive doesn't respond to a link reset until after its internal
> timeout, in which case nothing is saved by shortening the timeout).
>
>> until the drive reports a read error, which will
>> include the affected sector LBA.
>
> It doesn't matter which sector.  Chances are good that it was more than
> one of the outstanding requested sectors anyway.  Rewrite them all.

*shrug* even if valid, it only helps the raid 1+ cases. It does
nothing to help raid0, linear/concat, or single device deployments.
Those users also deserve to have access to their data, if the drive
can recover it by giving it enough time to do so.


> We know which sectors they are because somebody has an IO operation
> waiting for a status on each of them (unless they're using AIO or some
> other API where a request can be fired at a hard drive and the reply
> discarded).  Notify all of them that their IO failed and move on.

Dunno, maybe.


>
>> Btrfs does have something of a work around for when things get slow,
>> and that's balance, read and rewrite everything. The write forces
>> sector remapping by the drive firmware for bad sectors.
>
> It's a crude form of "resilvering" as ZFS calls it.

In what manner is it crude?




> If btrfs sees EIO from a lower block layer it will try to reconstruct the
> missing data (but not repair it).  If that happens during a scrub,
> it will also attempt to rewrite the missing data over the original
> offending sectors.  This happens every few months in my server pool,
> and seems to be working even on btrfs raid5.
>
> Last time I checked all the RAID implementations on Linux (ok, so that's
> pretty much just md-raid) had some sort of repair capability.

You can read man 4 md, and you can also look on linux-raid@, it's very
clearly necessary for the drive to report a read or write error
explicitly with LBA for md to do repairs. If there are link resets,
bad sectors accumulate and the obvious inevitably happens.



>
>> For single drives and RAID 0, the only possible solution is to not do
>> link resets for up to 3 minutes and hope the drive returns the single
>> copy of data.
>
> So perhaps the timeout should be influenced by higher layers, e.g. if a
> disk becomes part of a raid1, its timeout should be shortened by default,
> while a timeout for a disk that is not used in by redundant layer should
> be longer.

And there are a pile of reasons why link resets are necessary that
have nothing to do with bad sectors. So if you end up with a drive or
controller misbehaving and the new behavior is to force a bunch of new
(corrective) writes to the drive right after a reset it could actually
make its problems worse for all we know.

I think it's highly speculative to assume hung block devices means bad
sector and should be treated as a bad sector, and that doing so will
cause no other side effects. That's a question for block device/SCSI
experts to opine on whether this is at all sane to do. I'm sure
they're reasonably aware of this problem that if it were that simple
they'd have done that already, but conversely 5 years of telling users
to change the command timer or stop using the wrong kind of drives for
RAID really isn't sufficiently good advice either.

The reality is that manufacturers of drives have handed us drives that
far and wide don't support SCT ERC or it's disabled by default, so
yeah maybe the thing to do is udev polls the drive for SCT ERC, if
it's already at 70,70 then leave the SCSI command timer as is. If it
reports it's disabled, then udev needs to know if it's in some kind of
RAID 1+ and if so then set SCT ERC to 70,70. If it's a single drive,
linear/concat, or RAID 0, then instead it should change the SCSI
command timer to 180 and let the user sort out the possible insanity
that follows which will be the occasional half minute or longer hang
whenever a drive has a bad sector.

>
>> Even in the case of Btrfs DUP, it's thwarted without a read error
>> reported from the drive (or it returning bad data).
>
> That case gets messy--different timeouts for different parts of the disk.
> Probably not practical.

The point is that DUP implies single device, and for certain that
configuration should not have such a short command timer. If the drive
can recover it at all, it could possibly remap the sector on its own.
In fact that's what is supposed to happen, but drives seem to only do
this when the sector read is already painfully slow.

-- 
Chris Murphy
