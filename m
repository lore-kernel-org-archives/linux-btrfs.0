Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57745 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752895AbeD2NT3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 09:19:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE665AEC4
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Apr 2018 13:19:27 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: build: use m4_flatten instead of
 m4_chomp
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <20180427185637.16642-1-jeffm@suse.com>
 <20180427185637.16642-4-jeffm@suse.com>
 <75b17e5e-520f-7c23-b592-047e2b150474@suse.com>
 <20180429101309.GN21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e4ef1312-7622-bc71-c321-d4e627c2176b@suse.com>
Date: Sun, 29 Apr 2018 09:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <20180429101309.GN21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k1jFdSyGlpOqFTPWe94rJhmE3gdLDLhdZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k1jFdSyGlpOqFTPWe94rJhmE3gdLDLhdZ
Content-Type: multipart/mixed; boundary="tBTGgoezb3zVlFfebabSQoobp6qtNnhog";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dsterba@suse.com
Message-ID: <e4ef1312-7622-bc71-c321-d4e627c2176b@suse.com>
Subject: Re: [PATCH 3/3] btrfs-progs: build: use m4_flatten instead of
 m4_chomp
References: <20180427185637.16642-1-jeffm@suse.com>
 <20180427185637.16642-4-jeffm@suse.com>
 <75b17e5e-520f-7c23-b592-047e2b150474@suse.com>
 <20180429101309.GN21272@twin.jikos.cz>
In-Reply-To: <20180429101309.GN21272@twin.jikos.cz>

--tBTGgoezb3zVlFfebabSQoobp6qtNnhog
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/29/18 6:13 AM, David Sterba wrote:
> On Fri, Apr 27, 2018 at 03:18:17PM -0400, Jeff Mahoney wrote:
>> On 4/27/18 2:56 PM, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> Commit 2e1932e6a38 (btrfs-progs: build: simplify version tracking)
>>> started m4_chomp to strip the newlines from the version file.  m4_cho=
mp
>>> was introduced in autoconf 2.64 but SLE11 ships with autoconf 2.63.
>>> For purposes of just stripping the newline, m4_flatten is sufficient.=

>>
>> Scratch that.  The previous patch also requires autoconf 2.64.
>=20
> I wanted to avoid shell tricks, but this should work everywhere:
>=20
> m4_esyscmd([echo -n $(cat VERSION)])
>=20

m4_flatten should work everywhere.  It's the AX_CHECK_COMPILE_FLAGS that
depends on autoconf 2.64.

I can fix the dependency, but it ends up looking like:

m4_version_prereq([2.64], [
    AX_CHECK_COMPILE_FLAG([-std=3Dgnu90],[CSTD=3D-std=3Dgnu90],[CSTD=3D-s=
td=3Dgnu89])
  ], [
    AX_GCC_VERSION([4], [5], [0], [CSTD=3D-std=3Dgnu90],[CSTD=3D-std=3Dgn=
u89])
  ])
AC_SUBST([CSTD])

AX_GCC_VERSION is deprecated, but works with earlier autoconf versions.
I'm not thrilled about it, but keying off the autoconf version and using
the newer way for newer versions means it'll be easier to drop it later
when we drop support for earlier autoconf.

Alternatively, I can just put this patch in the OBS project.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--tBTGgoezb3zVlFfebabSQoobp6qtNnhog--

--k1jFdSyGlpOqFTPWe94rJhmE3gdLDLhdZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlrlxlwACgkQHntLYyF5
5bKc7w/5Aaho/kDxkHQtLU/T90qzvmpaLQSTze1jKfpb7/Qir5ooUJix2QiFK8fV
YUiYXwg1Y0aiFYUGgQ4K3g5j5UsEPYbd5/pRIYrq7h3i2o5IkUwnoZb6oFauKcU3
dnztHZL7nWWFzetbK3PDpyGy2BaOj0wG5v/4NaBUni1lJK9TAyqyA6ooblqo6KF/
04AGFTKynvCYlmngGDpnD3UI1j40oTa2k0O0ci+TmfpR+/YM89BjnFd4gcdCtNWy
aYsjZjOJmuokKWTrLFs1DH05e1fyNN9wJUfTCQoX+CNIMKy98SmYsSugeRLFSpSQ
j8AS1Q1AQhsKBvCYNLaKKP2krDMs5zTbNf9DMFln11X9e4zQ6P9UaeDjQIDcBEyn
jyPwIz+dDBYmyQfa7bM89C3csN6iWumOqwiIhrF+6lkUr0w+s7tNN18CoqGN9AbI
NBGN5cNFjpEv8Y1+KnpGLrO++rKjjNMrgWS6A0mNRKXoEOLHrhRLsVbBjH3f8UY0
Awk/rz/7vP4bozNbzwo9jtAUuMn2KM7OncOH7pYoaf0Z2qyms9bxb80Hqqm11FO0
HUwnwH/PCML3i+7fKTpNlkUGkr1u2o03oqlspNyZSMiRbrZ1+IclrPg4jo51xxvm
vPE0jr0OAMwQdywMqqh4tgpICqBr+z+p6PHGbXDJIaTrBqrkUt4=
=vocZ
-----END PGP SIGNATURE-----

--k1jFdSyGlpOqFTPWe94rJhmE3gdLDLhdZ--
