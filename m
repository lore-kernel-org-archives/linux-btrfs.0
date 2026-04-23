Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C133E21E098
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776920420; cv=none; b=uvpJyGaIVMjVDmLBSJicKIKqqQqgUcO2detcxtaliEspqWyH4QoPaDUdVeSA7Z/B9di8Fn5qkYj+Fjn1NRlJt88/RaPeI0KJxjW5UmFTY2vCu2r+9CWiadxH0HU2a2sYS4V/eE6zADSuDaf+GA1XrI4/OX1P9D4C1eTDDxbW7Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776920420; c=relaxed/simple;
	bh=03uoT+HhykHcab4fAWv1EW17LE9he8albSxo02UtLqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+eqNGeqILPx83KMhOMgBW64BxzHirykS9qQM4P4ofrl6GFFrUPgspcyrIH+Bw+w1WFXj9UP84DfKitnhhr6ezy2XNuZBdyQSr1bAJJwvJmQoRBZjiGlTjN1o9c31/8E7pCAyIURtKvpfsO2VTPKGeUn5MSy9ogSMOqcycbjkkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VvGZFZrY; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VvGZFZrY"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so80338305e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776920417; x=1777525217; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MF/feU1Am5CY+hy8phkU2ZTpJ0KgOgyuKnd+pHr28m0=;
        b=VvGZFZrYiFDIEBVmCv8SZCsZbYIqtz5WI1CRIZhgOr4qvRqiI+eGPSsXX+gF346ZXU
         WvTJEk79SV2XLAWfjq2CVO8SgabFUXblX8VwsZfVjeRU2YZgXzFYVBfjbGOav1Ufs+bD
         wp/v9QlPbUDPjy0xHPEXb9R5I7lMqUVh6JkEs0xrPYnFFiCetgCCFJDs56HoVUFVH49v
         ZpZ7wnTMKGDdKLogNn9OD/Eb8BvDBezudjjeM9nodYez2u6Z+b4Nm42F96IqB1UN4Ie0
         jO8rMMcAOkhGvE7/1xdqsWifHRCEzQuLe/6y8R1kqfZ7oOQ0C1fmMv3V/DcixVOYRfrh
         86Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776920417; x=1777525217;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MF/feU1Am5CY+hy8phkU2ZTpJ0KgOgyuKnd+pHr28m0=;
        b=FlANfiLOqFjTMhdKD5wAYUZTnwx6qtOrf7f/xmON946jZan9LjA7/QMr/1DJuZ6U4F
         M/pFUETursywgQOk2dk8pXyo0RHKsntTeauy9RVWuuMfyR+af4GITWQRz1lXqftVXo2m
         1IOL83kDbhO9Iwj5CFuhGM3y6ZZ+G7RhVmSpTr2aoT9tXPf64WBt4RkDk7RdA16PYwjA
         iJfdP3kOLjxradP05E1Jx0c4xr1OeEo7JvpWFBuWxtExQp8AIuIAPj5HoulLzEf0tRlk
         AbSVQc21r0FoNLDQJ4iL4T2ZOXuHLvr0+2mbNY3u68W4VfZl6lJSeJds+1MTg72hYodw
         nqYg==
X-Forwarded-Encrypted: i=1; AFNElJ/cPAZjQLQzxZxJbJRpIf7qhCgjESarG1v/vXGVVaxliLFjfr0YyGloTzeQ1hpk8rS7tIE1eIiGLF4J8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyziPgQv85ggd3IpVtBuXPWy4rP173FKsDbpz1uKbgt03XI/0Yp
	ikAHkzgSPstPaZNykjQqueEN/M7Rd1QoXbpYI8XZ9FdsyXqPmCpuDdpNA/rwM9BZJ5k=
