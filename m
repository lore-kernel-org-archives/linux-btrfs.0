Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbbHNVhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 17:37:45 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx003) with ESMTPSA
 (Nemesis) id 0Lu874-1YgoW91nHC-011Vfe for <linux-btrfs@vger.kernel.org>; Fri,
 14 Aug 2015 23:37:43 +0200
Date: Fri, 14 Aug 2015 23:37:37 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Deleted files cause btrfs-send to fail
Message-ID: <20150814233737.5403f9fe@thetick>
In-Reply-To: <20150813105458.676c884a@thetick>
References: <20150813003419.09f13c1a@thetick>
	<20150813090541.77f5c821@thetick>
	<pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
	<20150813105458.676c884a@thetick>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/vn1jjE9o5DdM_+SsC4M.WYw"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/vn1jjE9o5DdM_+SsC4M.WYw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Thu, 13 Aug 2015 10:54:58 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> Am Thu, 13 Aug 2015 08:29:19 +0000 (UTC)
> schrieb Duncan <1i5t5.duncan@cox.net>:
>=20
> > Marc Joliet posted on Thu, 13 Aug 2015 09:05:41 +0200 as excerpted:
> >=20
> > > Here's the actual output now, obtained via btrfs-progs 4.0.1 from an
> > > initramfs emergency shell:
> > >=20
> > > checking extents checking free space cache checking fs roots root 5
> > > inode 8338813 errors 2000, link count wrong
> > >         unresolved ref dir 26699 index 50500 namelen 4 name root
> > >         filetype 0 errors 3, no dir item, no dir index
> > > root 5 inode 8338814 errors 2000, link count wrong
> > >         unresolved ref dir 26699 index 50502 namelen 6 name marcec
> > >         filetype 0 errors 3, no dir item, no dir index
> > > root 5 inode 8338815 errors 2000, link count wrong
> > >         unresolved ref dir 26699 index 50504 namelen 6 name systab
> > >         filetype 0 errors 3, no dir item, no dir index
> > > root 5 inode 8710030 errors 2000, link count wrong
> > >         unresolved ref dir 26699 index 59588 namelen 6 name marcec
> > >         filetype 0 errors 3, no dir item, no dir index
> > > root 5 inode 8710031 errors 2000, link count wrong
> > >         unresolved ref dir 26699 index 59590 namelen 4 name root
> > >         filetype 0 errors 3, no dir item, no dir index
> > > Checking filesystem on /dev/sda1 UUID:
> > > 0267d8b3-a074-460a-832d-5d5fd36bae64 found 63467610172 bytes used err=
 is
> > > 1 total csum bytes: 59475016 total tree bytes: 1903411200 total fs tr=
ee
> > > bytes: 1691504640 total extent tree bytes: 130322432 btree space waste
> > > bytes: 442495212 file data blocks allocated: 555097092096
> > >  referenced 72887840768
> > > btrfs-progs v4.0.1
> > >=20
> > > Again: is this fixable?
> >=20
> > FWIW, root 5 (which you asked about upthread) is the main filesystem=20
> > root.  So all these appear to be on the main filesystem, not on snapsho=
ts/
> > subvolumes.
>=20
[...]
> > But if it's critical, you may wish to wait and have someone else confir=
m=20
> > that before acting on it, just in case I have it wrong.
>=20
> I can wait until tonight, at least.  The FS still mounts, and it's just t=
he root
> subvolume that's affected; running btrfs-send on the /home subvolume still
> works.

Well, I got impatient, and just went ahead and did it (I have backups, after
all).  It looks like it worked: the affected files were moved to /lost+foun=
d/,
where I deleted them again, and btrfs-send works again.  The output of "btr=
fs
check" after --repair:

checking extents
checking free space cache
checking fs roots
checking csums
There are no extents for csum range 0-69632
Csum exists for 0-69632 but there is no extent record
Checking filesystem on /dev/sda1
UUID: 0267d8b3-a074-460a-832d-5d5fd36bae64
block group 274307481600 has wrong amount of free spacefailed to load free =
space cache for block group 274307481600
found 60980420666 bytes used err is 1
total csum bytes: 57521732
total tree bytes: 1996800000
total fs tree bytes: 1791721472
total extent tree bytes: 127942656
btree space waste bytes: 460072661
file data blocks allocated: 478650343424
 referenced 73326161920
btrfs-progs v4.1.2

If I notice anything amiss, I'll report back.

(One other thing I found interesting was that "btrfs scrub" didn't care abo=
ut
the link count errors.)

Greetings.
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/vn1jjE9o5DdM_+SsC4M.WYw
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzl+mAAoJEL/Q5oYsiHj0jrsP/A7/+sE+DaA+vQiC5bu1C3L7
a0XPG6AOBiQ98nFkd7PHDW7XA0WBXrSJR+OpS6cQ/R8rATc88J2ortRU64STKceT
KSRiV6Z6LAhgOL9v3h1ecwXEhIEjB85vwkTNaCClQJEj8eVZ0GBK5/B+YsGlP+0G
+iNi9BTj6/hhyVwkh1qUT6yGwlnpAaKL+JFQO5dLIiWt/PhILvFIdeSUgnLIQ4gk
oraN/aLhY6lMUT7D1GrqvCUUErqRIf1RgRh+p9YyGB8igNmtE18F9AKuO++ySZTH
T3A7nmPbRyj5a48Ev8B/wlkhboRNDWBSyHfhZe3nPbMq9ph/MtH8oiD7NlvfFjVD
rmMbgS07kaZv5DCBjdsICJ+9EWs3/CHu7yaxC8DsckSki8FYCL/lBayJHshLaJbM
vJ0BxNH2sSFOsiYmBW/KaYpwbUe8Nq7+XC60FfaXFIW8EHIpUT0hWHHwFK/JEhSd
+Ca+KWQOw+WVCJfgCFcNFuZg+bZkwzoAKSs0uzogRTqX2FNPi3SX5qNuSuhvoyiF
7+O7jdmYl0P1CHw+WRA1CPuh22JRmM6onQrmyNDrmtvVTa/uXrNvOu06W0J9mVBR
tGHHmKgk5DJVzBcOY5g5E5ByEsqBj5a1IqgXFtp22DVfVsUTvPD2GsM2y5mEiQKr
kRh2PsohFdRNwHLY/Ylx
=RVoT
-----END PGP SIGNATURE-----

--Sig_/vn1jjE9o5DdM_+SsC4M.WYw--
