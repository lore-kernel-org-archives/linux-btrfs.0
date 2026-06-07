Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5D21A453
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 22:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780872347; cv=none; b=f/Uw+9CuP3X770PKRW1OCOMci2H0SrqQtq2NQBZHTvnnxRn7CPc+3EoLNcHOPmger0iZzkEWyJToVmqzViDhZeEI5bHcvojxxRg9/r1KtZinVcclVeEBx5SOV+LzRrQqh8OaoPfJJmGdpZDCnX6M5hNc3EmYmeIWEgul+bIGFfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780872347; c=relaxed/simple;
	bh=oJn8jrHfNVXualUgH4fLU394stPRTM3KuTO2sHvjCT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TD9OJ31EaRBZpWL+OM6BK4KB0RvvS17aWR5IWzxzSLzPAt5r/APz7hYNxTgvISla99j4eocUMCHvC/5qoZnCXixMWFdYOyMNiiI52Sa34jX80k+G50cW4qxvmEtpqKQIZpcHVVfQCJ/boa7KEtqu71uPq48Lm8AHOd60WKbJXoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PFehmeH/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PFehmeH/"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bdb3fd39045so465356266b.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2026 15:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780872343; x=1781477143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wUfGIOIwqDO8JlPrnj0VIgpQhntFrH37Hgne3Y4mty8=;
        b=PFehmeH/4blLekGMHl1FVzXdQSnm0XljbcunXgCAD3HFmnFVysfDrUhFCWQ/N51gxF
         ldbbas0rglIaHCt0ynR5ZM3X134No5XnBTYZpx0yaHSApttAx+kMTraiixoYXeBWpeGx
         lamOQqMu8lWo5r6T7Pkl/6pEpFWC/0eUdJYi1JzEFhK1aY7ckjoTJPBdpvvP6+l+O+oz
         tis79iCAdiatElEK2qbCQcMcvjWHv8Nl/0jK0ce5wh24frRiQygXgV7RYUpWIe5WMu0+
         n1G5rxPmJfm2tKxjAiVF5rFDvN+pcuQOzI6VnLpLHEQLhykKSRswP1LBXlqLNVQJwQB7
         aYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780872343; x=1781477143;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUfGIOIwqDO8JlPrnj0VIgpQhntFrH37Hgne3Y4mty8=;
        b=VBRL8Q8kRTeyjFn/8jqTOp+Gwka0wEpiXE7+NvOyNQ29r/NIetMC/Sx7VumJgO9xjs
         e//U6BrUmtGmjIUzrmw3VGqZUkWelNs/jvpG0BlnmAVwtbOEHUEpXCsN5FhizZ897BFu
         zuZqmWKLueJegY7UbIuvkRh9OqmlUDiaIzWAWxWRK1rJW4ytMZ17A+0C944NAOqvKAaJ
         LympqrY1jol/F/Veh/wpDg4RKThrGJH2/C2Kfcmt9VuEj/WwL41tHiZobiUQqQwgp5vf
         kl6QROKjfG+ujqXYo3hcyjldRmPYyFKKhTjyMfUZIwH/NuhjT2Pxr8ETcz5k/p6ZK1bf
         a/vQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yhwwME8n+tVgl1kRDNojGfiVgyHss5qvjLp+SnVPS2Jh8P+e9Tgegmp70ysAvjAL/mXbuSGOTgldD5g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh81F0aKdosGHdkj1gaQHgsD1m6grsBh+p2f6/MJoi5IfeUe9Z
	JeG/IVDeJLQwckppGZ9MYZcJ62hABdl8zS8iSO1AKMG0Y35Y7fAHfeEm4m2z/p3sF7wEJhN3oyI
	s1coW
X-Gm-Gg: Acq92OHwHEOl5GKuHPaQoiK9wPZeaorKG4ScMxaguVIRoXNgclx8C8baHKblonK+BQU
	g3BB2Iks+xdT7LfUNwp3gAQ++opQpJNW0PBwkaTRu8epCt9AHFe+QfqL2Wdo2ielv9WriFVLdm6
	nI1pEccZ9BuAI+qdHjr/XX4Gr8bToCcsMFQVoeMP3vJtThuKZWN4XC+pZB8vEZ9ZHUKVT2SsFcw
	WWd0hzbWKmg0Eq8wVzUCHtlpCVkbWcvBhyHZBb8ONjZr/ISpILjCvUJiO1l4lJ0D7Xk8TAZjNEQ
	1HYdnLpmLQqsEK3PunHCx1o354nwPOi/ZAZ0G5fUthst+F2e2ijf9eWgiAcuTDLZn5XXP47CbqO
	04N66vkFchH82/u+x/xaEpvUqPA8Ug76D3nIFG+H8j0SDxmmQe9lOPUgyUZwwpysHmh7NFbZ69N
	avNYqWYARYMyDMC5lNjHkmgCiz1hQSaNjS3kRnwvF6cqsuHx5xQfVzuKKgi5egPUn6g0TkfIMFk
	Pk2PWvM3gC8YmgD0OfzCYNZXt5zrgzK5cOfgqoDG7hysc/JkNFyT8lKTBdXG7VFnxI=
