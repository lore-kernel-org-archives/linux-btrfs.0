Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50281 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdJYAjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 20:39:12 -0400
Subject: Re: [PATCH 2/6] btrfs: qgroup: Introduce helpers to update and access
 new qgroup rsv
To: Edmund Nadolski <enadolski@suse.de>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-3-wqu@suse.com>
 <e2eda958-e17f-757b-f704-1b0371cd4ed7@suse.com>
 <5c5e54d4-dd24-45c9-139d-bec97b00de4d@suse.com>
 <345c9676-0199-97dc-f897-b7418faea469@suse.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <25b2a9d3-5eb1-e55e-6afb-611a5127768a@gmx.com>
Date: Wed, 25 Oct 2017 08:38:56 +0800
MIME-Version: 1.0
In-Reply-To: <345c9676-0199-97dc-f897-b7418faea469@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fjHxf08CXj2Istj2UWME6g1ejo06mLmSR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fjHxf08CXj2Istj2UWME6g1ejo06mLmSR
Content-Type: multipart/mixed; boundary="9Fonu57Q3EvWJpDdj2q96VkDG4CuxCqmO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Edmund Nadolski <enadolski@suse.de>, Qu Wenruo <wqu@suse.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Message-ID: <25b2a9d3-5eb1-e55e-6afb-611a5127768a@gmx.com>
Subject: Re: [PATCH 2/6] btrfs: qgroup: Introduce helpers to update and access
 new qgroup rsv
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-3-wqu@suse.com>
 <e2eda958-e17f-757b-f704-1b0371cd4ed7@suse.com>
 <5c5e54d4-dd24-45c9-139d-bec97b00de4d@suse.com>
 <345c9676-0199-97dc-f897-b7418faea469@suse.de>
In-Reply-To: <345c9676-0199-97dc-f897-b7418faea469@suse.de>

