Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:49139 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425AbaL1DOA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 22:14:00 -0500
Message-ID: <549F7539.4050801@ubuntu.com>
Date: Sat, 27 Dec 2014 22:12:57 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC: Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: Uncorrectable errors on RAID-1?
References: <CANcfdL39NWs=go4LVY8vuqp7bqkKuoop2arzpJoEX7TY4wSGYw@mail.gmail.com>	<CAJCQCtQ-DkJh5tg1gWuv6EW=enm66jx16jrtXhXiPvhauRnJ9w@mail.gmail.com>	<20141223211605.GC436@hungrycats.org> <CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
In-Reply-To: <CAJCQCtTK2OinQZakArtX4BD=JAz6UJr=dhc2xUbcqJJL1v6Kkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/23/2014 05:09 PM, Chris Murphy wrote:
> The timer in /sys is a kernel command timer, it's not a device
> timer even though it's pointed at a block device. You need to
> change that from 30 to something higher to get the behavior you
> want. It doesn't really make sense to say, timeout in 30 seconds,
> but instead of reporting a timeout, report it as a read error.
> They're completely different things.

The idea is not to give the drive a ridiculous amount of time to
recover without timing out, but for the timeout to be handled properly.

> There are all sorts of errors listed in libata so for all of them
> to get dumped into a read error doesn't make sense. A lot of those
> errors don't report back a sector, and the key part of the read
> error is what sector(s) have the problem so that they can be fixed.
> Without that information, the ability to fix it is lost. And it's
> the drive that needs to report this.

It is not lost.  The information is simply fuzzed from an exact
individual sector to a range of sectors in the timed out request.  In
an ideal world the drive would give up in a reasonable time and report
the failure, but if it doesn't, then we should deal with that in a
better way than hanging all IO for an unacceptably long time.

> Oven doesn't work, so lets spray gasoline on it and light it and
> the kitchen on fire so that we can cook this damn pizza! That's
> what I just read. Sorry. It doesn't seem like a good idea to me to
> map all errors as read errors.

How do you conclude that?  In the face of a timeout your choices are
between kicking the whole drive out of the array immediately, or
attempting to repair it by recovering the affected sector(s) and
rewriting them.  Unless that recovery attempt could cause more harm
than degrading the array, then where is the "throwing gasoline on it"
part?  This is simply a case of the device not providing a specific
error that says whether it can be recovered or not, so let's attempt
the recovery and see if it works instead of assuming that it won't and
possibly causing data loss that could be avoided.

> Any decent server SATA drive should support SCT ERC. The
> inexpensive WDC Red drives for NAS's all have it and by default are
> a reasonable 70 deciseconds last time I checked.

And yet it isn't supported on the cheaper but otherwise identical
greens, or the higher performing blues.  We should not be helping
vendors charge a premium for zero cost firmware features that are
"required" for raid use when they really aren't ( even if they are
nice to have ).


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUn3U5AAoJENRVrw2cjl5RFIQIAJAr86Y5s8RWuL8/We/AlM5Q
JUuZGGaE1IGmMROdUAEzmj78L8lI2U3D95sERDKmd3aJosfpi1SVOExQZebSIqch
hhkLGC0FecxE5VC/67E2wwmfbropSk0mlA5Fbgx8mYf60iUHWcFUkc01kER3JGnd
xMI2jV0UpqVD/gY/a5O7Z7bPeHICQcIyXCN7MAbTMBrDWsYhDACQpij+aNXu5+ke
rCNV5c/VkYFQZ9aaMb6Mxmi9KOkCVv2+kBOsxwqPxlO5s9vKORDhxMp8XeJQEvhU
X2GAgS8r8gSGVdPutekXR1vB+TwhdMxftBWL9jcI1y05Y0z3GcOX+/90S9mrSaU=
=2tIU
-----END PGP SIGNATURE-----
