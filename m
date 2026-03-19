Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2072E8E16
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773910604; cv=none; b=GzMZo8hoqXrtt6rB1ev2x7OVc4eCsTkQIJEY0U6sWmSese+RL4tjT2gbFjc/uoqv394CAcDSP6Tp2qqsS5kYK25muPyjqFEaNY3Onfld6WGIDblCJRrw/1ilhY+2WhvUOjPD86MIOXnTs/mL4g8itjPPBU7rCF64BzJ7IynK1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773910604; c=relaxed/simple;
	bh=Tc3fnVCr6vQZPGnfOswFl1JPIB7ZVw7azQgVeJSOGS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyGGUqzEdGybF2xXnrmP/Y/9ulIv6j+pq1CDbgCmGGa54OcXyKGPj3GhQCFxofiW46GUprpOfHwM70bmJbh3EhBPg8TIhGgVGWoUQN0h31vqgIbVa3tzWpTBPWtZkgGGyI9tQv65bVRDbKY8+mt5+IVC+vOj1IZ0XHHeMfW2+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cvo6YXze; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cvo6YXze"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso2445255e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 01:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773910601; x=1774515401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CCaKyfTy+MCb3lDMXR7lXvvGpD74epCt+GMoNk9ZEQw=;
        b=Cvo6YXze1pfpGSGTW0Vz+gcnRnWpan7KRB+g7c2oJ8tQY620Xh9Lw10lqnbEoWJQUU
         IfKpS9Qg1aFQZaeMQ5EgKGu7FIzraB8WjfbwvKmynwbJiRLdvGBXy5JHRMgKhr/9PZMZ
         RVeLWs43bjvXSKxH9RB27IS41iZ2O02hoKgp8YoaPh3VLWx6uBHN8QCdosmhNMdET2yu
         IifweCNmMxxKvv6iyAK+NAkIxB8HMasZRdSjq1wAZFdvK8Cx9/RQ7IcsfPXb6nab7Quq
         huFrbHFpbCkNhzKV139cC3lTn4RIZL4JE6bkcrPTyjwFZseLniqqZRhiadT9kWSIXuuk
         Itrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773910601; x=1774515401;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCaKyfTy+MCb3lDMXR7lXvvGpD74epCt+GMoNk9ZEQw=;
        b=hamuwnZVNzcKkRqCi/Z5RVFNYUDpOKBzUt4VrO7H2Eh9T1Yd+rVLp9uaeyGaHOqhl2
         ZblV6/LIXasbWTgleHnPeFsOJSp1sswE975cY9GAxkidC9j1U3U6uxSPRx9RZclfwl1N
         kD6TS2OpZYG83nRv8RTHaesvmXXY8VytRcwKlA1VGdwv0+9SIlYbNNqDIQqsXhS3gTri
         Xt+RxRMUs0jXZTxUVYJIu7QWzubZpQyPIKJsvQQ0Bns6wo0E16d3oGjWEvxxbDi3WqNG
         2DqfzLSrEZ4jbEo45O1g7Gk0mj/ylapwRDIS2bPtXksOs2pdEyHf81Rddmt1HeaLfq2K
         Iofw==
X-Gm-Message-State: AOJu0YzNPR1nWmJqDBzUiQW4+GD3dbtRCw0m3NOd1ugR9a4JejIUGwJ1
	/6ZTgdHwzHhn01ttbQM+NTj+wZTOh8AUFWHrVhD0AgsKe+8kxLgrxOFBIaqOKrgg9CwZhgJ1JTF
	Ikyqyuac=
