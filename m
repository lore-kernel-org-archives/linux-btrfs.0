Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64971 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbeASHjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 02:39:31 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <195d1a89-ba5d-081b-91de-f441679414c0@gmx.com>
Date: Fri, 19 Jan 2018 15:38:47 +0800
MIME-Version: 1.0
In-Reply-To: <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TmOPxZlAx20rAL8mx1H23HU63xctuUgjk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TmOPxZlAx20rAL8mx1H23HU63xctuUgjk
Content-Type: multipart/mixed; boundary="QAguR2PJHPUfMaDbucQR0OaxJeQ4jNRE0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com
Message-ID: <195d1a89-ba5d-081b-91de-f441679414c0@gmx.com>
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>
In-Reply-To: <9fe43408-dfcd-efa3-7195-87fcdba033ab@cn.fujitsu.com>

--QAguR2PJHPUfMaDbucQR0OaxJeQ4jNRE0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 15:39, Su Yue wrote:
>=20
>=20
> On 01/19/2018 03:25 PM, Qu Wenruo wrote:
>> btrfs_match_dir_item_name() will check if its filetype is valid before=

>> doing search, this makes btrfs-progs unable to locate and remove inval=
id
>> dir_index for btrfs_unlink().
>>
>> This function only affects btrfs_link() and btrfs_unlink() in upper
>> layer, and normal check can find invalid filetype by itself.
>>
> Lowmem mode can't handles wrong filetype well now.
> I'm working on it. And this change is okay for me.

I think you mean *original* mode can't handle it.

As v4.14.1 lowmem mode can detect such problem without problem:
-------
checking fs roots
ERROR: root 5 INODE_ITEM[258] index 2 name file1 filetype 34 mismath
ERROR: root 5 DIR INDEX[257 2] missing name file1 filetype 1
ERROR: errors found in fs roots
found 131072 bytes used, error(s) found
-------

And patch 1/3 will handle the repair, so it shouldn't be a problem for
lowmem.

Thanks,
Qu
>=20
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>=20
>> So remove the filetype check is completely safe in this case, and will=

>> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repair=
=2E
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 dir-item.c | 6 ------
>> =C2=A0 1 file changed, 6 deletions(-)
>>
>> diff --git a/dir-item.c b/dir-item.c
>> index 462546c0eaf4..e0a0ab4d7a5d 100644
>> --- a/dir-item.c
>> +++ b/dir-item.c
>> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *roo=
t,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 namelen =3D BTRFS_NAME_LEN;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 type =3D btrfs_dir_type(leaf, dir_it=
em);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (type >=3D BTRFS_FT_MAX) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "invalid d=
ir item type: %d\n",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (int)type);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 1;
>> -=C2=A0=C2=A0=C2=A0 }
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type =3D=3D BTRFS_FT_XATTR)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 namelen =3D XAT=
TR_NAME_MAX;
>> =C2=A0
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--QAguR2PJHPUfMaDbucQR0OaxJeQ4jNRE0--

--TmOPxZlAx20rAL8mx1H23HU63xctuUgjk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphoIcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjHLAf+OLc9r7OjrUTL0JMAOyKF1o1T
xrDeVvoq5UEA9fwqxaezf41rvCKD9ECXre/OZfooqhDGvRDzvOZtm7CJ5ZojnZJ5
OhXogFFRpCn4miOa5xgLyXgIIkeUKXeldb4/fbC5dyh3lCckKiRUxIh22Sbc9UdT
cFDzmWf60z6Fbi9ANrnvVva7jxdo7BhLwm8jSAr8ER5OB4TAtslMfHUXD2LmBuHD
AuOSMCySrnHfWtWdpigr5LyNVfWyCLSlvoNDarGTQAmMZbkEsFkQEDq8kgc9br78
eciBhg29p4+5qxay4OMMupsTXxfCmWCi/QXDboeP5/bOOniDGnsKTgLw8gsGTg==
=+Bd0
-----END PGP SIGNATURE-----

--TmOPxZlAx20rAL8mx1H23HU63xctuUgjk--
