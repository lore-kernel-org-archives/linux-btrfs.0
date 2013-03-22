Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:48619 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422788Ab3CVSMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 14:12:05 -0400
Date: Sat, 23 Mar 2013 00:12:01 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Ask =?UTF-8?B?QmrDuHJu?= Hansen <ask@develooper.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs "stuck" on
Message-ID: <20130323001201.2bbbb817@natsu>
In-Reply-To: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
References: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6etw650yfhaW5NkBaozgSjS"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/6etw650yfhaW5NkBaozgSjS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Mar 2013 11:56:37 -0700
Ask Bj=C3=B8rn Hansen <ask@develooper.com> wrote:

> Hello,
>=20
> A few weeks ago I replaced a ZFS backup system with one backed by btrfs. =
A script loops over a bunch of hosts rsyncing them to each their own subvol=
ume.  After each rsync I snapshot the "host-specific" subvolume.
>=20
> The "disk" is an iscsi disk that in my benchmarks performs roughly like a=
 local raid with 2-3 SATA disks.

I think you should re-verify if this is still the case. Maybe your block
device performance suddenly plummeted for some other unrelated issue?

The simplest test would be "hdparm -t /dev/sdc".

Personally I use btrfs on top of an MD raid accessed over network via NBD (=
and
AoE before), without any major issues. Though my workload is perhaps somewh=
at
lighter than what you describe.

--=20
With respect,
Roman

--Sig_/6etw650yfhaW5NkBaozgSjS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFMnvEACgkQTLKSvz+PZwhsuwCeLwUj0CV1inEMODSPc3JhpbZ6
WsgAnAnIbAAqvM6iADiLC2pEmIJZ22Tu
=X8+7
-----END PGP SIGNATURE-----

--Sig_/6etw650yfhaW5NkBaozgSjS--
