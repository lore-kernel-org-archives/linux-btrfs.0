Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbeHKB6j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 21:58:39 -0400
Subject: Re: BUG: scheduling while atomic
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
 <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
 <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
 <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
 <CAAMvbhGK7QZnLg+4O4B-Pk4XdfgS6N6Gv41ggPn151TPxOPA-g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9af66eed-9b57-bcde-a454-2229fd3cd3ba@gmx.com>
Date: Sat, 11 Aug 2018 07:26:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAAMvbhGK7QZnLg+4O4B-Pk4XdfgS6N6Gv41ggPn151TPxOPA-g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GZF1AypUNwA8RebFc8sJWJuPT6YkixGUt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GZF1AypUNwA8RebFc8sJWJuPT6YkixGUt
Content-Type: multipart/mixed; boundary="TWuA7NSb5VbwtPBHpHsYTOUeVh3bifNdk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9af66eed-9b57-bcde-a454-2229fd3cd3ba@gmx.com>
Subject: Re: BUG: scheduling while atomic
References: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
 <fa1bac3c-76d6-eb0a-459b-5b931375f1a9@gmx.com>
 <CAAMvbhGJdGobexGS0QEGDexNeZpZkJY3o_s9N4izZeEJ7-HWtA@mail.gmail.com>
 <7e1b4883-0095-3d7d-553d-ccb551d37a29@gmx.com>
 <CAAMvbhGK7QZnLg+4O4B-Pk4XdfgS6N6Gv41ggPn151TPxOPA-g@mail.gmail.com>
In-Reply-To: <CAAMvbhGK7QZnLg+4O4B-Pk4XdfgS6N6Gv41ggPn151TPxOPA-g@mail.gmail.com>

--TWuA7NSb5VbwtPBHpHsYTOUeVh3bifNdk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/11/18 6:14 AM, James Courtier-Dutton wrote:
> On 6 August 2018 at 07:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>> WARNING: CPU: 3 PID: 803 at
>>> /build/linux-hwe-SYRsgd/linux-hwe-4.15.0/fs/btrfs/extent_map.c:77
>>> free_extent_map+0x78/0x90 [btrfs]
>>
>> Then it makes sense, as it's a WARN_ON() line, showing one extent map =
is
>> still used.
>>
>> If it get freed, it will definitely cause some rbtree corruption.
>>
>>
>> It's should be the only free_extent_map() call in __do_readpage() func=
tion.
>> However a first glance into this function shows nothing wrong, nor new=

>> modification in this function.
>> (Maybe it's the get_extent() hook?)
>>
>> Is there any reproducer? Or special workload?
> The workload is fairly simple.
> 1) The server is receiving 1Gbyte files from across the network, in 10
> minute intervals, and storing them on the HDD.
> 2) A process reads the files, scanning them for certain patterns.
> 3) A cron job deletes the old files.

This looks pretty normal.
Shouldn't cause any problem.

>=20
>=20
>=20
>>
>> And, have you tried "btrfs check --readonly <device>"? If there is any=

>> error it would help a lot to locate the problem.
>>
> root@sandisk:~# btrfs check --readonly /dev/sda3
> Checking filesystem on /dev/sda3
> UUID: 8c9063b9-a4bb-48d1-92ba-6adf49af6fb5
> checking extents
> checking free space cache
> block group 6874953940992 has wrong amount of free space
> failed to load free space cache for block group 6874953940992

This problem can be solved by "btrfs check --clear-space-cache=3Dv1".
Normally it shouldn't cause much problem.

> checking fs roots
> checking csums
> checking root refs
> found 1488143566396 bytes used err is 0
> total csum bytes: 1448276084
> total tree bytes: 5079711744
> total fs tree bytes: 3280207872
> total extent tree bytes: 146997248
> btree space waste bytes: 1100557047
> file data blocks allocated: 2266345996288
>  referenced 2235075653632
> root@sandisk:~#
>=20
>=20
> So, not much to see there.
> Any more ideas?

Not really.

If it's still reproducible, maybe it's worth trying the latest upstream
kernel.

Thanks,
Qu

>=20


--TWuA7NSb5VbwtPBHpHsYTOUeVh3bifNdk--

--GZF1AypUNwA8RebFc8sJWJuPT6YkixGUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltuHyoACgkQwj2R86El
/qjOzwf+NX8GLalJD2u0QCaZWTnCPWQXNSRPvkSR4DmjwXrTZ9CAXzk1T9/Y6ggh
YcyehpzXUmcgQVlosanzk6zWAJMF6wiyO4fWJUdewcsreaTwyJYZ/XjmwB6jk5DT
Y+wq7o0I5ji6C5LHmpOz1EqtNtzDTAYqwS2zid4mTMKiIr+v5Bd2OhOtCvpBPHlT
hpXfCzhf6ZYgfcvGHByObtQjAseVArG2sEpYCryGt0GybKeaO+4sn+ZW5nsP6L20
JPZzPRed/WsTCaEs9aHxZTXZCdzKdZ2dy2mEmyCAxnqsXTIPaSTPKtWg0mAVt1Tq
GmeXUS0kDDNpfveB4zXjpq7n0wUeIA==
=+IEQ
-----END PGP SIGNATURE-----

--GZF1AypUNwA8RebFc8sJWJuPT6YkixGUt--
