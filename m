Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417953385A1
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 11:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781609165; cv=none; b=CHJYRz5o1a8yCw6WmeND6wr0NM42PFj41WMsmpalf4YHa9b6S0TO6IkahJ0wVL+49543YG3Ok4Oq9L6h855f3H1sFQM+LXnoil1hDJSr1Btl/CENGrJguElu/o0iW+nrgamTuEvLNUyUE7bUgVf51FtE1swKH5XW/gNFFcSVLl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781609165; c=relaxed/simple;
	bh=AiY25kML1frPc6fBoQ0C2hIm6IB7OsF0OA0JSNvJEtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdPSiPS8vB+wFNeoGyEfmdALsm+rCjpvadsjPDKw6fiEeh9AmOq5hHKhQQy1Qw2WHDkzRmWY/4F4Ztd/74+Yzk54JpyoduLv9+a79QtzTshkikVIBSDAjhHzONe77O9c60o5Mofup0QR3xgG1VCVivsQqx3QS8hKaRhILJ4ScwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MeMNHzYs; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MeMNHzYs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781609161; x=1782213961; i=quwenruo.btrfs@gmx.com;
	bh=hKTty0Lt6tSAcz0flh8Qsl2qvR3jcgMryJHGRDM58N4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MeMNHzYsB5GPmcCVPTlabJfoZ9n7Hara9ffZgFy53hq8rH3WXpRUJB9aVryDT4+m
	 u59wXstQjm0YNdvbrNmyZF96/Lv1U5yRDFm6TRV+NgfuPTqPI/+YPUqGkikJMQQ76
	 7imr5eh/sHOANPefvkioDNmW37MYMnDE+B7GFQW81P6m3ue2foyuHTAe6IwiQ7vxF
	 EZiPl3ti2JAXbbNyvwLBFEfuWZ5sCPpM6VTWOvgeObwyKvu2p9anZQjUUyosiRNb5
	 ivhBS03IyabMMGoO2Zy0RggrAfOkYZxi0NleRnjz2GyTWJtbnoD6Z4TWOUpkAJRlQ
	 /kjG4AnvLMlZs9AIng==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M59GG-1waYOK19am-00CtND; Tue, 16
 Jun 2026 13:26:00 +0200
Message-ID: <a9e2a26c-772a-4c4d-9290-9ecb1038d4a5@gmx.com>
Date: Tue, 16 Jun 2026 20:55:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs-progs: re-enable tree search v2 ioctl
To: You-Kai Zheng <ykzheng@synology.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <780847cd-3fa7-4b17-af33-0b84bd125cbc@suse.com>
 <20260616104308.2159912-1-ykzheng@synology.com>
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
In-Reply-To: <20260616104308.2159912-1-ykzheng@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RCBG//TL8yhJ8Kji9yKlteFHLRzXDeCv4O7iAOo9ye6T49OvI+x
 ZqAuGyXvYrA8aP64hQWBHRruS7jHe8WLI4yy7PL2OCv2xr3jNHJv0yh2U05bDz7iUfDXiHj
 YKBc+1Z6XLGDHPrXww5gkGu1ExCaQZoU9oBGDaEQ215cLjr61+6jY5MZ5qWv/erjwKUcVlx
 UixT4duU5zCRDgdxhrErQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6TovB09hs7Q=;yY85A3C6FsM+qTFvv447LKnNm7y
 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



