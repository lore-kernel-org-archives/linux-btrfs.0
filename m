Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:40747 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaL2Vxb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 16:53:31 -0500
Received: by mail-yh0-f51.google.com with SMTP id a41so6920010yho.10
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 13:53:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <549F7539.4050801@ubuntu.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
	<549F7539.4050801@ubuntu.com>
Date: Mon, 29 Dec 2014 14:53:30 -0700
Message-ID: <CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 27, 2014 at 8:12 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 12/23/2014 05:09 PM, Chris Murphy wrote:
>> The timer in /sys is a kernel command timer, it's not a device
>> timer even though it's pointed at a block device. You need to
>> change that from 30 to something higher to get the behavior you
>> want. It doesn't really make sense to say, timeout in 30 seconds,
>> but instead of reporting a timeout, report it as a read error.
>> They're completely different things.
>
> The idea is not to give the drive a ridiculous amount of time to
> recover without timing out, but for the timeout to be handled properly.

Get drives supporting configurable or faster recoveries. There's no
way around this.

>
>> There are all sorts of errors listed in libata so for all of them
>> to get dumped into a read error doesn't make sense. A lot of those
>> errors don't report back a sector, and the key part of the read
>> error is what sector(s) have the problem so that they can be fixed.
>> Without that information, the ability to fix it is lost. And it's
>> the drive that needs to report this.
>
> It is not lost.  The information is simply fuzzed from an exact
> individual sector to a range of sectors in the timed out request.  In
> an ideal world the drive would give up in a reasonable time and report
> the failure, but if it doesn't, then we should deal with that in a
> better way than hanging all IO for an unacceptably long time.

This is a broken record topic honestly. The drives under discussion
aren't ever meant to be used in raid, they're desktop drives, they're
designed with long recoveries because it's reasonable to try to
recover the data even in the face of delays rather than not recover at
all. Whether there are also some design flaws in here I can't say
because I'm not a hardware designer or developer but they are very
clearly targeted at certain use cases and not others, not least of
which is their error recovery time but also their vibration tolerance
when multiple drives are in close proximity to each other.

If you don't like long recoveries, don't buy drives with long
recoveries. Simple.


>
>> Oven doesn't work, so lets spray gasoline on it and light it and
>> the kitchen on fire so that we can cook this damn pizza! That's
>> what I just read. Sorry. It doesn't seem like a good idea to me to
>> map all errors as read errors.
>
> How do you conclude that?  In the face of a timeout your choices are
> between kicking the whole drive out of the array immediately, or
> attempting to repair it by recovering the affected sector(s) and
> rewriting them.  Unless that recovery attempt could cause more harm
> than degrading the array, then where is the "throwing gasoline on it"
> part?  This is simply a case of the device not providing a specific
> error that says whether it can be recovered or not, so let's attempt
> the recovery and see if it works instead of assuming that it won't and
> possibly causing data loss that could be avoided.

The device will absolutely provide a specific error so long as its
link isn't reset prematurely, which happens to be the linux default
behavior when combined with drives that have long error recovery
times. Hence the recommendation is to increase the linux command timer
value. That is the solution right now. If you want a different
behavior someone has to write the code to do it because it doesn't
exist yet, and so far there seems to be zero interest in actually
doing that work, just some interest in hand waiving that it ought to
exist, maybe.



>
>> Any decent server SATA drive should support SCT ERC. The
>> inexpensive WDC Red drives for NAS's all have it and by default are
>> a reasonable 70 deciseconds last time I checked.
>
> And yet it isn't supported on the cheaper but otherwise identical
> greens, or the higher performing blues.  We should not be helping
> vendors charge a premium for zero cost firmware features that are
> "required" for raid use when they really aren't ( even if they are
> nice to have ).

The manufacturer says they differ in vibration characteristics, 24x7
usage expectation, and warranty among the top relevant features. The
Red has a 3 year warranty, the Green is a 1 year warranty. That alone
easily accounts for the $15 difference, although that's perhaps
somewhat subjective. I don't actually know the wholesale prices, they
could be the same if the purchasing terms are identical.

Western Digital Red NAS Hard Drive WD30EFRX 3TB IntelliPower 64MB
Cache SATA 6.0Gb/s 3.5" NAS Hard Drive
$114 on Newegg.com

Western Digital WD Green WD30EZRX 3TB IntelliPower 64MB Cache SATA
6.0Gb/s 3.5" Internal Hard Drive Bare Drive - OEM
$99 on Newegg.com

And none of the manufacturers actually says these features are
required for raid use. What they say is, they reserve the right to
deny warranty claims if you're using a drive in a manner inconsistent
with their intended usage which is rather easily found information.

-- 
Chris Murphy
