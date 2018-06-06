Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932122AbeFFIC2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 04:02:28 -0400
Subject: Re: [PATCH 3/6] btrfs-progs: check/original: Detect and repair wrong
 inline ram_bytes
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180606072717.28854-1-wqu@suse.com>
 <20180606072717.28854-4-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <95764c6f-04c9-59e1-85cb-e654306466d5@cn.fujitsu.com>
Date: Wed, 6 Jun 2018 16:08:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180606072717.28854-4-wqu@suse.com>
Content-Type: multipart/mixed;
        boundary="------------1E66D46903CA8C68585CDF5D"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------1E66D46903CA8C68585CDF5D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 06/06/2018 03:27 PM, Qu Wenruo wrote:
> It looks like that around 2014, btrfs kernel has a regression that would
> cause offset-by-one ram_bytes for inline extent.
>=20
> Add the ability to repair it in original mode.
>=20
> Reported-by: Steve Leung <sjleung@shaw.ca>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/main.c          | 44 +++++++++++++++++++++++++++++++++++++++++--
>  check/mode-original.h |  1 +
>  2 files changed, 43 insertions(+), 2 deletions(-)
>=20
> diff --git a/check/main.c b/check/main.c
> index 52ef181add61..1374d8856d72 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1483,6 +1483,9 @@ static int process_file_extent(struct btrfs_root *r=
oot,
>  		} else {
>  			if (num_bytes > max_inline_size)
>  				rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LARGE;
> +			if (btrfs_file_extent_inline_item_len(eb, item) !=3D
> +			    num_bytes)
> +				rec->errors |=3D I_ERR_INLINE_RAM_BYTES_WRONG;
>  		}
>  		rec->found_size +=3D num_bytes;
>  		num_bytes =3D (num_bytes + mask) & ~mask;
> @@ -2534,6 +2537,40 @@ out:
>  	return ret;
>  }
>=20=20
> +static int repair_inline_ram_bytes(struct btrfs_trans_handle *trans,
> +				   struct btrfs_root *root,
> +				   struct btrfs_path *path,
> +				   struct inode_record *rec)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_item *i;
> +	u64 on_disk_item_len;
> +	int ret;
> +
> +	key.objectid =3D rec->ino;
> +	key.offset =3D 0;
> +	key.type =3D BTRFS_EXTENT_DATA_KEY;
> +
> +	ret =3D btrfs_search_slot(trans, root, &key, path, 0, 1);
> +	if (ret > 0)
> +		ret =3D -ENOENT;
> +	if (ret < 0)
> +		goto out;
> +
> +	i =3D btrfs_item_nr(path->slots[0]);
> +	on_disk_item_len =3D btrfs_file_extent_inline_item_len(path->nodes[0], =
i);
> +	fi =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			    struct btrfs_file_extent_item);
> +	btrfs_set_file_extent_ram_bytes(path->nodes[0], fi, on_disk_item_len);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +	printf("Successfully repaired inline ram_bytes for root %llu ino %llu\n=
",
> +		root->objectid, rec->ino);

Miss a line "rec->errors &=3D ~I_ERR_INLINE_RAM_BYTES_WRONG;"?.
Although the new test case passes, the fake appearance is due to
existed bug about returned codes of check_ino_rec().

And refer to outputs of existed code, no need for the word
'Successfully'.
> +out:
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
>  static int try_repair_inode(struct btrfs_root *root, struct inode_record=
 *rec)
>  {
>  	struct btrfs_trans_handle *trans;
> @@ -2545,8 +2582,9 @@ static int try_repair_inode(struct btrfs_root *root=
, struct inode_record *rec)
>  			     I_ERR_LINK_COUNT_WRONG |
>  			     I_ERR_NO_INODE_ITEM |
>  			     I_ERR_FILE_EXTENT_ORPHAN |
> -			     I_ERR_FILE_EXTENT_DISCOUNT|
> -			     I_ERR_FILE_NBYTES_WRONG)))
> +			     I_ERR_FILE_EXTENT_DISCOUNT |
> +			     I_ERR_FILE_NBYTES_WRONG |
> +			     I_ERR_INLINE_RAM_BYTES_WRONG)))

It's better if you can add otehr infomation into print_inode_error().

Others look fine to me.

Thanks,
Su
>  		return rec->errors;
>=20=20
>  	/*
> @@ -2575,6 +2613,8 @@ static int try_repair_inode(struct btrfs_root *root=
, struct inode_record *rec)
>  		ret =3D repair_inode_nlinks(trans, root, &path, rec);
>  	if (!ret && rec->errors & I_ERR_FILE_NBYTES_WRONG)
>  		ret =3D repair_inode_nbytes(trans, root, &path, rec);
> +	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
> +		ret =3D repair_inline_ram_bytes(trans, root, &path, rec);
>  	btrfs_commit_transaction(trans, root);
>  	btrfs_release_path(&path);
>  	return ret;
> diff --git a/check/mode-original.h b/check/mode-original.h
> index 13cfa5b9e1b3..ec2842e0b3be 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -187,6 +187,7 @@ struct file_extent_hole {
>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>  #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
> +#define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
>=20=20
>  struct inode_record {
>  	struct list_head backrefs;
>=20



--------------1E66D46903CA8C68585CDF5D
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

--------------1E66D46903CA8C68585CDF5D--
