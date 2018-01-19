Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbeASKjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 05:39:42 -0500
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
 <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
 <36928b14-2f3b-d072-de63-fb79a1734ea7@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <403e7168-aec5-e4b3-b7cf-687832d56c07@gmx.com>
Date: Fri, 19 Jan 2018 18:39:29 +0800
MIME-Version: 1.0
In-Reply-To: <36928b14-2f3b-d072-de63-fb79a1734ea7@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6UjAjpcH6P0746K26dwTtwo5fOMrmrgWl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6UjAjpcH6P0746K26dwTtwo5fOMrmrgWl
Content-Type: multipart/mixed; boundary="uxBWnVpPnWiEoIOiO7SX95Ky3HoRKa5hH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <403e7168-aec5-e4b3-b7cf-687832d56c07@gmx.com>
Subject: Re: [PATCH v2 2/3] btrfs-progs: dir-item: Don't do extra filetype
 validaction check for btrfs_match_dir_item_name
References: <20180119072536.22286-1-wqu@suse.com>
 <20180119072536.22286-3-wqu@suse.com>
 <56ce96dd-a711-c19e-b0b7-df65d305c763@suse.com>
 <cf26e3d3-61c4-2086-4414-64b5a004c0f7@gmx.com>
 <36928b14-2f3b-d072-de63-fb79a1734ea7@suse.com>
In-Reply-To: <36928b14-2f3b-d072-de63-fb79a1734ea7@suse.com>

--uxBWnVpPnWiEoIOiO7SX95Ky3HoRKa5hH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 18:21, Nikolay Borisov wrote:
>=20
>=20
> On 19.01.2018 12:03, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 17:40, Nikolay Borisov wrote:
>>>
>>>
>>> On 19.01.2018 09:25, Qu Wenruo wrote:
>>>> btrfs_match_dir_item_name() will check if its filetype is valid befo=
re
>>>> doing search, this makes btrfs-progs unable to locate and remove inv=
alid
>>>> dir_index for btrfs_unlink().>
>>>> This function only affects btrfs_link() and btrfs_unlink() in upper
>>>> layer, and normal check can find invalid filetype by itself.
>>>
>>> There is no function btrfs_link in btrfs-progs, there is, however,
>>> btrfs_add_link did you mean that function?
>>
>> Yep, sorry for the wrong name.
>>
>>> However, it doesn't seem to
>>> use verify_dir_item hence the check you are removing. I think this pa=
rt
>>> of the commit log should be more precise. Also it's not really clear
>>> what you mean by "normal check" in this sentence.
>>
>> I skipped several function calls.
>>
>> btrfs_add_link()
>> |- check_dir_conflict
>>    |- btrfs_lookup_dir_index() / btrfs_lookup_dir_item()
>>       |- btrfs_match_dir_item_name()
>>          |- verify_dir_item()
>>
>> And for btrfs_add_link() without checking invalid filetype, we can avo=
id
>> case like inserting duplicated DIR_ITEM/DIR_INDEX to avoid further
>> screwing up things.
>=20
> Right, since if verify_dir_item fails we just return NULL as opposed to=

> an error from btrfs_match_dir_item_name.
>=20
> <offtopic>
> Hm, so is it really possible to get a result for (key DIR_ITEM offset)
> and have btrfs_match_dir_item_name fail for that result?
>=20
> What I'm getting is that if btrfs_Search_slot returns 0 for such a quer=
y
> irrespective of whether the string name matches or not we should return=

> some error code other than NULL ?

This sounds reasonable, but it may end up as replacing NULL to
PTR_ERR(-ENOENT).
Not much different for callers though.

Thanks,
Qu

> </offtopic>
>=20
>=20
>>
>> For btrfs_unlink() it will be different story, as btrfs_unlink() can
>> locate the conflicting but invalid DIR_ITEM/DIR_INDEX and remove it,
>> allow us to fix the problem.
>>
>> And by "normal check" I mean btrfs check.
>>
>> I'll add the call trace to it.
>>
>>>>
>>>> So remove the filetype check is completely safe in this case, and wi=
ll
>>>> enhance btrfs_unlink() to remove invalid dir_index/dir_item for repa=
ir.
>>>
>>> So the problem is that since btrfs_unlink calls verify_item and the
>>> latter has the filetype check in case of wrong filetype (corruption)
>>> verify_dir_item fails, hence we cannot perform the unlink? If my
>>> understanding is correct how about something like:
>>>
>>>
>>> If we have a corrupted dir item and enough information to repair it w=
e
>>> need to first delete the old/corrupted version and then insert a new
>>> one.
>>> However, btrfs_unlink calls btrfs_match_dir_item_name to locate the
>>> offending dir item for deletion. The latter, in turn, uses
>>> verify_dir_item which checks if the value for DIR item's type is sane=
=2E
>>> In case of a corrupted type value then verify_dir_item will fail whic=
h
>>> in turn will prevent btrfs_unlink from deleting the offending item.
>>
>> Your understanding is completely right, and much shorter than my plann=
ed
>> explanation.
>>
>> I'll take it with extra call trace.
>>
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  dir-item.c | 6 ------
>>>>  1 file changed, 6 deletions(-)
>>>>
>>>> diff --git a/dir-item.c b/dir-item.c
>>>> index 462546c0eaf4..e0a0ab4d7a5d 100644
>>>> --- a/dir-item.c
>>>> +++ b/dir-item.c
>>>> @@ -294,12 +294,6 @@ static int verify_dir_item(struct btrfs_root *r=
oot,
>>>>  	u16 namelen =3D BTRFS_NAME_LEN;
>>>>  	u8 type =3D btrfs_dir_type(leaf, dir_item);
>>>> =20
>>>> -	if (type >=3D BTRFS_FT_MAX) {
>>>> -		fprintf(stderr, "invalid dir item type: %d\n",
>>>> -		       (int)type);
>>>> -		return 1;
>>>> -	}
>>>> -
>>>>  	if (type =3D=3D BTRFS_FT_XATTR)
>>>>  		namelen =3D XATTR_NAME_MAX;
>>>> =20
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--uxBWnVpPnWiEoIOiO7SX95Ky3HoRKa5hH--

--6UjAjpcH6P0746K26dwTtwo5fOMrmrgWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphyuEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjuwAf9Ff3J++kFCwQ0XnhhNtnELkCg
/GNo9uA1GX40O1hcRz83X7JyyNIuPHPBxO142AXdqlQoj8dnfD9AFGQ098KYh608
/EBrI3a+tvgEuSfiMdZtIGp+cy6+/UlFCrtiPC8np2RgjLLMa2P/5LO12m8Nt8Zz
PfPlCdzsX5KMFHoMv4FiQewkfTXYiqXRJgScXVGKBPR37eJyz0vrinkf0jNBt8U6
vWq1IHZgTLAPHS+YyYYqZy/5HrZK5BuqvcNZdeOQJHHQWeuBE8SEp8GSqeXYvgmx
9V8l2BJn/sxoM9DHxbKl+lweTsc4I2EokWzoVEu+KvIqkseXchln6QiP/hoo0w==
=JhaF
-----END PGP SIGNATURE-----

--6UjAjpcH6P0746K26dwTtwo5fOMrmrgWl--
