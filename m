Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9969239B94B
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908904; cv=none; b=a9gvsvwrGJv8HtSry/wdv8AwWEEM22UrdwHCGrZcNDxiPdQt82rSUD3AUBvp8AagOPYFC8bx3MM+JPNQb5TuXXueuBr2Ob2I7IrH97eWg5uci2KcGHB5+t4StrFRwolKrQqxvNzHPk7CYdieEMOggeflaaPKMQ8Z+jTTRXHWPsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908904; c=relaxed/simple;
	bh=/CmhggVcP7FKdoOFLkwtzPuSayN1YZdPVA9zZX+CR2g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ciBc6hUe2FCJ+OS1PunnO3W4h4Wzv8ULMFT1Qeb9MWVezZsTLDc8Ab432Vo1ofJgo+ueKrDXe0b9951CEvdXumiJA2FinWQv3IVHKvQjKBpRrypz+aLNcCTMvoujvHsLaZGQoMlFGczwCbmj02SCVpvCnUdxAA6Aa97D4xdyuuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BU+8CRUF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BU+8CRUF"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4873ce69ba9so15401085e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 15:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774908900; x=1775513700; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VF2FSQ7QUbNvthtKJvDzxVZCDtjhHU5BspA59sUdCAQ=;
        b=BU+8CRUFP+33C5mos3N2jq63Sd8feb9z8pIcnErwm7TNhRtrAh2/QUB0GpjSejqMzn
         teNFMuWNVL3OiQgKZar3FUDdnGM/E2tRN1lJF1JoI3ulDxTwRVWTJH2sqmaAStmFu2H5
         +o6Av7jZvni4Wym28jRGNEbTaJqxBUdOMvEcZOW3vHNtmx8u0xkJc5fn1+ISnD1HO+9X
         AHzVidJlXbPwSfr8mXVwlA8SzoHoR0yUVnh3cYh/yJXBlqdaXAleHWUCxqGDOlMOloOP
         cfAD4vi1nu0AzF1M4VJtVqTNLgwsf8+GPNRaEJMbGbDe6WahsTZ8RmSIrQrZtNz6XBbe
         cy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774908900; x=1775513700;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VF2FSQ7QUbNvthtKJvDzxVZCDtjhHU5BspA59sUdCAQ=;
        b=kcsuUexd81jPD8zOK08Rqf8/dkVSD1oBhovYugy8CKGDDqvz0q5WcTMVmdkXe4gJ+3
         V9tuh9BgdcmL8/moUCvOcwu4A1Rh7OHMQVG0py3eB5Os/3W5yS+v1H6FW+/QBzXqlvb8
         NyUlS6Lw1im6W3vDXqpxNZ+pPhM8H7Tnj8LXCeAxPNbDlQg18e7QxCpsaCXgDrJ9FxGT
         XlOkNtQkaFNPWW0zlnIykBMbotepokgyKIqA4YdININ5ZVhtdqzuikd0usABam72iyha
         PA/Mw2zseF792TM4zb+BjHxL+b9vCf3VIt8asbuY5MPGi3IpWV98EFkKItxV37YPXNoc
         E0/A==
X-Gm-Message-State: AOJu0Yx342x6zgP4dCRh7egCxiK6IiM7JldLbI7/MVY7MzW1lb9KED1j
	ENjv9YgC2uX0l03BBkMDa/VRY1i+o+PCzc11EHUDzFLCKwRB9mD+pdmeVJG6vboqJe0=
X-Gm-Gg: ATEYQzw5cusQydv9PZ4JkuIL9DAxvd2YpA3Eadh/yHqUPkKC1QR5JZ8nYqPLyM88X/Z
	DwmT3fjWuNNFr8F6ioyaAyjmc6itCeTnx3AW+ClfYUVx0G+gS+/hyUvV+lJlzqm5sUlBPps95/H
	eGIXSmKrdzu3WnXeck6uRDzBA+qyWXqNRUcX/9vuzz6BTECVYwaCNBu1QsK3AlgnNX1K4MzF2Y7
	H1zcp80hhxcERbozJS+gQZNN2azIUFjrky7kKrHWbeHsDKXF2ATX/CYLJC2aQjMtedZXcw5eMjd
	Gkapy8Wd+uO2t5jyy1ru9hvmCRRMoKRKJrwaTpLeV4rxrCNS0E0WbnndaLUPDQPOBTku+qGfyOk
	7Yz7RZF5hmP4hJqVEXX9BbSsLN/CFZ7FBoNqV3Qe2/4WlNtEwbtxRAFX1hISw+B2N0tnZ+knc2H
	6f45FPQoYdXcOXAafJVSdNmT3lU9dl2juAoDY4sMXi+HNdxz8Lvj8gkeDKZFipeA==
X-Received: by 2002:a05:600c:4744:b0:485:3b00:f92e with SMTP id 5b1f17b1804b1-48727d5e95bmr234780405e9.2.1774908899873;
        Mon, 30 Mar 2026 15:14:59 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427b1ef0sm115728835ad.74.2026.03.30.15.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 15:14:58 -0700 (PDT)
