Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD11D3C1F2B
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 07:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784101108; cv=none; b=TzWLCVDdcE+S0kfFkIH/Jpb2T3wBg+X2YZPo5dS1hJpNIwFIkmbp/kIzRsY2xsZWcYTnn+ii21W7AERB2LGB2l4VkkYJKDONg2Qsf7NLhe4WCRzsgEpb7J5V2SPG8CfWRh8sKxSj9MTcjU/lHkDInpo9ENv5J6o6ANTLAtYg2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784101108; c=relaxed/simple;
	bh=u9y0NKNI5kLh4+EHqcH6tqDTxWj0KT+SC5kHZXfCq4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ad0wRLvD0ZQCD0hMTyo1foZGWphYNGyj/VvKhoWQdSPDwUWEI7HP8CmElMSGmQ1ctC9rbJO+72io/JztzyBnidUcypsCxvWGROY5lX0HMGSPTQZaizkF58HNW1nzEk5C1w/veFL9DCNbCtpCuEocdxlVCYK3qpH8JlO5i19CAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4q5Z32+; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4q5Z32+"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so5223128a91.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 00:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784101106; x=1784705906; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IAYAAYyR0srimYaBWGV9eFc7CtxormUYdcLUO2WZR9M=;
        b=i4q5Z32+rZHi9PuBJXCYr0E+JBUq0C8T1Cg4EE0r/OKl+uWJ+WZ51QMr113f6Ii/39
         AEftRoLdyrZd1z3qYQM94X/2XgHDh+WlcpXOq6QnuTHafqhIL4BocRuO6s5WPMhX/b+H
         q+R+RqAfXoqFvpJKwzsCAYXTLt0QjT4ivN3KYYcEgBPsGKHwpy0PQ9pmZcyWTIpnC872
         w/+NwHBNgvq13BwCUs0oDXYbBSYuW/AXjPRNa4fqZYb/a7CsuRoniqbNz6VMgnSvXa6N
         hieYNJ9ZcUo/KmSoKvxzKiIG0JhTpNxkNq8XB7f7IHVPuPsNcSZmkExt4q0QdGiuvAqh
         LtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784101106; x=1784705906;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IAYAAYyR0srimYaBWGV9eFc7CtxormUYdcLUO2WZR9M=;
        b=FjEWbONiKUPxLPsQpNbrzDkzGvRATYLYTdhRgN244vdR49COP+9iZosGdrZVy39wEf
         sIFmgr99t5aX3EuVvw/CST720VVFxJUcsgSIva5tsjnptbSPVTn3tQUK2OErr1BIvY4m
         Bpfoh5xqwdP9WZKIGI4K1SaOBlDpyrAIiIxGbyr1ONO2BXenpYqKv3M7FV7cEJwd9csX
         sFyKjjUzdL32ICezG7+XIuWkA5MybCk7RgvK1yv5OjMVQDpwd5RwjPB/KhiVwrwDP6QM
         frxafRw21lvvOVNWZ9z8ChDCABF88S0BII4EKDMtDg/ONZXNNvTDbIo+mhjrPFDsWNCx
         TlyA==
X-Forwarded-Encrypted: i=1; AHgh+RrSZaYX9dGihCenzsX40+3E8qP2qz9HAYVow6lAEnriYFDP1t72IHO+tn3j05qjrl7oFKE7U8j1x3NMrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzlfNaqmmqQQBivN5gZhbGl9nYyxEwSVYwMpopyYuKmx52tJGy
	AYSMouuftH84L2lPoD32DqkPWvuiStyf6kzNLX4KcokY41Q1vn1+vOKH
X-Gm-Gg: AfdE7ckPKZJl1oNVkq0mEy7X0nwroA+tl0pJWHX5zV4hcoesAdQg57RT6FuCGOglrOZ
	B9E5fEQv35OPvfS5g3c+YiuiK52d8pnbGnjo0a7Ehlu7ZY/ayZAPy3jfaUm6QFGcfQf97AJwoaL
	6SC4AJQghX2+wuhsjWXFfbkq/Qccex2OZM1Z5dA/72mO84IdAys04LCfgSkBPkY9uK4O0ZvDBgG
	cxuV987Yl3BZatTEvVHm66iukqMkMPiqg4q/RS9nMhW9dp8HCVqvGccib1Vu6lhyOaP5HlUtQtR
	jYzIHuz/YXFvmxodIct27G68tVcdA2PxXfPbOfqK1aplbXdb+6PNCgagK+0Pj3VhuQsUVsVVQTC
	gJeyRWOltEK6eSa0vSwRGL+qY86bMv6nTqkXZGVH25i5ZflDa6BpemODQD2N6qyBbNbkAmxywcs
	B/vzurVdar5Xcylv7UBRcFAzcC5gdQkT4wYy2o1lDRqk609YDWzo+yp7jx1sbGuWc=
