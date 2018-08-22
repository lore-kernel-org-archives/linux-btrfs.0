Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:41115 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbeHVIXZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 04:23:25 -0400
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
To: Su Yue <Damenly_Su@gmx.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dan.merillat@gmail.com
References: <20180812013358.16431-1-wqu@suse.com>
 <trinity-c93954f2-367f-4aa0-947d-cb5c107877e0-1534905201387@3c-app-mailcom-bs02>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <edfaf3de-db70-7280-2758-66ac8847f4de@gmx.com>
Date: Wed, 22 Aug 2018 12:59:58 +0800
MIME-Version: 1.0
In-Reply-To: <trinity-c93954f2-367f-4aa0-947d-cb5c107877e0-1534905201387@3c-app-mailcom-bs02>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6wsjwUMLFyWQw9xkeITdtJa5ZXhr5ywpZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6wsjwUMLFyWQw9xkeITdtJa5ZXhr5ywpZ
Content-Type: multipart/mixed; boundary="RM6nz9C6Wo5ou4xStXOl5v3sXOQS5wpCQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <Damenly_Su@gmx.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dan.merillat@gmail.com
Message-ID: <edfaf3de-db70-7280-2758-66ac8847f4de@gmx.com>
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
References: <20180812013358.16431-1-wqu@suse.com>
 <trinity-c93954f2-367f-4aa0-947d-cb5c107877e0-1534905201387@3c-app-mailcom-bs02>
In-Reply-To: <trinity-c93954f2-367f-4aa0-947d-cb5c107877e0-1534905201387@3c-app-mailcom-bs02>

--RM6nz9C6Wo5ou4xStXOl5v3sXOQS5wpCQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/22 =E4=B8=8A=E5=8D=8810:33, Su Yue wrote:
>=20
>=20
>> Sent: Sunday, August 12, 2018 at 9:33 AM
>> From: "Qu Wenruo" <wqu@suse.com>
>> To: linux-btrfs@vger.kernel.org, dan.merillat@gmail.com
>> Subject: [PATCH] btrfs-progs: rescue: Add ability to disable quota off=
line
>>
>> Provide an offline tool to disable quota.
>>
>> For kernel which skip_balance doesn't work, there is no way to disable=

>> quota on huge fs with balance, as quota will cause balance to hang for=
 a
>> long long time for each tree block switch.
>>
> Make sense the use case.
>=20
>> So add an offline rescue tool to disable quota.
>>
>=20
>> Reported-by: Dan Merillat <dan.merillat@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Some nitpicks below.
> After fixes them, you can add tag:
>=20
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>=20
>> ---
>> This can patch can be fetched from github repo:
>> https://github.com/adam900710/btrfs-progs/tree/quota_disable
>> ---
>>  Documentation/btrfs-rescue.asciidoc |  6 +++
>>  cmds-rescue.c                       | 80 ++++++++++++++++++++++++++++=
+
>>  2 files changed, 86 insertions(+)
>>
>> diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs=
-rescue.asciidoc
>> index f94a0ff2b45e..fb088c1a768a 100644
>> --- a/Documentation/btrfs-rescue.asciidoc
>> +++ b/Documentation/btrfs-rescue.asciidoc
>> @@ -31,6 +31,12 @@ help.
>>  NOTE: Since *chunk-recover* will scan the whole device, it will be *V=
ERY* slow
>>  especially executed on a large device.
>> =20
>> +*disable-quota* <device>::
>> +disable quota offline
>> ++
>> +Acts as a fallback method to disable quota for case where mount hangs=
 due to
>> +balance and quota.
>> +
>>  *fix-device-size* <device>::
>>  fix device size and super block total bytes values that are do not ma=
tch
>>  +
>> diff --git a/cmds-rescue.c b/cmds-rescue.c
>> index 38c4ab9b2ef6..c7cd92427e9d 100644
>> --- a/cmds-rescue.c
>> +++ b/cmds-rescue.c
>> @@ -250,6 +250,84 @@ out:
>>  	return !!ret;
>>  }
>> =20
>> +static const char * const cmd_rescue_disable_quota_usage[] =3D {
>> +	"btrfs rescue disable-quota <device>",
>> +	"Disable quota, especially useful for balance mount hang when quota =
enabled",
>> +	"",
>> +	NULL
>> +};
>> +
>> +static int cmd_rescue_disable_quota(int argc, char **argv)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_fs_info *fs_info;
>> +	struct btrfs_path path;
>> +	struct btrfs_root *root;
>> +	struct btrfs_qgroup_status_item *qi;
>> +	struct btrfs_key key;
>> +	char *devname;
>> +	int ret;
>> +
>> +	clean_args_no_options(argc, argv, cmd_rescue_disable_quota_usage);
>> +	if (check_argc_exact(argc, 2))
>> +		usage(cmd_rescue_disable_quota_usage);
>> +
>> +	devname =3D argv[optind];
>> +	ret =3D check_mounted(devname);
>> +	if (ret < 0) {
>> +		error("could not check mount status: %s", strerror(-ret));
>> +		return !!ret;
>> +	} else if (ret) {
>> +		error("%s is currently mounted", devname);
>> +		return !!ret;
>> +	}
>> +	fs_info =3D open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES);=

