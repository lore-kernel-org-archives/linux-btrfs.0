Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADACD2BDC1C
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 04:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788928438; cv=none; b=K8FNlKv7mZNauOSGSvOVn9C+bu5feM2YC6SjlUBxN5whBjg/C6G0HoaOAskYQki0BkeL1/Qi8TCsGHvwWTEDjKxp6Wk6Ive0k4JbYkms7aY+D1zdmeOevz/149/TZb9vEr+J7KP3YHnO3SBwx0R04PhSjZgGxJuSTo+eS9sBp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788928438; c=relaxed/simple;
	bh=uIP5+X9fRzK8IuB/mzSXnHXzVEaJz/KO0XKashYAsGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQXWE51P3WgKYMHSMbw41i27GvDWUf0IJ9kyu3wBuuX/rzUAdQ8/HvYzLURy+DcZagjeGzedTij0Ri6jnafl7kfBQ2i1tuKk+YhQCYvDsrvT+eJ5uFL/CU9Wtm0q7xyezq751I72WGmdw7COgnJghrJje4eTE07Lz/cZownHaAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=l8a6NNmE; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=D6c4twYo; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="l8a6NNmE";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="D6c4twYo"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6894Wbtx3299174
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2026 00:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=qS/T
	tJdGLPA5+bK/9bT71cro3XlPuAYM0hPCqu2zzdU=; b=l8a6NNmE9liP1Q/lJQ/E
	sOqUVHPLYvuC+I1k7v6xqDF+7L3ulN1Ob/nLhb6tiuazVOmHG4N9l6Y7+pc8rNQ0
	+iLSkHQbwT8pJ0tgCGf5mc2xD9ZG9WHwOWuQo045+tgqvCKHu9c+Tr+uoWNE0s52
	6dYPcGEsNsb0bYEJtWCwGI6rhVG0GBLRPnjKW7BaNv4NmgdtjAxvcqDwTTyjl6He
	DK63oz+Z3zxWCRPnJeVeGCyE6cDJ4EfXhFq1UADckXvNYHI8a5ph4O7NoA8aBCbv
	A8l3AfgF3iB9EKiB/8B7ErhIDxrT33r7YZuiccEquMxaIVj5dsGe1tQQ47tsfNgw
	rg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gjnpp4w4c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2026 00:33:55 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5308af39ab3so37015191cf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 21:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788928435; x=1789533235; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qS/TtJdGLPA5+bK/9bT71cro3XlPuAYM0hPCqu2zzdU=;
        b=D6c4twYoshjGhU5x/ql7GHghsf0kk1/6e7AxMrrVVC78bncIR0bYZ0F9t64odUTQCu
         9kimlTVRIj0DavZV3YUGyx9gPxZLYiMTpLqOGaoAYkRFjX82LzE3xNOJ82jT8RYUwoxe
         54jLwunPkPBmneR288uDTgK/FTV/8n0rH5la9e/oRC5RFrW5aTR+RuHqPeZT3bhsS6sv
         KKnzvNU5Zl99fkOWyiA9Fhdo7Q7C9mMmyMMTUUzksRirFsRQnjSiXJWHXjzIroe74jqg
         wz3MagwSeV9ZvFkuogwmhx7Wn+ILjUTG4PsajyoVMgFBFosUdhUCwAZrW9HOF6BqJgqI
         9rgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788928435; x=1789533235;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qS/TtJdGLPA5+bK/9bT71cro3XlPuAYM0hPCqu2zzdU=;
        b=nILNYKP6++QwMDG2cdsWgINusfZxckQ83whXncgI8c5ExHhM1AXUlUwvxkjNsxhA+J
         oTDNOWgmc1ivxMBJ8iRdMlXbPZm/MZHJ0HsW2kno+kZ7gNNsGdsF8SLddWUAInkkjFRO
         qGgrldgYzjfoDWY/9JDOZY69+Vkkztu/TPODObTmOAz+uBLPXdqi1l9M8M0Uw588Ker+
         J90bO3K3ROCHGj9JmP1+VFRA3gVeJ6iq+MQVvtTgIUwyPPt/inMQz5mSa9lNUliPw6qc
         0+MFGOF2YYp/I8bLKde8cWApSaGpPqMNXLdkxe2J/qEj8Waut36Yff+Ijj+ZwYpUJdmN
         CZdA==
