Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231E288C30
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 22:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782339211; cv=none; b=Y15iCyzILIxxEF+eBdmMGqVhMX6fI6zdbwGJGKH/utT/7z8QPJ8grdH6OgOails66wFuX+CtAjr70BpwWzxJi8LCcmqMmX3R6l5bUNdOqxcdqKANpPg4CViLQ5I2yR71uvVfRsWucUVnntpbcT3ughp6C9z6cgeFutkNEyqv/BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782339211; c=relaxed/simple;
	bh=wHlBpHKvfkjTZRGf99ztGteRQFJVmywwf2Rhya3tEiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FT3dRe9I1Ood8t8ZMXAlTPo1E+4CBMKgMvOdtFoa+2eXz55B1IQBL1IBBMPhEezIgz+GGn0S3DPY4Z9WSq+GgUJbgSgiQtkOObdICEPHcPvg+Etqx26XX906JVF+wtNcyclvRGBW0IriJAg5dJ6EROZuCX8J+Sz6QC08ojlk8/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=f7u61Cya; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="f7u61Cya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782339206; x=1782944006; i=quwenruo.btrfs@gmx.com;
	bh=Vk2belfZjUZv9fUbdo5ZaxAYu0Gb1r00lqS1QCLyGhA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=f7u61Cyaze1P7KfkwGrUmMU0kCNpqdcOPFQLoAak+3XHqe5ebR20SQE2jBoiEb9B
	 YhxQQeg0avPVO8Zx3CXqpOeea3HNkOcFqsGXGYgcbBdkQRWWSgZWKUAa2bKvUarrK
	 R2+Tyk686VRshdPUEhyVjoE6BXtNHVfKPkx3FpgixYPvvEOeik0+IqfNY7XI79obX
	 5b5bFGX0lKCauCdu6LHRsOwnB4HuKtzPY7jwMH210DUmJ0ofbd06I+nPoWhR0rlVi
	 jHFgYovO7T5Pbv/x35iUFYBPgz+Ltk3R8lW+qQTRucA9AJFDVtEfkMGalS+VagaB5
	 2QfEe8mv5iFDd31QOA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MDhhX-1wTT2S49jz-00Cd1j; Thu, 25
 Jun 2026 00:13:25 +0200
Message-ID: <3a8c46ad-3887-4b56-bf44-3528c28c0539@gmx.com>
Date: Thu, 25 Jun 2026 07:43:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove btrfs_fs_info::stripesize
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <8a10be3992b88b143585dd1736998b4479c48b46.1782275006.git.wqu@suse.com>
 <20260624153309.GB150664@twin.jikos.cz>
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
In-Reply-To: <20260624153309.GB150664@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DPB3fSgSUVW3l3FerwVdvB/ikovCOtksZof6esgU2wRj0u24z77
 /PGTXtOYCR5617ZGH8o+M6ftyrvMT4KjXN1u8Pqhz8Z+DUWMSP+rcxXotPshcHqC++LcZXu
 khDVB0HPAG0eymazS4JXOVTvHeq3v3HDeZ26A0ve/BICKq3PGJaDzAFnWxPU7q02CDBuhKH
 l/VK1zq6qvIdmamSlJ9Uw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5hTGlB3/dK8=;u5D6kcDb6heM103osy/vB94W2s1
 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
 KvhQUQiCCvX99zwQWAs4sp4gOwA=



=E5=9C=A8 2026/6/25 01:03, David Sterba =E5=86=99=E9=81=93:
> On Wed, Jun 24, 2026 at 01:53:28PM +0930, Qu Wenruo wrote:
>> Btrfs does not support variable stripe length yet, all RAID0/5/6/10
>> chunks have the fixed stripe length 64K for now.
>=20
> The question is if the 'for now' will turn into configurable stripe size
> in the future. This was the plan, but long time ago. I think we can
> remove it anyway, the code is no-op and adding proper support would need
> more changes that just that.

I'm already working on the per-chunk stripe length.

But even with that feature, we're going to respect per-chunk stripe=20
length, not the global one.

So the existing naming "stripesize" doesn't even make any sense.

>=20
>> Furthermore, btrfs_fs_info::stripesize is not the real chunk stripe
>> length, it's always the same value as sectorsize.
>>
>> Remove btrfs_fs_info::stripesize, and for the only callsite utilizing
>> that member, replace it with fs_info->sectorsize instead.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
>=20
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4757,7 +4757,7 @@ static noinline int find_free_extent(struct btrfs=
_root *root,
>>  =20
>>   		/* Checks */
>>   		ffe_ctl->search_start =3D round_up(ffe_ctl->found_offset,
>> -						 fs_info->stripesize);
>> +						 fs_info->sectorsize);
>=20
> This seems to be the only relevant use in case the stripe size would not
> be equal to sector size.
>=20

I think we can even remove this one. As the extent tree should always=20
have everything block aligned.

Thanks,
Qu
