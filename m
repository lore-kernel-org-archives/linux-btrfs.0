Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:57892 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNSLO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 13:11:14 -0500
Date: Sat, 15 Feb 2014 00:11:10 +0600
From: Roman Mamedov <rm@romanrm.net>
To: kreijack@inwind.it
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
Message-ID: <20140215001110.76d8226f@natsu>
In-Reply-To: <52FE58EF.1060901@libero.it>
References: <1392318441-9224-1-git-send-email-kreijack@libero.it>
	<52FD1AD6.50500@libero.it>
	<20140214012810.26297146@natsu>
	<52FD21B4.4050502@libero.it>
	<20140214030045.415e21da@natsu>
	<52FE58EF.1060901@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J30A8EwFEAag.mOFrgR8XAd"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/J30A8EwFEAag.mOFrgR8XAd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Feb 2014 18:57:03 +0100
Goffredo Baroncelli <kreijack@libero.it> wrote:

> On 02/13/2014 10:00 PM, Roman Mamedov wrote:
> > On Thu, 13 Feb 2014 20:49:08 +0100
> > Goffredo Baroncelli <kreijack@libero.it> wrote:
> >=20
> >> Thanks for the comments, however I don't like du not usage; but you ar=
e right=20
> >> when you don't like "disk-usage". What about "btrfs filesystem chunk-u=
sage" ?
> >=20
> > Personally I don't see the point of being super-pedantic here, i.e. "lo=
ok this
> > is not just filesystem usage, this is filesystem CHUNK usage"... Consis=
tency
> > of having a matching "dev usage" and "fi usage" would have been nicer.
>=20
>=20
> What about "btrfs filesystem chunk-usage" ?=20

Uhm? Had to reread this several times, but it looks like you're repeating
exactly the same question that I was already answering in the quoted part.

To clarify even more, personally I'd like if there would have been "btrfs d=
ev
usage" and "btrfs fi usage". Do not see the need to specifically make the 2=
nd
one "chunk-usage" instead of simply "usage".

--=20
With respect,
Roman

--Sig_/J30A8EwFEAag.mOFrgR8XAd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL+XD4ACgkQTLKSvz+PZwgksACbBLqvY7ZrzjhAUoyxp3l8NgX5
lLIAniMtB5nW0ZuI3D+Y30PwJCJaTJdJ
=iL0u
-----END PGP SIGNATURE-----

--Sig_/J30A8EwFEAag.mOFrgR8XAd--