X-Forwarded-Encrypted: i=1; AKwUvByYFd6QwTifvFTcS6NY6JtsmNaQx+wfjnotUHU3LO5Y2mZ5hNQQxwwCDa9iQx6FnOuaM+cYVv9nyD0S3A==@vger.kernel.org
X-Gm-Message-State: AFuF++lLxYPL+ifMQrJZF7rM8MGSaZjbYrtElPttkgkXKKQ7Ky2ju+sj
	dKr/4QfemCWbLGR2giMmBtyqYxy8gzslkEDFSpo11QQb4Y5OJb3epo1mqKVay+WrVKDuVagToMy
	TtY+OqxIltF98g7R1I/KehLdUfjI1WjCoxfllHuZ9LbEwulU3ylVnSqovFG3E
X-Gm-Gg: AYBFou3224W4IHTY+A3Owu1gkx4xSFENaAwsZlcn7SPWkLu8DQUmBd0BTMs5CxOPIy1
	/8BJsSgYe9F2fK8uF3zO7JrOSfoopxiKmBmSf8vniSIp8B6r7AzzDhhCdkLHwLZKqV3oLv9OyJa
	8TTyhIjeG4JWa6Y8GcC8aijMqGmVqhFztFtQtpVRC5iP/9Rqfas+jYz/LH2rc1IfBf6IOOt1m6c
	tXSyvdptzXvrEvLQRawvODwMkmeixjk8/JOfS2YGvsz3p/+IOucxho7URg+w5Db2rfvUCP4YY10
	2FSIWyBJHIryTXaUjW9sBA9hWy5hcVdR9M/YqQ6KqSqX7F3QMFFG5WvIV4xY2kDwhFWnTchVsJr
	XjawubHRqTKBNz0hIU3lzDKYcDHydI/LEp78wQOM1hObYPGpaH9TUrGM=
X-Received: by 2002:a05:622a:2d0:b0:52d:953b:2c25 with SMTP id d75a77b69052e-530549ee1abmr420515701cf.38.1788928434779;
        Tue, 08 Sep 2026 21:33:54 -0700 (PDT)
X-Received: by 2002:a05:622a:2d0:b0:52d:953b:2c25 with SMTP id d75a77b69052e-530549ee1abmr420515351cf.38.1788928434312;
        Tue, 08 Sep 2026 21:33:54 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910405966f0sm134596966d6.6.2026.09.08.21.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 21:33:52 -0700 (PDT)
Message-ID: <5d2d27f9-e815-43d0-a7b5-6601c5e2509b@columbia.edu>
Date: Wed, 9 Sep 2026 00:33:51 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] btrfs: remove the v1 space cache
To: dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
 <20260909010846.GH9053@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260909010846.GH9053@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: MLYyKaKvAelVHvvBtLsHpfyqKs6p1UhG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA0OSBTYWx0ZWRfX2VZfp3z8KXVQ
 /4Jvyhn36twrLkM+tlfAkdNYuzah2ntys4e8Nsyc7zNMLHDvOYqvK+g5crNRLZL5iFeCYEkdHZf
 0htwJ3FbGNGkbw/aX54sCWHScS6ZrZEF7bs+TRhjxvwuUzDYuLfk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA0OSBTYWx0ZWRfX0eNuh8wjoeim
 Jh48aHmUu6U563+yPbvz0+GtRaOkembVFLnJfnb9UHitKU3L15nc5os4gUHUYAfLHigExcLGfJ6
 s7CAxz15y69rx69gM/r7acLpwS7mu6nOQ0XFn95cJm/1BK68jJVW0doF3icC1geXRLaL1dk82/G
 PAsmZrhAvDW0p4u1F7hT6kYMpMfauGgM27iTf9O/NZazCZ1bUcsu0tDMTyH7aZZTHDmCiC3Y7/C
 56XuzvVzbxspP0Rt2/GoJSYEoIuDNDQdaIjDN8p72MLz6x4aILDeFQwUILV1sZSquhtzLd7Sruk
 B/W6JXsd6wKLhpCOa8Ff/lcB/g86QhrVHq4+xJ61GymvzmjQniQUm3N/krEffrkbZ6foZ7hgudx
 VYbNeocnz4hMGHGvPyVhXCM55f4A18trcfjDDviEQVMpN7V80Tr4HZpQAWY9fZLif6XaISWmfdw
 n7289nb/A9L5rl8mZOg==
