Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0BB3E00B9;
	Wed, 17 Jun 2026 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695377; cv=none; b=uAcabvlnyJlKuVraPH0ADK8TjV7BtnC3AKov6d1EV/m+1CCSXD0V80FJ4Mj5cF7g7JCTnH+/mludgtXavmwy8TvUdwkRz6RMGw0Eh6sy0lgAo7UmYzLittPqbpKh+e8QwA8nuROBNb5rKgAHUe6dusfSJEaj84vu1NScSOd6mgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695377; c=relaxed/simple;
	bh=5BC9hRAvNMeKIuAN7ZmrQzUw7JzEAfES1E23HdJlw+w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aZCVJRGVShGNOVSN5OQZcLy+oHqMECkGBJClIocyAwXVj9BudIIY5bnao/GO0DkXsnCglGMtxRrpaDWtrMiYiwOAvogEcGzvRZ8YmsDA53CTl34mI72OoahCECYk9b2SJBGtpUBr3XwsTT0G2zIqbM/6bNfqkDgXjTKnTICBVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=NWL0Q9Bd; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="NWL0Q9Bd"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4ggM0N2L3Vz9v3X;
	Wed, 17 Jun 2026 13:22:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1781695364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2oDkwRAk5ZlFMICRQmplUo/xgJr4/mE+/UO8fTrc3qU=;
	b=NWL0Q9BdWOSo0IEOGtQBfRU2oqltW5iNKe3bqEOh/nDn2+JvL8t4G3/t5+b2lBS6lvbHbQ
	DVIiJKlad8jii61LTmE6OWsWED1t06CfgObC+Vhy0JqlQcQ/2DiWCkMtbVFs2/UDexUPYt
	XnpRkzNP82Oinubd+//Pr2UNzywPrZwxBaCkA7RTwPGM8aoOafoLjW4xMwtRjLOotg9+vs
	/jqMkW0BnZqVaAOsboQ+VYIBmsPcszFQGEum1rifqAf6SqWLqtH1xQikVkFpfxyn319K7f
	bN2PEKd5G5dG9u7BqAjytGrdNPnbxJh7tskwPYHpLqSMq/aOGc8okv4+uIwNJQ==
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Daan De Meyer <daan@amutable.com>
Cc: linux-btrfs@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: add 32-bit compat ioctl for
 BTRFS_IOC_GET_SUBVOL_INFO
In-Reply-To: <87wlvxct5e.fsf@> ("Miquel =?utf-8?Q?Sabat=C3=A9_Sol=C3=A0=22?=
 =?utf-8?Q?'s?= message of "Wed, 17 Jun
	2026 13:18:05 +0200")
References: <20260521075113.1079519-1-daan@amutable.com>
Date: Wed, 17 Jun 2026 13:22:41 +0200
Message-ID: <87qzm5csxq.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Just realized I'm commenting on an old thread and that the AUTO_KFREE
suggestion was already applied by David.

Sorry for the noise.

Miquel Sabat=C3=A9 Sol=C3=A0 @ 2026-06-17 13:18 +02:

> Hi,
>
> Just a small comment from my side, but feel free to ignore it :)
>
> Daan De Meyer @ 2026-05-21 07:51 GMT:
>
>> On 64-bit kernels with 32-bit userspace, struct btrfs_ioctl_timespec is
>> laid out as 16 bytes (8B sec + 4B nsec + 4B trailing padding) instead of
>> the 12 bytes a 32-bit userspace expects, because the surrounding struct
>> is not packed. As a result, struct btrfs_ioctl_get_subvol_info_args has
>> a different size and layout in 32-bit userspace than in the 64-bit
>> kernel, and BTRFS_IOC_GET_SUBVOL_INFO returns garbage to 32-bit callers.
>>
>> Mirror what was done for BTRFS_IOC_SET_RECEIVED_SUBVOL: add a packed
>> btrfs_ioctl_get_subvol_info_args_32 with btrfs_ioctl_timespec_32 fields,
>> define BTRFS_IOC_GET_SUBVOL_INFO_32 with that struct as the size
>> argument, factor the existing handler into a shared _btrfs_ioctl_get_
>> subvol_info() helper, and add btrfs_ioctl_get_subvol_info_32() which
>> fills the kernel struct and translates field-by-field into the 32-bit
>> struct before copy_to_user().
>>
>> Signed-off-by: Daan De Meyer <daan@amutable.com>
>> ---
>>  fs/btrfs/ioctl.c | 112 +++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 99 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index a39460bf68a7..31be2590f1b2 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -82,6 +82,30 @@ struct btrfs_ioctl_received_subvol_args_32 {
>>
>>  #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
>>  				struct btrfs_ioctl_received_subvol_args_32)
>> +
>> +struct btrfs_ioctl_get_subvol_info_args_32 {
>> +	__u64 treeid;
>> +	char name[BTRFS_VOL_NAME_MAX + 1];
>> +	__u64 parent_id;
>> +	__u64 dirid;
>> +	__u64 generation;
>> +	__u64 flags;
>> +	__u8 uuid[BTRFS_UUID_SIZE];
>> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
>> +	__u8 received_uuid[BTRFS_UUID_SIZE];
>> +	__u64 ctransid;
>> +	__u64 otransid;
>> +	__u64 stransid;
>> +	__u64 rtransid;
>> +	struct btrfs_ioctl_timespec_32 ctime;
>> +	struct btrfs_ioctl_timespec_32 otime;
>> +	struct btrfs_ioctl_timespec_32 stime;
>> +	struct btrfs_ioctl_timespec_32 rtime;
>> +	__u64 reserved[8];
>> +} __attribute__ ((__packed__));
>> +
>> +#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
>> +				struct btrfs_ioctl_get_subvol_info_args_32)
>>  #endif
>>
>>  #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
>> @@ -1945,9 +1969,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file=
 *file, void __user *argp)
