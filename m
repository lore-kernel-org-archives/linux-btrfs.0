Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:48023 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbeHHKH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 06:07:28 -0400
Subject: Re: [PATCH] btrfs: qgroup: Don't populating excl numbers for snapshot
 src if it belongs to other qgroups
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180808060409.20048-1-wqu@suse.com>
 <f6b41cc5-6827-4f6d-e8b5-ef5c3963293f@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <82e8e5e4-7ada-433d-c380-82c534aac796@gmx.com>
Date: Wed, 8 Aug 2018 15:48:51 +0800
MIME-Version: 1.0
In-Reply-To: <f6b41cc5-6827-4f6d-e8b5-ef5c3963293f@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mOBVAukQLzZXYdG9ntKtS19f7YgRUL3nr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mOBVAukQLzZXYdG9ntKtS19f7YgRUL3nr
Content-Type: multipart/mixed; boundary="zbQkEQm99RCqvPmLJOwis9rJBNQO5gf1t";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <82e8e5e4-7ada-433d-c380-82c534aac796@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't populating excl numbers for snapshot
 src if it belongs to other qgroups
References: <20180808060409.20048-1-wqu@suse.com>
 <f6b41cc5-6827-4f6d-e8b5-ef5c3963293f@jp.fujitsu.com>
In-Reply-To: <f6b41cc5-6827-4f6d-e8b5-ef5c3963293f@jp.fujitsu.com>

--zbQkEQm99RCqvPmLJOwis9rJBNQO5gf1t
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8808=E6=97=A5 15:41, Misono Tomohiro wrote:
> On 2018/08/08 15:04, Qu Wenruo wrote:
>> When quota is enabled and we do a snapshot, we just update the 'excl'
>> number of both snapshot src and dst to src's 'rfer' - nodesize.
>>
>> It's a quick hack to avoid quota rescan every time we create a snapsho=
t
>> and it works if src doesn't belong to other qgroups.
>>
>> But if we have higher level qgroups, such behavior only works for leve=
l
>> 0 qgroups, and higher level qgroups don't get update, thus making qgro=
up
>> number inconsistent.
>>
>> The problem of updating higher level qgroup numbers is, it's way to
>> complex.
>>
>> Under the following case, it's pretty simple: (src is 257, dst is 258)=

>> 0/257 - 1/0, 0/258.
>>
>> In this case, we only need to modify 1/0 to reduce its 'excl'
>>
>> But under the following case, it will go out of control:
>>
>> 0/257 - 1/0, 0/258 - 1/1 (using -i option), 1/0 - 2/0, 1/1 - 2/0.
>>
>> So to make it simple, if snapshot src has higher level qgroups, just
>> mark qgroup inconsistent and let later rescan to do its job.
>>
>> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index ec4351fd7537..2b3d2dd1b735 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2298,6 +2298,22 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans,
>>  		if (!srcgroup)
>>  			goto unlock;
>> =20
>> +		/*
>> +		 * If snapshot source is belonging to high level qgroups, it
>> +		 * will be a more complex to hack the numbers.
>> +		 * E.g. source is 257, snapshot is 258:
>> +		 * 0/257 - 1/0, creating snapshot 258 will need to update 1/0
>> +		 * It's too complex when higher level qgroup is involved.
>> +		 * Mark qgroup inconsistent for later rescan
>> +		 */
>> +		if (!list_empty(&srcgroup->groups)) {
>> +			btrfs_info_rl(fs_info,
>> +"src qgroup 0/%llu belongs to higher level qgroup, creating snapshot =
for it need qgroup rescan",
>> +				      srcid);
>> +			fs_info->qgroup_flags |=3D
>> +				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> +			goto unlock;
>> +		}
>>  		/*
>>  		 * We call inherit after we clone the root in order to make sure
>>  		 * our counts don't go crazy, so at this point the only
>>
>=20
> Thanks for the quick fix.
> Tested-by/Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>=

>=20
> However there is still another problem about removing relation:
>=20
> (4.18-rc7 with above patch)
> $ mkfs.btrfs -fq $DEV
> $ mount $DEV /mnt
>=20
> $ btrfs quota enable /mnt
> $ btrfs qgroup create 1/0 /mnt
> $ btrfs sub create /mnt/sub
> $ btrfs qgroup assign 0/257 1/0 /mnt
>=20
> $ dd if=3D/dev/urandom of=3D/mnt/sub/file bs=3D1k count=3D1000
> $ btrfs sub snap /mnt/sub /mnt/snap
> $ dmesg | tail -n 1
> BTRFS info (device sdb7): src qgroup 0/257 belongs to higher level qgro=
up,
>  creating snapshot for it need qgroup rescan
>=20
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre /mnt
> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          16.00KiB     16.00KiB         none         none ---     --=
-
> 0/257      1016.00KiB     16.00KiB         none         none 1/0     --=
-
> 0/258      1016.00KiB     16.00KiB         none         none ---     --=
-
> 1/0        1016.00KiB     16.00KiB         none         none ---     0/=
257
>                          =20
> so far so good, but:
>=20
> $ btrfs qgroup remove 0/257 1/0 /mnt
> WARNING: quotas may be inconsistent, rescan needed
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre  /mnt
> qgoupid         rfer         excl     max_rfer     max_excl parent  chi=
ld
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          16.00KiB     16.00KiB         none         none ---     --=
-
> 0/257      1016.00KiB     16.00KiB         none         none ---     --=
-
> 0/258      1016.00KiB     16.00KiB         none         none ---     --=
-
> 1/0        1016.00KiB     16.00KiB         none         none ---     --=
-
>            ^^^^^^^^^^     ^^^^^^^^ not cleared
>=20
> It seems some fix is needed for rescan too.

In this particular case, it's not hard to fix.

In fact for deleting/assigning qgroup with rfer =3D=3D excl case, it shou=
ld
go through the quick accounting path.

But it looks like remove path doesn't go that path.

I'll try to fix it soon.

Thanks,
Qu

>=20
> Thanks,
> Misono
>=20
>=20


--zbQkEQm99RCqvPmLJOwis9rJBNQO5gf1t--

--mOBVAukQLzZXYdG9ntKtS19f7YgRUL3nr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltqoGMACgkQwj2R86El
/qitUQf/VVrDjkMEFpuZbE0yrsL89NkblBOIS13RKkeTH/5Bnz8niejGbc3cJzUa
6mbBrBu+lNCQLFRsg6A9+HmY8ExEzjL/1BmRJ3MBkCfPNhxaahOTPRht4Wayfqjp
Pfa5TGfs88JyJa+7JJ57NuRWXzSBiXpeOvNIX6iGtQ6SOB4fLwykgCzdkCmI80L9
v7G1okJGMDumLsSdk8F5h6qXPe1A/WVfUKeVhnizt14OHyMKSG+tFLKCx0K7I2KK
89I4mqLkVJHCsPVgOLPQrk+TtHhjkRqa0/HI+G+SmshMmmKYRdCvUdoEM1KOe7T3
GkRci80FR/bGdzlVGgm4SxZh6Z7xHQ==
=ZIUk
-----END PGP SIGNATURE-----

--mOBVAukQLzZXYdG9ntKtS19f7YgRUL3nr--
