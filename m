Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72613394464
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 01:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785546166; cv=none; b=L47XOkS2e7qCP1s3Y4JwWJTLSO3rDjduhDicE/m2byNDJ6gtPpYLLXYulBjFWJLYgfcVLpBrjYKva8TKpTRe6wNSpuhzk44Qo0I77UcDv3ci+VXIWb26bNLCklsyDkljOKG1cK29oidIz9NHroPoh88qTkUyoPDc9tw49gZwgRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785546166; c=relaxed/simple;
	bh=PFh9lyO1T6z6mTi0G74WH1MBc2oEm8stmzDTm9HeC9g=;
	h=References:In-Reply-To:Subject:Date:Message-Id:Mime-Version:
	 Content-Type:To:From; b=RHRtAQfUn/3Gsh5AlBBzPUF2abqvrf1yphqxU5V6oQ+cVyRbQenS5NVNGmaR7isGGeeIRmBr1Wqbv0aMGysy1FF3WeOH97bk2OUgVg5T8rngEmWglfqcDQQIfLy46EQzNdgbLSEyl1jeoFGXU7F/728utNCLg/Ac499+cKS8+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ee2NhPvc; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ee2NhPvc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785546153;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=PFh9lyO1T6z6mTi0G74WH1MBc2oEm8stmzDTm9HeC9g=;
 b=ee2NhPvc0hEr9A32vfOaX0dC3GiLzPeQOcdaa4aSM5BFIIdhBVFm+BgsGmE9pnpx6LzZPE
 DtLO2nZ80FcpFcHH0lKcoeXAjSxX4XvIJjsq6B+cDncBzqYKJNMO0cLDYBTwDov7H5E7UG
 SQS6jm8hd5iRNq+y/44Z2+Qk06IU/9Ihq3912ZxLvlcJTLhHOwp9VaNhm2MxHHQVRHKql3
 patIPWUn6C+beucC4ukOEaFCLezlGugHuJpMMrszAUTgmX5xl2DKWqAvRr5QqhhOVyf2fj
 o+uGrOB/RTpHpM5FdbtkBr8D0RzP19prIc+ZjiOjYd0Va91vbaXSBE5XxZUv6A==
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com> <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io> <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com> <ca3eeaeb-76d4-4a23-a019-d3a5f4ceb431@fygo.io> <110adc02-4e4e-437d-867d-c8fd3a50aba9@suse.com> <0758b840-f48e-4693-af9b-04793319382d@fygo.io> <b741686a-d101-4529-b74a-4e1277caf84e@suse.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <b741686a-d101-4529-b74a-4e1277caf84e@suse.com>
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature, data_io_size
Date: Sat, 1 Aug 2026 09:02:29 +0800
X-Original-From: Sun YangKai <sunyangkai@fygo.io>
Content-Language: en-US
User-Agent: Mozilla Thunderbird
Message-Id: <6de284aa-f805-4f82-a4d4-3f4af7822cec@fygo.io>
X-Lms-Return-Path: <lba+26a6d45a9+61b65c+vger.kernel.org+sunyangkai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.5] ([113.109.57.41]) by smtp.larksuite.com with ESMTPS; Sat, 01 Aug 2026 01:02:32 +0000
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
From: "Sun YangKai" <sunyangkai@fygo.io>

On 2026/8/1 05:25, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/7/31 21:10, Sun YangKai =E5=86=99=E9=81=93:
>> On 2026/7/22 18:03, Qu Wenruo wrote:
>>>
>>> Full stripe 16K, then the new RAID5F chunks will require power-of-2
>>> disks, and no more than 16K/4K disks.
>>>
>>> So no 4 disks RAID5F chunk in the first place.
>>
>> I've got your idea and got the following 2 concerns:
>>
>> 1. the device count is limited to 3 or 5 device for RAID5, and 4 or 6
>> devices for RAID6, losing the flexibility currently btrfs have;
>=20
> Why you think 16K is the only block size?

My bad.

> You can go as large as 64K, which means 16 data devices which is more=20
> than enough for common usages.

Makes a lot of sense.


> In fact, I do not think you should have overly flex design, which is=20
> contributing to the write-hole in the first place.

Write hole is directly caused by RMW partial stripe write, which we want=20
to get rid of.

>>
>> 2. On each device, we will send a lot of 4KiB or 8KiB io, which might be
>> not good for performance;
>=20
> It can always be solved usings blk plugs.

That makes sense. AFAIK, larger stripes is usually good for performance.=20
But maybe I missed the performance win brought by no partial stripe=20
write. If benchmark shows a good result, this is not an issue.

Thanks a lot for your reply.

>>
>> So I personally don't think this is a good way to fix the write hole=20
>> issue.
>=20
> I do not think so.
>=20
> As I have already said, at least I know XFS is planning doing something=
=20
> similar. Although not to solve write-hole.
