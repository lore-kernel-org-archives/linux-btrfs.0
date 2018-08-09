Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60155 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbeHJCCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 22:02:47 -0400
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
Date: Fri, 10 Aug 2018 07:35:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180809174811.GA27001@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xPlvrS6nskSEiTbz8V77XL9yj7RXHRQaK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xPlvrS6nskSEiTbz8V77XL9yj7RXHRQaK
Content-Type: multipart/mixed; boundary="mraiHDn3bDeJ1bIwGzrzN5NLiq25aYPQe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
In-Reply-To: <20180809174811.GA27001@polanet.pl>

--mraiHDn3bDeJ1bIwGzrzN5NLiq25aYPQe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 1:48 AM, Tomasz Pala wrote:
> On Tue, Jul 31, 2018 at 22:32:07 +0800, Qu Wenruo wrote:
>=20
>> 2) Different limitations on exclusive/shared bytes
>>    Btrfs can set different limit on exclusive/shared bytes, further
>>    complicating the problem.
>>
>> 3) Btrfs quota only accounts data/metadata used by the subvolume
>>    It lacks all the shared trees (mentioned below), and in fact such
>>    shared tree can be pretty large (especially for extent tree and csu=
m
>>    tree).
>=20
> I'm not sure about the implications, but just to clarify some things:
>=20
> when limiting somebody's data space we usually don't care about the
> underlying "savings" coming from any deduplicating technique - these ar=
e
> purely bonuses for system owner, so he could do larger resource overboo=
king.

In reality that's definitely not the case.

=46rom what I see, most users would care more about exclusively used spac=
e
(excl), other than the total space one subvolume is referring to (rfer).

The most common case is, you do a snapshot, user would only care how
much new space can be written into the subvolume, other than the total
subvolume size.

>=20
> So - the limit set on any user should enforce maximum and absolute spac=
e
> he has allocated, including the shared stuff. I could even imagine that=

> creating a snapshot might immediately "eat" the available quota. In a
> way, that quota returned matches (give or take) `du` reported usage,
> unless "do not account reflinks withing single qgroup" was easy to impl=
emet.

In fact, that's the case. In current implementation, accounting on
extent is the easiest (if not the only) way to implement.

>=20
> I.e.: every shared segment should be accounted within quota (at least o=
nce).

Already accounted, at least for rfer.

>=20
> And the numbers accounted should reflect the uncompressed sizes.

No way for current extent based solution.

>=20
>=20
> Moreover - if there would be per-subvolume RAID levels someday, the dat=
a
> should be accouted in relation to "default" (filesystem) RAID level,
> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
> data, and twice the data in an opposite scenario (like "dup" profile on=

> single-drive filesystem).

No possible again for current extent based solution.

>=20
>=20
> In short: values representing quotas are user-oriented ("the numbers on=
e
> bought"), not storage-oriented ("the numbers they actually occupy").

Well, if something is not possible or brings so big performance impact,
there will be no argument on how it should work in the first place.

Thanks,
Qu


--mraiHDn3bDeJ1bIwGzrzN5NLiq25aYPQe--

--xPlvrS6nskSEiTbz8V77XL9yj7RXHRQaK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltsz8QACgkQwj2R86El
/qjh9wf9E/ndc53OajI8ODLF+XQI/wiUNPzXkozy9dSZa0j4D3q5b0Q/tUBx9uB9
xDgYabQo47PViSmNsE2DyULOy9V+qiCjhQMkV6eZ559kfBosU0CvGN9H4zchkJJC
qGNAuqvxcIAHOmjsADIS2svhfztV827J8WnNxqEiDyZvdQqogHw1+30Yg4GoG44+
8xff8h9xEWboNFogxeNUfgjOiAFZcK8NNW37tV3xj7LEETKgwiIXK0TdmXjghTs0
fCSg1L3epA3yqiTq1fFisp4a+w8bf1ywAd0HnDavRRJdxL4chKt9O/2UA5JZ2F7e
nMWqwaakiTNmZxNLa/YH9my377nm5Q==
=4Ad6
-----END PGP SIGNATURE-----

--xPlvrS6nskSEiTbz8V77XL9yj7RXHRQaK--