X-Gm-Gg: ATEYQzwrImgu2HIqYF7kuLweP2dHFK5iMR/frJ2+oercBqR0+tPzXrfmQ8klKwiWiqk
	0oS+e+0S9my8/eV64wQvpEBL+qeJZhdu+8dlL4/yh8cfxD1eVeBrU/TH6rZShuEO47N7iYexa31
	A/m0pdNAX+TGDfXJIXlbYUSo0G8SvD1xRIi3YbljjD23VvAXudJNeZv3EgrvhArUIAdDlC70mKV
	jcqVx4PvYQBaZEl5fzgcysa2XsOsUVKj5fvbciXIfza8giWycy8lKfaLRn1/r/Di779aMrSsc4m
	KBKzkmbWK3TAhHCRzaHKN0fRR/906kfnL835dhXGHS38DI9hYk6E1sbS0bHw0Rk4Wxba5eNazjb
	dJAgy+cNJYIHsvSuBvXbt52A7YTcKcm8vbXRwvVbcXXdIloiIU58yDhrBn+GoUwd/QGHL7bSlow
	OI2c7wZsiUg3HgrhdJUxvMV8O7qSyB4xYfOaGfgNfpvDWdLM5JQxI=
X-Received: by 2002:a05:600c:630a:b0:485:5574:8ccc with SMTP id 5b1f17b1804b1-486f445122amr102903715e9.13.1773910601068;
        Thu, 19 Mar 2026 01:56:41 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bbaf9452asm1653656a91.12.2026.03.19.01.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 01:56:39 -0700 (PDT)
Message-ID: <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
Date: Thu, 19 Mar 2026 19:26:34 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: Daniel J Blueman <daniel@quora.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260319053413.14771-1-daniel@quora.org>
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
In-Reply-To: <20260319053413.14771-1-daniel@quora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/19 16:04, Daniel J Blueman 写道:
> When booting Linux 7.0-rc4 on a Qualcomm Snapdragon X1 with KASAN
> software tagging with a BTRFS filesystem, we see:
> 
> BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
> Pointer tag: [7b], memory tag: [b2]
> 
> CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34 PREEMPTLAZY
> Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
> Workqueue: btrfs-endio-meta simple_end_io_work
> Call trace:
> show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
> dump_stack_lvl (lib/dump_stack.c:122)
> print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> kasan_report (mm/kasan/report.c:597)
> kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
> __hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
> xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> btrfs_csum_update (fs/btrfs/fs.c:106)
> csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
> btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
> end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
> btrfs_bio_end_io (fs/btrfs/bio.c:152)
> simple_end_io_work (fs/btrfs/bio.c:388)
> process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/trace/events/workqueue.h:110 kernel/workqueue.c:3281)
> worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workqueue.c:3440 (discriminator 2))
> kthread (kernel/kthread.c:436)
> ret_from_fork (arch/arm64/kernel/entry.S:861)
> 
> The buggy address belongs to the physical page:
> page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd pfn:0x884fe1
> memcg:51ff000800e68ec0 aops:btree_aops ino:1
> flags: 0x9340000000004000(private|zone=2|kasantag=0x4d)
> raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055dee8
> raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68ec0
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
> ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
>> ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> ^
> ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> 
> This occurs as contiguous pages may have different KASAN tags in the upper address
> bits, leading to a tag mismatch if linear addressing is used.
> 
> Fix this by treating them as discontiguous.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")
> 
> ---
>   fs/btrfs/extent_io.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5f97a3d2a8d7..e2b241fb6c0e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3517,8 +3517,16 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>   		 * At this stage, either we allocated a large folio, thus @i
>   		 * would only be 0, or we fall back to per-page allocation.
>   		 */
> -		if (i && folio_page(eb->folios[i - 1], 0) + 1 != folio_page(folio, 0))
> -			page_contig = false;
> +		if (i > 0) {
> +			struct page *prev = folio_page(eb->folios[i - 1], 0);
> +			struct page *curr = folio_page(folio, 0);
> +
> +			/*
> +			 * Contiguous pages may have different tags; can't be treated as contiguous
> +			 */
> +			if (curr != prev + 1 || page_kasan_tag(curr) != page_kasan_tag(prev))
> +				page_contig = false;

I am not a fan of this solution.

Although it doesn't affect end users who don't have KASAN soft tag 
enabled, I don't get what we can really get from the different tags.

I mean all those pages are already contig in physical addresses, why we 
can not access the range in one go?

Maybe it will be better to set all pages with the same random tag if 
page_contig is true?

Thanks,
Qu


> +		}
>   
>   		if (!btrfs_meta_folio_test_uptodate(folio, eb))
>   			uptodate = 0;

