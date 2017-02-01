Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35952 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbdBAWhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 17:37:19 -0500
Received: by mail-it0-f65.google.com with SMTP id f200so4043031itf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Feb 2017 14:37:19 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170117011050.18843-2-quwenruo@cn.fujitsu.com>
References: <20170117011050.18843-1-quwenruo@cn.fujitsu.com> <20170117011050.18843-2-quwenruo@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 1 Feb 2017 22:37:18 +0000
Message-ID: <CAL3q7H5F0J0dnGPjqKamh5v8DdZnOHAhQFM9cUbjRkF3_1PciA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: replace: Use ref counts to avoid destroying
 target device when canceled
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 1:10 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> When dev-replace and scrub are run at the same time, dev-replace can be
> canceled by scrub. It's quite common for btrfs/069.
>
> While in that case, target device can be destroyed at cancel time,
> leading to a user-after-free bug:
>
>      Process A (dev-replace)         |         Process B(scrub)
> ----------------------------------------------------------------------
>                                      |(Any RW is OK)
>                                      |scrub_setup_recheck_block()
>                                      ||- btrfs_map_sblock()
>                                      |   Got a bbio with tgtdev
> btrfs_dev_replace_finishing()        |
> |- btrfs_destory_dev_replace_tgtdev()|
>    |- call_rcu(free_device)          |
>       |- __free_device()             |
>          |- kfree(device)            |
>                                      | Scrub worker:
>                                      | Access bbio->stripes[], which
>                                      | contains tgtdev.
>                                      | This triggers general protection.
>
> The bug is mostly obvious for RAID5/6 since raid56 choose to keep old
> rbio and rbio->bbio for later steal, this hugely enlarged the race
> window and makes it much easier to trigger the bug.
>
> This patch introduces 'tgtdev_refs' and 'tgtdev_wait' for btrfs_device
> to wait for all its user released the target device.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I haven't read the patch, but seeing it's a fix for the issue you
reported in the thread with the subject "v4.9-rc7 scrub kernel panic",
could you please include the dmesg trace in the changelog? This helps
people figuring out if there's a fix for an issue they're hitting...
(I just hit it today for example).

Thanks.

> ---
>  fs/btrfs/dev-replace.c |  7 ++++++-
>  fs/btrfs/volumes.c     | 36 +++++++++++++++++++++++++++++++++++-
>  fs/btrfs/volumes.h     | 10 ++++++++++
>  3 files changed, 51 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 5de280b9ad73..794a6a0bedf2 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -558,7 +558,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>                           rcu_str_deref(src_device->name),
>                           src_device->devid,
>                           rcu_str_deref(tgt_device->name));
> -       tgt_device->is_tgtdev_for_dev_replace = 0;
>         tgt_device->devid = src_device->devid;
>         src_device->devid = BTRFS_DEV_REPLACE_DEVID;
>         memcpy(uuid_tmp, tgt_device->uuid, sizeof(uuid_tmp));
> @@ -579,6 +578,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>
>         btrfs_dev_replace_unlock(dev_replace, 1);
>
> +       /*
> +        * Only change is_tgtdev_for_dev_replace flag after all its
> +        * users get released.
> +        */
> +       wait_target_device(tgt_device);
> +       tgt_device->is_tgtdev_for_dev_replace = 0;
>         btrfs_rm_dev_replace_blocked(fs_info);
>
>         btrfs_rm_dev_replace_remove_srcdev(fs_info, src_device);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bb8592e1a364..74a6ee981b78 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2064,6 +2064,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>         WARN_ON(!tgtdev);
>         mutex_lock(&fs_info->fs_devices->device_list_mutex);
>
> +       wait_target_device(tgtdev);
>         btrfs_sysfs_rm_device_link(fs_info->fs_devices, tgtdev);
>
>         if (tgtdev->bdev)
> @@ -2598,6 +2599,8 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>         device->is_tgtdev_for_dev_replace = 1;
>         device->mode = FMODE_EXCL;
>         device->dev_stats_valid = 1;
> +       atomic_set(&device->tgtdev_refs, 0);
> +       init_waitqueue_head(&device->tgtdev_wait);
>         set_blocksize(device->bdev, 4096);
>         device->fs_devices = fs_info->fs_devices;
>         list_add(&device->dev_list, &fs_info->fs_devices->devices);
> @@ -2624,6 +2627,8 @@ void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
>         tgtdev->sector_size = sectorsize;
>         tgtdev->fs_info = fs_info;
>         tgtdev->in_fs_metadata = 1;
> +       atomic_set(&tgtdev->tgtdev_refs, 0);
> +       init_waitqueue_head(&tgtdev->tgtdev_wait);
>  }
>
>  static noinline int btrfs_update_device(struct btrfs_trans_handle *trans,
> @@ -5302,6 +5307,32 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
>         return bbio;
>  }
>
> +static void pin_bbio_target_device(struct btrfs_bio *bbio)
> +{
> +       int i;
> +
> +       for (i = 0; i < bbio->num_stripes; i++) {
> +               struct btrfs_device *device = bbio->stripes[i].dev;
> +
> +               if (device->is_tgtdev_for_dev_replace)
> +                       atomic_inc(&device->tgtdev_refs);
> +       }
> +}
> +
> +static void unpin_bbio_target_device(struct btrfs_bio *bbio)
> +{
> +       int i;
> +
> +       for (i = 0; i < bbio->num_stripes; i++) {
> +               struct btrfs_device *device = bbio->stripes[i].dev;
> +
> +               if (device->is_tgtdev_for_dev_replace) {
> +                       atomic_dec(&device->tgtdev_refs);
> +                       wake_up(&device->tgtdev_wait);
> +               }
> +       }
> +}
> +
>  void btrfs_get_bbio(struct btrfs_bio *bbio)
>  {
>         WARN_ON(!atomic_read(&bbio->refs));
> @@ -5312,8 +5343,10 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
>  {
>         if (!bbio)
>                 return;
> -       if (atomic_dec_and_test(&bbio->refs))
> +       if (atomic_dec_and_test(&bbio->refs)) {
> +               unpin_bbio_target_device(bbio);
>                 kfree(bbio);
> +       }
>  }
>
>  static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
> @@ -5868,6 +5901,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>                 bbio->stripes[0].physical = physical_to_patch_in_first_stripe;
>                 bbio->mirror_num = map->num_stripes + 1;
>         }
> +       pin_bbio_target_device(bbio);
>  out:
>         if (dev_replace_is_ongoing) {
>                 btrfs_dev_replace_clear_lock_blocking(dev_replace);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 811328984702..1b4069dbe1c3 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -149,6 +149,10 @@ struct btrfs_device {
>         /* Counter to record the change of device stats */
>         atomic_t dev_stats_ccnt;
>         atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
> +
> +       /* To ensure we wait this target device before destroying it */
> +       atomic_t tgtdev_refs;
> +       wait_queue_head_t tgtdev_wait;
>  };
>
>  /*
> @@ -538,4 +542,10 @@ struct list_head *btrfs_get_fs_uuids(void);
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>
> +static inline void wait_target_device(struct btrfs_device *tgtdev)
> +{
> +       if (!tgtdev || !tgtdev->is_tgtdev_for_dev_replace)
> +               return;
> +       wait_event(tgtdev->tgtdev_wait, atomic_read(&tgtdev->tgtdev_refs) == 0);
> +}
>  #endif
> --
> 2.11.0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