--9Fonu57Q3EvWJpDdj2q96VkDG4CuxCqmO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8825=E6=97=A5 00:22, Edmund Nadolski wrote:
>=20
>=20
> On 10/24/2017 06:05 AM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 19:07, Nikolay Borisov wrote:
>>>
>>>
>>> On 24.10.2017 11:39, Qu Wenruo wrote:
>>>> Introduce helpers to:
>>>>
>>>> 1) Get total reserved space
>>>>    For limit calculation
>>>>
>>>> 2) Increase reserved space for given type
>>>> 2) Decrease reserved space for given type
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/qgroup.c | 66 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>>>>  1 file changed, 66 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index fe3adb996883..04fd145516ad 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -47,6 +47,72 @@
>>>>   *  - check all ioctl parameters
>>>>   */
>>>> =20
>>>> +/*
>>>> + * Helpers to access qgroup reservation
>>>> + *
>>>> + * Callers should ensure the lock context and type are valid
>>>> + */
>>>> +
>>>> +static u64 qgroup_rsv_total(const struct btrfs_qgroup *qgroup)
>>>> +{
>>>> +	u64 ret =3D 0;
>>>> +	int i;
>>>> +
>>>> +	for (i =3D 0; i <=3D BTRFS_QGROUP_RSV_TYPES; i++)
>>>
>>> So if you actually take up on my idea of having an explicit value whi=
ch
>>> denotes the end, the loop here would be just < *_END rather than the =
<=3D
>>> which instantly looks suspicious of an off-by-one error.
>>
>> Yeah, I really like to do it, as mentioned in previous mail.
>>
>> But to follow the schema used elsewhere, I had no choice.
>>
>>>
>>>> +		ret +=3D qgroup->rsv.values[i];
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type t=
ype)
>>>> +{
>>>> +	if (type =3D=3D BTRFS_QGROUP_RSV_DATA)
>>>> +		return "data";
>>>> +	if (type =3D=3D BTRFS_QGROUP_RSV_META)
>>>> +		return "meta";
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +static void qgroup_rsv_increase(struct btrfs_qgroup *qgroup, u64 nu=
m_bytes,
>>>> +				enum btrfs_qgroup_rsv_type type)
>>>> +{
>>>> +	qgroup->rsv.values[type] +=3D num_bytes;
>>>> +}
>>>> +
>>>> +static void qgroup_rsv_decrease(struct btrfs_qgroup *qgroup, u64 nu=
m_bytes,
>>>> +				enum btrfs_qgroup_rsv_type type)
>>>> +{
>>>> +	if (qgroup->rsv.values[type] >=3D num_bytes) {
>>>> +		qgroup->rsv.values[type] -=3D num_bytes;
>>>> +		return;
>>>> +	}
>>>> +#ifdef CONFIG_BTRFS_DEBUG
>>>> +	WARN_RATELIMIT(1,
>>>> +		"qgroup %llu %s reserved space underflow, have %llu to free %llu"=
,
>>>> +		qgroup->qgroupid, qgroup_rsv_type_str(type),
>>>> +		qgroup->rsv.values[type], num_bytes);
>>>> +#endif
>>>> +	qgroup->rsv.values[type] =3D 0;
>>>> +}
>>>
>>>
>>> Perhaps these could be modelled after
>>> block_rsv_use_bytes/block_rsv_add_bytes ? I'm not entirely sure of wh=
at
>>> increasing the value actually does - reserving bytes or using already=

>>> reserved bytes, I guess it should be reserving. In this case what abo=
ut
>>> qgroup_bytes_reserve/qgroup_bytes_(free|unreserve) ?
>>
>> I'm really bad at naming functions.
>> My original idea is qgroup_rsv_add() and qgroup_rsv_rename(), but
>> "rename" is 3 characters longer than "add", which makes me quite
>> uncomfortable.
>> (Maybe 'add' and 'sub' better?)
>>
>> For the "reserve|free", it can be easily confused with
>> btrfs_qgroup_reserve|release_data().
>>
>> But in fact, this qgroup_rsv_* functions are only used to maintain
>> qgroup->rsv, so it's less meaningful compared to other functions, like=

>> btrfs_qgroup_reserve|release_data().
>>
>> The value itself represents how many bytes it has already reserved for=

>> later operation.
>> So qgroup_rsv_increase() normally means qgroup is reserving more space=
,
>> while qgroup_rsv_decrease() means qgroup reserved space is decreasing,=

>> either released or freed.
>>
>> Hopes above explanation could inspire you about better naming ideas.
>> (Because I really have no idea how to name it better while keeping the=

>> name the same length)
>=20
> I'm not sure I understand the concern about the length.  These names do=

> not seem excessive to me, so a few extra characters for the sake of
> clarity would be well worth it.

What about qgroup_rsv_add/remove()?

These functions are just designed to increase/decrease the value(s) of
btrfs_qgroup_rsv structure, and should not be accessed outside of
qgroup_reserve() and some special call sides.

Maybe __qgroup_rsv_add/remove() will be better considering it's only
used internally.

Thanks,
Qu

>=20
> Ed
>=20
>>>> +
>>>> +static void qgroup_rsv_increase_by_qgroup(struct btrfs_qgroup *dest=
,
>>>> +					  struct btrfs_qgroup *src)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i =3D 0; i <=3D BTRFS_QGROUP_RSV_TYPES; i++)
>>>> +		qgroup_rsv_increase(dest, src->rsv.values[i], i);
>>>> +}
>>>> +
>>>> +static void qgroup_rsv_decrease_by_qgroup(struct btrfs_qgroup *dest=
,
>>>> +					  struct btrfs_qgroup *src)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i =3D 0; i <=3D BTRFS_QGROUP_RSV_TYPES; i++)
>>>> +		qgroup_rsv_decrease(dest, src->rsv.values[i], i);
>>>> +}
>>>
>>> Why don't you model these similar to what we already have for the blo=
ck
>>> rsv. In this case I believe those would correspond to the
>>> btrfs_block_rsv_migrate. Admittedly we don't have a counterpart to
>>> rsv_decrease_by_qgroup.
>>
>> Not sure about 'migrate', I think it's more like 'inherit', since @src=

>> is not modified at all.
>>
>> 'increase' and 'decrease' are preferred mainly because they are the sa=
me
>> length, and represents the value change obviously enough.
>>
>> I'm completely open to better naming schema.
>> (But it's better to have same length, I'm kind of paranoid about this)=

>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>> +
>>>>  static void btrfs_qgroup_update_old_refcnt(struct btrfs_qgroup *qg,=
 u64 seq,
>>>>  					   int mod)
>>>>  {
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


--9Fonu57Q3EvWJpDdj2q96VkDG4CuxCqmO--

--fjHxf08CXj2Istj2UWME6g1ejo06mLmSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnv3SAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi+oQf9Flz46Gwrg3bZkiJuoUimRiEp
oaceR+C2YzrsJUYNe7WMH6VKpv+Igpze/6oU7vOrabsr64E/iLi4fjAZibmTWuJ/
3pixzJ2xb0g0njNrRXf8DgIiB4lsrjBV8zGSLaOvR0T//JAM4ttH6SSQBb+NYvkD
74oBlE7GO53jou8c8H6SVVK7mDV1GxpjkrJlA3AZVDjL7d763VljDGmjVXcqHrhY
EMKriIkXiUJREjOGEwv0qoNIa2vIRHKq8yYMuRfIze+Js/jmz0w9L5DtV2fz3z0z
zD3MjgRq9r6/uZHPC9GoWXjqtiV0NVe0wA6lW0eVfEkiXyvXSubZefxlutvzjg==
=06tI
-----END PGP SIGNATURE-----

--fjHxf08CXj2Istj2UWME6g1ejo06mLmSR--
