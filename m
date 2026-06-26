Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF21E3BFE52
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 22:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782512825; cv=none; b=ls7DSmHKS1P7cTFPhBUyZR+YsLqSsEUWO2P09WvYBRnMdt2FMJVSYn0zFQcNrPj34jwgfLjx0Q3F45B2gYJ3p6UWxoeC8h3DH98nfkhwuczwh1f7MNxIlISabivZSDLE2yg2wMDSXeSHUsiieXA5SzqWdHPv4qmEs1FLkaiVSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782512825; c=relaxed/simple;
	bh=PY19yWdEgptk1cGYkJRLODDddzuAs9McEZgsd8ti154=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IWhu4ncy1WNtquH4CqReF9UhNvXnj+cWvl8pvTHN4nhkriLPwlx5rBeCvRtNeQyABBtDjwoap7fffoK87wdyM7WAfbDwJylMgmoAUzV4NXZT4sfpaxzsq+87sVHyqdYeLpQpD1sA2kYl3ZhoPX5UkGDT/pVTVlJPtGfP53hdasI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Z7qz1cms; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Z7qz1cms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782512820; x=1783117620; i=quwenruo.btrfs@gmx.com;
	bh=seTjAapK22//FxGj+kcDkRjwk+7HB27cqmznPk3azGk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Z7qz1cmsmj4VWfqC+Iz95dQ9/Xrwr3u9QZnwLaB9Q2hu6IoQcaJe9lPYH949ez/E
	 Vh6nWbj1VD3RJ1q0GDFTuDb63eMcRAULQAv0pCb72R0StjRLp8BWZc6s7CMXgf24z
	 kw65oFDDkFW3W6tWabC6YixH8WZyRuEdny55hyfMlC60bTaE+zBZhpOtbMdw1c10q
	 2aVl2ia6j8S91Cq2u4nLExPjlOXdohuLe12yIqLz6TBYDUPkWwG+BoaiKk35mUgzU
	 UnLTz0ryWWGwbF7ILjvI/kTNyAMrkM8AheCWKvfWxI7soBfQ7F/LWm0/0IkNEN4/k
	 tuqiGxlcZXjmOse57g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MD9XF-1wUgQH0bMv-00ADgN; Sat, 27
 Jun 2026 00:27:00 +0200
Message-ID: <09eca73c-1f50-46b2-a307-76eef0408159@gmx.com>
Date: Sat, 27 Jun 2026 07:56:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
To: Alexey Charkov <alchark@flipper.net>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, u-boot@lists.denx.de
Cc: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>,
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>,
 Yao Zi <me@ziyao.cc>
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
 <20260626-btrfs-readdir-v2-1-7dd43f72d1b4@flipper.net>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260626-btrfs-readdir-v2-1-7dd43f72d1b4@flipper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:K0cXmjB643PnBCjXiz27RPlTNqfTXszpNyGuFITKi3F4524dWNE
 BADE4qxzcfWHLQEUwszgFRsl0BCFEj8l63TRXyKwwXPKM87XElgFaGQdtxoSTi2+FBRM3KO
 LcSb9VaCGzq2b5TOSHVLV2eTtpJGVgcNeXlmYd154yLqA+RNDrv9wo5rcOY+OYykDlWycbP
 MWoLY6qmxkjmZ0cHqf6zA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ktf+8jjcDzs=;bQZQLQ+l9EQ/6G7iUMpVbn+YEha
 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
 k3s+Yg==