Message-ID: <05020d93-524f-458d-a44a-765043ddbdb7@suse.com>
Date: Tue, 31 Mar 2026 08:44:53 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
From: Qu Wenruo <wqu@suse.com>
To: Teng Liu <27rabbitlt@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com,
 linux-kernel@vger.kernel.org
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com> <aclYf4R2XxlUkxAQ@rabbitArch>
 <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
 <840361b6-9b27-4419-b8ab-891ab254fac9@suse.com> <acq5Y9VuDI9htA-I@rabbitArch>
 <6564fe96-ead0-45d4-9655-cd14f13bdc9a@suse.com>
Content-Language: en-US
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
In-Reply-To: <6564fe96-ead0-45d4-9655-cd14f13bdc9a@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/31 08:18, Qu Wenruo 写道:
> 
> 
> 在 2026/3/31 04:30, Teng Liu 写道:
[...]
>>>>
>>>> 3) Use buffer_tree xarray to iterate through all ebs
>>>>      Since this is only for error handling of open_ctree(), we're 
>>>> fine to
>>>>      do the full xarray iteration, and wait for any eb that has
>>>>      EXTENT_BUFFER_READING flag.
>>>>
>>>>      The problem is, we do not have a dedicated tag like
>>>>      PAGECACHE_TAG_(TOWRITE|DIRTY) to easily catch all dirty/writeback
>>>>      ebs.
>>>>      So the only option is to go through each eb and check their flags.
>>>>
>>>>      I think this is the one with minimal impact, but may cause much
>>>>      longer runtime during this error handling path.
>>>>
>>>> My personal preference is option 3).
>>>
>>> Or the 4th one, which is only an idea and I haven't yet verified:
>>>
>>> 4) Handle error from invalidate_inode_pages2()
>>>     Currently we just call invalidate_inode_pages2() on btree inode and
>>>     expect it to return 0.
>>>
>>>     But if there is still an eb reading pending, it will make that
>>>     function to return -EBUSY, as try_release_extent_buffer() will
>>>     find a eb whose refs is not 0, and refuse the release that eb which
>>>     belongs to a folio.
>>>
>>>     That should be a good indicator of any pending metadata reads.
>>>
>>>     So if that invalidate_inode_pages2() returned -EBUSY, we should wait
>>>     retry until it returns 0.
>>>
>>>
>>
>> Thanks! Yes, it makes sense, simply waiting on the bio counter doesnt
>> fix the problem here.
>>
>> Among the options, I prefer option 3. Although it may be slower, but it
>> only happens in mount failure path so extra cost seems acceptable.
> 
> The problem is not limited to mount failure, but also affects 
> close_ctree() too.
> 
> As it shares the same root problem, we have nothing to trace nor wait 
> for any pending metadata read.
> 
>>
>> I am quite new to btrfs codebase so I dont know whether
>> `invalidate_inode_pages2()` would be a reliable solution so maybe I
>> should start with option 3?
> 
> Sure. Although iterating through xarray may not be that simple either, 
> as you may still need to look into all kinds of extra locks/rcu lock 
> etc, and if you apply that to the callsite of close_ctree(), it may be a 
> much bigger problem, as we have a lot of more ebs compared to mount time.
> 
> You can even mix option 3 and 4, e.g. only after 
> invalidate_inode_pages2() failed with -EBUSY then switch to xarray 
> iteration.
> 
> This should greatly reduce the number of ebs that are still inside the 
> xarray, thus makes the iteration much faster.
> 

Although option 4 is much easier to implement. I'm already testing with 
a testing patch applied, so far the fstests run looks pretty boring.

If you can verify this fix against the original report, it will be 
appreciated.

But please note that, this is only a PoC, not perfect.


The biggest problem is the busy loop wait, as I hit a bug of an older 
version that invalidate_inode_pages2() is called before freeing the root 
pointers, thus invalidate_inode_pages2() will always return -EBUSY, and 
take a CPU core to do the busy loop forever.

Even the current version has that problem fixed, it will still cause the 
same unnecessary busy loop for very slow storage, which is far from ideal.

So option 3 is still needed to avoid busy loop, and may detect 
unexpected dirty ebs better.

I believe the best option is really mixing option 3 and option 4.

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c835141ee384..39420d599822 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3706,7 +3706,11 @@ int __cold open_ctree(struct super_block *sb, 
struct btrfs_fs_devices *fs_device
         if (fs_info->data_reloc_root)
                 btrfs_drop_and_free_fs_root(fs_info, 
fs_info->data_reloc_root);
         free_root_pointers(fs_info, true);
-       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+       ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+       while (ret) {
+               cond_resched();
+               ret = 
invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+       }

  fail_sb_buffer:
         btrfs_stop_all_workers(fs_info);
@@ -4434,19 +4438,23 @@ void __cold close_ctree(struct btrfs_fs_info 
*fs_info)

         btrfs_put_block_group_cache(fs_info);

-       /*
-        * we must make sure there is not any read request to
-        * submit after we stopping all workers.
-        */
-       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-       btrfs_stop_all_workers(fs_info);
-
         /* We shouldn't have any transaction open at this point */
         warn_about_uncommitted_trans(fs_info);

         clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
         free_root_pointers(fs_info, true);
         btrfs_free_fs_roots(fs_info);
+       /*
+        * we must make sure there is not any read request to
+        * submit after we stopping all workers.
+        */
+       ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+       while (ret) {
+               cond_resched();
+               ret = 
invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+       }
+       btrfs_stop_all_workers(fs_info);
+

         /*
          * We must free the block groups after dropping the fs_roots as 
we could
--