>>  }
>>
>>  /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACK=
REF */
>> -static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user=
 *argp)
>> +static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
>> +					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
>>  {
>> -	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
>>  	struct btrfs_fs_info *fs_info;
>>  	struct btrfs_root *root;
>>  	struct btrfs_path *path;
>> @@ -1964,12 +1988,6 @@ static int btrfs_ioctl_get_subvol_info(struct ino=
de *inode, void __user *argp)
>>  	if (!path)
>>  		return -ENOMEM;
>>
>> -	subvol_info =3D kzalloc_obj(*subvol_info);
>> -	if (!subvol_info) {
>> -		btrfs_free_path(path);
>> -		return -ENOMEM;
>> -	}
>> -
>>  	fs_info =3D BTRFS_I(inode)->root->fs_info;
>>
>>  	/* Get root_item of inode's subvolume */
>> @@ -2048,15 +2066,79 @@ static int btrfs_ioctl_get_subvol_info(struct in=
ode *inode, void __user *argp)
>>  		}
>>  	}
>>
>> -	btrfs_free_path(path);
>> -	path =3D NULL;
>> -	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
>> -		ret =3D -EFAULT;
>> -
>>  out:
>>  	btrfs_put_root(root);
>>  out_free:
>>  	btrfs_free_path(path);
>> +	return ret;
>> +}
>> +
>> +#ifdef CONFIG_64BIT
>> +static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __u=
ser *argp)
>> +{
>> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info =3D NULL;
>> +	struct btrfs_ioctl_get_subvol_info_args_32 *subvol_info_32 =3D NULL;
>
> Maybe these two variables could be declared with the AUTO_KFREE helper,
> so you could remove goto's and the cleanup section in the end.
>
>> +	int ret;
>> +
>> +	subvol_info =3D kzalloc_obj(*subvol_info);
>> +	if (!subvol_info)
>> +		return -ENOMEM;
>> +
>> +	subvol_info_32 =3D kzalloc_obj(*subvol_info_32);
>> +	if (!subvol_info_32) {
>> +		ret =3D -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	ret =3D _btrfs_ioctl_get_subvol_info(inode, subvol_info);
>> +	if (ret)
>> +		goto out;
>> +
>> +	subvol_info_32->treeid =3D subvol_info->treeid;
>> +	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32-=
>name));
>> +	subvol_info_32->parent_id =3D subvol_info->parent_id;
>> +	subvol_info_32->dirid =3D subvol_info->dirid;
>> +	subvol_info_32->generation =3D subvol_info->generation;
>> +	subvol_info_32->flags =3D subvol_info->flags;
>> +	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
>> +	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UU=
ID_SIZE);
>> +	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRF=
S_UUID_SIZE);
>> +	subvol_info_32->ctransid =3D subvol_info->ctransid;
>> +	subvol_info_32->otransid =3D subvol_info->otransid;
>> +	subvol_info_32->stransid =3D subvol_info->stransid;
>> +	subvol_info_32->rtransid =3D subvol_info->rtransid;
>> +	subvol_info_32->ctime.sec =3D subvol_info->ctime.sec;
>> +	subvol_info_32->ctime.nsec =3D subvol_info->ctime.nsec;
>> +	subvol_info_32->otime.sec =3D subvol_info->otime.sec;
>> +	subvol_info_32->otime.nsec =3D subvol_info->otime.nsec;
>> +	subvol_info_32->stime.sec =3D subvol_info->stime.sec;
>> +	subvol_info_32->stime.nsec =3D subvol_info->stime.nsec;
>> +	subvol_info_32->rtime.sec =3D subvol_info->rtime.sec;
>> +	subvol_info_32->rtime.nsec =3D subvol_info->rtime.nsec;
>> +
>> +	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
>> +		ret =3D -EFAULT;
>> +
>> +out:
>> +	kfree(subvol_info_32);
>> +	kfree(subvol_info);
>> +	return ret;
>> +}
>> +#endif
>> +
>> +static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user=
 *argp)
