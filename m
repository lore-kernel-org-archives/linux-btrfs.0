Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:44681 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaBHLdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 06:33:14 -0500
Date: Sat, 8 Feb 2014 17:33:10 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140208173310.1f90af3b@natsu>
In-Reply-To: <agsfsa-mks.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c/7A6mWVtDTkOf+N_rYWmPt"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/c/7A6mWVtDTkOf+N_rYWmPt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Feb 2014 21:32:42 +0100
Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> It should show the raw space available. Btrfs also supports compression a=
nd=20
> doesn't try to be smart about how much compressed data would fit in the f=
ree=20
> space of the drive. If one is using RAID1, it's supposed to fill up with =
a=20
> rate of 2:1. If one is using compression, it's supposed to fill up with a=
=20
> rate of maybe 1:5 for mostly text files.

Imagine a small business with some 30-40 employees. There is a piece of pap=
er
near the door at the office so that everyone sees it when entering or leavi=
ng,
which says:

"Dear employees,

Please keep in mind that on the fileserver '\\DepartmentC', in the directory
'\PublicStorage7' the free space you see as being available needs to be div=
ided
by two; On the server '\\DepartmentD', in '\StorageArchive' and '\VideoFile=
s',
multiplied by two-thirds. For more details please contact the IT operations
team. Further assistance will be provided at the monthly training seminar.

Regards,
John S, CTO.'

--=20
With respect,
Roman

--Sig_/c/7A6mWVtDTkOf+N_rYWmPt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL2FfYACgkQTLKSvz+PZwhtEwCgiAixxXrZoAj+sUxIwMAVWJWn
5voAnA5fCx1EYEQDnzpfwpYfy4W21lwr
=4XfR
-----END PGP SIGNATURE-----

--Sig_/c/7A6mWVtDTkOf+N_rYWmPt--
