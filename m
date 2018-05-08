Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:41319 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbeEHBIR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 21:08:17 -0400
Received: by mail-io0-f182.google.com with SMTP id e12-v6so36441538iob.8
        for <linux-btrfs@vger.kernel.org>; Mon, 07 May 2018 18:08:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d5a49536db0af628f97f871254dc266d@synology.com>
References: <d5a49536db0af628f97f871254dc266d@synology.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 8 May 2018 09:08:15 +0800
Message-ID: <CANQeFDBgTLdkWz02YHoDh9AahEo-O18mcwQcKqGgeJxPDnhHjQ@mail.gmail.com>
Subject: Re: Problem with current->journal_info for BTRFS, Null pointer
 dereference in start_transaction
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 7, 2018 at 2:49 PM, robbieko <robbieko@synology.com> wrote:
> Hi,
>
> When send process requires memory allocation, shrinker may be triggered due
> to insufficient memory.
> Then evict_inode gets called when inode is dropped, and this function may
> need to start transaction.
> However, the journal_info is already points to BTRFS_SEND_TRANS_STUB, it
> passed the if condition,
> and the following use yields illegal memory access.
>
>  495     if (current->journal_info) {
>  496         WARN_ON(type & TRANS_EXTWRITERS);
>  497         h = current->journal_info;
>  498         refcount_inc(&h->use_count);
>  499         WARN_ON(refcount_read(&h->use_count) > 2);
>  500         h->orig_rsv = h->block_rsv;
>  501         h->block_rsv = NULL;
>  502         goto got_it;
>  503     }
>
> Direct IO has a similar problem, journal_info will store btrfs_dio_data,
> which will lead to illegal memory access.
>
> Anyone have the best solution?
>

btrfs_evict_inode() only starts transaction before doing truncate,
thus we can save the trans_handle and restore afterwards.

The same stuff can be applied to direct IO as what we used to do.

