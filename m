Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBDDC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 14:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D6DB2075C
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 14:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfCLOTt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:19:49 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:56979 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfCLOTt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 10:19:49 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1h3iFl-0002XA-Oq; Tue, 12 Mar 2019 14:19:37 +0000
Date:   Tue, 12 Mar 2019 14:19:37 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v5] btrfs-progs: dump-tree: add noscan option
Message-ID: <20190312141937.GC15963@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <1552396970-14651-1-git-send-email-anand.jain@oracle.com>
 <babdc163-61c5-1c12-7708-c26c544748ce@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <babdc163-61c5-1c12-7708-c26c544748ce@suse.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2019 at 04:16:29PM +0200, Nikolay Borisov wrote:
>=20
>=20
> On 12.03.19 =D0=B3. 15:22 =D1=87., Anand Jain wrote:
> > From: Anand Jain <Anand.Jain@oracle.com>
> >=20
> > The cli 'btrfs inspect dump-tree <dev>' will scan for the partner devic=
es
> > if any by default.
> >=20
> > So as of now you can not inspect each mirrored device independently.
> >=20
> > This patch adds noscan option, which when used won't scan the system for
> > the partner devices, instead it just uses the devices provided in the
> > argument.
> >=20
> > For example:
> >   btrfs inspect dump-tree --noscan <dev> [<dev>..]
> >=20
> > This helps to debug degraded raid1 and raid10.
>=20
> This is a much more clear and concise description of what you want to
> achieve. However, I don't think noscan is a good name, how about
> --use-dev or --force-dev or something like that ? I'll also like David
> to chime in on a particular naming. Don't be quick to send another versio=
n.

   How about --one-device, or just --device <dev1> --device <dev2> ...

> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> > v4->v5: nit: use %m to print error string.
> > 	changelog update.
> > v3->v4: change the patch title.
> > 	collapse scan_args() to its only parent cmd_inspect_dump_tree()
> > 	(it was bit confusing).
> > 	update the change log.
> > 	update usage.
> > 	update man page.
> > v2->v3: make it scalable for more than two disks in noscan mode
> > v1->v2: rename --degraded to --noscan
> >=20
> >  Documentation/btrfs-inspect-internal.asciidoc |  5 ++-
> >  cmds-inspect-dump-tree.c                      | 53 +++++++++++++++++++=
++------
> >  2 files changed, 45 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentat=
ion/btrfs-inspect-internal.asciidoc
> > index 381497d284b8..f9d7f1c58f00 100644
> > --- a/Documentation/btrfs-inspect-internal.asciidoc
> > +++ b/Documentation/btrfs-inspect-internal.asciidoc
> > @@ -61,7 +61,7 @@ specify which mirror to print, valid values are 0, 1 =
and 2 and the superblock
> >  must be present on the device with a valid signature, can be used toge=
ther with
> >  '--force'
> > =20
> > -*dump-tree* [options] <device>::
> > +*dump-tree* [options] <device> [device...]::
> >  (replaces the standalone tool *btrfs-debug-tree*)
> >  +
> >  Dump tree structures from a given device in textual form, expand keys =
to human
> > @@ -95,6 +95,9 @@ intermixed in the output
> >  --bfs::::
> >  use breadth-first search to print trees. the nodes are printed before =
all
> >  leaves
> > +--noscan::::
> > +do not scan the system for other partner device(s), only use the devic=
e(s)
> > +provided in the argument
> >  -t <tree_id>::::
> >  print only the tree with the specified ID, where the ID can be numeric=
al or
> >  common name in a flexible human readable form
> > diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> > index ad5345b4f1db..37d9b29fa824 100644
> > --- a/cmds-inspect-dump-tree.c
> > +++ b/cmds-inspect-dump-tree.c
> > @@ -21,6 +21,7 @@
> >  #include <unistd.h>
> >  #include <uuid/uuid.h>
> >  #include <getopt.h>
> > +#include <fcntl.h>
> > =20
> >  #include "kerncompat.h"
> >  #include "radix-tree.h"
> > @@ -185,7 +186,7 @@ static u64 treeid_from_string(const char *str, cons=
t char **end)
> >  }
> > =20
> >  const char * const cmd_inspect_dump_tree_usage[] =3D {
> > -	"btrfs inspect-internal dump-tree [options] device",
> > +	"btrfs inspect-internal dump-tree [options] <device> [<device> ..]",
> >  	"Dump tree structures from a given device",
> >  	"Dump tree structures from a given device in textual form, expand key=
s to human",
> >  	"readable equivalents where possible.",
> > @@ -200,6 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] =
=3D {
> >  	"-b|--block <block_num> print info from the specified block only",
> >  	"-t|--tree <tree_id>    print only tree with the given id (string or =
number)",
> >  	"--follow               use with -b, to show all children tree blocks=
 of <block_num>",
