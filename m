Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-4.smtp-out.eu-west-1.amazonses.com ([54.240.4.4]:57876 "EHLO
        a4-4.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbdLUTwc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 14:52:32 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Martin Raiber <martin@urbackup.org>
Subject: Btrfs blocked by too many delayed refs
Message-ID: <010201607aa262c5-5146203e-5b9c-4aad-89c1-968955a3f485-000000@eu-west-1.amazonses.com>
Date: Thu, 21 Dec 2017 19:52:30 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have the problem that too many delayed refs block a btrfs storage. I
have one thread that does work:

[<ffffffff810a3956>] io_schedule+0x16/0x40
[<ffffffff8117bff6>] wait_on_page_bit+0x116/0x150
[<ffffffff81359b65>] read_extent_buffer_pages+0x1c5/0x290
[<ffffffff81329dcd>] btree_read_extent_buffer_pages+0x9d/0x100
[<ffffffff8132b262>] read_tree_block+0x32/0x50
[<ffffffff8130a810>] read_block_for_search.isra.30+0x120/0x2e0
[<ffffffff8130c865>] btrfs_search_slot+0x385/0x990
[<ffffffff8130e501>] btrfs_insert_empty_items+0x71/0xc0
[<ffffffff8131186b>] insert_extent_data_ref.isra.49+0x11b/0x2a0
[<ffffffff8131608e>] __btrfs_inc_extent_ref.isra.59+0x1ee/0x220
[<ffffffff813197d4>] __btrfs_run_delayed_refs+0x924/0x12c0
[<ffffffff8131d17a>] btrfs_run_delayed_refs+0x7a/0x260
[<ffffffff81332da4>] create_pending_snapshot+0x5e4/0xf00
[<ffffffff81333757>] create_pending_snapshots+0x97/0xc0
[<ffffffff81333e95>] btrfs_commit_transaction+0x395/0x930
[<ffffffff8136bcf6>] btrfs_mksubvol+0x4a6/0x4f0
[<ffffffff8136bec5>] btrfs_ioctl_snap_create_transid+0x185/0x190
[<ffffffff8136c064>] btrfs_ioctl_snap_create_v2+0x104/0x150
[<ffffffff8136f891>] btrfs_ioctl+0x5e1/0x23b0
[<ffffffff812231c2>] do_vfs_ioctl+0x92/0x5a0
[<ffffffff81223749>] SyS_ioctl+0x79/0x9

the others are in 'D' state e.g. with

[<ffffffff81798b57>] call_rwsem_down_write_failed+0x17/0x30
[<ffffffff8121f04b>] filename_create+0x6b/0x150
[<ffffffff8121ffa4>] SyS_mkdir+0x44/0xe0

Slabtop shows 2423910 btrfs_delayed_ref_head structs, slowly decreasing.

What I think is happening is that delayed refs are added without
throttling them with btrfs_should_throttle_delayed_refs . Maybe by
creating a snapshot of a file and then modifying it (some action that
creates delayed refs, is not truncate which is already throttled and
does not commit a transaction which is also throttled).

Regards,
Martin Raiber

