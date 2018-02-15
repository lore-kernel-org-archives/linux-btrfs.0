Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:42877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752371AbeBODuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 22:50:08 -0500
Subject: Re: Status of FST and mount times
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <pan$4ce4f$f90ad4b5$3f1cd3cd$26789d16@cox.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7a938ce0-b7f2-0087-ca43-8b23525cc3f2@gmx.com>
Date: Thu, 15 Feb 2018 11:49:59 +0800
MIME-Version: 1.0
In-Reply-To: <pan$4ce4f$f90ad4b5$3f1cd3cd$26789d16@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ykWRR1C8NYndr49yZ5q8xQC6fLGssefky"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ykWRR1C8NYndr49yZ5q8xQC6fLGssefky
Content-Type: multipart/mixed; boundary="4CXTKXUH4c7lBL3Y30GP8Qm9Ahv9nlQTL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-ID: <7a938ce0-b7f2-0087-ca43-8b23525cc3f2@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <pan$4ce4f$f90ad4b5$3f1cd3cd$26789d16@cox.net>
In-Reply-To: <pan$4ce4f$f90ad4b5$3f1cd3cd$26789d16@cox.net>

--4CXTKXUH4c7lBL3Y30GP8Qm9Ahv9nlQTL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8815=E6=97=A5 10:15, Duncan wrote:
> Qu Wenruo posted on Thu, 15 Feb 2018 09:42:27 +0800 as excerpted:
>=20
>> The easiest way to get a basic idea of how large your extent tree is
>> using debug tree:
>>
>> # btrfs-debug-tree -r -t extent <device>
>>
>> You would get something like:
>> btrfs-progs v4.15 extent tree key (EXTENT_TREE ROOT_ITEM 0) 30539776
>> level 0  <<<
>> total bytes 10737418240 bytes used 393216 uuid
>> 651fcf0c-0ffd-4351-9721-84b1615f02e0
>>
>> That level is would give you some basic idea of the size of your exten=
t
>> tree.
>>
>> For level 0, it could contains about 400 items for average.
>> For level 1, it could contains up to 197K items.
>> ...
>> For leven n, it could contains up to 400 * 493 ^ (n - 1) items.
>> ( n <=3D 7 )
>=20
> So for level 2 (which I see on a couple of mine here, ran it out of=20
> curiosity):
>=20
> 400 * 493 ^ (2 - 1) =3D 400 * 493 =3D 197200
>=20
> 197K for both level 1 and level 2?  Doesn't look correct.
>=20
> Perhaps you meant a simple power of n, instead of (n-1)?

My fault, off by 1 is really easy to screw things up.

So it's 400 * 493 ^ n.

And level 0 also fits into the calculation.

>  That would=20
> yield ~97M for level 2, and would yield the given numbers for levels 0 =

> and 1 as well, whereby using n-1 for level 0 yields less than a single =

> entry, and 400 for level 1.
>=20
> Or the given numbers were for level 1 and 2, with level 0 not holding=20
> anything, not levels 0 and 1.  But that wouldn't jive with your level 0=
=20
> example, which I would assume could never happen if it couldn't hold ev=
en=20
> a single entry.

Here level 0 means it's leaf. And I assume the average item size of each
EXTENT_ITEM/METADATA item to be 40.
And using 16K nodesize we have 16283, we get 407, I just round it to 400
to make calculation a little easier and more headroom for larger item.

So for level 0, we could have around 400 items.
For nodes (1 < level <=3D 7), since node ptr is fixed to 33 bytes, the
calculation is pretty simple now.

Thanks,
Qu

>=20


--4CXTKXUH4c7lBL3Y30GP8Qm9Ahv9nlQTL--

--ykWRR1C8NYndr49yZ5q8xQC6fLGssefky
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqFA2cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgTQwf+NrKWRtj1dRJI1x4PFuzzaXyQ
FByOhczofm90YIhgeGVhZcRzCuyNZW9krhqoRfkK1TkhFrl801znCxmdMIUQknWa
0PHG6rZEX7+alRYp0u1ENNgo8LnOnlb3USoQZxLL937eFR9m34FDLK1nhd83VM5p
sls8qAL98DCGfLyCPPi1f3Al+MiXSCuL0KlgBhEvXiDHAfO5Ku7SxI8h6a/KbEdg
TVoIZxWYWMhok4A40huDOJ3agx7bmOThO4dXc9ePEVZGDsWTj8ocgBVkQDw/WfOe
AD04ogFEyz0Okh7QhPYD1WfA2cuiOOrAjzKhhNqdY9k8462Kpavlarne2rucUA==
=Y8Z3
-----END PGP SIGNATURE-----

--ykWRR1C8NYndr49yZ5q8xQC6fLGssefky--
