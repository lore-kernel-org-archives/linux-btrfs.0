Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59195 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474AbcAKWK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 17:10:58 -0500
Date: Mon, 11 Jan 2016 22:10:56 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Message-ID: <20160111221056.GD422@carfax.org.uk>
References: <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk>
 <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
In-Reply-To: <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
> >> >> OK. How do we track down that bug and get it fixed?
> >> >
> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
> >> >
> >> >    It's been around for a number of years. None of the devs has, I
> >> > think, had the time to look at it. When Josef was still (publicly)
> >> > active, he had it second on his list of bugs to look at for many
> >> > months -- but it always got trumped by some new bug that could cause
> >> > data loss.
> >>
> >>
> >> Interesting. I did not know of this bug. It's pretty rare.
> >
> >    Not really. It shows up maybe on average once a week on IRC. It
> > gets reported much less on the mailing list.
> 
> Is there a pattern? Does it only happen at a 2TiB threshold?

   No, and no.

   There is, as far as I can tell from some years of seeing reports of
this bug, no correlation with RAID level, hardware, OS, kernel
version, FS size, usage of the FS at failure, or allocation level of
either data or metadata at failure.

   I haven't tried correlating with the phase of the moon or the
losses on Lloyds Register yet.

   Hugo.

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWlChwAAoJEFheFHXiqx3kQyIP/2dZh4YuuiNcitoRD8BdDobI
t2m8fbUweKSEUaGLQYktMCvQM2lqgHf31mvmzPatSR4WkQZj2I+g5AkhYaDqpqCb
bAZjnItpw7kjZkY/Rnz861kmH2Mya4g+VKKV/qKt+x3GoNBkf9d/Rmkro2GjzgP0
U61axX9tAi0pu2I0uSHO1rsCZXTQJIAJiBA/W9kgcGDUF+RNzYSF/0OU0DaQ124N
3aNOzwJQx0JaePGzJvhwTXPU30eYmO8JJ8QSKp2GMiQ/N3NpNRtudqOMUHfhAAoZ
2SKc7NIESRC3IZu9dBcgZRGKPA1ZVkImMK+jSXmupcGljYCYnp9WJte9gS0hLLzr
WI7QPVAZHR4AKQQJFzn5G3p149fNrbwkkbc3xnnB64pFNCAIcwrTBAYzE4Q1japq
AQ9q4XLdEgQ1EJqJRhti7q0azHNW2N4emoLFejw4O3doNKwGevEo2T4iKSWfpIPT
S3+F6sVcPsSe5vyQeSBoLXkp5UGmBwLdWQR0QYuLyZ1DaYLK3OblPTunnETBCmPt
WzNS3+yke1qsUo9mPHqZzGZHSScTbXWJt2kMX9VL2PjrZNR5OLbA9DtO7aLVsbCK
XCMwPM8rkAuiZVvtd1kdOBHpphULajaZGMkXzPHQj99dfsCfBqT0dQ/txS5FAlod
hYTKhbwNBw99+zfI8y4k
=736P
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
