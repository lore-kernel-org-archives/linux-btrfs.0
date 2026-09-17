Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE25E372B57
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 21:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789681669; cv=none; b=pgShaZLVLoRAS4NaYsgcJnsDOVHNlxo3ly/fmyGffUsaI8Go0MxlSTtRbv9swv0ikRfBzmitCSM5+A5aZ36TbWfnchMD79Cyculg4qBzBncBAkEe7ppVohmhrLbNL6DSqmjzvACY3p53tJev+p/JadS11HGgqvdylza1lLVAz7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789681669; c=relaxed/simple;
	bh=KqLk1P5Fvz4Q+Lzj/nLovjUoEajt2nyIa8SLFq2U6Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EUFQCF6KkJ9Rh3rfjb1UnKBfu+vMEsXlQoUK5Y8Kwj6gug32RVb2j/Z0/UQwzcYfANSYHt6CqTewuW80I2KARi8jMy2rfQRgna01FyK+KiUdtApxdSYQpfJDNORr24HtnqyHE1fguhi5xVPnf1LpU3wX2N+/Ros3RPGmXkEJ9PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Uaz6oZqB; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Uaz6oZqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789681664; x=1790286464; i=quwenruo.btrfs@gmx.com;
	bh=60disEhAiTXIYcRS4Z4+8q6JyBjknNb6OzpfDi9klvc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Uaz6oZqBKVwX/5e5g9TyHztWUR14jh0vtKHzXKlFQ3bUeSTR0+iwxIirWNIREZPM
	 A7H3rGEKjmvdMHunjmJkjQd4n3y6wUfeC2jWiVI4VCwU/7S7aLpEUVhFX6LBEAZmZ
	 rDVawaYzCdMmYzJANN4XPcN6vJ88GCfNem75cb7CZOqPaK3m4NcnVBpd7hEQ9qXic
	 Ui2bHEBt/9i6Bt1ZvupxXafw43LjBcpDkE2aoaR4ik+WYzTS7GBiT5+CUJp60hGa2
	 JWYt41Vgaf5CisJkFT34k6AzUN3UEQc1Lg0UF4S10xPszwhsfik7wmb/eoJLkt2Zo
	 KVf5OlAE2AkaGS6zBw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTRQq-1xClyV3A9k-00J73N; Thu, 17
 Sep 2026 23:47:44 +0200
Message-ID: <04941319-1473-4e8c-980d-a68b5b13bd65@gmx.com>
Date: Fri, 18 Sep 2026 07:17:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix off by one super block end offset
 calculation when writing super blocks
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c5e7ed76826ca4504f5b0bb7de9f5f2e45365143.1789642741.git.fdmanana@suse.com>
 <1fe43f9a18a78de389ef66c699cfa906408285db.1789655618.git.fdmanana@suse.com>
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
In-Reply-To: <1fe43f9a18a78de389ef66c699cfa906408285db.1789655618.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eqImI3ARxwZCR7eeWuAuQ035WmnrpnRUIyOVL4n7r1R3xHmxw40
 jQM1zXmwB1F6Rn7Hv0AISxkD18YNFoywMjFDnM/b3C6D0pNvq35mc8mIh+QH4vch5R9QZdN
 QqzGF+znCHNJNBLvPxCGB/4v+pB8oLVkAALkPOZXovpuyrRxkQIYAEJmdIAod0bqH416AG4
 mt7Py7pPpEFSY3VxVVBdw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2LZ/KC2Nf4A=;q9UuMxted8fH7xikJT3LXcTAp8K
 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
 KUASJKsfpPQRY



=E5=9C=A8 2026/9/18 00:05, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We are skipping the write of a super block mirror if its end offset
> matches exactly the device's end offset. This happens because we are usi=
ng
> a greater than or equals comparison instead of just a greater than
> comparison.
>=20
> Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super bloc=
ks")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V2: Fix the waiting counter part in wait_dev_supers() too.
>      Changed subject.
>=20
>   fs/btrfs/disk-io.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a8535e309b57..90cf0647c47e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3909,8 +3909,7 @@ static int write_dev_supers(struct btrfs_device *d=
evice,
>   			atomic_inc(&device->sb_write_errors);
>   			continue;
>   		}
> -		if (bytenr + BTRFS_SUPER_INFO_SIZE >=3D
> -		    device->commit_total_bytes)
> +		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
>   			break;
>  =20
>   		btrfs_set_super_bytenr(sb, bytenr_orig);
> @@ -3988,8 +3987,7 @@ static int wait_dev_supers(struct btrfs_device *de=
vice, int max_mirrors)
>   				primary_failed =3D true;
>   			continue;
>   		}
> -		if (bytenr + BTRFS_SUPER_INFO_SIZE >=3D
> -		    device->commit_total_bytes)
> +		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
>   			break;
>  =20
>   		folio =3D filemap_get_folio(device->bdev->bd_mapping,

