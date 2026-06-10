Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E687233921
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 07:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781076499; cv=none; b=ejBWnwXPfNIEs9vHbwIDKtKrl3HfsrFe9WrlrnPbd/SwWuX7UEyuSoEDSTL9HeJrcGTtaxTq8oRyyx0n7n85wmD5TIMlpI6PvIocaqnmdut+HIP5swv0UhF9xyRs44E7DNRq3BqLoHA8de/EVOnGKaDDCrvuMQQlPp3xbICXXbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781076499; c=relaxed/simple;
	bh=+vl8iSzhUdrn3mA7G3AQEj0rvm40zpkKC1JjXDXwLyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tc+DjnyDNSTU4GU5dvv5j6dg8M66jQVwtyhQQI03niUlhQ8kU/vHQLQ+26cDURRuvAF1B5vYFR/uX++iIUoo7ZW3IbQrie/NHtBB/xDSSGjYaO15UnaRHBSjcAc3JdP7h8WowGGZHFt5Hs19tzLWZ+T2ydYqKKFE4rINsu50hIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Kq2Ymwtx; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Kq2Ymwtx"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c0c3546924so42864985ad.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 00:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781076496; x=1781681296; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5tdfa79kDKbQ3+OuyJqsdJbJYSOTNkir4FhKFxBuivU=;
        b=Kq2YmwtxGxf94lEodwq1ewj+UPEu4qUnr1RTR9a73PiZnf3mh5IJeehXfQUbDStETZ
         qTBIV4JoOWgeIO8kY2EZUoL2+w9C1Z+HotsPiM9eiTjI3FYIY0zDot3QK2ZICAofkOoG
         f65+5t6OXrb+akCYmgcbQTrSi60UHIvhlA5Q6gLu64lHmWRwCOXMufYp67yVp3t4qarV
         VkW7c7X+Z5do41hJlr94FHrRH908v/Qiof4Sn4/DKRztqfZqjX3rSH5GnrgCz/w1WHzi
         WexduCk916JG2z42zwJ2tO8ke9Uwva3oFfuojaiFZbm8baXpUa2sNKKB9EDOuWblABbM
         qtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781076497; x=1781681297;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5tdfa79kDKbQ3+OuyJqsdJbJYSOTNkir4FhKFxBuivU=;
        b=Za1sqPQaeQuxFmupC5gR7PiawaLeHMGKvyt5JNCRX5prYcS5I/kfwJvOX8enJFouPs
         gENjO2NYHIZUJOr94uhpizmlOyLc6IUoS2Wgeczm7LfryowwFUWSEooaGy+zSWFdEYj3
         oPk+79rjYsxGhzpc+OOZGwJDzkX13em36Px/F2AMqyiRjS7vUri892uizPbzSHiZb6vA
         uz83rTORoGz0D6RQ4nBjoBoyoU3RmdPnhGMqmhBjTdBxPQia4GXugyJR3ANI3z4yUR+d
         kk5MFFkrr4gLhHoXhsM8jM/l2UL/o9s0GIerS92cFL4K6xbYpPF+ChwxHO8Ntcr92c1N
         tQAA==
X-Gm-Message-State: AOJu0YxxnDVkLSmcy+3huUM7SE5sGu9PIUriogw0avnAfxRfe+sMxSGt
	UhUQ9Llxyj0QeprG0LbheD/I7SAudIN1dhjQqbzi8pV6/89pLf+Up1+vZkEiNwJrCw==
X-Gm-Gg: Acq92OG3tBqtACgVEMo9x/DA72sFU4xv7E8RFryKiiWdgos21nBB+j4UVdNn7vs844f
	/0QBtt+S0qrYpCJwIoh2h1eUUH9mvRfUehHln8dbjdDKXh8NV+gXfPk6NHUaPD/117zyHWO7oBY
	NUZRLXQw/ZH5Dq/y7oFcePzqzLlPCCkzloDv7qNvlK8o1qs4Gg1TwzGd3UUXgetLosLGyA4WXEm
	H9BudNRcaiEW9YyQqwZPKb9FEFf3aBvPpYTzI4DbEJDUXTUeAAmrXUQc4i8e4vHp6FKqz1lWQd+
	iHKclU4cFQjKZgZe7UA13ZBGaJ7cdPfs3Nzr3hkv9uAnMaPjsKsksB0POSVo+yNob5+wT7p3SyQ
	hBFBjXb06SEEkF0cKB3TUycvDMYs0x1gineBUzGlprhB6FpCmJ7UEk3B1nIwtf0uoXeHfSwMqKG
	ZPFODeziWGBEdH