X-Received: by 2002:a17:907:2d92:b0:bf0:59a2:4ccc with SMTP id a640c23a62f3a-bf36fd9bc68mr684216066b.3.1780872343117;
        Sun, 07 Jun 2026 15:45:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428237430esm14689797b3a.21.2026.06.07.15.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 15:45:42 -0700 (PDT)
Message-ID: <0cf28d94-f907-4ffc-9a91-5c51e487fc04@suse.com>
Date: Mon, 8 Jun 2026 08:15:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: fix use-after-free after relocation failure
 with concurrent COW
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3d57517e6e8ace7f1294277b0f03baa1150be55c.1780677297.git.fdmanana@suse.com>
 <2e4c256c45877d79c97c2a9cceeafeb12ed4e97f.1780822300.git.fdmanana@suse.com>
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
In-Reply-To: <2e4c256c45877d79c97c2a9cceeafeb12ed4e97f.1780822300.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/7 18:23, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we get a failure during relocation, before we update all the extent
> buffers that have file extent items pointing to extents from the block
> group being relocated, we can trigger a user-after-free on the reloc
> control structure (fs_info->reloc_control) if we have a concurrent task
> that is COWing a subvolume leaf.
> 
> This happens like this:
> 
> 1) Relocation of data block group X starts;
> 
> 2) Relocation changes its state to UPDATE_DATA_PTRS;
> 
> 3) A task doing a rename for example, COWs leaf A from a subvolume tree
>     and ends up at btrfs_reloc_cow_block() and extracts fs_info->reloc_ctl
>     into a local variable, which then passes to replace_file_extents();
> 
> 4) The relocation task gets an error and under the label 'out_put_bg' in
>     btrfs_relocate_block_group() calls free_reloc_control(), which frees
>     the reloc control structure that the rename task is using;
> 
> 5) The rename task triggers a use-after-free on the reloc control
>     structure that was just freed.
> 
> Syzbot reported this recently, with the following stack trace:
> 
>     [   88.389822][ T5325] BTRFS error (device loop0 state A): Transaction aborted (error -5)
>     [   88.389842][ T5325] BTRFS: error (device loop0 state A) in cleanup_transaction:2067: errno=-5 IO failure
>     [   88.389864][ T5325] BTRFS info (device loop0 state EA): forced readonly
>     [   88.392277][ T5324] BTRFS: error (device loop0 state EA) in btrfs_sync_log:3572: errno=-5 IO failure
>     [   88.396630][ T5325] BTRFS info (device loop0 state EA): balance: ended with status: -5
>     [   88.400135][ T5346] ==================================================================
>     [   88.400148][ T5346] BUG: KASAN: slab-use-after-free in replace_file_extents+0x85f/0x1590
>     [   88.400288][ T5346] Read of size 8 at addr ffff888012312010 by task syz.0.0/5346
>     [   88.400299][ T5346]
>     [   88.400306][ T5346] CPU: 0 UID: 0 PID: 5346 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
>     [   88.400319][ T5346] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     [   88.400325][ T5346] Call Trace:
>     [   88.400331][ T5346]  <TASK>
>     [   88.400336][ T5346]  dump_stack_lvl+0xe8/0x150
>     [   88.400351][ T5346]  print_address_description+0x55/0x1e0
>     [   88.400364][ T5346]  ? replace_file_extents+0x85f/0x1590
>     [   88.400378][ T5346]  print_report+0x58/0x70
>     [   88.400389][ T5346]  kasan_report+0x117/0x150
>     [   88.400405][ T5346]  ? replace_file_extents+0x85f/0x1590
>     [   88.400420][ T5346]  replace_file_extents+0x85f/0x1590
>     [   88.400440][ T5346]  ? __pfx_replace_file_extents+0x10/0x10
>     [   88.400452][ T5346]  ? update_ref_for_cow+0xa71/0x1270
>     [   88.400473][ T5346]  btrfs_force_cow_block+0xa4d/0x2450
>     [   88.400492][ T5346]  ? __pfx_btrfs_force_cow_block+0x10/0x10
>     [   88.400508][ T5346]  ? __pfx_btrfs_get_32+0x10/0x10
>     [   88.400523][ T5346]  btrfs_cow_block+0x3c4/0xa90
>     [   88.400542][ T5346]  push_leaf_left+0x2ac/0x4a0
>     [   88.400561][ T5346]  split_leaf+0xd16/0x12e0
>     [   88.400574][ T5346]  ? btrfs_bin_search+0x924/0xc70
>     [   88.400592][ T5346]  ? __pfx_split_leaf+0x10/0x10
>     [   88.400602][ T5346]  ? leaf_space_used+0x177/0x1e0
>     [   88.400618][ T5346]  ? btrfs_leaf_free_space+0x14a/0x2f0
>     [   88.400634][ T5346]  btrfs_search_slot+0x2641/0x2d20
>     [   88.400654][ T5346]  ? __pfx_btrfs_search_slot+0x10/0x10
>     [   88.400669][ T5346]  ? rcu_is_watching+0x15/0xb0
>     [   88.400681][ T5346]  ? trace_kmem_cache_alloc+0x29/0xe0
>     [   88.400694][ T5346]  btrfs_insert_empty_items+0x9c/0x190
>     [   88.400711][ T5346]  btrfs_insert_inode_ref+0x229/0xcb0
>     [   88.400724][ T5346]  ? __pfx_btrfs_insert_inode_ref+0x10/0x10
>     [   88.400736][ T5346]  ? __pfx_btrfs_qgroup_convert_reserved_meta+0x10/0x10
>     [   88.400751][ T5346]  ? btrfs_record_root_in_trans+0x124/0x180
>     [   88.400767][ T5346]  ? start_transaction+0x8a0/0x1820
>     [   88.400778][ T5346]  ? btrfs_set_inode_index+0x5e/0x100
>     [   88.400787][ T5346]  btrfs_rename2+0x17bb/0x40d0
>     [   88.400800][ T5346]  ? check_noncircular+0xda/0x150
>     [   88.400814][ T5346]  ? add_lock_to_list+0xc7/0x100
>     [   88.400828][ T5346]  ? __pfx_btrfs_rename2+0x10/0x10
>     [   88.400842][ T5346]  ? lockdep_hardirqs_on+0x7a/0x110
>     [   88.400901][ T5346]  ? lock_acquire+0x221/0x350
>     [   88.400915][ T5346]  ? down_write_nested+0x174/0x210
>     [   88.400931][ T5346]  ? __pfx_down_write_nested+0x10/0x10
>     [   88.400941][ T5346]  ? do_raw_spin_unlock+0x4d/0x210
>     [   88.400952][ T5346]  ? try_break_deleg+0x5b/0x180
>     [   88.400963][ T5346]  ? __pfx_btrfs_rename2+0x10/0x10
>     [   88.400973][ T5346]  vfs_rename+0xa96/0xeb0
>     [   88.400992][ T5346]  ? __pfx_vfs_rename+0x10/0x10
>     [   88.401010][ T5346]  ovl_fill_super+0x46b7/0x5e20
>     [   88.401030][ T5346]  ? __pfx_ovl_fill_super+0x10/0x10
>     [   88.401042][ T5346]  ? xas_create+0x1902/0x1b90
>     [   88.401060][ T5346]  ? __pfx___mutex_trylock_common+0x10/0x10
>     [   88.401076][ T5346]  ? trace_contention_end+0x3d/0x140
>     [   88.401094][ T5346]  ? shrinker_register+0x124/0x230
>     [   88.401111][ T5346]  ? __mutex_unlock_slowpath+0x1be/0x6f0
>     [   88.401127][ T5346]  ? shrinker_register+0x61/0x230
>     [   88.401143][ T5346]  ? __pfx___mutex_lock+0x10/0x10
>     [   88.401158][ T5346]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
>     [   88.401177][ T5346]  ? __raw_spin_lock_init+0x45/0x100
>     [   88.401196][ T5346]  ? sget_fc+0x962/0xa40
>     [   88.401208][ T5346]  ? __pfx_set_anon_super_fc+0x10/0x10
>     [   88.401222][ T5346]  ? __pfx_ovl_fill_super+0x10/0x10
>     [   88.401241][ T5346]  get_tree_nodev+0xbb/0x150
>     [   88.401257][ T5346]  vfs_get_tree+0x92/0x2a0
>     [   88.401272][ T5346]  do_new_mount+0x341/0xd30
>     [   88.401283][ T5346]  ? apparmor_capable+0x126/0x170
>     [   88.401301][ T5346]  ? __pfx_do_new_mount+0x10/0x10
>     [   88.401311][ T5346]  ? ns_capable+0x89/0xe0
>     [   88.401322][ T5346]  ? path_mount+0x690/0x10e0
>     [   88.401333][ T5346]  ? user_path_at+0xd4/0x160
>     [   88.401346][ T5346]  __se_sys_mount+0x31d/0x420
>     [   88.401358][ T5346]  ? __pfx___se_sys_mount+0x10/0x10
>     [   88.401370][ T5346]  ? __x64_sys_mount+0x20/0xc0
>     [   88.401381][ T5346]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401391][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401403][ T5346]  ? trace_irq_disable+0x3b/0x140
>     [   88.401413][ T5346]  ? clear_bhb_loop+0x40/0x90
>     [   88.401421][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401429][ T5346] RIP: 0033:0x7fa1ff79ce59
>     [   88.401436][ T5346] Code: ff c3 66 (...)
>     [   88.401443][ T5346] RSP: 002b:00007fa2005affe8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
>     [   88.401456][ T5346] RAX: ffffffffffffffda RBX: 00007fa1ffa16180 RCX: 00007fa1ff79ce59
>     [   88.401464][ T5346] RDX: 0000200000000100 RSI: 0000200000002240 RDI: 0000000000000000
>     [   88.401474][ T5346] RBP: 00007fa1ff832d6f R08: 0000200000000440 R09: 0000000000000000
>     [   88.401481][ T5346] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>     [   88.401488][ T5346] R13: 00007fa1ffa16218 R14: 00007fa1ffa16180 R15: 00007ffc734fba78
>     [   88.401500][ T5346]  </TASK>
>     [   88.401506][ T5346]
>     [   88.401510][ T5346] Allocated by task 5325:
>     [   88.401516][ T5346]  kasan_save_track+0x3e/0x80
>     [   88.401529][ T5346]  __kasan_kmalloc+0x93/0xb0
>     [   88.401542][ T5346]  __kmalloc_cache_noprof+0x31c/0x660
>     [   88.401554][ T5346]  btrfs_relocate_block_group+0x217/0xc40
>     [   88.401568][ T5346]  btrfs_relocate_chunk+0x115/0x820
>     [   88.401577][ T5346]  __btrfs_balance+0x1db0/0x2ae0
>     [   88.401587][ T5346]  btrfs_balance+0xaf3/0x11b0
>     [   88.401596][ T5346]  btrfs_ioctl_balance+0x3d3/0x610
>     [   88.401612][ T5346]  __se_sys_ioctl+0xfc/0x170
>     [   88.401626][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401640][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401650][ T5346]
>     [   88.401653][ T5346] Freed by task 5325:
>     [   88.401659][ T5346]  kasan_save_track+0x3e/0x80
>     [   88.401671][ T5346]  kasan_save_free_info+0x46/0x50
>     [   88.401680][ T5346]  __kasan_slab_free+0x5c/0x80
>     [   88.401692][ T5346]  kfree+0x1c5/0x640
>     [   88.401703][ T5346]  btrfs_relocate_block_group+0x95d/0xc40
>     [   88.401715][ T5346]  btrfs_relocate_chunk+0x115/0x820
>     [   88.401724][ T5346]  __btrfs_balance+0x1db0/0x2ae0
>     [   88.401733][ T5346]  btrfs_balance+0xaf3/0x11b0
>     [   88.401742][ T5346]  btrfs_ioctl_balance+0x3d3/0x610
>     [   88.401757][ T5346]  __se_sys_ioctl+0xfc/0x170
>     [   88.401770][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.401785][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.401795][ T5346]
>     [   88.401798][ T5346] The buggy address belongs to the object at ffff888012312000
>     [   88.401798][ T5346]  which belongs to the cache kmalloc-2k of size 2048
>     [   88.401807][ T5346] The buggy address is located 16 bytes inside of
>     [   88.401807][ T5346]  freed 2048-byte region [ffff888012312000, ffff888012312800)
>     [   88.401819][ T5346]
>     [   88.401822][ T5346] The buggy address belongs to the physical page:
>     [   88.401829][ T5346] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12310
>     [   88.401840][ T5346] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>     [   88.401849][ T5346] flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
>     [   88.401860][ T5346] page_type: f5(slab)
>     [   88.401871][ T5346] raw: 00fff00000000040 ffff88801ac42000 dead000000000100 dead000000000122
>     [   88.401881][ T5346] raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
>     [   88.401892][ T5346] head: 00fff00000000040 ffff88801ac42000 dead000000000100 dead000000000122
>     [   88.401902][ T5346] head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
>     [   88.401913][ T5346] head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
>     [   88.401923][ T5346] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
>     [   88.401929][ T5346] page dumped because: kasan: bad access detected
>     [   88.401935][ T5346] page_owner tracks the page as allocated
>     [   88.401941][ T5346] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9, tgid 9 (kworker/0:0), ts 83905464494, free_ts 83674944822
>     [   88.401961][ T5346]  post_alloc_hook+0x231/0x280
>     [   88.401975][ T5346]  get_page_from_freelist+0x24ba/0x2540
>     [   88.401990][ T5346]  __alloc_frozen_pages_noprof+0x18d/0x380
>     [   88.402004][ T5346]  allocate_slab+0x77/0x660
>     [   88.402019][ T5346]  refill_objects+0x339/0x3d0
>     [   88.402033][ T5346]  __pcs_replace_empty_main+0x321/0x720
>     [   88.402043][ T5346]  __kmalloc_node_track_caller_noprof+0x572/0x7b0
>     [   88.402055][ T5346]  __alloc_skb+0x2c1/0x7d0
>     [   88.402067][ T5346]  mld_newpack+0x14c/0xc90
>     [   88.402080][ T5346]  add_grhead+0x5a/0x2a0
>     [   88.402093][ T5346]  add_grec+0x1452/0x1740
>     [   88.402105][ T5346]  mld_ifc_work+0x6e6/0xe70
>     [   88.402116][ T5346]  process_scheduled_works+0xb5d/0x1860
>     [   88.402127][ T5346]  worker_thread+0xa53/0xfc0
>     [   88.402138][ T5346]  kthread+0x389/0x470
>     [   88.402150][ T5346]  ret_from_fork+0x514/0xb70
>     [   88.402161][ T5346] page last free pid 5282 tgid 5282 stack trace:
>     [   88.402168][ T5346]  __free_frozen_pages+0xbc7/0xd30
>     [   88.402180][ T5346]  __slab_free+0x274/0x2c0
>     [   88.402191][ T5346]  qlist_free_all+0x99/0x100
>     [   88.402201][ T5346]  kasan_quarantine_reduce+0x148/0x160
>     [   88.402211][ T5346]  __kasan_slab_alloc+0x22/0x80
>     [   88.402221][ T5346]  __kmalloc_cache_noprof+0x2ba/0x660
>     [   88.402231][ T5346]  kernfs_fop_open+0x3f0/0xda0
>     [   88.402253][ T5346]  do_dentry_open+0x785/0x14e0
>     [   88.402262][ T5346]  vfs_open+0x3b/0x340
>     [   88.402270][ T5346]  path_openat+0x2e08/0x3860
>     [   88.402281][ T5346]  do_file_open+0x23e/0x4a0
>     [   88.402292][ T5346]  do_sys_openat2+0x113/0x200
>     [   88.402300][ T5346]  __x64_sys_openat+0x138/0x170
>     [   88.402309][ T5346]  do_syscall_64+0x15f/0xf80
>     [   88.402326][ T5346]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>     [   88.402336][ T5346]
>     [   88.402339][ T5346] Memory state around the buggy address:
>     [   88.402345][ T5346]  ffff888012311f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>     [   88.402352][ T5346]  ffff888012311f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>     [   88.402359][ T5346] >ffff888012312000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     [   88.402365][ T5346]                          ^
>     [   88.402370][ T5346]  ffff888012312080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     [   88.402380][ T5346]  ffff888012312100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     [   88.402385][ T5346] ==================================================================
> 
> Fix this by:
> 
> 1) Making the reloc control structure ref counted;
> 
> 2) Make revery place that access fs_info->reloc_ctl outside the relocation
>     code, which at the moment it's only replace_file_extents() and
>     btrfs_init_reloc_root(), get a reference count on the structure.
>     There's also btrfs_update_reloc_root() that is called outside the
>     relocation code, but this case is safe because it's only called in
>     the transaction commit path while under the fs_info->reloc_mutex
>     protection, but nevertheless grab a reference to make the code more
>     consistent and avoid false alerts from AI reviews;
> 
> 3) Add a spinlock to protect fs_info->reloc_ctl, since we can not take the
>     fs_info->reloc_mutex as that would cause a deadlock since that lock is
>     taken in the transaction commit path. That spinlock is taken before
>     setting fs_info->reloc_ctl to an allocated structure, setting it to
>     NULL and reading fs_info->reloc_ctl;
> 
> 4) Make sure the structure is freed only when its reference count drops to
>     zero.
> 
> Reported-by: syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a1df323.bb0696ed.125a22.000a.GAE@google.com/
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V3: Avoid a null pointer deref in __del_reloc_root() when calling
>      put_reloc_control() if rc is NULL.
> 
> V2: Address sashiko reviews.
> 
>   fs/btrfs/disk-io.c    |   1 +
>   fs/btrfs/fs.h         |   2 +
>   fs/btrfs/relocation.c | 259 +++++++++++++++++++++++++-----------------
>   3 files changed, 160 insertions(+), 102 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 97f99f830795..0a7d80da9c94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2796,6 +2796,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
>   	mutex_init(&fs_info->unused_bg_unpin_mutex);
>   	mutex_init(&fs_info->reclaim_bgs_lock);
>   	mutex_init(&fs_info->reloc_mutex);
> +	spin_lock_init(&fs_info->reloc_ctl_lock);
>   	mutex_init(&fs_info->delalloc_root_mutex);
>   	mutex_init(&fs_info->zoned_meta_io_lock);
>   	mutex_init(&fs_info->zoned_data_reloc_io_lock);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index da87292420fa..5f0cfb0b5466 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -657,6 +657,8 @@ struct btrfs_fs_info {
>   	 * to protect us from the relocation code.
>   	 */
>   	struct mutex reloc_mutex;
> +	/* Protects setting, clearing and getting fs_info->reloc_ctl. */
> +	spinlock_t reloc_ctl_lock;
>   
>   	struct list_head trans_list;
>   	struct list_head dead_roots;
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 80aac9fcd627..d70596528bcb 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -178,8 +178,101 @@ struct reloc_control {
>   	bool create_reloc_tree;
>   	bool merge_reloc_tree;
>   	bool found_file_extent;
> +
> +	refcount_t refs;
>   };
>   
> +static struct reloc_control *get_reloc_control(struct btrfs_fs_info *fs_info)
> +{
> +	struct reloc_control *rc;
> +
> +	/* Quick path, avoid lock contention on fs_info->reloc_ctl_lock. */
> +	if (!data_race(fs_info->reloc_ctl))
> +		return NULL;
> +
> +	spin_lock(&fs_info->reloc_ctl_lock);
> +	rc = fs_info->reloc_ctl;
> +	if (rc)
> +		refcount_inc(&rc->refs);
> +	spin_unlock(&fs_info->reloc_ctl_lock);
> +
> +	return rc;
> +}
> +
> +static void __del_reloc_root(struct btrfs_root *root);
> +
> +static noinline_for_stack void free_reloc_roots(struct list_head *list)
> +{
> +	struct btrfs_root *reloc_root, *tmp;
> +
> +	list_for_each_entry_safe(reloc_root, tmp, list, root_list)
> +		__del_reloc_root(reloc_root);
> +}
> +
> +static void put_reloc_control(struct reloc_control *rc)
> +{
> +	if (refcount_dec_and_test(&rc->refs)) {
> +		struct mapping_node *node, *tmp;
> +
> +		if (rc->extent_root)
> +			ASSERT(rc->extent_root->fs_info->reloc_ctl != rc);
> +
> +		free_reloc_roots(&rc->reloc_roots);
> +		rbtree_postorder_for_each_entry_safe(node, tmp,
> +						     &rc->reloc_root_tree.rb_root,
> +						     rb_node)
> +			kfree(node);
> +
> +		if (rc->block_group)
> +			btrfs_put_block_group(rc->block_group);
> +
> +		kfree(rc);
> +	}
> +}
> +
> +/* Helper to delete the 'address of tree root -> reloc tree' mapping. */
> +static void __del_reloc_root(struct btrfs_root *root)
> +{
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct rb_node *rb_node;
> +	struct mapping_node AUTO_KFREE(node);
> +	struct reloc_control *rc;
> +	bool put_ref = false;
> +
> +	rc = get_reloc_control(fs_info);
> +	if (rc && root->node) {
> +		spin_lock(&rc->reloc_root_tree.lock);
> +		rb_node = rb_simple_search(&rc->reloc_root_tree.rb_root,
> +					   root->commit_root->start);
> +		if (rb_node) {
> +			node = rb_entry(rb_node, struct mapping_node, rb_node);
> +			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
> +			RB_CLEAR_NODE(&node->rb_node);
> +		}
> +		spin_unlock(&rc->reloc_root_tree.lock);
> +		ASSERT(!node || (struct btrfs_root *)node->data == root);
> +	}
> +
> +	/*
> +	 * We only put the reloc root here if it's on the list.  There's a lot
> +	 * of places where the pattern is to splice the rc->reloc_roots, process
> +	 * the reloc roots, and then add the reloc root back onto
> +	 * rc->reloc_roots.  If we call __del_reloc_root while it's off of the
> +	 * list we don't want the reference being dropped, because the guy
> +	 * messing with the list is in charge of the reference.
> +	 */
> +	spin_lock(&fs_info->trans_lock);
> +	if (!list_empty(&root->root_list)) {
> +		put_ref = true;
> +		list_del_init(&root->root_list);
> +	}
> +	spin_unlock(&fs_info->trans_lock);
> +	if (put_ref)
> +		btrfs_put_root(root);
> +	if (rc)
> +		put_reloc_control(rc);
> +}
> +
>   static void mark_block_processed(struct reloc_control *rc,
>   				 struct btrfs_backref_node *node)
>   {
> @@ -475,12 +568,11 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
>   /*
>    * helper to add 'address of tree root -> reloc tree' mapping
>    */
> -static int __add_reloc_root(struct btrfs_root *root)
> +static int __add_reloc_root(struct btrfs_root *root, struct reloc_control *rc)
>   {
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	struct rb_node *rb_node;
>   	struct mapping_node *node;
> -	struct reloc_control *rc = fs_info->reloc_ctl;
>   
>   	node = kmalloc_obj(*node, GFP_NOFS);
>   	if (!node)
> @@ -503,49 +595,6 @@ static int __add_reloc_root(struct btrfs_root *root)
>   	return 0;
>   }
>   
> -/*
> - * helper to delete the 'address of tree root -> reloc tree'
> - * mapping
> - */
> -static void __del_reloc_root(struct btrfs_root *root)
> -{
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	struct rb_node *rb_node;
> -	struct mapping_node AUTO_KFREE(node);
> -	struct reloc_control *rc = fs_info->reloc_ctl;
> -	bool put_ref = false;
> -
> -	if (rc && root->node) {
> -		spin_lock(&rc->reloc_root_tree.lock);
> -		rb_node = rb_simple_search(&rc->reloc_root_tree.rb_root,
> -					   root->commit_root->start);
> -		if (rb_node) {
> -			node = rb_entry(rb_node, struct mapping_node, rb_node);
> -			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
> -			RB_CLEAR_NODE(&node->rb_node);
> -		}
> -		spin_unlock(&rc->reloc_root_tree.lock);
> -		ASSERT(!node || (struct btrfs_root *)node->data == root);
> -	}
> -
> -	/*
> -	 * We only put the reloc root here if it's on the list.  There's a lot
> -	 * of places where the pattern is to splice the rc->reloc_roots, process
> -	 * the reloc roots, and then add the reloc root back onto
> -	 * rc->reloc_roots.  If we call __del_reloc_root while it's off of the
> -	 * list we don't want the reference being dropped, because the guy
> -	 * messing with the list is in charge of the reference.
> -	 */
> -	spin_lock(&fs_info->trans_lock);
> -	if (!list_empty(&root->root_list)) {
> -		put_ref = true;
> -		list_del_init(&root->root_list);
> -	}
> -	spin_unlock(&fs_info->trans_lock);
> -	if (put_ref)
> -		btrfs_put_root(root);
> -}
> -
>   /*
>    * helper to update the 'address of tree root -> reloc tree'
>    * mapping
> @@ -699,11 +748,12 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>   {
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	struct btrfs_root *reloc_root;
> -	struct reloc_control *rc = fs_info->reloc_ctl;
> +	struct reloc_control *rc;
>   	struct btrfs_block_rsv *rsv;
>   	bool clear_rsv = false;
> -	int ret;
> +	int ret = 0;
>   
> +	rc = get_reloc_control(fs_info);
>   	if (!rc)
>   		return 0;
>   
> @@ -712,7 +762,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>   	 * create/update the dead reloc tree
>   	 */
>   	if (reloc_root_is_dead(root))
> -		return 0;
> +		goto out;
>   
>   	/*
>   	 * This is subtle but important.  We do not do
> @@ -723,9 +773,8 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>   	 * in.
>   	 */
>   	if (root->reloc_root) {
> -		reloc_root = root->reloc_root;
> -		btrfs_set_root_last_trans(reloc_root, trans->transid);
> -		return 0;
> +		btrfs_set_root_last_trans(root->reloc_root, trans->transid);
> +		goto out;
>   	}
>   
>   	/*
> @@ -733,7 +782,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>   	 * reloc trees never need their own reloc tree.
>   	 */
>   	if (!rc->create_reloc_tree || btrfs_root_id(root) == BTRFS_TREE_RELOC_OBJECTID)
> -		return 0;
> +		goto out;
>   
>   	if (!trans->reloc_reserved) {
>   		rsv = trans->block_rsv;
> @@ -743,18 +792,23 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>   	reloc_root = create_reloc_root(trans, root, btrfs_root_id(root));
>   	if (clear_rsv)
>   		trans->block_rsv = rsv;
> -	if (IS_ERR(reloc_root))
> -		return PTR_ERR(reloc_root);
> +	if (IS_ERR(reloc_root)) {
> +		ret = PTR_ERR(reloc_root);
> +		goto out;
> +	}
>   
> -	ret = __add_reloc_root(reloc_root);
> +	ret = __add_reloc_root(reloc_root, rc);
>   	ASSERT(ret != -EEXIST);
>   	if (ret) {
>   		/* Pairs with create_reloc_root */
>   		btrfs_put_root(reloc_root);
> -		return ret;
> +		goto out;
>   	}
>   	root->reloc_root = btrfs_grab_root(reloc_root);
> -	return 0;
> +out:
> +	put_reloc_control(rc);
> +
> +	return ret;
>   }
>   
>   /*
> @@ -766,6 +820,7 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	struct btrfs_root *reloc_root;
>   	struct btrfs_root_item *root_item;
> +	struct reloc_control *rc;
>   	int ret;
>   
>   	if (!have_reloc_root(root))
> @@ -781,9 +836,9 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
>   	 */
>   	btrfs_grab_root(reloc_root);
>   
> +	rc = get_reloc_control(fs_info);
>   	/* root->reloc_root will stay until current relocation finished */
> -	if (fs_info->reloc_ctl && fs_info->reloc_ctl->merge_reloc_tree &&
> -	    btrfs_root_refs(root_item) == 0) {
> +	if (rc && rc->merge_reloc_tree && btrfs_root_refs(root_item) == 0) {
>   		set_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>   		/*
>   		 * Mark the tree as dead before we change reloc_root so
> @@ -803,6 +858,9 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
>   	ret = btrfs_update_root(trans, fs_info->tree_root,
>   				&reloc_root->root_key, root_item);
>   	btrfs_put_root(reloc_root);
> +	if (rc)
> +		put_reloc_control(rc);
> +
>   	return ret;
>   }
>   
> @@ -1807,15 +1865,6 @@ int prepare_to_merge(struct reloc_control *rc, int err)
>   	return err;
>   }
>   
> -static noinline_for_stack
> -void free_reloc_roots(struct list_head *list)
> -{
> -	struct btrfs_root *reloc_root, *tmp;
> -
> -	list_for_each_entry_safe(reloc_root, tmp, list, root_list)
> -		__del_reloc_root(reloc_root);
> -}
> -
>   static noinline_for_stack
>   void merge_reloc_roots(struct reloc_control *rc)
>   {
> @@ -1920,7 +1969,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>   	 * do the reloc_dirty_list afterwards.  Meanwhile the root->reloc_root
>   	 * will be cleaned up on unmount.
>   	 *
> -	 * The remaining nodes will be cleaned up by free_reloc_control.
> +	 * The remaining nodes will be cleaned up by put_reloc_control().
>   	 */
>   }
>   
> @@ -3434,7 +3483,9 @@ static void set_reloc_control(struct reloc_control *rc)
>   	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
>   
>   	mutex_lock(&fs_info->reloc_mutex);
> +	spin_lock(&fs_info->reloc_ctl_lock);
>   	fs_info->reloc_ctl = rc;
> +	spin_unlock(&fs_info->reloc_ctl_lock);
>   	mutex_unlock(&fs_info->reloc_mutex);
>   }
>   
> @@ -3443,7 +3494,9 @@ static void unset_reloc_control(struct reloc_control *rc)
>   	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
>   
>   	mutex_lock(&fs_info->reloc_mutex);
> +	spin_lock(&fs_info->reloc_ctl_lock);
>   	fs_info->reloc_ctl = NULL;
> +	spin_unlock(&fs_info->reloc_ctl_lock);
>   	mutex_unlock(&fs_info->reloc_mutex);
>   }
>   
> @@ -3828,19 +3881,9 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
>   	rc->reloc_root_tree.rb_root = RB_ROOT;
>   	spin_lock_init(&rc->reloc_root_tree.lock);
>   	btrfs_extent_io_tree_init(fs_info, &rc->processed_blocks, IO_TREE_RELOC_BLOCKS);
> -	return rc;
> -}
> -
> -static void free_reloc_control(struct reloc_control *rc)
> -{
> -	struct mapping_node *node, *tmp;
> +	refcount_set(&rc->refs, 1);
>   
> -	free_reloc_roots(&rc->reloc_roots);
> -	rbtree_postorder_for_each_entry_safe(node, tmp,
> -			&rc->reloc_root_tree.rb_root, rb_node)
> -		kfree(node);
> -
> -	kfree(rc);
> +	return rc;
>   }
>   
>   /*
> @@ -5380,13 +5423,14 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
>   		return -ENOMEM;
>   	}
>   
> -	ret = reloc_chunk_start(fs_info);
> -	if (ret < 0)
> -		goto out_put_bg;
> -
>   	rc->extent_root = extent_root;
> +	/* Block group ref now owned by rc, put_reloc_control() will drop it. */
>   	rc->block_group = bg;
>   
> +	ret = reloc_chunk_start(fs_info);
> +	if (ret < 0)
> +		goto out_put_rc;
> +
>   	ret = btrfs_inc_block_group_ro(rc->block_group, true);
>   	if (ret)
>   		goto out;
> @@ -5454,9 +5498,8 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
>   		iput(rc->data_inode);
>   	btrfs_free_path(path);
>   	reloc_chunk_end(fs_info);
> -out_put_bg:
> -	btrfs_put_block_group(bg);
> -	free_reloc_control(rc);
> +out_put_rc:
> +	put_reloc_control(rc);
>   	return ret;
>   }
>   
> @@ -5611,7 +5654,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
>   			goto out_unset;
>   		}
>   
> -		ret = __add_reloc_root(reloc_root);
> +		ret = __add_reloc_root(reloc_root, rc);
>   		ASSERT(ret != -EEXIST);
>   		if (ret) {
>   			list_add_tail(&reloc_root->root_list, &reloc_roots);
> @@ -5645,7 +5688,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
>   	unset_reloc_control(rc);
>   	reloc_chunk_end(fs_info);
>   out_end:
> -	free_reloc_control(rc);
> +	put_reloc_control(rc);
>   out:
>   	free_reloc_roots(&reloc_roots);
>   
> @@ -5729,7 +5772,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
>   	int level;
>   	int ret = 0;
>   
> -	rc = fs_info->reloc_ctl;
> +	rc = get_reloc_control(fs_info);
>   	if (!rc)
>   		return 0;
>   
> @@ -5754,7 +5797,8 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
>   			btrfs_err(fs_info,
>   "bytenr %llu was found but our backref cache was expecting %llu or %llu",
>   				  buf->start, node->bytenr, node->new_bytenr);
> -			return -EUCLEAN;
> +			ret = -EUCLEAN;
> +			goto out;
>   		}
>   
>   		btrfs_backref_drop_node_buffer(node);
> @@ -5777,6 +5821,9 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
>   
>   	if (level == 0 && first_cow && rc->stage == UPDATE_DATA_PTRS)
>   		ret = replace_file_extents(trans, rc, root, cow);
> +out:
> +	put_reloc_control(rc);
> +
>   	return ret;
>   }
>   
> @@ -5825,13 +5872,16 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
>   	struct btrfs_root *root = pending->root;
>   	struct btrfs_root *reloc_root;
>   	struct btrfs_root *new_root;
> -	struct reloc_control *rc = root->fs_info->reloc_ctl;
> -	int ret;
> +	struct reloc_control *rc;
> +	int ret = 0;
>   
> -	if (!rc || !have_reloc_root(root))
> +	rc = get_reloc_control(trans->fs_info);
> +	if (!rc)
>   		return 0;
>   
> -	rc = root->fs_info->reloc_ctl;
> +	if (!have_reloc_root(root))
> +		goto out;
> +
>   	rc->merging_rsv_size += rc->nodes_relocated;
>   
>   	if (rc->merge_reloc_tree) {
> @@ -5839,23 +5889,28 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
>   					      rc->block_rsv,
>   					      rc->nodes_relocated, true);
>   		if (ret)
> -			return ret;
> +			goto out;
>   	}
>   
>   	new_root = pending->snap;
>   	reloc_root = create_reloc_root(trans, root->reloc_root, btrfs_root_id(new_root));
> -	if (IS_ERR(reloc_root))
> -		return PTR_ERR(reloc_root);
> +	if (IS_ERR(reloc_root)) {
> +		ret = PTR_ERR(reloc_root);
> +		goto out;
> +	}
>   
> -	ret = __add_reloc_root(reloc_root);
> +	ret = __add_reloc_root(reloc_root, rc);
>   	ASSERT(ret != -EEXIST);
>   	if (ret) {
>   		/* Pairs with create_reloc_root */
>   		btrfs_put_root(reloc_root);
> -		return ret;
> +		goto out;
>   	}
>   	new_root->reloc_root = btrfs_grab_root(reloc_root);
> -	return 0;
> +out:
> +	put_reloc_control(rc);
> +
> +	return ret;
>   }
>   
>   /*

