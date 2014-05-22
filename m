Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52087 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaEVNP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 09:15:29 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WnSqH-0007UB-7d
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 06:15:29 -0700
Date: Thu, 22 May 2014 06:15:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.15.0-rc5: btrfs and sync deadlock: call_rwsem_down_read_failed / balance seems to create locks that block everything else
Message-ID: <20140522131528.GB22952@merlins.org>
References: <20140522090921.GA12037@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140522090921.GA12037@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 22, 2014 at 02:09:21AM -0700, Marc MERLIN wrote:
> I got m laptop to hang all IO to one of its devices again, this time
> drive #2.
> This is the 3rd time it happens, and I've already lost data as a result
> since things that haven't hit disk, don't make it at this point.
> 
> I was doing balance and btrfs send/receive.
> Then cron started a scrub in the background too.
> 
> IO to drive #1 was working fine, I didn't even notice that drive #2 IO
> was hung.
> 
> And then I typed sync and it never returned.
> 
> legolas:~# ps -eo pid,user,args,wchan  | grep  sync
> 23605 root     sync                        call_rwsem_down_read_failed
> 31885 root     sync                        call_rwsem_down_read_failed
> 
> What does this mean when sync is stuck that way?
> 
> When I'm in that state, accessing btrfs on drive 1 still works (read and
> write).
> Any access on drive 2 through btrfs hangs

After reboot, I got hangs on drive 2 quickly:
[ 1559.667362] INFO: task btrfs-balance:3280 blocked for more than 120 seconds.
[ 1559.667374]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s2 #1
[ 1559.667379] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.667383] btrfs-balance   D 0000000000000001     0  3280      2 0x00000000
[ 1559.667395]  ffff880408531c20 0000000000000046 000000000003da54 ffff880408531fd8
[ 1559.667405]  ffff880408fe8110 00000000000141c0 ffff8800ca1cc5e0 ffff8800ca1cc5e4
[ 1559.667414]  ffff880408fe8110 ffff8800ca1cc5e8 00000000ffffffff ffff880408531c30
[ 1559.667423] Call Trace:
[ 1559.667442]  [<ffffffff8161c896>] schedule+0x73/0x75
[ 1559.667451]  [<ffffffff8161cb57>] schedule_preempt_disabled+0x18/0x24
[ 1559.667459]  [<ffffffff8161dc7a>] __mutex_lock_slowpath+0x160/0x1d7
[ 1559.667466]  [<ffffffff8161dd08>] mutex_lock+0x17/0x27
[ 1559.667475]  [<ffffffff8126adb7>] btrfs_relocate_block_group+0x153/0x26d
[ 1559.667486]  [<ffffffff81249838>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[ 1559.667494]  [<ffffffff8161efbb>] ? _raw_spin_unlock+0x17/0x2a
[ 1559.667502]  [<ffffffff81245584>] ? free_extent_buffer+0x8a/0x8d
[ 1559.667510]  [<ffffffff8124c0be>] btrfs_balance+0x9b6/0xb74
[ 1559.667517]  [<ffffffff81615c3d>] ? printk+0x54/0x56
[ 1559.667526]  [<ffffffff8124c27c>] ? btrfs_balance+0xb74/0xb74
[ 1559.667534]  [<ffffffff8124c2d5>] balance_kthread+0x59/0x7b
[ 1559.667542]  [<ffffffff8106b467>] kthread+0xae/0xb6
[ 1559.667549]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[ 1559.667557]  [<ffffffff81625b3c>] ret_from_fork+0x7c/0xb0
[ 1559.667563]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[ 1679.595668] INFO: task btrfs-balance:3280 blocked for more than 120 seconds.
[ 1679.595680]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s2 #1
[ 1679.595685] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Balance cancel hangs too and so does sync again:
legolas:~# ps -eo pid,user,args,wchan  | grep  btrfs
  527 root     [btrfs-worker]              rescuer_thread
  528 root     [btrfs-worker-hi]           rescuer_thread
  529 root     [btrfs-delalloc]            rescuer_thread
  530 root     [btrfs-flush_del]           rescuer_thread
  531 root     [btrfs-cache]               rescuer_thread
  532 root     [btrfs-submit]              rescuer_thread
  533 root     [btrfs-fixup]               rescuer_thread
  534 root     [btrfs-endio]               rescuer_thread
  535 root     [btrfs-endio-met]           rescuer_thread
  536 root     [btrfs-endio-met]           rescuer_thread
  537 root     [btrfs-endio-rai]           rescuer_thread
  538 root     [btrfs-rmw]                 rescuer_thread
  539 root     [btrfs-endio-wri]           rescuer_thread
  540 root     [btrfs-freespace]           rescuer_thread
  541 root     [btrfs-delayed-m]           rescuer_thread
  542 root     [btrfs-readahead]           rescuer_thread
  543 root     [btrfs-qgroup-re]           rescuer_thread
  544 root     [btrfs-cleaner]             cleaner_kthread
  545 root     [btrfs-transacti]           transaction_kthread
 2267 root     [btrfs-worker]              rescuer_thread
 2268 root     [btrfs-worker-hi]           rescuer_thread
 2269 root     [btrfs-delalloc]            rescuer_thread
 2271 root     [btrfs-flush_del]           rescuer_thread
 2272 root     [btrfs-cache]               rescuer_thread
 2275 root     [btrfs-submit]              rescuer_thread
 2276 root     [btrfs-fixup]               rescuer_thread
 2277 root     [btrfs-endio]               rescuer_thread
 2278 root     [btrfs-endio-met]           rescuer_thread
 2279 root     [btrfs-endio-met]           rescuer_thread
 2281 root     [btrfs-endio-rai]           rescuer_thread
 2282 root     [btrfs-rmw]                 rescuer_thread
 2283 root     [btrfs-endio-wri]           rescuer_thread
 2284 root     [btrfs-freespace]           rescuer_thread
 2285 root     [btrfs-delayed-m]           rescuer_thread
 2286 root     [btrfs-readahead]           rescuer_thread
 2288 root     [btrfs-qgroup-re]           rescuer_thread
 3278 root     [btrfs-cleaner]             sleep_on_page
 3279 root     [btrfs-transacti]           sleep_on_page
 3280 root     [btrfs-balance]             btrfs_relocate_block_group
14727 root     [kworker/u16:47]            btrfs_tree_lock
14770 root     [kworker/u16:90]            btrfs_tree_lock
22551 root     btrfs send var_ro.20140522_ pipe_wait
22552 root     btrfs receive /mnt/btrfs_po balance_dirty_pages_ratelimited
22593 root     [kworker/u16:3]             btrfs_tree_lock
25054 root     btrfs balance cancel .      btrfs_cancel_balance

I was able to stop my btrfs send/receive, in turn this unlocked sync which
succeeded too (2mn later).
btrfs balance cancel did not return, but maybe that's normal. 
I see:
legolas:~# btrfs balance status /mnt/btrfs_pool2/
Balance on '/mnt/btrfs_pool2/' is running, cancel requested
383 out of about 388 chunks balanced (457 considered),   1% left

It's been running for at least 15mn in 'cancel mode'. Is that normal?

The system doesn't seem hung, but it seems that running anything else while
balance is running creates an avalanche of locks that kills everything.

Is that a known performance problem?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
