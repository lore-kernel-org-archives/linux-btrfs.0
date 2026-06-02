Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6EF32860B
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780367023; cv=none; b=NBJcRzdHxnRa5vE2m1IeaZwRIW8tRJWN/2HKCJ1s9sPEU46XV8uWRLgMwdIH02BUT4stH8DmRL0lyucpE15EtHz9S5JTsPtMM+oPIwEemIlEScwBaGCCF3SnYAMXrB37jSeTC+aMkfhA8yyF8Cf0EyTcwJiHjf+jwPLhBLWvFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780367023; c=relaxed/simple;
	bh=v3C6S+U0tgRcaBu25SznWJ3e2OTmIrJmSzs52RAgdks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dWRQPXnr+8gG9l2JPj4TjudYxroFRw9dEGl3DvMll/fm88mbqBIBuwhr9IM1rynrrTPc22K2XVj6VXf+ObGQ7j/5serdLddxl9iVrM13d3AJ4Zp6CdY4sonBci0mqBSsofS+9bCikUXA1XAMHU4zEF0nKfpyw+OFuOoakmHAXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=j9DzkX3i; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="j9DzkX3i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780367019; x=1780971819; i=quwenruo.btrfs@gmx.com;
	bh=UTjXH3RetOGNglrmEaehomnk+dXrmrXCznw42vDcSYc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=j9DzkX3id7UwfJ1V9fWdr3XduC4gAjcfs/BGFrg4jqtRitkaXlq9qqeW4LPStDjb
	 7z5VOS/wT1JbKDjN7sg0UO/Q7kB/qJxTLHhFKXJ0ZNpwZ4gXJylZ/RHjRDDesrnCH
	 ADJMK1VSbVulQ5/aSRXu22/ytimkf8ASs+3zCS4Fhcv4JyEfYxrTbxQyicqL+62ua
	 vd2rYhAhaV5XqsjgLuF1buo6oydWCu5gESd+zPMDHlC9khYjkLpDTbVNdbOW6cLEE
	 Y5Cc36Hhylv0ZTOvcLwZn2rvX/m2AFneFrTqxuHJVfFXK89VArMLlt+GwjfXzffBr
	 LdlqGqW0haAKMbY/rQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MaJ3n-1wpQR40yph-00KQGl; Tue, 02
 Jun 2026 04:23:39 +0200
Message-ID: <e08c313a-a042-423e-88d2-bcd2d99ffbe7@gmx.com>
Date: Tue, 2 Jun 2026 11:53:36 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
To: Glass Su <glass.su@suse.com>
Cc: Su Yue <l@damenly.org>, linux-btrfs@vger.kernel.org
References: <wlwir19t.fsf@damenly.org>
 <7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com> <ik82qx2i.fsf@damenly.org>
 <04af4b51-9039-404f-808d-0011443f8ba6@gmx.com>
 <579CB63E-1C39-4DCD-99D1-DE3E756E75F6@suse.com>
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
In-Reply-To: <579CB63E-1C39-4DCD-99D1-DE3E756E75F6@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UqkJIyNZDdyVs3tzNMMtmKTe7sJjuicItCJg4fAcbb2/Zhn228B
 dzUuqKgtqvMrlqb+RAxSg+IytflvMT+WuD3RUx66iZg9NZXO/vp6GuU/PlETkbEm3doy9A0
 zEsTlDqtodOZ1JXjQy75DR3R6MZxfd/Q9Ejx3pOzKsLuCg2vZpFo9k7bA91x5W2Dw4VjIwh
 1QDk53pnGgLUAd9C3TPsA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:trDfKUBe8Io=;k8oxJpKbh1AilBpeVLto0UBhBZx
 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
 d7EhXthMrrUkRHJZg8tbyh7MzXvU6QP4KPP49iW



=E5=9C=A8 2026/6/2 11:19, Glass Su =E5=86=99=E9=81=93:
>=20
>=20
>> On Jun 2, 2026, at 06:11, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> =E5=9C=A8 2026/6/1 21:42, Su Yue =E5=86=99=E9=81=93:
>>> On Mon 01 Jun 2026 at 21:23, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>> wrote:
>> [...]
>>>> Since you can reproduce it on the latest for-next, mind to provide
>>>> the for-next call trace along with the faddr2line output for pc
>>>> register of the for-next run?
>>> Sure.
>>> # ./scripts/faddr2line  fs/btrfs/btrfs.ko  btrfs_trim_fs+0x36c/0xa48 b=
trfs_trim_fs+0x36c/0xa48: bdev_max_discard_sectors at /var/lib/
>>> btrfs-linux-for-next/./include/ linux/blkdev.h:1449 (discriminator
>>> 1) (inlined by) btrfs_trim_free_extents_throttle at /var/lib/btrfs-
>>> linux- for-next/fs/btrfs/extent-tree.c:6628 (discriminator 1)
>>
>> Thanks! This is super helpful.
>>
>> However this looks a little weird.
>>
>> The NULL pointer dereference is from bdev_max_discard_sectors(), meanin=
g
>> the bdev is NULL, most likely the device is missing.
>>
>> However just before we call btrfs_trim_extents_throttle() we have
>> already checked the DEV_STATE_MISSING flag of the device and will skip
>> any missing device.
>>
>> Furthermore the test case doesn't change the missing device state durin=
g
>> the run.
>>
>> So there seems to be some weird race, or desychronization between
>> various bit flags.
>>
>> Mind to test with the following diff?
>=20
> Here you are:
>=20
> [  434.761748] BTRFS info (device sdc): enabling free space tree
> [  434.785804] assertion failed: device->bdev, in extent-tree.c:6630 (de=
vid=3D2 path=3D/dev/sdd dev_state=3D0x82
Thanks, this is really weird now.

Firstly through the previous message prefix, we know it's the sdc is the=
=20
first device with devid 1, and devid 2 is missing.

But still we got devid 2 with a valid device path, without a proper=20
bdev, nor DEVICE_MISSING flag.

This looks like by somehow devid 2 still got scanned but without proper=20
bdev populated.

Let me check if there is some other way to allow btrfs to register a new=
=20
device unexpectedly.

Thanks,
Qu
