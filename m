Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53371 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbcDHTKF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Apr 2016 15:10:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aobn9-0000bN-EX
	for linux-btrfs@vger.kernel.org; Fri, 08 Apr 2016 21:10:03 +0200
Received: from google-proxy-66-249-84-141.google.com ([66.249.84.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 21:10:03 +0200
Received: from johnathan.falk by google-proxy-66-249-84-141.google.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 21:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: Johnathan Falk <johnathan.falk@gmail.com>
Subject: Re: Volume stuck after Checking UUID tree
Date: Fri, 8 Apr 2016 19:09:04 +0000 (UTC)
Message-ID: <loom.20160408T210552-501@post.gmane.org>
References: <CADNp-0Ta+jNZGtjT0NKc-ZXaYChh=sUOyCy1asn0=ZYBSWaU7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

johnathan falk <johnathan.falk <at> gmail.com> writes:

> 
> The drive mounts perfectly fine when you mount RO, but when you mount
> it rw it gives this (and eventually locks up the system as I can't
> restart it cleanly):
> 
> kernel: BTRFS info (device sdb1): disk space caching is enabled
> Apr 06 17:09:16 kernel: BTRFS error (device sdb1): qgroup generation
> mismatch, marked as inconsistent
> Apr 06 17:09:17 kernel: BTRFS: checking UUID tree
> Apr 06 17:12:30 kernel: INFO: task btrfs-transacti:5701 blocked for
> more than 120 seconds.
> 
> Bug reported on launch pad:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1555828
> 
> When I mount the disk in journalctl -f:
> http://pastebin.com/1p6XppRb
> 
> Went through Marc Merlin's suggestions to fix my drive and the btrfsck
> -S1/2/3 never finishes and gets stuck on checking quota groups. I also
> created a btrfs-image first thing.
> 
> Any suggestions would be welcome as I don't know what to do.
> 

Paste of journalctl:
kernel: Call Trace:
Apr 02 18:55:03 theark kernel:  
[<ffffffff81835e45>] schedule+0x35/0x80
Apr 02 18:55:03 theark kernel:  
[<ffffffffc03a5cd2>] 
btrfs_commit_transaction+0x382/0xa90 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffff810c6320>] 
? wake_atomic_t_function+0x60/0x60
Apr 02 18:55:03 theark kernel:  
[<ffffffffc03a0c99>] transaction_kthread+0x229/0x240 
[btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffffc03a0a70>] ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffff810a2df8>] kthread+0xd8/0xf0
Apr 02 18:55:03 theark kernel: 
 [<ffffffff8183a122>] ret_from_fork+0x22/0x40
Apr 02 18:55:03 theark kernel:  [<ffffffff810a2d20>] ? 
kthread_create_on_node+0x1a0/0x1a0
Apr 02 18:55:03 theark kernel: INFO: task umount:4672 blocked for more than 120 
seconds.
Apr 02 18:55:03 theark kernel:       
Not tainted 4.6.0-040600rc1-generic #201603261930
Apr 02 18:55:03 theark kernel: 
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
Apr 02 18:55:03 theark kernel: 
umount          D ffff88008e323cd8     0  4672   3434 
0x00000000
Apr 02 18:55:03 theark kernel:  
ffff88008e323cd8 0000000000000000 ffffffff81e0d540 
ffff880343711c80
Apr 02 18:55:03 theark kernel:  
ffff88008e324000 ffff88040b4579f0 ffff88040b457800 
ffff88040b4579f0
Apr 02 18:55:03 theark kernel:  
0000000000000000 ffff88008e323cf0 ffffffff81835e45 
ffff8800bbd561b0
Apr 02 18:55:03 theark kernel: Call Trace:
Apr 02 18:55:03 theark kernel:  
[<ffffffff81835e45>] schedule+0x35/0x80
Apr 02 18:55:03 theark kernel:  
[<ffffffffc03a4d73>] 
wait_current_trans.isra.22+0xd3/0x120 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffff810c6320>] ? wake_atomic_t_function+0x60/0x60
Apr 02 18:55:03 theark kernel:  
[<ffffffffc03a665b>] start_transaction+0x27b/0x4c0 
[btrfs]
Apr 02 18:55:03 theark kernel:  [<ffffffffc03a697d>] 
btrfs_attach_transaction_barrier+0x1d/0x50 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffffc036fb52>] btrfs_sync_fs+0x42/0x110 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffff81253621>] sync_filesystem+0x71/0xa0
Apr 02 18:55:03 theark kernel:  
[<ffffffff81221ac7>] generic_shutdown_super+0x27/0x100
Apr 02 18:55:03 theark kernel:  
[<ffffffff81221e22>] kill_anon_super+0x12/0x20
Apr 02 18:55:03 theark kernel:  
[<ffffffffc0370da8>] btrfs_kill_super+0x18/0x110 [btrfs]
Apr 02 18:55:03 theark kernel:  
[<ffffffff81221fc3>] deactivate_locked_super+0x43/0x70
Apr 02 18:55:03 theark kernel:  
[<ffffffff8122249c>] deactivate_super+0x5c/0x60
Apr 02 18:55:03 theark kernel:  
[<ffffffff8124020f>] cleanup_mnt+0x3f/0x90
Apr 02 18:55:03 theark kernel:  
[<ffffffff812402a2>] __cleanup_mnt+0x12/0x20
Apr 02 18:55:03 theark kernel:  
[<ffffffff810a1253>] task_work_run+0x73/0x90
Apr 02 18:55:03 theark kernel:  
[<ffffffff81003242>] exit_to_usermode_loop+0xc2/0xd0
Apr 02 18:55:03 theark kernel:  
[<ffffffff81003c6e>] syscall_return_slowpath+0x4e/0x60
Apr 02 18:55:03 theark kernel:  [<ffffffff81839f7e>] 
entry_SYSCALL_64_fastpath+0xa6/0xa8


Currently a btrfsck using btrfs-progs 4.5.1 has run for 
3 days now and is currently using:
pri ni virt res shr s cpu% mem% time
20 0 22.1G 14.36G 188 D 1.9 95.5 47:16.21 btrfs check -s 2 /dev/sdb


