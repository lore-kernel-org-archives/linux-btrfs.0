Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8922BE7A7;
	Wed, 17 Jun 2026 11:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695101; cv=none; b=hkWS9SkDZwWGb2mFYl5xVe1Czq0e0IiwCKJOCqUw7Oy4rpEkEK8/qCmlnv7beZSYyPiUjcC9MsmSL4ovxJHcP5oD+UMJbUv3mj7oxLUhdbl6VGVj2opwYsfG5bObi2xU9uh//dND9D4WsZPq+Um/fnI22oniUaLzHw2qfcSQ3CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695101; c=relaxed/simple;
	bh=GHcfBq1dm/TFUdw1M+cPVoBNbNLwnSUyyOhrhhXGPlM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HYEZCFLDQoVMAPcsP+YcPJRa78/etYNpqwJJkcLM7b4oyuXucQCk+/WTwTFNd+yW1ykO2RAz8zs+aTtBjYiXIEuKerVIZ716bbg8gApCXPDMPu7j0Ja/jY95CuVJd7/NZsMPxx0Zfz14nYmsyMaJrKr8PpHooOaTRcTm+x+oVy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com; spf=fail smtp.mailfrom=mssola.com; dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b=fnPCLHLf; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mssola.com header.i=@mssola.com header.b="fnPCLHLf"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4ggLv757kMz9vLs;
	Wed, 17 Jun 2026 13:18:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1781695091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VNr+qsHGEzo3MilQP7dX2VYjgRIlXLSmwRWCfgqti7s=;
	b=fnPCLHLfIgP3VdO8tAYt2E1HTkxwPLvsN+rtEuwmmnPbsbLaXiQa2/1KQVEoGNxptMntJp
	6csfIP2mteO9UQYe4Cd27LxdTCJV6gs10Q+vIlR4mQxui+MdsYbSPEEzte3Axtf0DktyXz
	GDf+TXhgYpJs2INbtJzn7gW79zs37D/ILw4LcxNsIwptYTBEljuPjszrDp1ljvoh6WLMwH
	zk7eThLntsqDq4NNK/DaO2Vj66TKME++hTWsAd/Y4T7kC/+xYCXMUx2whJUgB2hCqzwfRi
	IXRYNLznMjeAU1YzHTD7tfN/l/kA3JvT071n5y6vGyUHUtfchHy01jp8pPKuJg==
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Daan De Meyer <daan@amutable.com>
Cc: linux-btrfs@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: add 32-bit compat ioctl for
 BTRFS_IOC_GET_SUBVOL_INFO
In-Reply-To: <20260521075113.1079519-1-daan@amutable.com> (Daan De Meyer's
	message of "Thu, 21 May 2026 07:51:13 +0000")
References: <20260521075113.1079519-1-daan@amutable.com>
Date: Wed, 17 Jun 2026 13:18:05 +0200
Message-ID: <87wlvxct5e.fsf@>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Hi,

Just a small comment from my side, but feel free to ignore it :)

Daan De Meyer @ 2026-05-21 07:51 GMT:

