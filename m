Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59086 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752455AbeAXAna (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 19:43:30 -0500
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Prevent temporary system chunk to
 use space in reserved 1M range
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        nborisov@suse.com
References: <20180110045648.3239-1-wqu@suse.com>
 <20180123164253.GN15713@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c7ce57d8-37f4-a2b0-ee12-11d9e107ef3d@gmx.com>
Date: Wed, 24 Jan 2018 08:42:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180123164253.GN15713@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o5cEw9nH2TLCrRiCzU5Cj5CNlWduJBzwc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o5cEw9nH2TLCrRiCzU5Cj5CNlWduJBzwc
Content-Type: multipart/mixed; boundary="FZTzDCch7cAnbqlZu4CDQxLMMXPYRtEQH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 nborisov@suse.com
Message-ID: <c7ce57d8-37f4-a2b0-ee12-11d9e107ef3d@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Prevent temporary system chunk to
 use space in reserved 1M range
References: <20180110045648.3239-1-wqu@suse.com>
 <20180123164253.GN15713@twin.jikos.cz>
In-Reply-To: <20180123164253.GN15713@twin.jikos.cz>

--FZTzDCch7cAnbqlZu4CDQxLMMXPYRtEQH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8824=E6=97=A5 00:42, David Sterba wrote:
> On Wed, Jan 10, 2018 at 12:56:47PM +0800, Qu Wenruo wrote:
>> When creating btrfs, mkfs.btrfs will firstly create a temporary system=

>> chunk as basis, and then created needed trees or new devices.
>>
>> However the layout temporary system chunk is hard-coded and uses
>> reserved [0, 1M) range of devid 1.
>>
>> Change the temporary chunk layout from old:
>>
>> 0	1M				4M	5M
>> |<----------- temp chunk -------------->|
>>   And it's 1:1 mapped, which means it's a SINGLE chunk,
>>   and stripe offset is also 0.
>>
>> to new layout:
>>
>> 0	1M				4M	5M
>> 	|<----------- temp chunk -------------->|
>>   And still keeps the 1:1 mapping.
>>
>> The problem can only be exposed by "-m single" or "-M" where we reuse =
the
>> temporary chunk.
>>
>> With other meta profiles, system and meta chunks are allocated by late=
r
>> btrfs_alloc_chunk() call, and old SINGLE chunks are removed, so it wil=
l
>> be no such problem for other meta profiles.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> The test mkfs-tests/010-minimal-size fails with this patch (devel
> branch). I've added some debugging and the requested minimal size by
> mkfs is not sufficient. I think it's because of the 1MB shift but
> haven't looked closely.

Patch under the way.

And this reminds me to refactor btrfs_alloc_chunk() to allow caller get
minimal chunk size to use other than manually read the code.

Thanks,
Qu

>=20
> The math in "btrfs-progs: mkfs: move source dir size calculation to its=

> own files" may need to be updated, I'm not sure how exactly to do that.=

> It would be good if you find the fix and we'll then see where to put it=

> (separate patch or fold it to some other one).
>=20
> Otherwise I'm going to apply patches 1 and 2, thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--FZTzDCch7cAnbqlZu4CDQxLMMXPYRtEQH--

--o5cEw9nH2TLCrRiCzU5Cj5CNlWduJBzwc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpn1ocXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhBegf+PO22iVALHTZBK7u1Ahwrf6oh
4UqJ6dk0TSqg6qBly9lqnrPxzvQ4MIC6gsIoEbd3mllQzGFM/WEXadOoceFvbqm1
BG2OClVv5MuJdz6PlCrLuhKg+7wiWUV1reyVLdfzpctj5rUoPgrEtbUEJZ5M0k7K
Nqok8Z4p73BwkYRZ+9KZ90IzdRWatesq9ffrBIkL0d8IEgruGG4MB+2ixFv1+yaa
uhlnLqWwd5VmFUOtJ/JEFbajbmq3qvv10APgFmUJhK1hGwE7Tyy9XUL69ecmllyr
0s4iYh+fjrJyC9jxjmo2pTamNazvB9Dz0tId3xOwUzntEMrvYp1XWgXgRUuxyw==
=J/Gq
-----END PGP SIGNATURE-----

--o5cEw9nH2TLCrRiCzU5Cj5CNlWduJBzwc--
