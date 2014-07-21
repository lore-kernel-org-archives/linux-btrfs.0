Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60187 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbaGUNWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 09:22:24 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MdEsh-1WrxwT2eZv-00IWNe for
 <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 15:22:22 +0200
Date: Mon, 21 Jul 2014 15:22:16 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140721152216.27d8a4c4@marcec>
In-Reply-To: <20140720214440.398e7e68@marcec>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
	<20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qZBRbNu/ED+QJQuE/h27X/S"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/qZBRbNu/ED+QJQuE/h27X/S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 20 Jul 2014 21:44:40 +0200
schrieb Marc Joliet <marcec@gmx.de>:

[...]
> What I did:
>=20
> - delete the single largest file on the file system, a 12 GB VM image, al=
ong
>   with all subvolumes that contained it
> - rsync it over again
[...]

I want to point out at this point, though, that doing those two steps freed=
 a
disproportionate amount of space.  The image file is only 12 GB, and it had=
n't
changed in any of the snapshots (I haven't used this VM since June), so that
"subvolume delete -c <snapshots>" returned after a few seconds. Yet deletin=
g it
seems to have freed up twice as much. You can see this from the "filesystem=
 df"
output: before, "used" was at 229.04 GiB, and after deleting it and copying=
 it
back (and after a day's worth of backups) went down to 218 GiB.

Does anyone have any idea how this happened?

Actually, now I remember something that is probably related: when I first
moved to my current backup scheme last week, I first copied the data from t=
he
last rsnapshot based backup with "cp --reflink" to the new backup location,=
 but
forgot to use "-a".  I interrupted it and ran "cp -a -u --reflink", but it =
had
already copied a lot, and I was too impatient to start over; after all, the
data hadn't changed.  Then, when rsync (with --inplace) ran for the first t=
ime,
all of these files with wrong permissions and different time stamps were co=
pied
over, but for some reason, the space used increased *greatly*; *much* more =
than
I would expect from changed metadata.

The total size of the file system data should be around 142 GB (+ snapshots=
),
but, well, it's more than 1.5 times as much.

Perhaps cp --reflink treats hard links differently than expected?  I would =
have
expected the data pointed to by the hard link to have been referenced, but
maybe something else happened?

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/qZBRbNu/ED+QJQuE/h27X/S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzRQNAAoJEL/Q5oYsiHj0r+wP/3LxqhmDxYTm3HC5QU/cSR8b
aHWUwO90N16QiPajUeUMOUVJPjrw6KmCAbGtxKlUg4iJoomqzFWf8i2WEOGAlfX1
KPzdrq2TDkZTeH1Q5HIWlHpM1VgYyT0BJHO6YnWzO5qcLpyPG9vVSDiRPUqWI2KJ
8NMsInF4V3274NYwH4fZoHmGAyztzJ2t/qZffoaTp2BFtNhP7LCWH27c4GWvOitZ
v1RA/wU8RvrHCPYNeang60W4t0C403OIOgLt/z7fhC6KAIRrh6yM4J5BSCaIca/X
joelPMGO6TjUuBeIyuIGevgdItKAper1UNkKKTFqteNuSai0iycYP2WUopnHBQK4
3Y7iP0RJLk6ZBpcutR/qmE/OyZrkLgW16SEg8QFznAg1t62zv28fdbXaEK9YjqSk
9k8b+/FYq4eSlfJz2WCJblGxovC2sAga0+8XRw28vbn/0jo1mpIealCqPe49ow3R
AWz1rRtnzE+UD0a+iHbGsLtnoyJi15vgUc//pSlNNdIgy1N19PE8h3yH+9cMn86y
QlL7XMD07CO0TL0yXtk8pnmyflaFJERWL7AP0TR5Ro6OXHF0IpPpJ9OjCnExihpA
1MMqg8Yb3Dds+0qJFIAjm1D8c3VTbl3DzKdjopYiJrxp0zvSQ9rBryKA1dXqS5EL
plifVsb8sk4bnkHwnyyh
=obgG
-----END PGP SIGNATURE-----

--Sig_/qZBRbNu/ED+QJQuE/h27X/S--
