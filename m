Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:49694 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3JOExM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 00:53:12 -0400
Date: Tue, 15 Oct 2013 10:53:06 +0600
From: Roman Mamedov <rm@romanrm.net>
To: David Madden <dhm@mersenne.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
Message-ID: <20131015105306.6a74ec5c@natsu>
In-Reply-To: <525CBF0D.1020609@mersenne.com>
References: <525CBF0D.1020609@mersenne.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/efDal+JVN8AYe/Z3+_QujfF"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/efDal+JVN8AYe/Z3+_QujfF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Oct 2013 21:05:33 -0700
David Madden <dhm@mersenne.com> wrote:

> I'd like to use BTRFS to do something like the old NetApp snapshot
> system: every hour or so, there'd be a snapshot, then the 23 of the
> snapshots during a day would be deleted, leaving just a day snapshot,
> then after a month, 6 of 7 snapshots would be deleted, leaving just a
> week snapshot, and so on.
>=20
> Is this a reasonable thing to do in a cron job with a BTRFS filesystem?
>  Apart from running out of space, are there any resources that might get
> used up?  Has anybody done this for a year or two in an active
> filesystem, and encountered success or weirdness?

Sure, that's one of the more awesome uses of btrfs.

But keep in mind that old snapshots on the same FS are not to be used inste=
ad
of a proper backup to external media/servers. If a block happened not to
change for a year, and it gets damaged on disk, it will become damaged in a=
ll
the snapshots all the way back to a year ago, and you lose that data.

--=20
With respect,
Roman

--Sig_/efDal+JVN8AYe/Z3+_QujfF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJcyjIACgkQTLKSvz+PZwgiwQCeNaBNlui4QJk76/9IgugBqF5A
ef0AnjQtEbE/VsC7Pr4/Eb9//DJl/k+v
=KyQo
-----END PGP SIGNATURE-----

--Sig_/efDal+JVN8AYe/Z3+_QujfF--
