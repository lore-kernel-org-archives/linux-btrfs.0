Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:41160 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbeHLGzA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 02:55:00 -0400
Received: by mail-oi0-f65.google.com with SMTP id k12-v6so22113303oiw.8
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Aug 2018 21:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com> <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com> <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
 <6c29c33b-68f4-91d1-493e-5751000dec24@gmx.com> <CAPL5yKe4if48zANCpSXi+G_q6cHevTEu+LJ2whqc1dQYapq1bA@mail.gmail.com>
 <CAPL5yKcWZ9qOt7ymw2tCM4gqZ3wiwgRLer+r1x=+kYgDJnqjcQ@mail.gmail.com>
 <0ad384b6-58ef-f2e9-76e3-f706cd38bd42@gmx.com> <250c5cd0-03fe-f5c6-93d6-75c60431f673@gmx.com>
In-Reply-To: <250c5cd0-03fe-f5c6-93d6-75c60431f673@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Sun, 12 Aug 2018 00:18:16 -0400
Message-ID: <CAPL5yKd3CdY2KXgUKGTE-c=rQoiEv-p_yVofnX-O6Ct5p1XKiQ@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 11, 2018 at 9:36 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> > I'll add a new rescue subcommand, 'btrfs rescue disable-quota' for you
> > to disable quota offline.
>
> Patch set (from my work mailbox), titled "[PATCH] btrfs-progs: rescue:
> Add ability to disable quota offline".
> Can also be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/quota_disable
>
> Usage is:
> # btrfs rescue disable-quota <device>
>
> Tested locally, it would just toggle the ON/OFF flag for quota, so the
> modification should be minimal.

Noticed one thing while testing this, but it's not related to the
patch so I'll keep it here.
I still had the ,ro mounts in fstab, and while it mounted ro quickly
*unmounting* the filesystem, even readonly,
got hung up:

Aug 11 23:47:27 fileserver kernel: [  484.314725] INFO: task
umount:5422 blocked for more than 120 seconds.
Aug 11 23:47:27 fileserver kernel: [  484.314787]       Not tainted
4.17.14-dirty #3
Aug 11 23:47:27 fileserver kernel: [  484.314892] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 11 23:47:27 fileserver kernel: [  484.315006] umount          D
0  5422   4656 0x00000080
Aug 11 23:47:27 fileserver kernel: [  484.315122] Call Trace:
Aug 11 23:47:27 fileserver kernel: [  484.315176]  ? __schedule+0x2c0/0x820
Aug 11 23:47:27 fileserver kernel: [  484.315270]  ?
kmem_cache_alloc+0x167/0x1b0
Aug 11 23:47:27 fileserver kernel: [  484.315358]  schedule+0x3c/0x90
Aug 11 23:47:27 fileserver kernel: [  484.315493]  schedule_timeout+0x1e4/0x430
Aug 11 23:47:27 fileserver kernel: [  484.315542]  ?
kmem_cache_alloc+0x167/0x1b0
Aug 11 23:47:27 fileserver kernel: [  484.315686]  wait_for_common+0xb1/0x170
Aug 11 23:47:27 fileserver kernel: [  484.315798]  ? wake_up_q+0x70/0x70
Aug 11 23:47:27 fileserver kernel: [  484.315911]
btrfs_qgroup_wait_for_completion+0x5f/0x80
Aug 11 23:47:27 fileserver kernel: [  484.316031]  close_ctree+0x27/0x2d0
Aug 11 23:47:27 fileserver kernel: [  484.316138]
generic_shutdown_super+0x69/0x110
Aug 11 23:47:27 fileserver kernel: [  484.316252]  kill_anon_super+0xe/0x20
Aug 11 23:47:27 fileserver kernel: [  484.316301]  btrfs_kill_super+0x13/0x100
Aug 11 23:47:27 fileserver kernel: [  484.316349]
deactivate_locked_super+0x39/0x70
Aug 11 23:47:27 fileserver kernel: [  484.316399]  cleanup_mnt+0x3b/0x70
Aug 11 23:47:27 fileserver kernel: [  484.316459]  task_work_run+0x89/0xb0
Aug 11 23:47:27 fileserver kernel: [  484.316519]
exit_to_usermode_loop+0x8c/0x90
Aug 11 23:47:27 fileserver kernel: [  484.316579]  do_syscall_64+0xf1/0x110
Aug 11 23:47:27 fileserver kernel: [  484.316639]
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Is it trying to write changes to a ro mount, or is it doing a bunch of
work that it's just going to throw away?  I ended up using sysrq-b
after commenting out the entries in fstab.

Everything seems fine with the filesystem now.  I appreciate all the help!
