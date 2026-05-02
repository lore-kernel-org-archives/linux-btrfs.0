Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2D0221D89
	for <linux-btrfs@vger.kernel.org>; Sat,  2 May 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777714244; cv=none; b=RCF99ReN9u6r3XBFZFYQYFAh1bazTTS5IbM4cOUZnxAHugZTTfOekBa7FxGppxCaHch++oY2BoAl1U2y5UWQnict64TYVfiLT+LoPA/Us6MZuz4KygzI7MR+ayI1UyfWyLfacwi448YFEwGXLPea//BOgyMxfV5pkhFjH7OerL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777714244; c=relaxed/simple;
	bh=GQvVqdT2ITbwvNyhT3miOtQzOTrhN98bBHGUB/fnfAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=igxnMSsbUmhW8gdVs+P3qb8STehseyYj2iLx8xpXdKkMB2etnv1qG9mAg52orT+yC/RyW+ehYdZc3BzGIJkTGge1VO9tHMgvbAOkHH4wc+GI/63OGYUEInkvR1GN72nQrBcuKtHgCLvBYYMhGN6J3wdhDzUfFGyGtkLeLAwqqiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=A9QbYS/u; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="A9QbYS/u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777714240; x=1778319040; i=quwenruo.btrfs@gmx.com;
	bh=hmKaVKUQm4lxvCw7KeszE2Z0vKsRg63r7gbwczZyIs8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=A9QbYS/ulsY7fPROFl5DAEv2j9JTvp3ZIgsQpXiRpAhWpS6a5DatrfYF96haorgM
	 GAJxGBwNNI66FOLHsk42rtQvgCpbhs8SxTsm0KQkyhJwI6rW9AAYelmPSR1g/hhHJ
	 g+ETUoLpj+AJPDZeUtqcDIr0bIvYEP8pt9Fg9l8ckX60AMxZOqX1RTXSHvj/9IjeR
	 A0/v9pQ2uHJ64FQVBIyC8l6/Ad3YMvsY2wk0APgTcDbrCDeDFNf2NmGT70Fn5nDX8
	 o4R4A4oUa8NULYMPAlB6WJClIgRMYQhvPpHCMndQKTrx8QWUHE5ALf2Na1FB2M91y
	 Cq5TM33ypqGPPYWRMA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mj8qd-1ve0lP1Wbd-00mhTY; Sat, 02
 May 2026 11:30:40 +0200
Message-ID: <2da00f33-9325-4bd8-b874-37b0ef204f7f@gmx.com>
Date: Sat, 2 May 2026 19:00:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: docs: update the qgroup performance hit
To: Max Chernoff <git@maxchernoff.ca>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
References: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
 <5b2ff34a3dabf213c2a0058578ab73cafe36b16d.camel@maxchernoff.ca>
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
In-Reply-To: <5b2ff34a3dabf213c2a0058578ab73cafe36b16d.camel@maxchernoff.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ymAxksgDx3KINsBQic0c9vKjxXViJhHwLo1Zh2LDO+o+g02NB8Z
 M+cLX3BL8UwVnPyaCy+FaFQK7fPWJo2LYcPTW8WDOe3b/wWVo1PNdm4HuHz4am+Uwj8ZvEc
 D2nUzdYZekVYyjXtW5Jw9F4WxPSzZpE0NbvpoPPmZuCjESiUj7amKGnttjU9WSrzgmXIocJ
 RrgRzC9b1Cu675L/5XViA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:au4sIlLwdVU=;3I2vsDQyB3+cgy1uSOy6Fr/WfUP
 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
 hF



=E5=9C=A8 2026/5/2 17:06, Max Chernoff =E5=86=99=E9=81=93:
> Hi Qu,
>=20
> On Fri, 2026-05-01 at 20:13 +0930, Qu Wenruo wrote:
>> Although we have mentioned the qgroup performance hit, we have never
>> explained how large the impact is.
>>
>> Update the documentation to:
>>
>> - Explain what affects qgroup performance
>>    Including snapshots and reflinks.
>>
>> - Explain that the automatic rescan can cause performance problem
>>
>> - Add extra warning to avoid qgroup
>>    If there are too many snapshots or reflinks.
>>
>> Reported-by: Max Chernoff <git@maxchernoff.ca>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> LGTM also, thanks for the fast patch.
>=20
> Reviewed-by: Max Chernoff <git@maxchernoff.ca>
>=20
> Would it maybe be worth adding something like the following?
>=20
>      If quota support is absolutely required for a filesystem with many
>      snapshots, then "simple quotas" (``squota``) should be preferred
>      over "quota groups" (``qgroups``).
>=20
> I've never used simple quotas myself, so I have no idea if that is
> actually true, but the documentation suggests that that's the case at
> least.

Squota has one special quirk that makes it pretty anti-instinctual, thus=
=20
I intentionally skipped that recommendation.

E.g. We have subvolume 256, which is the initial subvolume, have around=20
128MiB data. Then a snapshot of subvol 256 is created, that snapshot has=
=20
the subvolid 257.

Now we have something like: (squota has no distinguish between reference=
=20
and exclusive, it treat them all as semi-exclusive)

   Subvolid         Reference/Exclusive
        256         128MiB
        257         0

Here we ignore metadata to make it easier to explain.

If you know subvol 257 is a snapshot of 256, it makes sense since there=20
is no new data in subvol 257 yet.

Then if subvol 256 is deleted, things go ugly immediately, after subvol=20
256 fully deleted, the result is:

   Subvolid         Reference/Exclusive
        256         128MiB
        257         0

Nothing changed.

I do not believe most end users expect results like this at all.

Thanks,
Qu
>=20
> Thanks,
> -- Max
>=20

