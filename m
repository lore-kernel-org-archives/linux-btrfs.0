Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59877 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933865AbeBMJKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:10:47 -0500
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
To: Nikolay Borisov <nborisov@suse.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
 <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
 <6802cddd-5609-bce4-5274-d2dc59b664d2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d6872e2d-f00d-10bf-98c0-c2b5a6e13435@gmx.com>
Date: Tue, 13 Feb 2018 17:10:29 +0800
MIME-Version: 1.0
In-Reply-To: <6802cddd-5609-bce4-5274-d2dc59b664d2@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iQfJJGNMJEJ08BdVbJmtgy9woxkcOqn48"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iQfJJGNMJEJ08BdVbJmtgy9woxkcOqn48
Content-Type: multipart/mixed; boundary="Z6v2PITbcicrj4qxS2TMp5OjUqd3bKZDR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Anand Jain <anand.jain@oracle.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <d6872e2d-f00d-10bf-98c0-c2b5a6e13435@gmx.com>
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
 <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
 <6802cddd-5609-bce4-5274-d2dc59b664d2@suse.com>
In-Reply-To: <6802cddd-5609-bce4-5274-d2dc59b664d2@suse.com>

--Z6v2PITbcicrj4qxS2TMp5OjUqd3bKZDR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 17:08, Nikolay Borisov wrote:
>=20
>=20
> On 13.02.2018 11:05, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 11:53, Anand Jain wrote:
>>> For forensic investigations of issues, we would want to know
>>> if and when the user cancels the replace.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>> ---
>>> v1->v2: use btrfs_dev_name() instead of rcu_str_deref()
>>>         as btrfs_dev_name() also provides "missing" string,
>>>         if needed.
>>
>> Would you please provide the branch you're using?
>>
>> As I couldn't find the function or macro of btrfs_dev_name()
>=20
>=20
> I have it in my misc-next checkout. I got introduced by
> 3c958bd23b60 ("btrfs: add helper for device path or missing")
>=20
> which is in 4.16-rc1 so pretty recent.

I was on v4.15, no wonder no such function.

Thank you very much,
Qu

>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>  fs/btrfs/dev-replace.c | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>>> index dd717e204b5e..3b0760f7ec8a 100644
>>> --- a/fs/btrfs/dev-replace.c
>>> +++ b/fs/btrfs/dev-replace.c
>>> @@ -703,6 +703,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info=
 *fs_info)
>>>  {
>>>  	struct btrfs_dev_replace *dev_replace =3D &fs_info->dev_replace;
>>>  	struct btrfs_device *tgt_device =3D NULL;
>>> +	struct btrfs_device *src_device =3D NULL;
>>>  	struct btrfs_trans_handle *trans;
>>>  	struct btrfs_root *root =3D fs_info->tree_root;
>>>  	int result;
>>> @@ -724,6 +725,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info=
 *fs_info)
>>>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>>>  		result =3D BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>>>  		tgt_device =3D dev_replace->tgtdev;
>>> +		src_device =3D dev_replace->srcdev;
>>>  		dev_replace->tgtdev =3D NULL;
>>>  		dev_replace->srcdev =3D NULL;
>>>  		break;
>>> @@ -741,6 +743,11 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_inf=
o *fs_info)
>>>  	}
>>>  	ret =3D btrfs_commit_transaction(trans);
>>>  	WARN_ON(ret);
>>> +
>>> +	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s cancele=
d",
>>> +		   btrfs_dev_name(src_device), src_device->devid,
>>> +		   btrfs_dev_name(tgt_device));
>>> +
>>>  	if (tgt_device)
>>>  		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
>>> =20
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Z6v2PITbcicrj4qxS2TMp5OjUqd3bKZDR--

--iQfJJGNMJEJ08BdVbJmtgy9woxkcOqn48
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCq4UXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhJYQf/V1iTDyIvZtNvcRvHbpleC7U2
G3LSw3PiQlnG+Yt2lQc1tedUX3QnxyISh+HfJt7wVuynoDB1JbuHXHf2StuUeLBk
lMMIsUCdB+Ca9854I00Z1x+eIGA/zg/XpnL5NaJ0SGo9X1a2iIKlLud4lu7cSJNA
PZjlUBrpYCs0fKq7SBFMHjQJUUnr9EkBe+LHVsq52JhUXa2LBe8yBzzIMbXGM1EZ
THHjKYPtM6bhMN/fvrUHTyA8rzEPxa4bkqBnBv5FA1EP9MCxDK/3Xwn/1KsmpvaF
LY8tKOJ50mb7OK4Eqcr5V9QVCFQl8OSoeEmx3+t/ScMU12/pF0GVMjNe+n8tJQ==
=ur6p
-----END PGP SIGNATURE-----

--iQfJJGNMJEJ08BdVbJmtgy9woxkcOqn48--
