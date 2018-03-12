Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53885 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932451AbeCLDLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 23:11:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBF88AEB1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 03:11:10 +0000 (UTC)
Subject: Re: [PATCH 13/20] btrfs-progs: use cmd_struct as command entry point
To: linux-btrfs@vger.kernel.org
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-14-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <85840b4b-e8c4-d54d-bcf6-b52eaf7e3d5a@suse.com>
Date: Sun, 11 Mar 2018 23:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <20180308024047.10104-14-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eUaytGF9sb2fXgHe5CO17h7mhLequdYrA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eUaytGF9sb2fXgHe5CO17h7mhLequdYrA
Content-Type: multipart/mixed; boundary="Urogw5M22jVckAqPzThW1fOkYBFJhm0d8";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <85840b4b-e8c4-d54d-bcf6-b52eaf7e3d5a@suse.com>
Subject: Re: [PATCH 13/20] btrfs-progs: use cmd_struct as command entry point
References: <20180308024047.10104-1-jeffm@suse.com>
 <20180308024047.10104-14-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-14-jeffm@suse.com>

--Urogw5M22jVckAqPzThW1fOkYBFJhm0d8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/7/18 9:40 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index afd7fe48..12f200b3 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -625,33 +629,27 @@ static int cmd_inspect_min_dev_size(int argc, cha=
r **argv)
>  out:
>  	return !!ret;
>  }
> +static DEFINE_SIMPLE_COMMAND(inspect_min_dev_size, "min-dev-size");
> =20
>  static const char inspect_cmd_group_info[] =3D
>  "query various internal information";
> =20
> -const struct cmd_group inspect_cmd_group =3D {
> +static const struct cmd_group inspect_cmd_group =3D {
>  	inspect_cmd_group_usage, inspect_cmd_group_info, {
> -		{ "inode-resolve", cmd_inspect_inode_resolve,
> -			cmd_inspect_inode_resolve_usage, NULL, 0 },
> -		{ "logical-resolve", cmd_inspect_logical_resolve,
> -			cmd_inspect_logical_resolve_usage, NULL, 0 },
> -		{ "subvolid-resolve", cmd_inspect_subvolid_resolve,
> -			cmd_inspect_subvolid_resolve_usage, NULL, 0 },
> -		{ "rootid", cmd_inspect_rootid, cmd_inspect_rootid_usage, NULL,
> -			0 },
> -		{ "min-dev-size", cmd_inspect_min_dev_size,
> -			cmd_inspect_min_dev_size_usage, NULL, 0 },
> -		{ "dump-tree", cmd_inspect_dump_tree,
> -				cmd_inspect_dump_tree_usage, NULL, 0 },
> -		{ "dump-super", cmd_inspect_dump_super,
> -				cmd_inspect_dump_super_usage, NULL, 0 },
> -		{ "tree-stats", cmd_inspect_tree_stats,
> -				cmd_inspect_tree_stats_usage, NULL, 0 },
> -		NULL_CMD_STRUCT
> +		&cmd_struct_inspect_inode_resolve,
> +		&cmd_struct_inspect_logical_resolve,
> +		&cmd_struct_inspect_subvolid_resolve,
> +		&cmd_struct_inspect_rootid,
> +		&cmd_struct_inspect_min_dev_size,
> +		&cmd_struct_inspect_dump_tree,
> +		&cmd_struct_inspect_dump_super,
> +		&cmd_struct_inspect_tree_stats,
> +		NULL
>  	}
>  };
> =20
> -int cmd_inspect(int argc, char **argv)
> +static int cmd_inspect(int argc, char **argv)
>  {
>  	return handle_command_group(&inspect_cmd_group, argc, argv);
>  }
> +DEFINE_GROUP_COMMAND(inspect, "inspect");

"inspect-internal"

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--Urogw5M22jVckAqPzThW1fOkYBFJhm0d8--

--eUaytGF9sb2fXgHe5CO17h7mhLequdYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlql78oACgkQHntLYyF5
5bIVXg//XTCerptgmVM1H/GCpvSkjdjPgxB9+vxi9dVll6Hzer9d9vqaB/E2bTOH
Gj5Y99n4MWMnQ/bL8iPrvzWmiKr6nKbVHFGE5evMTQoUUls8CSrQKhJtvU8ei1jC
OBjD3dvtBnhSrbGCs8LKssQfiJfB3SquogWuKBz9x4n1CmloPqMHp9kfd/qHpSZd
GD42WH6TUOF1Iw2M+SkNCWNIHM7icBnEmVR37/jOUWQEzz8lx82wevRubucWxJ/F
l5w6T2OitLQbT6/MnF8BLGlWDWldhuIIxqIDes1pfQAfY/mn046zVDEtO1qM7AJ6
mkGNJojwDwGzxvi7aIUNBwjRt2WU9R7flVoZXTWShMds/MTj0W04JU8ODQ9Lonng
JHMvKNrOZz1XW31GlAhxx8aAwYZtJWK6CP+dC3bSNPtS95DEw/8Jcqets2jZFkTU
xI4qG0f2eQxxNCrBfCdLIsJWBDBm2GQcffMz6hr8kX3p2PC4lNtLlAkDEK7ic2NH
Usd0bhYLmgeuHHdh5ChzTivoSME3gQzr8hDkH7io5tkESIx2dmn90fbFt8z3Kzlx
abvOoF4nYzfuHSp72ppTncP3ToH5NP+x0V9yOK7ZQSE6l1WZW8gPDcpYlZtWfKjc
ADFTUfeFDtaWLAqXCz0Sna8lpv3F0+N5dtXjKnScf/iYyqCuafs=
=nbvX
-----END PGP SIGNATURE-----

--eUaytGF9sb2fXgHe5CO17h7mhLequdYrA--
