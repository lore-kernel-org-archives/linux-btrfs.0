Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44967 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbeDRFch (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:32:37 -0400
Subject: Re: [PATCH v2 08/10] btrfs-progs: undelete-subvol: add
 undelete-subvol subcommand
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <13f077b1-7128-cf95-5972-383030aa1114@gmx.com>
Date: Wed, 18 Apr 2018 13:32:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gAAyf96307KTXbs0DtMs895pFZmoNgtGn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gAAyf96307KTXbs0DtMs895pFZmoNgtGn
Content-Type: multipart/mixed; boundary="EwCAqtDlHxzCcnZryvjdQjvLFfXk9ysbn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <13f077b1-7128-cf95-5972-383030aa1114@gmx.com>
Subject: Re: [PATCH v2 08/10] btrfs-progs: undelete-subvol: add
 undelete-subvol subcommand
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>

--EwCAqtDlHxzCcnZryvjdQjvLFfXk9ysbn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> Add the undelete-subvol subcommand for btrfs rescue. This subcommand is=

> used to recover deleted subvolume left intact on the device.
>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
> v2: add -s option to specify subvol_id.
>=20
>  cmds-rescue.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 70 insertions(+)
>=20
> diff --git a/cmds-rescue.c b/cmds-rescue.c
> index c40088ad374e..c5132126e922 100644
> --- a/cmds-rescue.c
> +++ b/cmds-rescue.c
> @@ -25,6 +25,7 @@
>  #include "disk-io.h"
>  #include "commands.h"
>  #include "utils.h"
> +#include "undelete-subvol.h"
>  #include "help.h"
> =20
>  static const char * const rescue_cmd_group_usage[] =3D {
> @@ -248,6 +249,73 @@ out:
>  	return !!ret;
>  }
> =20
> +static const char * const cmd_rescue_undelete_subvol_usage[] =3D {
> +	"btrfs rescue undelete-subvol [-s <subvolid>] <device>",
> +	"Undelete deleted subvolume",
> +	"All deleted subvolume that still left intact on the device will be",=

> +	"recovered. If -s <subvolid> option is given, then just recover the",=

> +	"subvolume which specified by <subvolid>.",
> +	"",
> +	"-s <subvolid>	specify the subvolume which will be recovered.",
> +	NULL
> +};
> +
> +static int cmd_rescue_undelete_subvol(int argc, char **argv)
> +{
> +	struct btrfs_fs_info *fs_info;
> +	char *devname;
> +	u64 subvol_id =3D 0;
> +	int ret;
> +
> +	while (1) {
> +		int c =3D getopt(argc, argv, "s:");
> +
> +		if (c < 0)
> +			break;
> +		switch (c) {
> +		case 's':
> +			subvol_id =3D arg_strtou64(optarg);
> +			if (!is_fstree(subvol_id)) {
> +				error("%llu is not a valid subvolume id",
> +						subvol_id);
> +				ret =3D -EINVAL;
> +				goto out;
> +			}
> +			break;
> +		default:
> +			usage(cmd_rescue_undelete_subvol_usage);
> +		}
> +	}
> +
> +	if (check_argc_exact(argc - optind, 1))
> +		usage(cmd_rescue_undelete_subvol_usage);
> +
> +	devname =3D argv[optind];
> +	ret =3D check_mounted(devname);
> +	if (ret < 0) {
> +		error("could not check mount status: %s", strerror(-ret));
> +		goto out;
> +	} else if (ret) {
> +		error("%s is currently mounted", devname);
> +		ret =3D -EBUSY;
> +		goto out;
> +	}
> +
> +	fs_info =3D open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES |
> +				     OPEN_CTREE_PARTIAL);

I'm not sure if using OPEN_CTREE_PARTIAL here is a good idea.

As the undelete-subvol looks like a tool to revert stupid user mistake,
and we expect a healthy fs to be provided.
And for corrupted fs, we may make the case worse.

Thanks,
Qu

> +	if (!fs_info) {
> +		error("could not open btrfs");
> +		ret =3D -EIO;
> +		goto out;
> +	}
> +
> +	ret =3D btrfs_undelete_intact_subvols(fs_info->tree_root, subvol_id);=

> +
> +	close_ctree(fs_info->tree_root);
> +out:
> +	return ret;
> +}
> +
>  static const char rescue_cmd_group_info[] =3D
>  "toolbox for specific rescue operations";
> =20
> @@ -260,6 +328,8 @@ const struct cmd_group rescue_cmd_group =3D {
>  		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, =
0},
>  		{ "fix-device-size", cmd_rescue_fix_device_size,
>  			cmd_rescue_fix_device_size_usage, NULL, 0},
> +		{ "undelete-subvol", cmd_rescue_undelete_subvol,
> +			cmd_rescue_undelete_subvol_usage, NULL, 0},
>  		NULL_CMD_STRUCT
>  	}
>  };
>=20


--EwCAqtDlHxzCcnZryvjdQjvLFfXk9ysbn--

--gAAyf96307KTXbs0DtMs895pFZmoNgtGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW2G0ACgkQwj2R86El
/qi3Gwf/WxAUuDVtNW6jSRsr4NXBGTiv9SNxo0ORlhMVU7xXISo0FzrshCKepCze
33+B6T5nFRr7AVCHGUEKlB1u1xLS3jBymc7HvuekxXI7nbnnT47siVcVra+HqGma
XeaLU3BjkTMqnrTuNVUg8zIuJPH71B2A7cOOsZ3WNErcXrZ4xaojRZpFdd8qWwaS
ircaNV6k6Xwgj25vsVAKJpx3qwYxpppyySIFLUvl9usLWe0mlau47SfiUQny4Fbr
vqV4eidqNSpKtVTWbLI3RXBIbBE8Hm4RD5EnYd8piBKE2UtHB3+8zv19+am8aqP2
cqi4g+FubykQTntzlqgn5voiWO9ELA==
=6UK+
-----END PGP SIGNATURE-----

--gAAyf96307KTXbs0DtMs895pFZmoNgtGn--
