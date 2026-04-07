Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCE8312815
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 22:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775601585; cv=none; b=I79wxQ3RijI1iuixz+hue+iV8PCwAK61aET/E2Fs4nH0JVeg5y9tyKT15JTuVOh6pDLcEh5NI9+Uaxvr/cw6wMY48e+OGtafZ8ABzAoTWrxude7/xn56+2rfljSQeTYHNjW6Lqoisw0y9c5lJYDN1aJiilSm15HocJQRrOF0ybU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775601585; c=relaxed/simple;
	bh=VgtAFYnzc/NqRmhedDuhcjgmkDNC6Td5kvaCV7/m/SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbHhDOEI42/fujonsfocaghsnGPE9lzdu3urgk8rJFWTk7VLc2vMJXNvt7nOhBUv++IJOZg+FH/t+ZUSqNsh2fAH9o2zbJ3R9CEUMFUqo1lCStUlgjlFNSlBTwnk6kWOGsv3bWOZg2Hh2PJqLxoYVHc0HN8WwZiEkoiKwNRHZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=XwC/kwBw; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="XwC/kwBw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775601579; x=1776206379; i=quwenruo.btrfs@gmx.com;
	bh=VgtAFYnzc/NqRmhedDuhcjgmkDNC6Td5kvaCV7/m/SI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XwC/kwBw4Kd43nKrDG+H76lt3Royw+rOXIHKjsuBpazA65YfgzL/1M8Tx3T6dt1n
	 NtCTuV3whMU/wOY93/rEqcvDNFSTKQuVRBM3S8dUjTD7qvrLMUY9i/W+EQ5fhoNRb
	 0meMioADrx553JB0Cz3CcXTEUl0CpHMwMnOvAyYl2CLWMjbJgJ31bJymx4h7F1m9M
	 5HkWbYZE67XT5HLsHC6K60UXVidScLGLkle29woE9BdNeDiYfyoDTka9E4pZAtTLH
	 CqRWW3bZSyziUuzuFn14zZDnpugtcnKJTgVJy+Y7pJ+orIFrBxVl4s0Fnp+CxL0Oz
	 Y6BD+nnHkhWIX/3aCA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MjS5A-1vmUq10FQY-00iJ3R; Wed, 08
 Apr 2026 00:39:39 +0200
Message-ID: <2a47c0b6-4a40-4b19-9832-5ab6fcba0f9b@gmx.com>
Date: Wed, 8 Apr 2026 08:09:36 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Boris Burkov <boris@bur.io>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
 <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
 <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
 <7c2377be-ceca-44ce-8bcb-e201d142b4f8@gmx.com>
 <20260407221322.GA1579772@zen.localdomain>
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
In-Reply-To: <20260407221322.GA1579772@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nT7J+7HtORnn3CP/3ibshZmO3WAxh7HdU/24QVEH/zo50wHGfzJ
 ZLZs2kdY5u5tYAjlG38bgetSqQonQcKwpz5eyXIj4m3J9y1WEkUItKbpW4M6lws869djhOB
 w7eiVox7Yf/7Nto3hBDcxWl47k02lTYYulFEM8So84jaJn7jE4y9Irbym0ZHmmGgcqPnZ1L
 AebMSi8ChDhyeMs6XNEDw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:F5qoxIzxT0M=;Cy7C62l3+jB9b1ZADUmO/DJjUsE
 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
 XtOAzOVH0WOAIax07D9eQq/AruOoN



=E5=9C=A8 2026/4/8 07:43, Boris Burkov =E5=86=99=E9=81=93:
[...]
>>> We absolutely can't give non-root users csums to arbitrary data, that'=
s
>>> definitely a security breach.
>>
>> If getting csums for random logical is a security breach, I do not thin=
k the
>> new GET_CSUM ioctl is any better.
>>
>=20
> Isn't it better because you have to use a file we do permissions checks =
on?
>=20
> So it's not an arbitrary logical, it's a logical used by a file you have
> access to? That might still be insecure against some attack, though, wha=
t
> do I know.

OK, that makes sense now. Although I'm still not a huge fan just to=20
combine two different tree search operations into one, just to fulfill=20
the privilege check requirement.
