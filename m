Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803EDC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6CF2173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 23:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfC1XRK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 19:17:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728544AbfC1XRK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 19:17:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EB38ADDB
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 23:17:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6E52FDA911; Fri, 29 Mar 2019 00:18:19 +0100 (CET)
Date:   Fri, 29 Mar 2019 00:18:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/15] FITRIM improvement
Message-ID: <20190328231818.GS29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327122418.24027-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 02:24:03PM +0200, Nikolay Borisov wrote:
> Here is the (hopefully final) v4 of the fitrim patches. Main changes since v3:

Nope, tests don't like it. It's v4 applied from mails on top of misc-next.

generic/475             [20:36:10][11571.724402] run fstests generic/475 at 2019-03-28 20:36:10
[11572.257044] BTRFS: device fsid 207b6d9b-30c3-4a78-a932-d18e37fbaa69 devid 1 transid 5 /dev/vdb
[11572.331653] BTRFS info (device dm-0): disk space caching is enabled
[11572.335242] BTRFS info (device dm-0): has skinny extents
[11572.338687] BTRFS info (device dm-0): flagging fs with big metadata feature
[11572.413065] BTRFS info (device dm-0): checking UUID tree
[11574.472606] btrfs_dev_stat_print_on_error: 5 callbacks suppressed
[11574.472609] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[11574.476507] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[11574.479492] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[11574.484811] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[11574.487569] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[11574.489844] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 5, rd 1, flush 0, corrupt 0, gen 0
[11574.490393] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 6, rd 1, flush 0, corrupt 0, gen 0
[11574.495548] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 7, rd 1, flush 0, corrupt 0, gen 0
[11574.497559] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 8, rd 1, flush 0, corrupt 0, gen 0
[11574.500054] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 9, rd 1, flush 0, corrupt 0, gen 0
[11574.504700] BTRFS: error (device dm-0) in btrfs_commit_transaction:2226: errno=-5 IO failure (Error while writing out transaction)
[11574.506372] BTRFS info (device dm-0): forced readonly
[11574.507063] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
[11574.508360] BTRFS: error (device dm-0) in cleanup_transaction:1795: errno=-5 IO failure
[11574.509641] BTRFS info (device dm-0): delayed_refs has NO entry
[11574.510589] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
[11574.512075] BTRFS: error (device dm-0) in cleanup_transaction:1795: errno=-5 IO failure
[11574.515481] BTRFS info (device dm-0): delayed_refs has NO entry
[11574.845098] BTRFS info (device dm-0): disk space caching is enabled
[11574.850062] BTRFS info (device dm-0): has skinny extents
[11574.890143] BTRFS info (device dm-0): checking UUID tree
[11575.962905] BTRFS: error (device dm-0) in btrfs_commit_transaction:2226: errno=-5 IO failure (Error while writing out transaction)
[11575.968652] BTRFS info (device dm-0): forced readonly
[11575.970188] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
[11575.972000] BTRFS: error (device dm-0) in cleanup_transaction:1795: errno=-5 IO failure
[11575.973891] BTRFS info (device dm-0): delayed_refs has NO entry
[11576.217136] BTRFS info (device dm-0): disk space caching is enabled
[11576.218844] BTRFS info (device dm-0): has skinny extents
[11576.227769] BTRFS warning (device dm-0): block group 30408704 has wrong amount of free space
[11576.230266] BTRFS warning (device dm-0): failed to load free space cache for block group 30408704, rebuilding it now
[11576.260681] BTRFS error (device dm-0): error reading free space cache
[11576.260832] BUG: unable to handle kernel paging request at fffffffffffffffb
[11576.262301] BTRFS warning (device dm-0): failed to load free space cache for block group 1104150528, rebuilding it now
[11576.265687] #PF error: [normal kernel read fault]
[11576.265690] PGD 2b016067 P4D 2b016067 PUD 2b018067 PMD 0
[11576.265696] Oops: 0000 [#1] PREEMPT SMP
[11576.265700] CPU: 0 PID: 25594 Comm: fsstress Not tainted 5.1.0-rc2-default+ #531
[11576.265702] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
[11576.265753] RIP: 0010:btrfs_lookup_dentry+0x4ce/0x5d0 [btrfs]
[11576.265756] Code: 4c 63 f8 85 c0 0f 88 90 fb ff ff 80 7d ae 01 0f 85 8c fc ff ff 48 8b 7b 28 45 31 c0 31 c9 4c 89 f2 48 8d 75 a6 e8 e2 f0 ff ff <0f> b7 38 49 89 c7 e8 c7 01 e9 d2 3a 45 98 0f 84 5d fb ff ff 41
[11576.271036] BTRFS: error (device dm-0) in __btrfs_free_extent:7103: errno=-5 IO failure
[11576.271144] RSP: 0018:ffffa82cc3fe7db8 EFLAGS: 00010292
[11576.271149] RAX: fffffffffffffffb RBX: ffff94f41ea66218 RCX: 0000001603c56600
[11576.273851] BTRFS info (device dm-0): forced readonly
[11576.274694] RDX: 0000000000000011 RSI: ffff94f41ea63ed8 RDI: ffffffff930dacb4
[11576.274696] RBP: ffffa82cc3fe7e40 R08: 0000000000000001 R09: fffffffffffffffb
[11576.274698] R10: 0000000000000000 R11: ffff94f46f36a910 R12: ffff94f414e94500
[11576.275912] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:3001: errno=-5 IO failure
[11576.278115] R13: ffff94f474880000 R14: ffff94f403833000 R15: ffff94f4563eaa10
[11576.278117] FS:  00007ff34f4f4b80(0000) GS:ffff94f47d400000(0000) knlGS:0000000000000000
[11576.278121] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11576.278123] CR2: fffffffffffffffb CR3: 000000001f60c000 CR4: 00000000000006f0
[11576.299608] Call Trace:
[11576.300463]  btrfs_lookup+0xe/0x30 [btrfs]
[11576.301666]  __lookup_hash+0x6b/0x90
[11576.302748]  filename_create+0xa9/0x180
[11576.303865]  do_mkdirat+0x53/0xf0
[11576.304844]  do_syscall_64+0x54/0x180
[11576.305924]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11576.307131] RIP: 0033:0x7ff34f5e5307
[11576.307952] Code: 1f 40 00 48 8b 05 91 eb 0c 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 eb 0c 00 f7 d8 64 89 01
[11576.311502] RSP: 002b:00007fff14fd0a98 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
[11576.313415] RAX: ffffffffffffffda RBX: 0000000000000014 RCX: 00007ff34f5e5307
[11576.314809] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00000000004153d0
[11576.316224] RBP: 00007fff14fd0bf0 R08: fefefefefefefeff R09: fefefefefeff3263
[11576.318087] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000000001ff
[11576.319955] R13: 0000000000405390 R14: 0000000000000000 R15: 0000000000000000
[11576.321746] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_flakey dm_mod loop [last unloaded: scsi_d
[11576.325773] CR2: fffffffffffffffb
[11576.326498] ---[ end trace fe71251c3619f317 ]---
[11576.327514] RIP: 0010:btrfs_lookup_dentry+0x4ce/0x5d0 [btrfs]
[11576.328841] Code: 4c 63 f8 85 c0 0f 88 90 fb ff ff 80 7d ae 01 0f 85 8c fc ff ff 48 8b 7b 28 45 31 c0 31 c9 4c 89 f2 48 8d 75 a6 e8 e2 f0 ff ff <0f> b7 38 49 89 c7 e8 c7 01 e9 d2 3a 45 98 0f 84 5d fb ff ff 41
[11576.332993] RSP: 0018:ffffa82cc3fe7db8 EFLAGS: 00010292
[11576.334430] RAX: fffffffffffffffb RBX: ffff94f41ea66218 RCX: 0000001603c56600
[11576.336263] RDX: 0000000000000011 RSI: ffff94f41ea63ed8 RDI: ffffffff930dacb4
[11576.338080] RBP: ffffa82cc3fe7e40 R08: 0000000000000001 R09: fffffffffffffffb
[11576.339907] R10: 0000000000000000 R11: ffff94f46f36a910 R12: ffff94f414e94500
[11576.341535] R13: ffff94f474880000 R14: ffff94f403833000 R15: ffff94f4563eaa10
[11576.342561] FS:  00007ff34f4f4b80(0000) GS:ffff94f47d400000(0000) knlGS:0000000000000000
[11576.343689] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11576.345041] CR2: fffffffffffffffb CR3: 000000001f60c000 CR4: 00000000000006f0
[11576.346593] BUG: sleeping function called from invalid context at include/linux/cgroup-defs.h:721
[11576.348556] in_atomic(): 0, irqs_disabled(): 1, pid: 25594, name: fsstress
[11576.350006] INFO: lockdep is turned off.
[11576.350894] irq event stamp: 0
[11576.351608] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[11576.353254] hardirqs last disabled at (0): [<ffffffff9305cc77>] copy_process.part.72+0x847/0x1df0
[11576.355056] softirqs last  enabled at (0): [<ffffffff9305cc77>] copy_process.part.72+0x847/0x1df0
[11576.356705] softirqs last disabled at (0): [<0000000000000000>]           (null)
[11576.357848] CPU: 0 PID: 25594 Comm: fsstress Tainted: G      D           5.1.0-rc2-default+ #531
[11576.359000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
[11576.360913] Call Trace:
[11576.361480]  dump_stack+0x67/0x90
[11576.362231]  ___might_sleep.cold.85+0x9f/0xb1
[11576.363300]  exit_signals+0x30/0x130
[11576.364220]  do_exit+0xac/0xc10
[11576.365042]  ? do_mkdirat+0x53/0xf0
[11576.365937]  rewind_stack_do_exit+0x17/0x20
[failed, exit status 1] [20:36:15]- output mismatch (see /tmp/fstests/results//generic/475.out.bad)
