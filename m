Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765DC1CD1E4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 03:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773371385; cv=none; b=oJLYybEPKX/1VtBIc5vAdKS31NJd8TxjGDikq8pQax/t3AMpVZP+e8sYJtY4evJ32pH+d0EjdAnieBWKmJ9VqxgSzcUQEyVGGNR3BuUzFlKv+EKa6GZtG4LhxhIypm+wzq/knZRJaQ3ObhrvmRGmSLGA0FA+2cpl5h7RIyM2FBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773371385; c=relaxed/simple;
	bh=C/8mUQKkQW3Nw+n7SYR1OvSfVZq85NOMHEHdbRNGIas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDXi/GexnczbqONdO70NDHoPGEfTlq3F1V9HtYgn5fWeegW2qqFvyAT+SNMxHEAQ0Qv+n6rMcHUgvifCgUSTD9Vi5bk4zcj5dbHTpgOsY5dFUb6QLdYgUda4YCD53iSY9A6Ez63giVipneLqiLenr4yiC3IdMfCCgiMciMF4tx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JCYOZtwm; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JCYOZtwm"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-485410a0a8aso15208875e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 20:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773371381; x=1773976181; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WJB3Q3K9nN6lyOyAV/eD0epGzhDSQTZR2IuP5rmRiEU=;
        b=JCYOZtwmCJUMmJhgjvaUoAr0qtRNDIriOpI88enxQEJTQyBRuru+Pwke0d1cNFD1M8
         JmLnMC7y3k8LFxjWyQmEOa/E02W7mFpfHs+1LKG29z/SOqhDQz0P1FRxO0ijf5sEOqev
         Cu3NwECIPSizPW65sNkFOtL2mKKHyxRS82vdGG4KSVTBMlGJxFIPf97BxTJuQRz8DlTZ
         MCzqWF0iHV451qeJZmNFcLa9lVQRUhp3Tp6nxVcvORx758uFSWcrQJaC+5DWp68xs2DC
         0e8lM0H+iH1qRIQNnWMx50IKTNamEp5C+jZsNKgldtL+MngvmXNxtDFz+wam4e7op7jF
         xLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773371381; x=1773976181;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJB3Q3K9nN6lyOyAV/eD0epGzhDSQTZR2IuP5rmRiEU=;
        b=prRvDkmp8Y4ISK9Apd2gy8wrYsJhNstDXcTm8qj2UPs7uUevqciY4agF94DabnsCQa
         jl9lP81HJbEIiXx8BRYNy0HW1xZxL9lhAZMIiGMl49AIp0/VtyP6cRNWqM88LpYKQ7jY
         vDDuEN8TQVsh66IbJxV91RVbXN00P+1wdv4IIwWuaGWgJwtJX+cMJLdmfIFwPMcrEgbw
         sf1c73Qdx75A2LmK+AkAKtQRN9xu1AI8PnGQ1Oh9wxePvakPiFvL7UP+Jl1YyqEvEg/K
         1YcWCATRVwdFTsxYZOjwRx78IzNXJe/vsejBVLOSDCKHjbs1W67/xhGB/O6TUThMcJVO
         3WWg==
X-Forwarded-Encrypted: i=1; AJvYcCUiWADDhiO810AKHHsqC81QFYE+scCLSQNBTUqmdO/c9IpqdSufwuWZd5hzO71IfCnM3RKVyuvblbEsfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjLhk1QliMTUL7EbQnloLP6OzZTwfHueMLLFSum9bThznUMFow
	yjtRzHR5EAJX6WLyaJTm97KaCWRoL2TauxJXwcbekoHUOJlGatGSwwXZde0Asb2WoXI=
X-Gm-Gg: ATEYQzz0+SESKUAd/JcikRMV4HEvL9YgpNiW4H+TFgDGGIfE7pcyKOxw7c4mQvjvEk6
	gtxmnl5HHqJStEDl9Q79WIswnzw1x3Qkqhk85/AFJxgDG38/P23vUodCCK30tNu/ydiniSV2ERX
	FRMraLr6W69Vvn28Qxsf3zadJcNJm1jtt0OMKnsWPxkmHYnsDL92o8baNBOVrwGWg3ESa4+YUQQ
	fzMHaQmWHgZAgZlLs6EQA9bC0Yk5g4LLaLH9ODR+OfZ/7zY0i9LYGBIUA/ev5Vybo69iE1lxfWS
	00anLO3z/zOK7jNgJFD2E7RN/Owisc4mCq9Bf6fwJSlcNigtDz3/tUA6UXfzDMcGXbvZi1gB05+
	PRjY1NUfyMPLN1A0CvvftvcQWvG10GMJMXpY+5lo3rW/SbAqAB0pNSwhYHhMkC5ts11huDmuz9G
	hEQCYd10GRoh7LwL2koyMowEdEg+hr7NImQWOZYjiVyCOpSG8BHpE=
X-Received: by 2002:a05:600c:c4ac:b0:477:7b16:5f9f with SMTP id 5b1f17b1804b1-4855670e7c6mr22890475e9.31.1773371380446;
        Thu, 12 Mar 2026 20:09:40 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a072418e9sm4664280b3a.3.2026.03.12.20.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:09:39 -0700 (PDT)
