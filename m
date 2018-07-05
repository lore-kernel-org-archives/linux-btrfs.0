Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753346AbeGEJll (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 05:41:41 -0400
Subject: Re: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild
 root overwritting existing tree blocks
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-2-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A856B640@G08CNEXMBPEKD03.g08.fujitsu.local>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2a81613c-fdad-f7c9-7d12-bab4a67f8353@gmx.com>
Date: Thu, 5 Jul 2018 17:41:26 +0800
MIME-Version: 1.0
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A856B640@G08CNEXMBPEKD03.g08.fujitsu.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qx9vwGtHhxrneS8wdbLX8zR6CEw41ZJmh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qx9vwGtHhxrneS8wdbLX8zR6CEw41ZJmh
Content-Type: multipart/mixed; boundary="66uotGzXtRdjonWj5paK1Kr5mZeJXjiWp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <2a81613c-fdad-f7c9-7d12-bab4a67f8353@gmx.com>
Subject: Re: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild
 root overwritting existing tree blocks
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-2-wqu@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A856B640@G08CNEXMBPEKD03.g08.fujitsu.local>
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A856B640@G08CNEXMBPEKD03.g08.fujitsu.local>

--66uotGzXtRdjonWj5paK1Kr5mZeJXjiWp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8805=E6=97=A5 16:50, Gu, Jinxiang wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger=
=2Ekernel.org] On Behalf Of Qu Wenruo
>> Sent: Thursday, July 05, 2018 3:37 PM
>> To: linux-btrfs@vger.kernel.org
>> Subject: [PATCH 1/4] btrfs-progs: check: Remove the ability to rebuild=
 root overwritting existing tree blocks
>>
>> We have function btrfs_fsck_reinit_root() to reinit csum or extent tre=
e.
>=20
> Nit=EF=BC=9A
> or fs/file tree

Nope, btrfs check is only capable of reinit csum or extent tree.

Thanks,
Qu

>=20
>> However this function allows us to let it overwrite existing tree bloc=
ks
>> using @overwrite parameter.
>>
>> Such behavior is pretty dangerous while no caller is using this featur=
e
>> explicitly.
>>
>> So just remove @overwrite parameter and allow btrfs_fsck_reinit_root()=