X-Received: by 2002:a17:902:cccd:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2c1e80f8de6mr247919985ad.2.1781076496470;
        Wed, 10 Jun 2026 00:28:16 -0700 (PDT)
Received: from p1 ([73.140.210.38])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649bde7sm241138905ad.72.2026.06.10.00.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 00:28:15 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:28:12 -0700
From: Xiang Mei <xmei5@asu.edu>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, 
	Chris Mason <clm@fb.com>, Josef Bacik <josef@redhat.com>, 
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH btrfs] btrfs: reject free space cache with more entries
 than pages
Message-ID: <fq2uzgw3rq6vq3hhlfnonj3co2thyi4yyim7eblk6omvvjklpw@tcw5xg5kmcfr>
References: <20260609081135.2972081-1-xmei5@asu.edu>
 <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>
 <jnoeup5w2qznvycfqkoze6f3pv2dg6wgeoax4kiv743tmiapd3@fdmnmlat7a2a>
 <f7220873-14be-4e71-91df-f77486dba803@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7220873-14be-4e71-91df-f77486dba803@suse.com>

On Wed, Jun 10, 2026 at 09:46:24AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/10 08:57, Xiang Mei 写道:
> [...]
> > 
> > Feel free to let us know if you can't reprodce this bug. We are glad to
> > help.
> 
> 
> In this case, I stronglly recommend to you guys to send out a dedicated
> mail, showing the PoC, needed assets/step to reproduce the situation as a
> bug report first, just like what syzbot is doing.
> 
> Then send a proper fix, with Link: tag pointing to that bug report.
> 
> If you want to fix the bug by yourself, and don't want trigger-happy guys
> like me to fix it before your fix, you can just mention that a fix is
> already on the way in the bug report mail.
> 
> 
> This is way better for us to do a comprehensive review and provide more
> accurate advice on what to improve.

Thanks, that makes sense. We're new to this part of the tree and didn't
really know the preferred flow, so we'll do the report-first thing starting
from the next one.

For this bug, here's what's actually going on.

The PoC only changes one thing on disk: it inflates num_entries in the v1
free space header (the btrfs_free_space_header in the tree_root), then fixes
up the leaf csum so the leaf still passes. The tree-checker doesn't look at
that header, so the bogus count survives into __load_free_space_cache().

The problem is that io_ctl->pages[] is sized from the cache inode's i_size,
not from num_entries. So once the load loop has consumed all the real pages,
io_ctl->index keeps going and io_ctl_map_page() reads past the end of pages[]
(it's inlined into io_ctl_check_crc, which is why that's the frame KASAN
shows). That OOB pointer then gets dereferenced in the crc32c() right after,
which turns into the GP fault. Both halves are in the log at the end of this
mail.

