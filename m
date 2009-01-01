From: Chris Samuel <chris@csamuel.org>
Subject: Re: multiple device usage
Date: Thu, 1 Jan 2009 12:02:17 +1100
Message-ID: <200901011202.18060.chris@csamuel.org>
References: <556243856@web.de> <3d0408630812290716i5ac68b27i17fe35891706e449@mail.gmail.com> <1230672308.4229.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5270731.i3Lk3FMhFU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1230672308.4229.6.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5270731.i3Lk3FMhFU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 31 Dec 2008 8:25:08 am Chris Mason wrote:

> This gets confusing in a hurry, but the idea is to duplicate metadata by
> default. =A0So, if you're using the default mount options on a single
> drive and add a second drive, it should switch metadata to raid1.

Yup, that's what I inferred from your earlier posts and the code. :-)

> I've always planned on adding an option to btrfs-vol -b to have it
> change the data or metadata allocation policies (raidX to raidY,
> restripe etc). =A0The kernel side code is all there, we just need
> something to wire it up to userland.

Understood.  If I get some Copious Spare Time (tm) I might take a look at t=
hat=20
(though don't let that stop anyone else trying first!).

> data duplication on a single spindle could work, I just haven't hooked
> it up because I couldn't think of a really strong reason to do it ;)

I think for SSD's it could be really handy, especially for people who have =
a=20
standard distro install and decide they want to convert their ext3 partitio=
n=20
to btrfs using the tools.   It's just a bit easier than getting them to=20
backup, repartition, make the filesystem and restore.

Downside of course is that those original blocks never get mirrored (unless=
=20
something like btrfsck was extended to fix those things up).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart5270731.i3Lk3FMhFU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVwWGo1yjaOTJg85AQIEngf/R8E9FJmp+fsnCHyGY5HR+jF3D/F1X//m
6RvVnaFU5czOfSPmm8TQtfxsBMF1Go7tn7xAvD3OAyZnvwGBP1XiHjqYnP1Fh3TN
eQPWROXkVTPZpW5njp88em7HvJPTIO6+hNEHht7EUmWIHqom1dJuoC3eYdpfr6OQ
bPQ1QdnbdvZJFS/Mlu+czkqmlgfC697uuvQm9tvMOwh6WlgNJ9yQ+Fyb4a4cdnZK
jdshrQnLE3JeV3MGOY3/he8iarWfvO0pZtU9D38AdQVunWVNeaYBI2MU+U4QHGfH
tbMkK8p4AYrZGAQzKNTXIfh7hQrP7bWqRCyhMdwer19zb3AIbeWBuA==
=JIq7
-----END PGP SIGNATURE-----

--nextPart5270731.i3Lk3FMhFU--
