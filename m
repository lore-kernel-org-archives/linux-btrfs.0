Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F1F43B4B9
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110302; cv=none; b=AWjsXIqElTgmllsIcKTXbWb3uS2wH5CCoFyVlajpjy3OahiiesNtKEnlBpRTcps0FWb74B6fvumt4bpmb7E83BqP4oPGmBewSAhCUpBH53NT7FZIk2OnQQyTiKNr1tJYvFuD9tqgDruSTZwjH5rfUAVp/ICZpmXPw698ZNOYV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110302; c=relaxed/simple;
	bh=UuIp8ml5+VmG0JUYZ40RbeDZ0muFsxR25B9gTpryDqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DSin6YC8QJ+S7oHb4+9Pv0ptLItEKPuxL1AEiyRizuYRTM/ld5tEn0p1wBu3pS+We7DDSVsqMQbw1TznFvB4SnrbhVJQ1iYCZua6sGIGwlswzlDL3vq5eKIInA2UOti5+e1geVc6W5KD5myXC/ttSkgEqKeg4mgNqUWazxqxzyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MiNPH3t1; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MiNPH3t1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784110298; x=1784715098; i=quwenruo.btrfs@gmx.com;
	bh=UuIp8ml5+VmG0JUYZ40RbeDZ0muFsxR25B9gTpryDqg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MiNPH3t1UmDt64NXfKDNQFg6YUK98/N79DzjVChZEYpTsFnwoDPSKV4G2J+42CN6
	 r0J9BfXTq6vwBac7wUIHPuWI9f5jhSFmnfz2ZbRt14IcGepatSIdnRf1oqbGHZVYo
	 NboYEJO845amJZuqPkQXZ66JtA+1fWPTpIqefYStlT8S75gtwEx6284fYBjSuA6cg
	 DkkPnhYpAxCwJGywysJtU4pK6b6ubPeGdtVzCQPyPOV8/NbbCzvLYpcfSFizUSyCo
	 FMT7+O6RX9vot4CGl4S4y4tS28j++OH5gtVs7a0m59uvkV8NwNmjSy2dd1gd6Nlrn
	 UASyCnpoZFNbiuT7zQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MIx3C-1wTv4V1NnO-00PvH9; Wed, 15
 Jul 2026 12:11:37 +0200
Message-ID: <4674023f-1b70-4be4-ae0c-c65669901feb@gmx.com>
Date: Wed, 15 Jul 2026 19:41:32 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Zhang Boyang <zhangboyang.id@gmail.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
 <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
 <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
 <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
 <ebf9c527-2181-4afe-b88a-4d24fda6d8d9@gmail.com>
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
In-Reply-To: <ebf9c527-2181-4afe-b88a-4d24fda6d8d9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:x0Dd2GGo833LNH0PDyrObMXhnRh65NTtYBKwYdiVfT4cIiOvVL+
 1fxH34WWizoNliBCqWru9n4jm0Fo5rLkeesdmO0AOLE+hMetD6Qspn+gqiMg8cIBtme/aVO
 Rgtk7pWt3KAokMP/bO25r8Dpa/nXMaX3GFYgiQmltqlg03mXJXworDMtJZeOvLRvwYcq6kB
 HCurOK2pCLeJslv6AlqoA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:raoqxztzBsE=;35PcEUelVgYS+tD8CS19zcEobYx
 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
 vbcUdA==



=E5=9C=A8 2026/7/15 19:37, Zhang Boyang =E5=86=99=E9=81=93:
> Hi,
>=20
> On 2026/7/15 17:44, Qu Wenruo wrote:
>>> Personally I like the idea of turning metadata trees into merkle=20
>>> trees (so I wrote it first). But since you are the maintainer, I will=
=20
>>> let you decide which way is appropriate=E2=80=8C.
>>
>> I'm not the maintainer, I just default to not trust ideas/features=20
>> from unproven contributors, especially when the idea/feature is not=20
>> simple.
>>
>> Especially considering the increased patches generated by LLMs.
>>
>=20
> I understand your concern.
>=20
>>
>> So my suggestion is, if you really want to do long-term contributions,=
=20
>> stop coming up with fancy ideas, start from basics like doing proper=20
>> fstests runs with various combinations, report real bugs and fix=20
>> simple ones by yourself.
>>
>> Earn your name first then consider fancy ideas.
>>
>=20
> That's exactly what I'm doing. I'm not requesting devs to fix this bug=
=20
> immediately or implement my fancy idea. I wrote two test cases and hope=
=20
> it will be helpful to btrfs development. It would be better if these two=
=20
> test cases can be merged to test suite.

No, we will not push for test cases without a fix.

There is already a known failure, generic/747, and at least I'm not the=20
only one regretting pushing that.

>=20
> I even wrote a draft patch to fix the second bug. However, the first bug=
=20
> is not easily solvable. So I had to discuss possible solutions. If=20
> possible, I would have written=E2=80=8C a draft patch for the first bug,=
 too.

This is already what I call fancy ideas.

Anyway, this will mostly just get yourself ignored if you really choose=20
to start from fancy projects.
Those long existing problems are still there for a reason.

If you believe you're smarter than everyone else, then go ahead, no one=20
is going to make you change your mind.

>=20
>=20
> Zhang Boyang

