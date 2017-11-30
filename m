Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64418 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753082AbdK3GtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:49:23 -0500
Subject: Re: [PATCH v3 2/3] btrfs-progs: fi defrag: do not exit if defrag
 range ioctl is unsupported
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
 <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>
Message-ID: <1b2de721-70c3-6a2c-e6aa-e6d6b025fbd6@gmx.com>
Date: Thu, 30 Nov 2017 14:49:09 +0800
MIME-Version: 1.0
In-Reply-To: <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3htuFnjwO9QqQCF5rFKSFiqhEIJbAKmOa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3htuFnjwO9QqQCF5rFKSFiqhEIJbAKmOa
Content-Type: multipart/mixed; boundary="UOoJEvRho80f00RmUkId631LimrgsokH9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Message-ID: <1b2de721-70c3-6a2c-e6aa-e6d6b025fbd6@gmx.com>
Subject: Re: [PATCH v3 2/3] btrfs-progs: fi defrag: do not exit if defrag
 range ioctl is unsupported
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
 <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>
In-Reply-To: <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>

--UOoJEvRho80f00RmUkId631LimrgsokH9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8830=E6=97=A5 14:37, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B411=E6=9C=8829=E6=97=A5 10:12, Su Yue wrote:
>> If ioctl of defrag range is unsupported, defrag will exit immediately.=

>>
>> Since caller can handle the error, let cmd_filesystem_defrag()
>> close file, break the loop and return error instead of calling exit(1)=
=2E
>>
>> Suggested-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>=20
> Thanks,
> Qu

Please ignore my tag.

The best solution is mentioned in the 1st patch.

Thanks,
Qu

>> ---
>> Changelog:
>> v2:	Separate the patch from commit 6e991b9161fa ("btrfs-progs: fi
>> 	defrag: clean up duplicate code if find errors").
>> v3:	Call close_file_or_dir() before breaking the loop.
>> ---
>>  cmds-filesystem.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
>> index 17d399d58adf..232d4e88e0c0 100644
>> --- a/cmds-filesystem.c
>> +++ b/cmds-filesystem.c
>> @@ -1049,8 +1049,10 @@ static int cmd_filesystem_defrag(int argc, char=
 **argv)
>>  		if (recursive && S_ISDIR(st.st_mode)) {
>>  			ret =3D nftw(argv[i], defrag_callback, 10,
>>  						FTW_MOUNT | FTW_PHYS);
>> -			if (ret =3D=3D ENOTTY)
>> -				exit(1);
>> +			if (ret =3D=3D ENOTTY) {
>> +				close_file_or_dir(fd, dirstream);
>> +				break;
>> +			}
>>  			/* errors are handled in the callback */
>>  			ret =3D 0;
>>  		} else {
>>
>=20


--UOoJEvRho80f00RmUkId631LimrgsokH9--

--3htuFnjwO9QqQCF5rFKSFiqhEIJbAKmOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofqeUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjqHgf8CCh7SY0lXqpq5sQPbrLh1mfl
8cZpH0LuO7mEgqGAfLLTp1Enfar9/VSzTQs9g1yTGFCsUWbumhnID1pRuiB6Iv5m
c/F9vHshAzlP5aawblEbxesIBxt6GtExF2+wpy8ETHGYeVRWSKZQAbibqOpwF+9P
fPWUVKUxWyNkyY/483F8GWDvNUPD85D0esrmcaaJ4uzwYNLpRZeWMumPu9Lc53YO
RKIERQU0/YrIZ9FjnplTad3pjUQyOiu3m4H37jgFLM+aRKr8gcZUYwzs2Cynhy8R
sZAty3UAXKQqXlUSTEvXHFsssEoi7CIkY3L+nh+0j4Y+N1KWI6URcFrkUAJSIw==
=hBDq
-----END PGP SIGNATURE-----

--3htuFnjwO9QqQCF5rFKSFiqhEIJbAKmOa--
