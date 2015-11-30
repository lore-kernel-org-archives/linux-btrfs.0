Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46513 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbK3RGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 12:06:03 -0500
Date: Mon, 30 Nov 2015 17:06:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Mason <clm@fb.com>, Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151130170600.GC8775@carfax.org.uk>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151130164801.GD2162@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
In-Reply-To: <20151130164801.GD2162@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 30, 2015 at 11:48:01AM -0500, Chris Mason wrote:
> On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
> >    We've just had someone on IRC with a problem mounting their FS. The
> > main problem is that they've got a corrupt log tree. That isn't the
> > subject of this email, though.
> > 
> >    The issue I'd like to raise is that even with -oro as a point
> > option, the FS is trying to replay the log tree. The dmesg output from
> > mount -oro is at the end of the email.
> > 
> >    Now, my memory, experience and understanding is that the FS
> > doesn't, and shouldn't replay the log tree on a RO mount, because the
> > FS should still be consistent even without the reply, and
> > RO-means-actually-RO is possible and desirable. (Compared to a
> > journalling FS, where journal replay is required for a consistent,
> > usable FS).
> > 
> >    So, this looks to me like a regression that's come in somewhere.
> > 
> >    (Just for completeness, the system in question usually runs 4.2.5,
> > but the live CD the OP is using is 4.2.3).
> 
> We do need to replay the log tree, even on readonly mounts.  Otherwise
> files created and fsunk before crashing may not even exist.

   I'm actually happy with that, as long as the log tree is retained
until it _can_ be played back. I think it's much more important that
read-only actually means read-only *as much as is possible* (if for no
other reason than being able to test the status of the log tree).
Obviously, for journalling FSes, a journal reply is required by the
design of the FS, but with a CoW FS, the FS should be consistent if
possibly outdated with a RO mount.

   Maybe there should be a "replay-log" mount option to modify the
"ro" option to allow the log to be replayed but no further
modifications? (i.e. keep the plain "ro" case to be the safest option
that makes the fewest changes to the FS structure -- none).

> We'll bail out of the log replay on readonly media, but otherwise the
> replay always happens.

   OK, so what was happening in the cases where a filesystem was
mountable RO, but not RW, and then btrfs-zero-log allowed the FS to be
mounted? I've handled any number of people with exactly those
symptoms, and it's been like that for a while. What I saw on IRC a
couple of days ago seems to be new behaviour.

   Hugo.

-- 
Hugo Mills             | argc, argv, argh!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWXIH4AAoJEFheFHXiqx3k/DkQAI8HWpbeX8GlQLWFNExyGAgf
xOp+HsKSP6aKbkwoGNvl0TesQb4g/mY+IiYgJZsvTRH01KXQASnOaPy2OC3BTC8y
rYEMlOEQVJKb0w7fkpL3iTtrkP3TlBr8Qwhv+PmHUq8v42t2LnYls7yKuNtWnxf1
cuBPM3wpH5t3Ug51y7KmXLJicM5sOjQWuCYQE7MUKwoZjRtkfC0Au15ROtGzYMRY
qoamStvLZ6CTMrl5ZU/9dSfdkiZT+UW/iCRiEiahIuZ+TLMbh71HIXsZvo2qHrli
T/OYTdOQTwkJF7XszX0Zf86DZGRzOMoKvBTxoDrOU/ZO+A4Aw7lzC5fd1YMpNBs7
SI1hgAh/7kTOWbx5Xqunf+LANAHEVhygzfREBPPZwPLPTIryK5RNiPT5OhY/pgXF
E+DAndNRyE3nvwMS6wX/E7Ekhy7TKnfcojXhT5DeLrVUW5gJj7CmgTX5wUW0kF4P
D0sJftKcTDBLcboM5msE0sQBwilb2kRZEJxMISLrLNYl1V8aj6EsXT482m+2URF5
ZiDezALccMY98cxOUdYNIIMdxji33vDnPjlOWZ/RkPriyoq53kFuTyctHuPPoL+C
ZZVZw0R49486QnEqVnCCgiJi3gMZJ1dNqHyZz3qg4A5YoWa23VMBnGFBl2Vm64xG
YoFrGUNrfsQ0T0Sv+l7A
=jwlY
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
