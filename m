Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13A1C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 17:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 786B620855
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfBHRC6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:02:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:48910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbfBHRC6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 12:02:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DCB0AF1B;
        Fri,  8 Feb 2019 17:02:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A6D34DA83D; Fri,  8 Feb 2019 18:02:17 +0100 (CET)
Date:   Fri, 8 Feb 2019 18:02:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] btrfs: scrub: fix scrub_lock
Message-ID: <20190208170216.GQ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 02:44:59PM +0800, Anand Jain wrote:
> Fixes the circular locking dependency warning as in patch 1/3,
> and patch 2/3 adds lockdep_assert_held() to scrub_workers_get().
> Patch 3/3 converts scrub_workers_refcnt into refcount_t.
> 
> Anand Jain (3):
>   btrfs: scrub: fix circular locking dependency warning
>   btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
>   btrfs: scrub: convert scrub_workers_refcnt to refcount_t

The test 011 still complains, now user-after-free dected due to the
refcount_t underflow checks.

btrfs/011               [16:50:09][  334.134707] run fstests btrfs/011 at 2019-02-08 16:50:09
[  334.722472] BTRFS: device fsid e6112183-884c-473f-af91-217c504332b2 devid 1 transid 5 /dev/vdb
[  334.740057] BTRFS info (device vdb): disk space caching is enabled
[  334.742457] BTRFS info (device vdb): has skinny extents
[  334.744286] BTRFS info (device vdb): flagging fs with big metadata feature
[  334.766487] BTRFS info (device vdb): checking UUID tree
[  340.960787] BTRFS info (device vdb): dev_replace from /dev/vdb (devid 1) to /dev/vdc started
[  340.966691] ------------[ cut here ]------------
[  340.967918] refcount_t: increment on 0; use-after-free.
[  340.969290] WARNING: CPU: 3 PID: 24675 at lib/refcount.c:153 refcount_inc_checked+0x26/0x30
[  340.970962] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop
[  340.973321] CPU: 3 PID: 24675 Comm: btrfs Not tainted 5.0.0-rc5-default+ #459
[  340.975172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[  340.977686] RIP: 0010:refcount_inc_checked+0x26/0x30
[  340.981291] RSP: 0018:ffff976e4459bc78 EFLAGS: 00010286
[  340.982080] RAX: 0000000000000000 RBX: ffff8b1d65fb4000 RCX: 0000000000000006
[  340.983826] RDX: 0000000000000006 RSI: ffff8b1d74be58f8 RDI: ffff8b1d74be5000
[  340.985504] RBP: 0000000000000006 R08: 0000008abc17cca3 R09: 0000000000000000
[  340.987235] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  340.988823] R13: ffff8b1d65fb4000 R14: 0000000000000000 R15: ffff8b1d65fb7620
[  340.990405] FS:  00007f68924908c0(0000) GS:ffff8b1d7da00000(0000) knlGS:0000000000000000
[  340.992198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  340.993689] CR2: 00007fffcc01d830 CR3: 00000000719e8000 CR4: 00000000000006e0
[  340.995453] Call Trace:
[  340.996198]  scrub_workers_get+0xc2/0x110 [btrfs]
[  340.997462]  btrfs_scrub_dev+0x16f/0x5c0 [btrfs]
[  340.998814]  ? start_transaction+0xa1/0x500 [btrfs]
[  341.000155]  btrfs_dev_replace_by_ioctl.cold.19+0x179/0x1bb [btrfs]
[  341.001500]  btrfs_ioctl+0x262d/0x2e10 [btrfs]
[  341.002186]  ? __lock_acquire+0x263/0xf10
[  341.002798]  ? kvm_clock_read+0x14/0x30
[  341.003386]  ? kvm_sched_clock_read+0x5/0x10
[  341.004023]  ? sched_clock+0x5/0x10
[  341.004574]  ? sched_clock_cpu+0xc/0xc0
[  341.005171]  ? do_vfs_ioctl+0xa2/0x6d0
[  341.005750]  do_vfs_ioctl+0xa2/0x6d0
[  341.006580]  ? do_sigaction+0x1a7/0x210
[  341.007521]  ksys_ioctl+0x3a/0x70
[  341.008273]  __x64_sys_ioctl+0x16/0x20
[  341.009112]  do_syscall_64+0x54/0x180
[  341.009939]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  341.011166] RIP: 0033:0x7f6892585a97

