Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34190 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdEQVDR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 17:03:17 -0400
Received: by mail-wr0-f194.google.com with SMTP id 6so3578973wrb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 14:03:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9ef08ee9-526f-d7df-ae9d-f7777716908f@suse.com>
References: <1495033663-15610-1-git-send-email-nborisov@suse.com>
 <CADfjVrg9OByV7rLEtRPKywJRJgRh5cVtrmC+GXLLv_24UfyFBw@mail.gmail.com>
 <bee0d0c0-2c8a-9654-4dde-6bd736527d99@suse.com> <CADfjVrhC1U4Wd9PfOZP-Bb0CouocMrbo+kuHW2p_rp2Y7E_etA@mail.gmail.com>
 <9ef08ee9-526f-d7df-ae9d-f7777716908f@suse.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 17 May 2017 17:02:35 -0400
Message-ID: <CADfjVrius7ve+QjYFu40TMPajkVQSEtuOJLWzbsfaQx9Y_dyuA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: Separate space_info create/update
To: Jeff Mahoney <jeffm@suse.com>
Cc: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 4:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 5/17/17 4:52 PM, Noah Massey wrote:
>> On Wed, May 17, 2017 at 4:34 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>
>>>
>>> On 17.05.2017 21:57, Noah Massey wrote:
>>>> On Wed, May 17, 2017 at 11:07 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>>>>> Currently the struct space_info creation code is intermixed in the
>>>>> udpate_space_info function. There are well-defined points at which the we
>>>>
>>>> ^^^ update_space_info
>>>>
>>>>> actually want to create brand-new space_info structs (e.g. during mount of
>>>>> the filesystem as well as sometimes when adding/initialising new chunks). In
>>>>> such cases udpate_space_info is called with 0 as the bytes parameter. All of
>>>>> this makes for spaghetti code.
>>>>>
>>>>> Fix it by factoring out the creation code in a separate create_space_info
>>>>> structure. This also allows to simplify the internals. Furthermore it will
>>>>> make the update_space_info function not fail, allowing to remove error
>>>>> handling in callers. This will come in a follow up patch.
>>>>>
>>>>> This bears no functional changes
>>>>>
>>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>>> Reviewed-by: Jeff Mahoney <jeffm@suse.com>
>>>>> ---
>>>>>  fs/btrfs/extent-tree.c | 127 ++++++++++++++++++++++++-------------------------
>>>>>  1 file changed, 62 insertions(+), 65 deletions(-)
>>>>>
>>>>> Change since v1:
>>>>>
>>>>>  Incorporated Jeff Mahoney's feedback and added his reviewed-by
>>>>>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index be5477676cc8..28848e45b018 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -3914,15 +3914,58 @@ static const char *alloc_name(u64 flags)
>>>>>         };
>>>>>  }
>>>>>
>>>>> +static int create_space_info(struct btrfs_fs_info *info, u64 flags,
>>>>> +                            struct btrfs_space_info **new) {
>>>>> +
>>>>> +       struct btrfs_space_info *space_info;
>>>>> +       int i;
>>>>> +       int ret;
>>>>> +
>>>>> +       space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
>>>>> +       if (!space_info)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       ret = percpu_counter_init(&space_info->total_bytes_pinned, 0, GFP_KERNEL);
>>>>> +       if (ret) {
>>>>> +               kfree(space_info);
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
>>>>> +               INIT_LIST_HEAD(&space_info->block_groups[i]);
>>>>> +       init_rwsem(&space_info->groups_sem);
>>>>> +       spin_lock_init(&space_info->lock);
>>>>> +       space_info->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
>>>>> +       space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
>>>>> +       init_waitqueue_head(&space_info->wait);
>>>>> +       INIT_LIST_HEAD(&space_info->ro_bgs);
>>>>> +       INIT_LIST_HEAD(&space_info->tickets);
>>>>> +       INIT_LIST_HEAD(&space_info->priority_tickets);
>>>>> +
>>>>> +       ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
>>>>> +                                   info->space_info_kobj, "%s",
>>>>> +                                   alloc_name(space_info->flags));
>>>>> +       if (ret) {
>>>>> +               percpu_counter_destroy(&space_info->total_bytes_pinned);
>>>>> +               kfree(space_info);
>>>>> +               return ret;
>>>>> +       }
>>>>> +
>>>>> +       *new = space_info;
>>>>> +       list_add_rcu(&space_info->list, &info->space_info);
>>>>> +       if (flags & BTRFS_BLOCK_GROUP_DATA)
>>>>> +               info->data_sinfo = space_info;
>>>>> +
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>>  static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>>>>>                              u64 total_bytes, u64 bytes_used,
>>>>>                              u64 bytes_readonly,
>>>>>                              struct btrfs_space_info **space_info)
>>>>>  {
>>>>>         struct btrfs_space_info *found;
>>>>> -       int i;
>>>>>         int factor;
>>>>> -       int ret;
>>>>>
>>>>>         if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
>>>>>                      BTRFS_BLOCK_GROUP_RAID10))
>>>>> @@ -3946,53 +3989,6 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>>>>>                 *space_info = found;
>>>>>                 return 0;
>>>>>         }
>>>>> -       found = kzalloc(sizeof(*found), GFP_NOFS);
>>>>> -       if (!found)
>>>>> -               return -ENOMEM;
>>>>> -
>>>>> -       ret = percpu_counter_init(&found->total_bytes_pinned, 0, GFP_KERNEL);
>>>>> -       if (ret) {
>>>>> -               kfree(found);
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>> -       for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
>>>>> -               INIT_LIST_HEAD(&found->block_groups[i]);
>>>>> -       init_rwsem(&found->groups_sem);
>>>>> -       spin_lock_init(&found->lock);
>>>>> -       found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
>>>>> -       found->total_bytes = total_bytes;
>>>>> -       found->disk_total = total_bytes * factor;
>>>>> -       found->bytes_used = bytes_used;
>>>>> -       found->disk_used = bytes_used * factor;
>>>>> -       found->bytes_pinned = 0;
>>>>> -       found->bytes_reserved = 0;
>>>>> -       found->bytes_readonly = bytes_readonly;
>>>>> -       found->bytes_may_use = 0;
>>>>> -       found->full = 0;
>>>>> -       found->max_extent_size = 0;
>>>>> -       found->force_alloc = CHUNK_ALLOC_NO_FORCE;
>>>>> -       found->chunk_alloc = 0;
>>>>> -       found->flush = 0;
>>>>> -       init_waitqueue_head(&found->wait);
>>>>> -       INIT_LIST_HEAD(&found->ro_bgs);
>>>>> -       INIT_LIST_HEAD(&found->tickets);
>>>>> -       INIT_LIST_HEAD(&found->priority_tickets);
>>>>> -
>>>>> -       ret = kobject_init_and_add(&found->kobj, &space_info_ktype,
>>>>> -                                   info->space_info_kobj, "%s",
>>>>> -                                   alloc_name(found->flags));
>>>>> -       if (ret) {
>>>>> -               kfree(found);
>>>>> -               return ret;
>>>>> -       }
>>>>> -
>>>>> -       *space_info = found;
>>>>> -       list_add_rcu(&found->list, &info->space_info);
>>>>> -       if (flags & BTRFS_BLOCK_GROUP_DATA)
>>>>> -               info->data_sinfo = found;
>>>>> -
>>>>> -       return ret;
>>>>>  }
>>>>>
>>>>>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
>>>>> @@ -4495,10 +4491,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>>>>>
>>>>>         space_info = __find_space_info(fs_info, flags);
>>>>>         if (!space_info) {
>>>>> -               ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
>>>>> +               ret = create_space_info(fs_info, flags, &space_info);
>>>>>                 BUG_ON(ret); /* -ENOMEM */
>>>>>         }
>>>>> -       BUG_ON(!space_info); /* Logic error */
>>>>
>>>> Isn't removing this BUG_ON a functional change?
>>>> I understand that it shouldn't happen in the current incarnation of
>>>> create_space_info, but that was true before the patch as well
>>>
>>> No, because this bug_on would have triggere only if !space_info, and
>>> this condition would have, in turn, triggered the if statement, which
>>> has a BUG_ON(ret). E.g. in case ret is 0 then space_info will definitely
>>> be set. Hence BUG_ON(!space_info) is redundant.
>>>
>>
>> But the BUG_ON(ret) value is independent of BUG_ON(!space_info)
>> The BUG_ON(!space_info) seems to have been there to catch a potential
>> logic error if update_space_info is modified / regressed to return 0
>> and still not set space_info pointer, so removing the BUG_ON seems to
>> be a change separate from the switch to create_space_info.
>
> The BUG_ON(!space_info) is older than the call to update_space_info().
> It should've been removed when we started creating the space info there.
>
> -Jeff

Understood.
Thank you for your patience.

~ Noah