X-Gm-Gg: AeBDievhn7+59OM2IjBYanuyQqug+AW6lby/NcNagXL+Xl1lYEAGjysjr1kTj5Z66JU
	7C4kiIFn3VXTiYdX7l3xYwRMLkfdKYjDa6jt1vcqAu0JP0agHBQiU+6xosUv6Ia+CaU//ZPftMU
	T2HOOx3Lu1uLJlLnFJcoOSbwUe2zcqbXcz6OdG2jTZ1MrkhcRdcHpkx9aVgCT5yN/74+rtZgyon
	S+PXMxndR3svn4nUemevrH2X3EE6SdZmZ3Df4lN5eXXHYOzORWriQkkt4S1w7vNwNFkNW4ba7Lv
	J4XGDqc8AtBtEUJI3ouoiRbn1BJHDrDKsV5cIbaRoHj7spNGjOPc5dFQr+oSgqBH0Pat0goE8ej
	6uQMwdS641FvkbJrmyc/V2qZWQCW62W2CcdilFVHieYhjjHgtQCbaFxbm8kV1pKh9Ig9MJ018j4
	aXS6BqHo30N2ZxWloSvOESSfWQwGc4VqwzxXqo+0FnI9k/98AcP8C+sochQW7Yfw==
X-Received: by 2002:a05:600c:4ec6:b0:489:1f98:71e3 with SMTP id 5b1f17b1804b1-4891f987487mr207750575e9.28.1776920417059;
        Wed, 22 Apr 2026 22:00:17 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa2df0asm182394675ad.26.2026.04.22.22.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 22:00:15 -0700 (PDT)
Message-ID: <f06b2ba0-1c1a-4f81-9966-dd1ceb9903a3@suse.com>
Date: Thu, 23 Apr 2026 14:30:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: preallocate extent changeset before acquiring
 extent_io_tree lock
To: tchou <tchou@synology.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, quwenruo.btrfs@gmx.com
References: <20260417064011.1316310-1-tchou@synology.com>
 <20260417073836.1320467-1-tchou@synology.com>
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
In-Reply-To: <20260417073836.1320467-1-tchou@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/17 17:08, tchou 写道:
> In btrfs_clear_extent_bit_changeset(), the extent changeset ulist may need
> to allocate new nodes. Currently, this can happen while holding the
> extent_io_tree->lock spinlock. Although ulist_prealloc() uses GFP_NOFS to
> avoid deadlock with filesystem reclaim, it's better to preallocate before
> acquiring the spinlock to:
> 
> 1. Avoid potential allocation failures while holding the lock
> 2. Be consistent with set_extent_bit() which already preallocates both
>     extent state and changeset before the spinlock
> 3. Reduce lock contention by not doing allocations under the lock
> 
> Preallocate the changeset ulist node before acquiring the spinlock,
> mirroring the pattern used for extent state preallocation.
> 
> Signed-off-by: Ting-Chang Hou <tchou@synology.com>
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---

This patch cause reliable ASSERT() triggering in btrfs/022, with the 
following call trace:

