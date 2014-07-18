Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:37178 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaGRNFb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 09:05:31 -0400
Date: Fri, 18 Jul 2014 19:05:24 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
Message-ID: <20140718190524.143439e1@natsu>
In-Reply-To: <20140718053422.78784982@ws>
References: <1405627978.2630.39.camel@s-Air>
	<e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
	<pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
	<TmvW1o01t4NXQGV01mvYsU>
	<20140718053422.78784982@ws>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WiVpGdKG6Q7RppV3SNxO4cD"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/WiVpGdKG6Q7RppV3SNxO4cD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2014 05:34:22 -0700
Duncan <1i5t5.duncan@cox.net> wrote:

> Effectively, admins can choose NOCOW XOR frequent-snapshotting, altho
> the fact that snapshots stop at subvolume borders can be used as a
> partial workaround, by putting NOCOW files on a dedicated partition and
> not snapshotting it, exactly as I mentioned.

You can't backup running VM images and datafiles of an active database using
"traditional" backup techniques such as file copy or rsync. The tail of a f=
ile
you're copying for a backup will be long-inconsistent with the overall state
or the head of the file when you started copying. Snapshots on the other ha=
nd
are atomic, and can very much be used to create a static copy of the files =
for
the purposes of compressing/copying away somewhere. And at worst, the
"restored from backup" state of such a backed up VM or DB will be equivalent
to it just having had a power-loss. Journalling FSes and databases can deal
with that with no major problems.

So just exercise moderation, snapshot e.g. once an hour or even a day, the
result will still be better than not using NOCOW, and will deliver most of =
the
benefits you get by snapshotting.

Another option is to snapshot->backup->delete snapshot.

--=20
With respect,
Roman

--Sig_/WiVpGdKG6Q7RppV3SNxO4cD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPJG5QACgkQTLKSvz+PZwgZTwCfdEgpiCZ63LOhVQfRtQfCrOKo
M7cAn1p1L6izOkE38N8JXqy5O/8HG9s8
=fxzo
-----END PGP SIGNATURE-----

--Sig_/WiVpGdKG6Q7RppV3SNxO4cD--
