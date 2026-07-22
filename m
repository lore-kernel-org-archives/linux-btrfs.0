Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2900B2E266C
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 09:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712945; cv=none; b=bMNM9YEDnLqJeUxt2zBk0FKRWy0/vNZ8uVG1DFCwIX9pEkmwZaqdSR/550lh3zi1imow0tL6fPel4pZ0KzulCMhWBBKfj8CW4ccettKRapv1JEDf8LhQNdKOTi/8d/xNxoc3FIwChokcQm8jcFvmvTKVxp4+NXyA1ObuvEGXZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712945; c=relaxed/simple;
	bh=GG2EOvrsApZCeL1C+Pb/We/gJRTuu4NFd+kjd4iSItM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5YPw/R55a5LwwwwkoJhm0qnAllquszyuF9ojgssOapwv42kzNkLroBeOO4zG68TP+6TIyIDMzbqL89+YBA5SQSHvPBkQ7iJvF2z50ZumvlSVCXp4yIXg1e22MMxBnVJOTq/gO1hkj3Na+g7lf6o+sEx7FAmvMOEncm8BgRYHgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=agLrWkPh; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="agLrWkPh"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso13562559a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 02:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784712941; x=1785317741; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dFy4yNyzmo3UbOv6Xs2SIMr6v8Q5AhI2ZjktcOYD0w8=;
        b=agLrWkPhHBIv5YF4CciQoQzc+Hf2Qc+YCv6KFnYLFc4cV5YAOyQuZ1AsM3DWqnLKhw
         wZ76dwNftBiE1EqtJh95tPCMrFZTotHnEEu2jzXqn5MO453nE4KmwAzx0ne5e/M1FDlp
         rtksDnCPGuFJUacOEWKQbpgQRlszBFYvgndYdITeqXDUEA4M+FoBxok0hu1QFG2lKWkW
         LhmFnqFPUZ33jjlYPIx68VO1GwhzEoUncyIsa53J/hB3pb+evxYtSgpHRW4YQPtIrUhZ
         On54WiemrUnFt9zd2soD10WplOhprKNLyDLdupND1j4yp/fgTI21NggxzkGH7uULeLLh
         i99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712941; x=1785317741;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dFy4yNyzmo3UbOv6Xs2SIMr6v8Q5AhI2ZjktcOYD0w8=;
        b=ZQuDc6pr80pkZ+p2xChVmG8uQXvT1FxTpAPPhnMDmHtqf4Uxis2MSjzRWaT00eph8u
         olOnnWei/NI9zLGnv84gAL45C8P5ctcRofVjK8Yw8wpNU/7dvMrgAQiCUW7jTaAK9FbC
         IDS9iUgFfthJq7zVs5bZAQ/pFHNPms2oC0IactxcVeeC8zE1kAOZycfj7Ty7/25wDh+U
         r+GkmCyASQZeEV0l0zQNyozILoRUkABeRAUNzTqkrJKIL6mUdLG+TPAMEwhtT68WV2Sa
         1q0ka/YpUeJN6ZRHgG8rBhBMbYs15kppDiC0Ke4gyk6iR1tKcGuUuvdnzGsG18es6jtz
         yZTQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNMOZL3IWS1YhxUVS0S/fO1FRBkSDY0qojFvdZsBWYeigTGI+mp1/ruBhaYIXHZvK9A0bm2AH+EW+Fiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT5qJsOKhrGUcu4J7hqFAClO0yw6AieI5gBiKMrzL4NMYJZgRF
	GQUO/tzlIza8kQ/nHbBsoU6a71Hx+qzVATsYp3Ojb+QOUlCr6S8uVbAlbjc5LP9IS8w=
X-Gm-Gg: AR+sD12hry2odANrInY6PyH5GTtouXJvXlIGDSmq8i7jZSnGljS8tt5MBvguAb7Phzt
	E5B39aBIYunlfonJ8PKyfMRJiV0mXHRL7JQy/cPLrKjDryjUGlRgB+dXuITHSM/LvHaKFacRYYG
	Xz6FSUkiVXUMJkpwCy2RkQkNh+2zk95bk75zsMKk7d+3f+CMxhf6iNZfpxGtUBJeQK//2jLw1Pe
	FY/cJqcOzsYYXxNfU0GXA862vTdZX9/YFF6McleT92QRZ7yPDa/w0nftrtXH9JaCmCC8aPfRvfq
	sTHJndNJrINw0Nen7v3HPF2gEaPCncYc92wUJHMrwX7dFpgbISZh821MFytXEueFpQbultznmD4
	y0y5i4lzDDAsHVNRSS3lTHApeEamPrCJd0rBFp/4CjqHEIUgcXZViHb3rb8Tf07N2qV5rAjU=
X-Received: by 2002:a17:907:3f99:b0:c16:592b:ec4c with SMTP id a640c23a62f3a-c16b46990d8mr926168866b.1.1784712941118;
        Wed, 22 Jul 2026 02:35:41 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f02e454sm882841a12.0.2026.07.22.02.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:35:40 -0700 (PDT)
