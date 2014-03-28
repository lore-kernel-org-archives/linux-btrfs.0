Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49144 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaC1XpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 19:45:15 -0400
Date: Fri, 28 Mar 2014 23:45:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lists <lists@benjamindsmith.com>
Cc: Avi Miller <avi.miller@oracle.com>,
        Johan =?iso-8859-1?Q?Kr=F6ckel?= <johan.kroeckel@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RHEL/CentOS or Debian for stable deployment
Message-ID: <20140328234503.GJ7442@carfax.org.uk>
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com>
 <CF9CC748-3700-4D4F-AB96-03F27EA9C32B@oracle.com>
 <533607E1.8060202@benjamindsmith.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fU0UwhtRbpo05rnG"
In-Reply-To: <533607E1.8060202@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fU0UwhtRbpo05rnG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 04:38:09PM -0700, Lists wrote:
> On 03/28/2014 02:42 PM, Avi Miller wrote:
> >Have you considered Oracle Linux? We are continually backporting btrfs f=
ixes and enhancements to our Unbreakable Enterprise Kernel releases. On Ora=
cle Linux 6, you would run the UEK Release 3, which is based on 3.8 mainlin=
e with upstream fixes. We also provide all security and bug fix errata for =
free viahttp://public-yum.oracle.com, so you don=E2=80=99t need to buy supp=
ort to run Oracle Linux at keep up-to-date.
>=20
> Can't remember asking if btrfs is supported on 32 bit kernels?

   I can't speak for Oracle's distribution, but in the general case,
yes, btrfs works on 32 bit systems.

   On the subject of bitness, there's a couple of rough edges with
64-bit kernels and 32-bit userspace. (I think there's still one ioctl
that fails on that configuration, but I've not hit it yet on my test
machine).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, --- =20
                and a natural deficiency in moral fibre.                =20

--fU0UwhtRbpo05rnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUBUzYJf1heFHXiqx3kAQJ1zQ/0DK4W629OQbK6DCUfyt3GfZUyR2u/34OH
N8EsKDGQy+di1QBYHmOPybcgCrMt9zwywFMUed7ZQI4//Lz0aUPny2F/8fWNUSdH
aRJpA3pmIqrbi2OBRZ2t+BogXH1dD3cdUvPe56bQCKkIOMS/ShGL3rABerlIhGvv
j2tWGe8AXRyv6StN6OszfrlUZ1Y8pygWDGoud1cxQbeEopSr0fpxQRBCO1QXb2B+
K3jRlCyih+GTI7Q5XZTO0zKP2kWuW97gPMr8O3ZcWUYdmCffF0EzNKgx/OSx/Sty
uk/J0HD2Kri8Ng+L16Tgl+PpFen6KkVMXWZD8VLng0JMhVHE7TFSlRBSrjVOgn3b
0CtQ11TKmfQeyj0FK73LgmvDPpR4FPi2b7cHOlI03QB32hkbYKJ228tJ1tEvVzxk
FEWfKZCUwABXCKbaz99124CD5lSmRZLWx2kajirTTNIzjp81PlX8HAodzz0IUdnA
IjJ/Y6FgYAV0Lg7/hoTcP0IWQsPzkaC4uJWfUQGDk1enw1R7Zt8AvVRAC4cNT9RA
wVksbLCEoQpUIylbv5UXYhaewoegtEKSfULlEv6nATzabv+pJQnJku/LCZuYFUI8
dWNL00qIxmDDigDkOZ93bu+gM44rEukhgl42+UWlisgH3hwM7LcEaRaAAdVpb/go
OLP54hJE4g==
=2miL
-----END PGP SIGNATURE-----

--fU0UwhtRbpo05rnG--
