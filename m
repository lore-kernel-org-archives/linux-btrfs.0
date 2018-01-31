Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57672 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbeAaIsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 03:48:53 -0500
Subject: Re: [PATCH] btrfs: volumes: Remove the meaningless condition of
 minimal nr_devs when allocating a chunk
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180131055615.14454-1-wqu@suse.com>
 <786c6ed0-0764-96cf-c494-78b40979f70d@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bed38c35-854f-7b93-bc9b-8b9bcee95d94@gmx.com>
Date: Wed, 31 Jan 2018 16:48:38 +0800
MIME-Version: 1.0
In-Reply-To: <786c6ed0-0764-96cf-c494-78b40979f70d@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H6jeRP8ol2djiUEJWMq5VCYhSLBz0vyWc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H6jeRP8ol2djiUEJWMq5VCYhSLBz0vyWc
Content-Type: multipart/mixed; boundary="R7Y6JtSldRChOJZ2EMsa82MZixqhYTx0W";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <bed38c35-854f-7b93-bc9b-8b9bcee95d94@gmx.com>
Subject: Re: [PATCH] btrfs: volumes: Remove the meaningless condition of
 minimal nr_devs when allocating a chunk
References: <20180131055615.14454-1-wqu@suse.com>
 <786c6ed0-0764-96cf-c494-78b40979f70d@suse.com>
In-Reply-To: <786c6ed0-0764-96cf-c494-78b40979f70d@suse.com>

--R7Y6JtSldRChOJZ2EMsa82MZixqhYTx0W
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8831=E6=97=A5 15:35, Nikolay Borisov wrote:
>=20
>=20
> On 31.01.2018 07:56, Qu Wenruo wrote:
>> When checking the minimal nr_devs, there is one dead and meaningless
>> condition:
>>
>> if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> This condition is meaningless, @devs_increment has nothing to do with
>> @sub_stripes.
>>
>> In fact, in btrfs_raid_array[], profile with sub_stripes larger than 1=

>> (RAID10) already has the @devs_increment set to 2.
>> So no need to multiple it by @sub_stripes.
>>
>> And above condition is also dead.
>> For RAID10, @devs_increment * @sub_stripes equals 4, which is also the=

>> @devs_min of RAID10.
>> For other profiles, @sub_stripes is always 1, and since @ndevs is
>> rounded down to @devs_increment, the condition will always be true.
>>
>> Remove the meaningless condition to make later reader wander less.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>=20
> Quick question : What exactly is a substripe?

IMHO it is the number of copies inside the RAID0 virtual stripe.

For current RAID10, it's 2 devices as a bundle, using RAID1, then RAID0
these bundles.

> Stripe is essentially how
> many contiguous portions of disk are necessary to satisfy the profile,
> right? So for raid1 we write 1 copy of the data per device (hence
> dev_stripes =3D 1). For DUP we have 2 copies of the data on the same di=
sk
> hence dev_stripes 2. How does sub_stripes fit in the grand scheme of th=
ings?
Here we have extra number to describe the behavior. Mostly
btrfs_raid_arrary.

For sub_stripes, it should be acts like:

Logical address space:   0                              1G
                         |           RAID10 chunk       |
                         | RAID0 of virtual stripe 1~3  |
                         /               |             \
                        /                |              \
|             Virtual stripe 1|| Virtual stripe 2 || Vritual bundle 3 |
|RAID1 of physical stripe 1~2 |
             /            \
            /              \
|Physical stripe 1| |Physical stripe 2|

And sub_stripes describes how many physical stripes are inside the
virtual stripe.

Thanks,
Qu

>> ---
>>  fs/btrfs/volumes.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 215e85e22c8e..cb0a8d27661b 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4729,7 +4729,7 @@ static int __btrfs_alloc_chunk(struct btrfs_tran=
s_handle *trans,
>>  	/* round down to number of usable stripes */
>>  	ndevs =3D round_down(ndevs, devs_increment);
>> =20
>> -	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
>> +	if (ndevs < devs_min) {
>>  		ret =3D -ENOSPC;
>>  		goto error;
>>  	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--R7Y6JtSldRChOJZ2EMsa82MZixqhYTx0W--

--H6jeRP8ol2djiUEJWMq5VCYhSLBz0vyWc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpxguYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj41QgAidxmE1f0EaiK9qKQEO7YjB4n
MTvXbK6IIL2+gg+h7ctdTlNnJBM2vLyxZthwNk5eR8ukpZGT35KS3pt+OrtFqxh2
Ix21NT87HPyAMV44pcozB3DEzI6sP0g7ipgIZmVP5QPxoTG9mtQABOiS9kLPTqRl
7Gyywek/VHq7K3sPavbli+7XmjQrEw/R4I/A3ZUEihEBJWUGmYmtNybhjq1t1L8y
Wyp8OagUIeUoHXysYli+P33fsXbyc8jEvDIg/lWmcGV5jKYKC46Rvmnkm04eAS0g
RgcjrvciKXlm0haUH2sgHwxJSa27oshm912QyFz9NQQKW7XUmfGB9hdmAH9KPw==
=i8D+
-----END PGP SIGNATURE-----

--H6jeRP8ol2djiUEJWMq5VCYhSLBz0vyWc--
