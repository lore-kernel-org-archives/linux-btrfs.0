Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F5422A7F0
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932626; cv=none; b=hYZNJ+RLweO2atHr5L0xMUDrChlgPJOVCLj8Rrn+3oHYwVAgK/M860S0Ay/tWsSu/VUBbj6+TEWq2g8WejZ/Bx9zGdOFF159X7P4SGl1voYNdReYb/j6iSjLkWCksD6S+fqsPVYs1SULhiWt9tln3XT/0guM3Z2UwLIcG+9JArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932626; c=relaxed/simple;
	bh=lK2z7cSQvTHEED6wwCCICr1DRNZ3TNeygaSOXp10YJg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ffIaXqJtExJbkr0xeW2EgKfVmrByZeUlBpJSmnMrFoeGzb1Nh1uOJMJy8tL8r6wkgpgMUos+nnlLYnaOGKLEAe9s6ZNNNAtKm/BYdC8ltArZe4eeD0ROPR2l1G2JGv7gJU6+B0/YV/AX6ZM7yVFiLCGrSaZ1tw+2ecF+sP4Xkjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=siUDTbk2; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="siUDTbk2"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5218927884fso28566471cf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 19:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786932623; x=1787537423; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9UjgPsIurOg/tszojWDb8bPohwsDdLE6+WMdoTOyM/s=;
        b=siUDTbk20IKmMCLYurQTqMpiz/azLe80uRSzzkyMhESOz90bQVmLFgP3xFaCUeoCmd
         fZEYIPyTcfo3N3XfsuKSjIvw2Tfw2ptMOrNllawe2Vs34Si29ZDJcUc8aZZTaM0tM9DA
         DMcF0dM7JgnA+gE0oBRoYVv8kalh8fxLp+OSYQOQch607h7oCKItJqYW3G/ipGKM8auk
         eHeQTW1ZqFB51N4POlTwLc+JAsqRqJ1RfWPHxr5tZV6VoW/TM52cX+2hBXaESm1sdX7p
         qm2oTCZC8R4lA7dHPk7C72LcKOM9I5H5cB40/1q6ZVMD9dcDgRROLPHoRXYMthgWswEN
         DIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786932623; x=1787537423;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9UjgPsIurOg/tszojWDb8bPohwsDdLE6+WMdoTOyM/s=;
        b=ona3SEm5uZjrVYioVWrZPzaqaPt5nyHrCNTTaCrSX/wgXqQsVvuCl6aEez2DkjCEU3
         BdAFg6HNK7jLgnELwgYbEI9kR2hq1tbmCPV9E5lx2esXI+2nCR4g5L0ddZCkr9Qi0qvH
         korWc6ZFa+1K7zRE/dPHJMGSVYe87vRrnbwIU+g8fFMVB8iz7up+plUJAgsEDXsNvcTp
         oOB24P5CrGwArJ/oWmntN1sznkZXMLUBWlqv+PMbL9GmYRbuVKvEwLhIFtbO5ugNDbOj
         HSu5by88NVIi5ePkbAh8WdC6uG827VYwnRpyEZwOO1Wd4n8f6tpy/J1oXxHK+zI52n3W
         1QeA==
X-Gm-Message-State: AOJu0YzzJw4v0D0SGQ8oxUULA/3FH4nFvxjR6IdqAFeVjch1n/8cej8C
	BvlIHLc3BIPO8f4rugovELAbcM2S46XmNvmVVf15RAzgpeR9sk1rL1X7
