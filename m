Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C4E299A82
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786326880; cv=none; b=aL0oxQODwSff4saoDeVwiKDOV6cKY5L5faf6BGqsgp9flBUquUSc5ZMlr9dYdgh+RTitrEKW2t1T1GMUbVmdqoLcvB6Shvh7V4NOmaolYvRJTPspzlKVxocjwov6/6jFoWdsH+fWHMz1XgGMRD+BGQS5mSObp4Cn0ho7z3zUmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786326880; c=relaxed/simple;
	bh=EMY9kv3RoJ/M/PXrptF3FXsZ+h3Al1dXrMbFcRJeNnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=butABs8fNDZnU3+nJpxqaQGMp4fC0JZ7dQNwXzOEqDn6UItgjqS/4enW5sg5FdejQZ7Zyb4rfTLLn0e7A1x08yzhPYXOSKLn2JOU5gsQvYn+WhbSy5BGz7Yk+vE6BwmNNSFdxWOPvNiyGi2NXqv3n8honCPEBielJXoZIgpM5Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VynZU4Bd; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VynZU4Bd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786326872; x=1786931672; i=quwenruo.btrfs@gmx.com;
	bh=RXovHbUfX0TKh8lD/4UCA3Y2Sha/OyCKKr5IoPdiRl4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VynZU4Bdgtt23RpfAopuKjfPAjn/DIDgrC/BPF2sKscOxBxqkfT5gn841gAehcTz
	 p/INAiFqgzYseMjlxHiDCBWUVg0lCJGSK7aGWUd4sUHVbZfEN71XucXdMff3BCWUC
	 mHT3i8mIuBIgxFnMAf7OFOcrOT+Vqelpm8s3lDChe48odH2MdDUlNClzUszSXKWUB
	 KHpffzVmNlS1C3F/2HEPfDvsxlIS2qzKyTaWePo4Y66zas6rGIM+/vMRg6Ng8jIvr
	 V5jForhU/iLfyaGRao4nynBawemk6N5qMeYRwLT7EkzSxwKnJCrqTjDqNskqPSgcx
	 KigPawx4IIzVMXaGUw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MqJqD-1xFdTg3gCx-00lYAP; Mon, 10
 Aug 2026 03:54:32 +0200
Message-ID: <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>
Date: Mon, 10 Aug 2026 11:24:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, Qu Wenruo <wqu@suse.com>,
 Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
 <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
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
In-Reply-To: <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dmZ/AIsg4RsU0qKWuFDeu5vgUYdIrT6y4cVk6kQCtpQQHuz/JdC
 keZy8HgPNra2EMo3vtupLuf+uwSmlBsliR5UZ4abzYRpQJ+XZH1ExjLta+VSMaKcWjxxjHQ
 dugmqJfAW8MSVzc2F1JTpCHh5RgpljKv/q3aaCfQs/hiXeOM7uVSaM3BSS4E85aq1mykQGD
 1Y2icwj19PiUBWq1t2DGQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:uxnznoToxTE=;Y4DNNrwxXAiaDTgzwoZNdl86si0
 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
 luowY0IoPb0oihQTGtadYkvgus4I=



=E5=9C=A8 2026/8/10 10:35, koraynilay =E5=86=99=E9=81=93:
> On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>>> So either option 2 or 3 would be fine to me. Although I personally =
prefer
>>>>>> option 3 a little more, just because it's much cleaner code wise.
>>>>>
>>>>> Option 2 preserves legacy behavior that is 12 years old now, and it
>>>>> costs a single comparison in two 'if' statements.
>>>>>
>>>>> Option 3 makes an already confusing situation worse--it makes the
>>>>> underspecified behavior change depending on kernel version.
>>>>
>>>> One should never rely on something not documented in the first place.
>>>
>>> Option 3 prevents existing mount-option compression level specificatio=
ns
>>> from working when the attribute agress with the mount option; otherwis=
e,
>>> they would be blocked by a btrfs.compression string that doesn't speci=
fy
>>> a level.  That's a _regression_.
>>
>> Let me be this clear, the current one nor option 2 is not working eithe=
r.
>>
>> If the current algo is different from the XATTR algo, it will be
>> whatever random number clamped to the XATTR algo for the current code.
>>
>> This applies to the option 2 solution. When mount option changed, the
>> level will suddenly change from whatever previous mount option to the
>> default.
>=20
> TBF, I can see how it could be useful (or rather, how it could be good
> to have it as an option) to have some files with btrfs.compression=3D"zs=
td"
> and then use -o compress=3D to decide on the fly how much compressed the
> new data added to them should be.
> Both are (read: will be, after the per-inode patch) 1 command away, but
> there *might* be use-cases where mount is more suitable.

To be honest, with the proper XATTR compression level specification, I=20
think we should even deprecate compress=3D mount option, and make the=20
XATTR one the only recommended way to specific compression.

There are already too many corner cases with mount option.

IMHO, a good design should allow and only allow the best way to do a thing=
.

And option 3 matches perfect for the XATTR only compression future. It=20
still allows old XATTR to work, have a very sane default level, very=20
explicit and clear independent from whatever stupid mount option there=20
could be.

>=20
>=20
>>>       https://wiki.tnonline.net/w/Btrfs/Compression
>>
>> The first URL doesn't even resolve here.
> (for some reason it's down right now :(, it was up < 1 hour ago).
>=20
> Best,
> koraynilay

