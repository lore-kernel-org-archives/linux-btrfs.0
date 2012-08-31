Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:41593 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2HaFCh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:02:37 -0400
Date: Fri, 31 Aug 2012 11:02:34 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Message-ID: <20120831110234.031e23ee@natsu>
In-Reply-To: <201208302334.49399.Martin@lichtvoll.de>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
	<20120830162512.GA2879@localhost.localdomain>
	<201208302334.49399.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R=i2kfVrveG5jRI/2UbdRHY"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/R=i2kfVrveG5jRI/2UbdRHY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Aug 2012 23:34:49 +0200
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> I wanted to ask about 32k either.
>=20
> I used 32k on one 2,5 inch external esata disk. But I never measured=20
> anything so far.
>=20
> I wonder what a good value for SSD might be. I tend to not use anymore=20
> than 16k, but thats just some gut feeling right now. Nothing based on a=20
> well-founded explaination.

If you look closely at https://oss.oracle.com/~mason/blocksizes/ , you will
notice that 16K delivers almost all of the 32K's performance gains in "Read=
",
while not suffering from slowdowns that 32K shows in "Create" and "Delete".

I have chosen 16K for my new /home partition (on an SSD+HDD mdadm RAID1).
But what disappointed me at the time, is that one can't seem to have a "mix=
ed"
allocation FS with non-default leaf/node sizes.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/R=i2kfVrveG5jRI/2UbdRHY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBARWoACgkQTLKSvz+PZwiK+gCeI72syQypXyxvJhh15OXC/Thl
LTwAni/iXZNcj96Z7gLfXWaTxVHUxDop
=xhQu
-----END PGP SIGNATURE-----

--Sig_/R=i2kfVrveG5jRI/2UbdRHY--
