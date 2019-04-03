Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE852C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B27A20830
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfDCOrY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:47:24 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41598 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfDCOrX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:47:23 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 0E9E1291A17; Wed,  3 Apr 2019 10:47:17 -0400 (EDT)
Date:   Wed, 3 Apr 2019 10:47:16 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Spurious "ghost" "parent transid verify failed" messages on
 5.0.5 + lockdep warning
Message-ID: <20190403144716.GA15312@hungrycats.org>
References: <20190312040024.GI9995@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312040024.GI9995@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 12:00:25AM -0400, Zygo Blaxell wrote:
> On 4.14.x and 4.20.14 kernels (probably all the ones in between too,
> but I haven't tested those), I get what I call "ghost parent transid
> verify failed" errors.  Here's an unedited recent example from dmesg:
> 
> 	[16180.649285] BTRFS error (device dm-3): parent transid verify failed on 1218181971968 wanted 9698 found 9744

These happen much less often on 5.0.x, but they still happen from time
to time.

5.0.5 also produced a lockdep warning last night, the first such warning
I have seen with this call trace:

	[Tue Apr  2 23:00:28 2019] WARNING: CPU: 1 PID: 4213 at kernel/locking/lockdep.c:702 register_lock_class+0x2f2/0x590
	[Tue Apr  2 23:00:28 2019] Modules linked in: crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ppdev joydev dm_cache_smq dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod aesni_intel aes_x86_64 snd_pcm crypto_simd cryptd glue_helper snd_timer sr_mod cdrom snd soundcore sg parport_pc input_leds psmouse rtc_cmos ide_pci_generic pcspkr serio_raw floppy parport piix bochs_drm ide_core i2c_piix4 evbug evdev qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[Tue Apr  2 23:00:28 2019] CPU: 1 PID: 4213 Comm: btrfs-cleaner Not tainted 5.0.5-zb64-4eaee293f832+ #1
	[Tue Apr  2 23:00:28 2019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[Tue Apr  2 23:00:28 2019] RIP: 0010:register_lock_class+0x2f2/0x590
	[Tue Apr  2 23:00:28 2019] Code: 40 b2 f8 8d 89 c2 e8 9d 94 00 00 66 90 85 d2 74 11 48 c7 c7 c8 45 5e 8c e8 eb fb ff ff e8 fb b2 c2 00 45 31 ff e9 f6 fd ff ff <0f> 0b 8b 05 ee 41 e8 02 e9 c0 fd ff ff 65 48 8b 04 25 00 6e 01 00
	[Tue Apr  2 23:00:28 2019] RSP: 0018:ffffb15f40893ab0 EFLAGS: 00010087
	[Tue Apr  2 23:00:28 2019] RAX: ffffffff8c906af0 RBX: 0000000000000282 RCX: 0000000000000000
	[Tue Apr  2 23:00:28 2019] RDX: ffffffff8e085a18 RSI: 000000000000076e RDI: 0000000000000000
	[Tue Apr  2 23:00:28 2019] RBP: 0000000000000000 R08: ffffffff8b4dd33d R09: 0000000000000000
	[Tue Apr  2 23:00:28 2019] R10: 0000000000000000 R11: ffff908c2a09a720 R12: 0000000000000000
	[Tue Apr  2 23:00:28 2019] R13: 0000000000000001 R14: ffff908c2a09a720 R15: ffffffff8d623b60
	[Tue Apr  2 23:00:28 2019] FS:  0000000000000000(0000) GS:ffff908d3a000000(0000) knlGS:0000000000000000
	[Tue Apr  2 23:00:28 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[Tue Apr  2 23:00:28 2019] CR2: 00007f65819ea1f0 CR3: 00000001328d2006 CR4: 00000000001606e0
	[Tue Apr  2 23:00:28 2019] Call Trace:
	[Tue Apr  2 23:00:28 2019]  ? __lock_acquire+0x477/0x1b30
	[Tue Apr  2 23:00:28 2019]  __lock_acquire+0xb1/0x1b30
	[Tue Apr  2 23:00:28 2019]  ? btrfs_tree_lock+0x9d/0x250
	[Tue Apr  2 23:00:28 2019]  ? __lock_acquire+0x477/0x1b30
	[Tue Apr  2 23:00:28 2019]  ? lock_acquire+0xbc/0x1c0
	[Tue Apr  2 23:00:28 2019]  lock_acquire+0xbc/0x1c0
	[Tue Apr  2 23:00:28 2019]  ? btrfs_tree_lock+0x9d/0x250
	[Tue Apr  2 23:00:28 2019]  _raw_write_lock+0x30/0x70
	[Tue Apr  2 23:00:28 2019]  ? btrfs_tree_lock+0x9d/0x250
	[Tue Apr  2 23:00:28 2019]  btrfs_tree_lock+0x9d/0x250
	[Tue Apr  2 23:00:28 2019]  ? mark_page_accessed+0x13d/0x160
	[Tue Apr  2 23:00:28 2019]  ? mark_extent_buffer_accessed+0x67/0x80
	[Tue Apr  2 23:00:28 2019]  do_walk_down+0x126/0x610
	[Tue Apr  2 23:00:28 2019]  ? do_raw_spin_unlock+0x49/0xc0
	[Tue Apr  2 23:00:28 2019]  walk_down_tree+0xb8/0x100
	[Tue Apr  2 23:00:28 2019]  btrfs_drop_snapshot+0x3a4/0x8d0
	[Tue Apr  2 23:00:28 2019]  btrfs_clean_one_deleted_snapshot+0xb2/0x110
	[Tue Apr  2 23:00:28 2019]  cleaner_kthread+0x11f/0x180
	[Tue Apr  2 23:00:28 2019]  kthread+0x106/0x140
	[Tue Apr  2 23:00:28 2019]  ? btrfs_destroy_pinned_extent+0x1b0/0x1b0
	[Tue Apr  2 23:00:28 2019]  ? kthread_park+0x90/0x90
	[Tue Apr  2 23:00:28 2019]  ret_from_fork+0x3a/0x50
	[Tue Apr  2 23:00:28 2019] irq event stamp: 131299397
	[Tue Apr  2 23:00:28 2019] hardirqs last  enabled at (131299397): [<ffffffff8b2bd4fe>] kmem_cache_alloc+0x1fe/0x310
	[Tue Apr  2 23:00:28 2019] hardirqs last disabled at (131299396): [<ffffffff8b2bd3b5>] kmem_cache_alloc+0xb5/0x310
	[Tue Apr  2 23:00:28 2019] softirqs last  enabled at (131299388): [<ffffffff8c0003a4>] __do_softirq+0x3a4/0x45f
	[Tue Apr  2 23:00:28 2019] softirqs last disabled at (131299339): [<ffffffff8b0a3d54>] irq_exit+0xe4/0xf0
	[Tue Apr  2 23:00:28 2019] ---[ end trace 3fa5835f7315f7f2 ]---

The comments around lockdep.c:702 talk about trampling on memory,
which could be a use-after-free bug.  The spurious parent transid
verify failures also behave like a use-after-free bug.  Both events have
occurred only while snapshots are being deleted.  This smells a lot like
a use-after-free bug in the btrfs snapshot delete code.

Some time later:

	[Wed Apr  3 09:05:20 2019] BTRFS error (device dm-3): parent transid verify failed on 2071098556416 wanted 13332 found 13308
	[Wed Apr  3 09:05:21 2019] BTRFS error (device dm-3): parent transid verify failed on 2071098556416 wanted 13332 found 13308

In this case the test machine was running a workload that includes
continuous snapshot deletes--snapshots are created in parallel by a
process that tries to keep 20-100 snapshots being deleted at all times
(in addition to the usual 10 rsyncs + bees dedupe).

The log messages here are 10 hours apart, and the first appeared 3 hours
after boot.  Normally, there will be a few "parent transid verify failed"
messages per 24 hours of snapshot delete time.