=E5=9C=A8 2026/6/16 20:13, You-Kai Zheng =E5=86=99=E9=81=93:
> Commit d73e69824854 ("btrfs-progs: temporarily disable usage of v2 of
> search tree ioctl") turned off TREE_SEARCH_V2 detection because it led
> to an infinite loop in load_chunk_info() (reachable via 'btrfs
> filesystem usage', reproducible by mkfs-tests/001): from the second
> item in the returned buffer the data read back as all zeros while
> nr_items was non-zero, so the search key never advanced.
>=20
> The root cause is the type of the variable-sized buffer buf in struct
> btrfs_ioctl_search_args_v2: it is declared as __u64[], but the buffer
> holds a packed byte stream addressed by byte offsets. Adding such an
> offset to a __u64 pointer in btrfs_tree_search_data() scaled it by 8,
> so every item after the first landed past the valid data and read
> zeros, which fed a zeroed key back into the search and spun forever.
>=20
> Declare buf as __u8 in all in-tree copies of the struct so the offset
> arithmetic is in bytes, and restore the tree search autodetection so
> callers use the v2 ioctl when supported. The struct size is unchanged:
> buf stays 8-byte aligned after the __u64 buf_size.
>=20
> Tested on Linux 7.1.0; the whole mkfs-tests group passes with the v2
> ioctl enabled.
>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: You-Kai Zheng <ykzheng@synology.com>

Although the patch looks pretty good to me, I'd prefer to hide the v2=20
ioctl search behind the experimental flag.

This is affecting quite some features, including:
- subvolume group
- inspect group
- qgroup group
- send group

So if there is still some hidden bug, we're suddenly pushing to end users.
Thus hidding it behind experimental flag for one or two releases will=20
give us enough time to shake out bugs.

I'll also run a full selftests along with fstests with this patch applied.

You do not need to resend the patch, I can update this one at merge time.

Thanks,
Qu
> ---
> v2:
> - Fix at the UAPI level by declaring buf as __u8 instead of casting in
>    btrfs_tree_search_data(), per Qu Wenruo's review, and update all
>    in-tree copies of the struct.
>=20
> A corresponding kernel patch has been sent separately:
>=20
>    "btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8"
>=20
>   common/fsfeatures.c        | 6 ------
>   kernel-shared/uapi/btrfs.h | 2 +-
>   libbtrfs/ioctl.h           | 2 +-
>   libbtrfsutil/btrfs.h       | 2 +-
>   4 files changed, 3 insertions(+), 9 deletions(-)
>=20
> diff --git a/common/fsfeatures.c b/common/fsfeatures.c
> index 2b19bd6e..9dcd237e 100644
> --- a/common/fsfeatures.c
> +++ b/common/fsfeatures.c
> @@ -708,14 +708,8 @@ int btrfs_tree_search_ioctl(int fd, struct btrfs_tr=
ee_search_args *sa)
>   {
>   	/* On first use check the supported status and save it. */
>   	if (!tree_search_v2_initialized) {
> -#if 0
> -		/*
> -		 * Keep using v1 until v2 is fully tested, in some cases it
> -		 * does not return properly formatted results in the buffer.
> -		 */
>   		if (btrfs_tree_search2_ioctl_supported(fd) =3D=3D 1)
>   			tree_search_v2_supported =3D true;
> -#endif
>   		tree_search_v2_initialized =3D true;
>   	}
>   	sa->use_v2 =3D tree_search_v2_supported;
> diff --git a/kernel-shared/uapi/btrfs.h b/kernel-shared/uapi/btrfs.h
> index 33dc1ae4..a765fbc4 100644
> --- a/kernel-shared/uapi/btrfs.h
> +++ b/kernel-shared/uapi/btrfs.h
> @@ -626,7 +626,7 @@ struct btrfs_ioctl_search_args_v2 {
>   	__u64 buf_size;		   /* in - size of buffer
>   					    * out - on EOVERFLOW: needed size
>   					    *       to store item */
> -	__u64 buf[];                       /* out - found items */
> +	__u8 buf[];                        /* out - found items */
>   };
>   _static_assert(sizeof(struct btrfs_ioctl_search_args_v2) =3D=3D 112);
>  =20
> diff --git a/libbtrfs/ioctl.h b/libbtrfs/ioctl.h
> index 7b53a531..66cdd739 100644
> --- a/libbtrfs/ioctl.h
> +++ b/libbtrfs/ioctl.h
> @@ -385,7 +385,7 @@ struct btrfs_ioctl_search_args_v2 {
>           __u64 buf_size;			   /* in - size of buffer
>                                               * out - on EOVERFLOW: need=
ed size
>                                               *       to store item */
> -        __u64 buf[0];                      /* out - found items */
> +        __u8 buf[0];                       /* out - found items */
>   };
>  =20
>   /* With a @src_length of zero, the range from @src_offset->EOF is clon=
ed! */
> diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
> index 29320b5c..47d9ebf8 100644
> --- a/libbtrfsutil/btrfs.h
> +++ b/libbtrfsutil/btrfs.h
> @@ -590,7 +590,7 @@ struct btrfs_ioctl_search_args_v2 {
>   	__u64 buf_size;		   /* in - size of buffer
>   					    * out - on EOVERFLOW: needed size
>   					    *       to store item */
> -	__u64 buf[0];                       /* out - found items */
> +	__u8 buf[0];                        /* out - found items */
>   };
>  =20
>   /* With a @src_length of zero, the range from @src_offset->EOF is clon=
ed! */

