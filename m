Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933022AbeCBLkb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 06:40:31 -0500
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
To: fdmanana@gmail.com
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
 <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
 <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
Date: Fri, 2 Mar 2018 19:40:14 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o8FEfAX4gKDSmLsNlsNrWSzA720XDMwxo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o8FEfAX4gKDSmLsNlsNrWSzA720XDMwxo
Content-Type: multipart/mixed; boundary="09ayly227AUn3A9IRZKWdmR6vKfwBlZ2w";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
 dsterba@suse.cz
Message-ID: <8af18593-05ff-e24c-1c39-0492cce2c21b@gmx.com>
Subject: Re: [PATCH 2/5] btrfs: Always limit inline extent size by
 uncompressed size
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-3-wqu@suse.com>
 <CAL3q7H68aJYeTtU=-sSeMvfxSiQ_Fda4N2o-On2x9tWexRG9bg@mail.gmail.com>
 <7f7b8437-8def-18be-3e94-6a50c2bfabda@gmx.com>
 <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>
In-Reply-To: <CAL3q7H6YN7-Vd8oaxH_7J41Bfhjor_XyC5NvsC0-tZ_UhfT_=g@mail.gmail.com>

--09ayly227AUn3A9IRZKWdmR6vKfwBlZ2w
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 19:00, Filipe Manana wrote:
> On Fri, Mar 2, 2018 at 10:54 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 18:46, Filipe Manana wrote:
>>> On Fri, Mar 2, 2018 at 5:22 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>> Normally when specifying max_inline, we should normally limit it by
>>>> uncompressed extent size, as it's the only thing user can control.
>>>
>>> Why does it matter that users can control it? Will they write less (o=
r
>>> more) data to files because stuff won't get inlined?
>>> Why do they care about stuff getting inlined or not? That's an
>>> implementation detail of btrfs to speed up access to file data and
>>> save some space.
>>
>> Then why we still have max_inline mount option?
>=20
> My comment was about deciding based on which size to make the decision
> (compressed vs uncompressed).

The same thing, we have given user options to trigger the behavior, then
we should give them *predictable* option to modify the behavior.

Not something confusing like current max_inline.

Either we give user max_inline and max_inline_compressed, or both follow
max_inline.

Thanks,
Qu

>=20
>> Just do everything we *think* is best is good enough in that case.
>>
>> If we provide that mount option to allow *user* to specify the behavio=
r,
>> then allow then to do the same control.
>>
>> Thanks,
>> Qu
>>
>>>
>>>> (Control the algorithm and compressed data is almost impossible)
>>>>
>>>> Since btrfs is providing *TRANSPARENT* compression, max_inline shoul=
d
>>>> behave the same for both plain and compress data.
>>>
>>> Taking away the benefits of compression for. So now some cases that
>>> ended up getting the benefits of inlining won't get them anymore.
>>>
>>> I don't agree with this change.
>>
>>
>>>
>>>>
>>>> So this patch will use @inline_len instead of @data_len in
>>>> cow_file_range_inline() so user will know their max_inline mount opt=
ion
>>>> works exactly the same for both plain and compressed data extent.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/inode.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index e1a7f3cb5be9..48472509239b 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -303,7 +303,7 @@ static noinline int cow_file_range_inline(struct=
 btrfs_root *root,
>>>>             (!compressed_size &&
>>>>             (actual_end & (fs_info->sectorsize - 1)) =3D=3D 0) ||
>>>>             end + 1 < isize ||
>>>> -           data_len > fs_info->max_inline) {
>>>> +           inline_len > fs_info->max_inline) {
>>>>                 return 1;
>>>>         }
>>>>
>>>> --
>>>> 2.16.2
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>
>=20
>=20
>=20


--09ayly227AUn3A9IRZKWdmR6vKfwBlZ2w--

--o8FEfAX4gKDSmLsNlsNrWSzA720XDMwxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqZOB4XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhs4Qf/cwQsdhf3FukQcxgZvGrPzznt
oR9OGuRq4vFGe4HRDZJ+DzRWxjaTNpZoAoXOR9za71UyybnKlzy720QF70gdUkEA
C1zjw0IHLs1J0DrppUIwQUfAccSOa4c0wHNfZnbypsfMQg26qwEGUNvAP4hyYlAr
fIDadBgixqEDuwC+q04cSnm0JLnSVR+Z2rKWh281NysyBvn42kiHMb/TCxhlaAIP
a/QjPvx8X/LL5g7pfSj9K4IGDFTk9DicQcCpmXUWCqsRF0aeieQOS18QZtzRPm9C
n0B+Gd1ZZJ9qw8kdTGV2ZIPqPKwn8wWwt01fTWzTXScZIely3mGmG4PenInAzw==
=BMxt
-----END PGP SIGNATURE-----

--o8FEfAX4gKDSmLsNlsNrWSzA720XDMwxo--