=E5=9C=A8 2026/6/27 00:48, Alexey Charkov =E5=86=99=E9=81=93:
> Add support for generic directory iteration with opendir(), readdir() an=
d
> closedir() in the btrfs filesystem driver.
>=20
> Signed-off-by: Alexey Charkov <alchark@flipper.net>
> ---
>   fs/btrfs/btrfs.c    | 98 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>   fs/btrfs/ctree.h    |  2 ++
>   fs/btrfs/dir-item.c | 73 +++++++++++++++++++++++++++++++++++++++
>   fs/fs.c             |  4 ++-
>   include/btrfs.h     |  5 +++
>   5 files changed, 181 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
> index f3087f690fa4..6f034861da90 100644
> --- a/fs/btrfs/btrfs.c
> +++ b/fs/btrfs/btrfs.c
> @@ -8,7 +8,9 @@
>   #include <config.h>
>   #include <malloc.h>
>   #include <u-boot/uuid.h>
> +#include <linux/kernel.h>
>   #include <linux/time.h>
> +#include <fs.h>
>   #include "btrfs.h"
>   #include "crypto/hash.h"
>   #include "disk-io.h"
> @@ -159,6 +161,102 @@ int btrfs_ls(const char *path)
>   	return 0;
>   }
>  =20
> +/*
> + * The fs layer closes and re-probes btrfs between readdir() calls (see
> + * fs_readdir() in fs/fs.c), freeing and reallocating fs_info, so root =
cannot
> + * be stored directly. The subvolume id and inode number are stable tho=
ugh, so
> + * re-resolve the root from the current fs_info by subvolume id, which =
avoids
> + * a full path walk and is much faster.
> + */
> +struct btrfs_dir_stream {
> +	struct fs_dir_stream parent;
> +	struct fs_dirent dirent;
> +	u64 subvolid;
> +	u64 ino;
> +	u64 offset;
> +};
> +
> +int btrfs_opendir(const char *dirname, struct fs_dir_stream **dirsp)
> +{
> +	struct btrfs_fs_info *fs_info =3D current_fs_info;
> +	struct btrfs_dir_stream *dirs;
> +	struct btrfs_root *root;
> +	u64 ino;
> +	u8 type;
> +	int ret;
> +
> +	*dirsp =3D NULL;
> +	ASSERT(fs_info);
> +
> +	ret =3D btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
> +				dirname, &root, &ino, &type, 40);
> +	if (ret < 0)
> +		return ret;
> +	if (type !=3D BTRFS_FT_DIR)
> +		return -ENOTDIR;
> +
> +	dirs =3D calloc(1, sizeof(*dirs));
> +	if (!dirs)
> +		return -ENOMEM;
> +	dirs->subvolid =3D root->root_key.objectid;
> +	dirs->ino =3D ino;
> +
> +	*dirsp =3D &dirs->parent;
> +	return 0;
> +}
> +
> +static unsigned int btrfs_dirent_type_to_fs_type(u8 dirent_type)
> +{
> +	switch (dirent_type) {
> +	case BTRFS_FT_DIR:
> +		return FS_DT_DIR;
> +	case BTRFS_FT_SYMLINK:
> +		return FS_DT_LNK;
> +	default:
> +		return FS_DT_REG;
> +	}
> +}
> +
> +int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **den=
tp)
> +{
> +	struct btrfs_dir_stream *dirs =3D container_of(fs_dirs, struct btrfs_d=
ir_stream, parent);
> +	struct btrfs_fs_info *fs_info =3D current_fs_info;
> +	struct fs_dirent *dent =3D &dirs->dirent;
> +	struct btrfs_root *root;
> +	struct btrfs_key key;
> +	u8 type;
> +	int ret;
> +
> +	*dentp =3D NULL;
> +	ASSERT(fs_info);
> +
> +	key.objectid =3D dirs->subvolid;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D (u64)-1;
> +	root =3D btrfs_read_fs_root(fs_info, &key);

You can save the root pointer into btrfs_dir_stream, so we can avoid=20
subvolume root lookup for each dentry.

You do not need to bother the lifespan of subvolume roots either, they=20
are properly released during the close of the fs.

Otherwise looks good to me, except an unrelated question just lines below.

> +	if (IS_ERR(root))
> +		return PTR_ERR(root);
> +
> +	memset(dent, 0, sizeof(*dent));
> +	ret =3D btrfs_next_dir_entry(root, dirs->ino, &dirs->offset, dent->nam=
e,
> +				   sizeof(dent->name), &type);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		return -ENOENT;

I'm not sure what is the proper/preferred/sane handling of end of director=
y.

Ext4/fat returns -ENOENT, squashfs returned -1, erofs return 1, exfat=20
returns 0 but without populating @dentp.

Personally I found the exfat behavior more sane, but considering the=20
caller fs_ls_generic() doesn't really bother the return value but only=20
cares if @dent is populated, it should be fine either way.

But still, returning -ENOENT will populate errno, which may be confusing=
=20
for debugging.

Anyway it's an unrelated nitpick.

Thanks,
Qu

> +
> +	dent->type =3D btrfs_dirent_type_to_fs_type(type);
> +	*dentp =3D dent;
> +	return 0;
> +}
> +
> +void btrfs_closedir(struct fs_dir_stream *fs_dirs)
> +{
> +	struct btrfs_dir_stream *dirs =3D container_of(fs_dirs, struct btrfs_d=
ir_stream, parent);
> +
> +	free(dirs);
> +}
> +
>   int btrfs_exists(const char *file)
>   {
>   	struct btrfs_fs_info *fs_info =3D current_fs_info;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index b7be09d5df83..7de35aa7efd5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1225,6 +1225,8 @@ typedef int (*btrfs_iter_dir_callback_t)(struct bt=
rfs_root *root,
>   					 struct btrfs_dir_item *di);
>   int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
>   		   btrfs_iter_dir_callback_t callback);
> +int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset,
> +			 char *namebuf, int namebuf_len, u8 *ftype);
>   /* inode.c */
>   int btrfs_lookup_path(struct btrfs_root *root, u64 ino, const char *fi=
lename,
>   			struct btrfs_root **root_ret, u64 *ino_ret,
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index 5f81d6414f06..b12298e20c41 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -166,3 +166,76 @@ out:
>   	btrfs_release_path(&path);
>   	return ret;
>   }
> +
> +/*
> + * btrfs_next_dir_entry() - read one directory entry at or after a curs=
or
> + *
> + * Streaming counterpart to btrfs_iter_dir() for the fs-layer readdir, =
which
> + * is re-entered once per entry: returns the first real entry whose
> + * BTRFS_DIR_INDEX_KEY offset is >=3D *offset and advances *offset past=
 it.
> + *
> + * @root, @ino:		directory to read
> + * @offset:		in/out cursor; DIR_INDEX offset to resume from
> + * @namebuf:		caller buffer that receives the NUL-terminated name
> + * @namebuf_len:	size of @namebuf in bytes
> + * @ftype:		receives the BTRFS_FT_* type of the entry
> + *
> + * Return: 0 if an entry was returned, 1 when the directory is exhauste=
d,
> + *	   -ve on error.
> + */
> +int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset,
> +			 char *namebuf, int namebuf_len, u8 *ftype)
> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct btrfs_dir_item *di;
> +	int name_len;
> +	int ret;
> +
> +	btrfs_init_path(&path);
> +	key.objectid =3D ino;
> +	key.type =3D BTRFS_DIR_INDEX_KEY;
> +	key.offset =3D *offset;
> +
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[0])) {
> +		ret =3D btrfs_next_leaf(root, &path);
> +		if (ret < 0)
> +			goto out;
> +		if (ret > 0) {		/* end of tree */
> +			ret =3D 1;
> +			goto out;
> +		}
> +	}
> +
> +	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +	if (key.objectid !=3D ino || key.type !=3D BTRFS_DIR_INDEX_KEY) {
> +		ret =3D 1;		/* no more entries for this dir */
> +		goto out;
> +	}
> +
> +	di =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> +			    struct btrfs_dir_item);
> +	if (verify_dir_item(root, path.nodes[0], di)) {
> +		ret =3D -EUCLEAN;
> +		goto out;
> +	}
> +
> +	*offset =3D key.offset + 1;
> +
> +	name_len =3D btrfs_dir_name_len(path.nodes[0], di);
> +	if (name_len > namebuf_len - 1)
> +		name_len =3D namebuf_len - 1;
> +	read_extent_buffer(path.nodes[0], namebuf,
> +			   (unsigned long)(di + 1), name_len);
> +	namebuf[name_len] =3D '\0';
> +	*ftype =3D btrfs_dir_type(path.nodes[0], di);
> +	ret =3D 0;
> +
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> diff --git a/fs/fs.c b/fs/fs.c
> index 8ea50a6c13c4..4694a88f776b 100644
> --- a/fs/fs.c
> +++ b/fs/fs.c
> @@ -326,7 +326,9 @@ static struct fstype_info fstypes[] =3D {
>   		.read =3D btrfs_read,
>   		.write =3D fs_write_unsupported,
>   		.uuid =3D btrfs_uuid,
> -		.opendir =3D fs_opendir_unsupported,
> +		.opendir =3D btrfs_opendir,
> +		.readdir =3D btrfs_readdir,
> +		.closedir =3D btrfs_closedir,
>   		.unlink =3D fs_unlink_unsupported,
>   		.mkdir =3D fs_mkdir_unsupported,
>   		.ln =3D fs_ln_unsupported,
> diff --git a/include/btrfs.h b/include/btrfs.h
> index 2d73add18e09..6fff45a497ee 100644
> --- a/include/btrfs.h
> +++ b/include/btrfs.h
> @@ -10,6 +10,8 @@
>  =20
>   struct blk_desc;
>   struct disk_partition;
> +struct fs_dir_stream;
> +struct fs_dirent;
>  =20
>   int btrfs_probe(struct blk_desc *fs_dev_desc,
>   		struct disk_partition *fs_partition);
> @@ -20,5 +22,8 @@ int btrfs_read(const char *, void *, loff_t, loff_t, l=
off_t *);
>   void btrfs_close(void);
>   int btrfs_uuid(char *);
>   void btrfs_list_subvols(void);
> +int btrfs_opendir(const char *filename, struct fs_dir_stream **dirsp);
> +int btrfs_readdir(struct fs_dir_stream *dirs, struct fs_dirent **dentp)=
;
> +void btrfs_closedir(struct fs_dir_stream *dirs);
>  =20
>   #endif /* __U_BOOT_BTRFS_H__ */
>=20

