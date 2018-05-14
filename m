Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:42026 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeENLji (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:39:38 -0400
Received: by mail-ua0-f193.google.com with SMTP id f3-v6so8075838uan.9
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 04:39:38 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1526266294-23121-1-git-send-email-robbieko@synology.com>
References: <1526266294-23121-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 14 May 2018 12:39:36 +0100
Message-ID: <CAL3q7H6u-cH+zKnUkMgC-O_eWAhP4JvxOMR=b+szk5SYCo1cFQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: incremental send, fix BUG when invalid memory access
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 3:51 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> [BUG]
> btrfs incremental send BUG happens when creating a snapshot of snapshot
> that is being used by send.
>
> [REASON]
> The problem can happen if while we are doing a send one of the snapshots
> used (parent or send) is snapshotted, because snapshoting implies COWing
> the root of the source subvolume/snapshot.
>
> 1. When doing an incremental send, the send process will get the commit
>    roots from the parent and send snapshots, and add references to them
>    through extent_buffer_get().
>
> 2. When a snapshot/subvolume is snapshotted, its root node is COWed
>    (transaction.c:create_pending_snapshot()).
>
> 3. COWing releases the space used by the node immediately, through:
>
>    __btrfs_cow_block()
>    --btrfs_free_tree_block()
>    ----btrfs_add_free_space(bytenr of node)
>
> 4. Because send doesn't hold a transaction open, it's possible that
>    the transaction used to create the snapshot commits, switches the
>    commit root and the old space used by the previous root node gets
>    assigned to some other node allocation. Allocation of a new node will
>    use the existing extent buffer found in memory, which we previously
>    got a reference through extent_buffer_get(), and allow the extent
>    buffer's content (pages) to be modified:
>
>    btrfs_alloc_tree_block
>    --btrfs_reserve_extent
>    ----find_free_extent (get bytenr of old node)
>    --btrfs_init_new_buffer (use bytenr of old node)
>    ----btrfs_find_create_tree_block
>    ------alloc_extent_buffer
>    --------find_extent_buffer (get old node)
>
> 5. So send can access invalid memory content and have unpredictable
>    behaviour.
>
> [FIX]
> So we fix the problem by copying the commit roots of the send and
> parent snapshots and use those copies.
>
> CallTrace looks like this:
>  ------------[ cut here ]------------
>  kernel BUG at fs/btrfs/ctree.c:1861!
>  invalid opcode: 0000 [#1] SMP
>  CPU: 6 PID: 24235 Comm: btrfs Tainted: P           O 3.10.105 #23721
>  ffff88046652d680 ti: ffff88041b720000 task.ti: ffff88041b720000
>  RIP: 0010:[<ffffffffa08dd0e8>] read_node_slot+0x108/0x110 [btrfs]
>  RSP: 0018:ffff88041b723b68  EFLAGS: 00010246
>  RAX: ffff88043ca6b000 RBX: ffff88041b723c50 RCX: ffff880000000000
>  RDX: 000000000000004c RSI: ffff880314b133f8 RDI: ffff880458b24000
>  RBP: 0000000000000000 R08: 0000000000000001 R09: ffff88041b723c66
>  R10: 0000000000000001 R11: 0000000000001000 R12: ffff8803f3e48890
>  R13: ffff8803f3e48880 R14: ffff880466351800 R15: 0000000000000001
>  FS:  00007f8c321dc8c0(0000) GS:ffff88047fcc0000(0000)
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  R2: 00007efd1006d000 CR3: 0000000213a24000 CR4: 00000000003407e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Stack:
>  ffff88041b723c50 ffff8803f3e48880 ffff8803f3e48890 ffff8803f3e48880
>  ffff880466351800 0000000000000001 ffffffffa08dd9d7 ffff88041b723c50
>  ffff8803f3e48880 ffff88041b723c66 ffffffffa08dde85 a9ff88042d2c4400
>  Call Trace:
>  [<ffffffffa08dd9d7>] ? tree_move_down.isra.33+0x27/0x50 [btrfs]
>  [<ffffffffa08dde85>] ? tree_advance+0xb5/0xc0 [btrfs]
>  [<ffffffffa08e83d4>] ? btrfs_compare_trees+0x2d4/0x760 [btrfs]
>  [<ffffffffa0982050>] ? finish_inode_if_needed+0x870/0x870 [btrfs]
>  [<ffffffffa09841ea>] ? btrfs_ioctl_send+0xeda/0x1050 [btrfs]
>  [<ffffffffa094bd3d>] ? btrfs_ioctl+0x1e3d/0x33f0 [btrfs]
>  [<ffffffff81111133>] ? handle_pte_fault+0x373/0x990
>  [<ffffffff8153a096>] ? atomic_notifier_call_chain+0x16/0x20
>  [<ffffffff81063256>] ? set_task_cpu+0xb6/0x1d0
>  [<ffffffff811122c3>] ? handle_mm_fault+0x143/0x2a0
>  [<ffffffff81539cc0>] ? __do_page_fault+0x1d0/0x500
>  [<ffffffff81062f07>] ? check_preempt_curr+0x57/0x90
>  [<ffffffff8115075a>] ? do_vfs_ioctl+0x4aa/0x990
>  [<ffffffff81034f83>] ? do_fork+0x113/0x3b0
>  [<ffffffff812dd7d7>] ? trace_hardirqs_off_thunk+0x3a/0x6c
>  [<ffffffff81150cc8>] ? SyS_ioctl+0x88/0xa0
>  [<ffffffff8153e422>] ? system_call_fastpath+0x16/0x1b
>  ---[ end trace 29576629ee80b2e1 ]---
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, I would only change the subject to something like:

Btrfs: send, fix invalid access to commit roots due to concurrent snapshotting

David can probably do that when picking this patch.

thanks

> ---
> V3: use btrfs_clone_extent_buffer
> V2: fix comments
>  fs/btrfs/ctree.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b88a79e..8b6b554 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -5460,12 +5460,24 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>         down_read(&fs_info->commit_root_sem);
>         left_level = btrfs_header_level(left_root->commit_root);
>         left_root_level = left_level;
> -       left_path->nodes[left_level] = left_root->commit_root;
> +       left_path->nodes[left_level] =
> +                       btrfs_clone_extent_buffer(left_root->commit_root);
> +       if (!left_path->nodes[left_level]) {
> +               up_read(&fs_info->commit_root_sem);
> +               ret = -ENOMEM;
> +               goto out;
> +       }
>         extent_buffer_get(left_path->nodes[left_level]);
>
>         right_level = btrfs_header_level(right_root->commit_root);
>         right_root_level = right_level;
> -       right_path->nodes[right_level] = right_root->commit_root;
> +       right_path->nodes[right_level] =
> +                       btrfs_clone_extent_buffer(right_root->commit_root);
> +       if (!right_path->nodes[right_level]) {
> +               up_read(&fs_info->commit_root_sem);
> +               ret = -ENOMEM;
> +               goto out;
> +       }
>         extent_buffer_get(right_path->nodes[right_level]);
>         up_read(&fs_info->commit_root_sem);
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
