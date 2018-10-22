Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27289C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C30205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:00:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="fXjRe+A4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C30205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbeJWCUD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:20:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42944 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbeJWCUC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 22:20:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id j46-v6so47362038qtc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 11:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QJ5l+itGXPBHvqIFxA1KYog9xGNixGlUV4Ee6u3GNcM=;
        b=fXjRe+A4QtNzBceULQ53uvZ+9NXMHG66PEOmTDkG9+nJUuJCPg7FvFYdaEK5OK4khq
         cMegVcuWKcqiFlXAFAQ2wYf2iX7+mgOKGyxhSqtWy2+x8FxpejsWMWESRDNPh7Sb3Gd3
         wdQNNp6Iz9NjNxq36zbGPtJpn/GIs07D1eB/VD9zOXe3rjjKDVs2JeQ5Hml7sy1WAPeb
         edOZZfONSFs1P8e4CZWLKX3XN82CD8aJFPs6XyiHWIKaqmFZdH7oURSokdaRVmIzx0Hp
         hEpoGaiUVSh15S/r4wIjkhcX1I7OiUegY/F1Y/A8tSiqkEXFjgUnio3UOA9p5J4zLrFQ
         xsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QJ5l+itGXPBHvqIFxA1KYog9xGNixGlUV4Ee6u3GNcM=;
        b=GUyoQUWMoY+s+M4Y+8JXSS//MJ1oU0JBCvJRksYDgxC4l1JVWbsJPiHTO4KhOJBRbw
         9lBlmL4J0woJ4GpJe3b0OB6l47j7khSY6/ouZqSbd3W0Vg80av0JCve9dvMkHSXiivO7
         1rOgdpPVAafDnMSGkgburlUGCxIHBskkz71NpKIUi4gJD3VC8HtkMvLoZW5Awr9XNiH9
         YH9bSCuERhB9UAQ9m81VRTigknIPa8Q6uvA0aOHbAYYg9ICDzehYXKPuBVMn1MX7BG3h
         piboe443LxtFlw573Zcjn24aFLPAGUmu3X9jDr3CroEaTRV05kfEJRREt4uhTaNwiRfz
         //qg==
X-Gm-Message-State: ABuFfoiwqApawIuxYiOy9DLS+ZFA/tVDfHl1rBDr756s5FnsenNvTKsT
        Mw2xs43YM+2oTwsFEfKJRtuj9KWl9aPNtA==
X-Google-Smtp-Source: ACcGV625Q5RCzJIzImwAIYWrxB0optfq61WN8OJvH8jmJvOZbMSig9ViUiHDxJCZGW5QRVp0ESaRJA==
X-Received: by 2002:ac8:1701:: with SMTP id w1-v6mr12230103qtj.76.1540231230079;
        Mon, 22 Oct 2018 11:00:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d134-v6sm21991822qke.88.2018.10.22.11.00.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Oct 2018 11:00:29 -0700 (PDT)
