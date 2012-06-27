Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:39319 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2F0FrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 01:47:17 -0400
Message-ID: <4FEA9E63.50000@profihost.ag>
Date: Wed, 27 Jun 2012 07:47:15 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE8A21E.7050104@profihost.ag> <20120625180252.GD7404@localhost.localdomain> <4FE8ADBA.20505@profihost.ag> <4FE8BCF5.4080605@profihost.ag> <20120625201151.GG7404@localhost.localdomain> <4FE8C80F.2040009@profihost.ag> <20120625202310.GH7404@localhost.localdomain> <4FE9E7BC.1020104@profihost.ag> <20120626201418.GA24953@localhost.localdomain> <4FEA1945.7050906@profihost.ag> <20120626204759.GC24953@localhost.localdomain>
In-Reply-To: <20120626204759.GC24953@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes i will do so. Right now i was trying to compare discard with non 
discard with this simple command:
for i in `seq 0 1 1000`; do dd if=/dev/zero of=t_$i bs=4M count=1; rm 
t_$i; done;

But i hit a new bug:

[39577.660228] BUG: unable to handle kernel paging request at 
fffffffffffffe50
[39577.686517] IP: [<ffffffff8131b4f3>] btrfs_finish_ordered_io+0x23/0x3f0
[39577.713417] PGD 1c0d067 PUD 1c0e067 PMD 0
[39577.740039] Oops: 0000 [#1] SMP
[39577.766401] CPU 6
[39577.792540] Modules linked in: nf_conntrack_ipv4 nf_conntrack 
nf_defrag_ipv4 ipv6 i2c_i801 coretemp i2c_core ixgbe(O) [last unloaded: 
scsi_wait_scan]
[39577.847511]
[39577.847513] Pid: 3447, comm: btrfs-endio-wri Tainted: G           O 
3.5.0-rc4intel #15 Supermicro 
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F
[39577.847516] RIP: 0010:[<ffffffff8131b4f3>]  [<ffffffff8131b4f3>] 
btrfs_finish_ordered_io+0x23/0x3f0
[39577.847516] RSP: 0018:ffff880e3b861d90  EFLAGS: 00010287
[39577.847517] RAX: ffff880e3b861e90 RBX: ffff880e3a8fb100 RCX: 
ffff880e3b861e90
[39577.847517] RDX: ffff880e3b861e90 RSI: ffff880e3a8fb190 RDI: 
ffff880e3a8fb100
[39577.847518] RBP: ffff880e3b861e10 R08: dead000000100100 R09: 
dead000000200200
[39577.847518] R10: 0000000000000000 R11: 0000000000000001 R12: 
ffff880e3a624770
[39577.847518] R13: 0000000000000000 R14: ffff880e3a8fb1b8 R15: 
ffff880e3b861e80
[39577.847519] FS:  0000000000000000(0000) GS:ffff880e7fd80000(0000) 
knlGS:0000000000000000
[39577.847520] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[39577.847520] CR2: fffffffffffffe50 CR3: 0000000001c0b000 CR4: 
00000000000407e0
[39577.847521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[39577.847521] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[39577.847522] Process btrfs-endio-wri (pid: 3447, threadinfo 
ffff880e3b860000, task ffff880e40e58000)
[39577.847522] Stack:
[39577.847524]  0000000000000000 dead000000200200 0000000100965b86 
ffff880e40e94000
[39577.847525]  ffffffff8104dc20 ffff880e40e58000 ffffffffffffffff 
0000000000000000
[39577.847526]  0000000000000000 0000000000000000 ffff880e40e58000 
ffff880e3a624720
[39577.847527] Call Trace:
[39577.847530]  [<ffffffff8104dc20>] ? lock_timer_base+0x70/0x70
[39577.847531]  [<ffffffff8131b8d0>] finish_ordered_fn+0x10/0x20
[39577.847533]  [<ffffffff8133f38e>] worker_loop+0x14e/0x530
[39577.847534]  [<ffffffff8133f240>] ? btrfs_queue_worker+0x310/0x310
[39577.847535]  [<ffffffff8133f240>] ? btrfs_queue_worker+0x310/0x310
[39577.847538]  [<ffffffff8105ffd6>] kthread+0x96/0xa0
[39577.847541]  [<ffffffff816dc594>] kernel_thread_helper+0x4/0x10
[39577.847543]  [<ffffffff8105ff40>] ? kthread_worker_fn+0x130/0x130
[39577.847544]  [<ffffffff816dc590>] ? gs_change+0xb/0xb
[39577.847555] Code: 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 c4 80 48 
89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 48 89 fb 4c 8b 
6f 38 <4d> 8b a5 50 fe ff ff 4d 8d 95 50 fe ff ff 48 c7 45 c8 00 00 00
[39577.847556] RIP  [<ffffffff8131b4f3>] btrfs_finish_ordered_io+0x23/0x3f0
[39577.847557]  RSP <ffff880e3b861d90>
[39577.847557] CR2: fffffffffffffe50
[39577.847558] ---[ end trace 27bdc0b318ad6463 ]---

Am 26.06.2012 22:48, schrieb Josef Bacik:
> On Tue, Jun 26, 2012 at 02:19:17PM -0600, Stefan Priebe wrote:
>> Am 26.06.2012 22:14, schrieb Josef Bacik:
>>> I can't reproduce so I'm going to have to figure out a way to debug it through
>>> you, as soon as I think of something I will let you know.  Thanks,
>>>
>>
>> Thanks. You mentioned that discard shouldn't have any positive effects
>> on a SSD.
>>
>> May i see a sideffect? I mean with discard 13.000 IOPs in ceph without
>> discard just 6000-9000 IOPs could this be real or might this just happen
>> due to the bug i see?
>>
>
> Beats me, it would seem to me that discard would make things slower since we
> have to wait for the commit to discard everybody, but who knows, stranger things
> have happened.  Can you reproduce 2 more times and get sysrq+w each time so I
> have a few different outputs to compare, maybe I'm missing something.  Thanks,
>
> Josef
>

