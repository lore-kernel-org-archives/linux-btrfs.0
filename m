Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbcIFDdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 23:33:42 -0400
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        "'Sean Fu'" <fxinrong@gmail.com>, dsterba@suse.com
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com>
Cc: clm@fb.com, anand.jain@oracle.com, fdmanana@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57CE3464.7090107@suse.com>
Date: Mon, 5 Sep 2016 23:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <57CE326C.8000105@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5are92eo69TehLA5aC5kvMojwxbOsKTlQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5are92eo69TehLA5aC5kvMojwxbOsKTlQ
Content-Type: multipart/mixed; boundary="9MErlW6XcNOTE4FAM7jOEctR1wgsVN2it"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
 'Sean Fu' <fxinrong@gmail.com>, dsterba@suse.com
Cc: clm@fb.com, anand.jain@oracle.com, fdmanana@suse.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <57CE3464.7090107@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com>
In-Reply-To: <57CE326C.8000105@suse.com>

--9MErlW6XcNOTE4FAM7jOEctR1wgsVN2it
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/5/16 11:05 PM, Jeff Mahoney wrote:
> On 9/5/16 3:56 AM, Qu Wenruo wrote:
>>
>>
>> At 09/05/2016 09:19 AM, Zhao Lei wrote:
>>> Hi, Sean Fu
>>>
>>>> From: Sean Fu [mailto:fxinrong@gmail.com]
>>>> Sent: Sunday, September 04, 2016 7:54 PM
>>>> To: dsterba@suse.com
>>>> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
>>>> zhaolei@cn.fujitsu.com; linux-btrfs@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
>>>> Subject: [PATCH] Btrfs: remove unnecessary code of chunk_root
>>>> assignment in
>>>> btrfs_read_chunk_tree.
>>>>
>>>> The input argument root is already set with "fs_info->chunk_root".
>>>> "chunk_root =3D fs_info->chunk_root =3D btrfs_alloc_root(fs_info)" i=
n caller
>>>> "open_ctree".
>>>> =E2=80=9Croot->fs_info =3D fs_info=E2=80=9D in "btrfs_alloc_root".
>>>>
>>> The root argument of this function means "any root".
>>> And the function is designed getting chunk root from
>>> "any root" in head.
>>>
>>> Since there is only one caller of this function,
>>> and the caller always send chunk_root as root argument in
>>> current code, we can remove above conversion,
>>> and I suggest renaming root to chunk_root to make it clear,
>>> something like:
>>>
>>> - btrfs_read_chunk_tree(struct btrfs_root *root)
>>> + btrfs_read_chunk_tree(struct btrfs_root *chunk_root)
>>
>> Since root is only used to get fs_info->chunk_root, why not use fs_inf=
o
>> directly?
>=20
> Weird.  Exactly this was a part of my fs_info patchset.  I guess I need=

> to go back and check what else is missing.

Actually, most of this didn't land.  Pretty much anything that's a root
->fs_info conversion is in there.

-Jeff

> -Jeff
>=20
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Thanks
>>> Zhaolei
>>>
>>>> Signed-off-by: Sean Fu <fxinrong@gmail.com>
>>>> ---
>>>>  fs/btrfs/volumes.c | 2 --
>>>>  1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 366b335..384a6d2 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *r=
oot)
>>>>      int ret;
>>>>      int slot;
>>>>
>>>> -    root =3D root->fs_info->chunk_root;
>>>> -
>>>>      path =3D btrfs_alloc_path();
>>>>      if (!path)
>>>>          return -ENOMEM;
>>>> --=20
>>>> 2.6.2
>>>>
>>>
>>>
>>>
>>>
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--9MErlW6XcNOTE4FAM7jOEctR1wgsVN2it--

--5are92eo69TehLA5aC5kvMojwxbOsKTlQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXzjRkAAoJEB57S2MheeWyI/QP/05PjHz1ctIQaUwRJBAXCOCk
Cly734Zxl8dOLUbuqTgOjdHVCZi+HUNubmsIEI3cM9fAyeYzpY9/jwtja1i1h7Wn
GVue/RQZiZ0SrEkfIOay47tpL3YNKOeA4ffeZ0j/sPqiQMighm28t2FatyjIcefq
nFnPXda/g1qeOUcLbig5RyIftQrP68l9/dEG1S9hvEMrq4RsR++pCSX5Dyx0oTVD
cGIgntiGuTa6csmyptwyrUJnq1xkSAf8f7F4QUtmi71ydE08n/pA2yK5aGwaxueu
emKIE8bz+2Qahw4nup10jDq7SfrOYDRS/7iGXbda9BvCNw4DJiQHTzQ5Ak8kBaw9
1tTHvY9BSkhyApWyiGFhuk8APMf8JB9iFM2UYmo5tzYjTFv/1HxrZlT5UfL94xCD
JKf+0rkqukjqXo/dyoduBULgAJsg++sdlJejTz8vscJfh3N6IMglON0iePG2vzNa
oGxZ7ld7Ig5R+7jAYCpqrHh7owFcqKcu+e7gtpzLKoxL1iDYkxKUz5tnXAYWsLCx
7h0TZ7+0BPq0xdm5Cpo8x7gX5IROLpan1tyHVjrxvJlh0A7a/2/3p3j3bXGoFesP
TK0pJRgdX/WsmKwC6jsISoK4fAdzSg+dnzDqAJaBvUwcY1jEYxUujR6YTfYrFKjX
U0NduJRKmD6ZooYlWCKI
=c9we
-----END PGP SIGNATURE-----

--5are92eo69TehLA5aC5kvMojwxbOsKTlQ--
