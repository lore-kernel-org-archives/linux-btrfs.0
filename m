Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33965 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbbHDRek (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 13:34:40 -0400
Received: by ioea135 with SMTP id a135so24273545ioe.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 10:34:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1438699433-1581-3-git-send-email-anand.jain@oracle.com>
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
	<1438699433-1581-3-git-send-email-anand.jain@oracle.com>
Date: Tue, 4 Aug 2015 18:34:39 +0100
Message-ID: <CAL3q7H4QsbcAuq5Az59_SaONcZtZ9frJ7q14kCtMds7LkqGg2A@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: fix null pointer dereference when extent
 buffer is already freed
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 4, 2015 at 3:43 PM, Anand Jain <anand.jain@oracle.com> wrote:
> When, read_tree_block() returns error it has already freed the extent_buffer
>
> read_tree_block(..)
> {
> ::
>         ret = btree_read_extent_buffer_pages(root, buf, 0, parent_transid); <== fails
>         if (ret) {
>                 free_extent_buffer(buf); <=== its freed already
>                 return ERR_PTR(ret);
>         }
> ::
> }
>
> open_ctree()
> {
> ::
>         chunk_root->node = read_tree_block(..);
> ::
>
> BTRFS: failed to read chunk root on sdf
> BUG: unable to handle kernel NULL pointer dereference at 000000000000001f
> IP: [<ffffffffa04f930e>] free_extent_buffer+0x1e/0xb0 [btrfs]
> ::
> [<ffffffffa04c7dae>] ? free_root_extent_buffers+0x1e/0x40 [btrfs]
> [<ffffffffa04c7e26>] free_root_pointers+0x56/0x60 [btrfs]
> [<ffffffffa04cebc0>] open_ctree+0x19e0/0x2360 [btrfs]
> [<ffffffffa04a2676>] btrfs_mount+0x9e6/0xb10 [btrfs]
> [<ffffffff81353cea>] ? find_next_zero_bit+0x1a/0x30
> [<ffffffff81353cb5>] ? find_next_bit+0x15/0x30
> [<ffffffff8119246a>] ? pcpu_alloc+0x35a/0x680
> [<ffffffff811ec648>] mount_fs+0x38/0x190
> [<ffffffff811927c5>] ? __alloc_percpu+0x15/0x20
> [<ffffffff81207ecb>] vfs_kern_mount+0x6b/0x120
> [<ffffffffa04a1e88>] btrfs_mount+0x1f8/0xb10 [btrfs]
> [<ffffffff8119246a>] ? pcpu_alloc+0x35a/0x680
> [<ffffffff811ec648>] mount_fs+0x38/0x190
> [<ffffffff811927c5>] ? __alloc_percpu+0x15/0x20
> [<ffffffff81207ecb>] vfs_kern_mount+0x6b/0x120
> [<ffffffff8120af54>] do_mount+0x224/0xb80
> [<ffffffff8120bbbe>] SyS_mount+0x7e/0xe0
> [<ffffffff815d00ae>] system_call_fastpath+0x12/0x71
>
> this patch avoids calling it again
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index da7b7bf..e8901ac 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2081,7 +2081,8 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
>  static void free_root_extent_buffers(struct btrfs_root *root)
>  {
>         if (root) {
> -               free_extent_buffer(root->node);
> +               if (!IS_ERR(root->node))
> +                       free_extent_buffer(root->node);

Wasn't this already solved by commit [1] added in the last 4.2-rc?
Either way, it's better to avoid having root->node with an error in
the first place, should be NULL or a valid (non-error) address (like
what's done everywhere else).

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=95ab1f64908795a2edd6b847eca94a0c63a44be4

>                 free_extent_buffer(root->commit_root);
>                 root->node = NULL;
>                 root->commit_root = NULL;
> --
> 2.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
