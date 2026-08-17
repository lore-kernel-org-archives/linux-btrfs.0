Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F0136351;
	Mon, 17 Aug 2026 02:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935389; cv=none; b=a8TM74giHkXCRJU1bjkRR2iLzAZKk3CgB7mm76evO9NRtj1j6MBFV+ItAN56GKcBsx+rsXY8+m9y21FmK52emgRZTg8ElmwTGG7UK65tGmqzZJAzGxcXiCweqWNZcGRTGkmRr4s9ySD6EqYRnleRhfDm/Q+k+SpQjYz8uWXC5+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935389; c=relaxed/simple;
	bh=8pQddLqDm3PRlibBPDU+VBO/IdXgGNyJdxfvRSSUjng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLo9ZeSqDOOb7logSPzsgNRa25/04pwimGO286fmylWKNHQWs0uXZRV3V2Cl2kK3isTFcNPUMStWTDetl28pnR4NFBoaoQLYqRZBS4L6RGLbgPTnUGBblcjWz2/e1B+o8whl/XpFjC1AMjhVklf/Mx9mXofr/tfKtZtoyTjLUXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Uz+Kl74r; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Uz+Kl74r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786935377; x=1787540177; i=quwenruo.btrfs@gmx.com;
	bh=5MCEdjvuclEEFhlqsG9V33h/lmUiLGhWgm7pFYN6hp4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Uz+Kl74rnugxznTUOeO6ySrq/9KYaLOsP4uu816levmRqOGwVev1TigNAaWJ76YG
	 Ro2R6hN02F1u7aqRQ6fj5ONEOTCyfaw9lMrqQlX8B/GvH8ToUIZJ/j7faCEyqEK/F
	 XNN8pIKmO0oQCY8krPuzn6dSsigLI3iJukoHDWPYmdeM60CwSR9UOp/uqr2AVnhpt
	 Fz+BMA9ItjSXuSL8gYv6mh98PFmGFJl0rX4hmt9T9stl3IJWPxAl0t09qYYuI89Wy
	 s3Sxatgq7SN8IzxnbKq4wML5dz2ffpvKEqEAijwzGMNWTM5cLdolpk2QhcpxJYHMn
	 SDq6DSvwYoQfep0gsw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZCfD-1xQkdt2AM5-00UIEF; Mon, 17
 Aug 2026 04:56:17 +0200
Message-ID: <8e30fed1-5879-4a26-a1a2-d1a3302bc068@gmx.com>
Date: Mon, 17 Aug 2026 12:25:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: handle highmem folios in read_key_bytes
To: Hongling Zeng <zenghongling@kylinos.cn>, clm@fb.com, dsterba@suse.com,
 lizetao1@huawei.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhongling0719@126.com, stable@vger.kernel.org
References: <20260817022012.19658-1-zenghongling@kylinos.cn>
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
In-Reply-To: <20260817022012.19658-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IdJeUXGXEkFVK4x8/tZJWFHiyMtmBZcaeGu0Yq+YuQG7EjPkhem
 2jT+N8l1qKnwt9rjBjmCT+o632yV3Rzsr8z8wS7T4wH9BStWySzzdhCXIILnLqaKUoWfPEM
 kiYCQFJMptyIH6VzWDMLSoQ6HzWaxWv7/6jxN9e29r+Z56X0IKFii8Aq07+wr3y9bS0ilep
 rjLtzggnHeoj5NiUYQeKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bJws0zl+z24=;5SOomsZomZn40C+QNXNL5m24exS
 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
 ZnPi6LiEpkdHce+Vn6LiDTSqegdM=



=E5=9C=A8 2026/8/17 11:50, Hongling Zeng =E5=86=99=E9=81=93:
> On 32-bit systems with highmem, folio_address() can return NULL for
> unmapped highmem folios. When this NULL is passed as the dest parameter
> to read_key_bytes() with a non-NULL dest_folio, it violates the function=
's
> contract (which requires dest to be non-NULL when dest_folio is provided=
).

But metadata folios are not allocated by page cache, but by btrfs=20
itself, which always use GFP_NOFS then attach the folio to page cache,=20
thus should not get highmem memory in the first place.

And there is no way to trigger read from userspace on btree inode, so=20
there should be no highmem folios from the beginning.

>=20
> The original bug had two symptoms:
> 1. Unsigned len underflow when len -=3D copy_bytes executes (infinite lo=
op)
> 2. The folio remains uninitialized because the copy block is skipped

So did you really hit the problem in the real world?

>=20
> Fix requires two changes:
>=20
> 1. Change "if (!dest)" to "if (!dest && !dest_folio)"
>     - Prevents the "counting-only" mode when dest_folio is provided
>     - Fixes the underflow/infinite loop
>=20
> 2. Change "if (dest)" to "if (dest || dest_folio)"
>     - Ensures the copy block executes when dest_folio is provided
>     - Allows kmap_local_folio() to properly map the highmem folio
>     - Actually writes data to the folio
>=20
> Without the second change, the highmem folio is not populated even
> though the read succeeds, causing subsequent fs-verity verification to
> operate on stale or uninitialized data.
>=20
> Fixes: 884937793db5 ("btrfs: convert read_key_bytes() to take a folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Missing LLM disclosure.
> ---
>   fs/btrfs/verity.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 983365a73541..80bc945c7dcb 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -351,7 +351,7 @@ static int read_key_bytes(struct btrfs_inode *inode,=
 u8 key_type, u64 offset,
>   		}
>  =20
>   		/* desc =3D NULL to just sum all the item lengths */
> -		if (!dest)
> +		if (!dest && !dest_folio)
>   			copy_end =3D item_end;
>   		else
>   			copy_end =3D min(offset + len, item_end);
> @@ -362,7 +362,7 @@ static int read_key_bytes(struct btrfs_inode *inode,=
 u8 key_type, u64 offset,
>   		/* Offset from the start of item for copying */
>   		copy_offset =3D offset - key.offset;
>  =20
> -		if (dest) {
> +		if (dest || dest_folio) {
>   			if (dest_folio)
>   				kaddr =3D kmap_local_folio(dest_folio, 0);
>  =20

