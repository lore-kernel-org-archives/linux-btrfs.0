Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7A91DDC35
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788161491; cv=none; b=RmU8JKBn+u7KF29rOPANH8JXRRwtw/S3GLzCF2D1GCT8+kOc3JSeQFy6yYZMVf62G0byXaM+jPPG0Y4VJiPMRAFiivsj39woUNvtSfduO1kf6TZ8M3R7FYkMmpbY+gj5mZv8+F3pOpl4VionUV4+R0oKztWgiiglcjarT6fTrJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788161491; c=relaxed/simple;
	bh=O62Bow7PIns4f468OcYLyUPeNpMggfTyY03iq23qjYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZ/bQlBQ2YyPKLw83RUjEQXnDm07+uZ+y9sNFDAestix0If/CS/lcoNTeUYll3wSh8aiZP01WGY55zKOVbsiN7p4GNynjr/OGqhmIO8WZlKbkkfSZzIfExQHODUcAaMEAiNWwj8QE2+V+wW1jofbfjTfKyQ8eSOvz+pHzifbJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=pCX1lSG3; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="pCX1lSG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788161486; x=1788766286; i=quwenruo.btrfs@gmx.com;
	bh=GwhzKolt88qrHKzRpDxts8S+ip1b3vmxxI42Zw4xGLY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=pCX1lSG3kj6xMjD+S6UfxkYjfYBvya598GkQBR1rKhUoBo0gRe5Cb4bMKlup+dIO
	 o/JuIk1XhMfDvvuuwTiTZ3SqpSXDZJY0Akv+tLuQoCnCjSrnB0KPyk//jKDixdTlo
	 BWsalneEt/bR+je6j1AePaj+j7EtJJIhCUCPHjyLneRi6TcrlYmcnd4FKsrTcQYSq
	 Bzwk4lTWWNSWQKI4WDqazfG626KNHa7L1u93VDeyX4Km4dcfI3uSzTWYrnk96TCcc
	 /Fvva1eZ5fqXzLmSB5QvaGk0H/OplHKmoLlwVCDBLfy+qMswOZwHEF2WciOP5aDSd
	 vQff+2+6bT4Du7nlIg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MSKy8-1xTZA53F16-00Nv9Y; Mon, 31
 Aug 2026 09:31:26 +0200
Message-ID: <74188ab7-96d7-4536-997f-926a5a845f79@gmx.com>
Date: Mon, 31 Aug 2026 17:01:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag for direct reads
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
 <apUp9SjdTSAmmzXV@infradead.org>
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
In-Reply-To: <apUp9SjdTSAmmzXV@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XEaLd866uTDXdCV9d2P3NiCb7u8iQeWnbKVihVdwODvT7Dnemtm
 aOG+wcASpqhr6oFsOHAIL3ImprhjZ2SWzQjlWXDxiCGmS1NwPe1FGSdKTMD/Mhk+iIfLkM+
 3u8CREBYqaAvZpxEDWfUv1YSGUNEal2uajdsRE4ZGersCcpj1OalN8cOvN7/3ioEZ2r3J9h
 Om6NSfHuB867aM+njUYmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l+vOhmLiFXU=;ctiW3WPtVczAXF4hOW4atuDWkKQ
 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
 FaMYOM9g==



=E5=9C=A8 2026/8/31 16:45, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Aug 28, 2026 at 06:58:16PM +0930, Qu Wenruo wrote:
>> Similar to direct writes, if the inode requires data checksum, we shoul=
d
>> use a stable buffer for IO, or even for direct reads an unstable buffer
>> (e.g. the buffer is being modified during the direct read) can lead to
>> checksum mismatch and even cause read failure.
>>
>> To address the potential problems of unstable dio read buffers, use
>> IOMAP_DIO_BOUNCE for dio reads if the inode requires data checksum.
>>
>> This will bring a small performance drop, around 7% for my benchmark,
>> which is definitely observable on modern NVME SSDs, but the overhead is
>> still much smaller compared to data checksum:
>=20
> Please take a look at the "lazy bounce buffering for checksummed reads"
> series I just sent v2 of.

Thanks for pointing to that series.

However it only shows up in lore, but not in my inbox at all, and I have=
=20
no idea why.

And lore is never a good way to review patches, nor easy to reply.

>=20
> For one this removes the read-side IOMAP_DIO_BOUNCE support you are
> using here, because it had problems.  The alternative is iomap-based
> and better at building large, aligned read bios which matter for HDD.
> It also introduces the concept of lazy bouncing where it only bounce
> buffers after a checksum failure happens by default, which means you
> only pay an overhead for misbehaving applications.

In that case I'm afraid btrfs may need some way to integrate the=20
checksum handling into iomap.
As the btrfs has a very internal handling for repairing each block.

>  And unlike for
> writes where they do exist in real life, I don't know any that modify
> the buffer they read into.

Yep, and that's why we didn't put too much attention to dio reads until
the dio writes bounce is implemented.

Thanks,
Qu
