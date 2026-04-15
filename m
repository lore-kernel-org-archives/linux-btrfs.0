Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387D117A2EA
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776291170; cv=none; b=AIOC3J/nT+lIWuFqLUTDGAC1y2SvjuVPdYOYo93HfqyHTnUxg6x7EEAI519SOCrv+qUxHSZm+3FtIovXR9XoCFzj6soTJ5YTnjEUHRDOXZei+gQiC1mXmCx/tS2rbXl7DINFKrHLNQWaS1/XxUCyqkVO8glxhFpbwwT5o25InCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776291170; c=relaxed/simple;
	bh=Nn5sBWXEGIIjGJFmT6z358Z0r3JIq1HZ4meyQ3/4Ml4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QBD8CnfEVAgyFOlE63Bd6iKd0bL4ceU13NBNIQ2gunynQDLRHBhBUHzXLWYhttYLKPwDGdysTGMessweKU8cLCJtkN4OvrQu3oD5jUSPcJxgp9RTRyoCsTSZee1K166mCJWY+sl4TqO2faJm4Sl7psOc/H4/vC/t6EgQ9ccJ5dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=I5QHq/a5; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="I5QHq/a5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776291164; x=1776895964; i=quwenruo.btrfs@gmx.com;
	bh=nG7buzfJWGYVMyLXlE9Tut9cS+g6RcwsT71nyx2qqSs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=I5QHq/a5ehzrNXdhqjvOxzBZ69ye8MYDGNVP4SLxM9XB4qKwdWo7oJBuWp8RLSTz
	 1mm0iAhCi9N01tojdCdEoru4cGu8pTwyfBTFMu6V613YsYeyNJo0zVx9N88kTrcW4
	 ck0/qQtFWItapPRDNHPi/vWKzSU5AwSQ+pbfxCEdWHjVSdG1a6fVFGStwni5Xr9OV
	 yVR6IYxCv60qrX+FbmnX22/1YnW+O8B/k2beCCeuFe+Tn8yDVoHbcOL6WPGmWjd8P
	 PkZ4Btho5/K7a7Y80XwNS76+cX/E4KXTRomsktJARKXbGjSloiA8GNu8NXAmGXWyi
	 cgXkpaLkX+ULjPp3lA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6KUT-1vKf8y2yCn-00rOGK; Thu, 16
 Apr 2026 00:12:44 +0200
Message-ID: <3b18f22a-00a2-4d6e-871f-443680c01069@gmx.com>
Date: Thu, 16 Apr 2026 07:42:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: convert ioctl handlers to AUTO_KFREE
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260415214414.15115-1-dsterba@suse.com>
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
In-Reply-To: <20260415214414.15115-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SqC6ZzSvqmxqvOXh0j9zoUe0IGIuc5Fv76iDj13OeG/tfs/lVXG
 OM9qDPPNEK/1bDZhMdeQgMpVl33ntKtKvsIAjHxkaxCFUlayJC+l6Uqcfy9SaKou/YGxy/U
 y2ikDIVpVoG9XqztdDJnJ30zTiG2Uxpsd75nRRKC4kP5SYjbuF/0FkXGe26/yMuA0F5uzXw
 cpKjbb5U56AJxpC+/cRng==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bpCqLQb++lM=;Gpy6tE3nDxKWPiMLf8llUmRFQw3
 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
 ZjPk/+sAgIRiLckjJm2F6heVT/7kx5di0vEY=



