Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731479AbeG0CjQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 22:39:16 -0400
Subject: Re: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable
 time
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180726091504.5833-1-wqu@suse.com>
 <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <c525eeeb-a73c-0dd4-a509-833b102b49d9@suse.de>
Date: Fri, 27 Jul 2018 09:19:46 +0800
MIME-Version: 1.0
In-Reply-To: <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8qKHsEd5qBpnH69QmvCLDddhLbA719RSm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8qKHsEd5qBpnH69QmvCLDddhLbA719RSm
Content-Type: multipart/mixed; boundary="CXOPHOaxVgLVvQRINmApZa5cDAusdTrvm";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <c525eeeb-a73c-0dd4-a509-833b102b49d9@suse.de>
Subject: Re: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable
 time
References: <20180726091504.5833-1-wqu@suse.com>
 <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
In-Reply-To: <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>

--CXOPHOaxVgLVvQRINmApZa5cDAusdTrvm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8827=E6=97=A5 09:10, Misono Tomohiro wrote:
> On 2018/07/26 18:15, Qu Wenruo wrote:
>> Between btrfs_quota_enable() finished and rescan kicked in, there is a=

>> small window that quota status has (ON | INCONSISTENT) bits set but
>> without RESCAN bits set.
>>
>> And transaction is committed inside the window and then power loss
>> happens, we will have a quota tree with all qgroup numbers set to 0, a=
nd
>> not RESCAN bit set.
>>
>> At next mount time, qgroup rescan will not kick in due to the missing =
of
>> RESCAN bit, user needs to kick in rescan manually.
>>
>> This patch will fix it by setting RESCAN bit at btrfs_quota_enable(),
>> so even after power loss we will still kick in rescan automatically.
>>
>> Suggested-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/qgroup.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index c25dc47210a3..13c1c7dd278d 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -930,7 +930,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle *=
trans,
>>  	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
>>  	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VERSI=
ON);
>>  	fs_info->qgroup_flags =3D BTRFS_QGROUP_STATUS_FLAG_ON |
>> -				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>> +				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
>> +				BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>>  	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
>>  	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
>> =20
>> @@ -987,7 +988,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *=
trans,
>>  	fs_info->quota_root =3D quota_root;
>>  	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>  	spin_unlock(&fs_info->qgroup_lock);
>> -	ret =3D qgroup_rescan_init(fs_info, 0, 1);
>> +	ret =3D qgroup_rescan_init(fs_info, 0, 0);
>>  	if (!ret) {
>>  	        qgroup_rescan_zero_tracking(fs_info);
>>  	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
>>
>=20
> This is what I think at first, but is it ok not holding fs_info->qgroup=
_ioctl_lock
> in brfs_qgroup_rescan() as you concerned in previous thread?

I think it's OK, since we have larger mutex (subvol_sem) for
quota_enable/disable() so there will be no concurrency modifying flags.
And we're holding trans handler from btrfs_ioctl_quota_ctl(),
transaction won't be committed in btrfs_quota_enable().

So I think it's OK.

Thanks,
Qu



--CXOPHOaxVgLVvQRINmApZa5cDAusdTrvm--

--8qKHsEd5qBpnH69QmvCLDddhLbA719RSm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltaczIACgkQwj2R86El
/qgwOAf/Y5Zz6Jw79xSOnCs0fLjM4mlxeIBD2GPtQ87mCMqY1pZuAYFblZUxbAri
G4WQnyCp2fYY6PRf+EH+0LGaI16UqmqX9f7t29hQT4tYxOh01DJ4TX7lJHKNnHeS
o1LZOTOvOgXQcQF0IXF19s9DnhnzCv/2Sme27EdnbwW0Wx3Ub/LAL8XY9TWPuHI4
Mfo8UmK05zzwaGBnFPa9sulWdZFjJhMl90dmF4bKLN3M9uVufoHhNLVoX4rZhjH8
6VDdtfPtuzAhgXVpHqZ7ZoCLxmZvdiMlXqg+gFicWXJ6qwbUshL2OZAlGg6oci3s
Ka+op4CTictU8eRTcNXeh2h+24dcjQ==
=ahZd
-----END PGP SIGNATURE-----

--8qKHsEd5qBpnH69QmvCLDddhLbA719RSm--