> > +	"--noscan               do not scan for the partner device(s)",
> >  	NULL
> >  };
> > =20
> > @@ -214,7 +216,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >  	struct btrfs_disk_key disk_key;
> >  	struct btrfs_key found_key;
> >  	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
> > -	int ret;
> > +	int ret =3D 0;
> >  	int slot;
> >  	int extent_only =3D 0;
> >  	int device_only =3D 0;
> > @@ -222,6 +224,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >  	int roots_only =3D 0;
> >  	int root_backups =3D 0;
> >  	int traverse =3D BTRFS_PRINT_TREE_DEFAULT;
> > +	int dev_optind;
> >  	unsigned open_ctree_flags;
> >  	u64 block_only =3D 0;
> >  	struct btrfs_root *tree_root_scan;
> > @@ -239,8 +242,8 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >  	optind =3D 0;
> >  	while (1) {
> >  		int c;
> > -		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS,
> > -		       GETOPT_VAL_BFS };
> > +		enum { GETOPT_VAL_FOLLOW =3D 256, GETOPT_VAL_DFS, GETOPT_VAL_BFS,
> > +		       GETOPT_VAL_NOSCAN};
> >  		static const struct option long_options[] =3D {
> >  			{ "extents", no_argument, NULL, 'e'},
> >  			{ "device", no_argument, NULL, 'd'},
> > @@ -252,6 +255,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >  			{ "follow", no_argument, NULL, GETOPT_VAL_FOLLOW },
> >  			{ "bfs", no_argument, NULL, GETOPT_VAL_BFS },
> >  			{ "dfs", no_argument, NULL, GETOPT_VAL_DFS },
> > +			{ "noscan", no_argument, NULL, GETOPT_VAL_NOSCAN },
> >  			{ NULL, 0, NULL, 0 }
> >  		};
> > =20
> > @@ -313,24 +317,49 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >  		case GETOPT_VAL_BFS:
> >  			traverse =3D BTRFS_PRINT_TREE_BFS;
> >  			break;
> > +		case GETOPT_VAL_NOSCAN:
> > +			open_ctree_flags |=3D OPEN_CTREE_NO_DEVICES;
> > +			break;
> >  		default:
> >  			usage(cmd_inspect_dump_tree_usage);
> >  		}
> >  	}
> > =20
> > -	if (check_argc_exact(argc - optind, 1))
> > +	if (check_argc_min(argc - optind, 1))
> >  		usage(cmd_inspect_dump_tree_usage);
> > =20
> > -	ret =3D check_arg_type(argv[optind]);
> > -	if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
> > +	dev_optind =3D optind;
> > +	while (dev_optind < argc) {
> > +		int fd;
> > +		struct btrfs_fs_devices *fs_devices;
> > +		u64 num_devices;
> > +
> > +		ret =3D check_arg_type(argv[optind]);
> > +		if (ret !=3D BTRFS_ARG_BLKDEV && ret !=3D BTRFS_ARG_REG) {
> > +			if (ret < 0) {
> > +				errno =3D -ret;
> > +				error("invalid argument %s: %m", argv[dev_optind]);
> > +			} else {
> > +				error("not a block device or regular file: %s",
> > +				       argv[dev_optind]);
> > +			}
> > +		}
> > +		fd =3D open(argv[dev_optind], O_RDONLY);
> > +		if (fd < 0) {
> > +			error("cannot open %s: %m", argv[dev_optind]);
> > +			return -EINVAL;
> > +		}
> > +		ret =3D btrfs_scan_one_device(fd, argv[dev_optind], &fs_devices,
> > +					    &num_devices,
> > +					    BTRFS_SUPER_INFO_OFFSET,
> > +					    SBREAD_DEFAULT);
> > +		close(fd);
> >  		if (ret < 0) {
> >  			errno =3D -ret;
> > -			error("invalid argument %s: %m", argv[optind]);
> > -		} else {
> > -			error("not a block device or regular file: %s",
> > -			      argv[optind]);
> > +			error("device scan %s: %m", argv[dev_optind]);
> > +			return ret;
> >  		}
> > -		goto out;
> > +		dev_optind++;
> >  	}
> > =20
> >  	printf("%s\n", PACKAGE_STRING);
> >=20

--=20
Hugo Mills             | O tempura! O moresushi!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJch7/5AAoJEFheFHXiqx3kWwUP/2l1ZS+GAZ8mcthAeqn2TboX
k7WutBsYWx4FhTi69lUjBIQQodPkvsGK1YrNYOQZnC1kUDCKp+IAngkPWP4b6+JS
RBG9zpwFCkgv5iJJ1ssmIho5g7inSkdGBuzyfGhZh6kgZLbw917hZFUaT1oGwd65
3UH3EmDeMess6QcQgmLRvQtYgP+gt0qpAxtuKoFVO7B9Lor0RRUby62Q1Exz6mbk
Yy31zn5Dxqt/6VRQalgJ1qzCemYLJKvPXE5FxonTZJUorDgPng4CwnkWk3WjPgJ5
kDkWAxYUfTSKQN6CY7PZseS5G1r8IKkhVUxSsTRgItvl0WVXe7TzJj49l8G3w67W
dThAnb0HZ+etXbF+WYzLo6LPHDUgL4cWwnZXrOhe7s49KTrbUX7oEWezVH7EzVjt
XW4kcbkROjlh55s0gN8voE1vqIkethZjgBdQ2tx6RV5TrD0V2V0u0Nk5jdQAw+rC
DEjRr3Aipe2cGs62Q/Is+yBWeEBdzKls6BdeWF+7s5ICExSBrTrBUx8TNYIS9Gcd
GEv273ZePZQSDQ1BfZRsuheMvOBQFIG1TxjWGZlambJ80ugxvy1DlviRy4zu82Tc
VMp2JCHIZUWX6EcA+IvTyUYy5f74eGvvDTCUert9vJGh3/xuw+DnjGUQX9GkjbuE
odMXBVwdXZT7rQ7iCW84
=WS0t
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
