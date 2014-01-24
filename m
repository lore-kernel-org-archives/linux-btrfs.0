Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaAXJR0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 04:17:26 -0500
Message-ID: <52E22F5C.7050006@cn.fujitsu.com>
Date: Fri, 24 Jan 2014 17:16:12 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: optimize to remove unnecessary removal with ulist
 reallocation
References: <1389360346-23842-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140113023109.GA26294@localhost.localdomain>
In-Reply-To: <20140113023109.GA26294@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

On 01/13/2014 10:31 AM, Liu Bo wrote:
> On Fri, Jan 10, 2014 at 09:25:46PM +0800, Wang Shilong wrote:
>> Here we are not going to free memory, no need to remove every node
>> one by one, just init root node here is ok.
> Looks fine, but we need to make sure that it passes the regression test since you're
> working on an old bug.
Sorry for late reply, i have just sent a regression test for this.

I did some hacking in kernel codes, and make sure test covers
ulist reallocation, hopely it is helpful in the future.^_^

url can be seen:
https://patchwork.kernel.org/patch/3533801/


Thanks,
Wang
>
> -liubo
>
>> Cc:  Liu Bo <bo.li.liu@oracle.com>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ulist.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
>> index b0a523b2..35f5de9 100644
>> --- a/fs/btrfs/ulist.c
>> +++ b/fs/btrfs/ulist.c
>> @@ -207,9 +207,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>>   		void *old = NULL;
>>   		int i;
>>   
>> -		for (i = 0; i < ulist->nnodes; i++)
>> -			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
>> -
>>   		/*
>>   		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
>>   		 * yet, so pass NULL to krealloc
>> @@ -234,6 +231,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
>>   		 * pointers, so we have to do it ourselves.  Otherwise we may
>>   		 * be bitten by crashes.
>>   		 */
>> +		ulist->root = RB_ROOT;
>>   		for (i = 0; i < ulist->nnodes; i++) {
>>   			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
>>   			if (ret < 0)
>> -- 
>> 1.8.3.1
>>

