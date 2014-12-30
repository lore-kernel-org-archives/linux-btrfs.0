Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43543 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3X6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 18:58:19 -0500
Received: by mail-yh0-f53.google.com with SMTP id i57so7570486yha.26
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 15:58:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A30F19.5050801@ubuntu.com>
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>
	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>
	<20141223211605.GC436@hungrycats.org>
	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
	<549F7539.4050801@ubuntu.com>
	<CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
	<54A30F19.5050801@ubuntu.com>
Date: Tue, 30 Dec 2014 16:58:18 -0700
Message-ID: <CAJCQCtSyu7dvp9SoF4u6QV9hF3jAQLtpYv8-6MOHSoP_NQyQ7A@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID-1?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 30, 2014 at 1:46 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/29/2014 4:53 PM, Chris Murphy wrote:
>> Get drives supporting configurable or faster recoveries. There's
>> no way around this.
>
> Practically available right now?  Sure.  In theory, no.

I have no idea what this means. Such drives exist, you can buy them or
not buy them.


>
>> This is a broken record topic honestly. The drives under
>> discussion aren't ever meant to be used in raid, they're desktop
>> drives, they're designed with long recoveries because it's
>> reasonable to try to
>
> The intention to use the drives in a raid is entirely at the
> discretion of the user, not the manufacturer.  The only reason we are
> even having this conversation is because the manufacturer has added a
> misfeature that makes them sub-optimal for use in a raid.

Clearly you have never owned a business, nor have you been involved in
volume manufacturing or you wouldn't be so keen to demand one market
subsidize another. 24x7 usage is a non-trivial quantity of additional
wear and tear on the drive compared to 8 hour/day, 40 hour/week duty
cycle. But you seem to think that the manufacturer has no right to
produce a cheaper one for the seldom used hardware, or a more
expensive one for the constantly used hardware.

And of course you completely ignored, and deleted, my point about the
difference in warranties.

Does the SATA specification require configurable SCT ERC? Does it
require even supporting SCT ERC? I think your argument is flawed by
mis-distributing the economic burden while simultaneously denying one
even exists or that these companies should just eat the cost
differential if it does. In any case the argument is asinine.


>
>> recover the data even in the face of delays rather than not recover
>> at all. Whether there are also some design flaws in here I can't
>> say because I'm not a hardware designer or developer but they are
>> very clearly targeted at certain use cases and not others, not
>> least of which is their error recovery time but also their
>> vibration tolerance when multiple drives are in close proximity to
>> each other.
>
> Drives have no business whatsoever retrying for so long; every version
> of DOS or Windows ever released has been able to report an IO error
> and give the *user* the option of retrying it in the hopes that it
> will work that time, because drives used to be sane and not keep
> retrying a positively ridiculous number of times.

When the encoded data signal weakens, they effectively becomes fuzzy
bits. Each read produces different results. Obviously this is a very
rare condition or there'd be widespread panic. However, it's common
and expected enough that the drive manufacturers are all, to very
little varying degree, dealing with this problem in a similar way,
which is multiple reads.

Now you could say they're all in collusion with each other to screw
users over, rather than having legitimate reasons for all of these
retried. Unless you're a hard drive engineer, I'm unlikely to find
such an argument compelling. Besides, it would also be a charge of
fraud.

>
>> If you don't like long recoveries, don't buy drives with long
>> recoveries. Simple.
>
> Better to fix the software to deal with it sensibly instead of
> encouraging manufacturers to engage in hamstringing their lower priced
> products to coax more money out of their customers.


In the meantime, there already is a working software alternative:
(re)write over all sectors periodically. Perhaps every 6-12 months is
sufficient to mitigate such signal weakening on marginal sectors that
aren't persistently failing on writes. This can be done with a
periodic reshape if it's md raid. It can be done with balance on
Btrfs. It can be done with resilvering on ZFS.


>
>> The device will absolutely provide a specific error so long as its
>> link isn't reset prematurely, which happens to be the linux
>> default behavior when combined with drives that have long error
>> recovery times. Hence the recommendation is to increase the linux
>> command timer value. That is the solution right now. If you want a
>> different behavior someone has to write the code to do it because
>> it doesn't exist yet, and so far there seems to be zero interest in
>> actually doing that work, just some interest in hand waiving that
>> it ought to exist, maybe.
>
> If this is your way of saying "patches welcome" then it probably would
> have been better just to say that.

Certainly not. I'm not the maintainer of anything, I have no idea if
such things are welcome. I'm not even a developer. I couldn't code my
way out of a hat.



-- 
Chris Murphy
