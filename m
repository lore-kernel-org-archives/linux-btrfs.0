Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33937 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3BIR6X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 12:58:23 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so2395817eek.11
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2013 09:58:21 -0800 (PST)
Date: Sat, 9 Feb 2013 20:57:42 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add static compile target
Message-ID: <20130209205742.00907573@sf>
In-Reply-To: <1360365569-18996-1-git-send-email-pomac@demius.net>
References: <1360365569-18996-1-git-send-email-pomac@demius.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+7pdAwcnz3HUzkUQ_rbeHmB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/+7pdAwcnz3HUzkUQ_rbeHmB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  9 Feb 2013 00:19:29 +0100
Ian Kumlien <pomac@demius.net> wrote:

> Sometimes, when you least expect it, a static binary is what you need to
> rescue your data... Or just get a good enough handle on things to make
> it work again ;)
>=20
> "make static" is a gift to you, dear user with filesystem problems!

What's wrong with conventional LDFLAGS=3D-static make?

> Anyway, on a more serious note, changed the cflags and ldflags so that
> we create a smaller binary, 1.1MB stripped on my 64 bit system
> (2.7MB with debug data)
>=20

--=20

  Sergei

--Sig_/+7pdAwcnz3HUzkUQ_rbeHmB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEWjhkACgkQcaHudmEf86qT4wCdEtCR5XgdRfdgg/QesBKt9Ls6
miwAni0a4oAJxBbulmcsxntj2rTOuwvZ
=zc5r
-----END PGP SIGNATURE-----

--Sig_/+7pdAwcnz3HUzkUQ_rbeHmB--
