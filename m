Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:60645 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965467AbaFSXWD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 19:22:03 -0400
Received: from g6t1526.atlanta.hp.com (g6t1526.atlanta.hp.com [15.193.200.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id D908960CA1
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 23:22:01 +0000 (UTC)
Message-ID: <53A3708E.9060203@hp.com>
Date: Thu, 19 Jun 2014 19:21:50 -0400
From: Waiman Long <waiman.long@hp.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, t-itoh@jp.fujitsu.com
Subject: Re: Lockups with btrfs on 3.16-rc1 - bisected
References: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>	<53A20FFF.3010807@hp.com>	<53A2125B.3050701@fb.com>	<53A21702.8090109@hp.com>	<53A21C78.1040809@fb.com>	<53A21E84.2050103@hp.com>	<53A22064.7080400@fb.com>	<53A2212E.7090907@hp.com>	<53A2268F.3080807@fb.com>	<CAB9dFds5J8Ti3CgtxHrgqM3j1TiwqYCnhP+A3Nb0q-FNgmQbXA@mail.gmail.com>	<53A22A01.7080505@hp.com>	<CAB9dFdvD9QMZ_rONhhP5ZD2E7+A7qxnsY978Snc3zHEbdPRszw@mail.gmail.com> <CAB9dFdtTFN+uQ8=WXVa0Y5GbBSYM5iVLgTaEeh_FqHt=XFKNvQ@mail.gmail.com> <53A246C6.5050408@fb.com> <53A2573B.1060901@hp.com> <53A31514.8030308@fb.com> <53A32353.5000104@hp.com> <53A343B9.3000900@fb.com> <53A35B31.4060203@fb.com>
In-Reply-To: <53A35B31.4060203@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 05:50 PM, Chris Mason wrote:
>>>
>>> I would like to take back my comments. I took out the read_lock, but the
>>> process still hang while doing file activities on btrfs filesystem. So
>>> the problem is trickier than I thought. Below are the stack backtraces
>>> of some of the relevant processes.
>>>
>> You weren't wrong, but it was also the tree trylock code.  Our trylocks
>> only back off if the blocking lock is held.  btrfs_next_leaf needs it to
>> be a true trylock.  The confusing part is this hasn't really changed,
>> but one of the callers must be a spinner where we used to have a blocker.
> This is what I have queued up, it's working here.
>
> -chris
>
> commit ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
> Author: Chris Mason<clm@fb.com>
> Date:   Thu Jun 19 14:16:52 2014 -0700
>
>      Btrfs: fix deadlocks with trylock on tree nodes
>
>      The Btrfs tree trylock function is poorly named.  It always takes
>      the spinlock and backs off if the blocking lock is held.  This
>      can lead to surprising lockups because people expect it to really be a
>      trylock.
>
>      This commit makes it a pure trylock, both for the spinlock and the
>      blocking lock.  It also reworks the nested lock handling slightly to
>      avoid taking the read lock while a spinning write lock might be held.
>
>      Signed-off-by: Chris Mason<clm@fb.com>

I didn't realize that those non-blocking lock functions are really 
trylocks. Yes, the patch did seem to fix the hanging problem that I saw 
when I just untar the kernel source files into a btrfs filesystem. 
However, when I tried did a kernel build on a 24-thread (-j 24) system, 
the build process hanged after a while. The following kind of stack 
trace messages were printed:

INFO: task btrfs-transacti:16576 blocked for more than 120 seconds.
       Tainted: G            E 3.16.0-rc1 #5
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 000000000000000f     0 16576      2 0x00000000
  ffff88080eabbbf8 0000000000000046 ffff880803b98350 ffff88080eab8010
  0000000000012b80 0000000000012b80 ffff880805ed8f10 ffff88080d162310
  ffff88080eabbce8 ffff8807be170880 ffff8807be170888 7fffffffffffffff
Call Trace:
  [<ffffffff81592de9>] schedule+0x29/0x70
  [<ffffffff815920bd>] schedule_timeout+0x13d/0x1d0
  [<ffffffff8106b474>] ? wake_up_worker+0x24/0x30
  [<ffffffff8106d595>] ? insert_work+0x65/0xb0
  [<ffffffff81593cc6>] wait_for_completion+0xc6/0x100
  [<ffffffff810868d0>] ? try_to_wake_up+0x220/0x220
  [<ffffffffa06bb9ba>] btrfs_wait_and_free_delalloc_work+0x1a/0x30 [btrfs]
  [<ffffffffa06d458d>] btrfs_run_ordered_operations+0x1dd/0x2c0 [btrfs]
  [<ffffffffa06b7fd5>] btrfs_flush_all_pending_stuffs+0x35/0x40 [btrfs]
  [<ffffffffa06ba099>] btrfs_commit_transaction+0x229/0xa30 [btrfs]
  [<ffffffff8105ef30>] ? lock_timer_base+0x70/0x70
  [<ffffffffa06b51db>] transaction_kthread+0x1eb/0x270 [btrfs]
  [<ffffffffa06b4ff0>] ? close_ctree+0x2d0/0x2d0 [btrfs]
  [<ffffffff8107544e>] kthread+0xce/0xf0
  [<ffffffff81075380>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff8159636c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81075380>] ? kthread_freezable_should_stop+0x70/0x70

It looks like some more work may still be needed. Or it could be a 
problem in my system configuration.

-Longman

