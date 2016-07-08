Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbcGHBss (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 21:48:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8A166AAF4
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 01:48:46 +0000 (UTC)
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
To: linux-btrfs@vger.kernel.org
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Cc: David Sterba <DSterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
Date: Thu, 7 Jul 2016 21:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="v5aPCixrDDwT2bnckaIgpEofG2CnkLOSP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v5aPCixrDDwT2bnckaIgpEofG2CnkLOSP
Content-Type: multipart/mixed; boundary="lxkI1iHJqHH55dvJNptC2mNd665guRKNI"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <DSterba@suse.com>
Message-ID: <ad2900c1-b7d6-6fe0-f455-06e936355cc6@suse.com>
Subject: Re: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>

--lxkI1iHJqHH55dvJNptC2mNd665guRKNI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/24/16 6:14 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> One of the common complaints I've heard from new and experienced
> developers alike about the btrfs code is the ubiquity of
> struct btrfs_root.  There is one for every tree on disk and it's not
> always obvious which root is needed in a particular call path.  It can
> be frustrating to spend time figuring out which root is required only
> to discover that it's not actually used for anything other than
> getting the fs-global struct btrfs_fs_info.
>=20
> The patchset contains several sections.
>=20
> 1) The fsid trace event patchset I posted earlier; I can rebase without=
 this
>    but I'd prefer not to.
>=20
> 2) Converting btrfs_test_opt and friends to use an fs_info.
>=20
> 3) Converting tests to use an fs_info pointer whenever a root is used.
>=20
> 4) Moving sectorsize and nodesize to fs_info and cleaning up the
>    macros used to access them.

This change was a little overzealous in free-space-cache.c, which hit
block_group->sectorsize as well as root->sectorsize by accident.  While
the change is fine for general btrfs usage, it breaks the sanity tests
since dummy block groups now depend on a dummy fs_info as well.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--lxkI1iHJqHH55dvJNptC2mNd665guRKNI--

--v5aPCixrDDwT2bnckaIgpEofG2CnkLOSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXfwZ7AAoJEB57S2MheeWypiMP/13T6QihxcvyYx+CGLosF9tD
QDJ2SS2v5kFAhcG+Veb2cWwOw1eQ6v+rV56JjKXtaZk2pbqK515K78FJhPCst7gp
XfVMcdLOOOvquGgw01YEjJWv1s8oaaVcO4nhgtCoKlNKhbBGb4j3AU39YO33jYA5
dMXT2Cpw5PRp6TF64EyE9iEPt/daKoCftkJK1FzdDixcASPDXEFVmQaP4PtaPqn5
qBwW/PZAyQUf1tyzQK6h5/xxvQKNruL1Y9MMa0WEixx/62IDt/sL8K+73jflav1q
k0gseZO8v0gjONvL+xVu80LwtCYxjkbUGY+HRNEOoXlY1zr3+2JtuqMgc4eCFblO
fAS+pm5CBYfDB7WWIH+CHoNhp3pabK9gX3zNsv9kvE9vBP0phkl9Y+DNCYZuIvpO
QgDNu1Ut2jTZxnZcHTli19dnJx2nhYNOJd38hVdFnghanOJH4M+QngQOVP9L0hfX
HKZV6Chxs7Aq0JSsF/c1fa+be/O1wiHV3iEcbUWPqn08o5m+JxTgLoaaqIZkMpYU
BI+0Z3x4k2N+p5ei30xAcJfaKQ4Y5+B/X0t2UlRpA28NfIS8b66obEiE+mKlzJLc
i+pBiELk0YBTUE2e5Hp42dWs/nBoHYI8wwUhillFVGvKxKkYcx39896eLyczGUKN
cwOfgshzTfbDXeYFaOpy
=n0y+
-----END PGP SIGNATURE-----

--v5aPCixrDDwT2bnckaIgpEofG2CnkLOSP--
