Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53532 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbcGUNFY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 09:05:24 -0400
Subject: Re: [PATCH 1/4] btrfs: use correct offset for reloc_inode in
 prealloc_file_extent_cluster()
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
 <20160720055637.7275-2-wangxg.fnst@cn.fujitsu.com>
 <5a91d751-ec98-8a2d-2d7c-8e63efbe750b@fb.com>
 <57902A11.9070201@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <cf46653d-13f6-84a5-0d46-16a308d9a01e@fb.com>
Date: Thu, 21 Jul 2016 09:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <57902A11.9070201@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2016 09:49 PM, Wang Xiaoguang wrote:
> hello,
>
> On 07/20/2016 09:18 PM, Josef Bacik wrote:
>> On 07/20/2016 01:56 AM, Wang Xiaoguang wrote:
>>> In prealloc_file_extent_cluster(), btrfs_check_data_free_space() uses
>>> wrong file offset for reloc_inode, it uses cluster->start and cluster->end,
>>> which indeed are extent's bytenr. The correct value should be
>>> cluster->[start|end] minus block group's start bytenr.
>>>
>>> start bytenr   cluster->start
>>> |              |     extent      |   extent   | ...| extent |
>>> |----------------------------------------------------------------|
>>> |                block group reloc_inode |
>>>
>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/relocation.c | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>>> index 0477dca..a0de885 100644
>>> --- a/fs/btrfs/relocation.c
>>> +++ b/fs/btrfs/relocation.c
>>> @@ -3030,12 +3030,14 @@ int prealloc_file_extent_cluster(struct inode *inode,
>>>      u64 num_bytes;
>>>      int nr = 0;
>>>      int ret = 0;
>>> +    u64 prealloc_start = cluster->start - offset;
>>> +    u64 prealloc_end = cluster->end - offset;
>>>
>>>      BUG_ON(cluster->start != cluster->boundary[0]);
>>>      inode_lock(inode);
>>>
>>> -    ret = btrfs_check_data_free_space(inode, cluster->start,
>>> -                      cluster->end + 1 - cluster->start);
>>> +    ret = btrfs_check_data_free_space(inode, prealloc_start,
>>> +                      prealloc_end + 1 - prealloc_start);
>>>      if (ret)
>>>          goto out;
>>>
>>> @@ -3056,8 +3058,8 @@ int prealloc_file_extent_cluster(struct inode *inode,
>>>              break;
>>>          nr++;
>>>      }
>>> -    btrfs_free_reserved_data_space(inode, cluster->start,
>>> -                       cluster->end + 1 - cluster->start);
>>> +    btrfs_free_reserved_data_space(inode, prealloc_start,
>>> +                       prealloc_end + 1 - prealloc_start);
>>>  out:
>>>      inode_unlock(inode);
>>>      return ret;
>>>
>>
>> This ends up being the same amount.  Consider this scenario
>>
>> bg bytenr = 4096
>> cluster->start = 8192
>> cluster->end = 12287
>>
>> cluster->end + 1 - cluster->start = 4096
>>
>> prealloc_start = cluster->start - offset = 0
>> prealloc_end = cluster->end - offset = 8191
>>
>> prealloc_end + 1 - prealloc_start = 4096
>>
>> You shift both by the same amount, which gives you the same answer.  Thanks,
> Thanks for reviewing.
> Yes, I know the amount of preallocated data space is the same, this patch
> does not fix any bugs :)
>
> For every block group to be balanced, we create a corresponding inode.
> For this inode, the initial offset should be 0. In your above example,
> before this patch, it's btrfs_free_reserved_data_space(inode, 8192, 4096);
> with this patch, it's btrfs_free_reserved_data_space(inode, 4096, 4096).
>
> I just want to make btrfs_free_reserved_data_space()'s 'start' argument
> be offset inside block group, not offset inside whole fs byternr space. I'm not
> a  English native, hope that I have expressed what I want to :)
>
> But yes, I'm also OK with removing this patch.
>

Oh I see, ok that's fine if we're just trying to make it look sane then go for it.

Signed-off-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

