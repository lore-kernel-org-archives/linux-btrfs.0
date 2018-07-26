Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbeGZJBr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 05:01:47 -0400
Subject: Re: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is
 initialized without rescan initialized
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180726065900.8469-1-wqu@suse.com>
 <feefe6a2-c1ac-fa8e-85d0-e8c039eb6ebd@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f03da50c-d51f-f5ba-afb7-6b7e713a305e@gmx.com>
Date: Thu, 26 Jul 2018 15:45:55 +0800
MIME-Version: 1.0
In-Reply-To: <feefe6a2-c1ac-fa8e-85d0-e8c039eb6ebd@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1pe7F0ENW0K4CLxUgjvkAbg7yztxzg7Ug"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1pe7F0ENW0K4CLxUgjvkAbg7yztxzg7Ug
Content-Type: multipart/mixed; boundary="Z4HCOdHeJCAGFZmDNn2JSLW6S7fZbypPs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <f03da50c-d51f-f5ba-afb7-6b7e713a305e@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Auto kick in rescan if qgroup tree is
 initialized without rescan initialized
References: <20180726065900.8469-1-wqu@suse.com>
 <feefe6a2-c1ac-fa8e-85d0-e8c039eb6ebd@jp.fujitsu.com>
In-Reply-To: <feefe6a2-c1ac-fa8e-85d0-e8c039eb6ebd@jp.fujitsu.com>

--Z4HCOdHeJCAGFZmDNn2JSLW6S7fZbypPs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8826=E6=97=A5 15:21, Misono Tomohiro wrote:
> On 2018/07/26 15:59, Qu Wenruo wrote:
>> Under certain case, btrfs/166 could cause power loss just after quota
>> tree initialized but rescan not kicked in.
>>
>> In this case, since flags of qgroup status item is just ON |
>> INCONSISTENT, without RESCAN flag, rescan won't be kicked in in next
>> mount.
>>
>> Now kick in rescan automatically for such situation, so user won't nee=
d
>> to do rescan manually.
>=20
> How about setting all of BTRFS_QGROUP_STATUS_FLAG_ON/INCONSISTENT/RESCA=
N
> at first place and calling qgroup_rescan_init(fs_info, 0, 0)=20
> (currently it is (fs_info, 0, 1)) in btrfs_quota_enable()?

I'm wondering if there will any race window between we set RESCAN flag
and we really kick in rescan.

But the idea looks doable and I'll look into it.

>=20
> I think with this approach, current btrfs-progs can work as expected to=
o.

In theory, we still need to fix btrfs check/kernel since we may need to
handle old fs.
But since it's pretty rare, I think if we could fix kernel using the
idea you purposed, it would be enough for this case.

Thanks,
Qu

>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index c25dc47210a3..e62598fc354f 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -392,6 +392,17 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info=
 *fs_info)
>>  			fs_info->qgroup_flags =3D btrfs_qgroup_status_flags(l,
>>  									  ptr);
>>  			rescan_progress =3D btrfs_qgroup_status_rescan(l, ptr);
>> +
>> +			/*
>> +			 * Qgroup is enabled but rescan hans't kicked in and
>> +			 * power loss happened, kick rescan in
>> +			 */
>> +			if (rescan_progress =3D=3D 0 &&
>> +			    (BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
>> +			     BTRFS_QGROUP_STATUS_FLAG_ON) =3D=3D
>> +			    fs_info->qgroup_flags)
>> +				fs_info->qgroup_flags |=3D
>> +					BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>>  			goto next1;
>>  		}
>> =20
>>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Z4HCOdHeJCAGFZmDNn2JSLW6S7fZbypPs--

--1pe7F0ENW0K4CLxUgjvkAbg7yztxzg7Ug
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltZfDMACgkQwj2R86El
/qjK2Qf9FhUKO54c+3YnHRLVhloi9Zzwn86LdiwzpyPSg2QEfWatZOl9Sj7udcCW
Um6314JxFqT9YngrCLlO1Yjs9y76WLZ7AqdM3qTsw2Eyb1NedZt+mxO4kkgH27KM
URiLW5OrxEff5RRTuCsKrNxTPlW44y+IL9oelTjujb191Pg607fA63QLd1FumM1h
rchJ6GTLUhkB2CXYQIpwSat/AaqW7XWx+Z2r6Rz3kzWFnAscuP037ZWMq1Uldw8n
NW6/Hkl9ULvEbqlSNX/o9K0aQFgQ7cJvRcYBOsP6SLpXy1AOTIFXEJcIfHTN1Ixd
ug2EnXpJVYehuee5vP7WGPVkVXCAyA==
=3B0O
-----END PGP SIGNATURE-----

--1pe7F0ENW0K4CLxUgjvkAbg7yztxzg7Ug--
