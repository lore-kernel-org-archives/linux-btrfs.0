Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35604 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbcF0Wa0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 18:30:26 -0400
Received: by mail-oi0-f45.google.com with SMTP id r2so220507271oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 15:30:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627215726.GG14667@hungrycats.org>
References: <576CB0DA.6030409@gmail.com> <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com> <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com> <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com> <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 16:30:23 -0600
Message-ID: <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
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

On Mon, Jun 27, 2016 at 3:57 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:

>
>> It just came up again in a thread over the weekend on linux-raid@. I'm
>> going to ask while people are paying attention if a patch to change
>> the 30 second time out to something a lot higher has ever been
>> floated, what the negatives might be, and where to get this fixed if
>> it wouldn't be accepted in the kernel code directly.
>
> Defaults are defaults, they're not for everyone.  30 seconds is about
> two minutes too short for an SMR drive's worst-case write latency, or
> 28 seconds too long for an OLTP system, or just right for an end-user's
> personal machine with a low-energy desktop drive and a long spin-up time.

The question is where is the correct place to change the default to
broadly capture most use cases, because it's definitely incompatible
with consumer SATA drives, whether in an enclosure or not.

Maybe it's with the kernel teams at each distribution? Or maybe an
upstream udev rule?

In any case something needs to give here because it's been years of
bugging users about this misconfiguration and people constantly run
into it, which means user education is not working.


>
> Once a drive starts taking 30+ seconds to do I/O, I consider the drive
> failed in the sense that it's too slow to meet latency requirements.

Well that is then a mismatch between use case and the drive purchasing
decision. Consumer drives do this. It's how they're designed to work.


> When the problem is that it's already taking too long, the solution is
> not waiting even longer.  To put things in perspective, consider that
> server hardware watchdog timeouts are typically 60 seconds by default
> (if not maximum).

If you want the data retrieved from that particular device, the only
solution is waiting longer. The alternative is what you get, an IO
error (well actually you get a link reset, which also means the entire
command queue is purged on SATA drives).


> If anything, I want the timeout to be shorter so that upper layers with
> redundancy can get an EIO and initiate repair promptly, and admins can
> get notified to evict chronic offenders from their drive slots, without
> having to pay extra for hard disk firmware with that feature.

The drive totally thwarts this. It doesn't report back to the kernel
what command is hung, as far as I'm aware. It just hangs and goes into
a so called "deep recovery" there is no way to know what sector is
causing the problem until the drive reports a read error, which will
include the affected sector LBA.

Btrfs does have something of a work around for when things get slow,
and that's balance, read and rewrite everything. The write forces
sector remapping by the drive firmware for bad sectors.


>> *Ideally* I think we'd want two timeouts. I'd like to see commands
>> have a timer that results in merely a warning that could be used by
>> e.g. btrfs scrub to know "hey this sector range is 'slow' I'm going to
>> write over those sectors". That's how bad sectors start out, they read
>> slower and eventually go beyond 30 seconds and now it's all link
>> resets. If the problem could be fixed before then... that's the best
>> scenario.
>
> What's the downside of a link reset?  Can the driver not just return
> EIO for all the outstanding IOs in progress at reset, and let the upper
> layers deal with it?  Or is the problem that the upper layers are all
> horribly broken by EIOs, or drive firmware horribly broken by link resets?

Link reset clears the entire command queue on SATA drives, and it
wipes away any possibility of finding out what LBA or even a range of
LBAs, is the source of the stall. So it pretty much gets you nothing.


> The upper layers could time the IOs, and make their own decisions based
> on the timing (e.g. btrfs or mdadm could proactively repair anything that
> took more than 10 seconds to read).  That might be a better approach,
> since shortening the time to an EIO is only useful when you have a
> redundancy layer in place to do something about them.

For RAID with redundancy, that's doable, although I have no idea what
work is needed, or even if it's possible, to track commands in this
manner, and fall back to some kind of repair mode as if it were a read
error.

For single drives and RAID 0, the only possible solution is to not do
link resets for up to 3 minutes and hope the drive returns the single
copy of data.

Even in the case of Btrfs DUP, it's thwarted without a read error
reported from the drive (or it returning bad data).



-- 
Chris Murphy