X-Gm-Gg: AR+sD102X3h7w7dHJKuEWXQEM71tvU8SOoqDEQGcjDk7JrNwqkTy1PveRIag15NcNgX
	Zehsk2I3F/ZTQIV4dWz44cj6n75Ug6cPhGM7ACICd9HwZ2/nI4dYDuBcSLiMoB8yafHwfMM2k27
	NwcW617hKY3fxXB1d8bW9MOhhUctO4nmLH1Bp2KnN725NASwZtl2zFDEmfXyz/Cf9zcB4l1+gcb
	GCmK/1ZIK/woR/CHdQg2H9SpNg8KpD35Pn+rU+Z0ZFC/4RWcz+NtiTW5CzJbzlaE8RMQO3OFXyX
	of97q+XWOpmt8W/DZD7AE4jSAQpYxUlOgab9FgfEtlQEqfU2ieXgoe63ijQDZh8XuxBVGx3c7za
	eKK+TIJU91iqR8X7k33O6UXbsno0+cR4Yi5B1pqCsavU3ZUAVQa+LMFGRkuMPptN6dwF9W7HrgJ
	DeQc6sMvhSJsWf20JqtaUtpMbffvgan6CQl4OkFDb/2MY9REeW/TQVNi/YlKusFOlV1xUGcRWc9
	3qjNhnMGJeC4Un0Dy1l3MnmiGpkPXaZ
X-Received: by 2002:a05:622a:3d4:b0:51b:fb82:67d1 with SMTP id d75a77b69052e-52d8542c8e8mr195140151cf.20.1786932623564;
        Sun, 16 Aug 2026 19:10:23 -0700 (PDT)
Received: from smtpclient.apple ([2600:1016:b124:3234:a874:664b:2cbc:f571])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db60e9975sm2652081cf.1.2026.08.16.19.10.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2026 19:10:23 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] btrfs: fix transaction use-after-free in raid stripe
 insertion
From: Shuangpeng <shuangpeng.kernel@gmail.com>
In-Reply-To: <267b4f65-9afb-4997-ad26-d1ff5addce9f@suse.com>
Date: Sun, 16 Aug 2026 22:09:51 -0400
Cc: linux-btrfs@vger.kernel.org,
 clm@fb.com,
 dsterba@suse.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <501EF29A-2130-40F7-B369-F94A9F3DFE52@gmail.com>
References: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
 <267b4f65-9afb-4997-ad26-d1ff5addce9f@suse.com>
To: Qu Wenruo <wqu@suse.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 16, 2026, at 21:58, Qu Wenruo <wqu@suse.com> wrote:
>=20
>=20
>=20
> =E5=9C=A8 2026/8/17 10:57, Shuangpeng Bai =E5=86=99=E9=81=93:
>> If allocation of a RAID stripe extent fails,
>> btrfs_insert_one_raid_extent() aborts and ends the transaction before
>> returning -ENOMEM.
>> btrfs_finish_one_ordered(), the production caller through
>> btrfs_insert_raid_extent(), still owns the transaction handle. It =
handles
>> the error by aborting the transaction and then reaches the common =
exit
>> path, which ends the transaction again.
>> The premature end can free the handle and drop its transaction =
reference.
>> Transaction cleanup can then free the transaction before the caller's
>> second abort accesses the handle and transaction, resulting in
>> use-after-free.
>> Keep the abort at the failure site, but let the caller's common exit =
path
>> end the transaction once, after it has finished using both objects.
>> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe =
extents")
>> Cc: stable@vger.kernel.org
>=20
> Please disclose LLM usage.
>=20

Hi Qu,

Thanks for pointing this out.

I used Codex to help generate the patch. I had confirmed the bug with =
KASAN,
and I also verified the proposed fix with my reproducer. With the patch =
applied,
the reproducer no longer triggers the KASAN report.

I will send a v2 with the appropriate LLM disclosure tag.

Thanks,
Shuangpeng

>> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>> ---
>>  fs/btrfs/raid-stripe-tree.c | 1 -
>>  1 file changed, 1 deletion(-)
>> diff --git a/fs/btrfs/raid-stripe-tree.c =
b/fs/btrfs/raid-stripe-tree.c
>> index b210371ce91e..89e259a47d8d 100644
>> --- a/fs/btrfs/raid-stripe-tree.c
>> +++ b/fs/btrfs/raid-stripe-tree.c
>> @@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct =
btrfs_trans_handle *trans,
>>   stripe_extent =3D kzalloc(item_size, GFP_NOFS);
>>   if (unlikely(!stripe_extent)) {
>>   btrfs_abort_transaction(trans, -ENOMEM);
>> - btrfs_end_transaction(trans);
>>   return -ENOMEM;
>>   }
>> =20
>=20

