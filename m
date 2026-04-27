Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A33B38B5
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 09:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283436; cv=none; b=Ny4G6qNAqcItBh6y0TJy79vvz01NttRwsLz6os5c4bYh6UPwdLk2EDBqkeB9d03bYVIAAjReYcStRUtH4PSxx74KGvSKFWNgHCr/fg3x4woJ4juRQOEY/9X04Db23bdLxYyqngAFPeP8TJKi81HHqx5CBy6ZiioxGb9fbwvJ0sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283436; c=relaxed/simple;
	bh=nWcJoA2cPEgvoTREbca0e7TuYS2jJqMbq9CjklhLrVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tVIWFYq1V4xVYo1uAAT+t2p+P2hB9eCML9QtUhF1UowFDGLEc2sHArpvG9OcDU+l3r1fAmeFS0p+C5RoOE1wmLhiptHy1sCSckq5g5qPgvL7jzwfAmlTBqiYgrfm31Smx4q73JXL0Q4tljQPDCLrMmjMudG2IRnzOxSodCC8Wa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=nMqawWCm; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="nMqawWCm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777283429; x=1777888229; i=quwenruo.btrfs@gmx.com;
	bh=tJw1idbtQxMX425dX0pZoZujiVM3iuQi7zIgiuPjHZk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nMqawWCmpYCoEm1UbXd/8tF08hCqGfxthCA8xO2tsw1T8mZcoL2Jjz9HtkymUj6Z
	 S2VFL7NWS1wORJ2U2WhJ4yaLUtgtsGes+6D0tZ+w2VBsythE7yF/+xx0XiDmtvwbo
	 7ExyKsPuy+NiLKRJWgiBYuPhsDd5P2d7dgWHXJ6DNqdeVenJE6kTEtiKY2uJzelDr
	 3noLedKHTA6VquYhJvZnnq++1mvoOTOVN3vqbC0VVlX5yBiNVsXxnHCAITN+yCqUF
	 hqYY+s0ca1NdfyLbhCs4LO+SYK7QU8Oea/p89ZH1u4hX/h4vBAn9StAmQXHV0rkIP
	 NO3OTTVz0pj/xKRtkA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mel81-1vgrrN25tl-00oEFK; Mon, 27
 Apr 2026 11:50:29 +0200
Message-ID: <50baea0e-fed6-4d7e-a9d5-d67ac67a7926@gmx.com>
Date: Mon, 27 Apr 2026 19:20:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: Limit size of bios submitted from writeback
To: Jan Kara <jack@suse.cz>, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260423093052.13219-2-jack@suse.cz>
 <5e19c224-b007-43f9-aa73-3016b5e8ce2c@suse.com>
 <jfq3okghxlwr2ppqtrfold2emgqu3ermkgs2jwoiig4hivtpwo@s2wxyvncqpw4>
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
In-Reply-To: <jfq3okghxlwr2ppqtrfold2emgqu3ermkgs2jwoiig4hivtpwo@s2wxyvncqpw4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ScDBc2TBhqkH8+Sa3+/D5a0MTQz7neUGIbGxrWXEndPLqPpO/Fr
 46W2TWiqZcnVyh5NGEWl6ViRlI6Bn4KTk6jRH0Lm4zyasrPMa82847+JgcigpSZSfKK6VuA
 xm25TfK3GArhMpmuHBtjHI2nbW3Ri0E8KdCaHNX0I+6t7vNsD9FnNJhHR3QpOhqkVOye5de
 q3dYGXxjSFm7LVBZe0aZg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:G3KgWDvWwps=;nK5riZZVVWID3AOUv7Yo9V773Ra
 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
 p0PRmleSHVAe6pQ==



=E5=9C=A8 2026/4/27 18:33, Jan Kara =E5=86=99=E9=81=93:
> On Thu 23-04-26 19:24:02, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/4/23 19:00, Jan Kara =E5=86=99=E9=81=93:
>>> Currently btrfs_writepages() just accumulates as large bio as possible
>>> (within writeback_control constraints) and then submits it. This can
>>> however lead to significant latency in writeback IO submission (I have
>>> observed tens of miliseconds) because the submitted bio easily has ove=
r
>>> hundred of megabytes. Consequently this leads to IO pipeline stalls an=
d
>>> reduced throughput.
>>>
>>> At the same time beyond certain size submitting so large bio provides
>>> diminishing returns because the bio is split by the block layer
>>> immediately anyway. So compute (estimate of) bio size beyond which we
>>> are unlikely to improve performance and just submit the bio for
>>> writeback once we accumulate that much to keep the IO pipeline busy.
>>> This improves writeback throughput for sequential writes by about 15% =
on
>>> the test machine I was using.
>>>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>
>> Looks great!
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> Just one minor question inlined below.
>=20
> Thanks!
>=20
>>> +int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
>>> +{
>>> +	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>>> +	struct btrfs_device *device;
>>> +	u32 writeback_bio_size =3D fs_info->sectorsize;
>>> +
>>> +	mutex_lock(&fs_devices->device_list_mutex);
>>> +	/*
>>> +	 * Let's take maximum over optimal request sizes for all devices. Fo=
r
>>> +	 * RAID profiles writeback will submit stripe (64k) sized bios anywa=
y
>>> +	 * so our value doesn't matter and for simple profiles this is a goo=
d
>>> +	 * approximation of sensible IO chunking.
>>> +	 */
>>> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
>>> +		struct request_queue *queue;
>>> +		unsigned int io_opt;
>>> +
>>> +		queue =3D bdev_get_queue(device->bdev);
>>> +		io_opt =3D queue_io_opt(queue) ? :
>>> +				queue_max_sectors(queue) << SECTOR_SHIFT;
>>> +		writeback_bio_size =3D max(writeback_bio_size, io_opt);
>>> +	}
>>> +	mutex_unlock(&fs_devices->device_list_mutex);
>>> +
>>> +	fs_info->writeback_bio_size =3D writeback_bio_size;
>>
>> With this simplified version of optimal io size detection, do we want t=
o
>> hook dev add/removal/replace to update the calculation?
>>
>> I guess in the real world, the added/removed/replaced disks should have=
 all
>> the same performance parameter for server usages, so no difference ther=
e.
>>
>> And for personal/pro users, I doubt if the original performance problem=
 is
>> even noticeable for most end users.
>>
>> So overall I'm fine either way.
>=20
> Yeah, at this point I'm not sure the complexity is worth it. Normally ad=
ded
> disks have very similar parameters as existing ones, also even if they a=
re
> somewhat different, it will cost you a few percent of writeback speed at
> worst which doesn't seem too bad and it will "fix" itself on next mount.

Thanks, we're on the same page.

Now the patch is pushed to for-next branch, with one typo "miliseconds"=20
fixed.

Thanks,
Qu

>=20
> 								Honza

