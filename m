Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 67-129-172-163.rev.cloud.scaleway.com ([163.172.129.67]:51344
        "EHLO mail1.sd85.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753503AbdDDN3S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 09:29:18 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Robert Krig <robert.krig@render-wahnsinn.de>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
 <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
From: Brian B <brian@sd85.net>
Message-ID: <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
Date: Tue, 4 Apr 2017 09:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="xABvVlUDxcN5bxETG04FuJLqCT4I5PJC0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xABvVlUDxcN5bxETG04FuJLqCT4I5PJC0
Content-Type: multipart/mixed; boundary="gKLjNk341sCFmXodWRCU3DRJb4RASHSan";
 protected-headers="v1"
From: Brian B <brian@sd85.net>
To: Robert Krig <robert.krig@render-wahnsinn.de>,
 Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <0eda9836-a4ee-b666-2a05-b4bb26746b1a@sd85.net>
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
 <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
 <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>
In-Reply-To: <36448783-672c-5e88-cdda-9a8679c4b4ad@render-wahnsinn.de>

--gKLjNk341sCFmXodWRCU3DRJb4RASHSan
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/04/2017 12:02 AM, Robert Krig wrote:
> My storage array is BTRFS Raid1 with 4x8TB Drives.
> Wouldn't it be possible to simply disconnect two of those drives, mount=

> with -o degraded and still have access (even if read-only) to all my da=
ta?
Just jumping on this point: my understanding of BTRFS "RAID1" is that
each file (block?) is randomly assigned to two disks of the array (no
matter how many disks are in the array).  So if you remove two disks,
you will probably have files that were "assigned" to both of those
disks, and will be missing.

In short, you can't remove more than one disk of a BTRFS RAID1 and still
have all of your data.


--gKLjNk341sCFmXodWRCU3DRJb4RASHSan--

--xABvVlUDxcN5bxETG04FuJLqCT4I5PJC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY45+nAAoJEOrm+yJI9jqLatgQAL7YG95fthE5BBCdfw5nBzsu
bEoVb34nTx3akkkjVaijq/ky1e114wfSHWlofnwh38ZFE7yS7m6L47IOcvwtfxmY
6qzK5l0T7aeOXEt1/CKnzvMnM2BNrKLU9KYW+rbRwm42HoUQ3/t8BYX0wg05+NM/
1OK+FK0ozlOJnm+Ve89dTSq2qzlpRq4w/wlBmVNScIlclNvSoK35mRSeZekdGXiG
95OQQYRSEmcw4mQoD4/gjIYf0iwaT5giPzH4t0oEyx0pKfU4jzfpbSseNgvphTJs
4lWsHDo0uswhm7TYMoQWZaHi3IHorQD1g2ZZtn7HeYz1H31YXsy7iSbLwSYf0Db4
heCF9cTOzOV/bGHtt/E3XRg5Lx8wp53x2JEVU9szjYNLeB+e3EyTf8f6rPXPqapQ
CoTNJ8AHA5yh6lJNbSSXq7NURxAHWBMDmFurLh/qSP47Ga927VAjYM24etzTBdyW
c7RWJ4NMQZStzc/CfZTe1qVSJwp9l1SZPNazlkn78RElrIgb9of2K8/q/aT1jFZU
arZucFPvPYWt0c/063D4LZ9KTMKxBi+WTTxv6CcLMHkpPvqQNAANon3pPaX7Tv1e
ImpdyoHf5mOcD2phfePhy7ZVblu3WXYG0vhi5iBLPrqNJPTBJQ3uCCAd1rLT65Jm
jR1dt0RojykeVkjRLLFe
=Lhpl
-----END PGP SIGNATURE-----

--xABvVlUDxcN5bxETG04FuJLqCT4I5PJC0--