> On 64-bit kernels with 32-bit userspace, struct btrfs_ioctl_timespec is
> laid out as 16 bytes (8B sec + 4B nsec + 4B trailing padding) instead of
> the 12 bytes a 32-bit userspace expects, because the surrounding struct
> is not packed. As a result, struct btrfs_ioctl_get_subvol_info_args has
> a different size and layout in 32-bit userspace than in the 64-bit
> kernel, and BTRFS_IOC_GET_SUBVOL_INFO returns garbage to 32-bit callers.
>
> Mirror what was done for BTRFS_IOC_SET_RECEIVED_SUBVOL: add a packed
> btrfs_ioctl_get_subvol_info_args_32 with btrfs_ioctl_timespec_32 fields,
> define BTRFS_IOC_GET_SUBVOL_INFO_32 with that struct as the size
> argument, factor the existing handler into a shared _btrfs_ioctl_get_
> subvol_info() helper, and add btrfs_ioctl_get_subvol_info_32() which
> fills the kernel struct and translates field-by-field into the 32-bit
> struct before copy_to_user().
>
> Signed-off-by: Daan De Meyer <daan@amutable.com>
> ---
>  fs/btrfs/ioctl.c | 112 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 99 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a7..31be2590f1b2 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -82,6 +82,30 @@ struct btrfs_ioctl_received_subvol_args_32 {
>
>  #define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
>  				struct btrfs_ioctl_received_subvol_args_32)
> +
> +struct btrfs_ioctl_get_subvol_info_args_32 {
> +	__u64 treeid;
> +	char name[BTRFS_VOL_NAME_MAX + 1];
> +	__u64 parent_id;
> +	__u64 dirid;
> +	__u64 generation;
> +	__u64 flags;
> +	__u8 uuid[BTRFS_UUID_SIZE];
> +	__u8 parent_uuid[BTRFS_UUID_SIZE];
> +	__u8 received_uuid[BTRFS_UUID_SIZE];
> +	__u64 ctransid;
> +	__u64 otransid;
> +	__u64 stransid;
> +	__u64 rtransid;
> +	struct btrfs_ioctl_timespec_32 ctime;
> +	struct btrfs_ioctl_timespec_32 otime;
> +	struct btrfs_ioctl_timespec_32 stime;
> +	struct btrfs_ioctl_timespec_32 rtime;
> +	__u64 reserved[8];
> +} __attribute__ ((__packed__));
> +
> +#define BTRFS_IOC_GET_SUBVOL_INFO_32 _IOR(BTRFS_IOCTL_MAGIC, 60, \
> +				struct btrfs_ioctl_get_subvol_info_args_32)
>  #endif
>
>  #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> @@ -1945,9 +1969,9 @@ static int btrfs_ioctl_ino_lookup_user(struct file *file, void __user *argp)
>  }
>
>  /* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
> -static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
> +static int _btrfs_ioctl_get_subvol_info(struct inode *inode,
> +					struct btrfs_ioctl_get_subvol_info_args *subvol_info)
>  {
> -	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
>  	struct btrfs_fs_info *fs_info;
>  	struct btrfs_root *root;
>  	struct btrfs_path *path;
> @@ -1964,12 +1988,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>  	if (!path)
>  		return -ENOMEM;
>
> -	subvol_info = kzalloc_obj(*subvol_info);
> -	if (!subvol_info) {
> -		btrfs_free_path(path);
> -		return -ENOMEM;
> -	}
> -
>  	fs_info = BTRFS_I(inode)->root->fs_info;
>
>  	/* Get root_item of inode's subvolume */
> @@ -2048,15 +2066,79 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
>  		}
>  	}
>
> -	btrfs_free_path(path);
> -	path = NULL;
> -	if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> -		ret = -EFAULT;
> -
>  out:
>  	btrfs_put_root(root);
>  out_free:
>  	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_64BIT
> +static int btrfs_ioctl_get_subvol_info_32(struct inode *inode, void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info = NULL;
> +	struct btrfs_ioctl_get_subvol_info_args_32 *subvol_info_32 = NULL;

Maybe these two variables could be declared with the AUTO_KFREE helper,
so you could remove goto's and the cleanup section in the end.

> +	int ret;
> +
> +	subvol_info = kzalloc_obj(*subvol_info);
> +	if (!subvol_info)
> +		return -ENOMEM;
> +
> +	subvol_info_32 = kzalloc_obj(*subvol_info_32);
> +	if (!subvol_info_32) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> +	if (ret)
> +		goto out;
> +
> +	subvol_info_32->treeid = subvol_info->treeid;
> +	memcpy(subvol_info_32->name, subvol_info->name, sizeof(subvol_info_32->name));
> +	subvol_info_32->parent_id = subvol_info->parent_id;
> +	subvol_info_32->dirid = subvol_info->dirid;
> +	subvol_info_32->generation = subvol_info->generation;
> +	subvol_info_32->flags = subvol_info->flags;
> +	memcpy(subvol_info_32->uuid, subvol_info->uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info_32->parent_uuid, subvol_info->parent_uuid, BTRFS_UUID_SIZE);
> +	memcpy(subvol_info_32->received_uuid, subvol_info->received_uuid, BTRFS_UUID_SIZE);
> +	subvol_info_32->ctransid = subvol_info->ctransid;
> +	subvol_info_32->otransid = subvol_info->otransid;
> +	subvol_info_32->stransid = subvol_info->stransid;
> +	subvol_info_32->rtransid = subvol_info->rtransid;
> +	subvol_info_32->ctime.sec = subvol_info->ctime.sec;
> +	subvol_info_32->ctime.nsec = subvol_info->ctime.nsec;
> +	subvol_info_32->otime.sec = subvol_info->otime.sec;
> +	subvol_info_32->otime.nsec = subvol_info->otime.nsec;
> +	subvol_info_32->stime.sec = subvol_info->stime.sec;
> +	subvol_info_32->stime.nsec = subvol_info->stime.nsec;
> +	subvol_info_32->rtime.sec = subvol_info->rtime.sec;
> +	subvol_info_32->rtime.nsec = subvol_info->rtime.nsec;
> +
> +	if (copy_to_user(argp, subvol_info_32, sizeof(*subvol_info_32)))
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(subvol_info_32);
> +	kfree(subvol_info);
> +	return ret;
> +}
> +#endif
> +
> +static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
> +{
> +	struct btrfs_ioctl_get_subvol_info_args *subvol_info;
> +	int ret;
> +
> +	subvol_info = kzalloc_obj(*subvol_info);
> +	if (!subvol_info)
> +		return -ENOMEM;
> +
> +	ret = _btrfs_ioctl_get_subvol_info(inode, subvol_info);
> +	if (!ret && copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
> +		ret = -EFAULT;
> +
>  	kfree(subvol_info);
>  	return ret;
>  }
> @@ -5273,6 +5355,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_set_features(file, argp);
>  	case BTRFS_IOC_GET_SUBVOL_INFO:
>  		return btrfs_ioctl_get_subvol_info(inode, argp);
> +#ifdef CONFIG_64BIT
> +	case BTRFS_IOC_GET_SUBVOL_INFO_32:
> +		return btrfs_ioctl_get_subvol_info_32(inode, argp);
> +#endif
>  	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
>  		return btrfs_ioctl_get_subvol_rootref(root, argp);
>  	case BTRFS_IOC_INO_LOOKUP_USER:

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmoygm0bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZYAED/wJ7eJg7nclCMEoPi0zgLfjQrwiMpScxReUTw8s4AUvsA21Z+UAH4WT2ObQ
h4kZndRV/EiowL41cp0oH0AH5fRVao3GF89G5qeafGePOcWLd44+NGZ6+1UZS7C9
RTFQvrwNSGQWiXWcRtVYVn7nXELkVtZK3HG/EB0pJRxl0YlpQC5E/y7KOpFFOh4H
atL6PuIOTmkEpzDpG7ijdgu8BzlMbaJHEbJ74CzjOfkchdXHtiN/khhkonT6ClaS
tAhCesghtVsyQxkx3ZEnT0LAX8x4whNMvfmsrpdXAdwhpEsxcl2wh4fUL82V+S1G
3QWYm0JqlgWuAzGPSC5sR7ylskfSCU6Ks2+v62ve2rFMjlLKHoyWwG/fr8PIC9EN
riHlyVp6bdTxyuUL5K+R18ducorZql0uCNeo2XKYfBuDiI417JiAePZBNwW8U9mo
GQfk+K2YbZ0lusooKc4IbnOFnebD5i9RY6AWmZOL3mCosY1wn4y0k/mq+o/eMqYd
D08SlXX1G/cYo2ZRzdh7nQhqX0zDsXhoBJwjCgibM3grNooZgNpUImGVzMK0S46L
oKjfy9aZG5Obwsl4KJ3in0jxja5yG/1uCfgu90dktx9hB5P0+LNJRDTaMEIseix6
yeJDzMXNSj9B5QS/wv4XknHyt3zUwZF51gPMPvwKhE5nmc+cqA==
=2866
-----END PGP SIGNATURE-----
--=-=-=--
