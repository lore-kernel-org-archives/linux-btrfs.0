Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41102 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176AbaJFBUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 21:20:19 -0400
Message-ID: <5431EE79.4010609@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 09:20:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Check the consistence between the parent
 node and child node/leaf.
References: <1411716995-22537-1-git-send-email-quwenruo@cn.fujitsu.com> <1412178564.9583.1@mail.thefacebook.com>
In-Reply-To: <1412178564.9583.1@mail.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: Check the consistence between the 
parent node and child node/leaf.
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年10月01日 23:49
> On Fri, Sep 26, 2014 at 3:36 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
> wrote:
>> When btrfs-progs walk down the tree, it does not check whether the child
>> node/leaf is valid.
>> In fact, there is some corrupted image whose csum is all valid but
>> parent node points to a invalid leaf.
>>
>> In my case, the parent node in fs tree point to a invalid leaf(gen 11),
>> whose generation(15) and first key(EXTENT_TREE ROOT_ITEM 0) is
>> completely invalid, and will cause BUG_ON in process_inode_item().
>>
>> Unfortunately, we are unable to fix when it happens.
>> So we can only output meaningful error message and avoid the insane
>> node/leaf, which is still much better than the original BUG_ON().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  cmds-check.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index d479361..9471709 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -1302,6 +1302,52 @@ static void reada_walk_down(struct btrfs_root 
>> *root,
>>      }
>>  }
>>
>> +/*
>> + * Check the child node/leaf by the following condition:
>> + * 1. the first item key of the node/leaf should be the same with 
>> the one
>> + *    in parent.
>> + * 2. block in parent node should match the child node/leaf.
>> + * 3. generation of parent node and child's header should be 
>> consistent.
>> + *
>> + * Or the child node/leaf pointed by the key in parent is not valid.
>> + *
>> + * We hope to check leaf owner too, but since subvol may share leaves,
>> + * which makes leaf owner check not so strong, key check should be
>> + * sufficient enough for that case.
>> + */
>> +static int check_child_node(struct btrfs_root *root,
>> +                struct extent_buffer *parent, int slot,
>> +                struct extent_buffer *child)
>> +{
>> +    struct btrfs_key parent_key;
>> +    struct btrfs_key child_key;
>> +    int ret = 0;
>> +
>> +    btrfs_item_key_to_cpu(parent, &parent_key, slot);
>
> Dave mentioned he was getting a bunch of Wrong key of child node 
> messages from his current tree.  I should have spotted it sooner, but 
> this call should be btrfs_node_key_to_cpu(), since the parent is 
> always a node.
>
>>
>> +    btrfs_item_key_to_cpu(child, &child_key, 0);
>
> This should check the level and only use btrfs_item_key_to_cpu on the 
> leaves.
>
> Thanks!
>
> -chris
>
>
Oh, that's completely right...
I forgot node and leaf should use different key to cpu func... :(

I'll fix it soon.

Thanks,
Qu
