Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:40156 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbaEZRCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 13:02:25 -0400
Date: Mon, 26 May 2014 23:02:18 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Cc: David Bloquel <david.bloquel@jimywoo.fr>
Subject: Re: Btrfs filesystem freezing during snapshots
Message-ID: <20140526230218.00d4ea24@natsu>
In-Reply-To: <20140526223916.25dfea52@natsu>
References: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
	<20140526223916.25dfea52@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=gHygeAW2=.fz1PjzoQKRnE"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/=gHygeAW2=.fz1PjzoQKRnE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 May 2014 22:39:16 +0600
Roman Mamedov <rm@romanrm.net> wrote:

> On Mon, 26 May 2014 14:28:51 +0200
> David Bloquel <david.bloquel@jimywoo.fr> wrote:
>=20
> > [69537.117439]       Not tainted 3.12-0.bpo.1-amd64 #1
>=20
> Try upgrading to the kernel 3.14. From what I can tell it has significant
> improvements/bugfixes in the snapshot deletion area. Just a couple of day=
s ago
> I got a recurring lock-up after deleting 50 snapshots with tens of thousa=
nds of
> fragments of files in each (VM images, like in your case). Googled around=
 a
> little bit, and found a similar issue with a report that 3.14 solves the
> problem. Upgraded to 3.14.4 (from 3.12.20), and voila, indeed it does.

Oh, I missed that your freezing happens during snapshot creation, not
deletion. But anyways, I think checking if the problem persists on the newe=
st
kernel is still a good idea.

--=20
With respect,
Roman

--Sig_/=gHygeAW2=.fz1PjzoQKRnE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlODc5oACgkQTLKSvz+PZwiJFwCff7uZ6mndgXaMjmo8UBXYTW8Y
JdEAnjbfo7UxXd+VWwlGLzqSbsNqQhmy
=XGjP
-----END PGP SIGNATURE-----

--Sig_/=gHygeAW2=.fz1PjzoQKRnE--