On where to check: we did look at catching it earlier, up in
__load_free_space_cache() by comparing num_entries against num_pages. We
didn't because the entries-per-page count isn't a clean number (a bitmap
takes a whole page, an extent doesn't), so an up-front bound is easy to get
slightly wrong and end up rejecting a good cache.

Checking index >= num_pages right at the map is the condition we actually
care about, and it's the one spot both the entry loop and the bitmap loop go
through. The write side already does the same check before mapping; the read
side was just missing it. When it trips we return -EIO, which lands on the
existing goto free_cache path, so the cache is just dropped and rebuilt from
the extent tree (a normal cache never gets there).

The full crash is pasted below for reference. We don't have anywhere to host
files, so we can't give a syzbot-style link, but the assets to reproduce it
were in our previous mail.

Thanks again for taking the time to review.

Xiang

[    2.760247] ==================================================================
[    2.760577] BUG: KASAN: slab-out-of-bounds in io_ctl_check_crc+0x3e0/0x4b0
[    2.760914] Read of size 8 at addr ffff88800c833a80 by task kworker/u8:3/58
[    2.761229] 
[    2.761307] CPU: 0 UID: 0 PID: 58 Comm: kworker/u8:3 Not tainted 7.1.0-rc6+ #5 PREEMPTLAZY 
[    2.761315] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/4
[    2.761320] Workqueue: btrfs-cache btrfs_work_helper
[    2.761326] Call Trace:
[    2.761329]  <TASK>
[    2.761331]  dump_stack_lvl+0xbc/0xf0
[    2.761342]  print_report+0xd0/0x630
[    2.761354]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    2.761364]  ? io_ctl_check_crc+0x3e0/0x4b0
[    2.761371]  kasan_report+0xce/0x100
[    2.761380]  ? io_ctl_check_crc+0x3e0/0x4b0
[    2.761388]  io_ctl_check_crc+0x3e0/0x4b0
[    2.761395]  __load_free_space_cache+0xb7b/0xed0
[    2.761404]  ? __pfx___load_free_space_cache+0x10/0x10
[    2.761413]  ? _raw_spin_lock+0x84/0xe0
[    2.761422]  ? __pfx__raw_spin_lock+0x10/0x10
[    2.761431]  ? kmem_cache_alloc_noprof+0x14f/0x440
[    2.761438]  load_free_space_cache+0x356/0xc20
[    2.761446]  ? btrfs_bio_end_io+0x2bb/0x3c0
[    2.761455]  ? simple_end_io_work+0x13e/0x1b0
[    2.761462]  ? process_one_work+0x747/0x1120
[    2.761472]  ? worker_thread+0x6e0/0xea0
[    2.761479]  ? kthread+0x3c4/0x510
[    2.761486]  ? ret_from_fork+0x373/0x880
[    2.761496]  ? __pfx_load_free_space_cache+0x10/0x10
[    2.761506]  ? __pfx_mutex_lock+0x10/0x10
[    2.761512]  ? update_load_avg+0x184/0xd60
[    2.761518]  caching_thread+0xb19/0x1150
[    2.761527]  ? psi_group_change+0x521/0xb10
[    2.761536]  ? native_load_tls+0x1c/0x70
[    2.761542]  ? _raw_spin_unlock+0xe/0x30
[    2.761551]  ? __pfx_caching_thread+0x10/0x10
[    2.761560]  ? _raw_spin_lock+0x84/0xe0
[    2.761568]  ? __pfx__raw_spin_lock+0x10/0x10
[    2.761579]  btrfs_work_helper+0x1f2/0xf70
[    2.761584]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[    2.761593]  process_one_work+0x747/0x1120
[    2.761601]  ? assign_work+0x167/0x3c0
[    2.761608]  worker_thread+0x6e0/0xea0
[    2.761617]  ? __pfx_worker_thread+0x10/0x10
[    2.761624]  kthread+0x3c4/0x510
[    2.761631]  ? __pfx_kthread+0x10/0x10
[    2.761637]  ret_from_fork+0x373/0x880
[    2.761645]  ? __pfx_ret_from_fork+0x10/0x10
[    2.761654]  ? __switch_to+0x66a/0xe60
[    2.761661]  ? __pfx_kthread+0x10/0x10
[    2.761672]  ret_from_fork_asm+0x1a/0x30
[    2.761681]  </TASK>
[    2.761683] 
[    2.771308] Allocated by task 58:
[    2.771573] 
[    2.771652] The buggy address belongs to the object at ffff88800c833a00
[    2.771652]  which belongs to the cache kmalloc-128 of size 128
[    2.772233] The buggy address is located 0 bytes to the right of
[    2.772233]  allocated 128-byte region [ffff88800c833a00, ffff88800c833a80)
[    2.772807] 
[    2.772890] The buggy address belongs to the physical page:
[    2.773191] 
[    2.773273] Memory state around the buggy address:
[    2.773496]  ffff88800c833980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.773823]  ffff88800c833a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.774132] >ffff88800c833a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.774435]                    ^
[    2.774576]  ffff88800c833b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.774905]  ffff88800c833b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    2.775205] ==================================================================
[    2.775533] Oops: general protection fault, probably for non-canonical address 0x2685384000000000: 0000 [#1] SMP KASAN NOPTI
[    2.776019] CPU: 0 UID: 0 PID: 58 Comm: kworker/u8:3 Tainted: G    B               7.1.0-rc6+ #5 PREEMPTLAZY 
[    2.776449] Tainted: [B]=BAD_PAGE
[    2.776602] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/4
[    2.777111] Workqueue: btrfs-cache btrfs_work_helper
[    2.777339] RIP: 0010:crc32c_x86_3way+0x55/0x1a0
[    2.777545] Code: f3 48 81 fa 00 0c 00 00 73 0b 69 c2 ab 0a 00 00 c1 e8 10 eb 05 b8 80 00 00 00 4d 31 c0 4d 31 c9 89 c1 c1 8
[    2.778372] RSP: 0018:ffff88800d0476c0 EFLAGS: 00010216
[    2.778603] RAX: 000000000000007b RBX: 00000000ffffffff RCX: 0000000000000400
[    2.778948] RDX: 0000000000001000 RSI: 2685384000000000 RDI: 00000000ffffffff
[    2.779284] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    2.779611] R10: 0000000000000000 R11: 3d3d3d3d3d3d3d3d R12: 0000000000001000
[    2.779936] R13: 2685384000000000 R14: 0000000000001000 R15: ffffea0000000000
[    2.780258] FS:  0000000000000000(0000) GS:ffff888177237000(0000) knlGS:0000000000000000
[    2.780619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.780885] CR2: 0000597d6c72f39c CR3: 000000000890e005 CR4: 0000000000772ef0
[    2.781193] PKRU: 55555554
[    2.781316] Call Trace:
[    2.781431]  <TASK>
[    2.781535]  crc32c+0x34c/0x3a0
[    2.781704]  io_ctl_check_crc+0x248/0x4b0
[    2.781887]  __load_free_space_cache+0xb7b/0xed0
[    2.782108]  ? __pfx___load_free_space_cache+0x10/0x10
[    2.782354]  ? _raw_spin_lock+0x84/0xe0
[    2.782539]  ? __pfx__raw_spin_lock+0x10/0x10
[    2.782764]  ? kmem_cache_alloc_noprof+0x14f/0x440
[    2.782993]  load_free_space_cache+0x356/0xc20
[    2.783197]  ? btrfs_bio_end_io+0x2bb/0x3c0
[    2.783378]  ? simple_end_io_work+0x13e/0x1b0
[    2.783579]  ? process_one_work+0x747/0x1120
[    2.783782]  ? worker_thread+0x6e0/0xea0
[    2.783954]  ? kthread+0x3c4/0x510
[    2.784109]  ? ret_from_fork+0x373/0x880
[    2.784293]  ? __pfx_load_free_space_cache+0x10/0x10
[    2.784512]  ? __pfx_mutex_lock+0x10/0x10
[    2.784700]  ? update_load_avg+0x184/0xd60
[    2.784875]  caching_thread+0xb19/0x1150
[    2.785060]  ? psi_group_change+0x521/0xb10
[    2.785254]  ? native_load_tls+0x1c/0x70
[    2.785436]  ? _raw_spin_unlock+0xe/0x30
[    2.785619]  ? __pfx_caching_thread+0x10/0x10
[    2.785824]  ? _raw_spin_lock+0x84/0xe0
[    2.785995]  ? __pfx__raw_spin_lock+0x10/0x10
[    2.786189]  btrfs_work_helper+0x1f2/0xf70
[    2.786365]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[    2.786571]  process_one_work+0x747/0x1120
[    2.786762]  ? assign_work+0x167/0x3c0
[    2.786928]  worker_thread+0x6e0/0xea0
[    2.787095]  ? __pfx_worker_thread+0x10/0x10
[    2.787293]  kthread+0x3c4/0x510
[    2.787437]  ? __pfx_kthread+0x10/0x10
[    2.787602]  ret_from_fork+0x373/0x880
[    2.787780]  ? __pfx_ret_from_fork+0x10/0x10
[    2.787969]  ? __switch_to+0x66a/0xe60
[    2.788135]  ? __pfx_kthread+0x10/0x10
[    2.788302]  ret_from_fork_asm+0x1a/0x30
[    2.788476]  </TASK>
[    2.788577] Modules linked in:
[    2.788728] ---[ end trace 0000000000000000 ]---
[    2.788930] RIP: 0010:crc32c_x86_3way+0x55/0x1a0
[    2.789131] Code: f3 48 81 fa 00 0c 00 00 73 0b 69 c2 ab 0a 00 00 c1 e8 10 eb 05 b8 80 00 00 00 4d 31 c0 4d 31 c9 89 c1 c1 8
[    2.789909] RSP: 0018:ffff88800d0476c0 EFLAGS: 00010216
[    2.790134] RAX: 000000000000007b RBX: 00000000ffffffff RCX: 0000000000000400
[    2.790431] RDX: 0000000000001000 RSI: 2685384000000000 RDI: 00000000ffffffff
[    2.790739] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    2.791040] R10: 0000000000000000 R11: 3d3d3d3d3d3d3d3d R12: 0000000000001000
[    2.791338] R13: 2685384000000000 R14: 0000000000001000 R15: ffffea0000000000
[    2.791635] FS:  0000000000000000(0000) GS:ffff888177237000(0000) knlGS:0000000000000000
[    2.791978] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.792221] CR2: 0000597d6c72f39c CR3: 000000000890e005 CR4: 0000000000772ef0
[    2.792518] PKRU: 55555554
[    2.792640] Kernel panic - not syncing: Fatal exception in interrupt
[    2.793588] Kernel Offset: disabled


