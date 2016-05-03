Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25867 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932334AbcECA4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 20:56:39 -0400
Subject: Re: [PATCH RFC 04/16] btrfs-progs: fsck: Introduce function to check
 referencer of a backref
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-5-git-send-email-quwenruo@cn.fujitsu.com>
 <1d696d31-da61-7e99-6639-692c7b05240f@fb.com>
 <12c81894-9495-fa86-63ce-4ce38def5e0e@cn.fujitsu.com>
 <3e5e5326-0d9c-2f98-08ef-c37ef4c63387@fb.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3b3f920e-6c91-3f0c-06bc-020666f43df2@cn.fujitsu.com>
Date: Tue, 3 May 2016 08:56:31 +0800
MIME-Version: 1.0
In-Reply-To: <3e5e5326-0d9c-2f98-08ef-c37ef4c63387@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2016/04/29 09:52 -0400:
> On 04/29/2016 01:31 AM, Qu Wenruo wrote:
>>
>>
>> Josef Bacik wrote on 2016/04/28 10:17 -0400:
>>> On 04/25/2016 11:48 PM, Qu Wenruo wrote:
>>>> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>>
>>>> Introduce a new function check_tree_block_backref() to check if a
>>>> backref points to correct referencer.
>>>>
>>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>  cmds-check.c | 95
>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 95 insertions(+)
>>>>
>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>> index 6633b6e..81dd4f3 100644
>>>> --- a/cmds-check.c
>>>> +++ b/cmds-check.c
>>>> @@ -323,6 +323,8 @@ struct root_item_info {
>>>>  #define MISSING_BACKREF    (1 << 0) /* Completely no backref in
>>>> extent tree */
>>>>  #define BAD_BACKREF    (1 << 1) /* Backref mismatch */
>>>>  #define UNALIGNED_BYTES    (1 << 2) /* Some bytes are not aligned */
>>>> +#define MISSING_REFERENCER (1 << 3) /* Referencer not found */
>>>> +#define BAD_REFERENCER    (1 << 4) /* Referencer found, but not
>>>> mismatch */
>>>>
>>>>  static void *print_status_check(void *p)
>>>>  {
>>>> @@ -8736,6 +8738,99 @@ out:
>>>>      return ret;
>>>>  }
>>>>
>>>> +/*
>>>> + * Check if a tree block backref is valid (points to valid tree block)
>>>> + * if level == -1, level will be resolved
>>>> + */
>>>> +static int check_tree_block_backref(struct btrfs_fs_info *fs_info,
>>>> u64 root_id,
>>>> +                    u64 bytenr, int level)
>>>> +{
>>>> +    struct btrfs_root *root;
>>>> +    struct btrfs_key key;
>>>> +    struct btrfs_path path;
>>>> +    struct extent_buffer *eb;
>>>> +    struct extent_buffer *node;
>>>> +    u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
>>>> +    int err = 0;
>>>> +    int ret;
>>>> +
>>>> +    /* Query level for level == -1 special case */
>>>> +    if (level == -1)
>>>> +        level = query_tree_block_level(fs_info, bytenr);
>>>> +    if (level < 0) {
>>>> +        err = MISSING_REFERENCER;
>>>> +        goto out;
>>>> +    }
>>>> +
>>>> +    key.objectid = root_id;
>>>> +    key.type = BTRFS_ROOT_ITEM_KEY;
>>>> +    key.offset = (u64)-1;
>>>> +
>>>> +    root = btrfs_read_fs_root(fs_info, &key);
>>>> +    if (IS_ERR(root)) {
>>>> +        err |= MISSING_REFERENCER;
>>>> +        goto out;
>>>> +    }
>>>> +
>>>> +    /* Read out the tree block to get item/node key */
>>>> +    eb = read_tree_block(root, bytenr, root->nodesize, 0);
>>>> +    /* Impossible, as tree block query has read out the tree block */
>>>> +    if (!extent_buffer_uptodate(eb)) {
>>>> +        err |= MISSING_REFERENCER;
>>>> +        free_extent_buffer(eb);
>>>> +        goto out;
>>>> +    }
>>>> +
>>>> +    /* Empty tree, no need to check key */
>>>> +    if (!btrfs_header_nritems(eb) && !level) {
>>>> +        free_extent_buffer(eb);
>>>> +        goto out;
>>>> +    }
>>>
>>> Actually this is interesting, because we don't actually catch where we
>>> would have btrfs_header_nritems(eb) == 0 and !level.  So maybe integrate
>>> that check into check_block, to make sure we have items in node level
>>> extent buffers.  Thanks,
>>>
>>> Josef
>>>
>>>
>> Unfortunately, we can't integrate it into check_tree_block() (or caller
>> read_tree_block() and its variants).
>>
>> As this is a valid case.
>> (And that's why we don't report error here)
>>
>> For trees like csum tree and uuid tree, they can be empty, and it
>> doesn't break any thing.
>>
>> So it's a not something we need to integrate into check_tree_block().
>>
>> And if you mean check_block() in old fsck codes, we won't use it in new
>> fsck, so still not a big problem.
>>
>
> But empty trees the root is still level 0, we shouldn't have a node that
> is empty, it should just be removed, right?  Thanks,
>
> Josef
>
>
>
Oh, You mean any tree level higher than 0 shouldn't have nritems == 0.

That makes sense, I'll send a independent patch for that.

Thanks,
Qu


