Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:47126 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3CKGLs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 02:11:48 -0400
Date: Mon, 11 Mar 2013 12:11:43 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Michael Johnson - MJ <mj@revmj.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: snapshot deletion / unmount slowness
Message-ID: <20130311121143.5cfa69d8@natsu>
In-Reply-To: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qucWI27pRzXDeEV+6yrZkK/"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/qucWI27pRzXDeEV+6yrZkK/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Mar 2013 22:31:08 -0700
Michael Johnson - MJ <mj@revmj.com> wrote:

> What I now suspect is going on is that while deleting the snapshots
> was quick, that probably kicks of a background thread which actually
> does the heavy lifting.

Exactly that, the snapshot deletion only "syncs" on unmount, there is no
other way to ensure it is complete.

If you have some patience and let it unmount properly and then remount it, =
you
may find that you have gained much more free space, due to all the snapshots
being actually deleted and the space they were occupying freed only just no=
w.

--=20
With respect,
Roman

--Sig_/qucWI27pRzXDeEV+6yrZkK/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlE9dZ8ACgkQTLKSvz+PZwhQPQCeOm1sk2LO4+n55eHMC8rgeQff
0XcAnRkNYEe4rA27i51qtOcsK5UF2Z0Y
=uqPl
-----END PGP SIGNATURE-----

--Sig_/qucWI27pRzXDeEV+6yrZkK/--
