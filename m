Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755759AbcIFDFV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 23:05:21 -0400
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        "'Sean Fu'" <fxinrong@gmail.com>, dsterba@suse.com
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
Cc: clm@fb.com, anand.jain@oracle.com, fdmanana@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57CE326C.8000105@suse.com>
Date: Mon, 5 Sep 2016 23:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bWbVm0NclpvbIfItRadq3S2L0BrGCkV7I"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bWbVm0NclpvbIfItRadq3S2L0BrGCkV7I
Content-Type: multipart/mixed; boundary="kIEFNld9BJkcQPAFA2pIhWPn6lLQuJOpP"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
 'Sean Fu' <fxinrong@gmail.com>, dsterba@suse.com
Cc: clm@fb.com, anand.jain@oracle.com, fdmanana@suse.com,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <57CE326C.8000105@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
In-Reply-To: <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>

--kIEFNld9BJkcQPAFA2pIhWPn6lLQuJOpP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/5/16 3:56 AM, Qu Wenruo wrote:
>=20
>=20
> At 09/05/2016 09:19 AM, Zhao Lei wrote:
>> Hi, Sean Fu
>>
>>> From: Sean Fu [mailto:fxinrong@gmail.com]
>>> Sent: Sunday, September 04, 2016 7:54 PM
>>> To: dsterba@suse.com
>>> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
>>> zhaolei@cn.fujitsu.com; linux-btrfs@vger.kernel.org;
>>> linux-kernel@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
>>> Subject: [PATCH] Btrfs: remove unnecessary code of chunk_root
>>> assignment in
>>> btrfs_read_chunk_tree.
>>>
>>> The input argument root is already set with "fs_info->chunk_root".
>>> "chunk_root =3D fs_info->chunk_root =3D btrfs_alloc_root(fs_info)" in=
 caller
>>> "open_ctree".
>>> =E2=80=9Croot->fs_info =3D fs_info=E2=80=9D in "btrfs_alloc_root".
>>>
>> The root argument of this function means "any root".
>> And the function is designed getting chunk root from
>> "any root" in head.
>>
>> Since there is only one caller of this function,
>> and the caller always send chunk_root as root argument in
>> current code, we can remove above conversion,
>> and I suggest renaming root to chunk_root to make it clear,
>> something like:
>>
>> - btrfs_read_chunk_tree(struct btrfs_root *root)
>> + btrfs_read_chunk_tree(struct btrfs_root *chunk_root)
>=20
> Since root is only used to get fs_info->chunk_root, why not use fs_info=

> directly?

Weird.  Exactly this was a part of my fs_info patchset.  I guess I need
to go back and check what else is missing.

-Jeff


> Thanks,
> Qu
>=20
>>
>> Thanks
>> Zhaolei
>>
>>> Signed-off-by: Sean Fu <fxinrong@gmail.com>
>>> ---
>>>  fs/btrfs/volumes.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 366b335..384a6d2 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *ro=
ot)
>>>      int ret;
>>>      int slot;
>>>
>>> -    root =3D root->fs_info->chunk_root;
>>> -
>>>      path =3D btrfs_alloc_path();
>>>      if (!path)
>>>          return -ENOMEM;
>>> --=20
>>> 2.6.2
>>>
>>
>>
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
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--kIEFNld9BJkcQPAFA2pIhWPn6lLQuJOpP--

--bWbVm0NclpvbIfItRadq3S2L0BrGCkV7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXzjJxAAoJEB57S2MheeWyiYEP/3VU1RXggdRn9Hb8iuKT35Jd
LKNXyeHb+/n5vRZ7uES5Ustg+s8gAkJfWFlSR/aj/w0DQUKhrCQQ2nEXnRGw8nOj
idneFh9L1mzRiMVtC4htnnmsox9UkijRfQK1jYjHRhWq7woLUGfSQe68zp3YLRnD
2bB6r6FYP/c9vU1D9hKqiK1uA+C8uL1hzwATlrnEznxb8Si2I23gZOCI9Qk9pIef
C4cN64Iqx48vn7OP3xQz1CMfOjhHkodba8nd74z9ei+o3QssssDBIirqFj1lUQrE
PNRcK7FS0xduUth+hRSRwhGvd6292o7u31DCKw5w17pzPJGQn1L48f3maxiojwc+
mPQoKepnmzVBkchkKz7R1y3GIi0WbJ1deB9oUpPOuim3fk5++xdr1/RVB9vfJcup
ASqj2pl35QfwtGMMsrK4JWqQ6CwGva1gjiKHhypyP8SN9btu1uf7iiKEwSTzDQYH
lj01dvZ108kjvIeUpo3vEd7B+D9AfG+GoXgGiQe5lWjZ416Y0pXvjxk6QNA8gOGM
Xwaw7KnycYQvGCQ6myAr/nhh1uWJZCMnKK4NQRwkga8y6SCVabO0vcyV43wCPudc
4NRgui8THUrJN7KL6K4csi7RFZ0+nQxgKl0ZX9z9rVelplD+TB0N3NHBDyw7/cye
obB+Ii7GaeZcZ0Z/rPwo
=esBQ
-----END PGP SIGNATURE-----

--bWbVm0NclpvbIfItRadq3S2L0BrGCkV7I--
