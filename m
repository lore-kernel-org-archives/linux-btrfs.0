Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:36177 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbBFJyw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 04:54:52 -0500
Received: by labgf13 with SMTP id gf13so70459lab.3
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 01:54:50 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1423212122-12952-2-git-send-email-zhaolei@cn.fujitsu.com>
References: <1423212122-12952-1-git-send-email-zhaolei@cn.fujitsu.com>
	<1423212122-12952-2-git-send-email-zhaolei@cn.fujitsu.com>
Date: Fri, 6 Feb 2015 09:54:50 +0000
Message-ID: <CAL3q7H7J6jw=dq+UbXs+Mz-PQcy7x8xfuHgQR+iLdJgdBuiZAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: Fix out-of-space bug caused by searching
 commit_root in find_free_dev_extent()
From: Filipe David Manana <fdmanana@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 6, 2015 at 8:42 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
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
> Btrfs get free disk space by calling find_free_dev_extent() when
> re-create chunk for write, but current code set search_commit_root
> flag in searching tree, so disk spaces which was freed from dev_tree
> but not commited can not get from find_free_dev_extent(), then
> btrfs report NO_SPACE on above case.

Yes, and that is correct.
If you re-use the same physical space within the same transaction,
write to it and a crash happens before writing the next super block
(transaction commit), the next time the fs is mounted it will have
data or metadata corrupted.

With your change this could happen:

1) Delete metadata block group X, which takes physical space [2G, 3G]
(assuming single metadata profile);

2) A chunk allocation for a data block group happens, and it gets that
same physical space in the range [2G, 3G];

3) Data is written into it - for e.g. due to memory pressure, the VM
calls writepages() for some inodes;

4) Crash/reboot happens before the transaction commits;

5) On the next mount, you have metadata corrupted - there's now file
data instead of btree nodes/leafs in metadata the block group at the
physical range [2G, 3G]

That said, unless I missed something, I disagree with this patch.

>
> Fix:
> Remove "path->search_commit_root = 1" in find_free_dev_extent().
>
> Tested by above script, and confirmed action with many printk.
>
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 50c5a87..5cd0930 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1147,7 +1147,6 @@ again:
>         }
>
>         path->reada = 2;
> -       path->search_commit_root = 1;
>         path->skip_locking = 1;
>
>         key.objectid = device->devid;
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
