Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18815 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752085AbeEYFJ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 01:09:58 -0400
Subject: Re: [PATCH v4 2/3] btrfs: Refactor btrfs_check_super_valid()
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180525044325.3365-1-wqu@suse.com>
 <20180525044325.3365-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <c66dd544-2818-37f5-0d3b-0e9cd168256c@cn.fujitsu.com>
Date: Fri, 25 May 2018 13:15:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180525044325.3365-3-wqu@suse.com>
Content-Type: multipart/mixed;
        boundary="------------12FAF502636B379A55989DC0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------12FAF502636B379A55989DC0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/25/2018 12:43 PM, Qu Wenruo wrote:
> Refactor btrfs_check_super_valid() by the ways:
>=20
> 1) Rename it to btrfs_validate_mount_super()
>    Now it's more obvious when the function should be called.
>=20
> 2) Extract core check routine into __validate_super()
>    So later write time check can reuse it, and if needed, we could also
>    use __validate_super() to check each super block.
>=20
> 3) Add more comment about btrfs_validate_mount_super()
>    Mostly of what it doesn't check and when it should be called.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>  fs/btrfs/disk-io.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 13c5f90995aa..b981ecc4b6f9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2440,9 +2440,19 @@ static int btrfs_read_roots(struct btrfs_fs_info *=
fs_info)
>  	return ret;
>  }
>=20=20
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
> +/*
> + * Real super block validation check
> + * NOTE: super csum type and incompat features will not be checked here.
> + *
> + * @sb:		super block to check
> + * @mirror_num:	the super block number to check its bytenr:
> + * 		0 means the primary (1st) sb,
> + * 		1 and 2 means 2nd and 3rd backup copy
> + * 		-1 means to skip bytenr check
> + */
> +static int __validate_super(struct btrfs_fs_info *fs_info,
> +			    struct btrfs_super_block *sb, int mirror_num)
>  {
> -	struct btrfs_super_block *sb =3D fs_info->super_copy;
>  	u64 nodesize =3D btrfs_super_nodesize(sb);
>  	u64 sectorsize =3D btrfs_super_sectorsize(sb);
>  	int ret =3D 0;
> @@ -2545,7 +2555,8 @@ static int btrfs_check_super_valid(struct btrfs_fs_=
info *fs_info)
>  		ret =3D -EINVAL;
>  	}
>=20=20
> -	if (btrfs_super_bytenr(sb) !=3D BTRFS_SUPER_INFO_OFFSET) {
> +	if (mirror_num >=3D 0 &&
> +	    btrfs_super_bytenr(sb) !=3D btrfs_sb_offset(mirror_num)) {
>  		btrfs_err(fs_info, "super offset mismatch %llu !=3D %u",
>  			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>  		ret =3D -EINVAL;
> @@ -2589,6 +2600,16 @@ static int btrfs_check_super_valid(struct btrfs_fs=
_info *fs_info)
>  	return ret;
>  }
>=20=20
> +/*
> + * Check the validation of super block at mount time.
> + * Some checks already done by early mount, like csum type and incompat =
flags
> + * will be skipped.
> + */
> +static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
> +{
> +	return __validate_super(fs_info, fs_info->super_copy, 0);
> +}
> +
>  int open_ctree(struct super_block *sb,
>  	       struct btrfs_fs_devices *fs_devices,
>  	       char *options)
> @@ -2814,7 +2835,7 @@ int open_ctree(struct super_block *sb,
>=20=20
>  	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>=20=20
> -	ret =3D btrfs_check_super_valid(fs_info);
> +	ret =3D btrfs_validate_mount_super(fs_info);
>  	if (ret) {
>  		btrfs_err(fs_info, "superblock contains fatal errors");
>  		err =3D -EINVAL;
>=20



--------------12FAF502636B379A55989DC0
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

--------------12FAF502636B379A55989DC0--
