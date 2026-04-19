Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2A120FAA4
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 00:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776560254; cv=none; b=X9G+gTP4zftmWhsezbsVIltoV75rB21OSe1BZwPYQ+1uwdF2ugbsHMveeNAuLFcbpMjk3Tu1GnfeAIQoOflQbaDfOqQ9xfJjpoyeDORwpuWn7m6UUuanleXgMiW7ydev3Yil13dBrccK8kLbX8efzt4+oVolYuRFhGgQSBHiWA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776560254; c=relaxed/simple;
	bh=Ii6/FMqpjlRFVL/MRC41FudjSyAZ0GZ0Uy66blZ6jJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bhaUH7S84q2JBZFI+WuYQBEiWAtkT7EXRAJMvxmObt/TW96E0b8wHq+M+tEw0SXps7ExuUqq3INqOyFpJeOrQ02Q9+VON/LszAY2pMJUc8URhKm3q7mjprY86NnF7O2m+wo10xL4kryJ5OW3EN5a07jNgLINHE7nRat0YuyesKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=D7AdXfnK; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="D7AdXfnK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776560250; x=1777165050; i=quwenruo.btrfs@gmx.com;
	bh=GORuB+rBzbU8xjQaYd+fAWbqqcqrrDHGyKSnoWGHNQw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=D7AdXfnKfCto0O7INDQbiZmYxbWVdgMme5eZl+BjAiQd7le9J5gI/WszqnOoHDrN
	 sElC+mZOPaK42dDN7KczFGOQQiyFZG7pL1C1zjDYG9fCn36m16BivS3ZSA5je//jI
	 Jv07La1EgL9J/EedWMFTxSD8rrA+g9/ABW0GwAdAg+oGO42jgimPmFx60Tg9pqH0R
	 lTOf723VKP+8YZE300jLnbNnLWK86YHRvONe3bx2GW71LCCSiIFEu863qmu3Eswj1
	 lKEWYywQdjOzSxp2T3DRvLkKO+vRsLShs9aho/ugDoONsH0H2hQCSBiTDngbRAsp3
	 FzbdQncdy8CusYZDOQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnpru-1vdX0724FO-00ZaRd; Sun, 19
 Apr 2026 02:57:29 +0200
Message-ID: <2262d02d-e530-4083-9a08-dbc3d553c1b0@gmx.com>
Date: Sun, 19 Apr 2026 10:27:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: refactor btrfs_fallocate() ahead of supporting
 more modes
To: Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <20260418143808.199603-2-paul.richards@gmail.com>
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
In-Reply-To: <20260418143808.199603-2-paul.richards@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:J3frEGOrKDbneBcICZofrVd9XGBKum05651q60o+aBpDK5aVr9m
 0lxHUnDeZReJ3M30t4IxNLtji2iVCe4Hqv5T5LjMYgd0mrofWWhKIwU+WMrYKZvziJNkD5B
 0MfqE8EXbhfh3j0PSZoRaevKWgpjlBZAomb/kY8gku9xL3fuSOf6qwuJjvms1nV6H2oGWmg
 z02QKZgPXQu6ZZjhREK3Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tKt2kXVQipY=;gAbZxhDRrOTFFAbTiYKj/RUMdVI
 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
 Je696Mxzvd+hh8Cvo0iUbBnQ==



=E5=9C=A8 2026/4/19 00:08, Paul Richards =E5=86=99=E9=81=93:
> Refactor btrfs_fallocate() to switch and dispatch based on
> the mode argument, splitting most of the modes into separate
> functions. Only the "allocate range" and "zero range" functions
> remain coupled.
>=20
> Signed-off-by: Paul Richards <paul.richards@gmail.com>
> ---
[...]
> @@ -3115,27 +3113,12 @@ static long btrfs_fallocate(struct file *file, i=
nt mode,
>   	int blocksize =3D BTRFS_I(inode)->root->fs_info->sectorsize;
>   	int ret;
>  =20
> -	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
> -		return -EIO;
> -
> -	/* Do not allow fallocate in ZONED mode */
> -	if (btrfs_is_zoned(inode_to_fs_info(inode)))
> -		return -EOPNOTSUPP;
> +	ASSERT((mode & FALLOC_FL_MODE_MASK) =3D=3D FALLOC_FL_ALLOCATE_RANGE ||=
 (mode & FALLOC_FL_MODE_MASK) =3D=3D FALLOC_FL_ZERO_RANGE);

Too long line, this can be caught by checkpath.

>  =20
>   	alloc_start =3D round_down(offset, blocksize);
>   	alloc_end =3D round_up(offset + len, blocksize);
>   	cur_offset =3D alloc_start;
>  =20
> -	/* Make sure we aren't being give some crap mode */
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> -		     FALLOC_FL_ZERO_RANGE))
> -		return -EOPNOTSUPP;
> -
> -	if (mode & FALLOC_FL_PUNCH_HOLE)
> -		return btrfs_punch_hole(file, offset, len);
> -
> -	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
> -
>   	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size) {
>   		ret =3D inode_newsize_ok(inode, offset + len);
>   		if (ret)
> @@ -3185,7 +3168,6 @@ static long btrfs_fallocate(struct file *file, int=
 mode,
>  =20
>   	if (mode & FALLOC_FL_ZERO_RANGE) {
>   		ret =3D btrfs_zero_range(inode, offset, len, mode);
> -		btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
>   		return ret;
>   	}
>  =20
> @@ -3282,11 +3264,46 @@ static long btrfs_fallocate(struct file *file, i=
nt mode,
>   	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end=
,
>   			    &cached_state);
>   out:
> -	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
>   	extent_changeset_free(data_reserved);
>   	return ret;
>   }
>  =20
> +static long btrfs_fallocate(struct file *file, int mode,
> +			    loff_t offset, loff_t len)
> +{
> +	struct inode *inode =3D file_inode(file);
> +	int ret;
> +
> +	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
> +		return -EIO;
> +
> +	/* Do not allow fallocate in ZONED mode */
> +	if (btrfs_is_zoned(inode_to_fs_info(inode)))
> +		return -EOPNOTSUPP;
> +
> +	/* Check for options we do not support. */
> +	if (mode & ~(FALLOC_FL_MODE_MASK | FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;
> +
> +	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
> +
> +	/* Only one mode bit may be set. */
> +	switch (mode & FALLOC_FL_MODE_MASK) {
> +	case FALLOC_FL_ALLOCATE_RANGE:
> +	case FALLOC_FL_ZERO_RANGE:
> +		ret =3D btrfs_allocate_or_zero_range(file, mode, offset, len);

I'd prefer to have separate functions for zero and allocate range.

There are some shared code between them, but not too much, just:

- isize check
- file modified check
- btrfs_cont_expand()/btrfs_truncate_block()
- btrfs_wait_ordered_range().

This can be extracted into a helper function, shared by both=20
btrfs_allocate_range() and btrfs_zero_range().

This should make it a little easier to read.

Thanks,
Qu


> +		break;
> +	case FALLOC_FL_PUNCH_HOLE:
> +		ret =3D btrfs_punch_hole(file, offset, len);
> +		break;
> +	default:
> +		ret =3D -EOPNOTSUPP;
> +	}
> +
> +	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
> +	return ret;
> +}
> +
>   /*
>    * Helper for btrfs_find_delalloc_in_range(). Find a subrange in a giv=
en range
>    * that has unflushed and/or flushing delalloc. There might be other a=
djacent