Date:   Mon, 22 Oct 2018 14:00:28 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix use-after-free when dumping free space
Message-ID: <20181022180027.dwnptf7hero2j74h@destiny>
References: <20181022094306.28868-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022094306.28868-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 10:43:06AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We were iterating a block group's free space cache rbtree without locking
> first the lock that protects it (the free_space_ctl->free_space_offset
> rbtree is protected by the free_space_ctl->tree_lock spinlock).
> 
> KASAN reported an use-after-free problem when iterating such a rbtree due
> to a concurrent rbtree delete:
> 
> [ 9520.359168] ==================================================================
> [ 9520.359656] BUG: KASAN: use-after-free in rb_next+0x13/0x90
> [ 9520.359949] Read of size 8 at addr ffff8800b7ada500 by task btrfs-transacti/1721
> [ 9520.360357]
> [ 9520.360530] CPU: 4 PID: 1721 Comm: btrfs-transacti Tainted: G             L    4.19.0-rc8-nbor #555
> [ 9520.360990] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [ 9520.362682] Call Trace:
> [ 9520.362887]  dump_stack+0xa4/0xf5
> [ 9520.363146]  print_address_description+0x78/0x280
> [ 9520.363412]  kasan_report+0x263/0x390
> [ 9520.363650]  ? rb_next+0x13/0x90
> [ 9520.363873]  __asan_load8+0x54/0x90
> [ 9520.364102]  rb_next+0x13/0x90
> [ 9520.364380]  btrfs_dump_free_space+0x146/0x160 [btrfs]
> [ 9520.364697]  dump_space_info+0x2cd/0x310 [btrfs]
> [ 9520.364997]  btrfs_reserve_extent+0x1ee/0x1f0 [btrfs]
> [ 9520.365310]  __btrfs_prealloc_file_range+0x1cc/0x620 [btrfs]
> [ 9520.365646]  ? btrfs_update_time+0x180/0x180 [btrfs]
> [ 9520.365923]  ? _raw_spin_unlock+0x27/0x40
> [ 9520.366204]  ? btrfs_alloc_data_chunk_ondemand+0x2c0/0x5c0 [btrfs]
> [ 9520.366549]  btrfs_prealloc_file_range_trans+0x23/0x30 [btrfs]
> [ 9520.366880]  cache_save_setup+0x42e/0x580 [btrfs]
> [ 9520.367220]  ? btrfs_check_data_free_space+0xd0/0xd0 [btrfs]
> [ 9520.367518]  ? lock_downgrade+0x2f0/0x2f0
> [ 9520.367799]  ? btrfs_write_dirty_block_groups+0x11f/0x6e0 [btrfs]
> [ 9520.368104]  ? kasan_check_read+0x11/0x20
> [ 9520.368349]  ? do_raw_spin_unlock+0xa8/0x140
> [ 9520.368638]  btrfs_write_dirty_block_groups+0x2af/0x6e0 [btrfs]
> [ 9520.368978]  ? btrfs_start_dirty_block_groups+0x870/0x870 [btrfs]
> [ 9520.369282]  ? do_raw_spin_unlock+0xa8/0x140
> [ 9520.369534]  ? _raw_spin_unlock+0x27/0x40
> [ 9520.369811]  ? btrfs_run_delayed_refs+0x1b8/0x230 [btrfs]
> [ 9520.370137]  commit_cowonly_roots+0x4b9/0x610 [btrfs]
> [ 9520.370560]  ? commit_fs_roots+0x350/0x350 [btrfs]
> [ 9520.370926]  ? btrfs_run_delayed_refs+0x1b8/0x230 [btrfs]
> [ 9520.371285]  btrfs_commit_transaction+0x5e5/0x10e0 [btrfs]
> [ 9520.371612]  ? btrfs_apply_pending_changes+0x90/0x90 [btrfs]
> [ 9520.371943]  ? start_transaction+0x168/0x6c0 [btrfs]
> [ 9520.372257]  transaction_kthread+0x21c/0x240 [btrfs]
> [ 9520.372537]  kthread+0x1d2/0x1f0
> [ 9520.372793]  ? btrfs_cleanup_transaction+0xb50/0xb50 [btrfs]
> [ 9520.373090]  ? kthread_park+0xb0/0xb0
> [ 9520.373329]  ret_from_fork+0x3a/0x50
> [ 9520.373567]
> [ 9520.373738] Allocated by task 1804:
> [ 9520.373974]  kasan_kmalloc+0xff/0x180
> [ 9520.374208]  kasan_slab_alloc+0x11/0x20
> [ 9520.374447]  kmem_cache_alloc+0xfc/0x2d0
> [ 9520.374731]  __btrfs_add_free_space+0x40/0x580 [btrfs]
> [ 9520.375044]  unpin_extent_range+0x4f7/0x7a0 [btrfs]
> [ 9520.375383]  btrfs_finish_extent_commit+0x15f/0x4d0 [btrfs]
> [ 9520.375707]  btrfs_commit_transaction+0xb06/0x10e0 [btrfs]
> [ 9520.376027]  btrfs_alloc_data_chunk_ondemand+0x237/0x5c0 [btrfs]
> [ 9520.376365]  btrfs_check_data_free_space+0x81/0xd0 [btrfs]
> [ 9520.376689]  btrfs_delalloc_reserve_space+0x25/0x80 [btrfs]
> [ 9520.377018]  btrfs_direct_IO+0x42e/0x6d0 [btrfs]
> [ 9520.377284]  generic_file_direct_write+0x11e/0x220
> [ 9520.377587]  btrfs_file_write_iter+0x472/0xac0 [btrfs]
> [ 9520.377875]  aio_write+0x25c/0x360
> [ 9520.378106]  io_submit_one+0xaa0/0xdc0
> [ 9520.378343]  __se_sys_io_submit+0xfa/0x2f0
> [ 9520.378589]  __x64_sys_io_submit+0x43/0x50
> [ 9520.378840]  do_syscall_64+0x7d/0x240
> [ 9520.379081]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 9520.379387]
> [ 9520.379557] Freed by task 1802:
> [ 9520.379782]  __kasan_slab_free+0x173/0x260
> [ 9520.380028]  kasan_slab_free+0xe/0x10
> [ 9520.380262]  kmem_cache_free+0xc1/0x2c0
> [ 9520.380544]  btrfs_find_space_for_alloc+0x4cd/0x4e0 [btrfs]
> [ 9520.380866]  find_free_extent+0xa99/0x17e0 [btrfs]
> [ 9520.381166]  btrfs_reserve_extent+0xd5/0x1f0 [btrfs]
> [ 9520.381474]  btrfs_get_blocks_direct+0x60b/0xbd0 [btrfs]
> [ 9520.381761]  __blockdev_direct_IO+0x10ee/0x58a1
> [ 9520.382059]  btrfs_direct_IO+0x25a/0x6d0 [btrfs]
> [ 9520.382321]  generic_file_direct_write+0x11e/0x220
> [ 9520.382623]  btrfs_file_write_iter+0x472/0xac0 [btrfs]
> [ 9520.382904]  aio_write+0x25c/0x360
> [ 9520.383172]  io_submit_one+0xaa0/0xdc0
> [ 9520.383416]  __se_sys_io_submit+0xfa/0x2f0
> [ 9520.383678]  __x64_sys_io_submit+0x43/0x50
> [ 9520.383927]  do_syscall_64+0x7d/0x240
> [ 9520.384165]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [ 9520.384439]
> [ 9520.384610] The buggy address belongs to the object at ffff8800b7ada500
>                 which belongs to the cache btrfs_free_space of size 72
> [ 9520.385175] The buggy address is located 0 bytes inside of
>                 72-byte region [ffff8800b7ada500, ffff8800b7ada548)
> [ 9520.385691] The buggy address belongs to the page:
> [ 9520.385957] page:ffffea0002deb680 count:1 mapcount:0 mapping:ffff880108a1d700 index:0x0 compound_mapcount: 0
> [ 9520.388030] flags: 0x8100(slab|head)
> [ 9520.388281] raw: 0000000000008100 ffffea0002deb608 ffffea0002728808 ffff880108a1d700
> [ 9520.388722] raw: 0000000000000000 0000000000130013 00000001ffffffff 0000000000000000
> [ 9520.389169] page dumped because: kasan: bad access detected
> [ 9520.389473]
> [ 9520.389658] Memory state around the buggy address:
> [ 9520.389943]  ffff8800b7ada400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 9520.390368]  ffff8800b7ada480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 9520.390796] >ffff8800b7ada500: fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc
> [ 9520.391223]                    ^
> [ 9520.391461]  ffff8800b7ada580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 9520.391885]  ffff8800b7ada600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 9520.392313] ==================================================================
> [ 9520.392772] BTRFS critical (device vdc): entry offset 2258497536, bytes 131072, bitmap no
> [ 9520.393247] BUG: unable to handle kernel NULL pointer dereference at 0000000000000011
> [ 9520.393705] PGD 800000010dbab067 P4D 800000010dbab067 PUD 107551067 PMD 0
> [ 9520.394059] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [ 9520.394378] CPU: 4 PID: 1721 Comm: btrfs-transacti Tainted: G    B        L    4.19.0-rc8-nbor #555
> [ 9520.394858] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [ 9520.395350] RIP: 0010:rb_next+0x3c/0x90
> [ 9520.396461] RSP: 0018:ffff8801074ff780 EFLAGS: 00010292
> [ 9520.396762] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81b5ac4c
> [ 9520.397115] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000011
> [ 9520.397468] RBP: ffff8801074ff7a0 R08: ffffed0021d64ccc R09: ffffed0021d64ccc
> [ 9520.397821] R10: 0000000000000001 R11: ffffed0021d64ccb R12: ffff8800b91e0000
> [ 9520.398188] R13: ffff8800a3ceba48 R14: ffff8800b627bf80 R15: 0000000000020000
> [ 9520.398555] FS:  0000000000000000(0000) GS:ffff88010eb00000(0000) knlGS:0000000000000000
> [ 9520.399007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 9520.399335] CR2: 0000000000000011 CR3: 0000000106b52000 CR4: 00000000000006a0
> [ 9520.399679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 9520.400023] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 9520.400400] Call Trace:
> [ 9520.400648]  btrfs_dump_free_space+0x146/0x160 [btrfs]
> [ 9520.400974]  dump_space_info+0x2cd/0x310 [btrfs]
> [ 9520.401287]  btrfs_reserve_extent+0x1ee/0x1f0 [btrfs]
> [ 9520.401609]  __btrfs_prealloc_file_range+0x1cc/0x620 [btrfs]
> [ 9520.401952]  ? btrfs_update_time+0x180/0x180 [btrfs]
> [ 9520.402232]  ? _raw_spin_unlock+0x27/0x40
> [ 9520.402522]  ? btrfs_alloc_data_chunk_ondemand+0x2c0/0x5c0 [btrfs]
> [ 9520.402882]  btrfs_prealloc_file_range_trans+0x23/0x30 [btrfs]
> [ 9520.403261]  cache_save_setup+0x42e/0x580 [btrfs]
> [ 9520.403570]  ? btrfs_check_data_free_space+0xd0/0xd0 [btrfs]
> [ 9520.403871]  ? lock_downgrade+0x2f0/0x2f0
> [ 9520.404161]  ? btrfs_write_dirty_block_groups+0x11f/0x6e0 [btrfs]
> [ 9520.404481]  ? kasan_check_read+0x11/0x20
> [ 9520.404732]  ? do_raw_spin_unlock+0xa8/0x140
> [ 9520.405026]  btrfs_write_dirty_block_groups+0x2af/0x6e0 [btrfs]
> [ 9520.405375]  ? btrfs_start_dirty_block_groups+0x870/0x870 [btrfs]
> [ 9520.405694]  ? do_raw_spin_unlock+0xa8/0x140
> [ 9520.405958]  ? _raw_spin_unlock+0x27/0x40
> [ 9520.406243]  ? btrfs_run_delayed_refs+0x1b8/0x230 [btrfs]
> [ 9520.406574]  commit_cowonly_roots+0x4b9/0x610 [btrfs]
> [ 9520.406899]  ? commit_fs_roots+0x350/0x350 [btrfs]
> [ 9520.407253]  ? btrfs_run_delayed_refs+0x1b8/0x230 [btrfs]
> [ 9520.407589]  btrfs_commit_transaction+0x5e5/0x10e0 [btrfs]
> [ 9520.407925]  ? btrfs_apply_pending_changes+0x90/0x90 [btrfs]
> [ 9520.408262]  ? start_transaction+0x168/0x6c0 [btrfs]
> [ 9520.408582]  transaction_kthread+0x21c/0x240 [btrfs]
> [ 9520.408870]  kthread+0x1d2/0x1f0
> [ 9520.409138]  ? btrfs_cleanup_transaction+0xb50/0xb50 [btrfs]
> [ 9520.409440]  ? kthread_park+0xb0/0xb0
> [ 9520.409682]  ret_from_fork+0x3a/0x50
> [ 9520.410508] Dumping ftrace buffer:
> [ 9520.410764]    (ftrace buffer empty)
> [ 9520.411007] CR2: 0000000000000011
> [ 9520.411297] ---[ end trace 01a0863445cf360a ]---
> [ 9520.411568] RIP: 0010:rb_next+0x3c/0x90
> [ 9520.412644] RSP: 0018:ffff8801074ff780 EFLAGS: 00010292
> [ 9520.412932] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81b5ac4c
> [ 9520.413274] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000011
> [ 9520.413616] RBP: ffff8801074ff7a0 R08: ffffed0021d64ccc R09: ffffed0021d64ccc
> [ 9520.414007] R10: 0000000000000001 R11: ffffed0021d64ccb R12: ffff8800b91e0000
> [ 9520.414349] R13: ffff8800a3ceba48 R14: ffff8800b627bf80 R15: 0000000000020000
> [ 9520.416074] FS:  0000000000000000(0000) GS:ffff88010eb00000(0000) knlGS:0000000000000000
> [ 9520.416536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 9520.416848] CR2: 0000000000000011 CR3: 0000000106b52000 CR4: 00000000000006a0
> [ 9520.418477] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 9520.418846] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 9520.419204] Kernel panic - not syncing: Fatal exception
> [ 9520.419666] Dumping ftrace buffer:
> [ 9520.419930]    (ftrace buffer empty)
> [ 9520.420168] Kernel Offset: disabled
> [ 9520.420406] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> Fix this by acquiring the respective lock before iterating the rbtree.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
