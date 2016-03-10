Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:58746 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbcCJIdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 03:33:39 -0500
Date: Thu, 10 Mar 2016 13:33:34 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] df returns 100% used for empty mixed block group
 filesystem
Message-ID: <20160310133334.1528bc88@natsu>
In-Reply-To: <CAJCQCtRzt-BeoW9KNQC3kmBXw8MoydJv7Qy8fu0HmF3hAOgFRQ@mail.gmail.com>
References: <CAJCQCtRzt-BeoW9KNQC3kmBXw8MoydJv7Qy8fu0HmF3hAOgFRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oPtKFYzRjnw/6t99guYD5./"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/oPtKFYzRjnw/6t99guYD5./
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Mar 2016 01:24:44 -0700
Chris Murphy <lists@colorremedies.com> wrote:

> kernel 4.5.0 rc7
> btrfs-progs-4.4.1-1
>=20
> Summary: A new empty mixed block group "-M" filesystem shows up as
> 100% full with regular df (gnu coreutils 8.24). Pretty sure this is
> not a regression, but no regression testing done.
>=20
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D114281

Just guessing here, but this might be related?

  [PATCH] btrfs: statfs: report zero available if metadata are exhausted
  http://www.spinics.net/lists/linux-btrfs/msg48013.html

Maybe some maths there are wrong in case of a mixed blockgroup filesystem.

--=20
With respect,
Roman

--Sig_/oPtKFYzRjnw/6t99guYD5./
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbhMWAACgkQTLKSvz+PZwja2wCeMe4NqNGEbkxFa8uAKDQrkruu
jMgAn0B9/tjhc46o9BknI7Y+jUAVw7TP
=j1sr
-----END PGP SIGNATURE-----

--Sig_/oPtKFYzRjnw/6t99guYD5./--
