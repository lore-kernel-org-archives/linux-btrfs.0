Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50647 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeGSGde (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 02:33:34 -0400
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
Date: Thu, 19 Jul 2018 13:51:59 +0800
MIME-Version: 1.0
In-Reply-To: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t8Vu4edW4gDMjOntLhj8IUGhv34FeS5Gn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t8Vu4edW4gDMjOntLhj8IUGhv34FeS5Gn
Content-Type: multipart/mixed; boundary="42KS8CQ73BRJPM2vNCUxpxn5M6ev0GcqO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
In-Reply-To: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>

--42KS8CQ73BRJPM2vNCUxpxn5M6ev0GcqO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8819=E6=97=A5 13:15, Misono Tomohiro wrote:
> Add -i (ignore offset) option to logical-resolve command
> to show how BTRFS_IOC_LOGICAL_INO_V2 ioctl works
> (returns every ref to the extent of given logical address).
>=20
> [Example]
> $ mkfs.btrfs -f $DEV
> $ mount $DEV /mnt
>=20
> $ dd if=3D/dev/urandom of=3D/mnt/file bs=3D4k count=3D100
> # split above extent
> $ dd if=3D/dev/urandom of=3D/mnt/file bs=3D4k seek=3D10 count=3D1 conv=3D=
notrunc
> $ btrfs filesystem sync
>=20
> # v1
> $ btrfs inspect-internal logical-resolve -P 13631488 /mnt
> inode 257 offset 0 root 5
>=20
> # v2
> $ btrfs inspect-internal logical-resolve -iP 13631488 /mnt
> inode 257 offset 0 root 5
> inode 257 offset 45056 root 5
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
>  Documentation/btrfs-inspect-internal.asciidoc |  4 ++++
>  cmds-inspect.c                                | 17 +++++++++++++++--
>  ioctl.h                                       | 10 +++++++++-
>  libbtrfsutil/btrfs.h                          | 10 +++++++++-

Not related to this patch itself, but I'm wondering could we just use
/usr/include/linux/btrfs.h?

So we could save 2 same copies of headers here.

Thanks,
Qu

>  4 files changed, 37 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentat=
ion/btrfs-inspect-internal.asciidoc
> index e2db6466..a55c9add 100644
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -125,6 +125,10 @@ skip the path resolving and print the inodes inste=
ad
>  verbose mode, print count of returned paths and all ioctl() return val=
ues
>  -s <bufsize>::::
>  set internal buffer for storing the file names to 'bufsize', default i=
s 4096, maximum 64k
> +-i::::
> +ignore offset and return all the ref information
> +which points to the extent containing given logical address.
> +This requires version 2 ioctl support (BTRFS_IOC_LOGICAL_INO_V2, since=
 4.15).
> =20
>  *min-dev-size* [options] <path>::
>  (needs root privileges)
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index 2fc50c1a..d47eeacb 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -131,6 +131,9 @@ static const char * const cmd_inspect_logical_resol=
ve_usage[] =3D {
>  	"-s bufsize  set inode container's size. This is used to increase ino=
de",
>  	"            container's size in case it is not enough to read all th=
e ",
>  	"            resolved results. The max value one can set is 64k",
> +	"-i          ignore offset and return all the ref information",
> +	"            which points to the extent containing given logical addr=
ess",
> +	"            (requires version 2 ioctl support)",
>  	NULL
>  };
> =20
> @@ -142,7 +145,9 @@ static int cmd_inspect_logical_resolve(int argc, ch=
ar **argv)
>  	int verbose =3D 0;
>  	int getpath =3D 1;
>  	int bytes_left;
> +	int ignore_offset =3D 0;
>  	struct btrfs_ioctl_logical_ino_args loi;
> +	unsigned long ioctl_num =3D BTRFS_IOC_LOGICAL_INO;
>  	struct btrfs_data_container *inodes;
>  	u64 size =3D 4096;
>  	char full_path[PATH_MAX];
> @@ -151,7 +156,7 @@ static int cmd_inspect_logical_resolve(int argc, ch=
ar **argv)
> =20
>  	optind =3D 0;
>  	while (1) {
> -		int c =3D getopt(argc, argv, "Pvs:");
> +		int c =3D getopt(argc, argv, "Pvs:i");
>  		if (c < 0)
>  			break;
> =20
> @@ -165,6 +170,9 @@ static int cmd_inspect_logical_resolve(int argc, ch=
ar **argv)
>  		case 's':
>  			size =3D arg_strtou64(optarg);
>  			break;
> +		case 'i':
> +			ignore_offset =3D 1;
> +			break;
>  		default:
>  			usage(cmd_inspect_logical_resolve_usage);
>  		}
> @@ -183,13 +191,18 @@ static int cmd_inspect_logical_resolve(int argc, =
char **argv)
>  	loi.size =3D size;
>  	loi.inodes =3D ptr_to_u64(inodes);
> =20
> +	if (ignore_offset) {
> +		loi.flags =3D BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
> +		ioctl_num =3D BTRFS_IOC_LOGICAL_INO_V2;
> +	}
> +
>  	fd =3D btrfs_open_dir(argv[optind + 1], &dirstream, 1);
>  	if (fd < 0) {
>  		ret =3D 12;
>  		goto out;
>  	}
> =20
> -	ret =3D ioctl(fd, BTRFS_IOC_LOGICAL_INO, &loi);
> +	ret =3D ioctl(fd, ioctl_num, &loi);
>  	if (ret < 0) {
>  		error("logical ino ioctl: %m");
>  		goto out;
> diff --git a/ioctl.h b/ioctl.h
> index 709e996f..74f30c20 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -491,10 +491,16 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_path_a=
rgs) =3D=3D 56);
>  struct btrfs_ioctl_logical_ino_args {
>  	__u64				logical;	/* in */
>  	__u64				size;		/* in */
> -	__u64				reserved[4];
> +	__u64				reserved[3];	/* must be 0 for now */
> +	__u64				flags;		/* in, v2 only */
>  	/* struct btrfs_data_container	*inodes;	out   */
>  	__u64				inodes;
>  };
> +/*
> + * Return every ref to the extent, not just those containing logical b=
lock.
> + * Requires logical =3D=3D extent bytenr.
> + */
> +#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
> =20
>  enum btrfs_dev_stat_values {
>  	/* disk I/O failure stats */
> @@ -828,6 +834,8 @@ static inline char *btrfs_err_str(enum btrfs_err_co=
de err_code)
>                                    struct btrfs_ioctl_feature_flags[3])=