X-Proofpoint-GUID: MLYyKaKvAelVHvvBtLsHpfyqKs6p1UhG
X-Authority-Analysis: v=2.4 cv=Xbi5Co55 c=1 sm=1 tr=0 ts=6aa0e1b3 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=LShM9Hbsi2Ufa6fwzJoA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 impostorscore=10 malwarescore=0 lowpriorityscore=10 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609090049

On 9/9/26 4:08 AM, David Sterba wrote:
> On Mon, Sep 07, 2026 at 09:19:15PM -0400, Tal Zussman wrote:
>> Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
>> options can't select the v1 space cache anymore, but the code is all
>> still there, and a filesystem with an old cache and no free space tree
>> still enabled it from the superblock. Qu suggested removing it rather
>> than converting its page handling to folios [1].
>> 
>> Patch 1 stops enabling the cache from the on-disk state, so an existing
>> cache is cleaned up on the next read-write mount, as -o nospace_cache
>> already did. This is the one user-visible change: the cleanup is now
>> unconditional, and a read-write mount fails if it fails.
> 
> In case it fails there are 2 ways how to fix it:
> 
> - convert to free space tree during mount (the recommended conversion
>    from v1 to v2) but it could fail for the same reason
> 
> - on unmounted filesystem do 'btrfs rescue clear-space-cache v1'
> 

Thanks, I'll add this to the cover letter.

>> Patches 2-5
>> remove the write path, 6 and 7 the load path and disk_cache_state, and
>> 8 and 9 the SPACE_CACHE flag and the unused half of the cleanup helper.
>> Patches 10-15 remove the trimming ranges and the free space inode
>> special cases in the write path, which only the v1 writer used.
> 
> The piecemeal removal is good, makes it clear what's still needed, as
> listed below.
> 
>> What's left is what's needed to find and delete the cache inodes of an
>> existing filesystem:
>> 
>> 1. lookup_free_space_inode(), btrfs_remove_free_space_inode(), and
>>    btrfs_cleanup_free_space_cache_v1(), which runs on the first
>>    read-write mount and zeroes cache_generation in the super block.
>> 
>> 2. btrfs_truncate_free_space_cache() and delete_v1_space_cache(), which
>>    relocation uses to get a cache inode's extents out of a block group.
>> 
>> 3. btrfs_is_free_space_inode(), for the evict and inode update paths.
>> 
>> 4. The on-disk definitions: cache_generation in the super block,
>>    BTRFS_FREE_SPACE_OBJECTID, and the free space header and entry
>>    items.
>> 
>> space_cache and space_cache=v1 still fall back to nospace_cache with a
>> warning.
> 
> The sperblock::space_cache will remain unused and the only valid value
> is 0. Repurposing it in the future is possible but we need a long period
> in between.
> 
> The points listed above for the code that will be still needed seem
> minimal. It could be removed eventually leaving only the unmounted
> clearing.
> 
> I'll add the series as topic branch to linux-next. The mentioned change
> to tranaction NOJOIN is simple and no-op in the code so it'll get
> updated for the final merge.
> 

Great, thank you! I'll send a v2 with the transaction split in a couple
days.

