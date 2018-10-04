Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5370BC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 10:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDA12082A
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 10:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FDA12082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbeJDRGf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 13:06:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:34282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727415AbeJDRGf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 13:06:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 48420AC9C;
        Thu,  4 Oct 2018 10:13:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 13FFCDA82D; Thu,  4 Oct 2018 12:13:56 +0200 (CEST)
Date:   Thu, 4 Oct 2018 12:13:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] Cleanup dev-replace locking
Message-ID: <20181004101355.GB29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1536331604.git.dsterba@suse.com>
 <20180927110646.GP3255@twin.jikos.cz>
 <91a85e18-161f-5da0-825e-0468867af3f4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91a85e18-161f-5da0-825e-0468867af3f4@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 09:06:01AM +0800, Anand Jain wrote:
> 
> 
> On 09/27/2018 07:06 PM, David Sterba wrote:
> > On Fri, Sep 07, 2018 at 04:54:59PM +0200, David Sterba wrote:
> >> The series peels off the custom locking that's used for dev-replace and
> >> uses read-write semaphore in the end.
> >>
> >> I've mainly focused on correctness and haven't measured the performance
> >> effects. There should be none as the blocking and waiting was merely
> >> open coding what the rw semaphore does, but without the fairness. The
> >> overall number of locks taken is low, there's a lots of IO in between so
> >> even if new scheme is slower, I don't expect any dramatic change.
> > 
> > Mixed results. The btrfs/011 is a test that usually takes long time
> > (around 1000 sec on my test box) and I have a long list of run times to
> > compare. There this patchset does not show any problems. However on a VM
> > with 8 CPUs, this goes from similar times (1000 sec) to several hours,
> > without apparent reason. The is other low activity on the system, but so
> > this is with testing other patchsets and the times are not that bad.
> > 
> > So, I'm going to merge the first part of the patchset that does not
> > switch the locking primitives to the semaphores, more analysis needed.
> > 
> 
> I have reviewed/tested all in this set and it looks good to me.
> 
> So Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks for testing, I'll add the tag to the patches.

> I do observer btrfs/011 taking longer time to complete (200sec more) and 
> Null pointer dereference even without this patch set, tracing back lead 
> to conclusion, that

The run times of 011 are quite wild and sometimes drop to 500 secs and
go back to 1000+, on the same devices and basically same kernel. But
replacing the locking would need further analysis as it's possible that
the reader/writer fairness of the rwsem is acually not helping in the
replace case that as currently implemented favors readers.

I'm rarely observing a crash in 011, stacktrace attached, please let me
know if it's the same as the one you mention.

