Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE017B425
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 00:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786234674; cv=none; b=Ddp8ARiv9cVsjTngW9EX1TgvAjLlFiJBhKrz/BCO0Jsi8JyZzWuLPcOdAAsCfdfxeiWIwGJx/w+fxsqRB/FmEfPBp1B8yVBaeUvEjJn+C5YG+qMcMP0mzHh1mc18E7HFvwpTXktK/a3VIlkaZH+WgS5BuHWRmS41GaKPUk1QLvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786234674; c=relaxed/simple;
	bh=Oo+sr7UsqZctTzn9Hs90arTyE5Czk3xUu0HSq+KHRgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VI+9B1TYODraEJj0YRHwLMrrpuJRzqPTYRSCvJYQbGhIatFiChQWA4DLQdWekChRFDycdCgOMyyh9sAOiIkxWVZgaz3jlsUpOzZo7eG+be74gpLtGbNTBNKX/ROpOovye8EmU286vr1KQPvqVVUv6DAJvNusxz8WjiXTIB1idU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hbrPFSHV; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hbrPFSHV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786234666; x=1786839466; i=quwenruo.btrfs@gmx.com;
	bh=ETrafKCy+OUa7l30/5AgiKLryNsNHlibiDywJ/zTbWM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hbrPFSHVWbttsZvPTyMQEJYglb2J+jgIKUPHv3jeYbJoJwEFewJl5+4WTw2uCUef
	 hORvOHSQmbMwbLmvHqXHtmSozZUI2r1i2oJTuMdvee/3qhdUfw41LEZlcg85dGSUE
	 nex8Hcxj2UoJ2zG1ijzJJ25GnyRXayTDfmSssFUbpg6Txc3ntBqvyGMWzZs2OsK6S
	 NwPDf9XKzxHfKJ+HCbZc+82Ru9cT9xM6KUUFn9pPkmJviTvFPWX41LC6pZNp89juc
	 03mer01yg8lIcymVddXIGxaCcMW8s2DEc8peo8UwFXoY6tP0Bja9c3tBVFOmwk6nQ
	 QMPf0d2BIeRoA9kj1Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVNAr-1wQUbm3mVz-00X3ps; Sun, 09
 Aug 2026 02:17:46 +0200
Message-ID: <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
Date: Sun, 9 Aug 2026 09:47:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20260808023459.1494928-1-koray.fra@gmail.com>
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
In-Reply-To: <20260808023459.1494928-1-koray.fra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9XDlSzcCfk3MtirlTk9TUW7WHhv4yZ5xAvEXjCT+9Pi7OMD47Kv
 dHY3pyfaadDVi4Zs+X/FjpfDqS6mUpR1XosVpaQKriLFzJYZdSW9YSQODivSaIwhjyQEXVo
 +cQ/l8FWEReP/NTW/jvRuUOgvr2uAsE91oWuBHyfSP7/aKTljtjLfmNNRhu2Wk6CjkpGIKw
 fczFScKOcLhV2PSNwFOdw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Chh2FvjpNEU=;1Es19cxSED/WQop5w+4WKqRI0ZT
 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
 dGk2nQNzx2HDeDNncTOmtgjmW6R8=



=E5=9C=A8 2026/8/8 12:04, koraynilay =E5=86=99=E9=81=93:
> Add per-inode compression levels using
> btrfs property set /path/to/file compression "algo:level", using the
> same syntax as the compress mount option
> If set on folders, all new children will inherit the setting, while
> already existing children will be unaffected.
>=20
> This patch series keeps a legacy small "bug": when setting
> btrfs.compression, it keeps the mount option level, even if the algo is
> different (!!), so with e.g. compress=3Dzstd:15 and btrfs.compression=3D=
zlib
> the data gets compressed at zlib:9 (because it still gets clamped at the
> right range). This way the behaviour of chattr +c is also unchanged.

I'm not sure if this is the correct behavior in the first place.

As you already mentioned, zstd and zlib have very different compression=20
level range, using the incorrect level makes no sense (and it's being=20
clamped anyway).

I think we should go the default level when not specified, which makes=20
more sense, and that would definitely be something worth fixing.

Thanks,
Qu

>=20
> I also wanna thank Zygo for helping me by explaining stuff and for
> noticing this "bug".
>=20
> koraynilay (4):
>    btrfs: export btrfs_match_compress_type(), move it to compression.h
>    btrfs: also validate compression levels in
>      btrfs_compress_is_valid_type()
>    btrfs: add per-inode compression levels in xattrs
>    btrfs: support inheritance for per-inode compression levels
>=20
>   fs/btrfs/btrfs_inode.h |  1 +
>   fs/btrfs/compression.c | 28 ++++++++++++++++++---
>   fs/btrfs/compression.h |  3 ++-
>   fs/btrfs/inode.c       | 14 +++++++++++
>   fs/btrfs/props.c       | 57 +++++++++++++++++++++++++++++++++---------
>   fs/btrfs/super.c       |  8 ------
>   6 files changed, 87 insertions(+), 24 deletions(-)
>=20
>=20
> base-commit: a59f57e2aa127c5354168d2ec4bac920df1be4f4

