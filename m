Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59728 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaA0Tbs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 14:31:48 -0500
Date: Mon, 27 Jan 2014 19:31:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: Gerhard Heift <gerhard@heift.name>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
Message-ID: <20140127193123.GO3314@carfax.org.uk>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <52E6AF3C.1070401@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y4VYWfdFdHwFhC6D"
In-Reply-To: <52E6AF3C.1070401@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y4VYWfdFdHwFhC6D
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 08:10:52PM +0100, Goffredo Baroncelli wrote:
> Hi,
>=20
> On 2014-01-27 14:28, Gerhard Heift wrote:
> > This patch series adds a new ioctl TREE_SEARCH_V2 with which we could s=
tore the
> > results in a varying buffer. Now even items larger than 3992 bytes or a=
 large
> > amount of items can be returned.
>=20
>=20
> One of the main strangeness of the current TREE_SEARCH ioctl, which I
> found is the fact that the search was not in a "rectangular" region, but
> in a "linear" region.

> This is due the fact that after a ioctl call, we have to set the min_*
> fields with the sh->{objectid,offset,type} +1 rounding to 0 if case of
> overflow.
>=20
> This because the min_* fields are both the "lower bound" of the search
> and the "starting point" of the next search. Adding a new set of fields
> named start_* could solve this issue.
>=20
> I discussed this topic few years ago in [1].
>=20
> Because we are introducing a new ioctl, is it possible to solve this
> issue ? We could avoid some userspace<->kernelspace transition, which
> seems be one of the goal of your patch.

   Aargh, not this again. :(

   The keyspace is *linear*, consisting of a concatenation of three
data fields, sorted lexically. This is how they're stored in the
trees, and it's how they're returned by TREE_SEARCH. You can't
traverse the keyspace with an O(1) "next" operation in anything other
than that order. Each tree represents a linear keyspace (because
that's the fundamental nature of the data structure).

   If you want to treat the keyspace as a 3-dimensional tuple space
(in a subspace of |N=B3), then you have to search separately in the tree
each time you come to the end of an (objectid, type, _) range. The
other alternative is to retrieve all of the linear range, and filter
out the unwanted keys whilst traversing the sequence.

   Bottom line: it's a linear data structure, not a 3-dimensional one.
Please treat it as such, otherwise things are going to get complicated
and confusing.

   Hugo.

> [1] http://www.spinics.net/lists/linux-btrfs/msg07617.html

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---     =20

--Y4VYWfdFdHwFhC6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUua0C1heFHXiqx3kAQKOCw/9HKDYJ6E79LJmYzI1Ed/D+RC9bE+rYF2/
TS03rhuDQm3AWJiAencwlVJw0z3ArgKNaaQP/QX+fzOb+ik2vVaDXOH9PNVKvDTG
Gb3tC0sPOnk3lBHEJQYRYwehMRZHWLgkNPwdRkoQAisRJWzlA0Rb4bklWpwm0zHp
zbWWFJjsOTLaejESM9is1rymTv5GGq9FMUpzJjWu8wyYXOuHc3I0jZcQkX5L2MZP
WOidnnxcTAK7FVr4SgmwzrCkpuPoQ5XLC2hICgRZVpY7LkohHeROy1XTgjlnNivq
G1FQJLDTS7xIhflGcnA3LFj1ukIW5yk1ncxKTegMi7n8A956+qOmYgoD40bnOaMR
1r/ab/t+mk+HPTm/rf4eyndKrYRGb4eVWc6fLgEP+gI28MtMULBILoBykFyBzozo
iXgpDAJEtivR2pC1Hg63FA5Y20EvZy5BP5J0XPKfL2Lsh0xpO9HtsaHJLriIepAC
6u7Q3SM3cNs4tPhBCbSuaz/J8Q4KcX5UINNeIfViBbCn1MHS5J/FXlZXe9qGELyI
FXy+fKjq4bjLjUWejMjKBkjiDhQCPwKk5c+wNtDYuPTIutTI1NEYu/bvxh+dlWEx
OKi8QtR1UWXU3d2eURX4iWtsbi6vI/wkLHYSYPbLeKPBeSc+O3bAFiC5rtZ5hVA2
DHuQAd/XbZI=
=mcZE
-----END PGP SIGNATURE-----

--Y4VYWfdFdHwFhC6D--
