Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:56568 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059AbaCUCNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 22:13:52 -0400
Received: by mail-ve0-f172.google.com with SMTP id jx11so1923631veb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 19:13:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3aea$2e15c040$920db11$3a1e73c1@cox.net>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
	<53207C4B.6020000@fb.com>
	<CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
	<CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
	<pan$3aea$2e15c040$920db11$3a1e73c1@cox.net>
Date: Thu, 20 Mar 2014 22:13:51 -0400
Message-ID: <CAGfcS_mZ9=gmdxyn0jj_xKFK7XiejCACe84knzoJfC9gkg7CNw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 15, 2014 at 7:51 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 1) Does running the snapper cleanup command from that cron job manually
> trigger the problem as well?

As you can imagine I'm not too keen to trigger this often.  But yes, I
just gave it a shot on my SSD and cleaning a few days of timelines
triggered a panic.

> 2) What about modifying the cron job to run hourly, or perhaps every six
> hours, so it's deleting only 2 or 12 instead of 48 at a time?  Does that
> help?
>
> If so then it's a thundering herd problem.  While definitely still a bug,
> you'll at least have a workaround until its fixed.

Definitely looks like a thundering herd problem.

I stopped the cron jobs (including the creation of snapshots based on
your later warning).  However, I am my snapshots one at a time at a
rate of one every 5-30 minutes, and while that is creating
surprisingly high disk loads on my ssd and hard drives, I don't get
any panics.  I figured that having only one deletion pending per
checkpoint would eliminate locking risk.

I did get some blocked task messages in dmesg, like:
[105538.121239] INFO: task mysqld:3006 blocked for more than 120 seconds.
[105538.121251]       Not tainted 3.13.6-gentoo #1
[105538.121256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[105538.121262] mysqld          D ffff880395f63e80  3432  3006      1 0x00000000
[105538.121273]  ffff88028b623d38 0000000000000086 ffff88028b623dc8
ffffffff81c10440
[105538.121283]  0000000000000200 ffff88028b623fd8 ffff880395f63b80
0000000000012c40
[105538.121291]  0000000000012c40 ffff880395f63b80 00000000532b7877
ffff880410e7e578
[105538.121299] Call Trace:
[105538.121316]  [<ffffffff81623d73>] schedule+0x6a/0x6c
[105538.121327]  [<ffffffff81623f52>] schedule_preempt_disabled+0x9/0xb
[105538.121337]  [<ffffffff816251af>] __mutex_lock_slowpath+0x155/0x1af
[105538.121347]  [<ffffffff812b9db0>] ? radix_tree_tag_set+0x71/0xd4
[105538.121356]  [<ffffffff81625225>] mutex_lock+0x1c/0x2e
[105538.121365]  [<ffffffff8123c168>] btrfs_log_inode_parent+0x161/0x308
[105538.121373]  [<ffffffff8162466d>] ? mutex_unlock+0x11/0x13
[105538.121382]  [<ffffffff8123cd37>] btrfs_log_dentry_safe+0x39/0x52
[105538.121390]  [<ffffffff8121a0c9>] btrfs_sync_file+0x1bc/0x280
[105538.121401]  [<ffffffff811339a3>] vfs_fsync_range+0x13/0x1d
[105538.121409]  [<ffffffff811339c4>] vfs_fsync+0x17/0x19
[105538.121416]  [<ffffffff81133c3c>] do_fsync+0x30/0x55
[105538.121423]  [<ffffffff81133e40>] SyS_fsync+0xb/0xf
[105538.121432]  [<ffffffff8162c2e2>] system_call_fastpath+0x16/0x1b

I suspect that this may not be terribly helpful - it probably reflects
tasks waiting for a lock rather than whatever is holding it.  It was
more of a problem when I was trying to delete a snapshot per minute on
my ssd, or one every 5 min on hdd.

Rich
