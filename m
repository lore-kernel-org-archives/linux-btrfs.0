From: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Subject: Re: [PATCH 01/25] [btrfs] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 18:20:22 -0000
Message-ID: <E6AAE21E487F4437A1A924F505D747C2@laptop>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com> <1236661850-8237-2-git-send-email-stoyboyker@gmail.com> <49B62FF2.7020607@gmail.com> <6d291e080903101116i32f13c33nf272e4adafc32477@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Cc: <linux-kernel@vger.kernel.org>, <chris.mason@oracle.com>,
	<linux-btrfs@vger.kernel.org>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>, <davidjonx@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6d291e080903101116i32f13c33nf272e4adafc32477@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


>>> if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
>>> BUG();
>>
>> ^ You seem to have missed one.
>
> Actually that one was left on purpose because BUG_ON calls are not to
> have any side effects and I do not know enough about btrfs to know
> what BTRFS_NODEPTRS_PER_BLOCK does so it was left as is.
>

BTRFS_NODEPTRS_PER_BLOCK has no side effects - it's defined as:

00284 #define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
00285                               sizeof(struct btrfs_header)) / \
00286                              sizeof(struct btrfs_key_ptr))

so it should be fine to put it in the BUG_ON.
----- Original Message ----- 
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: <davidjonx@gmail.com>
Cc: <linux-kernel@vger.kernel.org>; <chris.mason@oracle.com>; 
<linux-btrfs@vger.kernel.org>
Sent: Tuesday, March 10, 2009 6:16 PM
Subject: Re: [PATCH 01/25] [btrfs] BUG to BUG_ON changes


> On Tue, Mar 10, 2009 at 4:16 AM, David John <davidjonx@gmail.com> wrote:
>> Stoyan Gaydarov wrote:
>>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>>> ---
>>> fs/btrfs/ctree.c | 3 +--
>>> fs/btrfs/extent-tree.c | 3 +--
>>> fs/btrfs/free-space-cache.c | 3 +--
>>> fs/btrfs/tree-log.c | 3 +--
>>> 4 files changed, 4 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>> index 37f31b5..2c590b0 100644
>>> --- a/fs/btrfs/ctree.c
>>> +++ b/fs/btrfs/ctree.c
>>> @@ -2174,8 +2174,7 @@ static int insert_ptr(struct btrfs_trans_handle 
>>> *trans, struct btrfs_root
>>> BUG_ON(!path->nodes[level]);
>>> lower = path->nodes[level];
>>> nritems = btrfs_header_nritems(lower);
>>> - if (slot > nritems)
>>> - BUG();
>>> + BUG_ON(slot > nritems);
>>> if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
>>> BUG();
>>
>> ^ You seem to have missed one.
>
> Actually that one was left on purpose because BUG_ON calls are not to
> have any side effects and I do not know enough about btrfs to know
> what BTRFS_NODEPTRS_PER_BLOCK does so it was left as is.
>
>>
>>> if (slot != nritems) {
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 9abf81f..0314ab6 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -672,8 +672,7 @@ static noinline int insert_extents(struct 
>>> btrfs_trans_handle *trans,
>>> keys+i, data_size+i, total-i);
>>> BUG_ON(ret < 0);
>>>
>>> - if (last && ret > 1)
>>> - BUG();
>>> + BUG_ON(last && ret > 1);
>>>
>>> leaf = path->nodes[0];
>>> for (c = 0; c < ret; c++) {
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index d1e5f0e..b0c7661 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -267,8 +267,7 @@ static int __btrfs_add_free_space(struct 
>>> btrfs_block_group_cache *block_group,
>>> out:
>>> if (ret) {
>>> printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
>>> - if (ret == -EEXIST)
>>> - BUG();
>>> + BUG_ON(ret == -EEXIST);
>>> }
>>>
>>> kfree(alloc_info);
>>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>>> index 9c462fb..2c892f6 100644
>>> --- a/fs/btrfs/tree-log.c
>>> +++ b/fs/btrfs/tree-log.c
>>> @@ -1150,8 +1150,7 @@ insert:
>>> ret = insert_one_name(trans, root, path, key->objectid, key->offset,
>>> name, name_len, log_type, &log_key);
>>>
>>> - if (ret && ret != -ENOENT)
>>> - BUG();
>>> + BUG_ON(ret && ret != -ENOENT);
>>> goto out;
>>> }
>>>
>>
>>
>
> -- 
>
> -Stoyan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

