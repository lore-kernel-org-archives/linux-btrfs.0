Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46835 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaDGSv0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 14:51:26 -0400
Date: Mon, 7 Apr 2014 11:51:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
Message-ID: <20140407185121.GI10222@merlins.org>
References: <20140407160506.GG10789@merlins.org>
 <5342CE0C.3070707@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5342CE0C.3070707@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 07, 2014 at 12:10:52PM -0400, Josef Bacik wrote:
> On 04/07/2014 12:05 PM, Marc MERLIN wrote:
> >I was debugging my why backup failed to run, and eventually found it was
> >stuck on sync:
> >14080       18:18 btrfs_tree_read_lock           sync
> >
> >This was hung for hours on this lock.
> >
> >Strangely, it looks like taking my sysrq-w hung the machine pretty hard for
> >close to 30sec, but this seems to have unhung sync and in the end btrfs send
> >completed after that.
> >
> >Sysqrq-w is here:
> >https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/sysrq-btrfs-sync-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=IHXWC1Chbc0jEiUWu1v4Va9NOphtjPbjYp6yVMdUmXM%3D%0A&s=bd787a3422e9ff0972d2d09de7d424f56589aadc9d6db33e19fc44886dce604f
> 
> Try Chris's integration branch in a few hours and see if that fixes
> it.  Thanks,

Mmmh, so I rebooted that server with 3.14.0 (no rc), and it was
deadlocked a long time during boot (about 10mn) before it unlocked
itself and finished booting.

This is a bit vexing, I don't yet know which of my 3 btrfs filesystems
is causing this, and how to fix it.
After boot, it seems ok enough.

You're recommending that I try btrfs-next on a 3.15 pre kernel, correct?
If so would it be likely to fix my filesystem and let me go back to a
stable 3.14? (I'm a bit warry about running some unstable 3.15 on it :).

Is there a chance balance or some file system cleaning will fix this?

For now, during boot, I get:
INFO: task btrfs-transacti:3633 blocked for more than 120 seconds.
      Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff88020d762680     0  3633      2 0x00000000
 ffff88020c6c7dc0 0000000000000046 ffff88020c6c7fd8 ffff88020d762150
 00000000000141c0 ffff88020d762150 ffff88020e11be90 ffff8802106271e8
 0000000000000000 ffff880210627000 ffff8800c5c82740 ffff88020c6c7dd0
Call Trace:
 [<ffffffff8160c331>] schedule+0x73/0x75
 [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff8122b812>] start_transaction+0x202/0x4f2
 [<ffffffff8122bb9e>] btrfs_attach_transaction+0x17/0x19
 [<ffffffff812277a8>] transaction_kthread+0xd6/0x1ab
 [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:3633 blocked for more than 120 seconds.
      Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff88020d762680     0  3633      2 0x00000000
 ffff88020c6c7dc0 0000000000000046 ffff88020c6c7fd8 ffff88020d762150
 00000000000141c0 ffff88020d762150 ffff88020e11be90 ffff8802106271e8
 0000000000000000 ffff880210627000 ffff8800c5c82740 ffff88020c6c7dd0
Call Trace:
 [<ffffffff8160c331>] schedule+0x73/0x75
 [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff8122b812>] start_transaction+0x202/0x4f2
 [<ffffffff8122bb9e>] btrfs_attach_transaction+0x17/0x19
 [<ffffffff812277a8>] transaction_kthread+0xd6/0x1ab
 [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:3633 blocked for more than 120 seconds.
      Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D ffff88020d762680     0  3633      2 0x00000000
 ffff88020c6c7dc0 0000000000000046 ffff88020c6c7fd8 ffff88020d762150
 00000000000141c0 ffff88020d762150 ffff88020e11be90 ffff8802106271e8
 0000000000000000 ffff880210627000 ffff8800c5c82740 ffff88020c6c7dd0
Call Trace:
 [<ffffffff8160c331>] schedule+0x73/0x75
 [<ffffffff8122a5f9>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff8122b812>] start_transaction+0x202/0x4f2
 [<ffffffff8122bb9e>] btrfs_attach_transaction+0x17/0x19
 [<ffffffff812277a8>] transaction_kthread+0xd6/0x1ab
 [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61

Eventually the boot finishes, but it hangs way too long.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
