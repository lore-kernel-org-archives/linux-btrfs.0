Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DA71A681D
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777071591; cv=none; b=ZCbD/UtT9ZS+fyHPyRBuvtt92MMwDeuwrmv6MhdFQ7OEiiTxoCZzL+e7awGQrKnEFIAq6QgfPhCUmYhy53o+xgxLO3VyC0IAu58b/SbWOf5D+ncpt8YOafI/X0qo72mD5kmYZHMbrLLOI7Q/LRGXzYn7b1206MqCH6v2N8mXBoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777071591; c=relaxed/simple;
	bh=GVtsqQpGQoFE+ERZdov7OcoumP7VV2s6WKl1BUp107o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UDxX1VI1Hr18qDjANDMU2Tlg8GjyvfytEzdPJdcQBnGCh6GkXeSjaDLKIgt/R8pwmm3nPMSyEgE0R291Ps9SPMoF6eSEShYsRsP2zZ7oRLpz1sHxX7YuOxB2kpbNsPb7upktbWB1DkiXAcNqDqs7GKFEETJXSQ6vkmLuRz1vBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=srcWevrq; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="srcWevrq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777071587; x=1777676387; i=quwenruo.btrfs@gmx.com;
	bh=345dZi9v6GD54LE9i/n7P42JN6Z2xrGu98FJZuxVZTI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=srcWevrqMoPuj9jE1JwDjfnu5o18ZWbAF7v3hZsNRPRfqWW5LHaalJ3048JniU2x
	 WmvCEMeuwacgqcEW8qR2zSvyz7b4m0pvCJEEu9m9VkLAEHNMrerx07lfK3OlzOlll
	 j0fMTf7zboNlk5T3K7zjAh2+jA9eLrSpz4uE1/4hMg+/w5ruNi9srX8mwJRwWjLDX
	 KhLM87FSpPBQZzOwpc0o0Mmtsx2arjws4AqsvPgILf18sMRz4CkrEkqMiAtCThOUB
	 5sK0J9/hXVYkn6Vt6f87KiBqpEzwbSmsxSvzk8hQRttVqxN6N95gM2Oh7RloNv58t
	 +C/NSJOgbKAwn2Cf+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MDysm-1w8fiw2vsy-006Kq6; Sat, 25
 Apr 2026 00:59:47 +0200
Message-ID: <3be1e1b5-ad4a-41bc-86e5-2be616b17352@gmx.com>
Date: Sat, 25 Apr 2026 08:29:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
 <20260424201054.GA2801466@zen.localdomain>
 <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>
 <20260424221059.GA2970690@zen.localdomain>
 <8bf661bc-2536-4310-a5cc-638b5cd9d25c@gmx.com>
Content-Language: en-US
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
In-Reply-To: <8bf661bc-2536-4310-a5cc-638b5cd9d25c@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+D8U3fbVzCKFpevZYtmxQFI/oKnQW5DtAz54HdF83XPQLspVe7I
 y7pf6MYMXT+dEhALsK5l8gjHEdZXUpVL3LBuJ1hijnt+RYh6bzkDT4TkJhqoqx3CEBt/zaZ
 sSoroixHkkBL06aFFJ7Mgj/icEFTquVZBjmU5rTjJOYb34swOwK+3e+Z444EPxo52/6kjXo
 w0AVRUPIroubYAhKGlcRw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:A2KGQ7JYRBA=;k/ycvCJw/GLipmJOQCGwWOjGgCu
 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



=E5=9C=A8 2026/4/25 07:51, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/4/25 07:40, Boris Burkov =E5=86=99=E9=81=93:
>> On Sat, Apr 25, 2026 at 07:36:49AM +0930, Qu Wenruo wrote:
> [...]
>>> At least we got something that both of us can reproduce.
>>>
>>> Another thing is, for g/027 on arm64 I'm also actively monitoring the=
=20
>>> CPU
>>> usage through top.
>>>
>>> Have you experienced very high (~100%) CPU usage on a kworker during=
=20
>>> g/027?
>>>
>>
>> No :(
>> As far as I can tell the system is stuck waiting on a commit. I'll keep
>> trying to repro your symptom.
>>
>> I'm curious if it goes away for you with Sun's proposed fix, something
>> like setting pages to at least 1 after those to min() operations.
>=20
> I go with the following diff:
>=20
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index e931deb3d013..2c5214b24239 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -770,6 +770,9 @@ static void shrink_delalloc(struct btrfs_space_info=
=20
> *space_info,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 u64 items =3D calc_reclaim_items_nr(fs_info,=20
> iter_reclaim) * 2;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 int async_pages;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (nr_pages =3D=3D 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nr_pages =
=3D 1;
> +
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_start_delalloc_roots(fs_info, nr_pages, true);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /*
>=20
>=20
> It solves the dead looping kworker on arm64, now the it's several=20
> different kworkers taking around 5~15% along with 027 itself taking CPU=
=20
> time.
>=20
> But unfortunately the test case itself still seems not to end any time=
=20
> soon.
>=20
> I believe the old 3 loops limit is really what makes the difference.
> It's ugly, but at least it seems to work.

Not an expert on the space reclaim part, but as far as I understand,=20
there can be some cases where the only dirty folios that can be flushed=20
is the folios that are being written back.

E.g. we have a large folio (256KiB) dirty, and that's the only dirty=20
data folio in the whole fs.

Then at delalloc time, we are reserving metadata, and we are waiting for=
=20
the ticket to shrink delalloc.

Although the ticket is trying to flush delalloc, the 256KiB dirty folio=20
is already under write back, thus it will reclaim no space.
Thus the loop never progresses.

This will cause a semi-deadlock, as we want to reserve metadata to do=20
the folio writeback, but the metadata reserving is trying to flush the=20
same folio to progress.

And the recent huge folio feature is making the problem more obvious, as=
=20
the folios grow larger, we have higher chance to hit such situation.


With that said, it means delalloc shrinking is never guaranteed to make=20
any progress under extreme ENOSPC situation.
Thus a proper way to break out the loop is highly recommended, when=20
there is no progress to be done.

Hopes this educated guess would help to explain the problem.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20

