Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48113 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaDFJZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 05:25:49 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sun, 06 Apr 2014 11:24:02 +0200
Message-ID: <2131050.Gsdb2GJxUb@tethys>
In-Reply-To: <20140405141340.GT7442@carfax.org.uk>
References: <2692878.dRG1K49eOP@fnix> <12471892.pAn1KAtSS4@tethys> <20140405141340.GT7442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart33258395.OsKD4pIrKs"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart33258395.OsKD4pIrKs
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi people :-)

Le samedi 5 avril 2014 15:13:40 Hugo Mills a =E9crit :
>=20
>  - I'm not aware, particularly, of any major differences between
>    noatime and relatime in performance on btrfs. (But I may be wrong
>    there).

It's especially noticeable at first boot in a given day, as "relatime" =
will=20
have atimes updated once a day.

I've noticed that the 1st boot on any given day can be up to 3-4 times =
longer=20
on a BTRFS with "relatime" compared to a btrfs with "noatime". This is=20=

especially true if snapshots have recently been made.

>  - Given Duncan's discussion of the performance of the semantic
>    desktop, I would suggest turning it off *temporarily* to see if it=

>    really is where the difficulty lies.

I'm afraid that this would turn my email off (I used Kmail and it's bac=
king=20
store is Akonadi, and non, I don't want to change MUA), and I can't rea=
lly=20
live long without it ;-)

>    (maybe delete the database and rebuild it regularly?

I'm not considering deleting the database. It contains about 1GB of my =
email=20
archive and I've no clue about how I could possibly export and reimport=
 it.=20
The way the Kmail apps use the Akonadi backing store is somewhat tricky=
...

>    mark parts of it nodatacow?

I woud be allright about trying "nodatacow", but it's totally unclear t=
o me=20
what impact this can have on snapshots ?

Will "nodatacow" defeat snapshots, allowing data to change in snapshots=
 ?

OTOH will snapshots force datacow to happen, defeating the purpose of=20=

nodatacow ?

As I don't want to break my DB, I won't use nodatacow until I'm sure ab=
out the=20
consequences...

>    maybe autodefrag helps?

I've always used autodefrag... Plus I perform manual defrags more often=
 than=20
in Windows :-/

>    maybe it's something simple
>    the authors of the database can change?).

I'm not going to expect KDE people to change anything aytime soon upon =
users=20
requests. Some very *SIMPLE* bugs confirmed by dozens of users have sta=
yed in=20
their bug tracker for years.

KDE bugs stay until somedays God decides to fix one. If ever.

>    If you truly find btrfs unusable -- which you've said at various
> points in the past -- then I'm not going to suggest that you keep
> using it. Maybe something else is genuinely better for you.

Every 9 months or so I reads reports or reviews or the BTRFS wiki stati=
ng that=20
performance and stability of BTRFS have dramatically improved. Then I r=
ead=20
everyting I can about new mkfs or btrfstune options, advice, best mount=
=20
options, the wiki, and give it a try.

Typically a couple months later my machines slow down to the point wher=
e I=20
come and start complaining here.

Usually 2 more months and I'm back either to ext4 or ZFS, depending on =
the=20
machine's specific usage pattern...

I still think that BTRFS *should* be very promising *if* its developper=
s can=20
fix the recurring performance issues and make it truly usable =AB for b=
asic=20
boring office use =BB which is currently typically my case on my laptop=
s, and I'm=20
no benchmark (or maybe a human one ?) and I can say that currently, BTR=
FS is=20
*not* adapted for a KDE desktop running KMail and Firefox - but if it a=
int' no=20
good at this very basic usage, well what is it good at ?

I'm not ranting because I love to shoot BTRFS down in flames, but becau=
se I'd=20
love to be able to keep it on my system this time, and forget it, and n=
ot to=20
reformat everything again in a month or so (as soon as I will tell myse=
lf : =AB=20
Well, the improvements promised by kernel 3.14 are still far behind my=20=

usability needs =BB)...

Kind regards.

=2D-=20
Sw=E2mi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 907=
6E32E

--nextPart33258395.OsKD4pIrKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iD8DBQBTQR1JL8JcHZB24y4RAo/XAKDEw9iIZ1w2DMqwcmOMevtWv27kPwCfRMdg
A6NSKKwBAOLk+cCgnLynktc=
=bmK5
-----END PGP SIGNATURE-----

--nextPart33258395.OsKD4pIrKs--

