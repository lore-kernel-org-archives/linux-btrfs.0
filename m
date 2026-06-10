Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4500B38E8A3
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 07:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781077349; cv=none; b=fmtaL6MWtJlPjMT4udnhv8gQ7OnOG798WZpD1oagHQsy99qPZhqlCzrW9vyKYheJKyk+QWuOF/VKdW90RnlD8SfxUtSW7hllHWTSO0D2F0nrp/Ct1dm69LD3bek47QY4TXUjFjlMIse/cZWSY4T0BQ3yubsZKQ1Xx51ujN03w4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781077349; c=relaxed/simple;
	bh=4Ao338ewgtP8CkDcSB3dny3nA+zTAZGSTv9kVZVMGMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WKTtdYq6ZQ5zIi1GvvC5PtokaflTGoBeYkno+nYckY8enJTqIy4BexTa4Hh/JYsyklORpwJODMMBh6n3VW90Uh8MrbXjlttfWZeiSTF4bcAvOQHW5GCjXi/fBnU0j8+MseW3psKQWb6PsrIZukY1EquWn79+k2LZK+gcbnJ3FIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gtoV88d4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gtoV88d4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so36989105e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 00:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781077346; x=1781682146; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s1gzV8bjoY0Jbc9fzgKn4tfw6LBqd/QshAZDWt29ZDM=;
        b=gtoV88d43Gahir9ela8TD06bBeUs+R5xIKxiwbOGYA78Ty3Qmd9YcJT+SdxDfSn3D9
         T+CR7ijimDKSIklhoXrFBOBCpA23AeYeAdHDyK4IHH9HTpzl46sCsECmmHXSy3GFE80x
         9WwIPTFcoF31pTMP7ubTZQIovTV0llFkC5NNAaNlXl3ydnsbKcJjSlu4sAK2SCquMNN8
         Xz38SINfosAHNfUySPSxC0bCOsfc+V2W+HDuMYT8qwOUXHP4vmTJfmF2swaOHiSNlF5r
         KneJXe9zvgsxPQskCqeMBcAA5fq0+GxReBI4UuQpeD9pLJmBseTJ28L7jXl+yS4EPJ2e
         Q5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781077346; x=1781682146;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1gzV8bjoY0Jbc9fzgKn4tfw6LBqd/QshAZDWt29ZDM=;
        b=JjgxPvPc9xa1Yw50sEzKT3OqVpq27b4cTqkxuB3Ti2ewkj+P+3/uSSSoerQFpMT/s0
         Gr1flitkBvs7qqkWAu0nHSXhucUsArRplS79kYuBf5bWZDWr8me+sGj7Pn+HEac0nWeg
         ctPEo1ACoAySfk/OZtHdmgAwKQ+OynPNSyHp7B9SxO0DXPbfirL1VubPca+Rnn3lpfwf
         Exosp2KupFseiVHm3aI3Ky8HKsbrPzjimYAdKyY6zoI8gIpGn96jCLprhmmOfFMYNtpv
         GA5FOih/82r5XUDogzqd9Yg5GJRaPMa9VmM8pEj/fy/MfJexiNHL5a5fHjSgcD61SsH3
         oMww==
X-Gm-Message-State: AOJu0YwYXIucnrF6qiP8C/f45TA9qjU/gnUQaX3hQSmCe1px6zQOafgH
	r/BaPBUeQSFVF+iRpa6jB/czboe16LVNDRZjFP3biNlB+fZAVNLbs0Q1xHq2/M4uzAM=
