Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58436 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaDGJCl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 05:02:41 -0400
Date: Mon, 7 Apr 2014 10:02:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub bug on kernel 2.13
Message-ID: <20140407090236.GW7442@carfax.org.uk>
References: <17911062.Cl4v2ZqDNL@zafu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vS2hnRoLMmJ4tslQ"
In-Reply-To: <17911062.Cl4v2ZqDNL@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vS2hnRoLMmJ4tslQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 07, 2014 at 10:32:04AM +0200, Sw=E2mi Petaramesh wrote:
> Hi there,
>=20
> Machine got rebooted while scrub was in process, and now it looks like a =
scrub=20
> zombie...
>=20
> How do I restore this to a normal non-zombie state ?

   There's a status file in /var/lib/btrfs (at least, it's somewhere
near there -- I think that's it, though). Delete that, and you should
be OK. It's a known bug, and I'm fairly sure it was fixed in the
userspace tools some time ago. What version of the tools are you
using?

   Hugo.

> root@zafu:~# btrfs scrub status /
> scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
>         scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
>         total bytes scrubbed: 34.06GiB with 0 errors
>=20
> root@zafu:~# btrfs scrub cancel /
> ERROR: scrub cancel failed on /: not running
>=20
> root@zafu:~# btrfs scrub start /
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /'.
> To see the status use 'btrfs scrub status [-d] /'.
>=20
> root@zafu:~# btrfs scrub status /
> scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
>         scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
>         total bytes scrubbed: 34.06GiB with 0 errors
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Questions are a burden, and answers a prison for oneself. ---   =20

--vS2hnRoLMmJ4tslQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0Jpq1heFHXiqx3kAQIiyw//UDfjOeeMj9txlKbE5MpABBs/OLv983OD
V38y5vGtaw1wFRSm8sOeONgBJeIlE0jOEAqOokGcafo1hT6IJopwCijxNR6kN9jf
30u8xg4FwEtHCzXDLo5KZ7IxFtSsqBdio1rWWDgndwFT+0YDlsON66V79OyBAXSX
BwMCgYnYCz/Gvp/lwzN5ok7e2hhKmlgX1z4F/rU+ukFpcwXZzx+nnMvLMnbhR/Ed
H7Vta/YhlrPxzuAKcz6UqMoJ0QYmZW+ztX/KV73VlCKZZ0x8O8xtW0SJH9RSaB7G
tstq5vvFGD2yim39SjNTwx4FWIjnTcs+gnUIVlDP8DH6hER50/b4GpqhQgCiIbpo
ZUIMVtoqgcW5yyRepLX6UfGb705PEBuMB1YIYeGjj2q5QE2dIgMDnM/LiHqjQu+1
FJq5ehqYwIx3i+EumBCdwbe+x5w90zN4Hzck/R3+VcJOwR5/hVVv57l9+oaq2beU
m1KIyFe7GHzpBbItZllUOXTGv99MKOQDkQnzUH6o4jMlqH/XcOxF8oH3cb3ABfDl
xOL3KlWMUfydsOrmrtJQ4zxlr0t3yHrWk5SA/7E05hmJCYJhfOhDBiZlCXOk2rWb
VGYdJcmkSpPDwgLzQ87+TCnvaYT64LbyeYo0tUb3jOvwzzep0k52yo0l0UkQsVo3
3k3/HH6XDaE=
=Gy9d
-----END PGP SIGNATURE-----

--vS2hnRoLMmJ4tslQ--
