Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26066 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755333AbeE2Ixr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 04:53:47 -0400
Subject: Re: [PATCH] btrfs-progs: check: Also compare data between mirrors to
 detect corruption for NODATASUM extents
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180529074527.7333-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <05f65234-e71b-c574-34e6-9e198904a310@cn.fujitsu.com>
Date: Tue, 29 May 2018 16:59:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180529074527.7333-1-wqu@suse.com>
Content-Type: multipart/mixed;
        boundary="------------A61FE4C52AF9C71BCDD1747B"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------A61FE4C52AF9C71BCDD1747B
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/29/2018 03:45 PM, Qu Wenruo wrote:
> As the lzo corruption reported by James Harvey, for data extents without
> checksum, neither btrfs check nor kernel scrub could detect anything
> wrong.
>=20
> However if our profile supports duplication, we still have a chance to
> detect such corruption, as in that case the mirrors will mismatch with
> each other.
>=20
> So enhance --check-data-csum option to do such check, and this could
> help us to detect such corruption in an autonomous test case.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good to me.
I'd rather like naming style without "for" like
check_bg_mirrors_nodatasum though.

Anyway,
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  Documentation/btrfs-check.asciidoc |   2 +
>  check/main.c                       | 161 ++++++++++++++++++++++++++++-
>  2 files changed, 162 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-che=
ck.asciidoc
> index b963eae5cdce..34173acbc523 100644
> --- a/Documentation/btrfs-check.asciidoc
> +++ b/Documentation/btrfs-check.asciidoc
> @@ -51,6 +51,8 @@ verify checksums of data blocks
>  +
>  This expects that the filesystem is otherwise OK, and is basically and o=
ffline
>  'scrub' but does not repair data from spare copies.
> +Also, for data extent without checksum (NODATASUM), it will compare data
> +between mirrors to detect any possible mismatch.
>=20=20
>  --chunk-root <bytenr>::
>  use the given offset 'bytenr' for the chunk tree root
> diff --git a/check/main.c b/check/main.c
> index 68da994f7ae0..2ea965fc2fed 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -5602,6 +5602,148 @@ out:
>  	return ret;
>  }
>=20=20
> +/*
> + * Return 0 if both mirrors match
> + * Return >0 if mirrors mismatch
> + * Return <0 for fatal error
> + */
> +static int compare_extent_mirrors(struct btrfs_fs_info *fs_info, u64 byt=
enr,
> +				  u64 len)
> +{
> +	u64 cur;
> +	const int buf_size =3D SZ_128K;
> +	char buf1[buf_size];
> +	char buf2[buf_size];
> +	int ret;
> +
> +	if (btrfs_num_copies(fs_info, bytenr, len) !=3D 2)
> +		return -EINVAL;
> +
> +	for (cur =3D bytenr; cur < bytenr + len; cur +=3D buf_size) {
> +		u64 cur_len =3D min_t(u64, buf_size, bytenr + len - cur);
> +
> +		ret =3D read_data_from_disk(fs_info, buf1, cur, cur_len, 1);
> +		if (ret < 0)
> +			return ret;
> +		ret =3D read_data_from_disk(fs_info, buf2, cur, cur_len, 2);
> +		if (ret < 0)
> +			return ret;
> +		if (memcmp(buf1, buf2, cur_len))
> +			return 1;
> +	}
> +	return 0;
> +}
> +
> +static int check_bg_mirrors_for_nodatasum(struct btrfs_fs_info *fs_info,
> +					  struct btrfs_block_group_cache *bg)
> +{
> +	struct btrfs_root *extent_root =3D fs_info->extent_root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	int errors =3D 0;
> +	int ret;
> +
> +	key.objectid =3D bg->key.objectid;
> +	key.type =3D 0;
> +	key.offset =3D 0;
> +	btrfs_init_path(&path);
> +
> +	ret =3D btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +	if (ret =3D=3D 0) {
> +		/* Such key should not exist, something goes wrong */
> +		ret =3D -EUCLEAN;
> +		goto error;
> +	}
> +
> +	while (1) {
> +		u64 csum_found;
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.type !=3D BTRFS_EXTENT_ITEM_KEY)
> +			goto next;
> +		ret =3D count_csum_range(fs_info, key.objectid, key.offset,
> +				       &csum_found);
> +		if (ret < 0)
> +			goto error;
> +		/*
> +		 * Here we don't care if csum is covering the whole extent,
> +		 * as if it's true it's half csumed, file extent check will
> +		 * report, we only care if it's without csum at all
> +		 */
> +		if (csum_found)
> +			goto next;
> +		ret =3D compare_extent_mirrors(fs_info, key.objectid, key.offset);
> +		if (ret < 0) {
> +			error(
> +	"failed to compare data extent mirrors for bytenr %llu len %llu: %s",
> +			      key.objectid, key.offset, strerror(-ret));
> +			goto error;
> +		}
> +		if (ret > 0) {
> +			error(
> +	"found data mismatch for NODATASUM extent, at bytenr %llu len %llu",
> +			      key.objectid, key.offset);
> +			errors++;
> +		}
> +next:
> +		ret =3D btrfs_next_extent_item(extent_root, &path,
> +					bg->key.objectid + bg->key.offset - 1);
> +		if (ret < 0)
> +			goto error;
> +		if (ret > 0)
> +			break;
> +	}
> +	btrfs_release_path(&path);
> +	return errors;
> +
> +error:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +/*
> + * Check for any data extent without csum, and then compare its data with
> + * any existing mirror to detect any possible corruption.
> + *
> + * Return 0 for all good.
> + * Return <0 for fatal error. (Like failed to read tree blocks)
> + * Return >0 for how many mismatched extents found.
> + */
> +static int check_mirrors_for_nodatasum(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_block_group_cache *bg;
> +	int ret;
> +	int errors =3D 0;
> +
> +	bg =3D btrfs_lookup_first_block_group(fs_info, 0);
> +	if (!bg)
> +		return -EUCLEAN;
> +
> +	while (bg) {
> +		/* Here we only care about data block groups */
> +		if (!(bg->flags & BTRFS_BLOCK_GROUP_DATA))
> +			goto next;
> +		/*
> +		 * And it must be mirrored profile
> +		 * NOTE: For RAID5/6 it's not yet supported yet.
> +		 */
> +		if (!((BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP |
> +		       BTRFS_BLOCK_GROUP_RAID10) & bg->flags))
> +			goto next;
> +		ret =3D check_bg_mirrors_for_nodatasum(fs_info, bg);
> +		/* Fatal error, exist right now */
> +		if (ret < 0)
> +			return ret;
> +		errors +=3D ret;
> +next:
> +		bg =3D btrfs_lookup_first_block_group(fs_info,
> +					bg->key.objectid + bg->key.offset);
> +	}
> +	return errors;
> +}
> +
>  static int check_csums(struct btrfs_root *root)
>  {
>  	struct btrfs_path path;
> @@ -5697,8 +5839,25 @@ skip_csum_check:
>  		num_bytes +=3D data_len;
>  		path.slots[0]++;
>  	}
> -
>  	btrfs_release_path(&path);
> +
> +	/*
> +	 * Do extra check on mirror consistence for NODATASUM case if
> +	 * --check-datasum is specified.
> +	 * For NODATASUM case, we can still check if both copies match.
> +	 */
> +	if (verify_csum) {
> +		ret =3D check_mirrors_for_nodatasum(root->fs_info);
> +		if (ret < 0) {
> +			error(
> +		"failed to check consistence for data without checksum: %s",
> +			      strerror(-ret));
> +			errors++;
> +		}
> +		if (ret > 0)
> +			errors +=3D ret;
> +	}
> +
>  	return errors;
>  }
>=20=20
>=20



--------------A61FE4C52AF9C71BCDD1747B
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

--------------A61FE4C52AF9C71BCDD1747B--
