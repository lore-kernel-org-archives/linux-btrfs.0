Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBE6282F26
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 01:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786327093; cv=none; b=uOJ4dSsV0Fs2Gq4Ro7UMyE9GEd8XLdUEy6lnSRHyqTMPWqe3L2bkbXL8+D7YYsKyHeFK+jdcG8gy0J0T8dNNyfDt9CGTCe0K6SNVwMijlXWslzkB+Lui31XkZeImJ2XM4/WHRQIsUN8wPgoKe8+gqvwh2Z3kv8P9CVNiWzLiY0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786327093; c=relaxed/simple;
	bh=3ZZMfbxy7DD/RQ3R/mGKuHicd2hJVNIl51ombmbhIUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJm/a7z+Wl+3YHM/7s6cU/DKn0rJ2/FQU+YZHySUOBAOUzpox1Ny3H4P13heKxerOHVrYg6Xo8g0rw/TUeK18l/l/2h8w0FKCUG++Ek8qO+KCxcwx1wemIetrLyvbEyGYCaHC+0j3Ro6Doo8n7957gH/QJyRKwDlXWeINkJ3aGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=JV5fBuBy; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="JV5fBuBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786327077; x=1786931877; i=quwenruo.btrfs@gmx.com;
	bh=pIg5bvgttkAQJGUDGxRIp1Cg8wncBI1J6ZPXH5bFU6g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JV5fBuBymNuE741z3bvdJPQgtHFEuO5RrAtf9fmWMfXv1Zv8/JI5x7BrowpLq/Q4
	 0wq/EyNGktee7O7dhYqSy3Si0QMMEr4v1BuZWKVRSTkANMPxgICnnWfdERnzdHwBa
	 +72RM0CaYkdBa4fV6mM4w61f/qDWTMl9yNyr0/eU6hxb1PfZDtJSZjguzKMvWIeuG
	 oan4geqHjqgjxY+O70n+VxsZGwzglLHF66GZINlA+tCLJRBEynMWzUkUyj1N58PuE
	 RqlFIdWcINTML9h6muTtKOmHmqHGacuasoDg9GvedlHf+N+PzWQQI2uJi4slp2Mpa
	 v2OPlZLHgPjh5tnbCA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mwwdl-1x4in00Kpn-00s2Zf; Mon, 10
 Aug 2026 03:57:57 +0200
Message-ID: <23eb77d0-d4f3-4d9f-ac53-8dbba575a8c5@gmx.com>
Date: Mon, 10 Aug 2026 11:27:49 +0930
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
 <f4a10cb9-0237-4326-9356-3704939072a7@gmx.com>
 <DKKW2W8COGXT.3GZPRA6TKLCFV@gmail.com>
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
In-Reply-To: <DKKW2W8COGXT.3GZPRA6TKLCFV@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BO9p/XPVBJioqnFGkXoWqxTdOVIVcu5cUq/MiHIBroENl8JvD2s
 EqZWQQGYup0SsilkVGuaHoMWafZi25v/zZ/cbC3Cu5xla+Xe1JyK3UUIXudf8/mkD1gqF25
 Q7QvJMpZ/VE7sd7/2xDF3ahWMA6QJP0ScqjgiqRRKe1smm5c3ax6wTYwnrZwIu1E53l1Pfa
 +rpjB3PGMCXkuA/qMOiBw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Uk5R8wojPKs=;1IxhMG+m2dOV72D5sr4RUAWFs5H
 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
 gJnsiTOta5YLhDwtRF9HvB0l2Zi0=



=E5=9C=A8 2026/8/10 11:27, koraynilay =E5=86=99=E9=81=93:
> On Mon Aug 10, 2026 at 3:54 AM CEST, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/8/10 10:35, koraynilay =E5=86=99=E9=81=93:
>>> On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>>>>> So either option 2 or 3 would be fine to me. Although I personall=
y prefer
>>>>>>>> option 3 a little more, just because it's much cleaner code wise.
>>>>>>>
>>>>>>> Option 2 preserves legacy behavior that is 12 years old now, and i=
t
>>>>>>> costs a single comparison in two 'if' statements.
>>>>>>>
>>>>>>> Option 3 makes an already confusing situation worse--it makes the
>>>>>>> underspecified behavior change depending on kernel version.
>>>>>>
>>>>>> One should never rely on something not documented in the first plac=
e.
>>>>>
>>>>> Option 3 prevents existing mount-option compression level specificat=
ions
>>>>> from working when the attribute agress with the mount option; otherw=
ise,
>>>>> they would be blocked by a btrfs.compression string that doesn't spe=
cify
>>>>> a level.  That's a _regression_.
>>>>
>>>> Let me be this clear, the current one nor option 2 is not working eit=
her.
>>>>
>>>> If the current algo is different from the XATTR algo, it will be
>>>> whatever random number clamped to the XATTR algo for the current code=
.
>>>>
>>>> This applies to the option 2 solution. When mount option changed, the
>>>> level will suddenly change from whatever previous mount option to the
>>>> default.
>>>
>>> TBF, I can see how it could be useful (or rather, how it could be good
>>> to have it as an option) to have some files with btrfs.compression=3D"=
zstd"
>>> and then use -o compress=3D to decide on the fly how much compressed t=
he
>>> new data added to them should be.
>>> Both are (read: will be, after the per-inode patch) 1 command away, bu=
t
>>> there *might* be use-cases where mount is more suitable.
>>
>> To be honest, with the proper XATTR compression level specification, I
>> think we should even deprecate compress=3D mount option, and make the
>> XATTR one the only recommended way to specific compression.
>=20
> Ah, and in that case, to set compression on the whole fs use btrfs prop =
to
> set it on the root?

Yep.
>=20
>> There are already too many corner cases with mount option.
>>
>> IMHO, a good design should allow and only allow the best way to do a th=
ing.
>>
>> And option 3 matches perfect for the XATTR only compression future. It
>> still allows old XATTR to work, have a very sane default level, very
>> explicit and clear independent from whatever stupid mount option there
>> could be.

