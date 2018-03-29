Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:53704 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeC2RbB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 13:31:01 -0400
Received: by mail-it0-f67.google.com with SMTP id m134-v6so9100668itb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 10:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <29571b59-d580-0386-59a8-527a255de41b@suse.com>
References: <1522275105-60516-1-git-send-email-bo.liu@linux.alibaba.com> <29571b59-d580-0386-59a8-527a255de41b@suse.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Thu, 29 Mar 2018 10:30:59 -0700
Message-ID: <CANQeFDD9BP9w_RSzHmamHi-c__Kw73xsZUR=jnUOjDyGBe=KsQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: print error messages when failing to read trees
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2018 at 11:24 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 29.03.2018 01:11, Liu Bo wrote:
>> When mount fails to read trees like fs tree, checksum tree, extent
>> tree, etc, there is not enough information about where went wrong.
>>
>> With this, messages like
>>
>> "BTRFS warning (device sdf): failed to read root (objectid=7): -5"
>>
>> would help us a bit.
>>
>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>> ---
>>  fs/btrfs/disk-io.c | 31 ++++++++++++++++++++++---------
>>  1 file changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 21f34ad..954616c 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2334,23 +2334,29 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
>>       location.offset = 0;
>>
>>       root = btrfs_read_tree_root(tree_root, &location);
>> -     if (IS_ERR(root))
>> -             return PTR_ERR(root);
>> +     if (IS_ERR(root)) {
>> +             ret = PTR_ERR(root);
>> +             goto out;
>> +     }
>>       set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
>>       fs_info->extent_root = root;
>>
>>       location.objectid = BTRFS_DEV_TREE_OBJECTID;
>>       root = btrfs_read_tree_root(tree_root, &location);
>> -     if (IS_ERR(root))
>> -             return PTR_ERR(root);
>> +     if (IS_ERR(root)) {
>> +             ret = PTR_ERR(root);
>> +             goto out;
>> +     }
>>       set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
>>       fs_info->dev_root = root;
>>       btrfs_init_devices_late(fs_info);
>>
>>       location.objectid = BTRFS_CSUM_TREE_OBJECTID;
>>       root = btrfs_read_tree_root(tree_root, &location);
>> -     if (IS_ERR(root))
>> -             return PTR_ERR(root);
>> +     if (IS_ERR(root)) {
>> +             ret = PTR_ERR(root);
>> +             goto out;
>> +     }
>>       set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
>>       fs_info->csum_root = root;
>>
>> @@ -2367,7 +2373,7 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
>>       if (IS_ERR(root)) {
>>               ret = PTR_ERR(root);
>>               if (ret != -ENOENT)
>> -                     return ret;
>> +                     goto out;
>>       } else {
>>               set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
>>               fs_info->uuid_root = root;
>> @@ -2376,13 +2382,19 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
>>       if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
>>               location.objectid = BTRFS_FREE_SPACE_TREE_OBJECTID;
>>               root = btrfs_read_tree_root(tree_root, &location);
>> -             if (IS_ERR(root))
>> -                     return PTR_ERR(root);
>> +             if (IS_ERR(root)) {
>> +                     ret = PTR_ERR(root);
>> +                     goto out;
>> +             }
>>               set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
>>               fs_info->free_space_root = root;
>>       }
>>
>>       return 0;
>> +out:
>> +     btrfs_warn(fs_info, "failed to read root (objectid=%llu): %d",
>> +                location.objectid, ret);
>
> Since those are critical errors don't we want btrfs_err here?
>

Not much difference to me, I followed the convention, after failing to
read tree roots and falling back to recovery tree roots array,
btrfs_warn is used.

tree_root->node = read_tree_block();
if () {
       btrfs_warn(...);
       goto recovery_tree_roots;
}

thanks,
liubo


>> +     return ret;
>>  }
>>
>>  int open_ctree(struct super_block *sb,
>> @@ -2953,6 +2965,7 @@ int open_ctree(struct super_block *sb,
>>       fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
>>       if (IS_ERR(fs_info->fs_root)) {
>>               err = PTR_ERR(fs_info->fs_root);
>> +             btrfs_warn(fs_info, "failed to read fs tree: %d", err);
>
> ditto
>
>>               goto fail_qgroup;
>>       }
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
