Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AB23659F9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252957; cv=none; b=cYNuTA/waVZDURzYx0piAqhKduc91DTDwMSD1bt1Lp3C4QDrM6ozSEOQNA7rrHN8iDwD5x33jEkf3FLlTeNfTdTFjf/kw36bDpVfBFuvtZJwTdatOmuyFTkOoKv1LLUA/Rk1q6KpdWWL8/paAHRABMi3eBNlgTLGj0Z5wSKk1R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252957; c=relaxed/simple;
	bh=G2CK0J36Wd+Snz4NC2Pbu4Gxee6KxHRqWWU0bZ0tFWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k8NTAagrPnvx7qfoKsWwQAQkYhtsrIS81uTHZHb5GNqeA/0Ti3VjPpT70ugL3dPOQ7TTHE/nfxJfEeQBqiU6AbNpA6XaqQY4ouBIeROMnkvqPppxTgZvDVtlvpPPdd/jmeyDqYcXnAoR1RVkP6ekOtZ6hjJqhi5Mk2c13LsGXMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NfxLaEVE; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NfxLaEVE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781252950; x=1781857750; i=quwenruo.btrfs@gmx.com;
	bh=OGMTh8FE7mQAQAFBAeG+OYjyfgDbfFlkUog5ftym5yI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NfxLaEVEKFVbgEFah2X6NrZl6Y4CeUE9qf0KeOPBFSDQ1AaMjVoDSxhTiGRnTBp7
	 m6ZTdQlU+zpfC0/hdDDqct/+xW4k0kKEpgvgLBZVIp3ldN4hR4UqTsYc7XJt4wBDm
	 b2KUQV+0fdCDIfvAVfPXPQNCJZKtXkhK++9FqH6AhPbPGbRy/Ks2TKMGHTSzIZ73F
	 JpsmIJ27ButaSXWUAKO8keXJ7FCFWZTZUU/wzI6xS77tHLhh6vbe03LWhG3U84SFD
	 RN97dbs3C4WSoul5CwF5B8OteXB7RO957/oXXZy54NJBIm5mWi6i1u2yU7xQ66/Kr
	 X1BZwCrf+RE37nlnEQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M9Fnj-1wceDi3pYd-00EpE2; Fri, 12
 Jun 2026 10:29:10 +0200
Message-ID: <b99a16ae-e603-4526-9781-afae246c5303@gmx.com>
Date: Fri, 12 Jun 2026 17:59:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix root leak if its reloc root is unexpected in
 merge_reloc_roots()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <7508b925a940bed6bd39f6c9eca5e27be7119bf2.1781187556.git.fdmanana@suse.com>
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
In-Reply-To: <7508b925a940bed6bd39f6c9eca5e27be7119bf2.1781187556.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n4KrOigCCwni82Nul7JKt5fRKgMm98ON1Tin7O7bOqjmjYMnk3R
 w5rBAIyHR8mQWKK8MlUHxpd4/wW6bexiuVkXfY5hchIPB1x5gwzlK03GMH9XvNzcoX4RPdo
 3z3DelbkYMCCEWh0yqg0AOm4SUOe/kFUjzT+bwaSb7qXlAyPQ++4OdMf69ChOv9hUNNweuK
 j4wR8FEBh83Z7cFycs5GQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LcgN1z6BlEs=;9l629ldW/BkMY/p3YCrEJj7OWwB
 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
 0tRAVIpl4=



=E5=9C=A8 2026/6/11 23:50, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we have an unexpected reloc_root for out root, we jump to the out lab=
el
> but never drop the reference we obtained for root, resulting in a leak.
> Add a missing btrfs_put_root() call.
>=20
> Fixes: 24213fa46c70 ("btrfs: do proper error handling in merge_reloc_roo=
ts")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/relocation.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index e962a3ee7a5b..82e64f2763db 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1917,6 +1917,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>   				 * corruption, e.g. bad reloc tree key offset.
>   				 */
>   				ret =3D -EINVAL;
> +				btrfs_put_root(root);
>   				goto out;
>   			}
>   			ret =3D merge_reloc_root(rc, root);

