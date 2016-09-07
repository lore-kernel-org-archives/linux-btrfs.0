Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65438 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755253AbcIGB5C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 21:57:02 -0400
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
To: Zhao Lei <zhaolei@cn.fujitsu.com>, <dsterba@suse.com>, <clm@fb.com>,
        <anand.jain@oracle.com>, <fdmanana@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <20160907013843.GA3907@linux-zmni.apac.novell.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f23134aa-435d-e280-e35f-402c8acb8093@cn.fujitsu.com>
Date: Wed, 7 Sep 2016 09:56:40 +0800
MIME-Version: 1.0
In-Reply-To: <20160907013843.GA3907@linux-zmni.apac.novell.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/07/2016 09:38 AM, Sean Fu wrote:
> On Mon, Sep 05, 2016 at 03:56:41PM +0800, Qu Wenruo wrote:
>>
>>
>> At 09/05/2016 09:19 AM, Zhao Lei wrote:
>>> Hi, Sean Fu
>>>
>>>> From: Sean Fu [mailto:fxinrong@gmail.com]
>>>> Sent: Sunday, September 04, 2016 7:54 PM
>>>> To: dsterba@suse.com
>>>> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
>>>> zhaolei@cn.fujitsu.com; linux-btrfs@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
>>>> Subject: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment in
>>>> btrfs_read_chunk_tree.
>>>>
>>>> The input argument root is already set with "fs_info->chunk_root".
>>>> "chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info)" in caller
>>>> "open_ctree".
>>>> “root->fs_info = fs_info” in "btrfs_alloc_root".
>>>>
>>> The root argument of this function means "any root".
>>> And the function is designed getting chunk root from
>>> "any root" in head.
>>>
>>> Since there is only one caller of this function,
>>> and the caller always send chunk_root as root argument in
>>> current code, we can remove above conversion,
>>> and I suggest renaming root to chunk_root to make it clear,
>>> something like:
>>>
>>> - btrfs_read_chunk_tree(struct btrfs_root *root)
>>> + btrfs_read_chunk_tree(struct btrfs_root *chunk_root)
>>
>> Since root is only used to get fs_info->chunk_root, why not use fs_info
>> directly?
> Sorry for late reply.
> chunk_root is processed in btrfs_read_chunk_tree.
> Why should we pass fs_info directly to btrfs_read_chunk_tree?
> Could you give me more detail?
>
> Many thanks

Normally we should only pass btrfs_root as parameter if it's a 
file/log/relocation tree which can't be grabbed directly from fs_info.

For system wide trees, which are already in fs_info, like 
fs_info->extent_root/chunk_root/..., we should pass fs_info.

Which is much much safer than passing a btrfs_root.
Careless caller can pass wrong tree and cause undefined behavior.

And such behavior makes caller more aware of what they really want to do.
Cases like just to grab sectorsize/nodesize shouldn't need a full 
btrfs_root.
(Jeff's patchset has already done such things quite well)

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>
>>> Thanks
>>> Zhaolei
>>>
>>>> Signed-off-by: Sean Fu <fxinrong@gmail.com>
>>>> ---
>>>> fs/btrfs/volumes.c | 2 --
>>>> 1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 366b335..384a6d2 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>>>> 	int ret;
>>>> 	int slot;
>>>>
>>>> -	root = root->fs_info->chunk_root;
>>>> -
>>>> 	path = btrfs_alloc_path();
>>>> 	if (!path)
>>>> 		return -ENOMEM;
>>>> --
>>>> 2.6.2
>>>>
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


