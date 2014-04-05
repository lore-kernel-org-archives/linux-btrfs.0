Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46871 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaDEONs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 10:13:48 -0400
Date: Sat, 5 Apr 2014 15:13:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Message-ID: <20140405141340.GT7442@carfax.org.uk>
References: <2692878.dRG1K49eOP@fnix>
 <7675297.F25Z3Ox7Yz@tethys>
 <pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>
 <12471892.pAn1KAtSS4@tethys>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CC5qiHV/f0UkyWC4"
In-Reply-To: <12471892.pAn1KAtSS4@tethys>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CC5qiHV/f0UkyWC4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2014 at 01:10:13PM +0200, Sw=E2mi Petaramesh wrote:
> Le samedi 5 avril 2014 10:12:17 Duncan wrote [excellent performance advic=
e=20
> about disabling Akonadi in BTRFS etc]:
>=20
> Thanks Duncan for all this excellent discussion.
>=20
> However I'm still rather puzzled with a filesystem for which advice is "i=
f you=20
> want tolerable performance, you have to turn off features that are the de=
fault=20
> with any other FS out there (relatime -> noatime) or you have to quit usi=
ng=20
> this database, or you have to fiddle around with esoteric option such as=
=20
> disabling COW wich BTW is one of BTRFS most promiment features".

   OK, a couple of points here:

 - For the things where you should turn CoW off, they're typically
   things like databases that do their _own_ CoW handling or similar
   high-performance reliable transactions/writes, so you generally
   lose very little there.

 - I'm not aware, particularly, of any major differences between
   noatime and relatime in performance on btrfs. (But I may be wrong
   there).

 - Given Duncan's discussion of the performance of the semantic
   desktop, I would suggest turning it off *temporarily* to see if it
   really is where the difficulty lies. If it turns out that it's
   unrelated and things still slow down horribly, then at least we've
   knocked down one theory and need to look elsewhere. If it _is_
   related, then that at least gives us a reproducer for the problem,
   and the people who are skilled in tracking down performance
   problems have something to look at. It also means that you have a
   range of things you know you can try if the problem gets really bad
   (maybe delete the database and rebuild it regularly? mark parts of
   it nodatacow? maybe autodefrag helps? maybe it's something simple
   the authors of the database can change?).

[snip]
> I need a filesystem that fits me, I don't want to have to fit my filesyst=
em :-\

   If you truly find btrfs unusable -- which you've said at various
points in the past -- then I'm not going to suggest that you keep
using it. Maybe something else is genuinely better for you. It's not
in the interests of the btrfs community to recommend that people use
btrfs when it's not appropriate. That said, it would be good to have
your help to try to fix the (apparently quite unusual) problems you're
seeing. Part of that is tracking down which bit of software is
triggering the issues, and helping to identify what the issues
actually are. Sometimes, the hardest problem in fixing bugs is finding
someone who can reproduce the bug and test fixes.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Ceci n'est pas une pipe:  | ---                  =20

--CC5qiHV/f0UkyWC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0APlFheFHXiqx3kAQJR9A/9EBzR9/HELrnJ7aIzSdLgXnVQ2b/It60M
XqoTk/2BEmOXN6wTfg1PPlW/027LwPnPEQ401LUHHQnHA9cHG4Xqk5iN/PTAjwxi
hUjA9cPz4znUbEL7KEMh+K5m7yF6E2TcbOz3VQuGQsQ3aWiUMiFY5xjIdURaCkXQ
J9wyEenGMF5X3y5exxXCKjD7jMbgEIQR8FhyzkRgZZenzwyP7livzrngtw4+f/vx
PN3H9fW5AM1jEhktyBbLrThRyILZ87qEvOuxhM4IJ6vtkvcxO8+Lmgn32VUHIx65
xWJqqEvudUtmFoZH0/4whsQaj52/sIu73qdapZZgDNAexLY/FtzZTWM8JYTzDjPl
Le1ufTKjUDJFDuKTIs0/sIXyb2z/1L6t7nkju22RNKMBuYmR028mD2GSef3KqM6O
A1eGx8rFo5LKQMxHS8ZYNCnr3Y/thENjIMWBvllHN1upLOTyfWD17fgJW/8tGJmz
S5M9hvRJHuOjk0tcoWHGDXwq4Z9UAGpk3uoyrj5X4pCEaVQJVaFYiuMu1dn+0iP6
zIfa0UF1qal2K7wEkbk3DWb+DSsVZRfgoLANsfgyBE1usfTnGT0fZnh41Nq2mnTA
ZSwiPeblvLq5cgw+Kb71TBA+i16gFyRMomAj2SPtJiMJFbdSMqr4m041o6NwM5JV
rmpJ6qzXC/Y=
=EKXa
-----END PGP SIGNATURE-----

--CC5qiHV/f0UkyWC4--