[   65.405567] BTRFS info (device dm-3): qgroup scan completed 
(inconsistency flag cleared)
[   65.644601] assertion failed: 
extent_changeset_tracks_ranges(changeset), in extent_io.h:234
[   65.646833] ------------[ cut here ]------------
[   65.648119] kernel BUG at extent_io.h:234!
[   65.649323] Oops: invalid opcode: 0000 [#1] SMP
[   65.651134] CPU: 9 UID: 0 PID: 76 Comm: kworker/u50:0 Tainted: G 
      OE       7.0.0-rc7-custom+ #366 PREEMPT(full) 
e43575492b73961c1dd795487d0d2ceacbfdec38
[   65.654784] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[   65.656170] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
unknown 02/02/2022
[   65.658210] Workqueue: btrfs-flush_delalloc btrfs_work_helper [btrfs]
[   65.659988] RIP: 0010:extent_changeset_prealloc.part.0+0x1f/0x21 [btrfs]
[   65.661798] Code: 0f 0b 66 0f 1f 84 00 00 00 00 00 b9 ea 00 00 00 48 
c7 c2 b2 2a 8f c0 48 c7 c6 88 92 90 c0 48 c7 c7 b8 92 90 c0 e8 a1 67 2e 
d1 <0f> 0b 48 c7 c6 c0 b0 82 c0 48 89 0c 24 e8 cf 92 30 d1 48 8b 0c 24
[   65.666489] RSP: 0018:ffffccbbc0aeb680 EFLAGS: 00010246
[   65.667835] RAX: 000000000000004f RBX: 00000000004bffff RCX: 
0000000000000000
[   65.669660] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff8aea77c9d3c0
[   65.671483] RBP: 0000000000001000 R08: 0000000000000000 R09: 
00000000ffffefff
[   65.673317] R10: ffffffff93a59b00 R11: ffffccbbc0aeb520 R12: 
ffff8ae9151f6c30
[   65.675209] R13: 0000000000000000 R14: 00000000004c0000 R15: 
00000000004bffff
[   65.677076] FS:  0000000000000000(0000) GS:ffff8aeae385b000(0000) 
knlGS:0000000000000000
[   65.679132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   65.680624] CR2: 00007f1afd800000 CR3: 0000000151124000 CR4: 
0000000000750ef0
[   65.682507] PKRU: 55555554
[   65.683259] Call Trace:
[   65.683939]  <TASK>
[   65.684525]  btrfs_clear_extent_bit_changeset.cold+0x109/0x14c [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.687187]  __btrfs_qgroup_release_data+0xa2/0x1f0 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.689565]  alloc_ordered_extent+0x266/0x330 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.691840]  btrfs_alloc_ordered_extent+0x290/0x350 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.694245]  cow_file_range+0x226/0x8a0 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.696388]  writepage_delalloc+0x35b/0x6e0 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.698636]  extent_write_cache_pages+0x25f/0x820 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.701004]  ? __ext4_journal_get_write_access+0x53/0x160 [ext4 
69c3e1469031ed506d5e673d78e2ebe810d3edeb]
[   65.703527]  btrfs_writepages+0x74/0x130 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.705705]  do_writepages+0xd0/0x160
[   65.706729]  ? _raw_spin_unlock+0xe/0x20
[   65.707785]  ? wbc_attach_and_unlock_inode+0xd1/0x130
[   65.709133]  filemap_writeback+0xb5/0xe0
[   65.710192]  btrfs_run_delalloc_work+0x1b/0x50 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.712508]  btrfs_work_helper+0xd7/0x3b0 [btrfs 
344d2e6beaedee2ce747d6035131ee8e936844c5]
[   65.714708]  process_one_work+0x198/0x3b0
[   65.715771]  worker_thread+0x1c8/0x330
[   65.716929]  ? rescuer_thread+0x5d0/0x5d0
[   65.718038]  kthread+0xee/0x120
[   65.718877]  ? kthreads_online_cpu+0x10/0x10
[   65.719998]  ret_from_fork+0x2a6/0x330
[   65.720987]  ? kthreads_online_cpu+0x10/0x10
[   65.722143]  ret_from_fork_asm+0x11/0x20
[   65.723180]  </TASK>

Next time please run a full fstests run, with CONFIG_BTRFS_ASSERT, 
CONFIG_BTRFS_DEBUG and CONFIG_BTRFS_EXPERIMENTAL enabled.

Now removed from for-next branch.

Thanks,
Qu

>   fs/btrfs/extent-io-tree.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
> index 626702244809..b5ba650cdb55 100644
> --- a/fs/btrfs/extent-io-tree.c
> +++ b/fs/btrfs/extent-io-tree.c
> @@ -663,6 +663,9 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
>   		 */
>   		prealloc = alloc_extent_state(mask);
>   	}
> +	/* Preallocate the extent changeset ulist node before acquiring spinlock. */
> +	if (changeset)
> +		extent_changeset_prealloc(changeset, mask);
>   
>   	spin_lock(&tree->lock);
>   	if (cached_state) {

