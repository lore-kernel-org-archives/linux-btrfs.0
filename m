Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52D6C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 04:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6541E2133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 04:53:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="LDl3LXka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfDKExZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 00:53:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:35389 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDKExY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 00:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554958394;
        bh=GP9xdaQG2V7nn4sCXf5sLZSdTUBBw9dvCqZrB34ELvE=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=LDl3LXkaMeDoS2qcUyg/9k0SPwdsZeeNAlYvKBN6vTP4N5LbLSNmqP5DdK08vTPOx
         5P1Qguc3/DF1+ozvjzPANSWGtHT+f5Eu2kCAaMfB26vThBN3ZR0/NmXIF4NKkcnQOR
         Mc0B2G/VTVC26NCNUQNiGTdsBGRUa4pNb0kXoKBo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M8e5P-1h0mq21CNP-00wCpv; Thu, 11
 Apr 2019 06:53:14 +0200
Subject: Re: [PATCH v5 RESEND] btrfs-progs: dump-tree: add noscan option
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190404072957.2847-1-anand.jain@oracle.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <121e7005-2535-c3d3-d779-9401db10bfa9@gmx.com>
Date:   Thu, 11 Apr 2019 12:53:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190404072957.2847-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Nor0UcuCC9BYaBNmtZdHgGLFBBxZX1OEw"
X-Provags-ID: V03:K1:ePggCbeDx6X2UnsZZwfVRdTaHGodBt/28BCbnlW/8v1PbRk0BQL
 BUdwxgP0fBLJnfWJAB/NQANirgB0bXOWn1GpbUMza+FdwNYj3NYc4+iExKjZLyTV+cNVO8a
 3eX8E5o7hJl5R8CP7EkJSiW+zs9vF0wSL0RgB1hmCixpwDc1yvH+cPmvuQ/OeVZGWL1whRD
 mdOjpYUdW0X+U/9umaHYQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tUI1QbQ7Cmw=:D4xHI/rGf1pj+lLRP7viLE
 IwxCnjCHq+oGzSi02MAMbyxZfoIS19E2cavrrlp71uJkNlEPWgO4PyaNdThLHu3cNFByu+5YG
 S8QV/4IyG8gTKdYb2B4ndYtOvAdroKA3tEKaBJCWJemYWpzv2xIY/jNJUNWxdYhXs+K84WkqP
 DH0O4D/+4rewDV7UX8HR1ysmAvclB4+GIHXeyrcpGjAjS6FtCRYaH9b/gvTtUq+8Hnhs15WA1
 MgeGSv/XyIUbjJWsijQFRlWd0EldKi93Rk5V6xbuSB51M2urwCDapATQLMkNWAsvJRYIxy2nu
 uWH2OjynkSyYgxMTahvQ9TkIodGyMgBLZ/KN0dBwK9xdOA23oemL1nJ34klMaRBegQrzfimV+
 8sS6PyWs5RycyaP8sHeoO7uMOkXKK2Ui4HAsfrvWkJRnnilcA4ZKr07xntRxkyO5QYJPJVil1
 gB2cgS/dcd3NpGWkVXja8ClP8s0bnyWr7HC9byjI4TyYirkOiwnySIipmg1CxzM9xrWjQxM7f
 hoPbalV55bKbVgyKEqJmerhyvuasUVF6GnVEPhMTj+FAGbWg1yEH/HFiH16MPGUGZsTQdjQk5
 JcYWv4J7l8S1YuBoUhVdBKPPoapP5GIAmJi7L7DUya+QaJKpIwsUY/hSOTVaKFI1X3QO1ssOE
 9A8zHZECX7fb/vb/YTRtm1QkMnsm7oPDqjBvHJPm7gDmoFUMP9OmYQy26WUmvD1d4em6Da31g
 3gmXxaqKQQ2Emfgl1n2wxHBY97bbEvuz3VxcLc41YntmfTvieNoGK+vq/pr/1IApw70/f7sez
 bYYUm+PYk+c9Xq251y5vsIf/xGMshUb7Y8hoZuTP67iIrGvcMCMl2LbqtzW2l2+kyV+PMz3Ga
 JwHG5LjiPEf3uw5lvzaGN+oJszSAonKVbxS+sjMSqG6fKXfq+kfhEKME2zh3+Z
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nor0UcuCC9BYaBNmtZdHgGLFBBxZX1OEw
Content-Type: multipart/mixed; boundary="LzH82meEstKr89maHd8u5DqZFeEjNEb4M";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <121e7005-2535-c3d3-d779-9401db10bfa9@gmx.com>
Subject: Re: [PATCH v5 RESEND] btrfs-progs: dump-tree: add noscan option
References: <20190404072957.2847-1-anand.jain@oracle.com>
In-Reply-To: <20190404072957.2847-1-anand.jain@oracle.com>

