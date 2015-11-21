Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:46918 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761215AbbKUAhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 19:37:45 -0500
Received: from [192.168.1.5] (unknown [119.224.19.150])
	by pim.lukas-pirl.de (Postfix) with ESMTPSA id C0EFD1FD931E
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2015 00:37:41 +0000 (UTC)
Subject: Re: 4.2.6: livelock in recovery (free_reloc_roots)?
To: linux-btrfs@vger.kernel.org
References: <564EE213.3060007@lukas-pirl.de>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <564FBCD1.1020009@lukas-pirl.de>
Date: Sat, 21 Nov 2015 13:37:37 +1300
MIME-Version: 1.0
In-Reply-To: <564EE213.3060007@lukas-pirl.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A follow-up question:

Can "btrfs_recover_relocation" prevented from being run? I would not
mind losing a few recent writes (what was a balance) but instead going
rw again, so I can restart a balance.

>From what I have read, btrfs-zero-log would not help in this case (?) so
I did not run it so far.

By the way, I can confirm the defect of 'btrfs device remove missing …"
mentioned here: http://www.spinics.net/lists/linux-btrfs/msg48383.html :

$ btrfs device delete missing /mnt/data
ERROR: missing is not a block device
$ btrfs device delete 5 /mnt/data
ERROR: 5 is not a block device

Thanks and best regards,

Lukas
On 11/20/2015 10:04 PM, Lukas Pirl wrote as excerpted:
> Dear list,
> 
> I am (still) trying to recover a RAID1 that can only be mounted
> recovery,degraded,ro.
> 
> I experienced an issue that might be interesting for you: I tried to
> mount the file system rw,recovery and the kernel ended up burning one
> core (and only one specific core, never scheduled to another one).
> 
> The watchdog printed a stack trace roughly every 20 seconds. There were
> only a few stack traces that were printed alternating (see below).
> After a few hours with the mount command still being blocked and without
> visible IO activity, the system was power-cycled.
> 
> Summary:
> 
> Call Trace:
>  [<ffffffffa0309641>] ? free_reloc_roots+0x11/0x30 [btrfs]
>  [<ffffffffa030964d>] ? free_reloc_roots+0x1d/0x30 [btrfs]
>  [<ffffffffa030f6e5>] ? merge_reloc_roots+0x165/0x220 [btrfs]
>  [<ffffffffa0310343>] ? btrfs_recover_relocation+0x293/0x380 [btrfs]
>  [<ffffffffa02bcaa2>] ? open_ctree+0x20d2/0x23b0 [btrfs]
>  [<ffffffffa02933fb>] ? btrfs_mount+0x87b/0x990 [btrfs]
>  [<ffffffff8117417f>] ? pcpu_next_unpop+0x3f/0x50
>  [<ffffffff811c3646>] ? mount_fs+0x36/0x170
>  [<ffffffff811ddf08>] ? vfs_kern_mount+0x68/0x110
>  [<ffffffffa0292d3b>] ? btrfs_mount+0x1bb/0x990 [btrfs]
>  …
> 
> Call Trace:
>  <IRQ>  [<ffffffff810c8240>] ? rcu_dump_cpu_stacks+0x80/0xb0
>  [<ffffffff810cb381>] ? rcu_check_callbacks+0x421/0x6e0
>  [<ffffffff8101cb95>] ? sched_clock+0x5/0x10
>  [<ffffffff8108d2c5>] ? notifier_call_chain+0x45/0x70
>  [<ffffffff810d5fc1>] ? timekeeping_update+0xf1/0x150
>  [<ffffffff810df2c0>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffff810d0bb6>] ? update_process_times+0x36/0x60
>  [<ffffffff810df2c0>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffff810decf4>] ? tick_sched_handle.isra.15+0x24/0x60
>  [<ffffffff810df2c0>] ? tick_sched_do_timer+0x40/0x40
>  [<ffffffff810df2fb>] ? tick_sched_timer+0x3b/0x70
>  [<ffffffff810d16dc>] ? __hrtimer_run_queues+0xdc/0x210
>  [<ffffffff8101c645>] ? read_tsc+0x5/0x10
>  [<ffffffff8101c645>] ? read_tsc+0x5/0x10
>  [<ffffffff810d1afa>] ? hrtimer_interrupt+0x9a/0x190
>  [<ffffffff8155b4f9>] ? smp_apic_timer_interrupt+0x39/0x50
>  [<ffffffff815596db>] ? apic_timer_interrupt+0x6b/0x70
>  <EOI>  [<ffffffff815584a0>] ? _raw_spin_lock+0x10/0x20
>  [<ffffffffa030955f>] ? __del_reloc_root+0x2f/0x100 [btrfs]
>  [<ffffffffa0309530>] ? __add_reloc_root+0xe0/0xe0 [btrfs]
>  [<ffffffffa030964d>] ? free_reloc_roots+0x1d/0x30 [btrfs]
>  [<ffffffffa030f6e5>] ? merge_reloc_roots+0x165/0x220 [btrfs]
>  [<ffffffffa0310343>] ? btrfs_recover_relocation+0x293/0x380 [btrfs]
>  [<ffffffffa02bcaa2>] ? open_ctree+0x20d2/0x23b0 [btrfs]
>  [<ffffffffa02933fb>] ? btrfs_mount+0x87b/0x990 [btrfs]
>  [<ffffffff8117417f>] ? pcpu_next_unpop+0x3f/0x50
>  [<ffffffff811c3646>] ? mount_fs+0x36/0x170
>  [<ffffffff811ddf08>] ? vfs_kern_mount+0x68/0x110
>  [<ffffffffa0292d3b>] ? btrfs_mount+0x1bb/0x990 [btrfs]
>  …
> 
> Call Trace:
>  [<ffffffffa030955f>] ? __del_reloc_root+0x2f/0x100 [btrfs]
>  [<ffffffffa030964d>] ? free_reloc_roots+0x1d/0x30 [btrfs]
>  [<ffffffffa030f6e5>] ? merge_reloc_roots+0x165/0x220 [btrfs]
>  [<ffffffffa0310343>] ? btrfs_recover_relocation+0x293/0x380 [btrfs]
>  [<ffffffffa02bcaa2>] ? open_ctree+0x20d2/0x23b0 [btrfs]
>  [<ffffffffa02933fb>] ? btrfs_mount+0x87b/0x990 [btrfs]
>  [<ffffffff8117417f>] ? pcpu_next_unpop+0x3f/0x50
>  [<ffffffff811c3646>] ? mount_fs+0x36/0x170
>  [<ffffffff811ddf08>] ? vfs_kern_mount+0x68/0x110
>  [<ffffffffa0292d3b>] ? btrfs_mount+0x1bb/0x990 [btrfs]
>  …
> 
> A longer excerpt can be found here: http://pastebin.com/NPM0Ckfy
> 
> I am using kernel 4.2.6 (Debian backports) and btrfs-tools 4.3.
> 
> btrfs check --readonly gave no errors.
> (except the probably false positives mentioned here
> http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg48325.html)
> 
> Reading the whole file system worked also.
> 
> If you need more information to trace this back, let me know and I'll
> try to get it.
> If you have suggestions regarding the recovery, please let me know as well.
> 
> Best regards,
> 
> Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
