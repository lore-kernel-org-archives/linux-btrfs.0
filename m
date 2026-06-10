Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F42772D
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 21:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781127032; cv=none; b=Lj6TcRjYCK89ys8ILJZpWU5w+T3FwevViUFobdx54Mpb0GNn7knn/d5NcXGiSg6tGew4RLWLgVePj2j0FbYDlDaVx3GgphhL23sH9r16xULwCkd4QqLaJz87kzY/DxrCcRPPbWM/THGTOvkixvHfeoWGtSQd74xSqSohSelWwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781127032; c=relaxed/simple;
	bh=knFZQIU3RitInb6GHEsKGhfF0ndcAKfemmGtq8EWZ8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otMU2bCzVUoIdH7cHmHTgS/PngmsB2EQujm7qXh+HymmNTQ6ModwlmdbyEV4s6ztLNyl2EUlv1C84iVwf7cBQX7nHiXboubVrJdOfDZyjR+NIAKwpoYWS+BHtRGyPx9ZAXpzlR/0JJmcatMK10XComLniBe8KRgsaInQMN6uYMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gGHbwuWk; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gGHbwuWk"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-befee9e5ef7so872759466b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 14:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781127028; x=1781731828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PK0T0u1AQ2vQ2ApnaoP1ADurHDOYM8RYl9Zgetnmqqg=;
        b=gGHbwuWkBDURmF2+ijSMmhkP8D0bPiB7h+M4iDLZpJ6icEUPF+NbDIUxnnYC4onONv
         nzKW2NL7GfkPTgYeu/ZJ/dHcPCUYGqmqt5wz0evVVV7d+Tlbt8zrCbeCDzsxEBntgVoF
         aXfkmKIXknGTkXd+NavmGOC/1VoRa6wEOnHvKlRVRWmxpvXKXILgNbw13t2eNgZ8lEO4
         wciTJ1qqgdO/gwReAdpLpflr493GoRaIQxjo4GuzbA76gWRpyp0g1KKQ3be76GsFCDgS
         IO2b0z5dXSDYn+G4c+ClUvWCLZZd/kNAw96lV0JJJ4VJ9DA8gys19HCRdQheZoZeWeq0
         AcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781127028; x=1781731828;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PK0T0u1AQ2vQ2ApnaoP1ADurHDOYM8RYl9Zgetnmqqg=;
        b=JGojAfceP+C+45QfNVC5c3sfYQc1c53VEhfhHnmAwk3WyMtvDNmHzsdd0BLVhRJvc1
         DZe8muNPjOYV8QlirCNaWp7ug/6g50dz65KL2YkcLNn1tXQbs/7n6lVPLPOB6oB678B/
         euZWkdzzbcRb42KuaoxLtTSChRC9K/xgLWajRJSI6enLCkT90AZ5evPCHoJvAyhjeHpS
         xjKN5QxEJsii9cGJltdXk545GcTPDn7fUWzAhWYfZqXCZEbItKVlwqZjzFp4xIGvVJjP
         5sux0pVf/6znWqJQ6oki2JILu7NXudylMUKveRGhQ36dA5NyY5O8fDztolVy5HY2pY4w
         1ohw==
X-Forwarded-Encrypted: i=1; AFNElJ8kAlMhAjnbr3vp3hde5Yb9AUmZKRrVvNK0xqIsJa7o5uDN97olspJ9QMBfVKoBmZ4JKE92hxnhGK0Szg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBgpf+SwEVBF5VfVrO4IRxpZnP5YOxuhPdIZ4ZHMkyi56oGjOA
	+l+KK+Pe/NCO9pVN5m0TIw3OAFs4KiaP0xUM1LEY95cspu2+sOQxrgWCidIMn96SA98=
X-Gm-Gg: Acq92OFL+gKdkn7RWx7ip/GOUrQSXEUMLt7ZvuKIpDZ+b1VrD64tvjr7vfO2BN7q8VG
	UPTfUvnN13SUHTcoLbIHgnhiHePQAx7ipBF7Ft2v0NcoReKntFr/pVKpMCVM8lZphgUpzxd+4b0
	UlmCJfeYF+2/SF+Rzphu1YDKBxkSfsXk/mpYXlTxHrK+saTLHo46K2tfgCzKDo2vWME6UMb6mWU
	nsTJRO1sGnImkSjlrvW2tgrUQfxDk3bixEmvK9OspHl0+/3clcvDFuR3g+CxUPg8eLvN9GJ/Viz
	BijK6eOwE3uGNPkTczSUT8Lvz+YpvUoSgQINIsVc56VaSqrjAqC0SOHUL9+Ni5+askH02LnOe6D
	n5bm+Ou9sg7BcHW/rSO1gp/p6X3UkxWMpS1HyaH7KPkYDr/mGFZ08JwEz91yawOyvIhU1cWjF5u
	aFeF+MyRykbaoBEx/5srnE+kfzyoP0otzB0AO0JKsU/+eaFMdlnO74N1tlZb3G7eDB/e2KmnIKP
	VkTzPYOaCnRZV5akTBS/g046+6A2ExwlN60uesv8A5L0cLqvPEIrl8N
