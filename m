Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6350435A92
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110060; cv=none; b=l5yILTG8FVeNS6LlBtJKg+bnmfmiZpgkzC6YjD6sPVdCNYO/Z0vf4u81LvQG+hrwWfeGksJeyjtPA17MX4mYCHMehNEzg8ksodjE+YUeiSoL1p5pi4gqJJgyTo0UCypRyRW1nwV1QCEoqHGfD36ooYwuLykMJeTMO+VBHRpZw3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110060; c=relaxed/simple;
	bh=ooVdIIB4R4lf2/MGtLf/rQ0RrRE/muOyrRuV3nN/0SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJP6LTliKrrvvqq+aOJWme/Al7fI7Kj1jw9WOcIq3Fcd9Hx+Hvz3n+r673U4KfaSd71YNzNUrEx7ES4BqyZ1FcD1x03b0X/W8i2DPY0LfmZzaF/gDHdpeTMckzffzBDMMqZF2A/btacT3UgTj9Omz4JV2GVXVuAL7yrjOEzPTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SxpM+NTg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxpM+NTg"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ceab75934dso47047095ad.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 03:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784110059; x=1784714859; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sze1cXIpLxXwgL8yF7BZIwOrNXyaLWQX0/yKiuzTnUA=;
        b=SxpM+NTgWpmqK1qkTg6/KMg6um/ou8foSXcm9ur/WMAP0I0fMnBBM2UGdtkKgKyNu6
         tmabaLHlXncV1B5yRBqP10m7RutIle25U0c+T/0v+aKEyyoHju0zG42pfRc06iI7ybmK
         SaqPAsjRVNQJYce/b6gZ7iqJm8x5o3JWeBRAApjfxJ8577MhAvoLn7z0ZHehfz2AkaD8
         6JtSZZ6vBzQgsTHCEFEFtghjdQ5orR42ESMLc0pso9f5ndISTpQBluludaCa2AEWf2X+
         RtxeQUyfcWcvReX7ZB9QemMoOHAu5Dget2++6DOLvu4lHA3N2MWYfUivLTwTym+G+qfG
         3Ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784110059; x=1784714859;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sze1cXIpLxXwgL8yF7BZIwOrNXyaLWQX0/yKiuzTnUA=;
        b=IGNzJL/QsFAqwse3Y3K73E+djyN5K918q5HuHneNEysndtT/Bb1BaKOXFcM8i5q2Xt
         Kwrc70PrIS8yTvawdSJkMJrCHdoGJAXbN0slCCGpOVvFk4li1yrwM592UgSuOGy7RGLo
         NMnD1LQJM65+yYE/dOxFNJKcNsTi4YJk1ngQsFzuFDNbsQ4dEhaERBDVZOhTtJZ06L7Y
         8fDkjSs944OpmcseTQwMNfO4R8K8sVfIXKI/Zp3xGpezMYXNVuct4L8qRV1Kk17/ziYb
         sVd+WcSWuw84SXswyHnTnadK2oO6qp54QiXegrZ4CO4rz1z1MLEkLh3SD1nZGcxbbfo6
         EKTQ==
X-Forwarded-Encrypted: i=1; AHgh+RpxarWJJCZZMJAO32tLajacOwfFCdnoPdGxB+s0k8w/E679p9FXupYQca65k79bCe52bdP8vzJVIFV9mw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlIL7Afof14cDVm0H8mtvj6ik0aqn3PhjSYmkEhMJ8s/SST9OO
	64goCKp2ripSrh5bKF72qhWgALkRssJnu9GvTxVSUtsI+SWK4oZdULRt
X-Gm-Gg: AfdE7ckVWGLmH2mLocDtRWZ/jhdv5ZkU3Vo5cnqvU+G+VPrWRvJOiyR93mxSOIvz+SI
	CgsCUeb22PUuvgb1OzkmlNdZV0SRp35pJMfjAZtSFZmHId2WSQi8V9naRMuf+WzvNEBeTAxS2hF
	Hnssxvq/Zyji84rVLTDkz8FOW9vskfiMqW0sXyl2sRc0DmyjbzdTcjZVjfQ5sstlhh2x6S3ba2P
	ABChbdTZriwb9gg6G5+/KTKClPCcPpUMh8ZLLWn/gxgfF1S0AdMokxDS8IUbCgP+JmIVEk67fUG
	60rYhLUFmDn3oXjE/ZHpO66MXtyIuKRWTCK0f+r5CU7RQrIFQbgKWrqT6ca2wM6XhhTNctP/U4x
	wkZDuAn9+VCM6NCzxbys65FHVLsQ70m7Y8CiUblvaw8agKhIdtzTYY15pWnErq2qmnK8HWEKjI2
	r7G8ch702PgFFOsX1tBLU4IdjSCZxI40ji7A50z/wqrxWJouZhqD396HtzXmn2nhMDMzKPINJHv
	g==
X-Received: by 2002:a17:903:15c3:b0:2cc:d807:369c with SMTP id d9443c01a7336-2cf03e0f454mr20974945ad.45.1784110058939;
        Wed, 15 Jul 2026 03:07:38 -0700 (PDT)
Received: from [0.0.0.0] (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb72fsm131690095ad.6.2026.07.15.03.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 03:07:38 -0700 (PDT)
Message-ID: <ebf9c527-2181-4afe-b88a-4d24fda6d8d9@gmail.com>
Date: Wed, 15 Jul 2026 18:07:36 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
 <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
 <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
 <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
Content-Language: en-US
From: Zhang Boyang <zhangboyang.id@gmail.com>
In-Reply-To: <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/7/15 17:44, Qu Wenruo wrote:
>> Personally I like the idea of turning metadata trees into merkle trees 
>> (so I wrote it first). But since you are the maintainer, I will let 
>> you decide which way is appropriate‌.
> 
> I'm not the maintainer, I just default to not trust ideas/features from 
> unproven contributors, especially when the idea/feature is not simple.
> 
> Especially considering the increased patches generated by LLMs.
> 

I understand your concern.

> 
> So my suggestion is, if you really want to do long-term contributions, 
> stop coming up with fancy ideas, start from basics like doing proper 
> fstests runs with various combinations, report real bugs and fix simple 
> ones by yourself.
> 
> Earn your name first then consider fancy ideas.
> 

That's exactly what I'm doing. I'm not requesting devs to fix this bug 
immediately or implement my fancy idea. I wrote two test cases and hope 
it will be helpful to btrfs development. It would be better if these two 
test cases can be merged to test suite.

I even wrote a draft patch to fix the second bug. However, the first bug 
is not easily solvable. So I had to discuss possible solutions. If 
possible, I would have written‌ a draft patch for the first bug, too.


Zhang Boyang
