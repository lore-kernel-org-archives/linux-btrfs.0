Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34415 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdFGScq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 14:32:46 -0400
Received: by mail-oi0-f43.google.com with SMTP id o65so9287106oif.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 11:32:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170607182303.GE7481@vader.DHCP.thefacebook.com>
References: <20170607180930.GA12551@ircssh-2.c.rugged-nimbus-611.internal> <20170607182303.GE7481@vader.DHCP.thefacebook.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Wed, 7 Jun 2017 11:32:04 -0700
Message-ID: <CAMp4zn9J7SUETL1aEoSEUXSd+VwdAPGuKaP6j_jC2biA--Q2Fg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Convert btrfs_fs_info's free_chunk_space to an atomic64_t
To: Omar Sandoval <osandov@osandov.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 7, 2017 at 11:23 AM, Omar Sandoval <osandov@osandov.com> wrote:
> On Wed, Jun 07, 2017 at 06:09:33PM +0000, Sargun Dhillon wrote:
>> This patch is a small performance optimization to get rid of a spin
>> lock, where instead an atomic64_t can be used.
>>
>> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> [snip]
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 017b67d..0123974 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2417,9 +2417,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>       fs_info->fs_devices->total_devices++;
>>       fs_info->fs_devices->total_rw_bytes += device->total_bytes;
>>
>> -     spin_lock(&fs_info->free_chunk_lock);
>> -     fs_info->free_chunk_space += device->total_bytes;
>> -     spin_unlock(&fs_info->free_chunk_lock);
>> +     atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
>>
>>       if (!blk_queue_nonrot(q))
>>               fs_info->fs_devices->rotating = 1;
>> @@ -2874,9 +2872,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>>                       mutex_lock(&fs_info->chunk_mutex);
>>                       btrfs_device_set_bytes_used(device,
>>                                       device->bytes_used - dev_extent_len);
>> -                     spin_lock(&fs_info->free_chunk_lock);
>> -                     fs_info->free_chunk_space += dev_extent_len;
>> -                     spin_unlock(&fs_info->free_chunk_lock);
>> +                     atomic64_add(dev_extent_len, &fs_info->free_chunk_space);
>>                       btrfs_clear_space_info_full(fs_info);
>>                       mutex_unlock(&fs_info->chunk_mutex);
>>               }
>> @@ -4409,9 +4405,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>>       btrfs_device_set_total_bytes(device, new_size);
>>       if (device->writeable) {
>>               device->fs_devices->total_rw_bytes -= diff;
>> -             spin_lock(&fs_info->free_chunk_lock);
>> -             fs_info->free_chunk_space -= diff;
>> -             spin_unlock(&fs_info->free_chunk_lock);
>> +             atomic64_sub(diff, &fs_info->free_chunk_space);
>>       }
>>       mutex_unlock(&fs_info->chunk_mutex);
>>
>> @@ -4535,9 +4529,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>>               btrfs_device_set_total_bytes(device, old_size);
>>               if (device->writeable)
>>                       device->fs_devices->total_rw_bytes += diff;
>> -             spin_lock(&fs_info->free_chunk_lock);
>> -             fs_info->free_chunk_space += diff;
>> -             spin_unlock(&fs_info->free_chunk_lock);
>> +             atomic64_add(diff, &fs_info->free_chunk_space);
>>               mutex_unlock(&fs_info->chunk_mutex);
>>       }
>>       return ret;
>> @@ -4882,9 +4874,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>>               btrfs_device_set_bytes_used(map->stripes[i].dev, num_bytes);
>>       }
>>
>> -     spin_lock(&info->free_chunk_lock);
>> -     info->free_chunk_space -= (stripe_size * map->num_stripes);
>> -     spin_unlock(&info->free_chunk_lock);
>> +     atomic64_sub((stripe_size * map->num_stripes), &info->free_chunk_space);
>
> Can you please get rid of the extra parentheses around the
> multiplication here? Also curious if you were able to measure any sort
> of performance difference. Besides that,
Sure.

According to lock stats, this spinlock was accounting for a little bit
more than 1% of time in transactions on our workload. The latency
benefit in synthetic testing was not significant, but the fewer
spurious locks we're measuring, means that perf locks, and bpf
profiling is at a lower cost.
>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
>
>>
>>       free_extent_map(em);
>>       check_raid56_incompat_flag(info, type);
>> @@ -6684,10 +6674,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>>       device->in_fs_metadata = 1;
>>       if (device->writeable && !device->is_tgtdev_for_dev_replace) {
>>               device->fs_devices->total_rw_bytes += device->total_bytes;
>> -             spin_lock(&fs_info->free_chunk_lock);
>> -             fs_info->free_chunk_space += device->total_bytes -
>> -                     device->bytes_used;
>> -             spin_unlock(&fs_info->free_chunk_lock);
>> +             atomic64_add(device->total_bytes - device->bytes_used,
>> +                          &fs_info->free_chunk_space);
>>       }
>>       ret = 0;
>>       return ret;
>> --
>> 2.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
