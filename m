Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45280 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755363AbdETBtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 21:49:19 -0400
Date: Sat, 20 May 2017 01:48:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520014807.GT9701@carfax.org.uk>
References: <20170519041638.sf7sensley4lpxiz@merlins.org>
 <20170519190358.GC10137@lim.localdomain>
 <20170520001134.GW29894@merlins.org>
 <20170520003747.GO9701@carfax.org.uk>
 <20170520004748.GA29894@merlins.org>
 <20170520005709.GP9701@carfax.org.uk>
 <20170520012522.GC29894@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1Sa0i77dkqaUxqYg"
In-Reply-To: <20170520012522.GC29894@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1Sa0i77dkqaUxqYg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 19, 2017 at 06:25:22PM -0700, Marc MERLIN wrote:
> On Sat, May 20, 2017 at 12:57:09AM +0000, Hugo Mills wrote:
> >    I think from the POV of removing these BUG_ONs, it doesn't matter
> > which FS causes them. "All" you need to know is where the error
> > happened. From there, you can (in theory) work out what was wrong and
> > handle it more elagantly than simply stopping.
> =20
> Sorry, "you" being the code author, or the user?

   Author.

> If code author, I'd rather this be worked out without the extra steps of
> having to guess or spend more time to see which FS.

   As I understand it, it doesn't really matter which FS it comes
=66rom. The question is: The kernel has hit this BUG_ON. What do you
actually want to do when this happens? You can't bring the kernel to a
grinding halt (BUG_ON), so how do you handle this more elegantly?

   It actually doesn't matter about the state of any specific FS that
caused this particular problem. The fact is, someone decided to check
on the FS's state, and punted the problem of handling the check's
failure to someone later (the BUG_ON). You(*)'ve got to pick up that punt
and deal with it more cleanly.

(*) You =3D=3D some kernel developer.

> My FS takes up to a day to scrub and btrfs check, clearly making me do th=
is
> over 3 of them is not a good use of time and a loss of up to 3 days of wa=
ll
> clock time.
> Not counting that during that time, I have loss of service on all my
> filesystems because I don't want to mount them read-write.
>=20
> >    Obviously it would be nice, from the POV of the sysadmin, to know
> > which FS was complaining, but as an FS developer it's secondary to
> > identifying a BUG_ON which happens in real life, which offers an
> > opportunity to make the error path more elegant.
>=20
> If the FS is remounted R/O, further damage is averted and it's obvious to
> the admin which FS has a problem.
>=20
> Is there a reason why all errors that are serious enough, do not cause the
> FS to remount R/O instead of having any BUG/BUG_ON at all?

   Simply that it's easier to write a BUG_ON than to write the code to
bubble up a failure to the point that the FS can be made RO. This is a
clean-up kind of process: BUG_ONs should mostly be changed into a
proper error-handling path leading to remount-RO (in the worst
cases). As I understand it, it's not massively difficult, but it's
probably non-trivial effort to get right in each case.

> WARN_ON is also fine obviously if the error is not serious enough, or doi=
ng
> a WARN_ON + a remount R/O

   Sure, but everything shouild really be turned into either a proper
error-handling path (most likely remount RO), or explicitly defined as
BUG_ON (i.e. "this must never happen -- if it does, then the hardware
is fucked up, and we're not responsible for the consequences") It's
that latter definition that's part of the hard decision-making process
for the kernel dev.

   Hugo.

--=20
Hugo Mills             | Great oxymorons of the world, no. 7:
hugo@... carfax.org.uk | The Simple Truth
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--1Sa0i77dkqaUxqYg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZH6BWAAoJEFheFHXiqx3koo0P/08vUbaE2apumHbxE6fL/BgZ
euyFVsBNIj1k/VWZ2aSpCS7qE1WCxBNKhaDV2Quxqqzm9wL9wyicjAXDna0IwEsK
/W3yK/RPd1jHjVwQ9qNw0VtEqAm2YhfqqHoJFj6dJUMmKczt99glz8tgu6vW+OPb
sarE+y6CnfBwEiGmVG2m3J3EiJ1JaiDUoN/a/7TrOe9aEKBNmGKOroPck1qXnEQK
6QQweiSHpw/tqRc7c/cOht6m9prZcUc1258BUWqamBPKPc5fwMqfg7wR5SZ/cS7E
pXI/lXH1t3I0c9EcFLlId4vU5TWbZ+gGtq9qzc1ZHg7txG/vFXsKVJ4/FIbucuxM
DleMsOKBDj94Y15U9DLKHwRdeuqgPaSG8XKtMWpu8CyAFoni1aXmMmf6LbsFETOV
8EE+587mAVX+6OWlQOxf83+Q1+4axrHyd/ojnGh6lAVY0D4/poVl2Ekb0rDBthzJ
TLsdnfMuXF4+aMLzujHsIJpSFfjdPmTNyVXDGbeulnQExshMUJtLdEih3nihfoQM
Qxm5hCwodoAo7s1MksO4aoxf+Qve67fxVAR2GYGSspOjKf7MBtRFKq0tWgDPFLWO
yAMrpIZFbmfuZlnaI6deWfs+ScDQxBtF/3YHNS8D1pVC6iHZQKjzHRyH04yd0MwX
rZjAxIX2iCVzXwAPXkUZ
=PEhT
-----END PGP SIGNATURE-----

--1Sa0i77dkqaUxqYg--
