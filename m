Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:44522 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbbD0Red (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 13:34:33 -0400
Date: Mon, 27 Apr 2015 22:34:42 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: sri <toyours_sridhar@yahoo.co.in>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs freeze/thaw when using with LVM2
Message-ID: <20150427223442.47e254c4@natsu>
In-Reply-To: <20150427145549.GC18187@carfax.org.uk>
References: <loom.20150427T140306-446@post.gmane.org>
	<20150427121521.GB18187@carfax.org.uk>
	<loom.20150427T163556-13@post.gmane.org>
	<20150427145549.GC18187@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kJJq7k6mihPJ1+JA9+hoBU="; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/kJJq7k6mihPJ1+JA9+hoBU=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 14:55:49 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> > This is strange considering that I wanted a consistent snapshot of=20
> > entire btrfs filesystem at volume level.
> >=20
> > Is there a way to achive this? or btrfs just cannot provide?
>=20
>    No, there's no way to manage it with the current btrfs code.

Why not. fsfreeze, dd to a file (optionally with compression), unfreeze.

--=20
With respect,
Roman

--Sig_/kJJq7k6mihPJ1+JA9+hoBU=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU+czIACgkQTLKSvz+PZwjbDgCdF9BuclleV4h12EZC9JjjCNiA
wIYAn2z1WE+gcZ+5o1ChKC6RYgIvwxjC
=wF9I
-----END PGP SIGNATURE-----

--Sig_/kJJq7k6mihPJ1+JA9+hoBU=--
