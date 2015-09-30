Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36844 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbbI3QTF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:19:05 -0400
Received: by ioii196 with SMTP id i196so53525782ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 09:19:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <aaa2dcf7018bd29459e20f0571ff490fe1abee51.1443611403.git.zhaolei@cn.fujitsu.com>
References: <aaa2dcf7018bd29459e20f0571ff490fe1abee51.1443611403.git.zhaolei@cn.fujitsu.com>
Date: Wed, 30 Sep 2015 17:19:03 +0100
Message-ID: <CAL3q7H5B=ByJBr819u_WM7Z3apd4fMG958vz6shDGv6T3vCYgQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: Fix lost-data-profile caused by auto
 removing bg
From: Filipe Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 12:11 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
> Reproduce:
>  (In integration-4.3 branch)
>
>  TEST_DEV=(/dev/vdg /dev/vdh)
>  TEST_DIR=/mnt/tmp
>
>  umount "$TEST_DEV" >/dev/null
>  mkfs.btrfs -f -d raid1 "${TEST_DEV[@]}"
>
>  mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>  umount "$TEST_DEV"
>
>  mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
>  btrfs filesystem usage $TEST_DIR
>
> We can see the data chunk changed from raid1 to single:
>  # btrfs filesystem usage $TEST_DIR
>  Data,single: Size:8.00MiB, Used:0.00B
>     /dev/vdg        8.00MiB
>  #
>
> Reason:
>  When a empty filesystem mount with -o nospace_cache, the last
>  data blockgroup will be auto-removed in umount.
>
>  Then if we mount it again, there is no data chunk in the
>  filesystem, so the only available data profile is 0x0, result
>  is all new chunks are created as single type.
>
> Fix:
>  Don't auto-delete last blockgroup for a raid type.
>
> Test:
>  Test by above script, and confirmed the logic by debug output.
>
> Changelog v1->v2:
> 1: Put code of checking block_group->list into
>    semaphore of space_info->groups_sem.
> Noticed-by: Filipe Manana <fdmanana@gmail.com>
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

I would have made the check in the "if" statement below that is
already done while holding a write lock on the semaphore (smaller code
diff), but this is equally correct.

thanks

> ---
>  fs/btrfs/extent-tree.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 79a5bd9..ed9426c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10010,8 +10010,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>                 block_group = list_first_entry(&fs_info->unused_bgs,
>                                                struct btrfs_block_group_cache,
>                                                bg_list);
> -               space_info = block_group->space_info;
>                 list_del_init(&block_group->bg_list);
> +
> +               space_info = block_group->space_info;
> +
> +               down_read(&space_info->groups_sem);
> +               if (block_group->list.next == block_group->list.prev) {
> +                       up_read(&space_info->groups_sem);
> +                       btrfs_put_block_group(block_group);
> +                       continue;
> +               }
> +               up_read(&space_info->groups_sem);
> +
>                 if (ret || btrfs_mixed_space_info(space_info)) {
>                         btrfs_put_block_group(block_group);
>                         continue;
> --
> 1.8.5.1
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
