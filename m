Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859A939A4DC
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 10:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783765049; cv=none; b=h7wEKxtnXyvqhB+B/WcumWuEMm6LquOyK6U9oLBtVYWiDRT1PSBbBYAdlPGY/AChVZ3OlCjfsC1SJYz2WmoGNBAFK15tQmCQSQxhSg3fN7LWCSHmZDVMLFavdD8U/YjB4XGUM2/yJxoozXKykgy44bZMtQG67ok8HC+96zZxqUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783765049; c=relaxed/simple;
	bh=PBB1Rt+IlyXAa8yhwFP5u8auAA6rQT0PQvVMqfTWfPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYrTC3rsOcFJeHeDUiTUFq0xm4TVElKYduzmk2m0iiJt60yfdp3Dqdu+ST3RYhJVk/4c215bWxm1h7TeCjDvYyOXPn336c0zi5SNgkrKFVaLwKATpb87/W/BgjLTTF/70lsuLJUymBST54qDXKuSSRs3ktk0TcyAvyrR3PyRsWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Dzs/2lVu; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Dzs/2lVu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783765043; x=1784369843; i=quwenruo.btrfs@gmx.com;
	bh=7vTQRRPtnUy43Jvi51xTit3vlh1a3f1Z9BiDpqpIw04=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Dzs/2lVuVUnaioBcvCO0Ankb74fX/jWfCLuSHF8/qCWXkP9rS/8NiJsSwzbb40Tq
	 Nq7AJV0dftyL+gFXq+J6YA66wixK8RhdMy/1qxtnf8TKikJegM/LHOX9PAbM66sa0
	 pAEq7Y3ijORymP08esdZsTIwlQsOnhA/mxRGHmOj7GFy2pV9a7wIXSqb2MmLUEap5
	 j17tCrCdhULrqX1yyGznbgtsIITaikOvsfJMtYc0do18ZG5or1Bnr+n23Fnt8lonZ
	 FFrOPL59g5lvHS3dp21DQCO8ZyRK2nxQy9utSOMPVoI2dVZpnBTN/PI7eM/Zwn72O
	 yAySFBlJ4LYjDZy05Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MowKc-1xOzmf05qI-00ilf7; Sat, 11
 Jul 2026 12:17:23 +0200
Message-ID: <df2d93c0-2e7e-422d-8c81-8ddb1dfc00c3@gmx.com>
Date: Sat, 11 Jul 2026 19:47:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: avoid NULL pointer dereference when block
 group tree root is missing
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
 <20260711051909.1313584-2-zhudongjiang@fnnas.com>
 <2fc07620-861f-4bb8-ad36-71128ec1ab09@gmx.com>
 <46fb761c-838f-4701-89aa-e56a85cca972@fnnas.com>
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
In-Reply-To: <46fb761c-838f-4701-89aa-e56a85cca972@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yPo/yLM0g26+20Ppysg/1UXHkY+idsSI580ZawMxmVIQ37VBLu4
 5HSOWo+EuAIZbLma95rLmBw3wX6yyScj98Aww0XpvygmVHMvxdUGrVpCCdxyhrTh4NdOeHo
 Aev4wpjZYBJyBw0TbR5OdOmGQlFrUvoyuwTgNixUMA663BYzUJzocRBaKTR+WBWI1BisSEU
 KMxtbVba09v60zqzNZe9Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7FXp+7fMq+g=;Esbw5u73FbbrzNPIieO9VGdbNoo
 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
 RiLucxxZ8=



=E5=9C=A8 2026/7/11 19:22, Dongjiang Zhu =E5=86=99=E9=81=93:
> =E5=9C=A8 2026/7/11 14:20, Qu Wenruo =E5=86=99=E9=81=93:
>>
>>
>> =E5=9C=A8 2026/7/11 14:49, Dongjiang Zhu =E5=86=99=E9=81=93:
>>> [BUG]
>>> For a filesystem using the block group tree feature, corrupting the
>>> block
>>> group tree root and mounting with rescue=3Dibadroots triggers the
>>> following
>>> NULL pointer dereference:
>>>
>>>  =C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum verify fa=
iled on
>>> logical 30654464 mirror 1 wanted 0x0f55b851 found 0xd7efdde7 level 0
>>>  =C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum verify fa=
iled on
>>> logical 30654464 mirror 2 wanted 0x0f55b851 found 0xd7efdde7 level 0
>>>  =C2=A0=C2=A0 BUG: kernel NULL pointer dereference, address: 000000000=
0000100
>>>  =C2=A0=C2=A0 #PF: supervisor read access in kernel mode
>>>  =C2=A0=C2=A0 #PF: error_code(0x0000) - not-present page
>>>  =C2=A0=C2=A0 Oops: Oops: 0000 [#1] SMP NOPTI
>>>  =C2=A0=C2=A0 RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrf=
s]
>>
>> The problem is why we need to use global block rsv in the first place?
>>
>> The whole fs is never going to be mounted RW as long as "rescue=3D"
>> mount option is utilized.
>>
>> In the case of a rescue mount, we should just fill in a dummy block
>> rsv, with block_rsv->full set.
>>
>> This will also fix the next bug you're fixing.
>=20
> That makes sense, thanks.
>=20
> I had considered simply skipping btrfs_update_global_block_rsv() from
> btrfs_init_global_block_rsv() when rescue=3Dibadroots is set, but did no=
t
> choose that approach in the end.
>=20
> Your suggestion is semantically more precise. If I understand it
> correctly, would the implementation look like this?
>=20
> void btrfs_init_global_block_rsv(struct btrfs_fs_info *fs_info)
> {
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_space_info *space_info;
>=20
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Existing space_info initialization. */
>=20
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(BTRFS_FS_ERROR(fs_info))) {

I'd prefer to put this inside btrfs_update_global_block_rsv().

Just in case there is some other call sites that can still hit=20
btrfs_update_global_block_rsv() for a fully RO fs.

>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs_info->globa=
l_block_rsv.full =3D true;
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>=20
>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs_update_global_block_rsv(fs_info);
> }
>=20
> Would you agree with using BTRFS_FS_ERROR() here, or would you prefer th=
e
> narrower fs_is_full_ro() or IGNOREBADROOTS condition?

I'd prefer fs_is_full_ro().

BTRFS_FS_ERROR() can be met for critical runtime errors, and we do not=20
want to mess global_block_rsv at all, as it may contain critical info=20
for debug.

For fs_is_full_ro() is very specific for rescue options, thus nothing to=
=20
save for debug in the first place.

>=20
> Thanks,
> Dongjiang

