Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34241 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdEVDFP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 23:05:15 -0400
Received: by mail-oi0-f47.google.com with SMTP id b204so145878965oii.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 20:05:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69628eef-98e0-a912-99d4-7896cd7459ab@cn.fujitsu.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Sun, 21 May 2017 20:04:34 -0700
Message-ID: <CAMp4zn9MHgOoOTOLRfr05fkntbO7iRy=v4ZDy6m2vWjd_MG5gA@mail.gmail.com>
Subject: Re: [PATCH 6/8] btrfs: Add code to check if a qgroup's subvol exists
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520083944.GA4244@ircssh-2.c.rugged-nimbus-611.internal>
 <69628eef-98e0-a912-99d4-7896cd7459ab@cn.fujitsu.com>

On Sun, May 21, 2017 at 6:39 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 05/20/2017 04:39 PM, Sargun Dhillon wrote:
>>
>> This patch is to prepare for following patches in this patchset. The
>> purpose is to make it so that we can prevent accidental removal of
>> qgroups that are actively in use.
>>
>> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
>> ---
>>   fs/btrfs/ioctl.c  |  4 ++--
>>   fs/btrfs/qgroup.c | 50
>> +++++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/qgroup.h |  3 ++-
>>   3 files changed, 53 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index b10d7bb..2b1a8c1 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2554,7 +2554,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct
>> file *file,
>>          */
>>         if (!btrfs_test_opt(fs_info, QGROUP_KEEP)) {
>>                 ret = btrfs_remove_qgroup(trans, fs_info,
>> -                                         dest->root_key.objectid);
>> +                                         dest->root_key.objectid, 0);
>>                 if (ret && ret != -ENOENT)
>>                         pr_info("Could not automatically delete qgroup:
>> %d\n", ret);
>>         }
>> @@ -4974,7 +4974,7 @@ static long btrfs_ioctl_qgroup_create(struct file
>> *file, void __user *arg)
>>         if (sa->create) {
>>                 ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
>>         } else {
>> -               ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid);
>> +               ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid,
>> 0);
>>         }
>>         err = btrfs_end_transaction(trans);
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 588248b..a0699fd 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1247,6 +1247,45 @@ int btrfs_del_qgroup_relation(struct
>> btrfs_trans_handle *trans,
>>         return ret;
>>   }
>>   +/*
>> + * Meant to only operate on level-0 qroupid.
>> + *
>> + * It returns 1 if a matching subvolume is found; 0 if none is found.
>> + * < 0 if there is an error.
>> + */
>> +static int btrfs_subvolume_exists(struct btrfs_fs_info *fs_info, u64
>> qgroupid)
>> +{
>> +       struct btrfs_path *path;
>> +       struct btrfs_key key;
>> +       int err, ret = 0;
>> +
>> +       path = btrfs_alloc_path();
>> +       if (!path)
>> +               return -ENOMEM;
>> +
>> +       key.objectid = qgroupid;
>> +       key.type = BTRFS_ROOT_BACKREF_KEY;
>
>
> Fs root (subvolume id equals to 5) has no ROOT_BACKREF key.
> Such search would make fs tree always treated as not existed.
Is it okay to just explicitly exempt 5, or is there a better way to do
this search?

>
> Thanks,
> Qu
>
>> +       key.offset = 0;
>> +
>> +       err = btrfs_search_slot_for_read(fs_info->tree_root, &key, path,
>> 1, 0);
>> +       if (err == 1)
>> +               goto out;
>> +
>> +       if (err) {
>> +               ret = err;
>> +               goto out;
>> +       }
>> +
>> +       btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +       if (key.objectid != qgroupid || key.type !=
>> BTRFS_ROOT_BACKREF_KEY)
>> +               goto out;
>> +
>> +       ret = 1;
>> +out:
>> +       btrfs_free_path(path);
>> +       return ret;
>> +}
>> +
>>   /* Must be called with qgroup_ioctl_lock held */
>>   static int __btrfs_create_qgroup(struct btrfs_trans_handle *trans,
>>                                  struct btrfs_fs_info *fs_info, u64
>> qgroupid)
>> @@ -1333,10 +1372,19 @@ static int __btrfs_remove_qgroup(struct
>> btrfs_trans_handle *trans,
>>   }
>>     int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>> -                       struct btrfs_fs_info *fs_info, u64 qgroupid)
>> +                       struct btrfs_fs_info *fs_info, u64 qgroupid,
>> +                       int check_in_use)
>>   {
>>         int ret;
>>   +     if (check_in_use && btrfs_qgroup_level(qgroupid) == 0) {
>> +               ret = btrfs_subvolume_exists(fs_info, qgroupid);
>> +               if (ret < 0)
>> +                       return ret;
>> +               if (ret)
>> +                       return -EBUSY;
>> +       }
>> +
>>         mutex_lock(&fs_info->qgroup_ioctl_lock);
>>         ret = __btrfs_remove_qgroup(trans, fs_info, qgroupid);
>>         mutex_unlock(&fs_info->qgroup_ioctl_lock);
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index fb6c7da..fc08bdb 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -127,7 +127,8 @@ int btrfs_del_qgroup_relation(struct
>> btrfs_trans_handle *trans,
>>   int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
>>                         struct btrfs_fs_info *fs_info, u64 qgroupid);
>>   int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
>> -                       struct btrfs_fs_info *fs_info, u64 qgroupid);
>> +                       struct btrfs_fs_info *fs_info, u64 qgroupid,
>> +                       int check_in_use);
>>   int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
>>                        struct btrfs_fs_info *fs_info, u64 qgroupid,
>>                        struct btrfs_qgroup_limit *limit);
>>
>
>
