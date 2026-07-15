Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D25B3A5430
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784108660; cv=none; b=oweDcD9WTfKM+jQtlIjb99//c5GCeEdN+xfThzsVrwcPwAsuR+SL/0r3OxdSvWviLnUdDUdBdWXE26taCUUGz6x/F4FHBVIaGcYJPUhEIpvPAS40NFf/f26oONlS96yWt3Rv5pWKSLNH3Bo1nlf76RKbdEZZXjR5in7VzGgj3UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784108660; c=relaxed/simple;
	bh=v8uD94eIAd7b9uivkM6cllJaVSzR08eQETjcANsmgIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6KKC0Bmo2HZYLjBzZuKpyWSHmNt7JDVzm5HKHQc1j77htN6rK0TIgF1BwAV5Wem3uPCVSYygygfDm65+kO0ULhAEqLnQHT0dD5wKT5FvbMHCOVNrBlSNsIhQQ6/dcSs8m7cD5Ktfie/uv+q5WOTUWCzcjJxhpL7Q+OuHbItGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uWvQY17l; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uWvQY17l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784108644; x=1784713444; i=quwenruo.btrfs@gmx.com;
	bh=v8uD94eIAd7b9uivkM6cllJaVSzR08eQETjcANsmgIk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uWvQY17llo/APRajgJV3sfvkOQgAs2jh89CClVjUpCxEbwwxKWZQlC9VnP8odCbQ
	 nE9M7T7S3zSRi8TSncMzbPEtj/1+PDU4bjWzWwIOXuBZj1EszQ2vnLRB32i1NY2YT
	 Hzmce5/sr8fqbmQDzfR0q39NYuegyZOA4AaFIEoH+f4xmhsHcBbDosGwRfB9vaWyj
	 kBa0WQumNOwf23bwvuwrYViZqT1L3JL7J79INpzNKCEgq5nAs/xXPcOWP7spq2cku
	 XjIdERMjizFSu/xEopJcA1ZwemC2smhGJYU7hJGy2Y00sghSGkCASQhMooJiF6y7Y
	 l69fKyznp1ouT91MoA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MOA3F-1wPmqg3MXR-00NVVs; Wed, 15
 Jul 2026 11:44:04 +0200
Message-ID: <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
Date: Wed, 15 Jul 2026 19:14:00 +0930
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
In-Reply-To: <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0sS/seTXIHPlYiOI0ijtjLf8YjmkwUoJm2J8Ew+xTifBioTtYdl
 VsWepF1Hp2CzWFwowhdAN/oeFGw1GNMlYz08nF3o5QPhmQg3azZ6/CfROMWF90Zzklgzm4a
 gRcYjGF2DrFJP1wi/vOshQ7Y66XCdD4BxiIdqu5BuCD1GvLXzl/Tjccaxk9dWkyxUSkvguK
 mqsHyi4kieVS8iypzHUTQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:olloQCih6pM=;c//ezExgo2CNiNTsPPezVl3uWpn
 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



=E5=9C=A8 2026/7/15 18:55, Zhang Boyang =E5=86=99=E9=81=93:
> Hi,
>=20
> On 2026/7/15 16:36, Qu Wenruo wrote:
>=20
>> You're introducing more and more code just to handle some very=20
>> specific corner cases.
>>
>> E.g. for your particular case, you will need a very specific write=20
>> situation. You're introducing a feature that is very hard to hit under=
=20
>> most situations, but we will always bear the burden.
>>
>=20
> Technically the runtime burden is small because generation mismatch is=
=20
> rare. If no generation mismatch is detected, no device will be marked=20
> dirty and no runtime burden is involved. On the other side, if=20
> generation mismatch is detected, you always want to run a scrub to=20
> resync your array.
>=20
>> I am not even sure if you'll still contribute in the next 5 years,=20
>> thus I won't bet my 5 cents on that this feature will be properly=20
>> maintained.
>>
> For maintenance burden, yes, there is maintenance burden. So I'm here to=
=20
> discuss which way to fix this bug is proper.
>=20
>> To me, if you really bother this particular situation for whatever=20
>> reason, just introduce a special harden mount option, that any=20
>> barrier/ super block write failure will mark the fs error.
>>
>> That will be a much safer bet than any of your proposal.
>=20
> This can be a solution, at the cost of one failing drive will render=20
> entire raid array unavailable.
>=20
> Personally I like the idea of turning metadata trees into merkle trees=
=20
> (so I wrote it first). But since you are the maintainer, I will let you=
=20
> decide which way is appropriate=E2=80=8C.

I'm not the maintainer, I just default to not trust ideas/features from=20
unproven contributors, especially when the idea/feature is not simple.

Especially considering the increased patches generated by LLMs.


So my suggestion is, if you really want to do long-term contributions,=20
stop coming up with fancy ideas, start from basics like doing proper=20
fstests runs with various combinations, report real bugs and fix simple=20
ones by yourself.

Earn your name first then consider fancy ideas.

>=20
>=20
> Zhang Boyang
>=20

