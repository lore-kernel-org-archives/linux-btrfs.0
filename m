Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7431F9BF
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775166394; cv=none; b=hhc1icGGl+YqFwIOv8J/DMckzPVbRpfKkyipYN/FhCGy9hdiOUIA1EpkqzxBsYiy7YtyWR88S18r9XMcQWk0xH+82oFmJ833/9hUHd++gOMfqoPAuJn9NyoPogvMfWex/eBy3iKv1Vv00QtefqrHZZArMNX62dX+Fj+AnD/gJp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775166394; c=relaxed/simple;
	bh=hwqdGwrUBrGYV4ioui/e4Hs47ktV2YZ/pbXOreE30lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kK+VwMoI+i//tRaMV0nWpkSW+/h6YvLPuJoTkviPs9OK8+0k4jg7gHJLsqQ3xShUzQafaH6XecUJxVoL4pzEorCntcY0r8kNAOenjad9FTYawwcpfB+2qkbhwnLaITvY1LMaM0imbYYPMaEAq2YWNA8LYZtvIP3tY3P7uQQAk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=WUeSpdAX; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="WUeSpdAX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775166389; x=1775771189; i=quwenruo.btrfs@gmx.com;
	bh=hwqdGwrUBrGYV4ioui/e4Hs47ktV2YZ/pbXOreE30lY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WUeSpdAXT5JUFXF0uzT2+dml4R3M01rxbg/wqvSYX5hIxq+1sUi7r5xaUcZ0AO01
	 eVynZjrhpLJt1S21y771d8Dnmj0D8m/lpzFZ5OtKP8ABWUucYGhpGIjrJEvYghYGD
	 REHAcKPI8aQHGRyeYuW2qhBaqf+jniYmCkbpweY3fcqcYSPJXRJfdjpOneKyjdLN+
	 T6ULvcwXIfVDksNcj9eNqB9jtNA/UYvPf5S7edsvVUexOveYMDB+iwFY5GryumiWM
	 5+tIYBw83hKtfNn/ajtWKeYt9pQoUHLbSvv8iEl2Yv5RcAy4HuqWv/WnFr1FbRSBI
	 6u2RA+sgHsP0kCwKSw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N3siG-1vQB6L0OIa-017odX; Thu, 02
 Apr 2026 23:46:29 +0200
Message-ID: <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
Date: Fri, 3 Apr 2026 08:16:26 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
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
In-Reply-To: <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:khgmY77aa03RYnF5NFNKx/v1jwB8Tve3eMHqyK44wq2C1tTrspY
 BON68iSITQ5T/BIw5+TlXJhrnFs7CuAosGL8B/0KK0IMGsBf5/JCaNSJ21Eu5KSeN24uJIQ
 SiQeb/NV9yyBlw1yeZGNkc9ww2+uDm3hdezjYurkR/qk9vNxcDkrsMA3gsW+Cy7o/SNYnlP
 Wr36td6UrEdaaKGMh4Z7w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kqrUh4aDCb8=;POZMB7BHBF4L+vLnlQDcWK0qJH4
 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
 ngp3F+t7bJLzkfgzkXFY



=E5=9C=A8 2026/4/3 03:35, Mark Harmstone =E5=86=99=E9=81=93:
> On 25/03/2026 9.04 pm, Qu Wenruo wrote:
[...]
>>
>> That's done by progs through fiemap. There will be a flag ENCODED for=
=20
>> compressed file extents.
>=20
> No, this still won't work I'm afraid. The ioctl is answering the=20
> question "what's the csum of the sector no. such-and-such in this=20
> file?". That can't be answered for compressed extents, as the csums are=
=20
> on the compressed data.

My point is, since you are not trying to fetching the csum of compressed=
=20
extent in the first place, you don't need to bother that situation at all.

And even for compressed extents, it is still possible to fetch the csum,=
=20
after all we're just search the csum tree for a given logical bytenr.

There will be some extra concerns like fiemap can not return the real=20
compressed length, but again we ruled our compressed extents in the=20
first place.

>=20
> There might be a use case for "fetch the csums for a compressed extent",=
=20
> but it'd be something different.
>=20
> My concern about relying on ENCODED is that that would also be set when=
=20
> we implement encryption. For an encrypted uncompressed extent the csum=
=20
> *would* be meaningful.
>=20
>>> The reason is that they may be "bookended", and you would leak=20
>>> information about other files if you returned the whole of the csums=
=20
>>> for the compressed extent. This is the reason why encoded read needs=
=20
>>> root.
>>
>> Nope, for the fiemap call, we will never reach any bookend extents.
>=20
> I really don't think the FIEMAP call achieves anything here. The kernel=
=20
> still has to do a lookup in the FS tree to determine what the logical=20
> address of the extent is.

The point is to minimize the work in kernel.

We already have a ioctl to do the fs tree lookup, and it is definitely=20
enough for non-compressed extents, and that's fiemap ioctl.

Thus I do not want to introduce new codes just to do a similar thing again=
.

> We can't allow (non-root) users to read the=20
> csums of arbitrary sectors.

And that's your choice on the csum ioctl, I have no preference, since=20
fiemap doesn't require root privilege anyway, if you want root check I=20
see no problem either since it's more secure.

Thanks,
Qu
