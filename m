Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63744 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbeAQAxb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 19:53:31 -0500
Subject: Re: [PATCH] btrfs: Add chunk allocation ENOSPC debug message for
 enospc_debug mount option
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180115061352.13799-1-wqu@suse.com>
 <6d5b67be-4aa5-9383-3d30-5756bc1cdc15@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dfd58ecb-0e95-36c8-7aeb-52924a81b685@gmx.com>
Date: Wed, 17 Jan 2018 08:52:47 +0800
MIME-Version: 1.0
In-Reply-To: <6d5b67be-4aa5-9383-3d30-5756bc1cdc15@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5JFmykIjAQpB3I89mw4l7C2lI0j3SmW7R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5JFmykIjAQpB3I89mw4l7C2lI0j3SmW7R
Content-Type: multipart/mixed; boundary="3UtQPM6VGpQVvSrsc2cN5TMP1Xnsqbwlp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <dfd58ecb-0e95-36c8-7aeb-52924a81b685@gmx.com>
Subject: Re: [PATCH] btrfs: Add chunk allocation ENOSPC debug message for
 enospc_debug mount option
References: <20180115061352.13799-1-wqu@suse.com>
 <6d5b67be-4aa5-9383-3d30-5756bc1cdc15@suse.com>
In-Reply-To: <6d5b67be-4aa5-9383-3d30-5756bc1cdc15@suse.com>

--3UtQPM6VGpQVvSrsc2cN5TMP1Xnsqbwlp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8816=E6=97=A5 21:47, Nikolay Borisov wrote:
>=20
>=20
> On 15.01.2018 08:13, Qu Wenruo wrote:
>> Enospc_debug makes extent allocator to print more debug messages,
>> however for chunk allocation, there is no debug message for enospc_deb=
ug
>> at all.
>>
>> This patch will add message for the following parts of chunk allocator=
:
>>
>> 1) No rw device at all
>>    Quite rare, but at least output one message for this case.
>>
>> 2) No enough space for some device
>>    This debug message is quite handy for unbalanced disks with stripe
>>    based profiles (RAID0/10/5/6).
>>
>> 3) Not enough free devices
>>    This debug message should tell us if current chunk allocator is
>>    working correctly on minimal device requirement.
>>
>> Although under most case, we will hit other ENOSPC before we even hit =
a
>> chunk allocator ENOSPC, but such debug info won't help.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/volumes.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index a25684287501..664d8a1b90b3 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -4622,8 +4622,11 @@ static int __btrfs_alloc_chunk(struct btrfs_tra=
ns_handle *trans,
>> =20
>>  	BUG_ON(!alloc_profile_is_valid(type, 0));
>> =20
>> -	if (list_empty(&fs_devices->alloc_list))
>> +	if (list_empty(&fs_devices->alloc_list)) {
>> +		if (btrfs_test_opt(info, ENOSPC_DEBUG))
>> +			btrfs_warn(info, "%s: No writable device", __func__);
>=20
> perhaps this shouldn't be gated on ENOSPC_DEBUG if it's a warning, or i=
f
> it's to be gated then make it a DEBUG.

Because the case of no writeable device is rare.

But change it to debug seems good.

>=20
>>  		return -ENOSPC;
>> +	}
>> =20
>>  	index =3D __get_raid_index(type);
>> =20
>> @@ -4705,8 +4708,14 @@ static int __btrfs_alloc_chunk(struct btrfs_tra=
ns_handle *trans,
>>  		if (ret =3D=3D 0)
>>  			max_avail =3D max_stripe_size * dev_stripes;
>> =20
>> -		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
>> +		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes) {
>> +			if (btrfs_test_opt(info, ENOSPC_DEBUG))
>> +				btrfs_debug(info,
>> +			"%s: devid %llu has no free space, have=3D%llu want=3D%u",
>> +					    __func__, device->devid, max_avail,
>> +					    BTRFS_STRIPE_LEN * dev_stripes);
>=20
> Here we have a debug output gated on ENOSCP_DEBUG so let's be consisten=
t
> (hence my previous comment)
>>  			continue;
>> +		}
>> =20
>>  		if (ndevs =3D=3D fs_devices->rw_devices) {
>>  			WARN(1, "%s: found more than %llu devices\n",
>> @@ -4731,6 +4740,12 @@ static int __btrfs_alloc_chunk(struct btrfs_tra=
ns_handle *trans,
>> =20
>>  	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
>>  		ret =3D -ENOSPC;
>> +		if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
>> +			btrfs_debug(info,
>> +		"%s: not enough devices with free space: have=3D%d minimal=3D%d inc=
rement=3D%d",
>> +				    __func__, ndevs, devs_min,
>> +				    devs_increment * sub_stripes);
>=20
> Without looking at the code it's not really obvious what increment is.
> Perhaps you can use a more descriptive word?

"increment" is indeed less meaningful.

I'll change it to only output "minimal" just min(minimal, devs_min).

Thanks,
Qu

>=20
>> +		}
>>  		goto error;
>>  	}
>> =20
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--3UtQPM6VGpQVvSrsc2cN5TMP1Xnsqbwlp--

--5JFmykIjAQpB3I89mw4l7C2lI0j3SmW7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpenl8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiVHggArMdWa9ESJ//4Nqs40rQATFzP
R5Eo5FQnFWCVbtNnCRYNj3NuruN+h+9z7edBO1ndgihyPdtyKVRd1QsYZoMYyFsx
0jhvFszVq9fwK9V1NxG2Til7/R0Hi/Ev2/TgRa1OZQ9GgbhivJi+KXGpBepbpoWp
c79Tneb03KfTstWMS7MAFBxcJmTHDz1V9e7w0QSlCK0brHleimMurkMqvICPMJtO
ngiIRxO+QFyTMxJuVKHEgZnS7ZdrFtP9HPmxCEosoZ0cXvSq12EIGeDWuny+GszD
5HcB1OJGf0b8mHcGIVTPqOOy3t+ZMs7+jA+b1BZHs1PyigbQFawq0JzOVE8OBw==
=XYzs
-----END PGP SIGNATURE-----

--5JFmykIjAQpB3I89mw4l7C2lI0j3SmW7R--
