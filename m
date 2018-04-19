Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:47847 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeDSKY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 06:24:58 -0400
Subject: Re: [PATCH 2/3] btrfs: Add csum type check for
 btrfs_check_super_valid()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-2-wqu@suse.com> <20180419100931.GY21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d64c43e8-4d7c-a00b-894a-ea11861e10b8@gmx.com>
Date: Thu, 19 Apr 2018 18:24:44 +0800
MIME-Version: 1.0
In-Reply-To: <20180419100931.GY21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="56Yszba7w3K6hHjGJgmMdP9HUW7F5S0jj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--56Yszba7w3K6hHjGJgmMdP9HUW7F5S0jj
Content-Type: multipart/mixed; boundary="dGRQtpYe0Ql57KQnV3qufalW770c49qsD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <d64c43e8-4d7c-a00b-894a-ea11861e10b8@gmx.com>
Subject: Re: [PATCH 2/3] btrfs: Add csum type check for
 btrfs_check_super_valid()
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-2-wqu@suse.com> <20180419100931.GY21272@twin.jikos.cz>
In-Reply-To: <20180419100931.GY21272@twin.jikos.cz>

--dGRQtpYe0Ql57KQnV3qufalW770c49qsD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8819=E6=97=A5 18:09, David Sterba wrote:
> On Thu, Apr 19, 2018 at 05:38:15PM +0800, Qu Wenruo wrote:
>> Just like incompat flags check, although we have already done super cs=
um
>> type check before calling btrfs_check_super_valid(), we can still add
>> such check for later write time check.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/disk-io.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index ec123158f051..b189ec086bc2 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3981,6 +3981,15 @@ static int btrfs_check_super_valid(struct btrfs=
_fs_info *fs_info)
>>  	u64 sectorsize =3D btrfs_super_sectorsize(sb);
>>  	int ret =3D 0;
>> =20
>> +	/*
>> +	 * For write time check, as for mount time we have checked csum befo=
re
>> +	 * calling btrfs_check_super_valid(), so it must be a corruption
>> +	 */
>> +	if (btrfs_super_csum_type(sb) >=3D ARRAY_SIZE(btrfs_csum_sizes)) {
>> +		btrfs_err(fs_info, "corrupted csum type %u",
>> +			  btrfs_super_csum_type(sb));
>> +		ret =3D -EINVAL;
>> +	}
>>  	if (btrfs_super_magic(sb) !=3D BTRFS_MAGIC) {
>=20
> The test for magic should be IMO the first one, that's how the
> filesystem type is identified before anything else. Granted that the
> magic must be correct before it can be even mounted, but the code shoul=
d
> follow that logic too. Otherwise ok.

Makes sense, will update the patchset.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dGRQtpYe0Ql57KQnV3qufalW770c49qsD--

--56Yszba7w3K6hHjGJgmMdP9HUW7F5S0jj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrYbmwACgkQwj2R86El
/qjAjwf9Hf4+FdFCEWltwnRZP3hW9AJ27m0lLdhY+8IFvsmG14x2Xdrv8x/QQLv1
HvsC8ft3eTxBMjC7jEEOSXQ4gg7nNnR/zCVmXEg/fkSFmpTp/ZLVEb1wkWSs7Rhf
6A0ugspsIWXqilmm6qc1gCzNVQdbBM683Zqb7udZUaD45qMnkcMaGLO9Kn0oyxpk
vSDFeYp8A0m3r2eRXPKQwzYxkmuSKH83rPvi08u7LW4gVXf8FVqOlpaLIYUqBEvR
h4ZdLj/u9ZB+GlCGtT2jrT+4/I5g4NoTY7M4TOnRecDOZWm8hVTbNWcGeZpxdZBG
qHNJDfodWugMX2I4yR+WsDvMiluYvA==
=y+IO
-----END PGP SIGNATURE-----

--56Yszba7w3K6hHjGJgmMdP9HUW7F5S0jj--
