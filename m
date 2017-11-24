Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61253 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbdKXHAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 02:00:22 -0500
Subject: Re: [PATCH 1/3] btrfs: Introduce macros to handle bytes and sector
 conversion
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171124041008.32656-1-wqu@suse.com>
 <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <75bcb200-b752-50c6-ed45-dd892bd09cad@gmx.com>
Date: Fri, 24 Nov 2017 14:59:35 +0800
MIME-Version: 1.0
In-Reply-To: <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JLhkRJndmcplCK7EU4u6s4SPIhxDAMwEo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JLhkRJndmcplCK7EU4u6s4SPIhxDAMwEo
Content-Type: multipart/mixed; boundary="Shug9gdNCip5Qatt4SKtRKudgD75921oa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <75bcb200-b752-50c6-ed45-dd892bd09cad@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: Introduce macros to handle bytes and sector
 conversion
References: <20171124041008.32656-1-wqu@suse.com>
 <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>
In-Reply-To: <1d7099e1-0c95-3085-de54-20cae5b5b304@suse.com>

--Shug9gdNCip5Qatt4SKtRKudgD75921oa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8824=E6=97=A5 14:53, Nikolay Borisov wrote:
>=20
>=20
> On 24.11.2017 06:10, Qu Wenruo wrote:
>> Since block I/O is always done in unit of 512 bytes, add BI_SECTOR_SIZ=
E
>> and BI_SECTOR_SHIFT macros and to_sector() and to_bytes() for later
>> use.
>>
>> Although the best position to define such things should be bvec.h, and=

>> to_sector() to_bytes() are also defined in device-mapper.h, there are
>> a lot of code defining their own SECTOR_SIZE and to_bytes() in
>> device-mapper is not using u64 (unsigned long long) but unsigned long,=

>> which doesn't fit btrfs usage.
>>
>> So define btrfs' own macros and inlined converters.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/ctree.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 8fc690384c58..8f6f57167661 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3734,4 +3734,17 @@ static inline int btrfs_is_testing(struct btrfs=
_fs_info *fs_info)
>>  #endif
>>  	return 0;
>>  }
>> +
>> +#define BI_SECTOR_SHIFT		(9)
>> +#define BI_SECTOR_SIZE		(1 << BI_SECTOR_SHIFT)
>> +
>> +static inline u64 to_bytes(sector_t n)
>> +{
>> +	return ((u64)n << BI_SECTOR_SHIFT);
>> +}
>> +
>> +static inline sector_t to_sector(u64 n)
>> +{
>> +	return (n >> BI_SECTOR_SHIFT);
>> +}
>=20
> nit: I don't like the naming, I'd rather have something similar to what=

> xfs has for its conversion macros i.e:
>=20
> XFS_FSS_TO_BB - filesystem sector to basic block (bb in this case is 51=
2
> bytes)

The problem is, without your explanation, I don't even know this macro
is used to convert sectors to bytes.

>=20
> so why not - BTRFS_B_TO_BB or BTRFS_B_TO_S and BTRFS_S_TO_B. Or
> something like that but just to_bytes and to_sector look a bit silly.
> It's not a big paint point but more of a "let's get the good ideas from=

> other fsses"

Yep, better ideas are always welcomed.

BTW, the to_bytes() and to_sector() from device-mapper.h is the easier
to understand one I can found in variant headers.
(I don't even need to add any comment, unlike the initials from XFS)

Thanks,
Qu

>=20
>>  #endif
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Shug9gdNCip5Qatt4SKtRKudgD75921oa--

--JLhkRJndmcplCK7EU4u6s4SPIhxDAMwEo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloXw1cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjEmQgAhvRyJstpi+aWb3cWRje3QcWv
oG4UPDQGkPsdq4unei9zFyu3M2KDc8SML945W7rolRkxachM7Jmk91lE1aKjWTVD
w12SmDTbMIg3kQ2n1lhJqYBUKq1l0YOOGR4zys9bIDVuDjvtoCZnFznlGVRQaR8e
QbmikBcMBKuM1eRVBnfgEjU/k5PBpz21fZ+X1rjJarIgwQBpxVYMfNZqo+1MP3uk
3MZwjCbOaRGIjpvgmTMTyAGRKfSLsbnklO0FB/uON8DNc6rMKQqMwmH8gyyLuHW8
QsHZttnnqx4PwW/w37h2cayrfI+cEo8YkyYTXetGaZTDrZViapsGe+mBRgNheg==
=LHOi
-----END PGP SIGNATURE-----

--JLhkRJndmcplCK7EU4u6s4SPIhxDAMwEo--
