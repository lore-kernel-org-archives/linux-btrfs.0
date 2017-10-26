Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932246AbdJZOMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 10:12:39 -0400
Subject: Re: [PATCH v2 4/6] btrfs: qgroup: Fix wrong qgroup reservation update
 for relationship modification
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171025025445.16617-1-wqu@suse.com>
 <20171025025445.16617-5-wqu@suse.com>
 <f8e074ea-8e8a-ba3b-30ef-0aeccd5a61f3@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <245614a1-57ab-3e61-a14c-6d7fa6907806@gmx.com>
Date: Thu, 26 Oct 2017 22:12:23 +0800
MIME-Version: 1.0
In-Reply-To: <f8e074ea-8e8a-ba3b-30ef-0aeccd5a61f3@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vlspU1ifVNF5ap1lhNXxB6QujMtB3WpBM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vlspU1ifVNF5ap1lhNXxB6QujMtB3WpBM
Content-Type: multipart/mixed; boundary="VCug1VLfoNEja1XdVGVBgelIIRtOIFMFo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <245614a1-57ab-3e61-a14c-6d7fa6907806@gmx.com>
Subject: Re: [PATCH v2 4/6] btrfs: qgroup: Fix wrong qgroup reservation update
 for relationship modification
References: <20171025025445.16617-1-wqu@suse.com>
 <20171025025445.16617-5-wqu@suse.com>
 <f8e074ea-8e8a-ba3b-30ef-0aeccd5a61f3@suse.com>
In-Reply-To: <f8e074ea-8e8a-ba3b-30ef-0aeccd5a61f3@suse.com>

--VCug1VLfoNEja1XdVGVBgelIIRtOIFMFo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8826=E6=97=A5 22:00, Nikolay Borisov wrote:
>=20
>=20
> On 25.10.2017 05:54, Qu Wenruo wrote:
>> When modifying qgroup relationship, for qgroup which only owns exclusi=
ve
>> extents, we will go through quick update path.
>>
>> In quick update path, we will adding/substracting exclusive and refere=
nce
>> number for parent qgroup, since the source (child) qgroup only have
>> exclusive extents, destination (parent) qgroup will also own or lose t=
hese
>                                                                 ^ what
> does own or lose mean how is it decided whether it's losing them or
> owning them ??

Adding a child qgroup to parent, then the parent qgroup *owns* all these
extents of the child groups.
And vice verse (lose).

Of course, only for "exclusive-only" child qgroup, whose extents are all
exclusive.

>> extents exclusively.
>>
>> So should be the same for reservation, since later reservation
> What does the 'same' refer to here - the "will also own or lose these
> extents exclusively" ? It's a bit ambiguous given the surrounding conte=
xt.
>> adding/releasing will also affect parent qgroup, without the servation=

>=20
> nit: s/servation/reservation
>=20
>> carried from child, parent will underflow reservation or have dead
>> reservation which will never be freed.
>>
>> However original code doesn't do the same thing for reservation.
>=20
> what does "the same" refer to here?

"The same" here means, the old code doesn't carry the reservation from
child, unlike it carries all rfer/excl from child.

>=20
>> It handles qgroup reservation quite differently:
>>
>> It removes qgroup reservation, as it's allocating space from the
>> reserved qgroup for relationship adding.
>> But does nothing for qgroup reservation if we're removing a qgroup
>> relationship.
>>
>> According to the original code, it looks just like because we're addin=
g
>> qgroup->rfer, the code assumes we're writing new data, so it's follows=

>=20
> nit:s/it's/it/
>=20
> It might not be worth it doing a resend of the series with those fixes,=

> I guess David could fix them up while committing them but just answerin=
g
> my question might help in fleshing out e clearer commit message.

No problem,

And answering your question can also help me to refine not only the
commit message the term used and the logic.

Thanks,
Qu
>=20
>> the normal write routine, by reducing qgroup->reserved and adding
>> qgroup->rfer/excl.
>>
>> This old behavior is wrong, and should be fixed to follow the same
>> excl/rfer behavior.
>>
>> Just fix it by using the correct behavior described above.
>>
>> Fixes: 31193213f1f9 ("Btrfs: qgroup: Introduce a may_use to account sp=
ace_info->bytes_may_use.")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 44 +++++++++++++++++++++++---------------------
>>  1 file changed, 23 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 2c690aa19d84..cbc31cfabf44 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1071,21 +1071,30 @@ static void report_reserved_underflow(struct b=
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
>> + * only has exclusive extents.
>> + *
>> + * In this case, all exclsuive extents will also be exlusive for pare=
nt, so
>> + * excl/rfer just get added/removed.
>> + *
>> + * So is qgroup reservation space, which should also be added/removed=
 to
>> + * parent.
>> + * Or when child tries to release reservation space, parent will unde=
rflow its
>> + * reservation (for relationship adding case).
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
>> @@ -1098,13 +1107,11 @@ static int __qgroup_excl_accounting(struct btr=
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
>> +	if (sign > 0)
>> +		qgroup_rsv_add_by_qgroup(qgroup, src);
>> +	else
>> +		qgroup_rsv_release_by_qgroup(qgroup, src);
>> =20
>>  	qgroup_dirty(fs_info, qgroup);
>> =20
>> @@ -1124,15 +1131,10 @@ static int __qgroup_excl_accounting(struct btr=
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
>> +			qgroup_rsv_add_by_qgroup(qgroup, src);
>> +		else
>> +			qgroup_rsv_release_by_qgroup(qgroup, src);
>>  		qgroup->excl_cmpr +=3D sign * num_bytes;
>>  		qgroup_dirty(fs_info, qgroup);
>> =20
>> @@ -1175,7 +1177,7 @@ static int quick_update_accounting(struct btrfs_=
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


--VCug1VLfoNEja1XdVGVBgelIIRtOIFMFo--

--vlspU1ifVNF5ap1lhNXxB6QujMtB3WpBM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnx7UgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiuTwf/bzrxjDADOIs2RS3Q7NXWDyUX
e6TflT8PTZWnQL3HpbFWc6w7m2FdWenEBa6vCJ8Pe7umDwUWB9OUpRfx+PZjEase
CAN6Ky7LX68d/QRmJVjP+dL6958tRscHbQdOON4cUNe3VNes6zgi5bxzUitFsHji
cqCh+/qKtrbn2FwDqsrsIWpqGn+1VlGn3aPVK5MejtPcalp7lVaT7+j63B8YbCtC
WNcMK3FNMWh3Kqfe7VveRcMLjuGlYMpnQ+VzdcOKyxCihCFU8cSVqW81klfJV0sy
EICQL9R1SwRRStbVRfn28sA8qFQtIcGMaCMHjcNDwt0z3ExM9Sa+/TdddkDCbw==
=mXg3
-----END PGP SIGNATURE-----

--vlspU1ifVNF5ap1lhNXxB6QujMtB3WpBM--