X-Received: by 2002:a17:907:761a:b0:be3:b3fb:e2 with SMTP id a640c23a62f3a-bf372349b33mr1015295566b.32.1781127027759;
        Wed, 10 Jun 2026 14:30:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282883647sm29927068b3a.36.2026.06.10.14.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 14:30:26 -0700 (PDT)
Message-ID: <ac0ae1f0-8c8a-46de-ab9b-bdf7bfb1c799@suse.com>
Date: Thu, 11 Jun 2026 07:00:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH btrfs v2] btrfs: reject free space cache with more entries
 than pages
To: Xiang Mei <xmei5@asu.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <josef@redhat.com>, Weiming Shi <bestswngs@gmail.com>,
 linux-kernel@vger.kernel.org
References: <20260610172926.844265-1-xmei5@asu.edu>
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
In-Reply-To: <20260610172926.844265-1-xmei5@asu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/11 02:59, Xiang Mei 写道:
> When loading a v1 free space cache, __load_free_space_cache() takes
> num_entries and num_bitmaps straight from the on-disk
> btrfs_free_space_header. That header is stored in the tree_root under a key
> with type 0, which the tree-checker has no case for, so neither count is
> validated before the load trusts it.
> 
> The load loops num_entries times and maps the next page whenever the current
> one runs out, going through io_ctl_check_crc() -> io_ctl_map_page(), which
> does io_ctl->pages[io_ctl->index++]. But pages[] is allocated in
> io_ctl_init() from the cache inode's i_size, not from num_entries:
> 
> 	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> 	io_ctl->pages = kcalloc(num_pages, sizeof(struct page *), GFP_NOFS);
> 
> So if num_entries claims more records than the pages can hold, io_ctl->index
> runs off the end of pages[]. The write side never hits this because
> io_ctl_add_entry() and io_ctl_add_bitmap() both stop once
> io_ctl->index >= io_ctl->num_pages; the read side just never had the same
> check.
> 
> To trigger it, take a clean cache (num_entries = <N> here), set num_entries
> in the header to 0x10000, and fix up the leaf checksum so it still passes
> the tree-checker. The cache inode has i_size = 65536, so num_pages is 16 and
> pages[] is a 16-pointer (kmalloc-128) array. The load now tries to read
> 65536 entries, io_ctl->index walks up to 16, and pages[16] is read past the
> array:
> 
>    BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
>    Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
>     io_ctl_check_crc (fs/btrfs/free-space-cache.c:420 fs/btrfs/free-space-cache.c:565)
>     __load_free_space_cache (fs/btrfs/free-space-cache.c:655 fs/btrfs/free-space-cache.c:820)
>     load_free_space_cache (fs/btrfs/free-space-cache.c:1017)
>     caching_thread (fs/btrfs/block-group.c:880)
>     btrfs_work_helper (fs/btrfs/async-thread.c:312)
>     process_one_work
>     worker_thread
>     kthread
>     ret_from_fork
> 
> free-space-cache.c:420 is io_ctl_map_page(), inlined into io_ctl_check_crc()
> at line 565, which is why that is the frame KASAN names. The out-of-bounds
> slot is then treated as a struct page and handed to crc32c(), so the bad
> read turns into a GP fault.
> 
> Add the missing check to io_ctl_check_crc(), which is where both the entry
> loop and the bitmap loop end up. When num_entries is too large the load now
> fails like any corrupt cache: __load_free_space_cache() drops it and rebuilds
> the free space from the extent tree, so a valid cache is never rejected.
> 
> Fixes: 5b0e95bf607d ("Btrfs: inline checksums into the disk free space cache")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

I'll add a Link: tag to the reproducer at merge time.

But I still strongly prefer you guys to submit a bug report/reproducer 
before sending out a fix.

> ---
> v2: add more details in the commit message
> 
>   fs/btrfs/free-space-cache.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index ab22e4f9ffdd..bbc4db7fe74b 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -555,6 +555,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
>   	u32 crc = ~(u32)0;
>   	unsigned offset = 0;
>   
> +	if (index >= io_ctl->num_pages)
> +		return -EIO;
> +
>   	if (index == 0)
>   		offset = sizeof(u32) * io_ctl->num_pages;
>   

