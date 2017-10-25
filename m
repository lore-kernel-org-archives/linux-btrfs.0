Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60550 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdJYALP (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 20:11:15 -0400
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
To: Edmund Nadolski <enadolski@suse.de>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
 <27d2fb87-ff7c-1783-9406-26cdcaec7ab5@suse.de>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <e3422692-360e-af01-3e9c-6d1281b01880@suse.com>
Date: Wed, 25 Oct 2017 08:11:07 +0800
MIME-Version: 1.0
In-Reply-To: <27d2fb87-ff7c-1783-9406-26cdcaec7ab5@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8H2VKJwWSFNp46ltoHhraUtlKfWErPr6l"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8H2VKJwWSFNp46ltoHhraUtlKfWErPr6l
Content-Type: multipart/mixed; boundary="9UAeE2Hwt9TGunBXXofNrngwo6oena3PE";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Edmund Nadolski <enadolski@suse.de>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Message-ID: <e3422692-360e-af01-3e9c-6d1281b01880@suse.com>
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
 <27d2fb87-ff7c-1783-9406-26cdcaec7ab5@suse.de>
In-Reply-To: <27d2fb87-ff7c-1783-9406-26cdcaec7ab5@suse.de>

--9UAeE2Hwt9TGunBXXofNrngwo6oena3PE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8825=E6=97=A5 01:11, Edmund Nadolski wrote:
>=20
>=20
> On 10/24/2017 02:39 AM, Qu Wenruo wrote:
>> When modifying qgroup relationship, for qgroup which only owns exclusi=
ve
>> extents, we will go through quick update path.
>>
>> In quick update path, we will just adding/removing exclusive and refer=
ence
>> number.
>>
>> However we did the opposite for qgroup reservation from the very
>> beginning.
>>
>> In fact, we should also inherit the qgroup reservation space, just lik=
e
>> exclusive and reference numbers.
>>
>> Fix by using the newly introduced
>> qgroup_rsv_increase/decrease_by_qgroup() function call.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 39 ++++++++++++++++++---------------------
>>  1 file changed, 18 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 7b89da9589c1..ba6f60fd0e96 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1069,21 +1069,24 @@ static void report_reserved_underflow(struct b=
trfs_fs_info *fs_info,
>>  #endif
>>  	qgroup->reserved =3D 0;
>>  }
>> +
>>  /*
>> - * The easy accounting, if we are adding/removing the only ref for an=
 extent
>> - * then this qgroup and all of the parent qgroups get their reference=
 and
>> - * exclusive counts adjusted.
>> + * The easy accounting, we're updating qgroup relationship whose chil=
d qgroup
>> + * only have exclusive extents.
>> + * In this case, we only need to update the rfer/excl, and inherit rs=
v from
>> + * child qgroup (@src)
>=20
> I'm not sure I understand this inheritance model.  Typically a child
> will inherit from one (or more) parents, but this seems to go the
> opposite way.  (Perhaps it's just terminology, but I may have missed
> something here.)

Btrfs qgroup, for exclusive qgroup, it's more like a subset.

If a exclusive qgroup belongs to a parent qgroup, then parent qgroup
should have all the exclusive extents and its reservation.

So it's still like inheritance, but it's parent inheriting things from
child.
Yeah, it's opposite, and I don't have better idea to explain this.

>=20
> Can these relationships form a hierarchy (i.e., grandparents,
> grandchildren, etc.)?

Yes, it's possible.

Thanks,
Qu

>=20
> Thanks,
> Ed
>=20
>=20
>>   *
>>   * Caller should hold fs_info->qgroup_lock.
>>   */
>>  static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>>  				    struct ulist *tmp, u64 ref_root,
>> -				    u64 num_bytes, int sign)
>> +				    struct btrfs_qgroup *src, int sign)
>>  {
>>  	struct btrfs_qgroup *qgroup;
>>  	struct btrfs_qgroup_list *glist;
>>  	struct ulist_node *unode;
>>  	struct ulist_iterator uiter;
>> +	u64 num_bytes =3D src->excl;
>>  	int ret =3D 0;
>> =20
>>  	qgroup =3D find_qgroup_rb(fs_info, ref_root);
>> @@ -1096,13 +1099,12 @@ static int __qgroup_excl_accounting(struct btr=
fs_fs_info *fs_info,
>>  	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>>  	qgroup->excl +=3D sign * num_bytes;
>>  	qgroup->excl_cmpr +=3D sign * num_bytes;
>> -	if (sign > 0) {
>> -		trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes);
>> -		if (qgroup->reserved < num_bytes)
>> -			report_reserved_underflow(fs_info, qgroup, num_bytes);
>> -		else
>> -			qgroup->reserved -=3D num_bytes;
>> -	}
>> +
>> +	/* *Inherit* qgroup rsv info from @src */
>> +	if (sign > 0)
>> +		qgroup_rsv_increase_by_qgroup(qgroup, src);
>> +	else
>> +		qgroup_rsv_decrease_by_qgroup(qgroup, src);
>> =20
>>  	qgroup_dirty(fs_info, qgroup);
>> =20
>> @@ -1122,15 +1124,10 @@ static int __qgroup_excl_accounting(struct btr=
fs_fs_info *fs_info,
>>  		qgroup->rfer_cmpr +=3D sign * num_bytes;
>>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>>  		qgroup->excl +=3D sign * num_bytes;
>> -		if (sign > 0) {
>> -			trace_qgroup_update_reserve(fs_info, qgroup,
>> -						    -(s64)num_bytes);
>> -			if (qgroup->reserved < num_bytes)
>> -				report_reserved_underflow(fs_info, qgroup,
>> -							  num_bytes);
>> -			else
>> -				qgroup->reserved -=3D num_bytes;
>> -		}
>> +		if (sign > 0)
>> +			qgroup_rsv_increase_by_qgroup(qgroup, src);
>> +		else
>> +			qgroup_rsv_decrease_by_qgroup(qgroup, src);
>>  		qgroup->excl_cmpr +=3D sign * num_bytes;
>>  		qgroup_dirty(fs_info, qgroup);
>> =20
>> @@ -1173,7 +1170,7 @@ static int quick_update_accounting(struct btrfs_=
fs_info *fs_info,
>>  	if (qgroup->excl =3D=3D qgroup->rfer) {
>>  		ret =3D 0;
>>  		err =3D __qgroup_excl_accounting(fs_info, tmp, dst,
>> -					       qgroup->excl, sign);
>> +					       qgroup, sign);
>>  		if (err < 0) {
>>  			ret =3D err;
>>  			goto out;
>>


--9UAeE2Hwt9TGunBXXofNrngwo6oena3PE--

--8H2VKJwWSFNp46ltoHhraUtlKfWErPr6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnv1psNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qEcFB/9K05ry1MA0eY2TixWgoyHuojnKMC6ZuTFkGhGO
hCFOwm32XomW8XWptcrXWyMYc8zL+/MORRl6fr5TvY7M+cwMovl3utg7IuOMtboJ
j/96pSow5gn7KnF/QRj7CBp87AJwj7dx7pbBsfJuQD515Fdj4Bo92RHrwU7dp6A0
q/GpokmCF/HIFIqoS4BXSOAam9VL3jb3+B+Aix0Ss5E+UDNydzzhB7X46MldRD4e
8VaPsNzA/v7OV4jiEaDQnHhNGCeYIL8cXRqJqjIKLJ98yVPotQ7fwHS/OwTIWYBK
CpJpLVNXzl7r5T8Pa2SQimQkG/3NV+FCFluh1S2fb+ZIADmY
=GU77
-----END PGP SIGNATURE-----

--8H2VKJwWSFNp46ltoHhraUtlKfWErPr6l--
