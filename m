Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1903C7697
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 04:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781583276; cv=none; b=lgJmAQTsKFaCL3BAyx3x6vH63wfAWAhKFae0TzlfYZvpkDaRgYnFUmnFdN5l8bThl5lVb0gvKlj75SWjQ/zfdypoRKCXVOjrzZGEg6zFbX6JODebmeL9FKUjRWjxquJu3/aWFmB2MLicizKkZAWDEzIgMas0RtjAFgLm6axEnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781583276; c=relaxed/simple;
	bh=AoJ6v/Jwo07XnQ5kcZCF6YeEAmhyTrqehx35LBMMlvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KyikB3+Q96n/Zs5EKzdeEEIeBBFk9ruIkmPB6yI/027recv5Mlh+SDl8IWeyTxjCEqz71h86hiBdOlqQ1myLaHqmrRIuFlDEP58nnD7/mEsvER+qDdb43NQF3FXlWgC9M1SsFhZLlr+5QxZQqPLMJLU6V9HRX4gjr5rAroJJgnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=oTv+BbZY; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="oTv+BbZY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781583255; x=1782188055; i=quwenruo.btrfs@gmx.com;
	bh=diLNRr9K9TOjGSxbQ36hvdfxJ/XBzlkgxzfkYDCOjgs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oTv+BbZYWccS2W6u9O1ArF4s9diI6KzCTZ7qDuJJZaz+5/BnyZGXdTWQ0Ef8TVT3
	 ZP/J10cuIeLxZmhB44rag7VSXcrJglCrrygPWsQVFaOK1oIbrXN3CeIYKKxTm30P0
	 Id3FIamrNUvvv1ElPcuUIoF5TDhujsmTArfsQ/IZhv/qVi4t/4Yq/a90yLIzXgDI8
	 iYnFfgVhFvtUR5f0KUXpN33n+CsxxGFgitbXZ6+lO/nRVDX2KzMHBLKbZDc1OY9+r
	 RV/vrNsAq+W5VawhHAAByvVXRuwHBIfqPTbh0V4xejRFFvXjQaJyuz2GU3YPaXX4L
	 vK9BOpxvUanLP1U8Cg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MbRfl-1xArjb2pib-00iviO; Tue, 16
 Jun 2026 06:14:15 +0200
Message-ID: <545cce1f-5da7-410f-8ef2-9779e8864b43@gmx.com>
Date: Tue, 16 Jun 2026 13:44:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: re-enable tree search v2 ioctl
To: You-Kai Zheng <ykzheng@synology.com>, linux-btrfs@vger.kernel.org
References: <20260616040426.1920745-1-ykzheng@synology.com>
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
In-Reply-To: <20260616040426.1920745-1-ykzheng@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NU2djRk43xp8hXoeI+L5cWT4DQwBzd7/RLTzNXwBeVCyJN4bWyI
 rcoUkiQ76yDcT129cYf/ZXXCa7vPkVdLF3WDvG6k134rD9xwY5rswhC5N/TD27lNq1jpV8e
 1mNhQgjScYeYNZ4Mi6ACg/KAa2QmpIOTJqFGSDP7X0U/ub7BSxHfEeE2GOQgdmSLuB3iGQB
 lFLSA4G9oaTGMUXveb3rg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hbUck2AWS4I=;nGa2LpvqIVC+HiicjTEMGdeikaS
 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
 /Bt0Cd3VGEwEloDlKoFwmz4u39A=



=E5=9C=A8 2026/6/16 13:34, You-Kai Zheng =E5=86=99=E9=81=93:
> Commit d73e69824854 ("btrfs-progs: temporarily disable usage of v2 of
> search tree ioctl") turned off TREE_SEARCH_V2 detection because it led
> to an infinite loop in load_chunk_info() (reachable via 'btrfs
> filesystem usage', reproducible by mkfs-tests/001): from the second
> item in the returned buffer the data read back as all zeros while
> nr_items was non-zero, so the search key never advanced.
>=20
> The root cause was not the kernel ioctl but the user space accessor
> btrfs_tree_search_data(): args2.buf is declared __u64[], so adding the
> byte offset to it advanced the pointer by 8 bytes per unit. The first
> item at offset 0 happened to be correct, but every subsequent item
> pointed past the valid data and read zeros, which fed a zeroed key
> back into the search and spun forever.
>=20
> Fix the accessor by casting args2.buf to a char pointer before adding
> the offset, and restore the tree search autodetection so callers use
> the v2 ioctl when supported.
>=20
> Tested on Linux 7.1.0; the whole mkfs-tests group passes with the v2
> ioctl enabled.
>=20
> Signed-off-by: You-Kai Zheng <ykzheng@synology.com>
> ---
>   common/fsfeatures.c  | 6 ------
>   common/tree-search.h | 2 +-
>   2 files changed, 1 insertion(+), 7 deletions(-)
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
> diff --git a/common/tree-search.h b/common/tree-search.h
> index 35eecbe0..1e2fd5cd 100644
> --- a/common/tree-search.h
> +++ b/common/tree-search.h
> @@ -27,7 +27,7 @@ static inline struct btrfs_ioctl_search_key *btrfs_tre=
e_search_sk(struct btrfs_t
>  =20
>   static inline void *btrfs_tree_search_data(struct btrfs_tree_search_ar=
gs *sa, unsigned long offset) {
>   	if (sa->use_v2)
> -		return (void *)(sa->args2.buf + offset);
> +		return (void *)((char *)sa->args2.buf + offset);'

I think this is a problem worthy an API updates.

Structure btrfs_ioctl_search_args_v2 should use __u8 for the variable=20
sized buffer.

Thanks,
Qu

>   	return (void *)(sa->args1.buf + offset);
>   }
>  =20

