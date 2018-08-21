Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51471 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbeHUKt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 06:49:57 -0400
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180812013358.16431-1-wqu@suse.com>
 <c546e216-0108-fb2b-4193-b2ce1884c336@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b54fc9a5-60de-314a-f927-1d9f06372f1e@gmx.com>
Date: Tue, 21 Aug 2018 15:30:34 +0800
MIME-Version: 1.0
In-Reply-To: <c546e216-0108-fb2b-4193-b2ce1884c336@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9GRZMO3Ub9htrdS1C4IEiECl4JQs86jXt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9GRZMO3Ub9htrdS1C4IEiECl4JQs86jXt
Content-Type: multipart/mixed; boundary="RJDOt1nbpKISiCTjL5tyYUUwlelf0uGsl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b54fc9a5-60de-314a-f927-1d9f06372f1e@gmx.com>
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
References: <20180812013358.16431-1-wqu@suse.com>
 <c546e216-0108-fb2b-4193-b2ce1884c336@jp.fujitsu.com>
In-Reply-To: <c546e216-0108-fb2b-4193-b2ce1884c336@jp.fujitsu.com>

--RJDOt1nbpKISiCTjL5tyYUUwlelf0uGsl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/21 =E4=B8=8B=E5=8D=883:14, Misono Tomohiro wrote:
> On 2018/08/12 10:33, Qu Wenruo wrote:
>> Provide an offline tool to disable quota.
>>
>> For kernel which skip_balance doesn't work, there is no way to disable=

>> quota on huge fs with balance, as quota will cause balance to hang for=
 a
>> long long time for each tree block switch.
>>
>> So add an offline rescue tool to disable quota.
>>
>> Reported-by: Dan Merillat <dan.merillat@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
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
>> +		ret =3D 0;
>> +		goto release;
>> +	}
>> +	qi =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +			    struct btrfs_qgroup_status_item);
>> +	btrfs_set_qgroup_status_flags(path.nodes[0], qi,
>> +			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
>=20
> This is not what "btrfs quota disable" does (completely removes quota t=
ree),
> so I think it is better to have different name other than "disable-quot=
a"
> (I'm not sure about good name, maybe suspend?).

Yep, it is not the same as "btrfs quota disable", but the end result is
the same. Quota will be disabled, leaving quota tree as is.

Quota tree can be re-initialized just by re-enabling quota.

As long as the end result is the same, I doubt if it's really needed to
use a different name.

>=20
> btw, maybe we should add this ability to online fs too so that we can
> temporally disable quota during balance while keeping limit/inheritance=
 settings?

For balance, I'm considering to skip unmodified subtrees to speed up the
balance.

Temporarily disable quota has one big disadvantage, we need to rescan
quota, although that is much better than balance hang, it still brings
extra performance hit for later rescan.

Thanks,
Qu

>=20
> Thanks,
> Misono
>=20
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
>>
>=20


--RJDOt1nbpKISiCTjL5tyYUUwlelf0uGsl--

--9GRZMO3Ub9htrdS1C4IEiECl4JQs86jXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt7v5oACgkQwj2R86El
/qhi9QgAgkaxOuFk6TyVTSRJrS/b2RVi5C0RKwtPzaAgQl/LUyjzVrWbVnxd5mb5
/Nrmsug2nwlz7Fum6Q0pTk7Cs1LvhmPVQrXnerLhDxG7B/RZCmiGHVPlEri+IsMY
lPNYW7vb6W1zBKhVTDud1TA6GPFXRFgckoi+jJTcRw+k/XiB7z/xBMgFE98o1rLX
HhRn3GDWB2IqPEsSAPyDNTUQmxDIHnz3CxlGTabBJ+5rK0r3f+iYjXr2V8/sIP+L
XRjfettKvjUmy39RxhlgG9C3cWYsGGeeq2kwQjmeBMRp15Y3ogdq+NlL0zA+Pg54
jjKdVWQy1fm4EQwoDfsEIuRAjdHkKg==
=36Z1
-----END PGP SIGNATURE-----

--9GRZMO3Ub9htrdS1C4IEiECl4JQs86jXt--
