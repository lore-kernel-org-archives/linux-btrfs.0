Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:46646 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbbBGOnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Feb 2015 09:43:19 -0500
Received: by lams18 with SMTP id s18so6187367lam.13
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 06:43:17 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1423317228-5307-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1423317228-5307-1-git-send-email-zhaolei@cn.fujitsu.com>
Date: Sat, 7 Feb 2015 14:43:17 +0000
Message-ID: <CAL3q7H5WRP3AaF_xXJXBDHKn9LvUUByfpzC5PJpTwmar_YV0Hw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: Fix out-of-space bug
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 7, 2015 at 1:53 PM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> Btrfs will report NO_SPACE when we create and remove files for several times:
> 1: Create a single-dev btrfs fs with default option
> 2: Write a file into it to take up most fs space
> 3: Delete above file
> 4: Wait about 100s to let chunk removed
> 5: goto 2
>
> Script is like following:
>  #!/bin/bash
>
>  # Recommend 1.2G space, too large disk will make test slow
>  DEV="/dev/sda16"
>  MNT="/mnt/tmp"
>
>  dev_size="$(lsblk -bn -o SIZE "$DEV")" || exit 2
>  file_size_m=$((dev_size * 75 / 100 / 1024 / 1024))
>
>  echo "Loop write ${file_size_m}M file on $((dev_size / 1024 / 1024))M dev"
>
>  for ((i = 0; i < 10; i++)); do umount "$MNT" 2>/dev/null; done
>  echo "mkfs $DEV"
>  mkfs.btrfs -f "$DEV" >/dev/null || exit 2
>  echo "mount $DEV $MNT"
>  mount "$DEV" "$MNT" || exit 2
>
>  for ((loop_i = 0; loop_i < 20; loop_i++)); do
>      echo
>      echo "loop $loop_i"
>
>      echo "dd file..."
>      cmd=(dd if=/dev/zero of="$MNT"/file0 bs=1M count="$file_size_m")
>      "${cmd[@]}" 2>/dev/null || {
>          # NO_SPACE error triggered
>          echo "dd failed: ${cmd[*]}"
>          exit 1
>      }
>
>      echo "rm file..."
>      rm -f "$MNT"/file0 || exit 2
>
>      for ((i = 0; i < 10; i++)); do
>          df "$MNT" | tail -1
>          sleep 10
>      done
>  done
>
> Reason:
> It is triggered by commit: 47ab2a6c689913db23ccae38349714edf8365e0a
> which is used to remove empty block groups automatically, but the
> reason is not in that patch. Code before works well because btrfs
> don't need to create and delete chunks so many times with high
> complexity.
>
> Reason1:
>  Btrfs get free disk space by calling find_free_dev_extent() when
>  re-create chunk for write, but current code set search_commit_root
>  flag in searching tree, so disk spaces which was freed from dev_tree
>  but not commited can not get from find_free_dev_extent(), then
>  btrfs report NO_SPACE on above case.
>  Fixed by this patch.
>
> Reason2:
>  When we remove some continuous chunks but leave other chunks after,
>  these disk space should be used by chunk-recreating, but in current
>  code, only first create will successed.
>  Fixed by Forrest Liu <forrestl@synology.com> in:
>  Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole
>
> Reason3:
>  contains_pending_extent() return wrong value in calculation.
>  Fixed by Forrest Liu <forrestl@synology.com> in:
>  Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole
>
> Changelog v1->v2:
>  V1 will introduce a new bug when create a metadata bg in space of
>  old data bg which was just removed, noticed by:
>  Filipe David Manana <fdmanana@gmail.com>
>  V2 fix this bug by commit transaction after remove block grops.

Well it's not specific to reusing the space from a deleted metadata
block group for a new data block group. This is true for any other
combination, even "data -> data". When using COW for both metadata and
data, if a crash happens before the transaction commits, it is
guaranteed that all data and metadata committed in the previous
transaction are available on the next mount (and all new data in the
current transaction if it was fsync'ed) - this applies to any COW
system, be it a filesystem or a database for example.

>
> Tested for severial times by above script.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a684086..67c85ff 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9653,6 +9653,10 @@ next:
>                 spin_lock(&fs_info->unused_bgs_lock);
>         }
>         spin_unlock(&fs_info->unused_bgs_lock);
> +       trans = btrfs_join_transaction(root);
> +       if (!IS_ERR(trans))
> +               btrfs_commit_transaction(trans, root);
> +

At the very least, before doing the commit, you should verify if any
block groups were actually deleted - under some conditions we skip
their deletion in the loop. Plus, it would be good to check if the sum
of the sizes of the deleted block groups exceeds some minimum
threshold (lets say 1G or 2G, whatever), so that we don't get the
overhead of committing a transaction for little or no gains.

I would also consider doing the commit only if the fs is really
running out of free space or close to being out of free space.

You can get into many similar cases of space not being released until
the transaction commits.
For example, create 10 files with a size of 1Gb each (via fallocate
for e.g.), and then truncate them all to a size of 1M in the same
transaction for example. You'll get 999Mb * 10 of space that won't be
available for use until the current transaction commits - it's exactly
the same problem you found, it just doesn't imply deleting whole block
groups/chunks.

Thanks

>  }
>
>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
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