Message-ID: <8ef80fa7-6c93-40bc-8a49-bf6494104cb7@suse.com>
Date: Wed, 22 Jul 2026 19:05:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/22 18:59, Christian Borntraeger 写道:
> Am 22.07.26 um 10:59 schrieb Qu Wenruo:
>>
>>
>> 在 2026/7/22 18:05, Christian Borntraeger 写道:
>>> Am 21.07.26 um 23:07 schrieb Qu Wenruo:
>>>
>>> First, thank you for taking the time to look into this and trying to 
>>> understand
>>> things and trying to explain things. this is highly appreciated.
>>> I am still trying to fully understand this myself. A question:
>>>
>>>> 在 2026/7/22 04:41, Christian Borntraeger 写道:
>>>>> A folio can carry the folio-level dirty flag while its btrfs subpage
>>>>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>>>>> so a generic folio_mark_dirty() call sets only the folio flag and the
>>>>> xarray tag, without setting any subpage dirty bit and without a
>>>>> delalloc reservation.  The typical source is set_page_dirty_lock() on
>>>>> a GUP pin,
>>>>
>>>> Shouldn't such folio got its ->page_mkwrite() callback get called 
>>>> first?
>>>
>>> Isnt that called implicitely at pin time?
>>
>> I have to admit, I'm not an expert on the MM part, I'm mostly a simple 
>> user of the existing MM interfaces.
>>
>> AFAIK, the last time I brought this thing up, Christoph mentioned that 
>> dirtying-folio-without-notifying-fs is a bug, and fs should not and is 
>> not able to handle such situation anyway.
>>
>> And that idea makes a lot of sense to me.
>>
>> So adding MM list for more help.
> So I now have an userspace O_DIRECT reproducer outside of KVM. 
> (attached) which gave me (on an s390 system, though)

Thanks a lot, I can also reproduce it on arm64 (64K page size).

This is super bad, as we have just removed a lot of folio ordered 
related code to detect such problem.

I'll also check if it's some recent btrfs changes making it worse.

Thanks,
Qu
> 
> [  189.067731] sysrq: Show Blocked State
> [  189.067872] task:kworker/u1665:5 state:D stack:0     pid:1363  
> tgid:1363  ppid:2      task_flags:0x4208060 flags:0x00000000
> [  189.067877] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [  189.067884] Call Trace:
> [  189.067886]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.067891]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.067894]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.067896]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.067902]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.067907]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.067910]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.067915]  [<000003a8b2324590>] __writeback_single_inode+0x50/0x310
> [  189.067917]  [<000003a8b2324b1a>] writeback_sb_inodes+0x2ca/0x690
> [  189.067919]  [<000003a8b2324f36>] __writeback_inodes_wb+0x56/0x140
> [  189.067921]  [<000003a8b2325498>] wb_writeback+0x368/0x460
> [  189.067923]  [<000003a8b23258c6>] wb_do_writeback+0x336/0x3d0
> [  189.067925]  [<000003a8b2325d2a>] wb_workfn+0x5a/0x1d0
> [  189.067927]  [<000003a8b1f0cee2>] process_one_work+0x1d2/0x480
> [  189.067932]  [<000003a8b1f0df30>] worker_thread+0x210/0x420
> [  189.067935]  [<000003a8b1f190b8>] kthread+0x148/0x170
> [  189.067939]  [<000003a8b1e90358>] __ret_from_fork+0x48/0x220
> [  189.067941]  [<000003a8b2e2426a>] ret_from_fork+0xa/0x30
> [  189.067994] task:oob-dirty-repro state:D stack:0     pid:8152  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000800
> [  189.067997] Call Trace:
> [  189.067998]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068050]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068052]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068054]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068057]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068061]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068063]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068066]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068069]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068072]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068074]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068079]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068084]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068086]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068088]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068090]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068094]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068098]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068101]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068106]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068108]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068109]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068112]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068114]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068117]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068120] task:oob-dirty-repro state:D stack:0     pid:8153  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068123] Call Trace:
> [  189.068124]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068126]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068128]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068130]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068133]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068136]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068138]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068141]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068144]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068146]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068149]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068152]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068154]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068156]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068158]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068160]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068163]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068165]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068168]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068170]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068172]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068174]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068176]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068178]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068181]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068184] task:oob-dirty-repro state:D stack:0     pid:8154  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068187] Call Trace:
> [  189.068188]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068190]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068192]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068193]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068196]  [<000003a8b26260fc>] btrfs_page_mkwrite+0x25c/0x8d0
> [  189.068199]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068202]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068203]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068206]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068208]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068210]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068213]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068215]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068218]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068219]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068221]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068223]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068225]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068228]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068231] task:oob-dirty-repro state:D stack:0     pid:8155  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068234] Call Trace:
> [  189.068235]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068237]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068239]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068241]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068244]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068246]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068249]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068252]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068255]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068257]  [<000003a8b2637d3c>] 
> btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
> [  189.068260]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
> [  189.068263]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
> [  189.068265]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
> [  189.068267]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
> [  189.068269]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
> [  189.068271]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
> [  189.068274]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
> [  189.068277]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
> [  189.068279]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
> [  189.068281]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
> [  189.068283]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
> [  189.068285]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
> [  189.068287]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
> [  189.068289]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068292]  [<000003a8b2e24242>] system_call+0x72/0x90
> [  189.068294] task:oob-dirty-repro state:D stack:0     pid:8156  
> tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
> [  189.068297] Call Trace:
> [  189.068298]  [<000003a8b2e19284>] __schedule+0x374/0x900
> [  189.068300]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
> [  189.068302]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
> [  189.068304]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
> [  189.068307]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
> [  189.068310]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
> [  189.068313]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
> [  189.068315]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
> [  189.068318]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
> [  189.068320]  [<000003a8b232bbf2>] sync_file_range+0x122/0x150
> [  189.068323]  [<000003a8b232bc84>] ksys_sync_file_range+0x64/0xb0
> [  189.068326]  [<000003a8b232bd0a>] __s390x_sys_sync_file_range+0x3a/0x50
> [  189.068328]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
> [  189.068331]  [<000003a8b2e24242>] system_call+0x72/0x90

