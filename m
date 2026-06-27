Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C995351C27
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2026 06:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782541231; cv=none; b=XIkDR6PZzYWizIYhVCY88Hn/HaNi0TNU9lUHVq/1cp7R4FZW+jUBnRm3sBg/f2xS03gpBuDhqdTgV/34XecauEGUXGowSBnkTpBclY4qaNnd2D720SabCA3EeJpbTPX5sV6QJQlTuNZeAe9xOJnX+NBfUjqOJEwpqPvDm3jy7rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782541231; c=relaxed/simple;
	bh=viUf50CuuMa1By+K84sgOFA+jeIfPomTXtVA+ErphZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boxJOs+cup1n4VM8633+0njJwOsJ4r57Cwjx/y9CYK8+vPA5kIHAXxVjy1p8UF9kM5uHaghCAMzVI3g3hrrnQztFeSgjkz1y0rB8bwelC9Qauxoq2ZvA/a1fV4CI96KtgDOJQZPqM/bEem/vTPacD+1GPBcTcoBMfVj1de1bfIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uVA5mJZ0; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uVA5mJZ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782541226; x=1783146026; i=quwenruo.btrfs@gmx.com;
	bh=Z/XpcxeCadPty/X8btS62sBXnGzUCSNiZKhLf894QIc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uVA5mJZ0duyRi0DzQMmtk8el6jWXnvRTXn5kFjuYFIadWst/XbP9qLyAqfXqU4ET
	 a7OdG3v9OkhKn27dphmd21dTUDvzTBy+T2HUnKY19X9gvD8qcHY1ym8B1BFOGrFmg
	 GX+683h7iNUL9gze19t/jTJuEkXQ2anF+18dB4l6BQvI2dZj9lYlam9urI/MSMs9P
	 vO5p2of1QybLDELTrdI8fzZKbW9f4futK/yBq9p0nmBDKjOJkWaku7qgEuXSdu6UJ
	 yB+vNJ8IniL0HiMdJQYT8fEY04zlOwFlonpYr8EOQVmHVEetDnmqq9dPdt8chS2Jr
	 MqY5Rs0cgqyj4g3ZqQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Ma20q-1wgZwL1BDg-00UvSw; Sat, 27
 Jun 2026 08:20:25 +0200
Message-ID: <190abc3d-e6a6-4f83-aec8-b47a529472cf@gmx.com>
Date: Sat, 27 Jun 2026 15:50:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] fs: btrfs: use fs_ls_generic() and drop custom
 implementation
To: Alexey Charkov <alchark@flipper.net>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, u-boot@lists.denx.de
Cc: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>,
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>,
 Yao Zi <me@ziyao.cc>
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
 <20260626-btrfs-readdir-v2-2-7dd43f72d1b4@flipper.net>
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
In-Reply-To: <20260626-btrfs-readdir-v2-2-7dd43f72d1b4@flipper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BapK/fVR18DszZv/4kaAB2NmzuDt9UvFz66bwBFvQpW6Xe7SzID
 ArB265190zrTNot0r3APur4p0my4YVvX2g8UHJgbu1SnvYFV3TslQ76BRjGAT7U2S8/S1dj
 hRpxcyd/14NfQ6L1Aydrk2laKkv6BZRkpYwNZHpuXTi5PtzI/gi2jb2qfdaxdaPq9OgFJja
 CD5LYRJRgG2sboVVU4JlQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:djbPR73wp/8=;D3YvnvjF4VymHYcg1yjoxk95VVf
 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
 s+EH1NLlXFakwjHKf7KscuQZ/yjv13pt5NnHwXc



