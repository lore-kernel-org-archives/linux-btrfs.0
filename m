Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37598 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbeG0HaW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jul 2018 03:30:22 -0400
Subject: Re: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable
 time
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180726091504.5833-1-wqu@suse.com>
 <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
 <c525eeeb-a73c-0dd4-a509-833b102b49d9@suse.de>
 <475ad0a0-ca60-f5a9-495a-af0449cfe708@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <08335c16-554d-3e26-8820-b73a0b452e8a@suse.de>
Date: Fri, 27 Jul 2018 14:09:40 +0800
MIME-Version: 1.0
In-Reply-To: <475ad0a0-ca60-f5a9-495a-af0449cfe708@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="z7UJEG3168KF6Syro5W1p75oJfNZPCJqH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z7UJEG3168KF6Syro5W1p75oJfNZPCJqH
Content-Type: multipart/mixed; boundary="M9qrvkC9E6uIVeeYXnsE7nWd3wLybQx8Z";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <08335c16-554d-3e26-8820-b73a0b452e8a@suse.de>
Subject: Re: [PATCH] btrfs: qgroup: Init flags with RESCAN bit at quota enable
 time
References: <20180726091504.5833-1-wqu@suse.com>
 <2531cce4-b3d5-88c7-30d5-b7461bd43fc3@jp.fujitsu.com>
 <c525eeeb-a73c-0dd4-a509-833b102b49d9@suse.de>
 <475ad0a0-ca60-f5a9-495a-af0449cfe708@jp.fujitsu.com>
In-Reply-To: <475ad0a0-ca60-f5a9-495a-af0449cfe708@jp.fujitsu.com>

--M9qrvkC9E6uIVeeYXnsE7nWd3wLybQx8Z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8827=E6=97=A5 09:43, Misono Tomohiro wrote:
> On 2018/07/27 10:19, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8827=E6=97=A5 09:10, Misono Tomohiro wrote:
>>> On 2018/07/26 18:15, Qu Wenruo wrote:
>>>> Between btrfs_quota_enable() finished and rescan kicked in, there is=
 a
>>>> small window that quota status has (ON | INCONSISTENT) bits set but
>>>> without RESCAN bits set.
>>>>
>>>> And transaction is committed inside the window and then power loss
>>>> happens, we will have a quota tree with all qgroup numbers set to 0,=
 and
>>>> not RESCAN bit set.
>>>>
>>>> At next mount time, qgroup rescan will not kick in due to the missin=
g of
>>>> RESCAN bit, user needs to kick in rescan manually.
>>>>
>>>> This patch will fix it by setting RESCAN bit at btrfs_quota_enable()=
,
>>>> so even after power loss we will still kick in rescan automatically.=

>>>>
>>>> Suggested-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/qgroup.c | 5 +++--
>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index c25dc47210a3..13c1c7dd278d 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -930,7 +930,8 @@ int btrfs_quota_enable(struct btrfs_trans_handle=
 *trans,
>>>>  	btrfs_set_qgroup_status_generation(leaf, ptr, trans->transid);
>>>>  	btrfs_set_qgroup_status_version(leaf, ptr, BTRFS_QGROUP_STATUS_VER=
SION);
>>>>  	fs_info->qgroup_flags =3D BTRFS_QGROUP_STATUS_FLAG_ON |
>>>> -				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>>>> +				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT |
>>>> +				BTRFS_QGROUP_STATUS_FLAG_RESCAN;
>>>>  	btrfs_set_qgroup_status_flags(leaf, ptr, fs_info->qgroup_flags);
>>>>  	btrfs_set_qgroup_status_rescan(leaf, ptr, 0);
>>>> =20
>>>> @@ -987,7 +988,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle=
 *trans,
>>>>  	fs_info->quota_root =3D quota_root;
>>>>  	set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>>>  	spin_unlock(&fs_info->qgroup_lock);
>>>> -	ret =3D qgroup_rescan_init(fs_info, 0, 1);
>>>> +	ret =3D qgroup_rescan_init(fs_info, 0, 0);
>>>>  	if (!ret) {
>>>>  	        qgroup_rescan_zero_tracking(fs_info);
>>>>  	        btrfs_queue_work(fs_info->qgroup_rescan_workers,
>>>>
>>>
>>> This is what I think at first, but is it ok not holding fs_info->qgro=
up_ioctl_lock
>>> in brfs_qgroup_rescan() as you concerned in previous thread?
>>
>> I think it's OK, since we have larger mutex (subvol_sem) for
>> quota_enable/disable() so there will be no concurrency modifying flags=
=2E
>> And we're holding trans handler from btrfs_ioctl_quota_ctl(),
>> transaction won't be committed in btrfs_quota_enable().
>=20
> Ok, but nikolay's patch in misc-next moves transaction commit in btrfs_=
quota_enable():
>   https://patchwork.kernel.org/patch/10508819/
>   ("btrfs: qgroups: Move transaction management inside btrfs_quota_enab=
le/disable")

Since qgroup_rescan_init() has nothing do to with transaction, it looks
OK even with Nikolay's patch.

>=20
> This is related to https://marc.info/?l=3Dlinux-btrfs&m=3D1529992890175=
82.
> However, it seems that other people does not see the problem,
> so I'm not sure how the above patch ends up...

IIRC I also failed to reproduce it, thus can't provide much help for
that thread.

Thanks,
Qu



>=20
> Thanks,
> Tomohiro Misono
>=20
>>
>> So I think it's OK.
>>
>> Thanks,
>> Qu
>>
>>
>=20


--M9qrvkC9E6uIVeeYXnsE7nWd3wLybQx8Z--

--z7UJEG3168KF6Syro5W1p75oJfNZPCJqH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltatyQACgkQwj2R86El
/qgGUQf/XoT2Fqy14kB/zvt74/QdSM9Kwdft2qmqtcSPXOXBnulwa34XyiVTqkux
QRTKGcVna2onLAQVTIEJyqYepjeKi+ItzPi5/en2NSUFeX+aJMQO7ptLnk020sT/
4QpeQQGu4dIALdFASKlE/zWtunxD5M/MsRZuudwJ2T/VlJL1u5fk5OZ719l1TPZd
TIRa/KtihGGkVtH+B/RZBX3XS3lhXL/3AutmMi5T8ZKEc6vrM6bhEd1EHCtTlcj+
Y6cJlYlTbi7CzwO/ezRl6OzG6ScEgFn/NUr0oWW4XvnYHeOtXtV1OQqrtNCkQRaF
GPMfzNHWnRRx5Uq8bIJtxZPYQGAGHg==
=SnCL
-----END PGP SIGNATURE-----

--z7UJEG3168KF6Syro5W1p75oJfNZPCJqH--
