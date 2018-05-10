Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934395AbeEJAim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 20:38:42 -0400
Subject: Re: [PATCH] btrfs: return original error code when failing from
 option parsing
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
 <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>
Message-ID: <ab73c999-06c0-8b5f-f7ca-8431b8276426@gmx.com>
Date: Thu, 10 May 2018 08:38:25 +0800
MIME-Version: 1.0
In-Reply-To: <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4Ge7WWj9f1KGziZE8hA690duhpHWqQnYv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4Ge7WWj9f1KGziZE8hA690duhpHWqQnYv
Content-Type: multipart/mixed; boundary="AcfnzabinD7aCRhr7vSnNq3n7BxirjYtI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
 dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <ab73c999-06c0-8b5f-f7ca-8431b8276426@gmx.com>
Subject: Re: [PATCH] btrfs: return original error code when failing from
 option parsing
References: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
 <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>
In-Reply-To: <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>

--AcfnzabinD7aCRhr7vSnNq3n7BxirjYtI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8810=E6=97=A5 08:34, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B405=E6=9C=8809=E6=97=A5 21:08, Chengguang Xu wrote:
>> It's no good to overwrite -ENOMEM using -EINVAL when failing
>> from mount option parsing, so just return original error code.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>=20
> Thanks,
> Qu
>=20
>> ---
>>  fs/btrfs/super.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 0628092..ae6447d 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -1783,7 +1783,6 @@ static int btrfs_remount(struct super_block *sb,=
 int *flags, char *data)
>> =20
>>  	ret =3D btrfs_parse_options(fs_info, data, *flags);
>>  	if (ret) {
>> -		ret =3D -EINVAL;
>>  		goto restore;
>>  	}

Just a small nitpick, for single line branch, the bracket should be
removed according to code style.

Thanks,
Qu

>> =20
>>
>=20


--AcfnzabinD7aCRhr7vSnNq3n7BxirjYtI--

--4Ge7WWj9f1KGziZE8hA690duhpHWqQnYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrzlIEACgkQwj2R86El
/qjNKggAseiKxWFyxvfXwFr51lWORQXI+iWzv+SIOxAJ2OyA7vrdY3JcotQefr92
VXWcOe7Uipp/IEZYbUq6qIk/rfLqdhe8nJ3eYhoBAmk3aMgmJC7zTiP60dATKlHx
ZJn0eeXLg/mX8s/eES7AtsHn2TERJ+Qfndm9kuN/3qOiHAGowN0uPbMMnQm0Ujgc
Dwmo6IGRxB+MenUHDNOn30gdZq8R5oGS14xVgryOj+rbgqPLguR2nxyw8/EDgKkR
qPCUrc5cYzuHOZY9diIC5dCF0l3WRyxDg1W+iW/3+ykc4jJNFEo9QxOxIXa2cLY/
rvFHUn++XJt+yCJX0oSGuDunlVa3Wg==
=0+Gq
-----END PGP SIGNATURE-----

--4Ge7WWj9f1KGziZE8hA690duhpHWqQnYv--