X-Gm-Gg: Acq92OGYXUhDXjayYf0qQYrH0J9QYUi674oMDKPYoLXWkFir/wjsBzYcFlX9yeHtZ5T
	MGD8ffm3QW6tKV4jLViXW1t7piaUn2arLYTp8QKMLgYQJpu2Y0lXI8V2iGxnzFuZwr7GN4lHoYh
	qPUrmVDekXTvfLViv/j3JvAfIaCaympWb/Nv6efCQlBx9k0/XPNueHjqLdnGWL8bPUr0kaSJvwg
	Ut8y5sMqJ9peqyRKdLHvLTVPm7QqR/NAy58wuFkJ44SIpLfpmz6yp3TX9qYLbQKvUtfIYcrvhOe
	i3vgCwMh2suLS2moxbsownI9u+O0pqTUPxA778R424A2pWVFFuUiICtH9heypwPv64dyqErFU88
	Ikr2VystLqo5aLdfuieHtxQ+H3TlarNrsxcNVmOcrS6MaSqOcwALJFOiecNwZkRwzm4BfWifgYt
	2kkuIjYXIOtztrJL+Eg4r/yJC14LaxVGKC4dvBMU2v+SMp8dVNLz81vsn1gg0NR9tYJ1aK0/ptS
	wd/6f96AvC+p+nVKe5LvMsVRd6sjlZBN3jF8NsO5jfBGaoVBlR5gvkyPQ==
X-Received: by 2002:a05:600c:4ec7:b0:490:44eb:c1dd with SMTP id 5b1f17b1804b1-490c26441b6mr392107865e9.29.1781077345636;
        Wed, 10 Jun 2026 00:42:25 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c166495203sm227995195ad.70.2026.06.10.00.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 00:42:24 -0700 (PDT)
Message-ID: <f35e0c82-c97d-447e-9044-3a5059c11deb@suse.com>
Date: Wed, 10 Jun 2026 17:12:18 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH btrfs] btrfs: reject free space cache with more entries
 than pages
To: Xiang Mei <xmei5@asu.edu>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@redhat.com>,
 Weiming Shi <bestswngs@gmail.com>
References: <20260609081135.2972081-1-xmei5@asu.edu>
 <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>
 <jnoeup5w2qznvycfqkoze6f3pv2dg6wgeoax4kiv743tmiapd3@fdmnmlat7a2a>
 <f7220873-14be-4e71-91df-f77486dba803@suse.com>
 <fq2uzgw3rq6vq3hhlfnonj3co2thyi4yyim7eblk6omvvjklpw@tcw5xg5kmcfr>
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
In-Reply-To: <fq2uzgw3rq6vq3hhlfnonj3co2thyi4yyim7eblk6omvvjklpw@tcw5xg5kmcfr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/10 16:58, Xiang Mei 写道:
> On Wed, Jun 10, 2026 at 09:46:24AM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/6/10 08:57, Xiang Mei 写道:
>> [...]
>>>
>>> Feel free to let us know if you can't reprodce this bug. We are glad to
>>> help.
>>
>>
>> In this case, I stronglly recommend to you guys to send out a dedicated
>> mail, showing the PoC, needed assets/step to reproduce the situation as a
>> bug report first, just like what syzbot is doing.
>>
>> Then send a proper fix, with Link: tag pointing to that bug report.
>>
>> If you want to fix the bug by yourself, and don't want trigger-happy guys
>> like me to fix it before your fix, you can just mention that a fix is
>> already on the way in the bug report mail.
>>
>>
>> This is way better for us to do a comprehensive review and provide more
>> accurate advice on what to improve.
> 
> Thanks, that makes sense. We're new to this part of the tree and didn't
> really know the preferred flow, so we'll do the report-first thing starting
> from the next one.
> 
> For this bug, here's what's actually going on.
> 
> The PoC only changes one thing on disk: it inflates num_entries in the v1
> free space header (the btrfs_free_space_header in the tree_root), then fixes
> up the leaf csum so the leaf still passes.

This part should be inside the commit message, better with an example of 
the original value and the bad one.