--LzH82meEstKr89maHd8u5DqZFeEjNEb4M
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/4 =E4=B8=8B=E5=8D=883:29, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
>=20
> The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devic=
es
> if any by default.
>=20
> So as of now you can not inspect each mirrored device independently.
>=20
> This patch adds noscan option, which when used won't scan the system fo=
r
> the partner devices, instead it just uses the devices provided in the
> argument.
>=20
> For example:
>   btrfs inspect dump-tree --noscan <dev> [<dev>..]

So you can specify multiple devices, just like kernel "device=3D" mount
option.

Then I don't think --noscan is a good naming, while I don't have any
good alternative, as the --degraded is no better.

My idea is "(--device=3D<dev1>,<dev2>)|(<dev>)", but that looks more awfu=
l.

Despite of that, the patch looks pretty good.

>=20
> This helps to debug degraded raid1 and raid10.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4->v5: nit: use %m to print error string.
> 	changelog update.
> v3->v4: change the patch title.
> 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
> 	(it was bit confusing).

I don't this is the correct direction.

You're introducing "--device=3D" btrfs-progs equivalent, there is no way
it will only be utilized by dump-tree.

Btrfs-check, btrfs-restore can all take advantage of this feature.

You don't need to resend, later code can export them when needed.
But doing it at the first place really helps.

Thanks,
Qu

> 	update the change log.
> 	update usage.
> 	update man page.
> v2->v3: make it scalable for more than two disks in noscan mode
> v1->v2: rename --degraded to --noscan
>=20
>  Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
>  cmds-inspect-dump-tree.c                      | 53 +++++++++++++++++++=
++------
>  2 files changed, 45 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentat=
ion/btrfs-inspect-internal.asciidoc
> index 381497d284b8..f9d7f1c58f00 100644
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 =
and 2 and the superblock
>  must be present on the device with a valid signature, can be used toge=
ther with
>  '--force'
> =20
> -*dump-tree* [options] <device>::
> +*dump-tree* [options] <device> [device...]::
>  (replaces the standalone tool *btrfs-debug-tree*)
>  +
>  Dump tree structures from a given device in textual form, expand keys =
to human
> @@ -95,6 +95,9 @@ intermixed in the output
>  --bfs::::
>  use breadth-first search to print trees. the nodes are printed before =
all
>  leaves
> +--noscan::::
> +do not scan the system for other partner device(s), only use the devic=
e(s)
> +provided in the argument
>  -t <tree_id>::::
>  print only the tree with the specified ID, where the ID can be numeric=
al or
>  common name in a flexible human readable form
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index ad5345b4f1db..37d9b29fa824 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -21,6 +21,7 @@
>  #include <unistd.h>
>  #include <uuid/uuid.h>
>  #include <getopt.h>
> +#include <fcntl.h>
> =20
>  #include "kerncompat.h"
>  #include "radix-tree.h"
> @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, cons=
t char **end)
>  }
> =20
>  const char * const cmd_inspect_dump_tree_usage[] =3D {
> -	"btrfs inspect-internal dump-tree [options] device",
> +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
>  	"Dump tree structures from a given device",
>  	"Dump tree structures from a given device in textual form, expand key=
s to human",
>  	"readable equivalents where possible.",
> @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] =3D=
 {
>  	"-b|--block <block_num> print info from the specified block only",
>  	"-t|--tree <tree_id>    print only tree with the given id (string or =
number)",
>  	"--follow               use with -b, to show all children tree blocks=
 of <block_num>",