[  738.344228] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 1) to /dev/vdc started
[  739.585174] WARNING: CPU: 3 PID: 20788 at fs/btrfs/scrub.c:620 scrub_setup_ctx.isra.19+0x20c/0x210 [btrfs]
[  739.591953] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop
[  739.594926] CPU: 3 PID: 20788 Comm: btrfs Not tainted 4.19.0-rc5-default+ #271
[  739.596350] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  739.598304] RIP: 0010:scrub_setup_ctx.isra.19+0x20c/0x210 [btrfs]
[  739.603855] RSP: 0018:ffff914d076bbc30 EFLAGS: 00010246
[  739.605120] RAX: 0000000000000001 RBX: 0000000000000040 RCX: 0000000000182000
[  739.606206] RDX: ffffffffc04aa000 RSI: 0000000000000000 RDI: 0000000000000038
[  739.607119] RBP: ffffffffc03c9640 R08: ffffffffc0328000 R09: ffffffff9a00abc0
[  739.608025] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  739.608950] R13: ffff9049f94d8000 R14: ffff9049fbc56800 R15: ffff9049f94daf30
[  739.610321] FS:  00007f72e9a328c0(0000) GS:ffff9049fd200000(0000) knlGS:0000000000000000
[  739.612299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  739.613602] CR2: 00005645d94eb4f0 CR3: 0000000046de0000 CR4: 00000000000006e0
[  739.615244] Call Trace:
[  739.615986]  btrfs_scrub_dev+0x14c/0x5a0 [btrfs]
[  739.617122]  ? start_transaction+0xa1/0x470 [btrfs]
[  739.618335]  btrfs_dev_replace_start.cold.24+0x9a/0x144 [btrfs]
[  739.619680]  btrfs_dev_replace_by_ioctl+0x35/0x60 [btrfs]
[  739.621003]  btrfs_ioctl+0x2a94/0x31d0 [btrfs]
[  739.622123]  ? filemap_map_pages+0x279/0x3d0
[  739.623199]  ? _raw_spin_unlock+0x24/0x40
[  739.624225]  ? __handle_mm_fault+0xb52/0xcb0
[  739.625263]  ? do_vfs_ioctl+0xa2/0x6b0
[  739.626247]  do_vfs_ioctl+0xa2/0x6b0
[  739.627184]  ksys_ioctl+0x3a/0x70
[  739.628058]  __x64_sys_ioctl+0x16/0x20
[  739.628953]  do_syscall_64+0x5a/0x1a0
[  739.629893]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  739.631083] RIP: 0033:0x7f72e8efeaa7
[  739.636109] RSP: 002b:00007ffd6d3695a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  739.637900] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f72e8efeaa7
[  739.639508] RDX: 00007ffd6d3699e0 RSI: 00000000ca289435 RDI: 0000000000000003
[  739.641116] RBP: 0000000000000000 R08: 00007f72e9a328c0 R09: 00007f72e93e72a0
[  739.642780] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd6d36c278
[  739.644499] R13: 0000000000000000 R14: 0000000000000004 R15: 00005645d95b72a0
[  739.646082] irq event stamp: 0
[  739.646968] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[  739.648878] hardirqs last disabled at (0): [<ffffffff9905b9cd>] copy_process.part.66+0x84d/0x1db0
[  739.651061] softirqs last  enabled at (0): [<ffffffff9905b9cd>] copy_process.part.66+0x84d/0x1db0
[  739.653042] softirqs last disabled at (0): [<0000000000000000>]           (null)
[  739.654965] ---[ end trace 9e2151540055738e ]---
[  740.471443] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 1) to /dev/vdc canceled
[  740.614161] BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
[  740.617332] PGD 0 P4D 0
[  740.618575] Oops: 0000 [#1] PREEMPT SMP
[  740.620664] CPU: 0 PID: 12214 Comm: kworker/u16:4 Tainted: G        W         4.19.0-rc5-default+ #271
[  740.626680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  740.629983] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
[  740.631239] RIP: 0010:scrub_write_page_to_dev_replace+0x86/0x2d0 [btrfs]
[  740.636572] RSP: 0018:ffff914d0b0fbd28 EFLAGS: 00010206
[  740.637711] RAX: ffff9049931b0800 RBX: ffff9049e3103400 RCX: 0000000000000000
[  740.639271] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9049931b0800
[  740.640820] RBP: ffff9049fbc56800 R08: ffff9049931b0780 R09: ffff9049e3103400
[  740.642359] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9049e30dbf00
[  740.643876] R13: ffff9049fbc56ae8 R14: ffffffffc03c5ce0 R15: ffff9049c6d82a00
[  740.645378] FS:  0000000000000000(0000) GS:ffff9049fcc00000(0000) knlGS:0000000000000000
[  740.647291] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  740.648514] CR2: 00000000000000b0 CR3: 0000000038011000 CR4: 00000000000006f0
[  740.650067] Call Trace:
[  740.650709]  scrub_write_block_to_dev_replace+0x3b/0x60 [btrfs]
[  740.652083]  scrub_bio_end_io_worker+0xee/0x500 [btrfs]
[  740.653241]  normal_work_helper+0xcd/0x530 [btrfs]
[  740.654368]  process_one_work+0x246/0x5c0
[  740.655321]  worker_thread+0x3c/0x390
[  740.656233]  ? rescuer_thread+0x360/0x360
[  740.657271]  kthread+0x116/0x130
[  740.658138]  ? kthread_create_worker_on_cpu+0x70/0x70
[  740.659353]  ret_from_fork+0x24/0x30
[  740.660276] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop
[  740.662453] CR2: 00000000000000b0
[  740.663402] ---[ end trace 9e2151540055738f ]---
[  740.664622] RIP: 0010:scrub_write_page_to_dev_replace+0x86/0x2d0 [btrfs]
[  740.670545] RSP: 0018:ffff914d0b0fbd28 EFLAGS: 00010206
[  740.671856] RAX: ffff9049931b0800 RBX: ffff9049e3103400 RCX: 0000000000000000
[  740.673523] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9049931b0800
[  740.675211] RBP: ffff9049fbc56800 R08: ffff9049931b0780 R09: ffff9049e3103400
[  740.676876] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9049e30dbf00
[  740.678582] R13: ffff9049fbc56ae8 R14: ffffffffc03c5ce0 R15: ffff9049c6d82a00
[  740.680092] FS:  0000000000000000(0000) GS:ffff9049fcc00000(0000) knlGS:0000000000000000
[  740.682002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  740.683264] CR2: 00000000000000b0 CR3: 0000000038011000 CR4: 00000000000006f0
[  740.684623] BUG: sleeping function called from invalid context at include/linux/cgroup-defs.h:711
[  740.686144] in_atomic(): 0, irqs_disabled(): 1, pid: 12214, name: kworker/u16:4
[  740.687471] INFO: lockdep is turned off.
[  740.688446] irq event stamp: 755514
[  740.689212] hardirqs last  enabled at (755513): [<ffffffff9960adf9>] _raw_spin_unlock_irq+0x29/0x50
[  740.690933] hardirqs last disabled at (755514): [<ffffffff9960283e>] __schedule+0xae/0xaf0
[  740.692750] softirqs last  enabled at (755460): [<ffffffff99a0034d>] __do_softirq+0x34d/0x442
[  740.694759] softirqs last disabled at (755439): [<ffffffff990648ba>] irq_exit+0xca/0xd0
[  740.696621] CPU: 0 PID: 12214 Comm: kworker/u16:4 Tainted: G      D W         4.19.0-rc5-default+ #271
[  740.698340] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  740.700854] Workqueue: btrfs-scrub btrfs_scrub_helper [btrfs]
[  740.702106] Call Trace:
[  740.702695]  dump_stack+0x85/0xc0
[  740.703527]  ___might_sleep.cold.79+0xac/0xbe
[  740.704539]  exit_signals+0x30/0x130
[  740.705425]  do_exit+0xac/0xb90
[  740.706178]  ? rescuer_thread+0x360/0x360
[  740.707018]  ? kthread+0x116/0x130
[  740.707748]  rewind_stack_do_exit+0x17/0x20
