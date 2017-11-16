Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759232AbdKPNxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 08:53:19 -0500
Subject: Re: [PATCH] btrfs: fix deadlock when writing out space cache
To: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1510780852-8862-1-git-send-email-josef@toxicpanda.com>
 <7281db4c-6d0f-c463-ba1a-fc77b356d906@suse.com>
 <cda921a3-0f24-1e51-5fa7-ecf74f4a85de@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <419eeebf-d084-3fca-08c5-c212c0515ad6@suse.com>
Date: Thu, 16 Nov 2017 15:53:17 +0200
MIME-Version: 1.0
In-Reply-To: <cda921a3-0f24-1e51-5fa7-ecf74f4a85de@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.11.2017 15:50, Chris Mason wrote:
> 
> 
> On 11/16/2017 03:09 AM, Nikolay Borisov wrote:
>>
>>
>> On 15.11.2017 23:20, Josef Bacik wrote:
>>> From: Josef Bacik <jbacik@fb.com>
>>>
>>> If we fail to prepare our pages for whatever reason (out of memory in
>>> our case) we need to make sure to drop the block_group->data_rwsem,
>>> otherwise hilarity ensues.
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>>> ---
>>>   fs/btrfs/free-space-cache.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index cdc9f4015ec3..a6c643275210 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -1263,8 +1263,12 @@ static int __btrfs_write_out_cache(struct
>>> btrfs_root *root, struct inode *inode,
>>>         /* Lock all pages first so we can lock the extent safely. */
>>>       ret = io_ctl_prepare_pages(io_ctl, inode, 0);
>>> -    if (ret)
>>> +    if (ret) {
>>> +        if (block_group &&
>>> +            (block_group->flags & BTRFS_BLOCK_GROUP_DATA))
>>> +            up_write(&block_group->data_rwsem);
>>>           goto out;
>>> +    }
>>
>> Which function after out: label causes a deadlock - btrfs_update_inode
>> (unlikely) or invalidate_inode_pages2?
> 
> Neither, out: just doesn't drop the data_rwsem mutex, so it leaves the
> block group locked.

Ah, it has a return ret; and never hits the code under out_nospc, fair
enough.

> 
> -chris
> 