Message-ID: <14bae5ed-c12c-4380-a9a0-7a714217913e@suse.com>
Date: Fri, 13 Mar 2026 13:39:34 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject root with mismatched level between
 root_item and node header
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, stable@vger.kernel.org
References: <20260312102229.220570-1-gality369@gmail.com>
 <ac5058d0-ba4e-4de6-b231-64a29ee2d5e3@suse.com>
 <CAOmEq9U14a=pwN_dw2M70gfujhMKki434cfmegoxcyUpkYs5bQ@mail.gmail.com>
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
In-Reply-To: <CAOmEq9U14a=pwN_dw2M70gfujhMKki434cfmegoxcyUpkYs5bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/13 13:19, ZhengYuan Huang 写道:
> On Fri, Mar 13, 2026 at 5:29 AM Qu Wenruo <wqu@suse.com> wrote:
>> Nope, we have btrfs_tree_parent_check structure, which has all the
>> needed checks at read time.
>>
>> The point of using that other than doing it manually here is, if one
>> mirror is bad, but the other mirror is good, then we can still grab the
>> good copy, but checking it here means if we got the bad mirror first, we
>> have no more chance.
>>
>> And during read of root-node, we have already passed the proper level
>> into it.
>>
>> So the only possibility is, your fuzzing tool is modifying the memory
>> after the read check.
>>
>> If so, it's impossible to fix.
> 
> Thanks for the review and for pointing this out.
> 
> I agree that btrfs_tree_parent_check is the intended read-time
> verifier, but the crash path here relies on a cache-hit bypass where
> that verification is not re-run.
> 
> My earlier description may have been misleading, or at least not clear
> enough, so let me clarify the exact trigger path in more detail below.

My bad, I forgot to mention the correct way to fix: you should put the 
check into the cached hit path, other than adhocing random checks around.

The correct way is to add an optional @check parameter for 
btrfs_buffer_uptodate() so that cached extent buffer will still be checked.

> 
> Two different metadata blocks are involved:
> - Block A: a root-tree leaf containing root_item for tree 265 (this
> field is corrupted: root_item.level = 1)
>    item 11 key (265 ROOT_ITEM 0) itemoff 13489 itemsize 439
>        generation 4255 root_dirid 256 bytenr 18787663872 level 1 refs 1
>        lastsnap 4214 byte_limit 0 bytes_used 16384 flags 0x0(none)
>        uuid 4cc4bc58-9708-2848-a264-19b95269f104
>        ctransid 13 otransid 13 stransid 0 rtransid 0
>        ctime 1766050670.362764444 (2025-12-18 09:37:50)
>        otime 1766050670.362000000 (2025-12-18 09:37:50)
>        drop key (0 UNKNOWN.0 0) level 0
> 
> - Block B: the actual tree-265 root block at bytenr 18787663872
> (header.level = 0, otherwise valid)
>      item 57 key (18787663872 METADATA_ITEM 0) itemoff 14198 itemsize 33
>        refs 1 gen 4255 flags TREE_BLOCK
>        tree block skinny level 0
>        tree block backref root 265
> 
> In relocate_tree_blocks phase 1 (get_tree_block_key), block B is read
> with check.level = block->level = 0 (from extent-tree metadata for
> that extent item).
> This I/O path runs btrfs_validate_extent_buffer, and level check
> passes (found 0, expected 0).
> So block B becomes EXTENT_BUFFER_UPTODATE.
> 
> In phase 2 (build_backref_tree -> handle_indirect_tree_backref ->
> btrfs_get_fs_root -> read_tree_root_path), level is taken from
> root_item in block A via btrfs_root_level, so expected level becomes 1
> (corrupt value).
> Then read_tree_block is called for the same bytenr (block B), but now
> it hits EXTENT_BUFFER_UPTODATE and returns from
> read_extent_buffer_pages_nowait early.
> 
> On that cache-hit path, btrfs_validate_extent_buffer is not executed
> again, so no level mismatch check occurs for expected=1 vs actual=0.
> 
> Because no read error is returned on cache hit, mirror retry logic is
> never entered. So this is not a “bad mirror first, good mirror later”
> case: there is no second mirror attempt because the read already
> succeeded from cache.
> 
> read_tree_root_path then builds an inconsistent root object:
>    - root->root_item.level = 1 (from block A)
>    - root->node/commit_root level = 0 (from cached block B)
> 
> handle_indirect_tree_backref computes level = cur->level + 1 = 1,
> searches commit_root (actual level 0), path->nodes[1] remains NULL,
> and btrfs_node_blockptr(NULL, ...) crashes. So the issue is a
> cross-block consistency gap at root construction time, not post-read
> memory corruption by the fuzzer.
> 
> That is why the fix in read_tree_root_path (checking
> btrfs_header_level(root->node) == btrfs_root_level(&root->root_item))
> is needed even with btrfs_tree_parent_check in place.
> 
> To clarify, our fuzzing tool does not perform any in-memory
> modification during testing. In fact, this bug is not caused by memory
> corruption at all; it is triggered entirely by corrupted on-disk
> metadata together with a cache-hit path that skips re-validation of
> the root block. I have also uploaded the reproduction script to
> https://drive.google.com/drive/folders/1BPXcgVI4DLzDcufNyynOakKD4EKnfVCg.
> 
> To reproduce the issue:
> 1. Build the PoC program: gcc repro.c -o poc
> 2. Build the ublk helper program from the ublk codebase, which is
> used to provide the runtime corruption capability:
> g++ -std=c++20 -fcoroutines -O2 -o standalone_replay \
> standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
> -I. -Iinclude -Itargets/include \
> -L./lib/.libs -lublksrv -luring -lpthread
> 3. Attach the crafted image through ublk:
> ./standalone_replay add -t loop -f /path/to/image
> 4. Run the PoC: ./poc
> This reliably reproduces the bug.
> 
> Thanks,
> ZhengYuan Huang

