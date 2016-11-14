Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46264 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbcKNS2G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:28:06 -0500
Date: Mon, 14 Nov 2016 13:27:58 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: James Pharaoh <james@wellbehavedsoftware.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114182756.GG21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8sQsHfNlXZNubEnG"
In-Reply-To: <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8sQsHfNlXZNubEnG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2016 at 12:06:01PM +0100, Niccol=F2 Belli wrote:
> Nice, you should probably update the btrfs wiki as well, because there is=
 no
> mention of btrfs-dedupe.
>=20
> First question, why this name? Don't you plan to support xfs as well?

Does XFS plan to support LOGICAL_INO, INO_PATHS, and something analogous
to SEARCH_V2?

POSIX API + FILE_EXTENT_SAME is OK for the lowest common denominator
across arbitrary filesystems, but a btrfs-specific tool can do a lot
better.  Especially for incremental dedup and low-RAM algorithms.


--8sQsHfNlXZNubEnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgqAisACgkQgfmLGlazG5xjmgCeLzzDBJaZ1hL3XFH7V3F72Zpe
Rr0AoL8V7VKrvknPVoh+BG4G2ZVsWedV
=ciRx
-----END PGP SIGNATURE-----

--8sQsHfNlXZNubEnG--
