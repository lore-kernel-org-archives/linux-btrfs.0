From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Tue, 22 Mar 2011 22:33:24 +0900
Message-ID: <20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>
References: <4D8324DE.4010400@cn.fujitsu.com>
	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>
	<4D8813A5.1040604@cn.fujitsu.com>
	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>
	<4D8873EC.1040702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8873EC.1040702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On Tue, 22 Mar 2011 18:03:24 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> The V5 patch is attached, could you test it for me? I have run Chris stress test, dbench benchmark
> on my machine, it work well. I want to check if the above bug still exists or not.
> 
> Thanks
> Miao

Here's the boot log (The V5 patch is on top of the btrfs-unstable next-rc branch):

BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
IP: [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
PGD 7074c067 PUD 75b6d067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
CPU 0 
Modules linked in: mptspi mptscsih mptbase scsi_transport_spi

Pid: 1, comm: init Not tainted 2.6.36-xie+ #120 440BX Desktop Reference Platform/VMware Virtual Platform
RIP: 0010:[<ffffffff81075c12>]  [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
RSP: 0018:ffff88007ceafb58  EFLAGS: 00010097
RAX: 0000000000000046 RBX: ffff88007ceb0050 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000c8
RBP: ffff88007ceafc18 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: ffff88007ceafd48 R12: ffff88007ceb0050
R13: 00000000000000c8 R14: 0000000000000002 R15: 0000000000000000
FS:  00007f1fe74e7720(0000) GS:ffff880004e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000c8 CR3: 0000000070486000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff88007ceae000, task ffff88007ceb0050)
Stack:
 0000000000000002 0000000000000001 ffff88007ceafb78 ffffffff810bdd5d
<0> ffff880000000000 ffffffff00000000 ffff88007ceafbc8 0000000000000046
<0> ffff88007ceafba8 ffff88007ceb0050 ffffffff81067dcd 0000000000000001
Call Trace:
 [<ffffffff810bdd5d>] ? time_hardirqs_off+0x2e/0x36
 [<ffffffff81067dcd>] ? local_clock+0x2a/0x3b
 [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
 [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
 [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
 [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
 [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
 [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
 [<ffffffff8110ba5f>] ? virt_to_head_page+0xe/0x31
 [<ffffffff8110dbbc>] ? cache_alloc_debugcheck_after+0x176/0x1cd
 [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
 [<ffffffff8121294b>] btrfs_get_delayed_items+0x37/0xb6
 [<ffffffff811d7e01>] btrfs_real_readdir+0x170/0x52c
 [<ffffffff8112b739>] ? vfs_readdir+0x56/0xb6
 [<ffffffff8112b559>] ? filldir+0x0/0xd0
 [<ffffffff810bdfc0>] ? trace_preempt_on+0x24/0x26
 [<ffffffff814cb4e8>] ? sub_preempt_count+0xa3/0xb6
 [<ffffffff814c6645>] ? __mutex_lock_common+0x3ee/0x444
 [<ffffffff8112b739>] ? vfs_readdir+0x56/0xb6
 [<ffffffff8111e435>] ? rcu_read_unlock+0x0/0x4b
 [<ffffffff8112b559>] ? filldir+0x0/0xd0
 [<ffffffff8112b559>] ? filldir+0x0/0xd0
 [<ffffffff8112b75c>] vfs_readdir+0x79/0xb6
 [<ffffffff8112b8e9>] sys_getdents+0x85/0xd8
 [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
Code: 58 e2 8b 01 00 be b3 0a 00 00 0f 85 c4 0c 00 00 e9 4d 0c 00 00 83 fe 07 76 11 e8 7e 55 1f 00 48 c7 c7 55 85 78 81 e9 78 0c 00 00 <49> 8 
RIP  [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
 RSP <ffff88007ceafb58>
CR2: 00000000000000c8
---[ end trace 87f215b3568d553d ]---

