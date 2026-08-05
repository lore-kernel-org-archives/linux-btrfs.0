Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C79E23BD05
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 03:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785900128; cv=none; b=cQYMPs+1uEPSOLqkIIX/MESsFeZ0UfES/tsjolO5PgDo6auJvO6o5sNlPfzOHflWmrg1Sbz5S+He8MREdAnUzlyMwhYKiAl5ybvSvTyJ1TJb5ParWYj+vztq/Eh9Q7mTvlP+xJVO3yGVkd/naq9A8gG0WcvYWljPoOlTCX+sO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785900128; c=relaxed/simple;
	bh=OX0c7A94x0npuo6gZsTobcEWunBqiXuPVXqzFWpJr+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sr6Z+ew450hlf2Si1CNFMAZj+gPtkSyOrCfjkyc59Bms+2IsDnAEEkRmNaTpJ/HxvI6VO1bLNx5R9zWB5ESdrfNkDbTwEj2AmOeHt0GJEhPj21FgHqWFTpR9Z/97oNdAygbrxz2GaeHzS5BgJ8HjaGzZg2F8PI0Ms/LrXcjGk8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=RbP0mxaj; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="RbP0mxaj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785900116; x=1786504916; i=quwenruo.btrfs@gmx.com;
	bh=RoKIkPKVOjozR4yarugJytKf3kV6acw2kbXc8PixXSM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RbP0mxajYT80RbipObWrAXRwi2LVEscV/+bm9jgB2PtPAFPRE67rHSLfFHGQqeRW
	 IVUiaUy6Tg+Lk4n3a5SuaxMsqL48qzFmvVuJvccH6NyIj13B0bXhQTxIeADNAF8Wq
	 IuRXL+jIH5S6K20kRMWJEdBjoH3HqI6eDY1YgCcJZuyV9qnHU7SdOA5umwvMoB3Oe
	 7VM2cv+c08+1gxJLVUf8qhzgMxWyTNtSbiY/lZGE9QrUHxR8jTmb7CBxX1apdRuz8
	 om0cARduapu+e877XmRUHAdabgY82jNs7H8P6wItmcY26/H3aeKWY2aQyF9LGT9G0
	 S5f1RJGRcdYJH1ArXQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M5QFB-1wspFO2LRt-004BRA; Wed, 05
 Aug 2026 05:21:56 +0200
Message-ID: <16f7f1b7-4692-465f-9e79-a4d1cc447f69@gmx.com>
Date: Wed, 5 Aug 2026 12:51:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] btrfs: always return -EIOCBQUEUED after
 btrfs_uring_read_extent_endio
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Mark Harmstone <maharmstone@fb.com>,
 Yue Sun <samsun1006219@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20260805021135.1896609-1-yangxiuwei@kylinos.cn>
 <20260805021135.1896609-3-yangxiuwei@kylinos.cn>
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
In-Reply-To: <20260805021135.1896609-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:W/DKRGyUwzcA5tC+nVSwQHpQUuZLWxIHcvW6T2EKbO4c2ir+Gi1
 WgMcdSwbV/ggtCVv7Up/veqKqSuJEfsD+pGK+3IdxFvXMsoXQv7RjgkERBWVkjJ+7kyy/9v
 F/37GMKSFklxcckc7fpq/IZCSLmIL2qQQxhZ6A42fDW4ZddN72rKsxnGBTqyombb6fCcjR6
 lryZPqqdhov0ElQlastyg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/OxZLIYBruE=;rPpBTAV9UomcRiroH58jhluC6sf
 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
 FwRdb7Q==



=E5=9C=A8 2026/8/5 11:41, Yang Xiuwei =E5=86=99=E9=81=93:
> If all bios finish before btrfs_encoded_read_regular_fill_pages()
> returns, it calls btrfs_uring_read_extent_endio() and previously
> returned the I/O status.  A negative errno then made
> btrfs_uring_read_extent() unlock and free while
> btrfs_uring_read_finished() did the same again.
>=20
> Return -EIOCBQUEUED so only the deferred path cleans up.
>=20
> Reported-by: Yue Sun <samsun1006219@gmail.com>
> Closes: https://lore.kernel.org/linux-btrfs/20260630091609.3414-1-samsun=
1006219@gmail.com/
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENC=
ODED_READ ioctl)")
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

Sashiko is reporting errors on pre-existing problems for this and the=20
next patch:

https://sashiko.dev/#/patchset/20260805021135.1896609-1-yangxiuwei%40kylin=
os.cn

I believe they are worth addressing since you're touching the error=20
handling.


> ---
>   fs/btrfs/inode.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b446c3014b24..8e3cee3845e6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9411,7 +9411,6 @@ int btrfs_encoded_read_regular_fill_pages(struct b=
trfs_inode *inode,
>   	struct completion sync_reads;
>   	unsigned long i =3D 0;
>   	struct btrfs_bio *bbio;
> -	int ret;
>  =20
>   	/*
>   	 * Fast path for synchronous reads which completes in this call, io_u=
ring
> @@ -9458,10 +9457,10 @@ int btrfs_encoded_read_regular_fill_pages(struct=
 btrfs_inode *inode,
>  =20
>   	if (uring_ctx) {
>   		if (refcount_dec_and_test(&priv->pending_refs)) {
> -			ret =3D blk_status_to_errno(READ_ONCE(priv->status));
> -			btrfs_uring_read_extent_endio(uring_ctx, ret);
> +			int err =3D blk_status_to_errno(READ_ONCE(priv->status));
> +
> +			btrfs_uring_read_extent_endio(uring_ctx, err);
>   			kfree(priv);
> -			return ret;
>   		}
>  =20
>   		return -EIOCBQUEUED;

