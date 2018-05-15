Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:38695 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbeEOIgN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:36:13 -0400
Received: by mail-ua0-f196.google.com with SMTP id y8-v6so10265347ual.5
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 01:36:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180514231015.udautml7oyffda6o@merlins.org>
References: <20180514231015.udautml7oyffda6o@merlins.org>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 15 May 2018 09:36:11 +0100
Message-ID: <CAL3q7H6zkrwWWe_SuZZJFLWTvdL0W1quxVyiJMC4oCT74NKCFw@mail.gmail.com>
Subject: Re: 4.15.6 crash: BUG at fs/btrfs/ctree.c:1862
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 15, 2018 at 12:10 AM, Marc MERLIN <marc@merlins.org> wrote:
> static noinline struct extent_buffer *
> read_node_slot(struct btrfs_fs_info *fs_info, struct extent_buffer *parent,
>                int slot)
> {
>         int level = btrfs_header_level(parent);
>         struct extent_buffer *eb;
>
>         if (slot < 0 || slot >= btrfs_header_nritems(parent))
>                 return ERR_PTR(-ENOENT);
>
>         BUG_ON(level == 0);
>
>
>
> BTRFS info (device dm-2): relocating block group 13404622290944 flags data
> BTRFS info (device dm-2): found 9959 extents
> BTRFS info (device dm-2): found 9959 extents
> BTRFS info (device dm-2): relocating block group 13403548549120 flags data
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/ctree.c:1862!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI
> CPU: 5 PID: 8103 Comm: btrfs Tainted: G     U           4.15.6-amd64-preempt-sysrq-20171018 #3
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> RIP: 0010:read_node_slot+0x3c/0x9e
> RSP: 0018:ffffbecfaa0b7b58 EFLAGS: 00210246
> RAX: 00000000000000a0 RBX: 000000000000000c RCX: 0000000000000003
> RDX: 000000000000000c RSI: ffff9a60e9d9de78 RDI: 000000052f6e0000
> RBP: ffff9a60e9d9de78 R08: 0000000000000001 R09: ffffbecfaa0b7bf6
> R10: ffff9a64988bd7e9 R11: ffff9a64988bd7c8 R12: ffffe003d4bdb800
> R13: ffff9a64a4810000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007fba34c9c8c0(0000) GS:ffff9a64de340000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000005a8b9c9a CR3: 00000001446c6004 CR4: 00000000001606e0
> Call Trace:
>  tree_advance+0xb1/0x11e
>  btrfs_compare_trees+0x1c2/0x4d6
>  ? process_extent+0xdcf/0xdcf
>  btrfs_ioctl_send+0x81e/0xc70
>  ? __kmalloc_track_caller+0xfb/0x10f
>  _btrfs_ioctl_send+0xbc/0xe6
>  ? paravirt_sched_clock+0x5/0x8
>  ? set_task_rq+0x2f/0x80
>  ? task_rq_unlock+0x22/0x36
>  btrfs_ioctl+0x162f/0x1dc8
>  ? select_task_rq_fair+0xb65/0xb7a
>  ? update_load_avg+0x16d/0x442
>  ? list_add+0x15/0x2e
>  ? cfs_rq_throttled.isra.30+0x9/0x18
>  ? vfs_ioctl+0x1b/0x28
>  vfs_ioctl+0x1b/0x28
>  do_vfs_ioctl+0x4f4/0x53f
>  ? __audit_syscall_entry+0xbf/0xe3
>  SyS_ioctl+0x52/0x76
>  do_syscall_64+0x72/0x81
>  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> RIP: 0033:0x7fba34d835e7
> RSP: 002b:00007ffc32cf4cb8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000000523f RCX: 00007fba34d835e7
> RDX: 00007ffc32cf4d40 RSI: 0000000040489426 RDI: 0000000000000004
> RBP: 0000000000000004 R08: 0000000000000000 R09: 00007fba34c9b700
> R10: 00007fba34c9b9d0 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000563a30b87020 R14: 0000000000000001 R15: 0000000000000001
> Code: f5 53 4c 8b a6 98 00 00 00 89 d3 4c 89 e7 e8 67 fd ff ff 85 db 78 63 4c 89 e7 41 88 c6 e8 92 fb ff ff 39 d8 76 54 45 84 f6 75 02 <0f> 0b 89 de 48 89 ef e8 2e ff ff ff 89 de 49 89 c4 48 89 ef e8
> RIP: read_node_slot+0x3c/0x9e RSP: ffffbecfaa0b7b58
> ---[ end trace a24e7de6b77b5cb1 ]---
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: 0x19000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

We got a fix for this recently:  https://patchwork.kernel.org/patch/10396523/


>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
