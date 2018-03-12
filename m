Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58129 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932337AbeCLAXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 20:23:51 -0400
Subject: Re: [PATCH v2] btrfs-progs: dump-tree: add degraded option
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0c04295b-1b42-37be-579d-5c8b7867affb@gmx.com>
Date: Mon, 12 Mar 2018 08:23:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180310135449.16072-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jGhTAApd6uK5Sn68y0RrlvsMpqiR3UIhA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180310135449.16072-1-anand.jain@oracle.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jGhTAApd6uK5Sn68y0RrlvsMpqiR3UIhA
Content-Type: multipart/mixed; boundary="xi6XoeT0lCjYbfm0L0cSsZ6W3VR6XxZtr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <0c04295b-1b42-37be-579d-5c8b7867affb@gmx.com>
Subject: Re: [PATCH v2] btrfs-progs: dump-tree: add degraded option
References: <20180309162324.GY23693@twin.jikos.cz>
 <20180310135449.16072-1-anand.jain@oracle.com>
In-Reply-To: <20180310135449.16072-1-anand.jain@oracle.com>

--xi6XoeT0lCjYbfm0L0cSsZ6W3VR6XxZtr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8810=E6=97=A5 21:54, Anand Jain wrote:
> btrfs inspect dump-tree cli picks the disk with the largest generation
> to read the root tree, even when all the devices were not provided in
> the cli. But in 2 disks RAID1 you may need to know what's in the disks
> individually, so this option -x | --noscan indicates to use only the
> given disk to dump.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: rename --degraded to --noscan
>=20
>  cmds-inspect-dump-tree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index df44bb635c9c..d2676ce55af7 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -198,6 +198,7 @@ const char * const cmd_inspect_dump_tree_usage[] =3D=
 {
>  	"-u|--uuid              print only the uuid tree",
>  	"-b|--block <block_num> print info from the specified block only",
>  	"-t|--tree <tree_id>    print only tree with the given id (string or =
number)",
> +	"-x|--noscan            use the disk in the arg, do not scan for the =
disks (for raid1)",

Still it looks a little too restrict.

What about some equivalent just like kernel "device=3D" mount option?

Thanks,
Qu

>  	NULL
>  };
> =20
> @@ -234,10 +235,11 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  			{ "uuid", no_argument, NULL, 'u'},
>  			{ "block", required_argument, NULL, 'b'},
>  			{ "tree", required_argument, NULL, 't'},
> +			{ "noscan", no_argument, NULL, 'x'},
>  			{ NULL, 0, NULL, 0 }
>  		};
> =20
> -		c =3D getopt_long(argc, argv, "deb:rRut:", long_options, NULL);
> +		c =3D getopt_long(argc, argv, "deb:rRut:x", long_options, NULL);
>  		if (c < 0)
>  			break;
>  		switch (c) {
> @@ -286,6 +288,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  			}
>  			break;
>  			}
> +		case 'x':
> +			open_ctree_flags |=3D OPEN_CTREE_NO_DEVICES;
> +			break;
>  		default:
>  			usage(cmd_inspect_dump_tree_usage);
>  		}
>=20


--xi6XoeT0lCjYbfm0L0cSsZ6W3VR6XxZtr--

--jGhTAApd6uK5Sn68y0RrlvsMpqiR3UIhA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqlyIwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qirMQgAjLKlJEz88b9ixygKghauMQvK
Q+49oD0oPve8OSUs71hdmlssvfKNNWXmED91u2UADK56uLW6MFlqFeohQIwnfIrA
laW7+mR6yShijTRJOziAMqPOX9GqU7hhKfWYb2IeAC+PxRKjr6ls7Vv3m3QTiLko
zua0bYLU19XFdseViAXZaYNlQYEBzKWCWgAlJ06NsY2hdFAKVj1pIy23ZmZId+Dd
i6Ds8XYQBNBifB74YbJJhW/b71MO7BEu4EBo5clK4UCHc8jCt1kYnUBsFbUHI9pv
b4CkVGBlUnmozUuwfnWiYyWHJFxWTcFQ64cbKieEib0ZGwc7u+PO3+0D/rVvmg==
=DSzQ
-----END PGP SIGNATURE-----

--jGhTAApd6uK5Sn68y0RrlvsMpqiR3UIhA--