>=20
> Not undertstand why not add OPEN_CTREE_PARTIAL here?
> The function is located in cmd-rescue, so may the FS is corrupted alrea=
dy?

Here I'm trying to avoid anything wrong with extent tree.

In that case, even we only CoW one tree block, with corrupted extent
tree we could screw up the whole fs further more.

So I avoid OPEN_CTREE_PARTIAL here.

>=20
>> +	if (!fs_info) {
>> +		error("could not open btrfs");
>> +		ret =3D -EIO;
>> +		return !!ret;
>> +	}
>> +	root =3D fs_info->quota_root;
>> +	if (!root) {
>> +		printf("Quota is not enabled, no need to modify the fs\n");
>> +		goto close;
>> +	}
>> +	btrfs_init_path(&path);
>> +	trans =3D btrfs_start_transaction(root, 1);
>> +	if (IS_ERR(trans)) {
>> +		ret =3D PTR_ERR(trans);
>> +		error("failed to start transaction: %s", strerror(-ret));
>> +		goto close;
>> +	}
>> +	key.objectid =3D 0;
>> +	key.type =3D BTRFS_QGROUP_STATUS_KEY;
>> +	key.offset =3D 0;
>> +	ret =3D btrfs_search_slot(trans, root, &key, &path, 0, 1);
>> +	if (ret < 0) {
>> +		error("failed to search tree: %s", strerror(-ret));
>> +		goto close;
>> +	}
>> +	if (ret > 0) {
>> +		printf(
>> +		"qgroup status item not found, not need to modify the fs");
> nits: s/qgroup/Qgroup and a linebreaker is needed.

Oh, I forgot that,

Thanks for pointing this out,
Qu

>=20
>> +		ret =3D 0;
>> +		goto release;
>> +	}
>> +	qi =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +			    struct btrfs_qgroup_status_item);
>> +	btrfs_set_qgroup_status_flags(path.nodes[0], qi,
>> +			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
>> +	btrfs_mark_buffer_dirty(path.nodes[0]);
>> +	ret =3D btrfs_commit_transaction(trans, root);
>> +	if (ret < 0)
>> +		error("failed to commit transaction: %s", strerror(-ret));
>> +release:
>> +	btrfs_release_path(&path);
>> +close:
>> +	close_ctree(fs_info->tree_root);
>> +	return !!ret;
>> +}
>> +
>>  static const char rescue_cmd_group_info[] =3D
>>  "toolbox for specific rescue operations";
>> =20
>> @@ -262,6 +340,8 @@ const struct cmd_group rescue_cmd_group =3D {
>>  		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL,=
 0},
>>  		{ "fix-device-size", cmd_rescue_fix_device_size,
>>  			cmd_rescue_fix_device_size_usage, NULL, 0},
>> +		{ "disable-quota", cmd_rescue_disable_quota,
>> +			cmd_rescue_disable_quota_usage, NULL, 0},
>>  		NULL_CMD_STRUCT
>>  	}
>>  };
>> --=20
>> 2.18.0
>>
>>


--RM6nz9C6Wo5ou4xStXOl5v3sXOQS5wpCQ--

--6wsjwUMLFyWQw9xkeITdtJa5ZXhr5ywpZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt87c4ACgkQwj2R86El
/qiNqwgAreRLiCXwLDtKRyMgmKF8bBnlY5LpkNfzjpYxQ10+h6JwbBnZuhvz4Fc/
w6VknE3WA17Io2poq5Hm+mkgSCsm46xr3GpLCPyxEsAY4W6kRHKJEErvtcr15/vU
6JMFuWsI5lz2vWJ2QwIEl7pMtqFRsgAxuViZnPymzNH3LwPxKBBIO03TDB0jycFI
YSRaZorIa78QWe/vVI2hKdxrlxIssQhn5bakdinU6nGjp6+bhevXd7U1rUZrugfY
DIlEWq8jAJgwvBOexiy8nV/ZIxNLNzVSqCcrR1/D0+1qOh2aaE64g0VjAOsd0usU
Fpd79TFacI2dg0Rqs1qrLlfq9nhKKg==
=S0KB
-----END PGP SIGNATURE-----

--6wsjwUMLFyWQw9xkeITdtJa5ZXhr5ywpZ--
