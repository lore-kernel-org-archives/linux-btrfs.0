Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34723 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdJXMlO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 08:41:14 -0400
Subject: Re: [PATCH 1/6] btrfs: qgroup: Skeleton to support separate qgroup
 reservation type
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-2-wqu@suse.com>
 <5e6a7a3c-21ce-12e4-1bdc-78cdcb69d6c7@suse.com>
 <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
 <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
Message-ID: <e4fb01cd-9861-2a62-14ee-c8dcd70b6b40@suse.com>
Date: Tue, 24 Oct 2017 08:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="34OD4Asf836TfVeljGFbtcQUducABf6X5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--34OD4Asf836TfVeljGFbtcQUducABf6X5
Content-Type: multipart/mixed; boundary="XB7lFIImau1usQGuo37Ofcwd3osmVttd8";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <e4fb01cd-9861-2a62-14ee-c8dcd70b6b40@suse.com>
Subject: Re: [PATCH 1/6] btrfs: qgroup: Skeleton to support separate qgroup
 reservation type
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-2-wqu@suse.com>
 <5e6a7a3c-21ce-12e4-1bdc-78cdcb69d6c7@suse.com>
 <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
 <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
In-Reply-To: <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>

--XB7lFIImau1usQGuo37Ofcwd3osmVttd8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/24/17 8:29 AM, Jeff Mahoney wrote:
> On 10/24/17 7:51 AM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 19:00, Nikolay Borisov wrote:
>>> nit: Why not BTRFS_QGROUP_RSV_TYPES_MAX =3D 2;
>>
>> My original plan is just as the same as yours.
>>
>> However I still remember I did it before and David fixed it by using
>> TYPES, so I follow his naming schema here.
>>
>> Kernel is also using this naming schema else where:
>> d91876496bcf ("btrfs: compress: put variables defined per compress typ=
e
>> in struct to make cache friendly")
>=20
> The COMPRESS_TYPES pattern isn't the right pattern to follow here.
> That's a special case since there's a _NONE that doesn't have anything
> associated with it, so we don't need to take a slot in the array.
>=20
> We also don't care about any of the specific values, just that they
> start at 0.  The BTRFS_COMPRESS_TYPES example also has a
> BTRFS_COMPRESS_LAST item in the enum, which serves the same purpose as
> MAX.  I don't have a strong opinion on the naming, just that we don't
> play games with +1 when handling arrays since, as you say, that's just
> waiting for subtle bugs later.
>=20
> enum btrfs_qgroup_rsv_type {
> 	BTRFS_QGROUP_RSV_DATA =3D 0,
> 	BTRFS_QGROUP_RSV_META,
> 	BTRFS_QGROUP_RSV_LAST,
> };

It turns out that BTRFS_COMPRESS_LAST did exist until very recently:

commit dc2f29212a2648164b054016dc5b948bf0fc92d5
Author: Anand Jain <anand.jain@oracle.com>
Date:   Sun Aug 13 12:02:41 2017 +0800

    btrfs: remove unused BTRFS_COMPRESS_LAST

=2E.. so it was there, but just wasn't used.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--XB7lFIImau1usQGuo37Ofcwd3osmVttd8--

--34OD4Asf836TfVeljGFbtcQUducABf6X5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWe802R57S2MheeWyAQgH2w/8C4K3TdpUwK107rgTvXNtTjUnnBc2MKL+
JAOSLbaX+LgN04FXvL4qyjjixndx+x7Lwpt6bAhCf6S4FwY4fd9PeDiLsG/WLbmO
5Bm2dVFY8bD92ste8vfm2sI0BjsIePdU9eJTHPT9HggVqACyypUo98lHvFlOmCci
5Lr3Pu2ouVszUzv/Ks9oiCK4j35XhMcKyBhkrAETG9JagJl+ROr3a2gtHcTeh5/F
XNQvQqXwA/VhDZiwAWWclkPz+ueijwrjUKAKxkd3/6/ZShS+JgwM9t+OHvwPrze8
hGM+A1MeEX/GXAcSWiu64GZpQ56m845WmBEFMn4LREZtMgyvm7kPz2QzPdB9HhIz
L/NUZiHBoOEbqlqnshGGA8F8MSuKpMpK/dDmmvKz0oWDrbSQi3PmcoTglP/VZCqu
kM9iEL6pkuUnzCNljsfLqMDoW5V474xuQ7emW9YasoV+403XcXTKIQZr5qy35aCf
trDaPfit8g/qqA+pTf29zsNTmDSEvd2Q8jlijFnxBXSqVLZd6CTjaqurYkaRxQi+
7ir8uvuLsvlYe6IGQv3G9+wkTEVX5M3rMqqSdt89Ieq5UY9uxe338iC02HvvL8x/
ma9Bcxe4k9Pp0n7NF4u5LNSNMFSQwvPtYeXX3Dl7JqksYau2GOLClMLJHWLUc3JI
iuXr2RX09rU=
=LlEL
-----END PGP SIGNATURE-----

--34OD4Asf836TfVeljGFbtcQUducABf6X5--
