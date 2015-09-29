Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36178 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbbI2Pri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 11:47:38 -0400
Received: by igcrk20 with SMTP id rk20so80517751igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 08:47:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1a179aa4a1d534e4b31d0978e72a7a391f9b408d.1443534660.git.zhaolei@cn.fujitsu.com>
References: <585889cfca0895674926445c0a8caa84f8fc6184.1443534660.git.zhaolei@cn.fujitsu.com>
	<1a179aa4a1d534e4b31d0978e72a7a391f9b408d.1443534660.git.zhaolei@cn.fujitsu.com>
Date: Tue, 29 Sep 2015 16:47:37 +0100
Message-ID: <CAL3q7H7UU7vCGgo8+F8awHaTchVDCHnoBwXZ9H2C7c5j0h-RBw@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: Fix lost-data-profile caused by balance bg
From: Filipe Manana <fdmanana@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 2:51 PM, Zhao Lei <zhaolei@cn.fujitsu.com> wrote:
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
>  btrfs balance start -dusage=0 $TEST_DIR
>  btrfs filesystem usage $TEST_DIR
>
>  dd if=/dev/zero of="$TEST_DIR"/file count=100
>  btrfs filesystem usage $TEST_DIR
>
> Result:
>  We can see "no data chunk" in first "btrfs filesystem usage":
>  # btrfs filesystem usage $TEST_DIR
>  Overall:
>     ...
>  Metadata,single: Size:8.00MiB, Used:0.00B
>     /dev/vdg        8.00MiB
>  Metadata,RAID1: Size:122.88MiB, Used:112.00KiB
>     /dev/vdg      122.88MiB
>     /dev/vdh      122.88MiB
>  System,single: Size:4.00MiB, Used:0.00B
>     /dev/vdg        4.00MiB
>  System,RAID1: Size:8.00MiB, Used:16.00KiB
>     /dev/vdg        8.00MiB
>     /dev/vdh        8.00MiB
>  Unallocated:
>     /dev/vdg        1.06GiB
>     /dev/vdh        1.07GiB
>
>  And "data chunks changed from raid1 to single" in second
>  "btrfs filesystem usage":
>  # btrfs filesystem usage $TEST_DIR
>  Overall:
>     ...
>  Data,single: Size:256.00MiB, Used:0.00B
>     /dev/vdh      256.00MiB
>  Metadata,single: Size:8.00MiB, Used:0.00B
>     /dev/vdg        8.00MiB
>  Metadata,RAID1: Size:122.88MiB, Used:112.00KiB
>     /dev/vdg      122.88MiB
>     /dev/vdh      122.88MiB
>  System,single: Size:4.00MiB, Used:0.00B
>     /dev/vdg        4.00MiB
>  System,RAID1: Size:8.00MiB, Used:16.00KiB
>     /dev/vdg        8.00MiB
>     /dev/vdh        8.00MiB
>  Unallocated:
>     /dev/vdg        1.06GiB
>     /dev/vdh      841.92MiB
>
> Reason:
>  btrfs balance delete last data chunk in case of no data in
>  the filesystem, then we can see "no data chunk" by "fi usage"
>  command.
>
>  And when we do write operation to fs, the only available data
>  profile is 0x0, result is all new chunks are allocated single type.
>
> Fix:
>  Allocate a data chunk explicitly in balance operation, to reserve
>  at least one data chunk in the filesystem.

Allocate a data chunk explicitly to ensure we don't lose the raid
profile for data.

>
> Test:
>  Test by above script, and confirmed the logic by debug output.
>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6fc73586..3d5e41e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3277,6 +3277,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>         u64 limit_data = bctl->data.limit;
>         u64 limit_meta = bctl->meta.limit;
>         u64 limit_sys = bctl->sys.limit;
> +       int chunk_reserved = 0;
>
>         /* step one make some room on all the devices */
>         devices = &fs_info->fs_devices->devices;
> @@ -3387,6 +3388,24 @@ again:
>                         goto loop;
>                 }
>
> +               if (!chunk_reserved) {
> +                       trans = btrfs_start_transaction(chunk_root, 0);
> +                       if (IS_ERR(trans)) {
> +                               mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> +                               ret = PTR_ERR(trans);
> +                               goto error;
> +                       }
> +
> +                       ret = btrfs_force_chunk_alloc(trans, chunk_root, 1);

Can we please use the symbol BTRFS_BLOCK_GROUP_DATA instead of 1?

> +                       if (ret < 0) {
> +                               mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> +                               goto error;
> +                       }
> +
> +                       btrfs_end_transaction(trans, chunk_root);
> +                       chunk_reserved = 1;
> +               }

Can we do this logic only if the block group is a data one? I.e. no
point allocating a data block group if our balance only touches
metadata ones (due to some filter for e.g.).

Also, can't this be ineffective when the data block group we allocate
ends up with a key  in the chunk_root that is lower than the key we
found in the current iteration? I.e., key found in current iteration
has object id B, we allocate a new block group which gets a  key with
object id A, where A < B and the next iteration of our loop sees key
A, deletes the respective block group A if it's empty. In the end we
have no data block groups, assuming that before A there are no other
non-empty data block groups.
Your example works because there's no free space before the offset
where the chunk starts in the device.

thanks

> +
>                 ret = btrfs_relocate_chunk(chunk_root,
>                                            found_key.offset);
>                 mutex_unlock(&fs_info->delete_unused_bgs_mutex);
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