=E5=9C=A8 2026/4/16 07:14, David Sterba =E5=86=99=E9=81=93:
> Many ioctl handlers are suitable for the AUTO_KFREE conversions as the
> data are temporary and short lived. The conversions are trivial or the
> collateral changes are straightforward.
>=20
> A kfree() preceding mnt_drop_write_file() is slightly more efficient but
> in the reverse order (i.e. the automatic kfree) does not cause any
> significant change as the write drop does only a few simple operations.
>=20
> Note: __free() handles also error pointers, so this is safe for the
> memdup_user() errors too.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> ---
> v2:
>=20
> - mention handling of error pointers
> - keep 'return ret' where necessary
>=20
>   fs/btrfs/ioctl.c | 285 +++++++++++++++++------------------------------
>   1 file changed, 102 insertions(+), 183 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index adbc6d2caafb..751db2ae8408 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -708,7 +708,7 @@ static int create_snapshot(struct btrfs_root *root, =
struct inode *dir,
>   {
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(dir);
>   	struct inode *inode;
> -	struct btrfs_pending_snapshot *pending_snapshot;
> +	struct btrfs_pending_snapshot AUTO_KFREE(pending_snapshot);
>   	unsigned int trans_num_items;
>   	struct btrfs_trans_handle *trans;
>   	struct btrfs_block_rsv *block_rsv;
> @@ -817,7 +817,6 @@ static int create_snapshot(struct btrfs_root *root, =
struct inode *dir,
>   		free_anon_bdev(pending_snapshot->anon_dev);
>   	kfree(pending_snapshot->root_item);
>   	btrfs_free_path(pending_snapshot->path);
> -	kfree(pending_snapshot);
>  =20
>   	return ret;
>   }
> @@ -962,7 +961,7 @@ static noinline int btrfs_ioctl_resize(struct file *=
file,
>   	u64 new_size;
>   	u64 old_size;
>   	u64 devid =3D 1;
> -	struct btrfs_ioctl_vol_args *vol_args;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
>   	struct btrfs_device *device =3D NULL;
>   	char *sizestr;
>   	char *devstr =3D NULL;
> @@ -988,13 +987,13 @@ static noinline int btrfs_ioctl_resize(struct file=
 *file,
>   	}
>   	ret =3D btrfs_check_ioctl_vol_args_path(vol_args);
>   	if (ret < 0)
> -		goto out_free;
> +		goto out_drop;
>  =20
>   	sizestr =3D vol_args->name;
>   	cancel =3D (strcmp("cancel", sizestr) =3D=3D 0);
>   	ret =3D exclop_start_or_cancel_reloc(fs_info, BTRFS_EXCLOP_RESIZE, ca=
ncel);
>   	if (ret)
> -		goto out_free;
> +		goto out_drop;
>   	/* Exclusive operation is now claimed */
>  =20
>   	devstr =3D strchr(sizestr, ':');
> @@ -1101,8 +1100,6 @@ static noinline int btrfs_ioctl_resize(struct file=
 *file,
>   			old_size, new_size);
>   out_finish:
>   	btrfs_exclop_finish(fs_info);
> -out_free:
> -	kfree(vol_args);
>   out_drop:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -1180,7 +1177,7 @@ static noinline int __btrfs_ioctl_snap_create(stru=
ct file *file,
>   static noinline int btrfs_ioctl_snap_create(struct file *file,
>   					    void __user *arg, bool subvol)
>   {
> -	struct btrfs_ioctl_vol_args *vol_args;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
>   	int ret;
>  =20
>   	if (!S_ISDIR(file_inode(file)->i_mode))
> @@ -1191,24 +1188,20 @@ static noinline int btrfs_ioctl_snap_create(stru=
ct file *file,
>   		return PTR_ERR(vol_args);
>   	ret =3D btrfs_check_ioctl_vol_args_path(vol_args);
>   	if (ret < 0)
> -		goto out;
> +		return ret;
>  =20
> -	ret =3D __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> -					vol_args->name, vol_args->fd, subvol,
> -					false, NULL);
> -
> -out:
> -	kfree(vol_args);
> -	return ret;
> +	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> +					 vol_args->name, vol_args->fd, subvol,
> +					 false, NULL);
>   }
>  =20
>   static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
>   					       void __user *arg, bool subvol)
>   {
> -	struct btrfs_ioctl_vol_args_v2 *vol_args;
> +	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args);
> +	struct btrfs_qgroup_inherit AUTO_KFREE(inherit);
>   	int ret;
>   	bool readonly =3D false;
> -	struct btrfs_qgroup_inherit *inherit =3D NULL;
>  =20
>   	if (!S_ISDIR(file_inode(file)->i_mode))
>   		return -ENOTDIR;
> @@ -1218,44 +1211,32 @@ static noinline int btrfs_ioctl_snap_create_v2(s=
truct file *file,
>   		return PTR_ERR(vol_args);
>   	ret =3D btrfs_check_ioctl_vol_args2_subvol_name(vol_args);
>   	if (ret < 0)
> -		goto free_args;
> +		return ret;
>  =20
> -	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ARGS_MASK) {
> -		ret =3D -EOPNOTSUPP;
> -		goto free_args;
> -	}
> +	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ARGS_MASK)
> +		return -EOPNOTSUPP;
>  =20
>   	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
>   		readonly =3D true;
>   	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
>   		struct btrfs_fs_info *fs_info =3D inode_to_fs_info(file_inode(file))=
;
>  =20
> -		if (vol_args->size < sizeof(*inherit) ||
> -		    vol_args->size > PAGE_SIZE) {
> -			ret =3D -EINVAL;
> -			goto free_args;
> -		}
> +		if (vol_args->size < sizeof(*inherit) || vol_args->size > PAGE_SIZE)
> +			return -EINVAL;
> +
>   		inherit =3D memdup_user(vol_args->qgroup_inherit, vol_args->size);
>   		if (IS_ERR(inherit)) {
> -			ret =3D PTR_ERR(inherit);
> -			goto free_args;
> +			return PTR_ERR(inherit);
>   		}
>  =20
>   		ret =3D btrfs_qgroup_check_inherit(fs_info, inherit, vol_args->size)=
;
>   		if (ret < 0)
> -			goto free_inherit;
> +			return ret;
>   	}
>  =20
> -	ret =3D __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> -					vol_args->name, vol_args->fd, subvol,
> -					readonly, inherit);
> -	if (ret)
> -		goto free_inherit;
> -free_inherit:
> -	kfree(inherit);
> -free_args:
> -	kfree(vol_args);
> -	return ret;
> +	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> +					 vol_args->name, vol_args->fd, subvol,
> +					 readonly, inherit);
>   }
>  =20
>   static noinline int btrfs_ioctl_subvol_getflags(struct btrfs_inode *in=
ode,
> @@ -1866,7 +1847,7 @@ static int btrfs_search_path_in_tree_user(struct m=
nt_idmap *idmap,
>   static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
>   					   void __user *argp)
>   {
> -	struct btrfs_ioctl_ino_lookup_args *args;
> +	struct btrfs_ioctl_ino_lookup_args AUTO_KFREE(args);
>   	int ret =3D 0;
>  =20
>   	args =3D memdup_user(argp, sizeof(*args));
> @@ -1896,9 +1877,8 @@ static noinline int btrfs_ioctl_ino_lookup(struct =
btrfs_root *root,
>  =20
>   out:
>   	if (ret =3D=3D 0 && copy_to_user(argp, args, sizeof(*args)))
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -	kfree(args);
>   	return ret;
>   }
>  =20
> @@ -1916,7 +1896,7 @@ static noinline int btrfs_ioctl_ino_lookup(struct =
btrfs_root *root,
>    */
>   static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user =
*argp)
>   {
> -	struct btrfs_ioctl_ino_lookup_user_args *args;
> +	struct btrfs_ioctl_ino_lookup_user_args AUTO_KFREE(args);
>   	struct inode *inode;
>   	int ret;
>  =20
> @@ -1932,7 +1912,6 @@ static int btrfs_ioctl_ino_lookup_user(struct file=
 *file, void __user *argp)
>   		 * The subvolume does not exist under fd with which this is
>   		 * called
>   		 */
> -		kfree(args);
>   		return -EACCES;
>   	}
>  =20
> @@ -1941,14 +1920,13 @@ static int btrfs_ioctl_ino_lookup_user(struct fi=
le *file, void __user *argp)
>   	if (ret =3D=3D 0 && copy_to_user(argp, args, sizeof(*args)))
>   		ret =3D -EFAULT;
>  =20
> -	kfree(args);
>   	return ret;
>   }
>  =20
>   /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BAC=
KREF */
>   static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __use=
r *argp)
>   {
> -	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	struct btrfs_ioctl_get_subvol_info_args AUTO_KFREE(subvol_info);
>   	struct btrfs_fs_info *fs_info;
>   	struct btrfs_root *root;
>   	struct btrfs_path *path;
> @@ -2058,7 +2036,6 @@ static int btrfs_ioctl_get_subvol_info(struct inod=
e *inode, void __user *argp)
>   	btrfs_put_root(root);
>   out_free:
>   	btrfs_free_path(path);
> -	kfree(subvol_info);
>   	return ret;
>   }
>  =20
> @@ -2069,7 +2046,7 @@ static int btrfs_ioctl_get_subvol_info(struct inod=
e *inode, void __user *argp)
>   static int btrfs_ioctl_get_subvol_rootref(struct btrfs_root *root,
>   					  void __user *argp)
>   {
> -	struct btrfs_ioctl_get_subvol_rootref_args *rootrefs;
> +	struct btrfs_ioctl_get_subvol_rootref_args AUTO_KFREE(rootrefs);
>   	struct btrfs_root_ref *rref;
>   	struct btrfs_path *path;
>   	struct btrfs_key key;
> @@ -2152,8 +2129,6 @@ static int btrfs_ioctl_get_subvol_rootref(struct b=
trfs_root *root,
>   			ret =3D -EFAULT;
>   	}
>  =20
> -	kfree(rootrefs);
> -
>   	return ret;
>   }
>  =20
> @@ -2168,8 +2143,8 @@ static noinline int btrfs_ioctl_snap_destroy(struc=
t file *file,
>   	struct inode *inode;
>   	struct btrfs_root *root =3D BTRFS_I(dir)->root;
>   	struct btrfs_root *dest =3D NULL;
> -	struct btrfs_ioctl_vol_args *vol_args =3D NULL;
> -	struct btrfs_ioctl_vol_args_v2 *vol_args2 =3D NULL;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
> +	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args2);
>   	struct mnt_idmap *idmap =3D file_mnt_idmap(file);
>   	char *subvol_name, *subvol_name_ptr =3D NULL;
>   	int ret =3D 0;
> @@ -2187,10 +2162,8 @@ static noinline int btrfs_ioctl_snap_destroy(stru=
ct file *file,
>   		if (IS_ERR(vol_args2))
>   			return PTR_ERR(vol_args2);
>  =20
> -		if (vol_args2->flags & ~BTRFS_SUBVOL_DELETE_ARGS_MASK) {
> -			ret =3D -EOPNOTSUPP;
> -			goto out;
> -		}
> +		if (vol_args2->flags & ~BTRFS_SUBVOL_DELETE_ARGS_MASK)
> +			return -EOPNOTSUPP;
>  =20
>   		/*
>   		 * If SPEC_BY_ID is not set, we are looking for the subvolume by
> @@ -2199,23 +2172,21 @@ static noinline int btrfs_ioctl_snap_destroy(str=
uct file *file,
>   		if (!(vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID)) {
>   			ret =3D btrfs_check_ioctl_vol_args2_subvol_name(vol_args2);
>   			if (ret < 0)
> -				goto out;
> +				return ret;
>   			subvol_name =3D vol_args2->name;
>  =20
>   			ret =3D mnt_want_write_file(file);
>   			if (ret)
> -				goto out;
> +				return ret;
>   		} else {
>   			struct inode *old_dir;
>  =20
> -			if (vol_args2->subvolid < BTRFS_FIRST_FREE_OBJECTID) {
> -				ret =3D -EINVAL;
> -				goto out;
> -			}
> +			if (vol_args2->subvolid < BTRFS_FIRST_FREE_OBJECTID)
> +				return -EINVAL;
>  =20
>   			ret =3D mnt_want_write_file(file);
>   			if (ret)
> -				goto out;
> +				return ret;
>  =20
>   			dentry =3D btrfs_get_dentry(fs_info->sb,
>   					BTRFS_FIRST_FREE_OBJECTID,
> @@ -2285,13 +2256,13 @@ static noinline int btrfs_ioctl_snap_destroy(str=
uct file *file,
>  =20
>   		ret =3D btrfs_check_ioctl_vol_args_path(vol_args);
>   		if (ret < 0)
> -			goto out;
> +			return ret;
>  =20
>   		subvol_name =3D vol_args->name;
>  =20
>   		ret =3D mnt_want_write_file(file);
>   		if (ret)
> -			goto out;
> +			return ret;
>   	}
>  =20
>   	if (strchr(subvol_name, '/') ||
> @@ -2372,9 +2343,6 @@ static noinline int btrfs_ioctl_snap_destroy(struc=
t file *file,
>   		dput(parent);
>   out_drop_write:
>   	mnt_drop_write_file(file);
> -out:
> -	kfree(vol_args2);
> -	kfree(vol_args);
>   	return ret;
>   }
>  =20
> @@ -2462,7 +2430,7 @@ static int btrfs_ioctl_defrag(struct file *file, v=
oid __user *argp)
>  =20
>   static long btrfs_ioctl_add_dev(struct btrfs_fs_info *fs_info, void __=
user *arg)
>   {
> -	struct btrfs_ioctl_vol_args *vol_args;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
>   	bool restore_op =3D false;
>   	int ret;
>  =20
> @@ -2502,15 +2470,13 @@ static long btrfs_ioctl_add_dev(struct btrfs_fs_=
info *fs_info, void __user *arg)
>  =20
>   	ret =3D btrfs_check_ioctl_vol_args_path(vol_args);
>   	if (ret < 0)
> -		goto out_free;
> +		goto out;
>  =20
>   	ret =3D btrfs_init_new_device(fs_info, vol_args->name);
>  =20
>   	if (!ret)
>   		btrfs_info(fs_info, "disk added %s", vol_args->name);
>  =20
> -out_free:
> -	kfree(vol_args);
>   out:
>   	if (restore_op)
>   		btrfs_exclop_balance(fs_info, BTRFS_EXCLOP_BALANCE_PAUSED);
> @@ -2524,7 +2490,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *fil=
e, void __user *arg)
>   	BTRFS_DEV_LOOKUP_ARGS(args);
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
> -	struct btrfs_ioctl_vol_args_v2 *vol_args;
> +	struct btrfs_ioctl_vol_args_v2 AUTO_KFREE(vol_args);
>   	struct file *bdev_file =3D NULL;
>   	int ret;
>   	bool cancel =3D false;
> @@ -2583,7 +2549,6 @@ static long btrfs_ioctl_rm_dev_v2(struct file *fil=
e, void __user *arg)
>   		bdev_fput(bdev_file);
>   out:
>   	btrfs_put_dev_args_from_path(&args);
> -	kfree(vol_args);
>   	return ret;
>   }
>  =20
> @@ -2592,7 +2557,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, =
void __user *arg)
>   	BTRFS_DEV_LOOKUP_ARGS(args);
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
> -	struct btrfs_ioctl_vol_args *vol_args;
> +	struct btrfs_ioctl_vol_args AUTO_KFREE(vol_args);
>   	struct file *bdev_file =3D NULL;
>   	int ret;
>   	bool cancel =3D false;
> @@ -2606,7 +2571,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, =
void __user *arg)
>  =20
>   	ret =3D btrfs_check_ioctl_vol_args_path(vol_args);
>   	if (ret < 0)
> -		goto out_free;
> +		return ret;
>  =20
>   	if (!strcmp("cancel", vol_args->name)) {
>   		cancel =3D true;
> @@ -2634,19 +2599,16 @@ static long btrfs_ioctl_rm_dev(struct file *file=
, void __user *arg)
>   		bdev_fput(bdev_file);
>   out:
>   	btrfs_put_dev_args_from_path(&args);
> -out_free:
> -	kfree(vol_args);
>   	return ret;
>   }
>  =20
>   static long btrfs_ioctl_fs_info(const struct btrfs_fs_info *fs_info,
>   				void __user *arg)
>   {
> -	struct btrfs_ioctl_fs_info_args *fi_args;
> +	struct btrfs_ioctl_fs_info_args AUTO_KFREE(fi_args);
>   	struct btrfs_device *device;
>   	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>   	u64 flags_in;
> -	int ret =3D 0;
>  =20
>   	fi_args =3D memdup_user(arg, sizeof(*fi_args));
>   	if (IS_ERR(fi_args))
> @@ -2687,17 +2649,16 @@ static long btrfs_ioctl_fs_info(const struct btr=
fs_fs_info *fs_info,
>   	}
>  =20
>   	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -	kfree(fi_args);
> -	return ret;
> +	return 0;
>   }
>  =20
>   static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
>   				 void __user *arg)
>   {
>   	BTRFS_DEV_LOOKUP_ARGS(args);
> -	struct btrfs_ioctl_dev_info_args *di_args;
> +	struct btrfs_ioctl_dev_info_args AUTO_KFREE(di_args);
>   	struct btrfs_device *dev;
>   	int ret =3D 0;
>  =20
> @@ -2731,7 +2692,6 @@ static long btrfs_ioctl_dev_info(const struct btrf=
s_fs_info *fs_info,
>   	if (ret =3D=3D 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
>   		ret =3D -EFAULT;
>  =20
> -	kfree(di_args);
>   	return ret;
>   }
>  =20
> @@ -3012,7 +2972,7 @@ static noinline long btrfs_ioctl_wait_sync(struct =
btrfs_fs_info *fs_info,
>   static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
>   {
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(file_inode(file));
> -	struct btrfs_ioctl_scrub_args *sa;
> +	struct btrfs_ioctl_scrub_args AUTO_KFREE(sa);
>   	int ret;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3027,15 +2987,13 @@ static long btrfs_ioctl_scrub(struct file *file,=
 void __user *arg)
>   	if (IS_ERR(sa))
>   		return PTR_ERR(sa);
>  =20
> -	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS) {
> -		ret =3D -EOPNOTSUPP;
> -		goto out;
> -	}
> +	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS)
> +		return -EOPNOTSUPP;
>  =20
>   	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
>   		ret =3D mnt_want_write_file(file);
>   		if (ret)
> -			goto out;
> +			return ret;
>   	}
>  =20
>   	ret =3D btrfs_scrub_dev(fs_info, sa->devid, sa->start, sa->end,
> @@ -3059,8 +3017,7 @@ static long btrfs_ioctl_scrub(struct file *file, v=
oid __user *arg)
>  =20
>   	if (!(sa->flags & BTRFS_SCRUB_READONLY))
>   		mnt_drop_write_file(file);
> -out:
> -	kfree(sa);
> +
>   	return ret;
>   }
>  =20
> @@ -3075,7 +3032,7 @@ static long btrfs_ioctl_scrub_cancel(struct btrfs_=
fs_info *fs_info)
>   static long btrfs_ioctl_scrub_progress(struct btrfs_fs_info *fs_info,
>   				       void __user *arg)
>   {
> -	struct btrfs_ioctl_scrub_args *sa;
> +	struct btrfs_ioctl_scrub_args AUTO_KFREE(sa);
>   	int ret;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3088,40 +3045,36 @@ static long btrfs_ioctl_scrub_progress(struct bt=
rfs_fs_info *fs_info,
>   	ret =3D btrfs_scrub_progress(fs_info, sa->devid, &sa->progress);
>  =20
>   	if (ret =3D=3D 0 && copy_to_user(arg, sa, sizeof(*sa)))
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -	kfree(sa);
>   	return ret;
>   }
>  =20
>   static long btrfs_ioctl_get_dev_stats(struct btrfs_fs_info *fs_info,
>   				      void __user *arg)
>   {
> -	struct btrfs_ioctl_get_dev_stats *sa;
> +	struct btrfs_ioctl_get_dev_stats AUTO_KFREE(sa);
>   	int ret;
>  =20
>   	sa =3D memdup_user(arg, sizeof(*sa));
>   	if (IS_ERR(sa))
>   		return PTR_ERR(sa);
>  =20
> -	if ((sa->flags & BTRFS_DEV_STATS_RESET) && !capable(CAP_SYS_ADMIN)) {
> -		kfree(sa);
> +	if ((sa->flags & BTRFS_DEV_STATS_RESET) && !capable(CAP_SYS_ADMIN))
>   		return -EPERM;
> -	}
>  =20
>   	ret =3D btrfs_get_dev_stats(fs_info, sa);
>  =20
>   	if (ret =3D=3D 0 && copy_to_user(arg, sa, sizeof(*sa)))
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -	kfree(sa);
>   	return ret;
>   }
>  =20
>   static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
>   				    void __user *arg)
>   {
> -	struct btrfs_ioctl_dev_replace_args *p;
> +	struct btrfs_ioctl_dev_replace_args AUTO_KFREE(p);
>   	int ret;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3138,10 +3091,8 @@ static long btrfs_ioctl_dev_replace(struct btrfs_=
fs_info *fs_info,
>  =20
>   	switch (p->cmd) {
>   	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
> -		if (sb_rdonly(fs_info->sb)) {
> -			ret =3D -EROFS;
> -			goto out;
> -		}
> +		if (sb_rdonly(fs_info->sb))
> +			return -EROFS;
>   		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
>   			ret =3D BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>   		} else {
> @@ -3163,9 +3114,8 @@ static long btrfs_ioctl_dev_replace(struct btrfs_f=
s_info *fs_info,
>   	}
>  =20
>   	if ((ret =3D=3D 0 || ret =3D=3D -ECANCELED) && copy_to_user(arg, p, s=
izeof(*p)))
> -		ret =3D -EFAULT;
> -out:
> -	kfree(p);
> +		return -EFAULT;
> +
>   	return ret;
>   }
>  =20
> @@ -3175,7 +3125,7 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_r=
oot *root, void __user *arg)
>   	int i;
>   	u64 rel_ptr;
>   	int size;
> -	struct btrfs_ioctl_ino_path_args *ipa =3D NULL;
> +	struct btrfs_ioctl_ino_path_args AUTO_KFREE(ipa);
>   	struct inode_fs_paths *ipath __free(inode_fs_paths) =3D NULL;
>   	struct btrfs_path *path;
>  =20
> @@ -3224,7 +3174,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_r=
oot *root, void __user *arg)
>  =20
>   out:
>   	btrfs_free_path(path);
> -	kfree(ipa);
>  =20
>   	return ret;
>   }
> @@ -3234,8 +3183,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrf=
s_fs_info *fs_info,
>   {
>   	int ret =3D 0;
>   	int size;
> -	struct btrfs_ioctl_logical_ino_args *loi;
> -	struct btrfs_data_container *inodes =3D NULL;
> +	struct btrfs_ioctl_logical_ino_args AUTO_KFREE(loi);
> +	struct btrfs_data_container AUTO_KVFREE(inodes);
>   	bool ignore_offset;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3250,41 +3199,32 @@ static long btrfs_ioctl_logical_to_ino(struct bt=
rfs_fs_info *fs_info,
>   		size =3D min_t(u32, loi->size, SZ_64K);
>   	} else {
>   		/* All reserved bits must be 0 for now */
> -		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
> -			ret =3D -EINVAL;
> -			goto out_loi;
> -		}
> +		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved)))
> +			return -EINVAL;
> +
>   		/* Only accept flags we have defined so far */
> -		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
> -			ret =3D -EINVAL;
> -			goto out_loi;
> -		}
> +		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET))
> +			return -EINVAL;
> +
>   		ignore_offset =3D loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
>   		size =3D min_t(u32, loi->size, SZ_16M);
>   	}
>  =20
>   	inodes =3D init_data_container(size);
> -	if (IS_ERR(inodes)) {
> -		ret =3D PTR_ERR(inodes);
> -		goto out_loi;
> -	}
> +	if (IS_ERR(inodes))
> +		return PTR_ERR(inodes);
>  =20
>   	ret =3D iterate_inodes_from_logical(loi->logical, fs_info, inodes, ig=
nore_offset);
>   	if (ret =3D=3D -EINVAL)
> -		ret =3D -ENOENT;
> +		return -ENOENT;
>   	if (ret < 0)
> -		goto out;
> +		return ret;
>  =20
>   	ret =3D copy_to_user((void __user *)(unsigned long)loi->inodes, inode=
s,
>   			   size);
>   	if (ret)
>   		ret =3D -EFAULT;
>  =20
> -out:
> -	kvfree(inodes);
> -out_loi:
> -	kfree(loi);
> -
>   	return ret;
>   }
>  =20
> @@ -3381,7 +3321,7 @@ static long btrfs_ioctl_balance(struct file *file,=
 void __user *arg)
