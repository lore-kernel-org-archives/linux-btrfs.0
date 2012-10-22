Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35874 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2JVMfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 08:35:03 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1007990bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 05:35:01 -0700 (PDT)
Message-ID: <50853D67.9050108@grimmer.com>
Date: Mon, 22 Oct 2012 14:34:47 +0200
From: Lenz Grimmer <lenz@grimmer.com>
MIME-Version: 1.0
To: Rory Campbell-Lange <rory@campbell-lange.net>
CC: Miao Xie <miaox@cn.fujitsu.com>, Anand jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] filter snapshot(s) by its parent uuid
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com> <50810363.1090304@cn.fujitsu.com> <20121019083752.GA19887@campbell-lange.net>
In-Reply-To: <20121019083752.GA19887@campbell-lange.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig911340D42583902B424820DB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig911340D42583902B424820DB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/19/2012 10:37 AM, Rory Campbell-Lange wrote:

> From my perspective as a user I would be grateful if the following chan=
ges in
> syntax for listing subvolumes could be considered:
>=20
> In addition to=20
>=20
>     btrfs subvolume list [-apurts] [-g [+|-]value] [-c [+|-]value] [--s=
ort=3Dgen,ogen,rootid,path] <path>
>     btrfs su list [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=3Dg=
en,ogen,rootid,path] <path>
>         List subvolumes (and snapshots)
>     (and Anand's patch to allow <path>/<subpath>)
>=20
> I believe the following shortcuts may be useful
>=20
>     btrfs subvolumes [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=3D=
gen,ogen,rootid,path] <path>[</subpath>]
>     btrfs sl [-apurts] [-g [+|-]value] [-c [+|-]value] [--sort=3Dgen,og=
en,rootid,path] <path>[</subpath>]
>=20
> Although from a technical perspective 'subvolume list' may be logical, =
listing
> subvolumes (plural) seems like a different sort of operation to those r=
elating
> to a subvolume (singular) for create/alter/show/delete/snapshot operati=
ons.

+1 to this proposal (FWIW) - thanks for making the user interface more
intuitive :)

--=20
  Lenz Grimmer <lenz@grimmer.com> - http://www.lenzg.net/


--------------enig911340D42583902B424820DB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlCFPWcACgkQSVDhKrJykfIrvwCfYnfFr9vq7rK7S22sEQ1asYAJ
/S0An0Ah3b0rwDjnL0gsywQPah5hWFEG
=Oz2D
-----END PGP SIGNATURE-----

--------------enig911340D42583902B424820DB--
