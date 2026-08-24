Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3903F31D375
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787611267; cv=none; b=pgE7Hyr5RZCuVqPYgxhbGpE0B5+BXyyc7lWdOcMsnfY3Hi1ULduBJTHkRER5PcG0EWFdRhi2ngKbhfk7Yom1zIrz7GKV75TnGq1d7KY75TlwzpQa8iZTV5QWRj84zXnQ2jDbfAJLNcHcMNfurrehrlavKq5rzxXHlDWcle5NvO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787611267; c=relaxed/simple;
	bh=mQwfRa29B9tL8GM6///us+U/H4MHz95qPPVuc7hU11M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lzj/xWu7yogoFUSkChRyTwABgASpktj06+RGY13WqEpLaA6F+87ujG+y5goOYHnOtbAdhwUv06XDiY/Y/ds8Wxf5/uTY5V67R5/9jAknv01MS/024J6Y237EGKWMSQ4dxVZY1vIx5kHomS6KA2WQaPOU8aShO1i3v1cI0UPIhhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FnwyXwNe; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="FnwyXwNe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787611254; x=1788216054; i=quwenruo.btrfs@gmx.com;
	bh=SrZYwqLeqr06nmqgWTkO5rcnEEdGQg9KYllLu8b+e5g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FnwyXwNeG+7sBtkbNe6qU9O/C0rDyn4dwnhZQQ7NehCU8qD1TefD+/f6YqmTURpj
	 FH4NKVNpaiJ6vVhHlR9Slz8t+5VO9TXq6GgnV4MN9JCv61qfP2ZxxCfwgvOvMOx2f
	 s0YZqE38ImPC0aZJEc9YGJKKu862ST4WEO1Iw+3h1PVkkdL9KqBL5KXJmfxDaWfcR
	 bGhqP7DzPJgqt0FIlbJzHd6kAe2jzQLDlfq+6pL/FSailr2uGLkObLiChbLMcDrU4
	 F2kQ0dd8DEPEfBDfvsBajjDuuCkCtZgIazcEdMt0WTke0FTsvYaoA47qJRhwUihG/
	 JrKoS5UYRjZK7ya4zg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MFsUv-1x9PND0NWZ-005FWi; Tue, 25
 Aug 2026 00:40:53 +0200
Message-ID: <32245f5e-59f1-4e9f-bd24-d55f2a17f158@gmx.com>
Date: Tue, 25 Aug 2026 08:10:48 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs: zoned: track only sequential zones as active
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com
References: <cover.1787551793.git.zhudongjiang@fygo.io>
 <9b86d2db35ad9afc13069d6ee8fcf421c85ef030.1787551793.git.zhudongjiang@fygo.io>
 <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
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
In-Reply-To: <aoxL1ZK42wn7VIwQ@mayhem.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xx7Zkzb1g3blFL3Fg9P8LLSFRwU3JuygxmSEPD4GZ8muxVXqBF6
 7vmnZfHqi1LkEnnXidjYAnXRTKzL7qivxDew050WPZgTi8SPJt6BGkgWBKWF058vs6ak/Nz
 jxunifyk2kiHnSLk172FUioUcI41hsKwtT9qtXibVmaQzAW7YKr/Y1PR7xD+bqtk+v18rxA
 +xMGIoJxqBMAKV4K+F/cw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GCLChMGnO1I=;xP99v6dcyiEVMcQ70yd13Yy4q38
 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
 KSzIh8TC6D4=



=E5=9C=A8 2026/8/24 23:25, Johannes Thumshirn =E5=86=99=E9=81=93:
> On Mon, Aug 24, 2026 at 02:49:53PM +0800, Dongjiang Zhu wrote:
>> [CAUSE]
>> The runtime activation and finish paths apply active-zone accounting to
>> both conventional and sequential stripes.
>>
>> At mount, however, active_zones_left is rebuilt from device zone
>> conditions.  Conventional zones report NOT_WP and are therefore not
>> included.  Meanwhile, all-conventional block groups are marked active
>> and added to zone_active_bgs, so mount recovery still decreases
>> reserved_active_zones for their metadata and system stripes.
>>
>> The two counters can therefore diverge across a remount.
>>
>> [BUG]
>> Each unmatched reservation decrement lets data consume one more
>> sequential active-zone slot.  Once the reservation becomes negative,
>> data can exhaust all such slots.
>>
>> A later transition from a conventional metadata or system target to a
>> sequential one can then fail, because finishing the conventional target
>> does not release a sequential active-zone slot.
>>
>> If this happens during synchronous transaction writeback,
>> btrfs_check_meta_write_pointer() returns -EAGAIN.  The transaction is
>> then aborted and the filesystem is forced read-only.
>>
>> The reservation mismatch was reproduced by creating small files with
>> large xattrs in batches, syncing them and remounting an HC620 filesyste=
m
>> using SINGLE profiles:
>>
>>    active_zones_left:     126
>>    reserved_active_zones: 3 -> -8
>>
>> The active list contained one partially used conventional system block
>> group, nine full conventional metadata block groups and one partially
>> used conventional metadata block group.
>>
>> [FIX]
>> Use sequential stripes as the unit of active-zone tracking.
>>
>> Do not mark all-conventional block groups active.  Only sequential
>> stripes update the active-zone bitmap and non-data reservation during
>> activation, finish and mount recovery.
>>
>> Assisted-by: LLM
>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fygo.io>
>=20
> Looks good, two small nits though in case you need to resend the series:
> 1) Please don't do the [CAUSE], [BUG], [FIX] thingy, I know Qu does it b=
ut
> noone else does that.

Sorry, I thought that was a good way to explain a bug, but this doesn't=20
look like so for everyone else.

I'll also change the future style.

Thanks,
Qu

> 2) We now have a repeated pattern of:
>=20
>    if (!btrfs_dev_is_sequential())
> 	return
>    if (max_active_zones)
>          return
>=20
> Maybe have a helper for that? Something like
>=20
> static inline bool btrfs_needs_active_zone_tracking(struct btrfs_device =
*dev,
> 						    u64 physical)
> {
> 	if (!btrfs_dev_is_sequential(dev, physical))
> 		return false;
>=20
> 	if (dev->zone_info->max_active_zones =3D=3D 0)
> 		return false;
>=20
> 	return true;
> }
>=20
> Otherwise looks good,
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>=20

