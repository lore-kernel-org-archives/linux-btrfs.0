Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:44786 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaBIBzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 20:55:39 -0500
Date: Sun, 9 Feb 2014 07:55:33 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140209075533.26b4b730@natsu>
In-Reply-To: <9hqisa-46c.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
	<20140208173310.1f90af3b@natsu>
	<9hqisa-46c.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fPZx=VYfCqtFrzXD5lCbISu"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fPZx=VYfCqtFrzXD5lCbISu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 09 Feb 2014 00:17:29 +0100
Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> "Dear employees,
>=20
> Please keep in mind that when you run out of space on the fileserver=20
> '\\DepartmentC', when you free up space in the directory '\PublicStorage7=
'=20
> the free space you gain on '\StorageArchive' is only one third of the amo=
unt=20
> you deleted, and in '\VideoFiles', you gain only one half.

But that's simply incorrect. Looking at my 2nd patch which also changes the
total reported size and 'used' size, the 'total' space, 'used' space and sp=
ace
freed up as 'available' after file deletion will all match up perfectly.

> The exercise of why is left to the reader...
>=20
> The proposed fix simply does not fix the problem. It simply shifts it=20
> introducing the need for another fix somewhere else, which in turn probab=
ly=20
> also introduces another need for a fix, and so forth... This will become =
an=20
> endless effort of fixing and tuning.

Not sure what exactly becomes problematic if a 2-device RAID1 tells the user
they can store 1 TB of their data on it, and is no longer lying about the=20
possibility to store 2 TB on it as currently.

Two 1TB disks in RAID1. Total space 1TB. Can store of my data: 1TB.
Wrote 100 GB of files? 100 GB used, 900 GB available, 1TB total.
Deleted 50 GB of those? 50 GB used, 950 GB available, 1TB total.

Can't see anything horribly broken about this behavior.

For when you need to "get to the bottom of things", as mentioned earlier
there's always 'btrfs fi df'.

> Feel free to fix it but be prepared for the reincarnation of this problem=
 when
> per-subvolume raid levels become introduced.

AFAIK no one has even begun to write any code code to implement those yet.

--=20
With respect,
Roman

--Sig_/fPZx=VYfCqtFrzXD5lCbISu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL24BUACgkQTLKSvz+PZwh6fgCfe/iZmk0bb1UpJA2MKAVyhXNz
HSYAnR3trqSCbJ4XC3+GmBDLoL45laLW
=A62Y
-----END PGP SIGNATURE-----

--Sig_/fPZx=VYfCqtFrzXD5lCbISu--