thanks,
liubo
> CallTrace looks like this:
> 018-04-30T04:28:00+08:00 Office kernel: [62182.567827] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000021
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.576596] IP:
> [<ffffffffa086f2d4>] start_transaction+0x64/0x450 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.584208] PGD 8fea4b067 PUD
> a33bea067 PMD 0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.589179] Oops: 0000 [#1] SMP
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.734282] CPU: 3 PID: 12681
> Comm: btrfs Tainted: P C O 3.10.102 #15266
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.742554] Hardware name:
> Synology Inc. RS3617xs Series/Type2 - Board Product Name1, BIOS M.012
> 2016/06/04
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.753451] task:
> ffff880a2babc040 ti: ffff880013e80000 task.ti: ffff880013e80000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.761819] RIP:
> 0010:[<ffffffffa086f2d4>] [<ffffffffa086f2d4>] start_transaction+0x64/0x450
> [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.772148] RSP:
> 0018:ffff880013e834d0 EFLAGS: 00010246
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.778085] RAX:
> ffff880a2babc040 RBX: ffff880b7e8488a0 RCX: 0000000000000000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.786063] RDX:
> ffff88101c1bc000 RSI: 0000000000000000 RDI: 0000000000000000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.794034] RBP:
> 0000000000000801 R08: 0000000000000001 R09: 0000000000000000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.802012] R10:
> 0000000000000100 R11: 0000000000000002 R12: ffff881018148000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.809983] R13:
> 0000000000000001 R14: ffff88101c1bc188 R15: ffff881018148000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.817961] FS:
> 00007f3db36038c0(0000) GS:ffff88107fc60000(0000) knlGS:0000000000000000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.827001] CS: 0010 DS: 0000
> ES: 0000 CR0: 0000000080050033
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.833424] CR2:
> 0000000000000021 CR3: 0000000633403000 CR4: 00000000003407e0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.841394] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.849373] DR3:
> 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.857351] Stack:
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.859585] 0000000000020000
> ffff881018148000 ffff880b7e8488a0 0000000000020000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.867869] ffff880933256540
> ffff880013e83550 ffff88101c1bc188 ffff881018148000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.876161] ffffffffa087a838
> 0000000000000007 0000000000000000 ffff88101c1bc000
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.884450] Call Trace:
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.887198] [<ffffffffa087a838>]
> ? btrfs_evict_inode+0x3d8/0x580 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.894799] [<ffffffff81115932>]
> ? evict+0xa2/0x1a0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.900352] [<ffffffff81112888>]
> ? shrink_dentry_list+0x308/0x3d0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.907263] [<ffffffff811137f3>]
> ? prune_dcache_sb+0x133/0x160
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.913881] [<ffffffff810fa51f>]
> ? prune_super+0xcf/0x1a0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.920013] [<ffffffff810bf6bf>]
> ? shrink_slab+0x11f/0x1d0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.926242] [<ffffffff810c19f2>]
> ? do_try_to_free_pages+0x452/0x560
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.933337] [<ffffffff810bf054>]
> ? throttle_direct_reclaim+0x74/0x240
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.940634] [<ffffffff810c1bae>]
> ? try_to_free_pages+0xae/0xc0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.947252] [<ffffffff810ba16b>]
> ? __alloc_pages_nodemask+0x53b/0x9f0
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.954542] [<ffffffff810bc89c>]
> ? __do_page_cache_readahead+0xec/0x270
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.962035] [<ffffffff810bcb2b>]
> ? ondemand_readahead+0xbb/0x220
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.968863] [<ffffffffa08d7c43>]
> ? fill_read_buf+0x2b3/0x3a0 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.976073] [<ffffffffa08dbf5e>]
> ? send_extent_data+0x10e/0x300 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.983566] [<ffffffffa08dc34b>]
> ? process_extent+0x1fb/0x1310 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.990969] [<ffffffffa08d8300>]
> ? iterate_dir_item.isra.28+0x1b0/0x250 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62182.999249] [<ffffffffa08dd500>]
> ? send_set_xattr+0xa0/0xa0 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.006378] [<ffffffffa08de565>]
> ? changed_cb+0xd5/0xc40 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.013190] [<ffffffffa08df1c2>]
> ? full_send_tree+0xf2/0x1a0 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.020400] [<ffffffffa08e022b>]
> ? btrfs_ioctl_send+0xfbb/0x1040 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.028003] [<ffffffffa08a9864>]
> ? btrfs_ioctl+0x1084/0x32a0 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.035223] [<ffffffff810d2333>]
> ? handle_pte_fault+0x363/0x980
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.041939] [<ffffffff81054e81>]
> ? atomic_notifier_call_chain+0x11/0x20
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.049433] [<ffffffff8105a1bc>]
> ? set_task_cpu+0xbc/0x150
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.055678] [<ffffffff810d34ae>]
> ? handle_mm_fault+0x13e/0x2a0
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.062297] [<ffffffff8102a6e8>]
> ? __do_page_fault+0x1b8/0x480
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.068916] [<ffffffff81058263>]
> ? update_rq_clock.part.63+0x13/0x30
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.076119] [<ffffffff81059edf>]
> ? check_preempt_curr+0x4f/0x90
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.082835] [<ffffffff8110e12e>]
> ? do_vfs_ioctl+0x20e/0x880
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.089163] [<ffffffff8103323a>]
> ? do_fork+0xfa/0x350
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.094906] [<ffffffff8110e820>]
> ? SyS_ioctl+0x80/0xa0
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.100749] [<ffffffff814b0ff2>]
> ? system_call_fastpath+0x16/0x1b
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.107658] Code: 00 48 83 b8 f8
> 05 00 00 00 0f 84 28 01 00 00 f7 c5 00 07 00 00 0f 85 e6 00 00 00 65 48 8b
> 04 25 c0 a7 00 00 4c 8b a8 f8 05 00 00 <49> 8b 45 20 48 83 c0 01 48 83 f8 02
> 49 89 45 20 0f 87 d6 00 00
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.129061] RIP
> [<ffffffffa086f2d4>] start_transaction+0x64/0x450 [btrfs]
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.136769] RSP
> <ffff880013e834d0>
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.140663] CR2:
> 0000000000000021
> 2018-04-30T04:28:00+08:00 Office kernel: [62183.144411] ---[ end trace
> 09fed78afc32d93e ]---
>
> Thanks.
> Robbie Ko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
