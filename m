Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:45427 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754634AbeCVOSE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:18:04 -0400
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
 <20180322140041.GB6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
Date: Thu, 22 Mar 2018 22:17:49 +0800
MIME-Version: 1.0
In-Reply-To: <20180322140041.GB6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L2Ol6uCOFXMVp0ZyvMLkUOtI38jQwgL0d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L2Ol6uCOFXMVp0ZyvMLkUOtI38jQwgL0d
Content-Type: multipart/mixed; boundary="vQO3xpiPjS7j8KxIaXCXzD1KYh6RCY0bs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <1cecd52c-74f5-5c2b-73ba-c5b817bbe18f@gmx.com>
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
 <20180322140041.GB6955@twin.jikos.cz>
In-Reply-To: <20180322140041.GB6955@twin.jikos.cz>

--vQO3xpiPjS7j8KxIaXCXzD1KYh6RCY0bs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 22:00, David Sterba wrote:
> On Thu, Mar 22, 2018 at 09:53:46PM +0800, Qu Wenruo wrote:
>>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>>> index 26484648d090..3866b8ab20f1 100644
>>>> --- a/fs/btrfs/backref.c
>>>> +++ b/fs/btrfs/backref.c
>>>> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info=
 *fs_info,
>>>>  		BUG_ON(ref->key_for_search.type);
>>>>  		BUG_ON(!ref->wanted_disk_byte);
>>>> =20
>>>> -		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0);
>>>> +		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
>>>> +				     0);
>>>
>>> Please add 2nd function that will take the extended parameters and
>>> keep read_tree_block as is.
>>
>> So for any new caller of read_tree_block(), reviewer is the last perso=
n
>> to info the author to use these parameters for safety check?
>>
>> And in fact, the old function should be avoid if possible, I think the=

>> new parameters act as a pretty good sign to make any caller double thi=
nk
>> about this.
>=20
> I saw half of the new parameters were just 0, NULL, so this looks like =
a
> lot of code churn and I haven't looked closer if there's a chance to
> fill the parameters in all callsites. So if it's a matter of adding the=
m
> incrementally then fine.
>=20
I'm afraid some of the call sites (ones I left with NULL, 0) are unable
to pass the new parameters by its nature.

Such callers include:
1) Tree root
   Just @bytenr and @gen from ROOT_ITEM. No @first_key.

2) Backref walker for FULL_BACKREF
   Only parent bytenr, no extra info on @first_key.

But despite of such call sites, every top-down reader should grab first
key and level. (And so I did in the patch).

BTW, about half of the read_tree_block() callers are using the new
parameters.
So a new function seems a little embarrassing here.

Thanks,
Qu


--vQO3xpiPjS7j8KxIaXCXzD1KYh6RCY0bs--

--L2Ol6uCOFXMVp0ZyvMLkUOtI38jQwgL0d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzuw0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhC4Af9Fdk3VzW/wkH9oJfL8AMZuzHt
UZ3BmE6OHLUPDdFsfY+FhseyKm5N1f+O6+aXlnvCiI4XD4WoD/GGKGbo5/vAXvNZ
R8LjJthGtc7PhoguLaWVe1RgeWyR+Okz8wSo6R5PPCpFUVDw9p1CME0+eHwSusYM
jmmCDS7jWL8w8L7jU0bf92KtsndKe0XbQdvVB++UWSHuIjQXfFrFzPQiWgXIgT77
YBJGUkJ4tWLa5ESzbC4p7BnWUPKmcUo3okjhYKlBifzgfF071ErF6Ves6hnTOnoC
Cd0V71SU/biO/GG3sMiodILMy/cTVDb2PkYrugX2+/gfacWVxiTW1obEb6kA+w==
=pFZ/
-----END PGP SIGNATURE-----

--L2Ol6uCOFXMVp0ZyvMLkUOtI38jQwgL0d--
