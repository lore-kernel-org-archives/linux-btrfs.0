Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0753A35CB7F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 23:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777333726; cv=none; b=nRXddYvMbAl4k/f8+BwR5daSgbpJOVvmSAfcwyeofFB5ZNfWoBME+GklSm3QO8onVbvBa/8KB79KLEggDYnKK8y8dS2Eq1rFB/niP6KR9h9SLtknUWksH6Ow+B4nCMhyq9DyFXLqgAuVaE08/lrij/z0IDg4xgJvSpK8BuAohSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777333726; c=relaxed/simple;
	bh=SNzz4iirqZIw8X+oCkVjtsDOgbvEf6J8iCWMZ4+eEs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsI74mk917tb/YSFCG+OxqBY0BX1nEA0B3mW9Lg6kdYXcfwb0hLDLUgnxfVelNQ6Z545mK7dAgludbP543VHjVSKVCCPXfG9TBp1jdL9Q3idjVGtG3EbDdUCyhXIPRSAuRpRod+Bm1YC3OR1tH2JcpdFIHTtuZYzj0ghXQk3VaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=SbZIyjVw; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="SbZIyjVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777333722; x=1777938522; i=quwenruo.btrfs@gmx.com;
	bh=zsxd0nJMOzQjyyfytxbWKcbQd5ZdISYZYlhcy+yEVfk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SbZIyjVwTt87+JPq9Mb0VPwDV/bm1vnCOb4cJFIiISZnaVqxyU+Quec/z7JkzplM
	 idhBUqzHobTmkzdi01kq8NmFBFJ7xTaPwGPRasRqstA3nynY6TwDnZwhAxibr285k
	 AF4WqmS4Ij/x3hh7XkC4gKiUCjq07iIdKsM6C5C5gagPHpPDuJH3in9cJ2Of7ewlR
	 iykTkBsvYiSUbDDgPkmfXArPoBElz2cX8WprBlskm29/+ud1EASSvpTFL1MXjOTY0
	 uPDzd1fdFKj4NLOmDZKIbHZV72ZJYp7m7WFbrgF+nPmvpsD+LH+2/9WTSMTMyW6ty
	 WKYGujFvR8sb3SO8JA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MkYXs-1vVUtr2uBq-00bz6A; Tue, 28
 Apr 2026 01:48:42 +0200
Message-ID: <0fd4ea4b-8f8a-4f0a-8923-17b038fe2745@gmx.com>
Date: Tue, 28 Apr 2026 09:18:38 +0930
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
 <50baea0e-fed6-4d7e-a9d5-d67ac67a7926@gmx.com>
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
In-Reply-To: <50baea0e-fed6-4d7e-a9d5-d67ac67a7926@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:p3yU1JBTn/h956wRp3kOZZprgXcPHazbvQW/9BUgWzq2BZXMwmq
 xj1rSSoAQoLYxsauVZz3tkiOUNF/KHCp63zK2ffZNtz6HnajFMXh73fYrz3WQNFb74Prkh1
 5lCCUSdamFIN0w7ygb0pqraW7imgdhr931uJbhHlGmDQgrAf2XhsNfw0bkGpJJlSpJxSett
 B2g2KZyUuOyAbEFnQpEuQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vO1cvjY8p34=;qDvbkRYYl9jNbl0KfFDxVvP1qGn
 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
 /lOyUHNF9g4hnhA==



=E5=9C=A8 2026/4/27 19:20, Qu Wenruo =E5=86=99=E9=81=93:
[...]
>> Yeah, at this point I'm not sure the complexity is worth it. Normally=
=20
>> added
>> disks have very similar parameters as existing ones, also even if they=
=20
>> are
>> somewhat different, it will cost you a few percent of writeback speed a=
t
>> worst which doesn't seem too bad and it will "fix" itself on next mount=
.
>=20
> Thanks, we're on the same page.
>=20
> Now the patch is pushed to for-next branch, with one typo "miliseconds"=
=20
> fixed.
>=20
> Thanks,
> Qu

Just a minor update.

The existing check is considering device->bdev always exists, but we can=
=20
have missing devices which doesn't have device->bdev, and this will=20
cause NULL pointer dereference during test cases like btrfs/027.

Fixed in for-next branch with the following small diff:

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8d36e8a9f0d9..93a923e4ecaf 100644
=2D-- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8224,6 +8224,8 @@ int btrfs_init_writeback_bio_size(struct=20
btrfs_fs_info *fs_info)
                 struct request_queue *queue;
                 unsigned int io_opt;

+               if (!device->bdev || test_bit(BTRFS_DEV_STATE_MISSING,=20
&device->dev_state))
+                       continue;
                 queue =3D bdev_get_queue(device->bdev);
                 io_opt =3D queue_io_opt(queue) ? :
                                 queue_max_sectors(queue) << SECTOR_SHIFT;

Thanks,
Qu
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Honza
>=20
>=20

