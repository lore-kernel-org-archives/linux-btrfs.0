Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:28331 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753513AbeEWBgG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 21:36:06 -0400
Subject: Re: [PATCH] Btrfs: fix memory and mount leak in
 btrfs_ioctl_rm_dev_v2()
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>, David Sterba <dsterba@suse.com>
References: <78fcd50378fec419da9f60086ce8331e12c7563d.1527028634.git.osandov@fb.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <af9b46d6-42c5-11c3-be8a-94c8dd2dd21e@cn.fujitsu.com>
Date: Wed, 23 May 2018 09:42:07 +0800
MIME-Version: 1.0
In-Reply-To: <78fcd50378fec419da9f60086ce8331e12c7563d.1527028634.git.osandov@fb.com>
Content-Type: multipart/mixed;
        boundary="------------DCE1A8378F03A0DDE5E1B3B9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------DCE1A8378F03A0DDE5E1B3B9
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/23/2018 06:44 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>=20
> If we have invalid flags set, when we error out we must drop our writer
> counter and free the buffer we allocated for the arguments. This bug is
> trivially reproduced with the following program:
>=20
> 	#include <fcntl.h>
> 	#include <stdint.h>
> 	#include <stdio.h>
> 	#include <stdlib.h>
> 	#include <unistd.h>
> 	#include <sys/ioctl.h>
> 	#include <sys/stat.h>
> 	#include <sys/types.h>
> 	#include <linux/btrfs.h>
> 	#include <linux/btrfs_tree.h>
>=20
> 	int main(int argc, char **argv)
> 	{
> 		struct btrfs_ioctl_vol_args_v2 vol_args =3D {
> 			.flags =3D UINT64_MAX,
> 		};
> 		int ret;
> 		int fd;
>=20
> 		if (argc !=3D 2) {
> 			fprintf(stderr, "usage: %s PATH\n", argv[0]);
> 			return EXIT_FAILURE;
> 		}
>=20
> 		fd =3D open(argv[1], O_WRONLY);
> 		if (fd =3D=3D -1) {
> 			perror("open");
> 			return EXIT_FAILURE;
> 		}
>=20
> 		ret =3D ioctl(fd, BTRFS_IOC_RM_DEV_V2, &vol_args);
> 		if (ret =3D=3D -1)
> 			perror("ioctl");
>=20
> 		close(fd);
> 		return EXIT_SUCCESS;
> 	}
>=20
> When unmounting the filesystem, we'll hit the
> WARN_ON(mnt_get_writers(mnt)) in cleanup_mnt().
>=20
> Fixes: 6b526ed70cf1 ("btrfs: introduce device delete by devid")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
> Sigh, I keep stepping in these ioctl bugs just trying to get my swap
> file series ready. This one is based on top of my "Btrfs: fix partly
> checksummed file races" series, although it should apply to for-next
> without it +/- some moved lines.
>=20
>  fs/btrfs/ioctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c2263bf4d6f5..9af3be96099f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3086,8 +3086,10 @@ static long btrfs_ioctl_rm_dev_v2(struct file *fil=
e, void __user *arg)
>  	}
>=20=20
>  	/* Check for compatibility reject unknown flags */
> -	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED)
> -		return -EOPNOTSUPP;
> +	if (vol_args->flags & ~BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out;
> +	}
>=20=20
>  	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
>  		ret =3D BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>=20



