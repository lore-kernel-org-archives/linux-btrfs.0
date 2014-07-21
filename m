Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52242 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaGUWbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 18:31:06 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LanoO-1Wgf7Q1dTE-00kOEn for
 <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 00:31:04 +0200
Date: Tue, 22 Jul 2014 00:30:57 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140722003057.0f3b89f0@marcec>
In-Reply-To: <20140721152216.27d8a4c4@marcec>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec>
	<20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec>
	<20140721152216.27d8a4c4@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/EWZ+L=XK/94m9w_m=z4nSPK"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/EWZ+L=XK/94m9w_m=z4nSPK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Mon, 21 Jul 2014 15:22:16 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> Am Sun, 20 Jul 2014 21:44:40 +0200
> schrieb Marc Joliet <marcec@gmx.de>:
>=20
> [...]
> > What I did:
> >=20
> > - delete the single largest file on the file system, a 12 GB VM image, =
along
> >   with all subvolumes that contained it
> > - rsync it over again
> [...]
>=20
> I want to point out at this point, though, that doing those two steps fre=
ed a
> disproportionate amount of space.  The image file is only 12 GB, and it h=
adn't
> changed in any of the snapshots (I haven't used this VM since June), so t=
hat
> "subvolume delete -c <snapshots>" returned after a few seconds. Yet delet=
ing it
> seems to have freed up twice as much. You can see this from the "filesyst=
em df"
> output: before, "used" was at 229.04 GiB, and after deleting it and copyi=
ng it
> back (and after a day's worth of backups) went down to 218 GiB.
>=20
> Does anyone have any idea how this happened?
>=20
> Actually, now I remember something that is probably related: when I first
> moved to my current backup scheme last week, I first copied the data from=
 the
> last rsnapshot based backup with "cp --reflink" to the new backup locatio=
n, but
> forgot to use "-a".  I interrupted it and ran "cp -a -u --reflink", but i=
t had
> already copied a lot, and I was too impatient to start over; after all, t=
he
> data hadn't changed.  Then, when rsync (with --inplace) ran for the first=
 time,
> all of these files with wrong permissions and different time stamps were =
copied
> over, but for some reason, the space used increased *greatly*; *much* mor=
e than
> I would expect from changed metadata.
>=20
> The total size of the file system data should be around 142 GB (+ snapsho=
ts),
> but, well, it's more than 1.5 times as much.
>=20
> Perhaps cp --reflink treats hard links differently than expected?  I woul=
d have
> expected the data pointed to by the hard link to have been referenced, but
> maybe something else happened?

Hah, OK, apparently when my daily backup removed the oldest daily snapshot,=
 it
freed up whatever was taking up so much space, so as of now the file system
uses only 169.14 GiB (from 218).  Weird.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/EWZ+L=XK/94m9w_m=z4nSPK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzZSmAAoJEL/Q5oYsiHj0Nq4P/1lyNC638XIZ/m835vEYDx41
V/bWxdS3ZDTwzK9G1n3YayBtFoolTMSHvKI6VIBmY9O5Lo/vg9Z1AW5LjHEuXGxk
UFJJ8x1mjJvFPKZ67HPy5ROInW9SdHGWGhMByuHnygfDAJ2Bg7VUMP8YwQBNisdv
xoY/hfaHpPOY7+/DjtUK7PueMsh7Op0l3gxT9neCin4aeh9FdX8CLA2na9p2VsIk
V4g965S9yikGlas5ZiwGKte8liQUU8x4EG4KGM7wSN73ryVpl1ZjMiRhGypsC2PR
JRxLVNFMprcnkzh/i4tUck4MrA3rDbZtL0eVkjm8/+/zVtiqYfH2CatKl7UsSg2/
yU8TcPAvSNSenH6o9aBoNQdZ/2LosqYhp1BZrUL8dUfsHqkTMnOJD0Pz3/+L9QhH
1bWqXmpTLdQKpGJzyUkB1lzdejNflyvtXLavfucTJNpTsTHzSB4/W3iY6H0eQpuo
AHDN+qp5VtrUo6OgtkQZc09MuNQnlbyYvdg45pu+nioX3GHFZ+p5ZZsmyOvyFADg
9B9rhXXwzuYtCpxoC6VuMm/45bvppRGd/bKZz40ZyTldFvTrdACxXRXEgM8KnP3A
ECs7os1ugPaCTuwrliimuVUF4eWTlvA1c7ydoohk88ndCM53hlZwDWFP/uXaJHzI
kWS6DIdeY82t9AKVUTz2
=7HTg
-----END PGP SIGNATURE-----

--Sig_/EWZ+L=XK/94m9w_m=z4nSPK--
