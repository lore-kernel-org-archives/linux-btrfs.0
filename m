Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753551AbeENHS2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 03:18:28 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: check/lowmem: Add checks for compressed
 extent without csum
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180514070310.27197-1-wqu@suse.com>
 <20180514070310.27197-2-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <62c89618-4c4e-f07f-1e5b-a29089ed1dba@cn.fujitsu.com>
Date: Mon, 14 May 2018 15:24:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180514070310.27197-2-wqu@suse.com>
Content-Type: multipart/mixed;
        boundary="------------E48559F886B22BEB83D816D6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------E48559F886B22BEB83D816D6
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
> This is for lowmem mode.
>=20
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Issue: #134
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>  check/mode-lowmem.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index dac3201b7d99..8e6d5e8de12a 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1543,6 +1543,24 @@ static int check_file_extent(struct btrfs_root *ro=
ot, struct btrfs_key *fkey,
>  			      csum_found);
>  		}
>  	}
> +	/*
> +	 * Extra check for compressed extents.
> +	 * Btrfs doesn't allow NODATASUM and compressed extent co-exist, thus
> +	 * all compressed extent should have csum.
> +	 */
> +	if (compressed && csum_found < search_len) {
> +		error(
> +"root %llu EXTENT_DATA[%llu %llu] compressed extent must have csum, but =
only %llu bytes has csum, expect %llu",
> +		      root->objectid, fkey->objectid, fkey->offset, csum_found,
> +		      search_len);
> +		err |=3D CSUM_ITEM_MISSING;
> +	}
> +	if (compressed && nodatasum) {
> +		error(
> +"root %llu EXTENT_DATA[%llu %llu] is compressed, but inode flag doesn't =
allow it",
> +		      root->objectid, fkey->objectid, fkey->offset);
> +		err |=3D FILE_EXTENT_ERROR;
> +	}
>=20=20
>  	/* Check EXTENT_DATA hole */
>  	if (!no_holes && *end !=3D fkey->offset) {
>=20



--------------E48559F886B22BEB83D816D6
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

--------------E48559F886B22BEB83D816D6--
