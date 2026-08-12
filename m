Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D972F3C18
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786569454; cv=none; b=eKzXLbJDE9bkxWmqC92Y/VVRkQsJ2DQzT5hwBsmusF+OPz01ZQGsnpgafEpV9Bgc5gkQSfEVWj2ioo4meCvhXRnSMfZ7RIYhD+RzXdGvKJR7skxqGs8grQkCWvzXPHo/0TqBHd6NMS4btI0W8rQmevXHZynylJGZ6EYYm/aIWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786569454; c=relaxed/simple;
	bh=SFdRACmmvlU+TQPUGWWp5v9fcY0jviQAd0fLWf0o9ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZ6DLcEiyOattXq0040YV5DFhzLPkeMVhRBvvEYEo+KF2OG9W68CuBXbfFP5r6NsK+nRKjwwHSQHZwPlcun6lmlOZD0xfXsZ1ZFEI4MJvpSmgwfjGNeA28vsHWog0H3F1qkuiKQqtk4UjvzVMKBrjj29LecHU+W8WMMrFRCuKt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Q0P5x/0u; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Q0P5x/0u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786569445; x=1787174245; i=quwenruo.btrfs@gmx.com;
	bh=SFdRACmmvlU+TQPUGWWp5v9fcY0jviQAd0fLWf0o9ds=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Q0P5x/0u/NGfBLqfoa6BbUtzoqPExn48ghQDDmaVvASA02j8xs6kRaTquPPRqRoL
	 kz6tYdVyWS6ptw/LQ6RJxuf5WHLJRBLfUD2VkrOlCE2lX2JKjSiS9vDaIabwn69PS
	 FhAZ8W2B2VOXg4Kst8DiS8f8bzYSBByboqY+xnXjURdBzrf5cwQc2KC5ZYKoYFHYd
	 Zk5H1XxNR/k81hJUrOiqPfKQraBwX89bfffLl+SUVJ0hI3al67gXsSQIqEIAlOHw4
	 wUvxTmZM9HV8XJ+7IixzT8mT6Fp/KDErZFmn0kbm4s47WRYYxoGGOccQQ6y0lMD89
	 06WDWPCdCtNwjyn6SA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mqs0R-1xGNj31By5-00ktkW; Wed, 12
 Aug 2026 23:17:25 +0200
Message-ID: <d8b4db18-0ae3-4384-9a9e-40c01dbe0cf7@gmx.com>
Date: Thu, 13 Aug 2026 06:47:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: Write as many copies as possible if the
 current RAID1 profile is unreachable
To: Logan Finley <logan_finley@selinc.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com
References: <20260811230427.4059275-1-logan_finley@selinc.com>
 <02b9630e-b575-4c45-ae87-d2faea53b72f@suse.com>
 <20260812173547.dmy7yqby3jsx3lmq@LOGAFINLPC.ad.selinc.com>
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
In-Reply-To: <20260812173547.dmy7yqby3jsx3lmq@LOGAFINLPC.ad.selinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EHc65Q2aLHD7+iZ+k9On2UcaA085u+zVmeWpPrxsY75y+nq067K
 DtTIzkHH9ckaNjMxvAp0wyP8LPnrYCo1EancKaZp9GxI/TjMbMkcwWgYrE8NS86kWK6YVzb
 7e6onbDszh8dhNAZ8kc+/AiPUOQpxvzOjAic/Iv9AK7vQV83tzfxv3N3sS+dcvLp7rRymzp
 yStyj2qUPazJZzxnBfVRA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UOQP9svZkII=;V5HwpP6xvgXeS78c6ZFKo3dwdk9
 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
 oSYsknxQaiaECo+2o7EfWn00HkMQ=



=E5=9C=A8 2026/8/13 03:05, Logan Finley =E5=86=99=E9=81=93:
> On Wed, Aug 12, 2026 at 09:02:24AM +0930, Qu Wenruo wrote:
>>> I'm not sure of a good way to fill up the System and Metadata block gr=
oups
>>> enough to trigger a new chunk to be allocated, so I wasn't able to see
>>> whether they also allocate "single"-profile chunks.
>>
>> For meta, go fill a subvolume with inlined data, that will easily bump =
up
>> the metadata usage.
>>
>> For system it's harder, but you can still use fallocate to take a lot o=
f
>> space, which will trigger new chunk allocation that will increase syste=
m
>> usage.
>> But it's very hard if your fs has limited space.
>>
>=20
> I was able to get a "single" profile metadata chunk to be allocated usin=
g
> inline data. I don't think I have enough storage to do the same with
> the system block group, but I'll wager the behavior would be the same.
>=20
>>> This (admittedly naive) patch modifies this behavior so that the RAID1
>>> family of profiles writes as many copies as possible in a degraded sta=
te
>>> when there are not enough disks present to write data in the configure=
d
>>> RAID profile.
>>>
>>> Signed-off-by: Logan Finley <logan_finley@selinc.com>
>>> ---
>>> What I'm looking for is feedback on whether this sort of patch is
>>> desired upstream, whether the approach is valid, and whether or not
>>> there are any gotchas I may have missed in the implementation.
>>
>> I think this downgrade from RAID1C4 to C3/C2 and from C3 to C2 is safe,=
 and
>> it's a good middle ground solution.
>>
>> Although it has the side effect that there will be new RAID1* profiles =
which
>> will require balance to remove after the missing device is dealt with.
>=20
> Good to know, thank you. I think for now we'll go with maintaining this
> mid-term patch internally, since it seems to do what we need. You're rig=
ht
> that it requires a balance be performed once the missing disk is taken c=
are
> of, but I can live with that.
>=20
>> The root problem is in how we handle chunk allocation in degraded mode.
>> When a device is missing, it's very instinctive to assume we should not=
 use
>> that device for new chunks.
>>
>> But that may not be the case, we may still want to allocate chunk on th=
at
>> missing device, and rely on the chunk's mirrors/duplications to handle =
it.
>>
>> There will be extra problems involved for using such missing device, e.=
g. we
>> should not use the missing device for profiles without duplication on o=
ther
>> devices, like SINGLE/DUP on that missing device.
>>
>> In the long run, that would allow us to still use whatever profile even=
 if
>> there is a missing device, and requires no extra balance after all devi=
ces
>> are online again.
>>
>>
>> Now the question is, should we go the long-term solution directly (if s=
ome
>> one is going to work on it), or go the middle ground first?
>=20
> In my free time I would like to spend some time working on the long-term
> solution you proposed and eventually send it upstream.

After some quick digging, the blockage for the long term solution is=20
that, we can no longer consider a device RW status as a simple binary.

E.g. a missing device can still be considered as allocation source for=20
new chunks as long as missing devices do not exceed the tolerance.
But we should not try to read from such missing device either.

This will change the device management code quite a lot, so I do not=20
expect the long term solution to be easy.

With that said, I think your RFC patch would be good to be merged upstream=
.

Reviewed-by: Qu Wenruo <wqu@suse.com>

I guess most btrfs developers are on vacation, so I'll leave this patch=20
for more reviews before pushing it into for-next.

Thanks,
Qu

>=20
> Thanks,
> Logan Finley
>=20