=E5=9C=A8 2026/6/27 00:48, Alexey Charkov =E5=86=99=E9=81=93:
> Now that generic callbacks for opendir/readdir/closedir are implemented,
> the custom btrfs_ls() implementation is no longer needed, along with the
> btrfs_iter_dir() callback iterator.
>=20
> Use fs_ls_generic() instead.
>=20
> Signed-off-by: Alexey Charkov <alchark@flipper.net>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/btrfs.c    | 129 --------------------------------------------=
=2D-------
>   fs/btrfs/ctree.h    |   5 --
>   fs/btrfs/dir-item.c |  59 ++----------------------
>   fs/fs.c             |   2 +-
>   include/btrfs.h     |   1 -
>   5 files changed, 4 insertions(+), 192 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
> index 6f034861da90..e663dda12e80 100644
> --- a/fs/btrfs/btrfs.c
> +++ b/fs/btrfs/btrfs.c
> @@ -17,107 +17,6 @@
>  =20
>   struct btrfs_fs_info *current_fs_info;
>  =20
> -static int show_dir(struct btrfs_root *root, struct extent_buffer *eb,
> -		    struct btrfs_dir_item *di)
> -{
> -	struct btrfs_fs_info *fs_info =3D root->fs_info;
> -	struct btrfs_inode_item ii;
> -	struct btrfs_key key;
> -	static const char* dir_item_str[] =3D {
> -		[BTRFS_FT_REG_FILE]	=3D "   ",
> -		[BTRFS_FT_DIR]		=3D "DIR",
> -		[BTRFS_FT_CHRDEV]	=3D "CHR",
> -		[BTRFS_FT_BLKDEV]	=3D "BLK",
> -		[BTRFS_FT_FIFO]		=3D "FIF",
> -		[BTRFS_FT_SOCK]		=3D "SCK",
> -		[BTRFS_FT_SYMLINK]	=3D "SYM",
> -	};
> -	u8 type =3D btrfs_dir_type(eb, di);
> -	char namebuf[BTRFS_NAME_LEN];
> -	char *target =3D NULL;
> -	char filetime[32];
> -	time_t mtime;
> -	int ret =3D 0;
> -
> -	/* skip XATTRs in directory listing */
> -	if (type =3D=3D BTRFS_FT_XATTR)
> -		return 0;
> -
> -	btrfs_dir_item_key_to_cpu(eb, di, &key);
> -
> -	if (key.type =3D=3D BTRFS_ROOT_ITEM_KEY) {
> -		struct btrfs_root *subvol;
> -
> -		/* It's a subvolume, get its mtime from root item */
> -		subvol =3D btrfs_read_fs_root(fs_info, &key);
> -		if (IS_ERR(subvol)) {
> -			ret =3D PTR_ERR(subvol);
> -			error("Can't find root %llu", key.objectid);
> -			return ret;
> -		}
> -		mtime =3D btrfs_stack_timespec_sec(&subvol->root_item.otime);
> -	} else {
> -		struct btrfs_path path;
> -
> -		/* It's regular inode, get its mtime from inode item */
> -		btrfs_init_path(&path);
> -		ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> -		if (ret > 0)
> -			ret =3D -ENOENT;
> -		if (ret < 0) {
> -			error("Can't find inode %llu", key.objectid);
> -			btrfs_release_path(&path);
> -			return ret;
> -		}
> -		read_extent_buffer(path.nodes[0], &ii,
> -			btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
> -			sizeof(ii));
> -		btrfs_release_path(&path);
> -		mtime =3D btrfs_stack_timespec_sec(&ii.mtime);
> -	}
> -	ctime_r(&mtime, filetime);
> -
> -	if (type =3D=3D BTRFS_FT_SYMLINK) {
> -		target =3D malloc(fs_info->sectorsize);
> -		if (!target) {
> -			error("Can't alloc memory for symlink %llu",
> -				key.objectid);
> -			return -ENOMEM;
> -		}
> -		ret =3D btrfs_readlink(root, key.objectid, target);
> -		if (ret < 0) {
> -			error("Failed to read symlink %llu", key.objectid);
> -			goto out;
> -		}
> -		target[ret] =3D '\0';
> -	}
> -
> -	if (type < ARRAY_SIZE(dir_item_str) && dir_item_str[type])
> -		printf("<%s> ", dir_item_str[type]);
> -	else
> -		printf("?%3u? ", type);
> -	if (type =3D=3D BTRFS_FT_CHRDEV || type =3D=3D BTRFS_FT_BLKDEV) {
> -		ASSERT(key.type =3D=3D BTRFS_INODE_ITEM_KEY);
> -		printf("%4llu,%5llu  ", btrfs_stack_inode_rdev(&ii) >> 20,
> -				btrfs_stack_inode_rdev(&ii) & 0xfffff);
> -	} else {
> -		if (key.type =3D=3D BTRFS_INODE_ITEM_KEY)
> -			printf("%10llu  ", btrfs_stack_inode_size(&ii));
> -		else
> -			printf("%10llu  ", 0ULL);
> -	}
> -
> -	read_extent_buffer(eb, namebuf, (unsigned long)(di + 1),
> -			   btrfs_dir_name_len(eb, di));
> -	printf("%24.24s  %.*s", filetime, btrfs_dir_name_len(eb, di), namebuf)=
;
> -	if (type =3D=3D BTRFS_FT_SYMLINK)
> -		printf(" -> %s", target ? target : "?");
> -	printf("\n");
> -out:
> -	free(target);
> -	return ret;
> -}
> -
>   int btrfs_probe(struct blk_desc *fs_dev_desc,
>   		struct disk_partition *fs_partition)
>   {
> @@ -133,34 +32,6 @@ int btrfs_probe(struct blk_desc *fs_dev_desc,
>   	return ret;
>   }
>  =20
> -int btrfs_ls(const char *path)
> -{
> -	struct btrfs_fs_info *fs_info =3D current_fs_info;
> -	struct btrfs_root *root =3D fs_info->fs_root;
> -	u64 ino =3D BTRFS_FIRST_FREE_OBJECTID;
> -	u8 type;
> -	int ret;
> -
> -	ASSERT(fs_info);
> -	ret =3D btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
> -				path, &root, &ino, &type, 40);
> -	if (ret < 0) {
> -		printf("Cannot lookup path %s\n", path);
> -		return ret;
> -	}
> -
> -	if (type !=3D BTRFS_FT_DIR) {
> -		error("Not a directory: %s", path);
> -		return -ENOENT;
> -	}
> -	ret =3D btrfs_iter_dir(root, ino, show_dir);
> -	if (ret < 0) {
> -		error("An error occurred while listing directory %s", path);
> -		return ret;
> -	}
> -	return 0;
> -}
> -
>   /*
>    * The fs layer closes and re-probes btrfs between readdir() calls (se=
e
>    * fs_readdir() in fs/fs.c), freeing and reallocating fs_info, so root=
 cannot
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7de35aa7efd5..3fa9a8c9c020 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1220,11 +1220,6 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(stru=
ct btrfs_trans_handle *trans,
>   					     struct btrfs_path *path, u64 dir,
>   					     const char *name, int name_len,
>   					     int mod);
> -typedef int (*btrfs_iter_dir_callback_t)(struct btrfs_root *root,
> -					 struct extent_buffer *eb,
> -					 struct btrfs_dir_item *di);
> -int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
> -		   btrfs_iter_dir_callback_t callback);
>   int btrfs_next_dir_entry(struct btrfs_root *root, u64 ino, u64 *offset=
,
>   			 char *namebuf, int namebuf_len, u8 *ftype);
>   /* inode.c */
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index b12298e20c41..c7b87d60d986 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -114,65 +114,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struc=
t btrfs_trans_handle *trans,
>   	return btrfs_match_dir_item_name(root, path, name, name_len);
>   }
>  =20
> -int btrfs_iter_dir(struct btrfs_root *root, u64 ino,
> -		   btrfs_iter_dir_callback_t callback)
> -{
> -	struct btrfs_path path;
> -	struct btrfs_key key;
> -	int ret;
> -
> -	btrfs_init_path(&path);
> -	key.objectid =3D ino;
> -	key.type =3D BTRFS_DIR_INDEX_KEY;
> -	key.offset =3D 0;
> -
> -	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> -	if (ret < 0)
> -		return ret;
> -	/* Should not happen */
> -	if (ret =3D=3D 0) {
> -		ret =3D -EUCLEAN;
> -		goto out;
> -	}
> -	if (path.slots[0] >=3D btrfs_header_nritems(path.nodes[0])) {
> -		ret =3D btrfs_next_leaf(root, &path);
> -		if (ret < 0)
> -			goto out;
> -		if (ret > 0) {
> -			ret =3D 0;
> -			goto out;
> -		}
> -	}
> -	do {
> -		struct btrfs_dir_item *di;
> -
> -		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> -		if (key.objectid !=3D ino || key.type !=3D BTRFS_DIR_INDEX_KEY)
> -			break;
> -		di =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
> -				    struct btrfs_dir_item);
> -		if (verify_dir_item(root, path.nodes[0], di)) {
> -			ret =3D -EUCLEAN;
> -			goto out;
> -		}
> -		ret =3D callback(root, path.nodes[0], di);
> -		if (ret < 0)
> -			goto out;
> -	} while (!(ret =3D btrfs_next_item(root, &path)));
> -
> -	if (ret > 0)
> -		ret =3D 0;
> -out:
> -	btrfs_release_path(&path);
> -	return ret;
> -}
> -
>   /*
>    * btrfs_next_dir_entry() - read one directory entry at or after a cur=
sor
>    *
> - * Streaming counterpart to btrfs_iter_dir() for the fs-layer readdir, =
which
> - * is re-entered once per entry: returns the first real entry whose
> - * BTRFS_DIR_INDEX_KEY offset is >=3D *offset and advances *offset past=
 it.
> + * Iterator for the fs-layer readdir, which is re-entered once per entr=
y:
> + * returns the first real entry whose BTRFS_DIR_INDEX_KEY offset is
> + * >=3D *offset and advances *offset past it.
>    *
>    * @root, @ino:		directory to read
>    * @offset:		in/out cursor; DIR_INDEX offset to resume from
> diff --git a/fs/fs.c b/fs/fs.c
> index 4694a88f776b..1ebda6f4ee2a 100644
> --- a/fs/fs.c
> +++ b/fs/fs.c
> @@ -320,7 +320,7 @@ static struct fstype_info fstypes[] =3D {
>   		.null_dev_desc_ok =3D false,
>   		.probe =3D btrfs_probe,
>   		.close =3D btrfs_close,
> -		.ls =3D btrfs_ls,
> +		.ls =3D fs_ls_generic,
>   		.exists =3D btrfs_exists,
>   		.size =3D btrfs_size,
>   		.read =3D btrfs_read,
> diff --git a/include/btrfs.h b/include/btrfs.h
> index 6fff45a497ee..3878b7817ea6 100644
> --- a/include/btrfs.h
> +++ b/include/btrfs.h
> @@ -15,7 +15,6 @@ struct fs_dirent;
>  =20
>   int btrfs_probe(struct blk_desc *fs_dev_desc,
>   		struct disk_partition *fs_partition);
> -int btrfs_ls(const char *);
>   int btrfs_exists(const char *);
>   int btrfs_size(const char *, loff_t *);
>   int btrfs_read(const char *, void *, loff_t, loff_t, loff_t *);
>=20

