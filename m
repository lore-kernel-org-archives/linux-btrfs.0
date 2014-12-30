Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58216 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL3UqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 15:46:16 -0500
Received: by mail-qa0-f50.google.com with SMTP id dc16so10403453qab.23
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 12:46:15 -0800 (PST)
Message-ID: <54A30F19.5050801@ubuntu.com>
Date: Tue, 30 Dec 2014 15:46:17 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Uncorrectable errors on RAID-1?
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>	<20141223211605.GC436@hungrycats.org>	<CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>	<549F7539.4050801@ubuntu.com> <CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
In-Reply-To: <CAJCQCtQOxfoeE9xRLpqohHK8WXW63x1gsOgJQEc8TtbRp67RoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/29/2014 4:53 PM, Chris Murphy wrote:
> Get drives supporting configurable or faster recoveries. There's
> no way around this.

Practically available right now?  Sure.  In theory, no.

> This is a broken record topic honestly. The drives under
> discussion aren't ever meant to be used in raid, they're desktop
> drives, they're designed with long recoveries because it's
> reasonable to try to

The intention to use the drives in a raid is entirely at the
discretion of the user, not the manufacturer.  The only reason we are
even having this conversation is because the manufacturer has added a
misfeature that makes them sub-optimal for use in a raid.

> recover the data even in the face of delays rather than not recover
> at all. Whether there are also some design flaws in here I can't
> say because I'm not a hardware designer or developer but they are
> very clearly targeted at certain use cases and not others, not
> least of which is their error recovery time but also their
> vibration tolerance when multiple drives are in close proximity to
> each other.

Drives have no business whatsoever retrying for so long; every version
of DOS or Windows ever released has been able to report an IO error
and give the *user* the option of retrying it in the hopes that it
will work that time, because drives used to be sane and not keep
retrying a positively ridiculous number of times.

> If you don't like long recoveries, don't buy drives with long 
> recoveries. Simple.

Better to fix the software to deal with it sensibly instead of
encouraging manufacturers to engage in hamstringing their lower priced
products to coax more money out of their customers.

> The device will absolutely provide a specific error so long as its 
> link isn't reset prematurely, which happens to be the linux
> default behavior when combined with drives that have long error
> recovery times. Hence the recommendation is to increase the linux
> command timer value. That is the solution right now. If you want a
> different behavior someone has to write the code to do it because
> it doesn't exist yet, and so far there seems to be zero interest in
> actually doing that work, just some interest in hand waiving that
> it ought to exist, maybe.

If this is your way of saying "patches welcome" then it probably would
have been better just to say that.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUow8ZAAoJENRVrw2cjl5Rr9UH+wd3yJ1ZnoaxDG3JPCBq9MJb
Tb6nhjHovRDREeus4UWLESp9kYUyy5OfKmahARhM6AbaBXWYeleoD9SEtMahFXfn
/2Kn9yRBqZCBDloVQGNOUaSZyfhTRRl31cGABbbynRo6IDkLEfMQQPWgvz9ttch7
3aPciHhehs1CeseNuiiUPk6HIMb8lJLvgW5J1O5FwgXZ6Wyi9OZdoPL+prnFh2bP
5E2rGblYUHIUiLkOKFOOsEs8q2H9RICFJIBsz8KoPzjCDtdNETBF5mvx8bIUJpg0
Q7cQOo7IRxpFUL/7gnBtWgRIw3lvRY+SY2G+2YwaMiqdeuYcLCr853ONDYg0NCc=
=AYGW
-----END PGP SIGNATURE-----
