Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33072 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbI3QHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:07:08 -0400
Received: by wiclk2 with SMTP id lk2so205957695wic.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 09:07:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433252601-14088-1-git-send-email-fdmanana@kernel.org>
References: <1433252601-14088-1-git-send-email-fdmanana@kernel.org>
Date: Wed, 30 Sep 2015 18:07:06 +0200
Message-ID: <CAOcd+r0+W99107GxQ69cywMFT8hyC+seu+fWCCzpPkLkW_kY7w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: check pending chunks when shrinking fs to avoid corruption
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: fdmanana@kernel.org
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

Looking the code of this patch, I see that if we discover a pending
chunk, we unlock the chunk mutex, commit the transaction (which
completes the allocation of all pending chunks and inserts relevant
items into the device tree and chunk tree), and retry the search.

However, after we unlock the chunk mutex, somebody could have
attempted a new chunk allocation, which would have resulted in new
pending chunk. On the other hand, we have done:

btrfs_device_set_total_bytes(device, new_size);

so this line should prevent anybody to allocate beyond the new size.
In that case, we are sure that on the seconds pass there will be no
pending chunks beyond the new size, so we can shrink to new_size
safely. Is my understanding correct?

Thanks,
Alex.



On Tue, Jun 2, 2015 at 3:43 PM,  <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> When we shrink the usable size of a device (its total_bytes), we go over
> all the device extent items in the device tree and attempt to relocate
> the chunk of any device extent that goes beyond the new usable size for
> the device. We do that after setting the new usable size (total_bytes) in
> the device object, so that all new allocations (and reallocations) don't
> use areas of the device that go beyond the new (shorter) size. However we
> were not considering that before setting the new size in the device,
> pending chunks might have been created that use device extents that go
> beyond the new size, and those device extents are not yet in the device
> tree after we search the device tree - they are still attached to the
> list of new block group for some ongoing transaction handle, and they are
> only added to the device tree when the transaction handle is ended (via
> btrfs_create_pending_block_groups()).
>
> So check for pending chunks with device extents that go beyond the new
> size and if any exists, commit the current transaction and repeat the
> search in the device tree.
>
> Not doing this it would mean we would return success to user space while
> still having extents that go beyond the new size, and later user space
> could override those locations on the device while the fs still references
> them, causing all sorts of corruption and unexpected events.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/volumes.c | 49 ++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 40 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index dbea12e..09e89a6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3984,6 +3984,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>         int slot;
>         int failed = 0;
>         bool retried = false;
> +       bool checked_pending_chunks = false;
>         struct extent_buffer *l;
>         struct btrfs_key key;
>         struct btrfs_super_block *super_copy = root->fs_info->super_copy;
> @@ -4064,15 +4065,6 @@ again:
>                 goto again;
>         } else if (failed && retried) {
>                 ret = -ENOSPC;
> -               lock_chunks(root);
> -
> -               btrfs_device_set_total_bytes(device, old_size);
> -               if (device->writeable)
> -                       device->fs_devices->total_rw_bytes += diff;
> -               spin_lock(&root->fs_info->free_chunk_lock);
> -               root->fs_info->free_chunk_space += diff;
> -               spin_unlock(&root->fs_info->free_chunk_lock);
> -               unlock_chunks(root);
>                 goto done;
>         }
>
> @@ -4084,6 +4076,35 @@ again:
>         }
>
>         lock_chunks(root);
> +
> +       /*
> +        * We checked in the above loop all device extents that were already in
> +        * the device tree. However before we have updated the device's
> +        * total_bytes to the new size, we might have had chunk allocations that
> +        * have not complete yet (new block groups attached to transaction
> +        * handles), and therefore their device extents were not yet in the
> +        * device tree and we missed them in the loop above. So if we have any
> +        * pending chunk using a device extent that overlaps the device range
> +        * that we can not use anymore, commit the current transaction and
> +        * repeat the search on the device tree - this way we guarantee we will
> +        * not have chunks using device extents that end beyond 'new_size'.
> +        */
> +       if (!checked_pending_chunks) {
> +               u64 start = new_size;
> +               u64 len = old_size - new_size;
> +
> +               if (contains_pending_extent(trans, device, &start, len)) {
> +                       unlock_chunks(root);
> +                       checked_pending_chunks = true;
> +                       failed = 0;
> +                       retried = false;
> +                       ret = btrfs_commit_transaction(trans, root);
> +                       if (ret)
> +                               goto done;
> +                       goto again;
> +               }
> +       }
> +
>         btrfs_device_set_disk_total_bytes(device, new_size);
>         if (list_empty(&device->resized_list))
>                 list_add_tail(&device->resized_list,
> @@ -4098,6 +4119,16 @@ again:
>         btrfs_end_transaction(trans, root);
>  done:
>         btrfs_free_path(path);
> +       if (ret) {
> +               lock_chunks(root);
> +               btrfs_device_set_total_bytes(device, old_size);
> +               if (device->writeable)
> +                       device->fs_devices->total_rw_bytes += diff;
> +               spin_lock(&root->fs_info->free_chunk_lock);
> +               root->fs_info->free_chunk_space += diff;
> +               spin_unlock(&root->fs_info->free_chunk_lock);
> +               unlock_chunks(root);
> +       }
>         return ret;
>  }
>
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
