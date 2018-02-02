Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbeBBL51 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 06:57:27 -0500
Subject: Re: [PATCH 5/7] btrfs-progs: volumes: Allow find_free_dev_extent() to
 return maximum hole size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-6-wqu@suse.com>
 <295a561d-dc4c-8a05-ac51-02d3ab24c278@suse.com>
 <8507fe44-9a1e-c36f-bd09-89ab6344a25b@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2777c60b-7255-135d-2826-40c5398083ff@suse.com>
Date: Fri, 2 Feb 2018 13:57:24 +0200
MIME-Version: 1.0
In-Reply-To: <8507fe44-9a1e-c36f-bd09-89ab6344a25b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.02.2018 13:49, Qu Wenruo wrote:
> 
> 
> On 2018年02月02日 19:41, Nikolay Borisov wrote:
>>
>>
>> On  2.02.2018 10:19, Qu Wenruo wrote:
>>> Just as kernel find_free_dev_extent(), allow it to return maximum hole
>>> size for us to build device list for later chunk allocator rework.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  volumes.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/volumes.c b/volumes.c
>>> index b47ff1f392b5..f4009ffa7c9e 100644
>>> --- a/volumes.c
>>> +++ b/volumes.c
>>> @@ -516,10 +516,10 @@ out:
>>>  }
>>>  
>>>  static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
>>> -				u64 *start)
>>> +				u64 *start, u64 *len)
>>>  {
>>>  	/* FIXME use last free of some kind */
>>> -	return find_free_dev_extent_start(device, num_bytes, 0, start, NULL);
>>> +	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
>>
>> Why do we need the free_dev_extent() wrapper over free_dev_extent_start
>> at all?
> 
> Because kernel part still needs find_free_dev_extent(), in extent-tree.c.
> 
> I'd prefer to keep the function across kernel and btrfs-progs.

You are right, I missed it while I was grepping the first time.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Thanks,
> Qu
> 
>>>  }
>>>  
>>>  static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>> @@ -543,7 +543,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>>>  	 * is responsible to make sure it's free.
>>>  	 */
>>>  	if (!convert) {
>>> -		ret = find_free_dev_extent(device, num_bytes, start);
>>> +		ret = find_free_dev_extent(device, num_bytes, start, NULL);
>>>  		if (ret)
>>>  			goto err;
>>>  	}
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
