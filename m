Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60491 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbdJXMUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 08:20:04 -0400
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
 <a386a6bc-5add-a09f-e7ac-bc557bbcbfa2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9e1af0bf-71d6-afdd-b6bd-9032cb16db18@gmx.com>
Date: Tue, 24 Oct 2017 20:19:42 +0800
MIME-Version: 1.0
In-Reply-To: <a386a6bc-5add-a09f-e7ac-bc557bbcbfa2@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4QwuM2IBLU9bSm04IF9Qb63NrxC3L6Miq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4QwuM2IBLU9bSm04IF9Qb63NrxC3L6Miq
Content-Type: multipart/mixed; boundary="4pDwclpg9cJJb69M1388Oo6UgUpnbGOmt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Message-ID: <9e1af0bf-71d6-afdd-b6bd-9032cb16db18@gmx.com>
Subject: Re: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation
 inheritance for relationship update
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-5-wqu@suse.com>
 <a386a6bc-5add-a09f-e7ac-bc557bbcbfa2@suse.com>
In-Reply-To: <a386a6bc-5add-a09f-e7ac-bc557bbcbfa2@suse.com>

--4pDwclpg9cJJb69M1388Oo6UgUpnbGOmt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 20:01, Nikolay Borisov wrote:
>=20
>=20
> On 24.10.2017 11:39, Qu Wenruo wrote:
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
>=20
> I'm afraid this sentence doesn't give much information about what's
> really going on.

I'll try to reorganize it to give a better explanation on this.

>=20
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
>=20
>=20
> I'm a bit confused by the semantics of the 'sign' variable. So what you=

> are doing is that if sign is > 0 then you are "adding a relationship"
> i.e. adding 'src reservation to 'qgroup', presumably because the src is=

> a child of qgroup? So you are handling both adding and deletion in the
> if statement?

Yes, the original design of @sign is to allow single function to handle
both relationship adding and deleting.
just like the rest code, which uses @sign to handle both adding and
deleting without using if.

>=20
> However, before that apparently only deleting a relation ship was
> handled by that same if (And I believe that was wrong since if sign > 0=

> then we should be adding bytes but here we are subtracting). SO the bug=

> being fixed by this commit are actually 2 bugs:
>=20
> 1. Completely missing the "adding a relation ship case"
> 2. Incorrect hanlding of sign < 0, since this was handled by the sign >=

> 0 case?

Yes, in fact 2 bugs.

Although the original code is acting like it's allocating space inside
the new parent, so it reduces parent's reserved, and adding new excl/refe=
r.

However it's not the case, it should do inheriting, not allocating from
parent.

For sign > 0, (adding relationship) parent should inherit all excl/rfer
and reserved space.
For sign < 0, (deleting relationshio) parent should have all its
excl/rfer along with reserved space removed.

^^^ This should be the correct behavior.

The original code is just a copy of older code, as you can see in commit
9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or
mark INCONSISTENT flags when assigning/deleting a qgroup relations.").

So it's a bug dating back to ancient days and it's my fault I didn't
expose it in the very beginning.

Thanks,
Qu
>=20
>=20
>=20
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--4pDwclpg9cJJb69M1388Oo6UgUpnbGOmt--

--4QwuM2IBLU9bSm04IF9Qb63NrxC3L6Miq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnvL94XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qitNQf+PxZvQTdIE+UUVmCNtyUhDG3F
u4Z0GMoB+zsLK/cB4bW9zOKBT9UGAloYY9IGt0XpnlOR/o9LGJMi1kCRpWs7V6v5
Ulg243RsqAKFlKWsWl+ZRwklc1LGSpBybgNVxXtdm7afhN6cIvxQbX/wb2KHquGE
C/dHvcld3vuBrLpXXpZn6gWEXfdwEDWXrZiJUMyZa4p8TvLgAVKLVMwAiuSl4H63
YTqVObm0aWFV+3B0fiZE6CBFGWT7ebIUNJl0IGePx3xqhOyQNzRNTLoLFqLTtThS
zG91Am3q7ojd5QICHqmlw88bMq1N2v0EXkR/S+2bS1ChnWxSb++7BVJZUJxbbw==
=QYpw
-----END PGP SIGNATURE-----

--4QwuM2IBLU9bSm04IF9Qb63NrxC3L6Miq--
