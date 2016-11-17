Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36681 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbcKQFjM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 00:39:12 -0500
Received: by mail-qt0-f175.google.com with SMTP id w33so122931992qtc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 21:39:11 -0800 (PST)
MIME-Version: 1.0
From: Chris Cui <chris.wei.cui@gmail.com>
Date: Thu, 17 Nov 2016 13:39:10 +0800
Message-ID: <CANx2UGGLP_jSNZ038H2Wd0bTwqSu=1VQKDaZ=sKr8ARg_Fgv4A@mail.gmail.com>
Subject: Re: btrfs btree_ctree_super fault
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have just encountered the same bug on 4.9.0-rc2.  Any solution now?

> kernel BUG at fs/btrfs/ctree.c:3172!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 0 PID: 22702 Comm: trinity-c40 Not tainted 4.9.0-rc4-think+ #1
> task: ffff8804ffde37c0 task.stack: ffffc90002188000
> RIP: 0010:[<ffffffffa00576b9>]
>   [<ffffffffa00576b9>] btrfs_set_item_key_safe+0x179/0x190 [btrfs]
> RSP: 0000:ffffc9000218b8a8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8804fddcf348 RCX: 0000000000001000
> RDX: 0000000000000000 RSI: ffffc9000218b9ce RDI: ffffc9000218b8c7
> RBP: ffffc9000218b908 R08: 0000000000004000 R09: ffffc9000218b8c8
> R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000218b8b6
> R13: ffffc9000218b9ce R14: 0000000000000001 R15: ffff880480684a88
> FS:  00007f7c7f998b40(0000) GS:ffff880507800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000044f15f000 CR4: 00000000001406f0
> DR0: 00007f4ce439d000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Stack:
>  ffff880501430000 d305ffffa00a2245 006c000000000002 0500000000000010
>  6c000000000002d3 0000000000001000 000000006427eebb ffff880480684a88
>  0000000000000000 ffff8804fddcf348 0000000000002000 0000000000000000
> Call Trace:
>  [<ffffffffa009cff0>] __btrfs_drop_extents+0xb00/0xe30 [btrfs]
