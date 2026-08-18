Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3435474F
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 22:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787092915; cv=none; b=j5VbN9O14UHGVhGEuDBHfJqhst7xabldiKv1sP/JullMHBHkGhssQxMnMa23z7xQA7SyXJntkDFwZwmA0iKw5UENjZC3+RdhbQR0JG9147P92BA8CZQYicl1e4GvqUHfBB9Vzu8Q26ZLaEK+VcQNzgxC+2h8VKKiBeVP9jCddmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787092915; c=relaxed/simple;
	bh=K+89LLeFedNPVcrmy9kdRxG93FpVKKgU/gx7AMapCEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cBQ4Z8TQuZxnDng65xNtKcojbDxPJWUxHI8LsTN5Bfi7gDwjCff4et8Fx9QFyxUIcZZkwNQouWf4pzzNCJGvPLo4cw+iQoSOCB06pynIxhKHGEHmaxpinf6DcViNTdkJIzrpnlbPLUjoX7fnc90y13QQam9qEEoODo5F+RasLHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=KH6Z4nNM; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="KH6Z4nNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787092908; x=1787697708; i=quwenruo.btrfs@gmx.com;
	bh=SqEJoaSsjNbeP64Gs2otah4Wsq8V52fPlZI8ruZwxh4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KH6Z4nNMv7YFoygjVX8Z2E/gM/9cZoqJzrL78vXd0W+65K5J5MpKtJvMjzy161zI
	 +OdPrcPGDj2gFZYP/VpKvqqFdPx514hbFucgrdWtzNJQ5yn1bXdNIHsmR/VbMgQ9O
	 qVr3a1DmMY+KsfnXH2uC7GEP2VWTScZbXh5qJpc7zZSFRbXd/HWyNq+3nKqY9eIUY
	 vfuS684i4asXWn8EtiUxO+Oz7WFQu8DtQv6z2FLJts3xrYu2ZksTfiDpLaJXpwhEd
	 oJnUez45kIyxBCjbRnRvUX4/wjqBh1SxueAG1sHKcanpsA5AbTaTr0Hqvm673FVsO
	 DsrJNv8/AUrpeM7uTA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M4s4r-1wwAzE2Cal-00D7J4; Wed, 19
 Aug 2026 00:41:48 +0200
Message-ID: <c96becbd-1f39-486c-8474-7a854af73044@gmx.com>
Date: Wed, 19 Aug 2026 08:11:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: propagate do_zone_finish() error in
 btrfs_zone_finish_endio()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
References: <20260818100037.1366563-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260818100037.1366563-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wT9sxsGGiv+0AoxgYZF9tv3Bdz5fJpEJFprN44wquvM0tsatzxh
 8koZiQlrYbO3zKR4wC9QA/FF5EQhKne3Y0mbHXZAmCbHxVevhwuC+/okaFE0CXsqCHXD8Y7
 iNAaDb9DeNDI5gd5CVMaIyT8m9TATtqJOD9iSdAToTTjgPrDZY/vf/qXcOhJUBrpnXRFgYR
 Q4L4ZrMtBVqy1JLDnizQQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:m7A0nx5hLbE=;X3rwo09Z1mxQXTuIU61ZQ/SCoWx
 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



=E5=9C=A8 2026/8/18 19:30, Johannes Thumshirn =E5=86=99=E9=81=93:
> btrfs_zone_finish_endio() ignored the return value of do_zone_finish()
> and always returned 0, silently dropping a failed zone finish.
>=20
> Instead propagate any error from do_zone_finish() as the caller
> btrfs_finish_ordered_io() already handles it.
>=20
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zoned.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index a016cb471beb..82c2394dd43c 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2713,6 +2713,7 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info *=
fs_info, u64 logical, u64 leng
>   {
>   	struct btrfs_block_group *block_group;
>   	u64 min_alloc_bytes;
> +	int ret =3D 0;
>  =20
>   	if (!btrfs_is_zoned(fs_info))
>   		return 0;
> @@ -2732,11 +2733,11 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info=
 *fs_info, u64 logical, u64 leng
>   	    block_group->start + block_group->zone_capacity)
>   		goto out;
>  =20
> -	do_zone_finish(block_group, true);
> +	ret =3D do_zone_finish(block_group, true);
>  =20
>   out:
>   	btrfs_put_block_group(block_group);
> -	return 0;
> +	return ret;
>   }
>  =20
>   static void btrfs_zone_finish_endio_workfn(struct work_struct *work)

