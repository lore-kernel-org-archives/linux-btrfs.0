Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36920 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbeCaWAs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 18:00:48 -0400
Received: by mail-oi0-f44.google.com with SMTP id e8-v6so10256131oii.4
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Mar 2018 15:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTTerrYvXpof+jiShO1D8PmaPaFCA9W1PyFxaGs0PZaig@mail.gmail.com>
References: <CAJCQCtTTerrYvXpof+jiShO1D8PmaPaFCA9W1PyFxaGs0PZaig@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 31 Mar 2018 16:00:47 -0600
Message-ID: <CAJCQCtQ+65fB16pmCH7wm5bNJicf0qtPwuM1asd8PYWCgvoE1g@mail.gmail.com>
Subject: Re: dead or dying SDXC card fsck's OK but mount hangs indefinitely
Cc: Btrfs BTRFS <linux-block@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 31, 2018 at 3:50 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is perhaps a novelty problem report. And it's also a throw away
> card data wise, and is a $12 Samsung EVO+ SDXC card used in an Intel
> NUC.
>
> Kernel is 4.15.14-300.fc27.x86_64
>
> It contains FAT, ext4, and Btrfs file systems. They can all be fsck'd,
> but none can be mounted. Even if it use blockdev --setro on the entire
> mmc device and then mount -o ro it still fails. Kinda weird huh?
>
> [68498.521260] mmc0: new ultra high speed SDR104 SDHC card at address 59b4
> [68498.521990] mmcblk0: mmc0:59b4 EB2MW 29.8 GiB
> [68498.530899]  mmcblk0: p1 p2 p3 p4
> [68507.152842] BTRFS info (device mmcblk0p4): using free space tree
> [68507.152919] BTRFS info (device mmcblk0p4): has skinny extents
> [68507.165855] BTRFS info (device mmcblk0p4): bdev /dev/mmcblk0p4
> errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
> [68507.192935] BTRFS info (device mmcblk0p4): enabling ssd optimizations
> [69107.488123] mmc0: Card stuck in programming state! mmcblk0 card_busy_detect
> [69107.539128] mmc0: Tuning timeout, falling back to fixed sampling clock
>
>
> The corrupt 10 was fixed with a scrub months ago, and I never reset
> the counter so that's not a current corruption. The most recent scrub
> was maybe a week ago. And even offline scrub works. So literally every
> single block related to this Btrfs file system is readable, and yet
> it's not mountable? Very weird.
>
> Anyway, that's it. No further errors. No timeouts. User space is hung
> on the mount command. mccqd/0 is using 7% CPU, the stack for that
> process is:
>
> [root@f27s ~]# cat /proc/2865/stack
> [<0>] mmc_wait_for_req_done+0x7b/0x130 [mmc_core]
> [<0>] mmc_wait_for_cmd+0x66/0x90 [mmc_core]
> [<0>] __mmc_send_status+0x70/0xa0 [mmc_core]
> [<0>] card_busy_detect+0x59/0x160 [mmc_block]
> [<0>] mmc_blk_err_check+0x170/0x640 [mmc_block]
> [<0>] mmc_start_areq+0xc6/0x3c0 [mmc_core]
> [<0>] mmc_blk_issue_rw_rq+0xcf/0x3b0 [mmc_block]
> [<0>] mmc_blk_issue_rq+0x298/0x7c0 [mmc_block]
> [<0>] mmc_queue_thread+0xce/0x160 [mmc_block]
> [<0>] kthread+0x113/0x130
> [<0>] ret_from_fork+0x35/0x40
> [<0>] 0xffffffffffffffff
> [root@f27s ~]#
>
> Basically the card is in some sort of state that the kernel code is
> not going to ever second guess. So there's no further error or reset
> attempt.
>
> # cat /sys/block/mmcblk0/queue/scheduler
> noop [deadline] cfq
>
>
> This part of the stack trace is interesting:
>
> mmc_blk_issue_rw_rq
>
> Something wants to write something, even though I'm using mount -o ro,
> and also blockdev --setro should prevent any writes from being
> attempted? Almost sounds like user error...

OK starting over:

[root@f27s ~]# blockdev --setro /dev/mmcblk0
[root@f27s ~]# blockdev --report /dev/mmcblk0
RO    RA   SSZ   BSZ   StartSec            Size   Device
ro   256   512  4096          0     32026656768   /dev/mmcblk0
[root@f27s ~]# mount -o ro,nologreplay /dev/mmcblk0p4 /mnt/sd

This works. It was doing log replay and expected to write something,
even ro, I guess. I expect log replay when mounting ro, but I'm not
expecting it to also write something but I guess it's not an in-memory
only kind of log replay.




-- 
Chris Murphy
