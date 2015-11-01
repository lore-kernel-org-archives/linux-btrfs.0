Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:49144 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbKANsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 08:48:47 -0500
Date: Sun, 1 Nov 2015 18:48:44 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ken Long <kelargo1000@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: trying to balance, filesystem keeps going read-only.
Message-ID: <20151101184844.0d67e5e2@natsu>
In-Reply-To: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3u1MQJ9lYBuEL4_gL.q=109"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3u1MQJ9lYBuEL4_gL.q=109
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Nov 2015 06:24:53 -0500
Ken Long <kelargo1000@gmail.com> wrote:

> Well, one drive is 8TB with a 5TB partition.

Is this by any chance a Seagate "SMR" drive? From what I remember seeing on
the list, those do not work well with Btrfs currently, with symptoms very
similar to what you're seeing.

--=20
With respect,
Roman

--Sig_/3u1MQJ9lYBuEL4_gL.q=109
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlY2GDwACgkQTLKSvz+PZwgalgCfSLwHwEfDKqY9djubH526OoSG
zIUAmwVj+4ODzNUbFmg8vZ16TMMXX1IQ
=OpSc
-----END PGP SIGNATURE-----

--Sig_/3u1MQJ9lYBuEL4_gL.q=109--