>> +{
>> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
>> +	int ret;
>> +
>> +	subvol_info =3D kzalloc_obj(*subvol_info);
>> +	if (!subvol_info)
>> +		return -ENOMEM;
>> +
>> +	ret =3D _btrfs_ioctl_get_subvol_info(inode, subvol_info);
>> +	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
>> +		ret =3D -EFAULT;
>> +
>>  	kfree(subvol_info);
>>  	return ret;
>>  }
>> @@ -5273,6 +5355,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>>  		return btrfs_ioctl_set_features(file, argp);
>>  	case BTRFS_IOC_GET_SUBVOL_INFO:
>>  		return btrfs_ioctl_get_subvol_info(inode, argp);
>> +#ifdef CONFIG_64BIT
>> +	case BTRFS_IOC_GET_SUBVOL_INFO_32:
>> +		return btrfs_ioctl_get_subvol_info_32(inode, argp);
>> +#endif
>>  	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
>>  		return btrfs_ioctl_get_subvol_rootref(root, argp);
>>  	case BTRFS_IOC_INO_LOOKUP_USER:

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmoyg4EbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZYJvD/4n1tM2/qkYJh8pMena9PZ5uz37Hz/ChZnKa68JGCiswfigPp61PwuAxNT3
/UHS4M7BPfb/NOpdvXjwHgFbp5JSo5nsT0njgROpoKhu14D+sgMVi+kE2ei4h5vU
31AvmILCDPbHJuTqJu/byqKfMn6KhzFVaf+2Q9GszSR6n6DbJw1kYwVFuzwF4Kz8
VFe8Vxm9+Aad4L59WKQHkhWasiYTqrwknEoNAWEQluFMlZcbpuTROuojJBFpqESJ
AQJ4LZbZFv9yRSHCnwYTqYigV+rqyTtN0CMaDYyuebCjW64JZYwNNb/XP/gEMHap
RM+itvCFJ6kj3rlrFtlRIZvZnYwTeFwRA+3LyaauJtBBXPe+Ej3iViB4aRZ16/za
Bl7t0LCYp/gKbgEhEZKXHbnBzNnlYuk7aSd8cRtm9qec85IE8Zap7HuSWu//ZQ1h
jeI9YAVv0pak6oClEM6BXyl8ovGGPRygKbvIY+cW4Y0UVauXwpKXXGFxIP7Yd/9k
Tp4NkQfzXbXaxxMfZQN+8Jzbgc1hQAOxfO2iDhsCS8Kpt247CzxiYLtb6vuS/1S5
OEUORhPoCzg93uQlnYBIDZUUr4W/C7v9yJ7HwQqEpgY5DA2r+DTMgc/fEtZ9Bu2t
B8gWEP2OeuO68uGr6xsix8KW5mVcoQfWFpxHpUC2fnw12atAQg==
=RaCh
-----END PGP SIGNATURE-----
--=-=-=--
