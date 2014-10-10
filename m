Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:56915 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaJJK7F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 06:59:05 -0400
Date: Fri, 10 Oct 2014 16:59:02 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
Message-ID: <20141010165902.36262e8e@natsu>
In-Reply-To: <5437BAB2.1040605@shiftmail.org>
References: <54358C77.2070808@redhat.com>
	<9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
	<5437BAB2.1040605@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9waolaq=/LNtBVkM7o3m3ZU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9waolaq=/LNtBVkM7o3m3ZU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Oct 2014 12:53:38 +0200
Bob Marley <bobmarley@shiftmail.org> wrote:

> On 10/10/2014 03:58, Chris Murphy wrote:
> >
> >> * mount -o recovery
> >> 	"Enable autorecovery attempts if a bad tree root is found at mount ti=
me."
> > I'm confused why it's not the default yet. Maybe it's continuing to evo=
lve at a pace that suggests something could sneak in that makes things wors=
e? It is almost an oxymoron in that I'm manually enabling an autorecovery
> >
> > If true, maybe the closest indication we'd get of btrfs stablity is the=
 default enabling of autorecovery.
>=20
> No way!
> I wouldn't want a default like that.
>=20
> If you think at distributed transactions: suppose a sync was issued on=20
> both sides of a distributed transaction, then power was lost on one=20
> side

What distributed transactions? Btrfs is not a clustered filesystem[1], it d=
oes
not support and likely will never support being mounted from multiple hosts=
 at
the same time.

[1]http://en.wikipedia.org/wiki/Clustered_file_system

--=20
With respect,
Roman

--Sig_/9waolaq=/LNtBVkM7o3m3ZU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlQ3u/YACgkQTLKSvz+PZwhqkgCdHfQscp1PsP9mZF3tUbQmIPXl
olIAniRflu/nhNsaDp6hK5zzQRQcDGkI
=yxbq
-----END PGP SIGNATURE-----

--Sig_/9waolaq=/LNtBVkM7o3m3ZU--