>   {
>   	struct btrfs_root *root =3D BTRFS_I(file_inode(file))->root;
>   	struct btrfs_fs_info *fs_info =3D root->fs_info;
> -	struct btrfs_ioctl_balance_args *bargs;
> +	struct btrfs_ioctl_balance_args AUTO_KFREE(bargs);
>   	struct btrfs_balance_control *bctl;
>   	bool need_unlock =3D true;
>   	int ret;
> @@ -3466,7 +3406,6 @@ static long btrfs_ioctl_balance(struct file *file,=
 void __user *arg)
>   		btrfs_exclop_finish(fs_info);
>   out:
>   	mnt_drop_write_file(file);
> -	kfree(bargs);
>   	return ret;
>   }
>  =20
> @@ -3519,7 +3458,7 @@ static long btrfs_ioctl_quota_ctl(struct file *fil=
e, void __user *arg)
>   {
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
> -	struct btrfs_ioctl_quota_ctl_args *sa;
> +	struct btrfs_ioctl_quota_ctl_args AUTO_KFREE(sa);
>   	int ret;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3578,7 +3517,6 @@ static long btrfs_ioctl_quota_ctl(struct file *fil=
e, void __user *arg)
>   		break;
>   	}
>  =20
> -	kfree(sa);
>   drop_write:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -3589,8 +3527,8 @@ static long btrfs_ioctl_qgroup_assign(struct file =
*file, void __user *arg)
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
>   	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -	struct btrfs_ioctl_qgroup_assign_args *sa;
> -	struct btrfs_qgroup_list *prealloc =3D NULL;
> +	struct btrfs_ioctl_qgroup_assign_args AUTO_KFREE(sa);
> +	struct btrfs_qgroup_list AUTO_KFREE(prealloc);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
>   	int err;
> @@ -3615,7 +3553,7 @@ static long btrfs_ioctl_qgroup_assign(struct file =
*file, void __user *arg)
>   		prealloc =3D kzalloc_obj(*prealloc);
>   		if (!prealloc) {
>   			ret =3D -ENOMEM;
> -			goto out;
> +			goto drop_write;
>   		}
>   	}
>  =20
> @@ -3623,7 +3561,7 @@ static long btrfs_ioctl_qgroup_assign(struct file =
*file, void __user *arg)
>   	trans =3D btrfs_start_transaction(root, 2);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	/*
> @@ -3649,9 +3587,6 @@ static long btrfs_ioctl_qgroup_assign(struct file =
*file, void __user *arg)
>   	if (err && !ret)
>   		ret =3D err;
>  =20
> -out:
> -	kfree(prealloc);
> -	kfree(sa);
>   drop_write:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -3661,7 +3596,7 @@ static long btrfs_ioctl_qgroup_create(struct file =
*file, void __user *arg)
>   {
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -	struct btrfs_ioctl_qgroup_create_args *sa;
> +	struct btrfs_ioctl_qgroup_create_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
>   	int err;
> @@ -3684,12 +3619,12 @@ static long btrfs_ioctl_qgroup_create(struct fil=
e *file, void __user *arg)
>  =20
>   	if (!sa->qgroupid) {
>   		ret =3D -EINVAL;
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	if (sa->create && btrfs_is_fstree(sa->qgroupid)) {
>   		ret =3D -EINVAL;
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	/*
> @@ -3699,7 +3634,7 @@ static long btrfs_ioctl_qgroup_create(struct file =
*file, void __user *arg)
>   	trans =3D btrfs_start_transaction(root, 2);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	if (sa->create) {
> @@ -3712,8 +3647,6 @@ static long btrfs_ioctl_qgroup_create(struct file =
*file, void __user *arg)
>   	if (err && !ret)
>   		ret =3D err;
>  =20
> -out:
> -	kfree(sa);
>   drop_write:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -3723,7 +3656,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *=
file, void __user *arg)
>   {
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> -	struct btrfs_ioctl_qgroup_limit_args *sa;
> +	struct btrfs_ioctl_qgroup_limit_args AUTO_KFREE(sa);
>   	struct btrfs_trans_handle *trans;
>   	int ret;
>   	int err;
> @@ -3749,7 +3682,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *=
file, void __user *arg)
>   	trans =3D btrfs_start_transaction(root, 1);
>   	if (IS_ERR(trans)) {
>   		ret =3D PTR_ERR(trans);
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	qgroupid =3D sa->qgroupid;
> @@ -3764,8 +3697,6 @@ static long btrfs_ioctl_qgroup_limit(struct file *=
file, void __user *arg)
>   	if (err && !ret)
>   		ret =3D err;
>  =20
> -out:
> -	kfree(sa);
>   drop_write:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -3775,7 +3706,7 @@ static long btrfs_ioctl_quota_rescan(struct file *=
file, void __user *arg)
>   {
>   	struct inode *inode =3D file_inode(file);
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
> -	struct btrfs_ioctl_quota_rescan_args *qsa;
> +	struct btrfs_ioctl_quota_rescan_args AUTO_KFREE(qsa);
>   	int ret;
>  =20
>   	if (!capable(CAP_SYS_ADMIN))
> @@ -3796,13 +3727,11 @@ static long btrfs_ioctl_quota_rescan(struct file=
 *file, void __user *arg)
>  =20
>   	if (qsa->flags) {
>   		ret =3D -EINVAL;
> -		goto out;
> +		goto drop_write;
>   	}
>  =20
>   	ret =3D btrfs_qgroup_rescan(fs_info);
>  =20
> -out:
> -	kfree(qsa);
>   drop_write:
>   	mnt_drop_write_file(file);
>   	return ret;
> @@ -3947,8 +3876,8 @@ static long _btrfs_ioctl_set_received_subvol(struc=
t file *file,
>   static long btrfs_ioctl_set_received_subvol_32(struct file *file,
>   						void __user *arg)
>   {
> -	struct btrfs_ioctl_received_subvol_args_32 *args32 =3D NULL;
> -	struct btrfs_ioctl_received_subvol_args *args64 =3D NULL;
> +	struct btrfs_ioctl_received_subvol_args_32 AUTO_KFREE(args32);
> +	struct btrfs_ioctl_received_subvol_args AUTO_KFREE(args64);
>   	int ret =3D 0;
>  =20
>   	args32 =3D memdup_user(arg, sizeof(*args32));
> @@ -3956,10 +3885,8 @@ static long btrfs_ioctl_set_received_subvol_32(st=
ruct file *file,
>   		return PTR_ERR(args32);
>  =20
>   	args64 =3D kmalloc_obj(*args64);
> -	if (!args64) {
> -		ret =3D -ENOMEM;
> -		goto out;
> -	}
> +	if (!args64)
> +		return -ENOMEM;
>  =20
>   	memcpy(args64->uuid, args32->uuid, BTRFS_UUID_SIZE);
>   	args64->stransid =3D args32->stransid;
> @@ -3972,7 +3899,7 @@ static long btrfs_ioctl_set_received_subvol_32(str=
uct file *file,
>  =20
>   	ret =3D _btrfs_ioctl_set_received_subvol(file, file_mnt_idmap(file), =
args64);
>   	if (ret)
> -		goto out;
> +		return ret;
>  =20
>   	memcpy(args32->uuid, args64->uuid, BTRFS_UUID_SIZE);
>   	args32->stransid =3D args64->stransid;
> @@ -3985,19 +3912,16 @@ static long btrfs_ioctl_set_received_subvol_32(s=
truct file *file,
>  =20
>   	ret =3D copy_to_user(arg, args32, sizeof(*args32));
>   	if (ret)
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -out:
> -	kfree(args32);
> -	kfree(args64);
> -	return ret;
> +	return 0;
>   }
>   #endif
>  =20
>   static long btrfs_ioctl_set_received_subvol(struct file *file,
>   					    void __user *arg)
>   {
> -	struct btrfs_ioctl_received_subvol_args *sa =3D NULL;
> +	struct btrfs_ioctl_received_subvol_args AUTO_KFREE(sa);
>   	int ret =3D 0;
>  =20
>   	sa =3D memdup_user(arg, sizeof(*sa));
> @@ -4005,17 +3929,14 @@ static long btrfs_ioctl_set_received_subvol(stru=
ct file *file,
>   		return PTR_ERR(sa);
>  =20
>   	ret =3D _btrfs_ioctl_set_received_subvol(file, file_mnt_idmap(file), =
sa);
> -
>   	if (ret)
> -		goto out;
> +		return ret;
>  =20
>   	ret =3D copy_to_user(arg, sa, sizeof(*sa));
>   	if (ret)
> -		ret =3D -EFAULT;
> +		return -EFAULT;
>  =20
> -out:
> -	kfree(sa);
> -	return ret;
> +	return 0;
>   }
>  =20
>   static int btrfs_ioctl_get_fslabel(struct btrfs_fs_info *fs_info,
> @@ -4255,7 +4176,7 @@ static int btrfs_ioctl_set_features(struct file *f=
ile, void __user *arg)
>  =20
>   static int _btrfs_ioctl_send(struct btrfs_root *root, void __user *arg=
p, bool compat)
>   {
> -	struct btrfs_ioctl_send_args *arg;
> +	struct btrfs_ioctl_send_args AUTO_KFREE(arg);
>   	int ret;
>  =20
>   	if (compat) {
> @@ -4284,9 +4205,7 @@ static int _btrfs_ioctl_send(struct btrfs_root *ro=
ot, void __user *argp, bool co
>   		if (IS_ERR(arg))
>   			return PTR_ERR(arg);
>   	}
> -	ret =3D btrfs_ioctl_send(root, arg);
> -	kfree(arg);
> -	return ret;
> +	return btrfs_ioctl_send(root, arg);
>   }
>  =20
>   static int btrfs_ioctl_encoded_read(struct file *file, void __user *ar=
gp,

