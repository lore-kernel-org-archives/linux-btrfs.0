Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4406347DF8F
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783373808; cv=none; b=WvekDk+XFVhE2p97YlHuqpDHzJx0mls5RzbHlDyup26IZnVVnh48qk2WDYDMO/OJhSAvAYctH+PvZkXGnpUOPz3s6zTFU2/GLaIUMFlY47G1hKKspa5RA5OLXEE36JVLqIfND8T+37h/Oc+Y8t9iMQ2jwxlEQSKNwsHNRsV8ZVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783373808; c=relaxed/simple;
	bh=V7etPkkQjkPKvkL3uhHico9vTPIdv9AUNa0ch98oIg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jQaGINkXBnbExZSDtEHXVgxbj46JePxvAVeTRPzS23mzgn9g+MKE9XVOkUOPGr79lZGWScenN5tD56hIQVgQad3vxER8z53hegnPvkBGybdJaESNI4PDATNuk8tjfZQZhaJVRZ5bwoftesI/ZUmZFhB/QgSdZA+0BApdmgHgqYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=me1w0K/5; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="me1w0K/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783373801; x=1783978601; i=quwenruo.btrfs@gmx.com;
	bh=9UZs3S41WWmByQbtYR84qwjYc4qUlNYgOkMJZL4BeVI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=me1w0K/5RBsSUEH5Fe64nNBqye70wBkbaAEJxDjWHzlCNTX+fRzVskjtm0qofj8B
	 x4bL7djioUP42bPFz3nFuiemODxUN8X9nNpu4VT3jcwH8dqHa7N5+VZTe4zk9cPVJ
	 T8iywYksAXmAgnRvTNA2aacxbgUmeuQetk5JA3Y+FAswYzO+oQeyHFJHdp/ssy8/4
	 h+2+XXZ0tGgX/v1hHUBT4nmI6Dynb29jz6BNa4C5GlphfgPez4dXFwJX1GdJxY86F
	 46MEftvIQ69zWqFDWvJGYg0GlejbuZ4/P5NawNU0nJQxJSGhTJlFgo/QO0ni4MPN6
	 lYOYR3BCkekALlqRww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M7b6l-1wiCJB0g61-009QcF; Mon, 06
 Jul 2026 23:36:40 +0200
Message-ID: <bf4ddfb6-6d8a-47af-b121-891fe7410078@gmx.com>
Date: Tue, 7 Jul 2026 07:06:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: get rid of useless label in
 btrfs_create_dio_extent()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <74bcf9563b76639f84210fb5ee006d5a865280c0.1783338152.git.fdmanana@suse.com>
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
In-Reply-To: <74bcf9563b76639f84210fb5ee006d5a865280c0.1783338152.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RKh4DlY5zA6kuaEXlB/N+cFDmUrrRyGBd/ozR2Vo2M0ajIP0Vzv
 A5Yk47AsZF4r+WfgfUKuKzJvlGkF1biGkwDnIsEn/IfOHqpgEhd+UuXzk98E9GvBXgj3uYM
 oo4NGiC9KCd+Zi28ddX3f3IFPzd9I2tSGOKSUALPI52kj17A8hnJ0Lvcu5rACwV30QS+2Mj
 uyjrU404IoLBkjDp1KeTQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QzgEucSu/UI=;PkCNcZiW1NdnZ9T4h/EHYH2vs0Z
 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
 0+A2Rw==



=E5=9C=A8 2026/7/6 21:14, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> There's no point in having a label where under it we do nothing but retu=
rn
> a variable. So remove it and directly return where we used to goto.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/direct-io.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 27d227f5bdc0..ed1779ccb4de 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -150,7 +150,7 @@ static struct extent_map *btrfs_create_dio_extent(st=
ruct btrfs_inode *inode,
>   	if (type !=3D BTRFS_ORDERED_NOCOW) {
>   		em =3D btrfs_create_io_em(inode, start, file_extent, type);
>   		if (IS_ERR(em))
> -			goto out;
> +			return em;
>   	}
>  =20
>   	ordered =3D btrfs_alloc_ordered_extent(inode, start, file_extent,
> @@ -167,7 +167,6 @@ static struct extent_map *btrfs_create_dio_extent(st=
ruct btrfs_inode *inode,
>   		ASSERT(!dio_data->ordered);
>   		dio_data->ordered =3D ordered;
>   	}
> - out:
>  =20
>   	return em;
>   }

