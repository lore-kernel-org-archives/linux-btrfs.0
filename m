Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20805 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805AbcAOBny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 20:43:54 -0500
Subject: Re: [PATCH v4 13/18] btrfs: dedup: Add support to delete hash for
 on-disk backend
To: <fdmanana@gmail.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1452751054-2365-14-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H4fJvm_xNSgXNTk0cgfbPUA5Gfja5waU+RkHu+TCzEmuw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56984ECF.5030305@cn.fujitsu.com>
Date: Fri, 15 Jan 2016 09:43:43 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4fJvm_xNSgXNTk0cgfbPUA5Gfja5waU+RkHu+TCzEmuw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/01/14 10:19 +0000:
> On Thu, Jan 14, 2016 at 5:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Now on-disk backend can delete hash now.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/dedup.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 93 insertions(+)
>>
>> diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
>> index 4acbbfb..66c8f05 100644
>> --- a/fs/btrfs/dedup.c
>> +++ b/fs/btrfs/dedup.c
>> @@ -437,6 +437,97 @@ static int inmem_del(struct btrfs_dedup_info *dedup_info, u64 bytenr)
>>          return 0;
>>   }
>>
>> +/*
>> + * If prepare_del is given, this will setup search_slot() for delete.
>> + * Caller needs to do proper locking.
>> + *
>> + * Return > 0 for found.
>> + * Return 0 for not found.
>> + * Return < 0 for error.
>> + */
>> +static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
>> +                               struct btrfs_dedup_info *dedup_info,
>> +                               struct btrfs_path *path, u64 bytenr,
>> +                               int prepare_del)
>> +{
>> +       struct btrfs_key key;
>> +       struct btrfs_root *dedup_root = dedup_info->dedup_root;
>> +       int ret;
>> +       int ins_len = 0;
>> +       int cow = 0;
>> +
>> +       if (prepare_del) {
>> +               if (WARN_ON(trans == NULL))
>> +                       return -EINVAL;
>> +               cow = 1;
>> +               ins_len = -1;
>> +       }
>> +
>> +       key.objectid = bytenr;
>> +       key.type = BTRFS_DEDUP_BYTENR_ITEM_KEY;
>> +       key.offset = (u64)-1;
>> +
>> +       ret = btrfs_search_slot(trans, dedup_root, &key, path,
>> +                               ins_len, cow);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       WARN_ON(ret == 0);
>
> If ret == 0 (who knows if one day there won't be an hash algorithm
> that produces 64 bits hashes with all bits set for some inputs), then
> we shouldn't do the btrfs_previous_item() call, which would make us
> miss the item.

That's right, and it doesn't even need another algorithm, since at least 
in theory, SHA256 should also be able to produce such hash (only need to 
be all 1 for the last 64bits).

I'll change it to skip the previous_item() if ret == 0.

Thanks,
Qu

>
>> +       ret = btrfs_previous_item(dedup_root, path, bytenr,
>> +                                 BTRFS_DEDUP_BYTENR_ITEM_KEY);
>> +       if (ret < 0)
>> +               return ret;
>> +       if (ret > 0)
>> +               return 0;
>> +       return 1;
>> +}
>> +
>> +static int ondisk_del(struct btrfs_trans_handle *trans,
>> +                     struct btrfs_dedup_info *dedup_info, u64 bytenr)
>> +{
>> +       struct btrfs_root *dedup_root = dedup_info->dedup_root;
>> +       struct btrfs_path *path;
>> +       struct btrfs_key key;
>> +       int ret;
>> +
>> +       path = btrfs_alloc_path();
>> +       if (!path)
>> +               return -ENOMEM;
>> +
>> +       key.objectid = bytenr;
>> +       key.type = BTRFS_DEDUP_BYTENR_ITEM_KEY;
>> +       key.offset = 0;
>> +
>> +       mutex_lock(&dedup_info->lock);
>> +
>> +       ret = ondisk_search_bytenr(trans, dedup_info, path, bytenr, 1);
>> +       if (ret <= 0)
>> +               goto out;
>> +
>> +       btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +       btrfs_del_item(trans, dedup_root, path);
>> +       btrfs_release_path(path);
>> +
>> +       /* Search for hash item and delete it */
>> +       key.objectid = key.offset;
>> +       key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
>> +       key.offset = bytenr;
>> +
>> +       ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
>> +       if (WARN_ON(ret > 0)) {
>> +               ret = -ENOENT;
>> +               goto out;
>> +       }
>> +       if (ret < 0)
>> +               goto out;
>> +       btrfs_del_item(trans, dedup_root, path);
>
> btrfs_del_item() can return errors.
>
>> +
>> +out:
>> +       btrfs_free_path(path);
>> +       mutex_unlock(&dedup_info->lock);
>> +       return ret;
>> +}
>> +
>>   /* Remove a dedup hash from dedup tree */
>>   int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>                      u64 bytenr)
>> @@ -449,6 +540,8 @@ int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>
>>          if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
>>                  return inmem_del(dedup_info, bytenr);
>> +       if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
>> +               return ondisk_del(trans, dedup_info, bytenr);
>>          return -EINVAL;
>>   }
>>
>> --
>> 2.7.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


