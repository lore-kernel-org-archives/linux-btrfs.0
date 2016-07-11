Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:33526 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcGKN4T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 09:56:19 -0400
Date: Mon, 11 Jul 2016 18:56:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs won't mount to /home
Message-ID: <20160711185613.0f03d47b@natsu>
In-Reply-To: <b44f915ca2d728f0fde9848f09524ecb@admin.virtall.com>
References: <b44f915ca2d728f0fde9848f09524ecb@admin.virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/95Y2R4M.hIrJJ9zrl_OB174"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/95Y2R4M.hIrJJ9zrl_OB174
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jul 2016 22:45:13 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:
=20
> So, weird, isn't it?
>
> What's wrong there?

Your systemd unmounts it immediately from /home, search the archives there's
been a funny story like that recently.

--=20
With respect,
Roman

--Sig_/95Y2R4M.hIrJJ9zrl_OB174
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAleDpX8ACgkQTLKSvz+PZwjuVwCeM+4pQz6NF+jAX2DrHaMD++Es
Ip8Ani+JblBvxbPNPnVkk0JVItETB9/8
=GnJh
-----END PGP SIGNATURE-----

--Sig_/95Y2R4M.hIrJJ9zrl_OB174--
