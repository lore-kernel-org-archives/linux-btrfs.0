Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29259 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752393AbeENHSk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 03:18:40 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: check/original: Add checks for
 compressed extent without csum
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180514070310.27197-1-wqu@suse.com>
 <20180514070310.27197-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <fbad04c1-1aa3-b94c-68d0-f550be95f176@cn.fujitsu.com>
Date: Mon, 14 May 2018 15:24:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180514070310.27197-3-wqu@suse.com>
Content-Type: multipart/mixed;
        boundary="------------E85CCE675F1B44082419F9CF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------E85CCE675F1B44082419F9CF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/14/2018 03:03 PM, Qu Wenruo wrote:
> There is one report of compressed extent happens in btrfs, but has no
> csum and then leads to possible decompress error screwing up kernel
> memory.
>=20
> Although it's a kernel bug, and won't cause problem until compressed
> data get corrupted, let's catch such problem in advance.
>=20
> This patch will catch any unexpected compressed extent with:
>=20
> 1) 0 or less than expected csum
>=20
> 2) nodatasum flag set in the inode item
>=20
> This is for original mode.
>=20
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Issue: #134
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>  check/main.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/check/main.c b/check/main.c
> index 891a6d797756..db064b27e84b 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1437,6 +1437,7 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>  	u64 mask =3D root->fs_info->sectorsize - 1;
>  	u32 max_inline_size =3D min_t(u32, mask,
>  				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
> +	u8 compression;
>  	int extent_type;
>  	int ret;
>=20=20
> @@ -1460,9 +1461,9 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>=20=20
>  	fi =3D btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>  	extent_type =3D btrfs_file_extent_type(eb, fi);
> +	compression =3D btrfs_file_extent_compression(eb, fi);
>=20=20
>  	if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> -		u8 compression =3D btrfs_file_extent_compression(eb, fi);
>  		struct btrfs_item *item =3D btrfs_item_nr(slot);
>=20=20
>  		num_bytes =3D btrfs_file_extent_inline_len(eb, slot, fi);
> @@ -1494,6 +1495,8 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>  		     btrfs_file_extent_encryption(eb, fi) ||
>  		     btrfs_file_extent_other_encoding(eb, fi)))
>  			rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> +		if (compression && rec->nodatasum)
> +			rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>  		if (disk_bytenr > 0)
>  			rec->found_size +=3D num_bytes;
>  	} else {
> @@ -1512,7 +1515,8 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>  	if (disk_bytenr > 0 &&
>  	    btrfs_header_owner(eb) !=3D BTRFS_DATA_RELOC_TREE_OBJECTID) {
>  		u64 found;
> -		if (btrfs_file_extent_compression(eb, fi))
> +
> +		if (compression)
>  			num_bytes =3D btrfs_file_extent_disk_num_bytes(eb, fi);
>  		else
>  			disk_bytenr +=3D extent_offset;
> @@ -1526,6 +1530,8 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>  				rec->found_csum_item =3D 1;
>  			if (found < num_bytes)
>  				rec->some_csum_missing =3D 1;
> +			if (compression && found < num_bytes)
> +				rec->errors |=3D I_ERR_SOME_CSUM_MISSING;
>  		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
>  			if (found > 0) {
>  				ret =3D check_prealloc_extent_written(root->fs_info,
>=20



--------------E85CCE675F1B44082419F9CF
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

--------------E85CCE675F1B44082419F9CF--
