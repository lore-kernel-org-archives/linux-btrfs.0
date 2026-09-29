Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731F452CCED
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 10:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678266; cv=none; b=mXGXinXw3kjBYPpF1ZuK74OxM/bFBpCCkqLnJC4lYJPb2WWpk6IMzc/LtAXAIftlEWJIyPDP5h95VxIVNmJ2mmnB/P8PU1ptVpst4EiMmu3tcLaiP9layZU7p9NRaVmkFwS6PLtEMNfnzr7GTxn7rxIOhxmENCvGMaDFfT/w89k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678266; c=relaxed/simple;
	bh=PfC6WvwI6aHKn9Rtn050gItIu/O3iXD1NAshMWsOR80=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lqN7lEATKw5HjoJLfBOAbYO7kjwj3yuhSNavG8yK01mrNJ9aXXBjasEVdQo7i2usLmmwlQeOGnZFVdmRUxooYUUkKYCi6fPoXWlu6vvy/TYEotaBMqt1GTos9yKt7iYIq4JJHq9djmxc9jWXoFh13WKYIAESs0KJBP3m20zuYJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=GCLsgUpN; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="GCLsgUpN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790678249; x=1791283049; i=quwenruo.btrfs@gmx.com;
	bh=oAji5vvSZGCnhuCjZdrYgEfEWAuVV4n8qHtxOzi9Qm4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GCLsgUpNkrX2OwEszRifESJY8fRCYJlkB1R0yeoj2rG0r65t2Mlupfkqjsuln31J
	 iwScm+ZIDBCcQ0o61rBjhdyGvO3LWMUfdvpr+/SgXZdFzcFF4bsr7aFUcPbatfYJP
	 OgN+4g/B5p5aSrDv9u5M1Tf/rs5JcbzYGxjolJcn8oueQDEiY51KgyEl8JrpARaNK
	 yvuQLSDmVEG95hJBwqfIgh0xAOEjGXcSNZlo0P/SaVehjy3JMo7z6X7rVY+8p3fpg
	 v96GUFhrrRUqqce4TWt0Tu9507NAlLxaDeITxIRcHTfCfazJ5g6933kha33Qz51P+
	 dSBXOHAld8sMNkFWEg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N5G9t-1wltHB3gt3-00u6vz; Tue, 29
 Sep 2026 12:37:29 +0200
Message-ID: <1ba84f08-92d8-4add-9e19-82f47446de87@gmx.com>
Date: Tue, 29 Sep 2026 20:07:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: receive: fix unused variable warning without
 LZO
To: liuh0329 <liuhuan01@kylinos.cn>, linux-btrfs@vger.kernel.org
References: <20260929071421.1114640-2-liuhuan01@kylinos.cn>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <20260929071421.1114640-2-liuhuan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7YKauGiP+G8I86MbKDFg/QwA2NNAjl2DjIShKtNL5bF9hkFxrTd
 pcexoqmWIIXWsjBXZkWa/VuzUIRTquImU/24nBnm+1ceEkyVyUQu1Hd1aJzdWA9fQ1/bbVz
 RD9IvGJ7v1fpwvBWLmh50J4shL35GR9RWgmWlBZZPwqW2ugYMPkb/ZqkSKSsyTFw2twQHlJ
 Ol4w67hRupUoLUV3lkotQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FTCGRq9+I2U=;JdMhje85lEYgMIuSOqv1txdDYPA
 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
 TQ4RF6qKqf0LdYjHVqdQzGKAAQ==



=E5=9C=A8 2026/9/29 16:44, liuh0329 =E5=86=99=E9=81=93:
> When btrfs-progs is built without LZO support, sector_shift is still
> declared in decompress_and_write(), while all its uses are guarded by
> COMPRESSION_LZO. This results in an unused variable warning.
>=20
> Guard the declaration with COMPRESSION_LZO as well.

Just move the declaration to the only usage.

That makes more sense than introducing new #if block.
>=20
> Fixes: 345731fff32d ("btrfs-progs: receive: optional build for lzo, zstd=
")
> Signed-off-by: liuh0329 <liuhuan01@kylinos.cn>
> ---
>   cmds/receive.c | 2 ++
>   1 file changed, 2 insertions(+)
>=20
> diff --git a/cmds/receive.c b/cmds/receive.c
> index 49103ea3..14a9ba03 100644
> --- a/cmds/receive.c
> +++ b/cmds/receive.c
> @@ -1186,7 +1186,9 @@ static int decompress_and_write(struct btrfs_recei=
ve *rctx,
>   {
>   	int ret =3D 0;
>   	char *unencoded_data;
> +#if COMPRESSION_LZO
>   	int sector_shift =3D 0;
> +#endif
>   	u64 written =3D 0;
>  =20
>   	unencoded_data =3D calloc(unencoded_len, 1);