>  #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
>  				   struct btrfs_ioctl_vol_args_v2)
> +#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
> +					struct btrfs_ioctl_logical_ino_args)
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
> index c293f6bf..b4debba7 100644
> --- a/libbtrfsutil/btrfs.h
> +++ b/libbtrfsutil/btrfs.h
> @@ -609,10 +609,16 @@ struct btrfs_ioctl_ino_path_args {
>  struct btrfs_ioctl_logical_ino_args {
>  	__u64				logical;	/* in */
>  	__u64				size;		/* in */
> -	__u64				reserved[4];
> +	__u64				reserved[3];	/* must be 0 for now */
> +	__u64				flags;		/* in, v2 only */
>  	/* struct btrfs_data_container	*inodes;	out   */
>  	__u64				inodes;
>  };
> +/*
> + * Return every ref to the extent, not just those containing logical b=
lock.
> + * Requires logical =3D=3D extent bytenr.
> + */
> +#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
> =20
>  enum btrfs_dev_stat_values {
>  	/* disk I/O failure stats */
> @@ -836,5 +842,7 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_feature_flags[3])
>  #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
>  				   struct btrfs_ioctl_vol_args_v2)
> +#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
> +					struct btrfs_ioctl_logical_ino_args)
> =20
>  #endif /* _LINUX_BTRFS_H */
>=20


--42KS8CQ73BRJPM2vNCUxpxn5M6ev0GcqO--

--t8Vu4edW4gDMjOntLhj8IUGhv34FeS5Gn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltQJv8ACgkQwj2R86El
/qhL9QgAo9rrzytI4aPM6Y65lpRgGWPv5/q2cZnzcbqgtkR4M45bcePUw8ukE0UQ
y8XewkepEo5jlIK++Uj+X0XHp0n8lqeuP6W9RroLZCaJuykAau+LmcDzVVlz3xcQ
MNdg0zuVTVt/WwZvZOx3GieeQ3AEqda8QNGFUWTuJda+4CKhndXoPfTNX2ymLbQ8
0NTUjhF2Jpa4EkjxYh21fPHLnBpmsBx9dsCrQVtUozQYQMJcW3BhJcXgKhRhs7G6
3mwhq8FXTJAiRcjrzSVPFvfJTmUhw/4sptsDxRTIoyeHEnKZyRoueIaCgB6hPOQy
utACqV8+ALhF7rbNvP18PwsseX2rvw==
=Rz+a
-----END PGP SIGNATURE-----

--t8Vu4edW4gDMjOntLhj8IUGhv34FeS5Gn--
