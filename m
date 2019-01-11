Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D13C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9EE20874
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbfAKO2B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:28:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:44862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388409AbfAKO17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 09:27:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82359ABCB;
        Fri, 11 Jan 2019 14:27:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A3202DA780; Fri, 11 Jan 2019 15:27:24 +0100 (CET)
Date:   Fri, 11 Jan 2019 15:27:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between cloning range ending at eof and
 writeback
Message-ID: <20190111142723.GD27146@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190108114254.3296-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108114254.3296-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 11:42:54AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The recent rework that makes btrfs' remap_file_range operation use the
> generic helper generic_remap_file_range_prep() introduced a race between
> writeback and cloning a range that covers the eof extent of the source
> file into a destination offset that is greater then the same file's size.
> 
> This happens because we now wait for writeback to complete before doing
> the truncation of the eof block, while previously we did the truncation
> and then waited for writeback to complete. This leads to a race between
> writeback of the truncated block and cloning the file extents in the
> source range, because we copy each file extent item we find in the fs
> root into a buffer, then release the path and then increment the reference
> count for the extent referred in that file extent item we copied, which
> can no longer exist if writeback of the truncated eof block completes
> after we copied the file extent item into the buffer and before we
> incremented the reference count. This is illustrated by the following
> diagram:
> 
>         CPU 1                                       CPU 2
> 
>   btrfs_clone_files()
>     btrfs_cont_expand()
>       btrfs_truncate_block()
>          --> zeroes part of the
>              page containg eof,
>              marking it for
>             delalloc
> 
>     btrfs_clone()
>       --> finds extent item
>           covering eof,
>           points to extent
>           at bytenr X
>       --> copies it into a
>           local buffer
>       --> releases path
> 
>                                         writeback starts
> 
>                                         btrfs_finish_ordered_io()
>                                           insert_reserved_file_extent()
>                                             __btrfs_drop_extents()
>                                               --> creates delayed
>                                                   reference to drop
>                                                   the extent at
>                                                   bytenr X
> 
>       --> starts transaction
>       --> creates delayed
>           reference to
>           increment extent
>           at bytenr X
> 
>                     <delayed references are run, due to a transaction
>                      commit for example, and the transaction is aborted
>                      with -EIO because we attempt to increment reference
>                      count for the extent at bytenr X after we freed it>
> 
> When this race is hit the running transaction ends up getting aborted with
> an -EIO error and a trace like the following is produced:
> 
> [ 4382.553858] WARNING: CPU: 2 PID: 3648 at fs/btrfs/extent-tree.c:1552 lookup_inline_extent_backref+0x4f4/0x650 [btrfs]
> (...)
> [ 4382.556293] CPU: 2 PID: 3648 Comm: btrfs Tainted: G        W         4.20.0-rc6-btrfs-next-41 #1
> [ 4382.556294] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
> [ 4382.556308] RIP: 0010:lookup_inline_extent_backref+0x4f4/0x650 [btrfs]
> (...)
> [ 4382.556310] RSP: 0018:ffffac784408f738 EFLAGS: 00010202
> [ 4382.556311] RAX: 0000000000000001 RBX: ffff8980673c3a48 RCX: 0000000000000001
> [ 4382.556312] RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000000
> [ 4382.556312] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> [ 4382.556313] R10: 0000000000000001 R11: ffff897f40000000 R12: 0000000000001000
> [ 4382.556313] R13: 00000000c224f000 R14: ffff89805de9bd40 R15: ffff8980453f4548
> [ 4382.556315] FS:  00007f5e759178c0(0000) GS:ffff89807b300000(0000) knlGS:0000000000000000
> [ 4382.563130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4382.563562] CR2: 00007f2e9789fcbc CR3: 0000000120512001 CR4: 00000000003606e0
> [ 4382.564005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 4382.564451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 4382.564887] Call Trace:
> [ 4382.565343]  insert_inline_extent_backref+0x55/0xe0 [btrfs]
> [ 4382.565796]  __btrfs_inc_extent_ref.isra.60+0x88/0x260 [btrfs]
> [ 4382.566249]  ? __btrfs_run_delayed_refs+0x93/0x1650 [btrfs]
> [ 4382.566702]  __btrfs_run_delayed_refs+0xa22/0x1650 [btrfs]
> [ 4382.567162]  btrfs_run_delayed_refs+0x7e/0x1d0 [btrfs]
> [ 4382.567623]  btrfs_commit_transaction+0x50/0x9c0 [btrfs]
> [ 4382.568112]  ? _raw_spin_unlock+0x24/0x30
> [ 4382.568557]  ? block_rsv_release_bytes+0x14e/0x410 [btrfs]
> [ 4382.569006]  create_subvol+0x3c8/0x830 [btrfs]
> [ 4382.569461]  ? btrfs_mksubvol+0x317/0x600 [btrfs]
> [ 4382.569906]  btrfs_mksubvol+0x317/0x600 [btrfs]
> [ 4382.570383]  ? rcu_sync_lockdep_assert+0xe/0x60
> [ 4382.570822]  ? __sb_start_write+0xd4/0x1c0
> [ 4382.571262]  ? mnt_want_write_file+0x24/0x50
> [ 4382.571712]  btrfs_ioctl_snap_create_transid+0x117/0x1a0 [btrfs]
> [ 4382.572155]  ? _copy_from_user+0x66/0x90
> [ 4382.572602]  btrfs_ioctl_snap_create+0x66/0x80 [btrfs]
> [ 4382.573052]  btrfs_ioctl+0x7c1/0x30e0 [btrfs]
> [ 4382.573502]  ? mem_cgroup_commit_charge+0x8b/0x570
> [ 4382.573946]  ? do_raw_spin_unlock+0x49/0xc0
> [ 4382.574379]  ? _raw_spin_unlock+0x24/0x30
> [ 4382.574803]  ? __handle_mm_fault+0xf29/0x12d0
> [ 4382.575215]  ? do_vfs_ioctl+0xa2/0x6f0
> [ 4382.575622]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [ 4382.576020]  do_vfs_ioctl+0xa2/0x6f0
> [ 4382.576405]  ksys_ioctl+0x70/0x80
> [ 4382.576776]  __x64_sys_ioctl+0x16/0x20
> [ 4382.577137]  do_syscall_64+0x60/0x1b0
> [ 4382.577488]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> (...)
> [ 4382.578837] RSP: 002b:00007ffe04bf64c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
> [ 4382.579174] RAX: ffffffffffffffda RBX: 00005564136f3050 RCX: 00007f5e74724dd7
> [ 4382.579505] RDX: 00007ffe04bf64d0 RSI: 000000005000940e RDI: 0000000000000003
> [ 4382.579848] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000044
> [ 4382.580164] R10: 0000000000000541 R11: 0000000000000202 R12: 00005564136f3010
> [ 4382.580477] R13: 0000000000000003 R14: 00005564136f3035 R15: 00005564136f3050
> [ 4382.580792] irq event stamp: 0
> [ 4382.581106] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
> [ 4382.581441] hardirqs last disabled at (0): [<ffffffff8d085842>] copy_process.part.32+0x6e2/0x2320
> [ 4382.581772] softirqs last  enabled at (0): [<ffffffff8d085842>] copy_process.part.32+0x6e2/0x2320
> [ 4382.582095] softirqs last disabled at (0): [<0000000000000000>]           (null)
> [ 4382.582413] ---[ end trace d3c188e3e9367382 ]---
> [ 4382.623855] BTRFS: error (device sdc) in btrfs_run_delayed_refs:2981: errno=-5 IO failure
> [ 4382.624295] BTRFS info (device sdc): forced readonly
> 
> Fix this by waiting for writeback to complete after truncating the eof
> block.
> 
> Fixes: 34a28e3d7753 ("Btrfs: use generic_remap_file_range_prep() for cloning and deduplication")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to 5.0-rc queue, thanks.