> The tree-checker doesn't look at
> that header, so the bogus count survives into __load_free_space_cache().
> 
> The problem is that io_ctl->pages[] is sized from the cache inode's i_size,
> not from num_entries. So once the load loop has consumed all the real pages,
> io_ctl->index keeps going and io_ctl_map_page() reads past the end of pages[]
> (it's inlined into io_ctl_check_crc, which is why that's the frame KASAN
> shows). That OOB pointer then gets dereferenced in the crc32c() right after,
> which turns into the GP fault. Both halves are in the log at the end of this
> mail.
> 
> On where to check: we did look at catching it earlier, up in
> __load_free_space_cache() by comparing num_entries against num_pages. We
> didn't because the entries-per-page count isn't a clean number (a bitmap
> takes a whole page, an extent doesn't), so an up-front bound is easy to get
> slightly wrong and end up rejecting a good cache.
> 
> Checking index >= num_pages right at the map is the condition we actually
> care about, and it's the one spot both the entry loop and the bitmap loop go
> through. The write side already does the same check before mapping; the read
> side was just missing it. When it trips we return -EIO, which lands on the
> existing goto free_cache path, so the cache is just dropped and rebuilt from
> the extent tree (a normal cache never gets there).

> 
> The full crash is pasted below for reference. We don't have anywhere to host
> files, so we can't give a syzbot-style link, but the assets to reproduce it
> were in our previous mail.

I believe the mailing list accepts some attachments.

E.g. 
https://lore.kernel.org/linux-btrfs/B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com/

This bug report has attachment and the ML accepted it.

So I believe you can send out a mail reporting the error, attaching the 
PoC/full dmesg as a compressed tarball, meanwhile using the KASAN dmesg 
as the body of the mail.

And with the detailed explanation, it's way easier to see that the fix 
is correct.
Thus it better to include them in the commit message.

Thanks,
Qu

> 
> Thanks again for taking the time to review.
> 
> Xiang
> 
> [    2.760247] ==================================================================
> [    2.760577] BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc+0x3e0/0x4b0
> [    2.760914] Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
> [    2.761229]
> [    2.761307] CPU: 0 UID: 0 PID: 58 Comm: kworker/u8:3 Not tainted 7.1.0-rc6+ #5 PREEMPTLAZY
> [    2.761315] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/4
> [    2.761320] Workqueue: btrfs-cache btrfs_work_helper
> [    2.761326] Call Trace:
> [    2.761329]  <TASK>
> [    2.761331]  dump_stack_lvl+0xbc/0xf0
> [    2.761342]  print_report+0xd0/0x630
> [    2.761354]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [    2.761364]  ? io_ctl_check_crc+0x3e0/0x4b0
> [    2.761371]  kasan_report+0xce/0x100
> [    2.761380]  ? io_ctl_check_crc+0x3e0/0x4b0
> [    2.761388]  io_ctl_check_crc+0x3e0/0x4b0
> [    2.761395]  __load_free_space_cache+0xb7b/0xed0
> [    2.761404]  ? __pfx___load_free_space_cache+0x10/0x10
> [    2.761413]  ? _raw_spin_lock+0x84/0xe0
> [    2.761422]  ? __pfx__raw_spin_lock+0x10/0x10
> [    2.761431]  ? kmem_cache_alloc_noprof+0x14f/0x440
> [    2.761438]  load_free_space_cache+0x356/0xc20
> [    2.761446]  ? btrfs_bio_end_io+0x2bb/0x3c0
> [    2.761455]  ? simple_end_io_work+0x13e/0x1b0
> [    2.761462]  ? process_one_work+0x747/0x1120
> [    2.761472]  ? worker_thread+0x6e0/0xea0
> [    2.761479]  ? kthread+0x3c4/0x510
> [    2.761486]  ? ret_from_fork+0x373/0x880
> [    2.761496]  ? __pfx_load_free_space_cache+0x10/0x10
> [    2.761506]  ? __pfx_mutex_lock+0x10/0x10
> [    2.761512]  ? update_load_avg+0x184/0xd60
> [    2.761518]  caching_thread+0xb19/0x1150
> [    2.761527]  ? psi_group_change+0x521/0xb10
> [    2.761536]  ? native_load_tls+0x1c/0x70
> [    2.761542]  ? _raw_spin_unlock+0xe/0x30
> [    2.761551]  ? __pfx_caching_thread+0x10/0x10
> [    2.761560]  ? _raw_spin_lock+0x84/0xe0
> [    2.761568]  ? __pfx__raw_spin_lock+0x10/0x10
> [    2.761579]  btrfs_work_helper+0x1f2/0xf70
> [    2.761584]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [    2.761593]  process_one_work+0x747/0x1120
> [    2.761601]  ? assign_work+0x167/0x3c0
> [    2.761608]  worker_thread+0x6e0/0xea0
> [    2.761617]  ? __pfx_worker_thread+0x10/0x10
> [    2.761624]  kthread+0x3c4/0x510
> [    2.761631]  ? __pfx_kthread+0x10/0x10
> [    2.761637]  ret_from_fork+0x373/0x880
> [    2.761645]  ? __pfx_ret_from_fork+0x10/0x10
> [    2.761654]  ? __switch_to+0x66a/0xe60
> [    2.761661]  ? __pfx_kthread+0x10/0x10
> [    2.761672]  ret_from_fork_asm+0x1a/0x30
> [    2.761681]  </TASK>
> [    2.761683]
> [    2.771308] Allocated by task 58:
> [    2.771573]
> [    2.771652] The buggy address belongs to the object at ffff88800c833a00
> [    2.771652]  which belongs to the cache kmalloc-128 of size 128
> [    2.772233] The buggy address is located 0 bytes to the right of
> [    2.772233]  allocated 128-byte region [ffff88800c833a00, ffff88800c833a80)
> [    2.772807]
> [    2.772890] The buggy address belongs to the physical page:
> [    2.773191]
> [    2.773273] Memory state around the buggy address:
> [    2.773496]  ffff88800c833980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    2.773823]  ffff88800c833a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [    2.774132] >ffff88800c833a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    2.774435]                    ^
> [    2.774576]  ffff88800c833b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    2.774905]  ffff88800c833b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [    2.775205] ==================================================================
> [    2.775533] Oops: general protection fault, probably for non-canonical address 0x2685384000000000: 0000 [#1] SMP KASAN NOPTI
> [    2.776019] CPU: 0 UID: 0 PID: 58 Comm: kworker/u8:3 Tainted: G    B               7.1.0-rc6+ #5 PREEMPTLAZY
> [    2.776449] Tainted: [B]=BAD_PAGE
> [    2.776602] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/4
> [    2.777111] Workqueue: btrfs-cache btrfs_work_helper
> [    2.777339] RIP: 0010:crc32c_x86_3way+0x55/0x1a0
> [    2.777545] Code: f3 48 81 fa 00 0c 00 00 73 0b 69 c2 ab 0a 00 00 c1 e8 10 eb 05 b8 80 00 00 00 4d 31 c0 4d 31 c9 89 c1 c1 8
> [    2.778372] RSP: 0018:ffff88800d0476c0 EFLAGS: 00010216
> [    2.778603] RAX: 000000000000007b RBX: 00000000ffffffff RCX: 0000000000000400
> [    2.778948] RDX: 0000000000001000 RSI: 2685384000000000 RDI: 00000000ffffffff
> [    2.779284] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [    2.779611] R10: 0000000000000000 R11: 3d3d3d3d3d3d3d3d R12: 0000000000001000
> [    2.779936] R13: 2685384000000000 R14: 0000000000001000 R15: ffffea0000000000
> [    2.780258] FS:  0000000000000000(0000) GS:ffff888177237000(0000) knlGS:0000000000000000
> [    2.780619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.780885] CR2: 0000597d6c72f39c CR3: 000000000890e005 CR4: 0000000000772ef0
> [    2.781193] PKRU: 55555554
> [    2.781316] Call Trace:
> [    2.781431]  <TASK>
> [    2.781535]  crc32c+0x34c/0x3a0
> [    2.781704]  io_ctl_check_crc+0x248/0x4b0
> [    2.781887]  __load_free_space_cache+0xb7b/0xed0
> [    2.782108]  ? __pfx___load_free_space_cache+0x10/0x10
> [    2.782354]  ? _raw_spin_lock+0x84/0xe0
> [    2.782539]  ? __pfx__raw_spin_lock+0x10/0x10
> [    2.782764]  ? kmem_cache_alloc_noprof+0x14f/0x440
> [    2.782993]  load_free_space_cache+0x356/0xc20
> [    2.783197]  ? btrfs_bio_end_io+0x2bb/0x3c0
> [    2.783378]  ? simple_end_io_work+0x13e/0x1b0
> [    2.783579]  ? process_one_work+0x747/0x1120
> [    2.783782]  ? worker_thread+0x6e0/0xea0
> [    2.783954]  ? kthread+0x3c4/0x510
> [    2.784109]  ? ret_from_fork+0x373/0x880
> [    2.784293]  ? __pfx_load_free_space_cache+0x10/0x10
> [    2.784512]  ? __pfx_mutex_lock+0x10/0x10
> [    2.784700]  ? update_load_avg+0x184/0xd60
> [    2.784875]  caching_thread+0xb19/0x1150
> [    2.785060]  ? psi_group_change+0x521/0xb10
> [    2.785254]  ? native_load_tls+0x1c/0x70
> [    2.785436]  ? _raw_spin_unlock+0xe/0x30
> [    2.785619]  ? __pfx_caching_thread+0x10/0x10
> [    2.785824]  ? _raw_spin_lock+0x84/0xe0
> [    2.785995]  ? __pfx__raw_spin_lock+0x10/0x10
> [    2.786189]  btrfs_work_helper+0x1f2/0xf70
> [    2.786365]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [    2.786571]  process_one_work+0x747/0x1120
> [    2.786762]  ? assign_work+0x167/0x3c0
> [    2.786928]  worker_thread+0x6e0/0xea0
> [    2.787095]  ? __pfx_worker_thread+0x10/0x10
> [    2.787293]  kthread+0x3c4/0x510
> [    2.787437]  ? __pfx_kthread+0x10/0x10
> [    2.787602]  ret_from_fork+0x373/0x880
> [    2.787780]  ? __pfx_ret_from_fork+0x10/0x10
> [    2.787969]  ? __switch_to+0x66a/0xe60
> [    2.788135]  ? __pfx_kthread+0x10/0x10
> [    2.788302]  ret_from_fork_asm+0x1a/0x30
> [    2.788476]  </TASK>
> [    2.788577] Modules linked in:
> [    2.788728] ---[ end trace 0000000000000000 ]---
> [    2.788930] RIP: 0010:crc32c_x86_3way+0x55/0x1a0
> [    2.789131] Code: f3 48 81 fa 00 0c 00 00 73 0b 69 c2 ab 0a 00 00 c1 e8 10 eb 05 b8 80 00 00 00 4d 31 c0 4d 31 c9 89 c1 c1 8
> [    2.789909] RSP: 0018:ffff88800d0476c0 EFLAGS: 00010216
> [    2.790134] RAX: 000000000000007b RBX: 00000000ffffffff RCX: 0000000000000400
> [    2.790431] RDX: 0000000000001000 RSI: 2685384000000000 RDI: 00000000ffffffff
> [    2.790739] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [    2.791040] R10: 0000000000000000 R11: 3d3d3d3d3d3d3d3d R12: 0000000000001000
> [    2.791338] R13: 2685384000000000 R14: 0000000000001000 R15: ffffea0000000000
> [    2.791635] FS:  0000000000000000(0000) GS:ffff888177237000(0000) knlGS:0000000000000000
> [    2.791978] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.792221] CR2: 0000597d6c72f39c CR3: 000000000890e005 CR4: 0000000000772ef0
> [    2.792518] PKRU: 55555554
> [    2.792640] Kernel panic - not syncing: Fatal exception in interrupt
> [    2.793588] Kernel Offset: disabled
> 
> 
> 