[  341.015696] RSP: 002b:00007fffcc022d68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  341.017384] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f6892585a97
[  341.018344] RDX: 00007fffcc0231a0 RSI: 00000000ca289435 RDI: 0000000000000003
[  341.019964] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  341.021533] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fffcc02524a
[  341.023195] R13: 0000000000000001 R14: 0000000000000004 R15: 000056333a1b82a0
[  341.025017] irq event stamp: 32590
[  341.025812] hardirqs last  enabled at (32589): [<ffffffff960c5345>] console_unlock+0x435/0x5d0
[  341.027987] hardirqs last disabled at (32590): [<ffffffff96001ac9>] trace_hardirqs_off_thunk+0x1a/0x1c
[  341.030440] softirqs last  enabled at (31906): [<ffffffff96a00364>] __do_softirq+0x364/0x47b
[  341.032599] softirqs last disabled at (31631): [<ffffffff96065781>] irq_exit+0xd1/0xe0
[  341.033772] ---[ end trace 01d834fdbc0fe47a ]---
[  341.129440] ------------[ cut here ]------------
[  341.130750] refcount_t: underflow; use-after-free.
[  341.131746] WARNING: CPU: 0 PID: 24675 at lib/refcount.c:187 refcount_sub_and_test_checked+0x46/0x50
[  341.133045] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq loop
[  341.134504] CPU: 0 PID: 24675 Comm: btrfs Tainted: G        W         5.0.0-rc5-default+ #459
[  341.136356] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[  341.137931] RIP: 0010:refcount_sub_and_test_checked+0x46/0x50
[  341.142184] RSP: 0018:ffff976e4459bc98 EFLAGS: 00010282
[  341.143343] RAX: 0000000000000000 RBX: ffff8b1d64ea6800 RCX: 0000000000000006
[  341.144886] RDX: 0000000000000006 RSI: ffff8b1d74be58c0 RDI: ffff8b1d74be5000
[  341.146340] RBP: ffff8b1d64329c00 R08: 0000008accffd043 R09: 0000000000000000
[  341.147652] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8b1d65fb76c0
[  341.149023] R13: ffff8b1d65fb4000 R14: 0000000000404100 R15: 0000000000000000
[  341.150876] FS:  00007f68924908c0(0000) GS:ffff8b1d7d400000(0000) knlGS:0000000000000000
[  341.152551] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  341.153367] CR2: 00007f535aa68d40 CR3: 00000000719e8000 CR4: 00000000000006f0
[  341.154523] Call Trace:
[  341.155559]  btrfs_scrub_dev+0x35c/0x5c0 [btrfs]
[  341.156563]  ? start_transaction+0xa1/0x500 [btrfs]
[  341.157520]  btrfs_dev_replace_by_ioctl.cold.19+0x179/0x1bb [btrfs]
[  341.158951]  btrfs_ioctl+0x262d/0x2e10 [btrfs]
[  341.160373]  ? __lock_acquire+0x263/0xf10
[  341.161821]  ? kvm_clock_read+0x14/0x30
[  341.163052]  ? kvm_sched_clock_read+0x5/0x10
[  341.164568]  ? sched_clock+0x5/0x10
[  341.165809]  ? sched_clock_cpu+0xc/0xc0
[  341.166941]  ? do_vfs_ioctl+0xa2/0x6d0
[  341.167609]  do_vfs_ioctl+0xa2/0x6d0
[  341.168163]  ? do_sigaction+0x1a7/0x210
[  341.168743]  ksys_ioctl+0x3a/0x70
[  341.169266]  __x64_sys_ioctl+0x16/0x20
[  341.169836]  do_syscall_64+0x54/0x180
[  341.170758]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
