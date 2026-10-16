Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6923F1678;
	Fri, 16 Oct 2026 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140883; cv=none; b=LzFUL+JPDwfXZwgGvguBSxa0q3kDqQwRsT0JLzZ+4+kOlTx/3rm9pSUFepXT51ZSTxLvXanLHqWAuVVMtjq7ZRAtxKO4CgbgxwfkC9ATPvsgGQS5xKNrzyJQAaVRFrh3tOJjQXqF3u4uJtVMceao0N3DHW7tpk3XM5Z+BhmLyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140883; c=relaxed/simple;
	bh=rBFBQT4qz4Mb0tAtjLefVs91QyeHTadB1EK3Afbhz5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/Dnlqcq8Lahuv9UkE3runD5Y7jJ6bzBwD4w8VZMzg0fAYCisXsIJ9sKgazR0u0uuflRcNGxdQQwj4IyFfywZEg0UGhl8YWfpWf3nxoIaCBKMC8kcUXScmZ9pW8mnBjouolZzAmkbr1DpZxn8q8A7gRnBneGxP2fJLBBHqKuVY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WI1jHhM5; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WI1jHhM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792140876; x=1792745676; i=quwenruo.btrfs@gmx.com;
	bh=bwPymz9S/b07crjozTxF5QHEm2rLQi4KQLqrzHNJI7w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WI1jHhM5Qp6SkCxKMlOTPQTz0EM+8FVjoBWVZEhN9gyrSe8Qz026IrQINWqGNMYk
	 T2XpZ/H8NgdB7p3VKI7SXDaM2+NlYSb/T3l2frcoWykOEPD2rusHylOZrDjCCHQ5w
	 N/0dKSGL2C6iXDGzcx0pcf43ZA/GRn0pUkJKxVC7BkCltFg8g03c12Z3Uj7dBzPDe
	 Wab4rmfD7oygpzhFc8ZEAFaqJ5m440Jgi7w9g9lpOuOtEcN5OHaSfsB0CUZI+XjAx
	 EgkP38ZR63rIl/sBAf7tpPw3mlELzjuxNtA946as25vhYSHJ4XBooE05W98pRJcAA
	 1yewA8FLvQ0nDojvTg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N5G9t-1waDw90A7B-0138PJ; Fri, 16
 Oct 2026 10:54:36 +0200
Message-ID: <4cafa46b-2bdc-4a91-9f33-85d4cb5f9357@gmx.com>
Date: Fri, 16 Oct 2026 19:24:32 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
To: Eric Biggers <ebiggers@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
References: <20261011222613.10793-1-wqu@suse.com> <20261016074756.GD3049@sol>
 <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com> <20261016082422.GA1894@sol>
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
In-Reply-To: <20261016082422.GA1894@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QbChk9rJ7caC3OA/QO9v0mW30TB1sKGZTiohcLAZyFF04qRm07M
 qcP3bbmNWCOuBo8wtLY4zfuVEbMYgI7Jll+YZMX31/pM4bwxEg7zzSIpchuLtgseYC54xJe
 nezUB0Omr24UWxHfJjy1b/0bBK+qAIcTkRuop/xygp62ROLCLXGyRVOeYJZ37dvZuEyhkcu
 TNPWXxd8qyJRSPZba7OuQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YhdJJ8k3xrg=;y9ZHEM3QodUr9v6RA6olZt3pnsP
 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



=E5=9C=A8 2026/10/16 18:54, Eric Biggers =E5=86=99=E9=81=93:
> On Fri, Oct 16, 2026 at 06:35:05PM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/10/16 18:17, Eric Biggers =E5=86=99=E9=81=93:
>>> On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
>>>> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
>>>> +	"btrfs: fix the fsverity callback where unexpected range is verifie=
d"
>>>
>>> Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
>>> passes.  Under what circumstances will this test fail?
>>
>> It need as least 7.2 upstream, which enables large data folios for btrf=
s by
>> default.
>>
>> And I can always reproduce it here, mind to provide more info about the
>> passed run?
>=20
> This is on the latest mainline (2f2f7eeef8b0).  Not sure what else
> you're looking for.

It can be racy, since the fsverity call is at endio time, if all the=20
endio of the same large folio is called after all the reads of the folio=
=20
finished, it can also pass the verification.

But I don't think it's that possible, unless you have blazing fast storage=
.
As the first hole read should trigger the verification for the whole=20
folio and trigger an fsverity error immediately.

I can enlarge the file size, or even git it a loop to run multiple=20
times, but I just can't figure out why...

Or is it possible that the kernel config doesn't have=20
CONFIG_TRANSPARENT_HUGEPAGE?
>=20
>>>> +# Read the file, unpatched btrfs will verify blocks outside the read=
 range and
>>>> +# trigger fs-verity warnings.
>>>> +# But the read itself should still be fine, as the failed part will =
be retried.
>>>> +cat "$SCRATCH_MNT/foobar" > /dev/null
>>>
>>> How about using md5sum and putting the expected value in the .out file=
,
>>> so the contents are validated too?
>>
>> That won't catch the problem.
>=20
> I know, but it might as well be checked too.

I'm fine adding the md5sum output.

Thanks,
Qu

>=20
> - Eric

