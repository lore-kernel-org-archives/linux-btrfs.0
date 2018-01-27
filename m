Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55848 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751434AbeA0C3k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 21:29:40 -0500
Subject: Re: [RFC PATCH] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1516976021-11935-1-git-send-email-nborisov@suse.com>
 <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>
Message-ID: <6f2d89e6-4a46-f0be-f25c-29e4ff3a158f@gmx.com>
Date: Sat, 27 Jan 2018 10:29:27 +0800
MIME-Version: 1.0
In-Reply-To: <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jHxZtE81GEnyLFOK0qcVx3OswTFB4BW7x"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jHxZtE81GEnyLFOK0qcVx3OswTFB4BW7x
Content-Type: multipart/mixed; boundary="bMrVzRp0OsiR1e4F6Vgk05aLOJUIXzafD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6f2d89e6-4a46-f0be-f25c-29e4ff3a158f@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
References: <1516976021-11935-1-git-send-email-nborisov@suse.com>
 <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>
In-Reply-To: <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>

--bMrVzRp0OsiR1e4F6Vgk05aLOJUIXzafD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8827=E6=97=A5 10:26, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 22:13, Nikolay Borisov wrote:
>> Running generic/019 with qgroups on the scratch device enabled is
>> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's=

>> supposed to trigger only on -ENOMEM, in reality, however, it's possibl=
e
>> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
>> finds the roots of the extent being tracked and sets the qrecord->old_=
roots
>> list. If this operation fails nothing critical happens except the
>> quota accounting can be considered wrong. In such case just set the
>> INCONSISTENT flag for the quota and be done with it.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>
>> Qu,=20
>>
>> This fixes the crash for me, however I'm not entirely sure it's really=
 the=20
>> best fix since it's leaking the usage of INCONSISTENT out of qgroup.c.=
 Ideally
>> I'd like to avoid this. Since you have more experience with qgroups an=
d also you
>> introduced the extent tracking code in add_delayed_tree_ref how does=20
>> look to you?=20

And for leaking INCONSISTENT flag out of qgroup scope, it could be
integrated into btrfs_qgroup_trace_extent_post() so we automatically
mark qgroup inconsistent without the help from callers.

Thanks,
Qu

>>
>>
>>  fs/btrfs/delayed-ref.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index a1a40cf382e3..1e9aa18cc0d8 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -820,8 +820,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_in=
fo *fs_info,
>>  			     num_bytes, parent, ref_root, level, action);
>>  	spin_unlock(&delayed_refs->lock);
>> =20
>> -	if (qrecord_inserted)
>> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>> +	if (qrecord_inserted) {
>> +		int ret =3D btrfs_qgroup_trace_extent_post(fs_info, record);
>=20
> Since generic/019 is using make_fail_request, it can cause some tree
> reads fail.
>=20
> And since btrfs_qgroup_trace_extent_post() cause btrfs_find_all_roots()=

> to fill @old_roots for new extents, it will definitely read tree blocks=
,
> and when its request failed, it returns -EIO as expected.
>=20
> So yes, the qgroup code break the old assumption that
> btrfs_add_delayed_tree|data_ref() could only return -ENOMEM.
>=20
>=20
> But compared to delayed-ref, qgroup is not a critical payload (if
> delayed-ref is screwed up, extent tree and possible data extent will be=

> corrupted, while qgroup failure only affects qgroup), so it's OK to kee=
p
> the old assumption.
>=20
>> +		if (ret !=3D -ENOMEM)
> Here we don't really need to handle ENOMEM specially.
> Just check ( ret < 0 ) should be enough.
>=20
>> +			fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>=20
> And extra btrfs_warn() would help.
>=20
>> +		else
>> +			return -ENOMEM;
>=20
> Since btrfs is not a critical payload compared to delayed ref, returnin=
g
> 0 should not be a problem as we have already marked qgroup inconsistent=
=2E
> (With comment explaining why it's OK to return 0)
>=20
> Thanks,
> Qu
>=20
>> +	}
>>  	return 0;
>> =20
>>  free_head_ref:
>>
>=20


--bMrVzRp0OsiR1e4F6Vgk05aLOJUIXzafD--

--jHxZtE81GEnyLFOK0qcVx3OswTFB4BW7x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpr5AcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhECwf+MexDXfsVYN2oeVMUqcjsOqZH
m1v95HG0aBofllK5cVHIWawZsxm119eHS3eoUH/UrenZxOMrJUasamg/qHA8kZlI
EF6mJFec43adbL+dz5v2sgIRiHZcJastreRzBOzNMZW9/4wLSxLAR3LjT6WajxZH
mnX1neYxM86S9u+tSat9+zt6cYL6RDd/7NTkCONT7JluGvAoqwbwxBvj907H9x5p
ltuopO/2mbwVP4hoeZdPQ7N/jRP2uAgW37GZQUV+JX8o0HcXJEYBqVxXw+gA8khN
h4Bd53hMrJBVQHjSniIjo39pAHKIr0gisMecpYhEyXiK0SzZlf4WCqr8bQmtVg==
=0dzF
-----END PGP SIGNATURE-----

--jHxZtE81GEnyLFOK0qcVx3OswTFB4BW7x--
