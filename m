Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:59274 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3ANQVD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 11:21:03 -0500
Date: Mon, 14 Jan 2013 22:20:58 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
Message-ID: <20130114222058.4dc90a81@natsu>
In-Reply-To: <50F422BC.4000901@gmail.com>
References: <50F3E77B.2030901@gmail.com>
	<20130114145904.GA1387@shiny>
	<50F422BC.4000901@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nmO_u6Dg9R9J4t6/Pi.N_3d"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/nmO_u6Dg9R9J4t6/Pi.N_3d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Jan 2013 15:22:36 +0000
Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:

> 1) create a single drive default btrfs volume on single partition ->=20
> fill with test data -> scrub -> admire errors.

Did you try ruling out btrfs as the cause of the problem? Maybe something e=
lse
in your system is corrupting data, and btrfs just lets you know about that.

I.e. on the same drive, create an Ext4 filesystem, copy some data to it whi=
ch
has known checksums (use md5sum or cfv to generate them in advance for data
that is on another drive and is waiting to be copied); copy to that drive,
flush caches, verify checksums of files at the destination.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/nmO_u6Dg9R9J4t6/Pi.N_3d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD0MGoACgkQTLKSvz+PZwicpgCfRUFqzk+om47QFw9IwjUy7zH1
9iIAn0uF2QIUJqmG2607vzMrqpn5fWUI
=LDUs
-----END PGP SIGNATURE-----

--Sig_/nmO_u6Dg9R9J4t6/Pi.N_3d--