--------------DCE1A8378F03A0DDE5E1B3B9
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----=0A=
=0A=
mQENBFrxafoBCADL54g5EnHtuYig32iQtOWgPqZlnBDgdSD+fMxnpMr6zZ7VNT9l=0A=
Pv7BNy4lUHkWff1TbLuZQIoxYKEbmkajwg1rEjBfQ+6RBQWGzsjfprPdEC6kf6Ch=0A=
sVKrfAfJArEgEvkMOCWZE1T5wNl/mNhlWfOYWadfLTIsQCKD5D1PhD9ZgKMwulGn=0A=
OhQfeRuu/X+7zijjrpT1Nvq/Qiya/ANCq7nCu2ZTXDgQR6GSe2qgn0oVC44HKTRl=0A=
PK+47CQ8LFnKeBuTygdOpfAWUi28SCMqwkfZhGtfQQU446HJPNz/bCNRok9l9dZi=0A=
3EEyxMamd/tVmtsOBvtUrYIIIxNAOB87h1+PABEBAAG0IFN1IFl1ZSA8c3V5LmZu=0A=
c3RAY24uZnVqaXRzdS5jb20+iQFUBBMBCAA+FiEE12oP3cNSLnn02mf3AOFqSFGv=0A=
ypwFAlrxafoCGwMFCQHhM4AFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQAOFq=0A=
SFGvypwZaAf8D8gcRk4atpfgKd1nB0UuDcJNPLpzrGxQz3u2UBeNjxGUXsVsQMsy=0A=
Ln+xd/5pbC7tk5D8/+XIZGtLc3Nb0G9D6kdSHjvlpRMo3GtnDJL/kp4TPBlcXM9V=0A=
xzPmbBECdo8Th5+P66H3MNl3S0B48kDEcj5i7M0dZDOeQjKxzt8j++bwEdXVgBvM=0A=
O5W8Qnd5CxbXnjme8/qyJtup1hYAKpf8Yi9bldPM0ri+uWbLtSx8/EvCxsFFMiM+=0A=
zk1fzPqsu+lhI+lBAKR9qvH6mVCictFxA6TM7BH+lcQezHunEJDSO1obLXpjQTwh=0A=
UpU7USyzmE0hx/O2unA6imv1O1fuafCsGLkBDQRa8Wn6AQgAtxCl1ghY/W/lP66b=0A=
27rYgz8otwQ5TaLLwb83qwVOv7AOiMu16ikNcG2Fn0ePj3kv4/iYcsAIq6UHka25=0A=
4UXMdwn8j8lN7dYuuJpFBjW45mHMH9gTNspp456ftqlvgTqJtPmRmcN62IGaI5OD=0A=
/L36v7nMY5iBPecK8hIZd7BFJcBV1jntzy3XTGrvyQXx7LxqIj9uKRj1vTYTLK+9=0A=
uaQFna1+SR7XKtkUg89YObQGXDD3D8qohk9SSmpQGkPPOdC1456Vpn/5FH057W0I=0A=
UC/udC6AKsbYrlEqYihMY0/5FkpTusPOxw+LHpAwJppQ95JNsjtq22HgyFMpGFCW=0A=
bSMMEwARAQABiQE8BBgBCAAmFiEE12oP3cNSLnn02mf3AOFqSFGvypwFAlrxafoC=0A=
GwwFCQHhM4AACgkQAOFqSFGvypwMlQf+NhF3GTn+VE7MgOBJdnYkcp8QjxAJXRVp=0A=
T9QHcJj37BiNJbCxKIac35rFsPe8BaFDM+W6aqe5+zayVd2Zx771imCbimCqgtTB=0A=
/ScbarN/fgTP1sodDBuVLJmJWPIisYrX4jQx26OfbnZHNYKEHumh5+YghSnNGd6U=0A=
zS/F+k2PEQZ6rbGQeyHYNDegzq7Nieg9aNoV7qvPAwbG/9KrXBQdh+X0w1Fs/Gye=0A=
wi1vrOIWtTE2ORTJZb8y76wy6M6oOWv2PnQ0TLHM+8wTTX+dgU/IjQNO6ikqLqI8=0A=
PN8qtLmiy6GAQETDZO//XSxcpHQJVIU/+jHKZYuHJ1IMCcaC9vvjzg=3D=3D=0A=
=3DDxgD=0A=
-----END PGP PUBLIC KEY BLOCK-----=0A=

--------------DCE1A8378F03A0DDE5E1B3B9--
