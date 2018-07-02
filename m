Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37943 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbeGBIPA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 04:15:00 -0400
Subject: Re: [PATCH] btrfs: relocation: Only remove reloc rb_trees if reloc
 control has been initialized
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180702062538.30794-1-wqu@suse.com>
 <341231a6-8464-d8ee-4e79-fe9066747384@suse.com>
 <6e41f3cb-9b20-246b-dfc8-ddd5f3ad7441@gmx.com>
 <69a2803a-af4f-a5ca-bc01-3d500b2152b2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0d3ab2f6-71f5-7aa2-a000-3d7f6c953c92@gmx.com>
Date: Mon, 2 Jul 2018 16:14:49 +0800
MIME-Version: 1.0
In-Reply-To: <69a2803a-af4f-a5ca-bc01-3d500b2152b2@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月02日 16:01, Nikolay Borisov wrote:
> 
> 
> On  2.07.2018 10:53, Qu Wenruo wrote:
>>
>>
>> On 2018年07月02日 15:31, Nikolay Borisov wrote:
>>>
>>>
>>> On  2.07.2018 09:25, Qu Wenruo wrote:
>>>> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199833, where an
>>>> invalid tree reloc tree can cause kernel NULL pointer dereference when
>>>> btrfs does some cleanup for reloc roots.
>>>>
>>>> It turns out that fs_info->reloc_ctl can be NULL in
>>>> btrfs_recover_relocation() as we allocate relocation control after all
>>>> reloc roots are verified.
>>>> So when we hit out: tag, we haven't call set_reloc_control() thus
>>>> fs_info->reloc_ctl is still NULL.
>>>>
>>>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/relocation.c | 23 ++++++++++++-----------
>>>>  1 file changed, 12 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>>> index 879b76fa881a..be94c65bb4d2 100644
>>>> --- a/fs/btrfs/relocation.c
>>>> +++ b/fs/btrfs/relocation.c
>>>> @@ -1321,18 +1321,19 @@ static void __del_reloc_root(struct btrfs_root *root)
>>>>  	struct mapping_node *node = NULL;
>>>>  	struct reloc_control *rc = fs_info->reloc_ctl;
>>>>  > -	spin_lock(&rc->reloc_root_tree.lock);
>>>> -	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
>>>> -			      root->node->start);
>>>> -	if (rb_node) {
>>>> -		node = rb_entry(rb_node, struct mapping_node, rb_node);
>>>> -		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
>>>
>>> Just do  if (!rc)
>>>                 return;
>>>
>>> The function is simple enough, no need to indent multiple lines.
>>
>> You missed serval lines below, we still have:
>> ---
>>         spin_lock(&fs_info->trans_lock);
>>         list_del_init(&root->root_list);
>>         spin_unlock(&fs_info->trans_lock);
>>         kfree(node);
>> ---
>>
>> Which still needs to be called even rc is not initialized.
> 
> But then isn't the function buggy even with your patch because if node
> is not initialised then we exit at if (!node) return.

That means node->data isn't initialized nor its root->root_list.

The patch only needs to call list_del_init() if @rc is not initialized.

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>> +	if (rc) {
>>>> +		spin_lock(&rc->reloc_root_tree.lock);
>>>> +		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
>>>> +				      root->node->start);
>>>> +		if (rb_node) {
>>>> +			node = rb_entry(rb_node, struct mapping_node, rb_node);
>>>> +			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
>>>> +		}
>>>> +		spin_unlock(&rc->reloc_root_tree.lock);
>>>> +		if (!node)
>>>> +			return;
>>>> +		BUG_ON((struct btrfs_root *)node->data != root);
>>>>  	}
>>>> -	spin_unlock(&rc->reloc_root_tree.lock);
>>>> -
>>>> -	if (!node)
>>>> -		return;
>>>> -	BUG_ON((struct btrfs_root *)node->data != root);
>>>>  
>>>>  	spin_lock(&fs_info->trans_lock);
>>>>  	list_del_init(&root->root_list);
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
