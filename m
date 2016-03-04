Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50269 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcCDMfs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 07:35:48 -0500
Date: Fri, 4 Mar 2016 12:35:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160304123546.GI27786@carfax.org.uk>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <pan$1a785$dbfe4789$bdc8f4d5$778788dd@cox.net>
 <CAOE4rSw_+PQEjAiHJkk03ec=J3ti9t9VCOD-zJSi=rP4dPnsjQ@mail.gmail.com>
 <pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sl5MdczEF/OU2Miu"
In-Reply-To: <pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sl5MdczEF/OU2Miu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 04, 2016 at 12:31:44PM +0000, Duncan wrote:
> D=C4=81vis Mos=C4=81ns posted on Thu, 03 Mar 2016 17:39:12 +0200 as excer=
pted:
>=20
> > 2016-03-03 6:57 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> >>
> >> You're issue isn't the same, because all your space was allocated,
> >> leaving only 1 MiB unallocated, which isn't normally enough to allocate
> >> a new chunk to rewrite the data or metadata from the old chunks into.
> >>
> >> That's a known issue, with known workarounds as dealt with in the FAQ.
> >>
> >>
> > Ah, thanks, well it was surprising for me that balance failed with out
> > of space when both data and metadata had not all been used and I thought
> > it could just use space from those...
> >=20
> > especially as from FAQ:
> >> If there is a lot of allocated but unused data or metadata chunks,
> >> a balance may reclaim some of that allocated space. This is the main
> >> reason for running a balance on a single-device filesystem.
> >=20
> > so I think regular balance should be smart enough that it could solve
> > this on own and wouldn't need to specify any options.
>=20
> Well it does solve the problem on its own... to the extent that it=20
> eliminates empty chunks (kernel 3.17+, it didn't before that).  But if=20
> there's even a single 4 KiB file block used in the (nominal 1 GiB sized=
=20
> data) chunk, it's no longer empty and thus not eliminated by the empty=20
> chunk cleanup routines.
>=20
> Additionally, balance, which was originally called the restriper,

   Nope, balance was always called balance. The restriper was the
balance feature that's now called "convert". :)

   Hugo.

 by=20
> definition, must have enough space to create at least one empty chunk in=
=20
> ordered to copy the data from existing chunks into, such that it can=20
> consolidate that data into fewer new chunks when the old ones were partly=
=20
> empty.  If there's not enough unallocated space left to write even one=20
> chunk, balance can't do its thing, because there's nowhere to create the=
=20
> new chunk it needs to be able to copy over the data from the old chunk.
>=20
> With nominal 1 GiB data chunk size (up to 10 GiB in some instances if the=
=20
> filesystem is large enough), that means you need at least 1 GiB of free=
=20
> unallocated space in ordered to have room to create that single chunk=20
> that starts the rewrite process off.  Without it, you're stuck, tho there=
=20
> are workarounds like trying to balance the smaller (256 MiB nominal)=20
> metadata chunks first, hoping that frees the minimum 1 GiB space needed=
=20
> for a data chunk, or temporarily adding another device a few GiB in size=
=20
> to the filesystem, to give it somewhere to write the new chunk to so it=
=20
> can start off the rewrite and shrinking process.
>=20

--=20
Hugo Mills             | Darkling's First Law of Filesystems:
hugo@... carfax.org.uk | The user hates their data
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--sl5MdczEF/OU2Miu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW2YEiAAoJEFheFHXiqx3kuvQP/igKQAS0+V2iWqGWqwGolB0h
I+ifcWwnxmCZzJXwby8uO0YoSogWY8fAxKicVa9LWVSLRyXC5wcJk4fTw7npAF9S
NbkxTbrUVmNzRcJ8k8Wjmx6V0MhiNRewG5kMH9z9snMClgV6vm9Z+zRZHju8VUpa
wESLa5cpaDgyRE+hqPU0fftCaxkN0Aaig5ahuWIvfeMFnqCn2eP7rfbk/bnwhz5b
1PpS3/axyD5WAEm2kkoKP+RImSRQIPtReQQpcFW2/QV+sxzogZQ65+plrXUZHrvl
tX3Q+PtMfbQuRI1qZtgEZ3NgYzOx1XkGseV3QS1HNzJkAuafuwx0IVyBURxeS7vZ
Nkj5FATVcGDw740XAsUQGl3Ua+HIWYvIi1gciMEXOjc6FMThfJmmgs72+nRx1KIr
eqOayL7PjkdasMZXDUyafj/if5JgMS/+Mls73mCyGjpSvlvKKpFyQhBSxriRe4o6
XHj2mBtEoyhZ5PTnp3i2/1rCSDzwi0mR8CTvRTxB/rDnfTAVzIu93UUL8hFNYVTb
h4kK4A6kq7wQNpPGLpHbgWFqkAcnNGSzmTI65w5br2+bIs83NHf/fAG0FkYjdl0u
Y4yMb+h94CRLb+ILWA2Bl2kLO/HPvuzSSPnAzaHIb3j50HLT0Py4ePwp94yEj0Zf
CjyanFYLBbtjfI4ZTTeo
=ycMj
-----END PGP SIGNATURE-----

--sl5MdczEF/OU2Miu--
