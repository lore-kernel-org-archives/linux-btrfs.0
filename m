Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA8C383993
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 22:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787093086; cv=none; b=Yl8prn/RDVyNpBHG84fO5AeZihCkOrQmljSMq5KlLfhnv4AvBykUk2DXLLr6Yb21lia8jGWshe0yQZg1Tirux5U+SBatldhtfhO2K4GF3gMqb4Zhr0vsKAvd3Kg9vfVfmhu7pf1wM4cttr9dw/2OVMgmaJ/7if4gQPd9C8V1d4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787093086; c=relaxed/simple;
	bh=TiZI/RgzXzuYsLrJuPkLjDV3vK9fhw1HT9NqBrpAikw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UyS35R17WHCZHuqkXVFUkvYcG7XT0Ti3L74zCJ2+YiSTLqaRsJ4c3eu8vf9rWHwUQYY+pTZfq6fIKoEQHIcfosvtZw+KGxjRmfCsClriqmdtmEZNZh9lcj9jckcCw4RlxuHk43ZUBEhQJV8mBX+Oobt5TGNUjbfNgE0bmtFketo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rsygp5wn; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rsygp5wn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787093081; x=1787697881; i=quwenruo.btrfs@gmx.com;
	bh=TiZI/RgzXzuYsLrJuPkLjDV3vK9fhw1HT9NqBrpAikw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rsygp5wnqkw5yrHUL4yPhQc+eUZnJ+mS5iAW8TkQCOMxf0lAyk2+nSZIAVnLOyxN
	 ggnYijd4vO3rJLttMMdw7M5cmZFioYhKnZqUO2EmGXn9AipL8F5/SI5Y+7DCEGSgP
	 rzny+Hp7oM7B0l5H8TZAPY1aX3XOiR1oYuljBYdrVkRgv1lfRJ+SJmrkDNSi7SkpH
	 hxelbl3bjeJJpeYteOQNt8OXocYbty2xv2++bQVPph8Mn7f9aCcz44cKMsh8SBXjI
	 tIStWH1A6xHON7e44c6ftzBF40jadxOeKA61Ch+DqV+pauXo671eynO2trPXPlvUu
	 nXnMfCs+6+bC0EA2Ew==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mel3n-1wMIyz3DtN-00hdU4; Wed, 19
 Aug 2026 00:44:41 +0200
Message-ID: <d3ba712b-9403-4cd4-9c28-c3c6fba59c19@gmx.com>
Date: Wed, 19 Aug 2026 08:14:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: propagate do_zone_finish() error in
 btrfs_zone_finish_endio()
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
References: <20260818100037.1366563-1-johannes.thumshirn@wdc.com>
 <c96becbd-1f39-486c-8474-7a854af73044@gmx.com>
Content-Language: en-US
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
In-Reply-To: <c96becbd-1f39-486c-8474-7a854af73044@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BDM0r2qpPAiFB68KxaHqXCbHWKYbEZtqiPEhOEafNBdvORnDZyE
 mOMv5ak5/rEMVGdCYYRgU8sq9wXN3U2Ef0QGW5Nm5Im30N15HLWFrDc1ZRs8VMXM+VgEVbd
 enMIAPViQGGocDNqRrS1tDTs/Itm+usnwzUf99fjiyUsEje6LrcOYhy740+2RBVXx4B5btN
 8fe787CzzvXGyQl3H3N8g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZMJXRaPCfbQ=;DiAluKAVKn+Q5HV6MV6YRCZmBT2
 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



=E5=9C=A8 2026/8/19 08:11, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/8/18 19:30, Johannes Thumshirn =E5=86=99=E9=81=93:
>> btrfs_zone_finish_endio() ignored the return value of do_zone_finish()
>> and always returned 0, silently dropping a failed zone finish.
>>
>> Instead propagate any error from do_zone_finish() as the caller
>> btrfs_finish_ordered_io() already handles it.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>

BTW, you may still want to check the sashiko review, which exposed an=20
pre-existing bug in the error handling path:

https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn=
%40wdc.com

>=20
> Thanks,
> Qu
>=20
>> ---
>> =C2=A0 fs/btrfs/zoned.c | 5 +++--
>> =C2=A0 1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>> index a016cb471beb..82c2394dd43c 100644
>> --- a/fs/btrfs/zoned.c
>> +++ b/fs/btrfs/zoned.c
>> @@ -2713,6 +2713,7 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info=
=20
>> *fs_info, u64 logical, u64 leng
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_block_group *block_group;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 min_alloc_bytes;
>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!btrfs_is_zoned(fs_info))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> @@ -2732,11 +2733,11 @@ int btrfs_zone_finish_endio(struct=20
>> btrfs_fs_info *fs_info, u64 logical, u64 leng
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block_group->sta=
rt + block_group->zone_capacity)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> -=C2=A0=C2=A0=C2=A0 do_zone_finish(block_group, true);
>> +=C2=A0=C2=A0=C2=A0 ret =3D do_zone_finish(block_group, true);
>> =C2=A0 out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_put_block_group(block_group);
>> -=C2=A0=C2=A0=C2=A0 return 0;
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> =C2=A0 static void btrfs_zone_finish_endio_workfn(struct work_struct *w=
ork)
>=20
>=20