> +	"--noscan               do not scan for the partner device(s)",
>  	NULL
>  };
> =20
> @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  	struct btrfs_disk_key disk_key;
>  	struct btrfs_key found_key;
>  	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
> -	int ret;
> +	int ret =3D 0;
>  	int slot;
>  	int extent_only =3D 0;
>  	int device_only =3D 0;
> @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  	int roots_only =3D 0;
>  	int root_backups =3D 0;
>  	int traverse =3D BTRFS_PRINT_TREE_DEFAULT;
> +	int dev_optind;
>  	unsigned open_ctree_flags;
>  	u64 block_only =3D 0;
>  	struct btrfs_root *tree_root_scan;
> @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  	optind =3D 0;
>  	while (1) {
>  		int c;
> -		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS,
> -		       GETOPT_VAL_BFS };
> +		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
> +		       GETOPT_VAL_NOSCAN};
>  		static const struct option long_options[] =3D {
>  			{ "extents", no_argument, NULL, 'e'},
>  			{ "device", no_argument, NULL, 'd'},
> @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
>  			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
>  			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
> +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
>  			{ NULL, 0, NULL, 0 }
>  		};
> =20
> @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  		case GETOPT_VAL_BFS:
>  			traverse =3D BTRFS_PRINT_TREE_BFS;
>  			break;
> +		case GETOPT_VAL_NOSCAN:
> +			open_ctree_flags |=3D OPEN_CTREE_NO_DEVICES;
> +			break;
>  		default:
>  			usage(cmd_inspect_dump_tree_usage);
>  		}
>  	}
> =20
> -	if (check_argc_exact(argc - optind, 1))
> +	if (check_argc_min(argc - optind, 1))
>  		usage(cmd_inspect_dump_tree_usage);
> =20
> -	ret =3D check_arg_type(argv[optind]);
> -	if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
> +	dev_optind =3D optind;
> +	while (dev_optind < argc) {
> +		int fd;
> +		struct btrfs_fs_devices *fs_devices;
> +		u64 num_devices;
> +
> +		ret =3D check_arg_type(argv[optind]);
> +		if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
> +			if (ret < 0) {
> +				errno =3D -ret;
> +				error("invalid argument %s: %m", argv[dev_optind]);
> +			} else {
> +				error("not a block device or regular file: %s",
> +				       argv[dev_optind]);
> +			}
> +		}
> +		fd =3D open(argv[dev_optind], O_RDONLY);
> +		if (fd < 0) {
> +			error("cannot open %s: %m", argv[dev_optind]);
> +			return -EINVAL;
> +		}
> +		ret =3D btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
> +					    &num_devices,
> +					    BTRFS_SUPER_INFO_OFFSET,
> +					    SBREAD_DEFAULT);
> +		close(fd);
>  		if (ret < 0) {
>  			errno =3D -ret;
> -			error("invalid argument %s: %m", argv[optind]);
> -		} else {
> -			error("not a block device or regular file: %s",
> -			      argv[optind]);
> +			error("device scan %s: %m", argv[dev_optind]);
> +			return ret;
>  		}
> -		goto out;
> +		dev_optind++;
>  	}
> =20
>  	printf("%s\n", PACKAGE_STRING);
>=20


--LzH82meEstKr89maHd8u5DqZFeEjNEb4M--

--Nor0UcuCC9BYaBNmtZdHgGLFBBxZX1OEw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyuyDUACgkQwj2R86El
/qjO2QgAlTgS2/mUJhq3PLAjbNLV5piAHdr3JHURiPcFgFoakp2PXRANnHDz+kXC
tv6kgBijUb7GmcypIGezS0ICm/mVE+ayTTiVMAhjZTr6UruEHiHekEbfJFVRIQHA
f4hG9eK+9VyOoCPfFedxXXpNSVlCeek0audcQtOcrITC9zMShj/+2jFmm6uFFGeE
NHMhxNViMKNuDjltxx3bLB5DjuNIeoiD5NkplZBorR6vs09HfIolIHNIhBulq3LW
N95DUgZtSU6CUEMEQjFyyi+UyNPKDYTCmUkyI3psfOZQRSknP48GfyUK5CO4G/c3
exkF1Y3wAP4HU3R906RvFioJiKteIw==
=ReGK
-----END PGP SIGNATURE-----

--Nor0UcuCC9BYaBNmtZdHgGLFBBxZX1OEw--
