Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978EF30E831
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 23:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775257262; cv=none; b=Eq+hDcbSN6kZMVCRM4mRDUpQLmZFedsuIwHZHHqi+3Dy+bNlMQ6DxnpSwJ45D9J0VqDn64UaOcX2c8x2o6jS8WFyqlxaMkkK/nm/kCp7KsjMM+9XEgYrdQ3Zqyc/qPnYTo5kinWDV+juVm2NTO5Zt4VJvBcnljIn90mwG39nX+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775257262; c=relaxed/simple;
	bh=hmeMSf5bEuPs7Hd5q///Hyj7RP9P7U+G1VaPd8kKfYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NU0NvnnbydG2aML6Y7uyzGBeNWSDyO600B5D53Z30JRPbrI1yquedzy8MbhH7BL2VS54XLs331lOca3fTQSmQBO+/1vl26WyFj7tVcYTk3u6Itr/uLrQN2MyukQLrrStoU4JQI/CV+U3fScKZq287dcWfs8yBr1ZGa35ZqBFjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lms+5LFE; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lms+5LFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1775257255; x=1775862055; i=quwenruo.btrfs@gmx.com;
	bh=AV7LhF/S47Zlku0GmWpVf/FslbJebstCCmPGRfX1umY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lms+5LFEh6NzyDyGJ/zs1cYTDhHdR14xLtgVpFyRayDs5d0nvQDBPkIbAgFFZH/g
	 Rizb3VdlQdZYvw8fM7NF8h/9cccrqNsgGId0MilYglenIqJqEWXuJ0j/gU8kQA1g7
	 mf/uveMX4/28hXXV4kbuvQ2M66vwAzlM9JJ3vPmfYxxwLWp2N1vrpyjVaVdlO5pXk
	 hiWvjGZ14zyD5Sh2owQf42qYLJMF/QzqWCccDGCRLtfd5Ty1ByQxourBpvs5YijIc
	 32g6NiUDVWYCrXJzkvxIv6zD59jG/A8twq30I+IMqz1nHYJxAkDXF9G2rnvzbRD+g
	 maXWsJ1kIcByJHEJfA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MVeI8-1w13kQ2Dwq-00VepH; Sat, 04
 Apr 2026 01:00:55 +0200
Message-ID: <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
Date: Sat, 4 Apr 2026 09:30:51 +1030
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
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
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
In-Reply-To: <20260403224449.GA1806609@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:83A9e+ICgmFOPUUFDs45rkymgjh3paPuRK5lJHtv4sbKV0/4TEU
 U4ktsmC6vZtCLx1ymZV+4ccDFdWI+6iUBJw2vPhVmy6pOmkgYgWTJYm4JEHuTsBEIuaJU4e
 9hKUSjc92h4NBkdSPzHPrVYN6as8SN9z7BYDT/JqX/qzIsrpdKV5asbTCRT6mV/NtP8HjrE
 iF+P/N3J0u93jvXVJa4JQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nF0Zqwi3DAo=;0uF6t7eOwMBqqL0pSLyOwWtLNxs
 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



=E5=9C=A8 2026/4/4 09:14, Boris Burkov =E5=86=99=E9=81=93:
> On Fri, Apr 03, 2026 at 08:16:26AM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/4/3 03:35, Mark Harmstone =E5=86=99=E9=81=93:
>>> On 25/03/2026 9.04 pm, Qu Wenruo wrote:
>> [...]
>>>>
>>>> That's done by progs through fiemap. There will be a flag ENCODED
>>>> for compressed file extents.
>>>
>>> No, this still won't work I'm afraid. The ioctl is answering the
>>> question "what's the csum of the sector no. such-and-such in this
>>> file?". That can't be answered for compressed extents, as the csums ar=
e
>>> on the compressed data.
>>
>> My point is, since you are not trying to fetching the csum of compresse=
d
>> extent in the first place, you don't need to bother that situation at a=
ll.
>>
>> And even for compressed extents, it is still possible to fetch the csum=
,
>> after all we're just search the csum tree for a given logical bytenr.
>>
>> There will be some extra concerns like fiemap can not return the real
>> compressed length, but again we ruled our compressed extents in the fir=
st
>> place.
>>
>=20
> I may be misinterpreting, but I feel like the question at hand is how
> much hardening the ioctl requires to be correct, and how much work it
> can delegate to userspace.
>=20
> Suppose we make it require root, I think we could make the interface
> much simpler and just use the logical offsets instead of a file based
> interface, and we can leave it up to userspace entirely to figure out
> which ranges they care about.
>=20
> OTOH, if we agree we want the csums ioctl to be unprivileged, which
> means that the interface must assume that the input could be bad, on
> overlapping extents, not marked up properly, etc... In that case, I do
> not quite know *exactly* what is redundant with fiemap, what is exactly
> necessary for safety vs for caller convenience, etc.
>=20
> Basically, I think the options are roughly:
>=20
> - Mark's proposal: A smart, convenient GET_CSUMS that does everything
>    turnkey and as helpfully as possible. Lots of redundance with fiemap.
>    Safe to make unprivileged.
> - Qu's review: Require the user to do the fiemap part themselves and
>    don't make GET_CSUMS quite as turnkey. It is unclear to me whether it
>    is possible to make such a version unprivileged safely *without*
>    the fiemap redundancy.
> - Boris's strawman: A dumb, inconvenient GET_CSUMS that expects a lot of
>    userspace but doesn't check anything and definitely needs root. If we
>    do go root-only, I feel like this might be the best interface?

Well, my idea is more aligned with yours, except the root part.

Our ideas share the same part, the ioctl just handles things inside the=20
csum tree without bothering subvolume tree.

Yes, bad inputs can lead to a lot of information leakage if we allow=20
non-root users to use this ioctl, but I doubt if they can really do=20
anything with the information they got.

One still needs proper privilege to call fiemap on a file, so even if=20
one knows there are some csum at random logical bytenr, unless they can=20
access fiemap result of files that are utilizing those bytenrs, the csum=
=20
is still useless.

But I'm also fine with root privilege requirement for the ioctl too, as=20
to me stricter requirement has no obvious disadvantage, and can release=20
us from safety concerns.

>=20
> And the questions are:
> 1. How badly do we want non-root? In practice, mkfs is root when writing
> disks but not necessarily when writing image files, so it's a bit of a
> toss up there. At meta we tend to end up sad when mkfs has root-only
> functionality that we want.

I'm fine either way.

> 2. What is the bare minimum processing needed to safely allow non-root
> callers with arbitrarily wrong input? I don't see how we can assume they
> will use fiemap correctly and not hit bookends, or set correct tags on
> the input, for a few examples.

They just pass random logical into the ioctl, and we return whatever=20
they want, including something to show which range has csum, and the csum.

Let me be clear again, it's just a variant of TREE_SEARCH, except the=20
existing TREE_SEARCH is not good enough for csum tree search.

We don't need to bother if it's bookend/compressed or whatever, if they=20
want to do stupid things, that's their choice, and just reading the csum=
=20
shouldn't cause any writes/effects/damage to the fs, so let they do=20
whatever.

Thanks,
Qu

>=20
> Thanks,
> Boris
>=20

