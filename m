Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD50C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 22:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDA921916
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 22:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBHW2k (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 17:28:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:47264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbfBHW2k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 17:28:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1735AFAB
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2019 22:28:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 468D8DA83D; Fri,  8 Feb 2019 23:27:57 +0100 (CET)
Date:   Fri, 8 Feb 2019 23:27:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: Speedup chunk allocation for large fs
Message-ID: <20190208222757.GS2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190130074000.16638-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130074000.16638-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 03:39:58PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/falloc_speedup
> 
> Which is based on v5.0-rc1 tag, with another enospc debug patch.
> 
> Btrfs falloc can be slower and slower when there are more and more block
> groups.
> 
> One cause of this problem is find_free_dev_extent(), as it always search
> from device offset 0, and if there are thousands existing dev extents
> btrfs will search leaf by leaf until it reaches a free slot.
> 
> This is super slow and inefficient.
> 
> This patchset will introduce a new member,
> btrfs_device::hint_free_dev_extent to give some hint for
> find_free_dev_extent().
> 
> The full cause analyse and benchmark can be found in the 2nd patch.
> 
> Qu Wenruo (2):
>   btrfs: Don't search devid for every verify_one_dev_extent() call
>   btrfs: Introduce free dev extent hint to speed up chunk allocation

fstests complain. It's the 2G VM, all tests up to that one are fine then it
goes donwhill and logs are flooded.

btrfs/161               [20:53:28][ 4057.174855] run fstests btrfs/161 at 2019-02-08 20:53:28
[ 4057.318947] BTRFS info (device vda): disk space caching is enabled
[ 4057.323914] BTRFS info (device vda): has skinny extents
[ 4057.515090] BTRFS: device fsid 8760735f-f548-42ff-a0c4-9fa470681954 devid 1 transid 5 /dev/vdb
[ 4057.530213] BTRFS info (device vdb): disk space caching is enabled
[ 4057.532582] BTRFS info (device vdb): has skinny extents
[ 4057.534353] BTRFS info (device vdb): flagging fs with big metadata feature
[ 4057.538604] BTRFS info (device vdb): checking UUID tree
[ 4057.626129] BTRFS info (device vdb): disk space caching is enabled
[ 4057.628347] BTRFS info (device vdb): has skinny extents
[ 4057.661631] ------------[ cut here ]------------
[ 4057.663927] BTRFS: Transaction aborted (error -28)
[ 4057.666545] WARNING: CPU: 1 PID: 3034 at fs/btrfs/volumes.c:2715 btrfs_init_new_device+0x12bd/0x1350 [btrfs]
[ 4057.671389] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_flakey dm_mod loop [last unloaded: libcrc32c]
[ 4057.675003] CPU: 1 PID: 3034 Comm: btrfs Not tainted 5.0.0-rc5-default+ #460
[ 4057.676487] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[ 4057.678239] RIP: 0010:btrfs_init_new_device+0x12bd/0x1350 [btrfs]
[ 4057.684383] RSP: 0018:ffffb8bf0581bc70 EFLAGS: 00010282
[ 4057.685866] RAX: 0000000000000000 RBX: ffff9ce1fc874000 RCX: 0000000000000000
[ 4057.687677] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffffffa30c5345
[ 4057.689126] RBP: ffffb8bf0581bd90 R08: 0000000000000001 R09: 0000000000000000
[ 4057.690770] R10: 0000000000000000 R11: ffffb8bf0581bb18 R12: 00000000ffffffe4
[ 4057.692258] R13: ffff9ce1f8278000 R14: ffff9ce1fc874980 R15: ffff9ce18afa0800
[ 4057.693732] FS:  00007f94294ec8c0(0000) GS:ffff9ce1fd600000(0000) knlGS:0000000000000000
[ 4057.695754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4057.697206] CR2: 00007ffcf7a96fd0 CR3: 0000000037ffd000 CR4: 00000000000006e0
[ 4057.699078] Call Trace:
[ 4057.699832]  btrfs_ioctl+0x24ae/0x2e10 [btrfs]
[ 4057.700962]  ? _copy_to_user+0x5e/0x70
[ 4057.701684]  ? cp_new_stat+0x12c/0x160
[ 4057.702258]  ? do_vfs_ioctl+0xa2/0x6d0
[ 4057.702823]  do_vfs_ioctl+0xa2/0x6d0
[ 4057.703386]  ? __do_sys_newlstat+0x48/0x70
[ 4057.704202]  ksys_ioctl+0x3a/0x70
[ 4057.704784]  __x64_sys_ioctl+0x16/0x20
[ 4057.705371]  do_syscall_64+0x54/0x180
[ 4057.705929]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4057.706633] RIP: 0033:0x7f94295e1a97
[ 4057.711767] RSP: 002b:00007ffcf7a9c508 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 4057.713815] RAX: ffffffffffffffda RBX: 00007ffcf7a9d6c8 RCX: 00007f94295e1a97
[ 4057.715370] RDX: 00007ffcf7a9c540 RSI: 000000005000940a RDI: 0000000000000003
[ 4057.717266] RBP: 0000000000000001 R08: 000000000000ffff R09: 0000000000000001
[ 4057.719098] R10: 0000556403361a00 R11: 0000000000000246 R12: 0000000000000004
[ 4057.720925] R13: 00007ffcf7a9d6d0 R14: 0000000000000000 R15: 0000556403360a20
[ 4057.722731] irq event stamp: 0
[ 4057.723632] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[ 4057.725718] hardirqs last disabled at (0): [<ffffffffa305c84b>] copy_process.part.72+0x84b/0x1df0
[ 4057.728217] softirqs last  enabled at (0): [<ffffffffa305c84b>] copy_process.part.72+0x84b/0x1df0
[ 4057.730514] softirqs last disabled at (0): [<0000000000000000>]           (null)
[ 4057.732558] ---[ end trace d75e6b78fb58b18b ]---
[ 4057.733808] BTRFS warning (device vdb): btrfs_init_new_device:2715: Aborting unused transaction(No space left).
[failed, exit status 1][ 4057.776999] assertion failed: nr_devices, file: fs/btrfs/super.c, line: 1918
[ 4057.781086] ------------[ cut here ]------------
[ 4057.783603] kernel BUG at fs/btrfs/ctree.h:3530!
[ 4057.786148] invalid opcode: 0000 [#1] PREEMPT SMP
[ 4057.788739] CPU: 1 PID: 3039 Comm: umount Tainted: G        W         5.0.0-rc5-default+ #460
[ 4057.792391] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[ 4057.795704] RIP: 0010:btrfs_statfs.cold.68+0x1f/0x21 [btrfs]
[ 4057.801880] RSP: 0018:ffffb8bf05843dc0 EFLAGS: 00010246
[ 4057.802703] RAX: 0000000000000040 RBX: ffff9ce1fc8742d0 RCX: 0000000000000000
[ 4057.803919] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa30c5345
[ 4057.805846] RBP: ffffb8bf05843e38 R08: 0000000000000001 R09: 0000000000000000
[ 4057.807157] R10: 0000000000000000 R11: ffffb8bf05843c70 R12: ffffb8bf05843eb0
[ 4057.808932] R13: ffff9ce18afa0800 R14: ffff9ce1fc874000 R15: 0000000000000001
[ 4057.810237] FS:  00007fe011459fc0(0000) GS:ffff9ce1fd600000(0000) knlGS:0000000000000000
[ 4057.811801] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4057.813081] CR2: 00007fe0117985d0 CR3: 000000004c613000 CR4: 00000000000006e0
[ 4057.814549] Call Trace:
[ 4057.815171]  statfs_by_dentry+0x57/0x80
[ 4057.816129]  vfs_statfs+0x16/0xc0
[ 4057.816916]  user_statfs+0x54/0xa0
[ 4057.817782]  __do_sys_statfs+0x20/0x50
[ 4057.818678]  do_syscall_64+0x54/0x180
[ 4057.819603]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4057.820814] RIP: 0033:0x7fe0116945e7
[ 4057.821745] Code: 44 00 00 48 8b 05 b1 f8 0c 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 89 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 f8 0c 00 f7 d8 64 89 01 48
[ 4057.826876] RSP: 002b:00007ffeea10e7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000089
[ 4057.828936] RAX: ffffffffffffffda RBX: 000055d89a521970 RCX: 00007fe0116945e7
[ 4057.830023] RDX: 0000000000000001 RSI: 00007ffeea10e820 RDI: 000055d89a521b80
[ 4057.830968] RBP: 00007ffeea10e820 R08: 0000000000000000 R09: 0000000000000000
[ 4057.832374] R10: 0000000000000000 R11: 0000000000000246 R12: 000055d89a521b80
[ 4057.833827] R13: 0000000000000000 R14: 00007fe0117c91c4 R15: 00007ffeea10fc00
[ 4057.834781] Modules linked in: btrfs libcrc32c xor zstd_decompress zstd_compress xxhash raid6_pq dm_flakey dm_mod loop [last unloaded: libcrc32c]
[ 4057.837089] ---[ end trace d75e6b78fb58b18c ]---
[ 4057.838144] RIP: 0010:btrfs_statfs.cold.68+0x1f/0x21 [btrfs]
[ 4057.843474] RSP: 0018:ffffb8bf05843dc0 EFLAGS: 00010246
[ 4057.844636] RAX: 0000000000000040 RBX: ffff9ce1fc8742d0 RCX: 0000000000000000
[ 4057.846229] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa30c5345
[ 4057.848112] RBP: ffffb8bf05843e38 R08: 0000000000000001 R09: 0000000000000000
[ 4057.849874] R10: 0000000000000000 R11: ffffb8bf05843c70 R12: ffffb8bf05843eb0
[ 4057.851783] R13: ffff9ce18afa0800 R14: ffff9ce1fc874000 R15: 0000000000000001
[ 4057.853636] FS:  00007fe011459fc0(0000) GS:ffff9ce1fd600000(0000) knlGS:0000000000000000
[ 4057.854943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4057.855973] CR2: 00007fe0117985d0 CR3: 000000004c613000 CR4: 00000000000006e0