>> to error out when it fails to allocate tree block.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c | 26 ++++++++------------------
>>  1 file changed, 8 insertions(+), 18 deletions(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 8db300abb825..c8c347236543 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -8379,7 +8379,7 @@ static int do_check_chunks_and_extents(struct bt=
rfs_fs_info *fs_info)
>>  }
>>
>>  static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
>> -			   struct btrfs_root *root, int overwrite)
>> +				  struct btrfs_root *root)
>>  {
>>  	struct extent_buffer *c;
>>  	struct extent_buffer *old =3D root->node;
>> @@ -8389,21 +8389,13 @@ static int btrfs_fsck_reinit_root(struct btrfs=
_trans_handle *trans,
>>
>>  	level =3D 0;
>>
>> -	if (overwrite) {
>> -		c =3D old;
>> -		extent_buffer_get(c);
>> -		goto init;
>> -	}
>>  	c =3D btrfs_alloc_free_block(trans, root,
>>  				   root->fs_info->nodesize,
>>  				   root->root_key.objectid,
>>  				   &disk_key, level, 0, 0);
>> -	if (IS_ERR(c)) {
>> -		c =3D old;
>> -		extent_buffer_get(c);
>> -		overwrite =3D 1;
>> -	}
>> -init:
>> +	if (IS_ERR(c))
>> +		return PTR_ERR(c);
>> +
>>  	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
>>  	btrfs_set_header_level(c, level);
>>  	btrfs_set_header_bytenr(c, c->start);
>> @@ -8422,9 +8414,7 @@ init:
>>  	/*
>>  	 * this case can happen in the following case:
>>  	 *
>> -	 * 1.overwrite previous root.
>> -	 *
>> -	 * 2.reinit reloc data root, this is because we skip pin
>> +	 * reinit reloc data root, this is because we skip pin
>>  	 * down reloc data tree before which means we can allocate
>>  	 * same block bytenr here.
>>  	 */
>> @@ -8609,7 +8599,7 @@ reinit_data_reloc:
>>  		goto out;
>>  	}
>>  	record_root_in_trans(trans, root);
>> -	ret =3D btrfs_fsck_reinit_root(trans, root, 0);
>> +	ret =3D btrfs_fsck_reinit_root(trans, root);
>>  	if (ret)
>>  		goto out;
>>  	ret =3D btrfs_make_root_dir(trans, root, BTRFS_FIRST_FREE_OBJECTID);=

>> @@ -8675,7 +8665,7 @@ again:
>>  	}
>>
>>  	/* Ok we can allocate now, reinit the extent root */
>> -	ret =3D btrfs_fsck_reinit_root(trans, fs_info->extent_root, 0);
>> +	ret =3D btrfs_fsck_reinit_root(trans, fs_info->extent_root);
>>  	if (ret) {
>>  		fprintf(stderr, "extent root initialization failed\n");
>>  		/*
>> @@ -9764,7 +9754,7 @@ int cmd_check(int argc, char **argv)
>>
>>  		if (init_csum_tree) {
>>  			printf("Reinitialize checksum tree\n");
>> -			ret =3D btrfs_fsck_reinit_root(trans, info->csum_root, 0);
>> +			ret =3D btrfs_fsck_reinit_root(trans, info->csum_root);
>>  			if (ret) {
>>  				error("checksum tree initialization failed: %d",
>>  						ret);
>> --
>=20
> Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>
>=20
>=20
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20
>=20
> N=E5=AB=A5=E5=8F=89=E9=9D=A3=E7=AC=A1y=EE=8C=B7=E6=B0=8Ab=E7=9E=82=EE=83=
=91=E5=8D=83v=E8=B1=9D=EF=BF=BD)=E8=97=93{.n=EF=BF=BD+=E5=A3=8F=EE=9A=8F{=
=E7=9C=93=E8=B0=B6=EF=BF=BD)=E9=9F=B0=E9=AA=85w*=1Fjg=EE=83=8C=EF=BF=BD=1E=
=E7=A7=B9=E6=AE=A0=E5=A8=B8=EE=95=90/=E4=BE=81=E9=8B=A4=E7=BD=90=E6=9E=88=
=EF=BF=BD2=E5=A8=B9=E6=AB=92=E7=92=80=EF=BF=BD&=EF=BF=BD)=E6=91=BA=E7=8E=9C=
=E5=9B=A4=7F=EE=92=BF=1E=E7=93=BD=E7=8F=B4=E9=96=94=EF=BF=BD=0F=E9=8E=97:=
+v=E5=A2=BE=E5=A6=9B=E9=91=B6=E4=BD=B6
>=20


--66uotGzXtRdjonWj5paK1Kr5mZeJXjiWp--

--Qx9vwGtHhxrneS8wdbLX8zR6CEw41ZJmh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls958YACgkQwj2R86El
/qgn6wgAl/sGmb4XV8EQB6GcJE/DnhL2uTVqEDRih+2QV3JnlC5/vw5k2ZbNhenl
wZcaioxhOQ0v8oHdO5sdpyAa2w7kiN9gEqy5av1V3ZwuV3WrlGRjnKIHdQSLsgwx
7pVkMhmTIypxildNFBQFxlFl0lXbcAcijBTGCwoh87Sgp7KecLfhvXER6Zts1VKb
XahAh22GoC3Vjtwg4lLCRtxcmCTIzuwV2AdBQDDb8d+FEOAjfvsNBrukA8XwxrI5
jSQ21Kyf1IWLjVR8xrNJqOrGEV5Z0eRrMdoNLWCuMfQ0h49GatUfTMPElpkzSdWc
0CxWIWZXETOQU7zxkf2/NEIfRDfpZg==
=FfDY
-----END PGP SIGNATURE-----

--Qx9vwGtHhxrneS8wdbLX8zR6CEw41ZJmh--
