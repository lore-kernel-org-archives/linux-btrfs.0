Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36056 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbdDJMov (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:44:51 -0400
Received: by mail-io0-f177.google.com with SMTP id l7so93291697ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 05:44:51 -0700 (PDT)
Subject: Re: parity scrub on 32-bit
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <20170410085322.giqsdl45o6rexzoc@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <73d262a7-92c0-fe98-69a5-ab9d8e2238d3@gmail.com>
Date: Mon, 10 Apr 2017 08:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <20170410085322.giqsdl45o6rexzoc@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-10 04:53, Adam Borowski wrote:
> Hi!
> While messing with the division failure on current -next, I've noticed that
> parity scrub splats immediately on all 32-bit archs I tried.  But, it's not
> a regression: it bisects to 5a6ac9eacb49143cbad3bbfda72263101cb1f3df (merged
> in 3.19) which happens to be when parity scrub was added.  Ie, it never
> worked in the first place.
>
> But this doesn't sound right to me -- while no one gives a damn about i386
> (good riddance!), ARM32 NASes are quite popular.  Surely someone would have
> noticed -- it fails not only when there's damage to repair but even when
> everything is clean.
I can confirm this on 32-bit MIPS (both big and little endian), PPC, and 
SPARC tested in Qemu, as well as the aforementioned ARM and x86.  The 
numbers in the back-traces I get are different on each of course, but 
the actual function names are the same (within architectural 
differences).  I only checked current and 
5a6ac9eacb49143cbad3bbfda72263101cb1f3df however.
>
> Am I missing something?
>
> Test script attached (overkill, it dies on first scrub before I get to
> damage it).
>
> Trace from the earliest commit, i386_defconfig+btrfs:
> [   83.254499] ------------[ cut here ]------------
> [   83.255009] kernel BUG at mm/highmem.c:353!
> [   83.255009] invalid opcode: 0000 [#1] SMP
> [   83.255009] Modules linked in:
> [   83.255009] CPU: 0 PID: 3017 Comm: kworker/u4:7 Not tainted 3.18.0-rc6-defconfig+ #1
> [   83.255009] Hardware name: Hewlett-Packard HP Compaq dc7100 SFF(DX878AV)/097Ch, BIOS 786C1 v01.05 06/16/2004
> [   83.255009] Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper
> [   83.255009] task: f646f580 ti: f5ee0000 task.ti: f5ee0000
> [   83.255009] EIP: 0060:[<c110dab0>] EFLAGS: 00010246 CPU: 0
> [   83.255009] EIP is at kunmap_high+0x90/0xa0
> [   83.255009] EAX: 000000ca EBX: 00000001 ECX: fffff000 EDX: 00000000
> [   83.255009] ESI: 00000004 EDI: f65e6680 EBP: f5ee1e34 ESP: f5ee1e30
> [   83.255009]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   83.255009] CR0: 8005003b CR2: b555cfdc CR3: 20476000 CR4: 000007d0
> [   83.255009] Stack:
> [   83.255009]  f5820800 f5ee1e3c c103de19 f5ee1ea0 c12d1546 00000000 e2729000 de4f1000
> [   83.255009]  e2941000 ff8c9000 e0fd3cac f5ee1e4c 00000002 f5ee1e5c f5820800 00000000
> [   83.255009]  f7400300 ffffffff f7409240 f65e6680 f5ee1e48 00000003 0000000d 00000000
> [   83.255009] Call Trace:
> [   83.255009]  [<c103de19>] kunmap+0x49/0x50
> [   83.255009]  [<c12d1546>] finish_parity_scrub+0x216/0x440
> [   83.255009]  [<c12d280a>] validate_rbio_for_parity_scrub+0xda/0xe0
> [   83.255009]  [<c12d2867>] raid56_parity_scrub_end_io+0x57/0x70
> [   83.255009]  [<c1313ab1>] bio_endio+0x41/0x90
> [   83.255009]  [<c1258064>] ? end_workqueue_fn+0x24/0x40
> [   83.255009]  [<c1313b0c>] bio_endio_nodec+0xc/0x10
> [   83.255009]  [<c125806d>] end_workqueue_fn+0x2d/0x40
> [   83.255009]  [<c1290aba>] btrfs_scrubnc_helper+0xca/0x250
> [   83.255009]  [<c1290ce8>] btrfs_endio_raid56_helper+0x8/0x10
> [   83.255009]  [<c105574d>] process_one_work+0x1ad/0x3f0
> [   83.255009]  [<c1055b8a>] worker_thread+0x1fa/0x490
> [   83.255009]  [<c1055990>] ? process_one_work+0x3f0/0x3f0
> [   83.255009]  [<c1059b16>] kthread+0x96/0xb0
> [   83.255009]  [<c17f55c1>] ret_from_kernel_thread+0x21/0x30
> [   83.255009]  [<c1059a80>] ? kthread_worker_fn+0x120/0x120
> [   83.255009] Code: ba 03 00 00 00 e8 a1 53 f6 ff 58 8b 5d fc c9 c3 8d 76 00 31 c0 81 3d 24 7b aa c1 24 7b aa c1 0f 95 c0 eb c5 8d b4 26 00 00 00 00 <0f> 0b 8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 55 89 e5 56 53
> [   83.255009] EIP: [<c110dab0>] kunmap_high+0x90/0xa0 SS:ESP 0068:f5ee1e30
> [   83.497432] ---[ end trace bf2c0560a0dc9e51 ]---
>

