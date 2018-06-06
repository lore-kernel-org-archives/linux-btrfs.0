Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25904 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932185AbeFFAdU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2018 20:33:20 -0400
Subject: Re: [PATCH] btrfs-progs: check: Fix wrong error message in case of
 corrupted extent
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1528198750-27840-1-git-send-email-nborisov@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <665a3869-34ec-181b-3c0e-898547e5b34a@cn.fujitsu.com>
Date: Wed, 6 Jun 2018 08:39:24 +0800
MIME-Version: 1.0
In-Reply-To: <1528198750-27840-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/mixed;
        boundary="------------2513059E322EDA16D2FD938C"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------2513059E322EDA16D2FD938C
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 06/05/2018 07:39 PM, Nikolay Borisov wrote:
> When btrfs check detects a freespace tree extent which ends beyond the
> blockgroup containing it a misleading error messages is printed. For
> example if we have the following extent in the freespace tree:
>=20
>     item 5 key (30408704 FREE_SPACE_INFO 1073741824) itemoff 16259 itemsi=
ze 8
>             free space info extent count 3 flags 0
>     item 6 key (30425088 FREE_SPACE_EXTENT 49152) itemoff 16259 itemsize 0
>             free space extent
>     item 7 key (30507008 FREE_SPACE_EXTENT 65536) itemoff 16259 itemsize 0
>             free space extent
>     item 8 key (30654464 FREE_SPACE_EXTENT 14524648038063310901) itemoff =
16259 itemsize 0
>=20
> Clearly the last extent is corrupted so we should print something
> along the lines of:
>=20
> free space extent ends at 14524648038063310901, beyond end of block group=
 30408704-1104150528
>=20
> Instead currently this is printed:
>=20
> free space extent ends at 30654464, beyond end of block group 30408704-11=
04150528
>=20
> So instead of printing the actual erroneous end, we print the beginning
> of the extent. Fix this by printing the actual corrupted end.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>  free-space-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/free-space-tree.c b/free-space-tree.c
> index 69a4eca8a74f..747f8778e610 100644
> --- a/free-space-tree.c
> +++ b/free-space-tree.c
> @@ -276,7 +276,7 @@ static int load_free_space_extents(struct btrfs_fs_in=
fo *fs_info,
>  		if (key.objectid + key.offset > end) {
>  			fprintf(stderr,
>  	"free space extent ends at %llu, beyond end of block group %llu-%llu\n",
> -				key.objectid, start, end);
> +				key.objectid+key.offset, start, end);
>  			(*errors)++;
>  			break;
>  		}
>=20



--------------2513059E322EDA16D2FD938C
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

--------------2513059E322EDA16D2FD938C--
