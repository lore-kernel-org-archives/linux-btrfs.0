Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:37608 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcDRO0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 10:26:25 -0400
Date: Mon, 18 Apr 2016 19:26:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Henk Slager <eye1tm@gmail.com>
Cc: sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image and btrfs send related queries
Message-ID: <20160418192619.4749bc17@natsu>
In-Reply-To: <CAPmG0jbDDG+aLHn+ymBT1Mbd2UZg17rDiwYXu8AYoxb666GXMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dLv5kR0+8j04DBEKF_Cx18W"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>
 <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>
 <loom.20160418T092105-74@post.gmane.org>
 <CAPmG0jbDDG+aLHn+ymBT1Mbd2UZg17rDiwYXu8AYoxb666GXMA@mail.gmail.com>

--Sig_/dLv5kR0+8j04DBEKF_Cx18W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Apr 2016 16:13:28 +0200
Henk Slager <eye1tm@gmail.com> wrote:

> (your email keeps ending up in gmail spam folder)
>=20
> On Mon, Apr 18, 2016 at 9:24 AM, sri <toyours_sridhar@yahoo.co.in> wrote:
> > I tried btrfs-image and created image file and ran btrfs-image -r to a
> > different disk. Once recovered and mounted, I can able to see data is
> > not zeroed out as mentioned in btrfs-image man page.
>=20
> "different disk"  you mention, that is important info. If you doe the
> restore to a image file, that image file is sparse and all data blocks
> are read as zeros.
>=20
> However, if you restore to a block device, then you can assume it just
> writes the device blocks for metadata and leaves the rest untouched.
> So trim whole device first or brute-force overwrite completely with
> zeros.
>=20
> So maybe the man pages needs some correction / extra notes.
>=20
> > I tried on same machine.

Does btrfs-image store/restore the FS UUID? If it does, then potentially bo=
th
the source FS and the restored one were visible at the same time to the ker=
nel
with identical UUIDs, and maybe it was actually accessing/mounting the sour=
ce
one.

--=20
With respect,
Roman

--Sig_/dLv5kR0+8j04DBEKF_Cx18W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcU7o4ACgkQTLKSvz+PZwjehQCfUDiZb9RW7hnFMzgkgftfckT/
qAsAn3DSRZnLOb5IRqv3T/esL45mHhQd
=HzLC
-----END PGP SIGNATURE-----

--Sig_/dLv5kR0+8j04DBEKF_Cx18W--
