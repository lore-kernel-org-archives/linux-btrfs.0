Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:44519 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbeBBCGW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 21:06:22 -0500
Received: by mail-ot0-f194.google.com with SMTP id l5so12765276otj.11
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 18:06:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANznX5GQEx5h3A=WKuFnoJFPt7+5iYO526TVWr-vOfEK2ASDGA@mail.gmail.com>
References: <CANznX5Eza4E--py7nzj+-vZB_-_Stj-_4LP=Fb2hbTkQQ7LGsA@mail.gmail.com>
 <CANznX5GQEx5h3A=WKuFnoJFPt7+5iYO526TVWr-vOfEK2ASDGA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Feb 2018 19:06:21 -0700
Message-ID: <CAJCQCtTCr+XXV9bxGM0FpQDN4SroaZV6rN8+98JQsNkvCi8yEw@mail.gmail.com>
Subject: Re: Writeback errors in kernel log with Linux 4.15 (m=s=raid1,
 d=raid5, 5 disks)
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 1, 2018 at 6:37 PM, Janos Toth F. <toth.f.janos@gmail.com> wrote:
> Hmm... Actually, I just discovered a different machine with s=m=d=dup
> (single HDD) spit out a few similar messages (a lot less and it took
> longer for them to appear at all but it handles very little load):
>
> [  333.197366] WARNING: CPU: 0 PID: 134 at fs/fs-writeback.c:2339
> __writeback_in
>
>                              odes_sb_nr+0xc6/0xd0
> [  333.197371] CPU: 0 PID: 134 Comm: btrfs-transacti Not tainted
> 4.15.0-gentoo #
>
>                               2
> [  333.197372] Hardware name: Dell Inc. Vostro 1700
>  /      ,
>
>                          BIOS A07 04/21/2008
> [  333.197373] RIP: 0010:__writeback_inodes_sb_nr+0xc6/0xd0
> [  333.197376] RSP: 0018:ffff96eb80777e00 EFLAGS: 00010246
> [  333.197378] RAX: 0000000000000000 RBX: ffff88d19a5dd000 RCX: 0000000000000000
> [  333.197379] RDX: 0000000000000002 RSI: 0000000000001100 RDI: ffff88d19a4cb000
> [  333.197380] RBP: ffff96eb80777e04 R08: fffffffffffffffe R09: 0000000000000003
> [  333.197383] R10: ffff96eb80777d10 R11: 0000000000000400 R12: ffff88d19a0bc600
> [  333.197384] R13: ffff88d19a96a5b8 R14: 0000000000014c0a R15: ffff88d19a96a5e0
> [  333.197385] FS:  0000000000000000(0000) GS:ffff88d19fc00000(0000)
> knlGS:00000
>
>                           00000000000
> [  333.197387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  333.197389] CR2: 00007fd058028000 CR3: 00000000c6a0a000 CR4: 00000000000006f0
> [  333.197390] Call Trace:
> [  333.197397]  btrfs_commit_transaction+0x776/0x860
> [  333.197399]  ? start_transaction+0x99/0x380
> [  333.197403]  transaction_kthread+0x176/0x1a0
> [  333.197404]  ? btrfs_cleanup_transaction+0x490/0x490
> [  333.197407]  kthread+0x109/0x120
> [  333.197411]  ? __kthread_bind_mask+0x60/0x60
> [  333.197413]  ret_from_fork+0x35/0x40
> [  333.197417] Code: 8d 74 24 08 e8 ec fd ff ff 48 89 ee 48 89 df e8
> d1 fe ff ff
>
>                            48 8b 44 24 48 65 48 33 04 25 28 00 00 00
> 75 0b 48 83 c4 50 5b 5d c3 <0f> ff eb
>
>                                                      c0 e8 c1 af ef ff
> 90 48 85 ff 53 48 c7 c3 60 5b 83 89
> [  333.197459] ---[ end trace 4427bc8429f8bec7 ]---


No balance or block group relocation is mentioned in this. There are
changes between 4.14 and 4.15 in fs/fs-writeback.c

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/fs/fs-writeback.c?id=v4.15&id2=v4.14



-- 
Chris Murphy