X-Received: by 2002:a05:6300:8941:b0:3bf:ba2a:6a8e with SMTP id adf61e73a8af0-3c34d583230mr8493283637.21.1784101106068;
        Wed, 15 Jul 2026 00:38:26 -0700 (PDT)
Received: from [0.0.0.0] (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3162a49sm10738007a12.15.2026.07.15.00.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 00:38:25 -0700 (PDT)
Message-ID: <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
Date: Wed, 15 Jul 2026 15:38:23 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
Content-Language: en-US
From: Zhang Boyang <zhangboyang.id@gmail.com>
In-Reply-To: <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/7/15 14:10, Qu Wenruo wrote:
> 
> 
> 在 2026/7/15 15:16, Zhang Boyang 写道:
>> Hi,
>>
>> On 2026/7/15 05:40, Qu Wenruo wrote:
>>>> At first power failure during transaction N, metadata trees of
>>>> generation N are written to disk A, but super is not committed. Nothing
>>>> is written to disk B.
>>>>
>>>> At second power failure during a different transaction N,
>>>
>>> If it's a different transaction, why it will still have the same 
>>> transid N?
>>>
>>
>> Because the power failure occurred just before writing superblock 
>> (transid N). The superblock on disk still has transid N-1.
>>
>> After reboot, looking at superblock which transid is N-1, btrfs has no 
>> idea of transid N existed previously, so it uses transid N for new 
>> transcation.
> 
> Then there should be no problem at least at the next mount after the 
> power loss.
> 
>>
>>>> nothing is
>>>> written to disk A, but metadata trees and super is committed to disk B.
>>>>
>>>> This creates a ambiguous generation N in two disks. Currently btrfs
>>>> can't detect this, and can lead to severe damages.
> 
> At the next mount, btrfs should detect device B has the latest super 
> block, and use that as the super block to mount.
> 
> Since metadata are all written to device B, even disk A may have some 
> stale tree blocks with transid N, stale tree blocks still need to meet 
> other conditions like root owner, level, first key checks.
> 
> I won't say that's impossible, and won't say we shouldn't do anything to 
> address it, but this is a variant of the split brain problems mentioned 
> in the past.
> 

I think this is a very special variant of split brain problem. This bug 
can occur even if no degraded mounts are involved. All devices are 
presented to btrfs at every mounts. Personally I don't like to call this 
bug as a split brain problem because I think split brain should only 
related to degraded mounts.

> I strongly recommend to find out that thread and check if any of the 
> ideas are explored before and if they have their limits.
> 

I did read some of these threads. If split brain problems are solved, 
this bug can be solved as well. But I think fixing this particular bug 
is also beneficial.

>>
>> By the way, I came up another solution:
>>
>> If generation mismatch between devices (or log-tree mismatch) is 
>> detected at mount time, set a dirty flag in superblock on device which 
>> is behind.
>>
>> If dirty flag is set for a device, disable read load balancing for 
>> that device. So (meta)data only read from latest device(s).
> 
> What if some metadata only arrives at that stale device, but not 
> completely reached the good device?
> 

Let me add another rule: always write superblocks of dirty devices after 
superblocks of (one of) latest devices are fully written.

Therefore, as long as there is no died device, there is at least one 
device not dirty so we can get golden data from it.

Of course performance may hit but we are safe.

> That kills the only chance to get the good metadata mirror.
> 

A recovery option can be introduced to disable the above policy.

> And this won't solve the split brain situation either.
> 

I'm not aiming to solve the split brain problems completely.

But waiting split brain problems to be solved is also a solution to this 
particular bug though.

>>
>> If dirty flag is detected, ask user to run a scrub. The dirty flag is 
>> cleared after a successful scrub.
>>
>>
>> Zhang Boyang
> 

Zhang Boyang
