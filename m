Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:40631 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbeHUIQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 04:16:02 -0400
Subject: Re: [PATCH] btrfs: Always check nocow for quota enabled case to make
 sure we won't reserve unnecessary data space
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180815061323.23936-1-wqu@suse.com>
 <1c8e89b5-eed8-8fdd-33bd-80a9d579fc21@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b4bde13b-250f-f4af-0cd6-cd729a0957ad@gmx.com>
Date: Tue, 21 Aug 2018 12:57:11 +0800
MIME-Version: 1.0
In-Reply-To: <1c8e89b5-eed8-8fdd-33bd-80a9d579fc21@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YZ3FFTNbFCwAAtFpUybMGTYUALMCSFh2J"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YZ3FFTNbFCwAAtFpUybMGTYUALMCSFh2J
Content-Type: multipart/mixed; boundary="gG0C7ENrhrrGE0fVBKCxFkCNM8bS7Z3Qv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b4bde13b-250f-f4af-0cd6-cd729a0957ad@gmx.com>
Subject: Re: [PATCH] btrfs: Always check nocow for quota enabled case to make
 sure we won't reserve unnecessary data space
References: <20180815061323.23936-1-wqu@suse.com>
 <1c8e89b5-eed8-8fdd-33bd-80a9d579fc21@jp.fujitsu.com>
In-Reply-To: <1c8e89b5-eed8-8fdd-33bd-80a9d579fc21@jp.fujitsu.com>

--gG0C7ENrhrrGE0fVBKCxFkCNM8bS7Z3Qv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/21 =E4=B8=8B=E5=8D=8812:21, Misono Tomohiro wrote:
> On 2018/08/15 15:13, Qu Wenruo wrote:
>> Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>> makes nocow check less frequent to improve performance.
>>
>> However for quota enabled case, such optimization could lead to extra
>> unnecessary data reservation, which results failure for test case like=

>> btrfs/153 in fstests.
>>
>> Fix it by reverting to old behavior for quota enabled case.
>>
>> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/file.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index 51e77d72068a..f2ce1d707d4c 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1587,6 +1587,7 @@ static noinline ssize_t __btrfs_buffered_write(s=
truct file *file,
>>  	int ret =3D 0;
>>  	bool only_release_metadata =3D false;
>>  	bool force_page_uptodate =3D false;
>> +	bool quota_enabled =3D test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->fl=
ags);
>> =20
>>  	nrptrs =3D min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>>  			PAGE_SIZE / (sizeof(struct page *)));
>> @@ -1627,9 +1628,15 @@ static noinline ssize_t __btrfs_buffered_write(=
struct file *file,
>>  				fs_info->sectorsize);
>> =20
>>  		extent_changeset_release(data_reserved);
>> -		ret =3D btrfs_check_data_free_space(inode, &data_reserved, pos,
>> +		/*
>> +		 * If we have quota enabled, we must do the heavy lift nocow
>> +		 * check here to avoid reserving data space, or we can hit
>> +		 * limitation for NOCOW files.
>> +		 */
>> +		if (!quota_enabled)
>> +			ret =3D btrfs_check_data_free_space(inode, &data_reserved, pos,
>>  						  write_bytes);
>> -		if (ret < 0) {
>> +		if (ret < 0 || quota_enabled) {
>>  			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
>>  						      BTRFS_INODE_PREALLOC)) &&>  			    check_can_nocow(BTRFS_=
I(inode), pos,
>>
>=20
> This fixes btrfs/153 but in turn makes other qgroup tests fail (022,091=
 etc.)

Thanks for the test.
I also found the problem too.

>=20
> If quota is enabled and file is not marked as nocow, above if is false =
and write will stop.
> so I think we still need to call btrfs_check_dta_free_space() when quot=
a is enabled
> and file is not nocow, right?

Yes, we should btrfs_check_data_free_space() check.

I only considered quota+nocow and noquota case.
For quota+cow case it should goes the normal way.

I'll check if there is any better solution to organize the code.

Thanks,
Qu


--gG0C7ENrhrrGE0fVBKCxFkCNM8bS7Z3Qv--

--YZ3FFTNbFCwAAtFpUybMGTYUALMCSFh2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt7m6cACgkQwj2R86El
/qgrCgf/Rc+w26UcyRRNImEYvpPdgT/98r/Lgb7094opGb4mVhM8MrOsF/RnZ8eA
5E3Cgvi/pWUW1oK9brH3V9UpFZ/ikmK0jHZ69WEdYE+wSdWbNxgpi6u9rtNgcAa1
cYim3rudCKt4l2skDAofk7unuIvOfqpilW4UFpIXjciYaw4dt1QFhmIUc1eYXeMs
fVqJk+xDaamddFgEgUdCm7/LJVk+irqreuiy4KeGqVmvIZcqHHdxjtJvVutWGWSr
fN03wyNI+dg8G2bVBkml1QvfS8iZIsgf13K1CqicY/YKCKtwDCCxKd3/5G72bNMY
N3TBCpr6iu4gTNl6p15Iqn+RMy0rUA==
=pLZg
-----END PGP SIGNATURE-----

--YZ3FFTNbFCwAAtFpUybMGTYUALMCSFh2J--
