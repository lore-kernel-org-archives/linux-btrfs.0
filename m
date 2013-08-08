Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab3HHFgl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 01:36:41 -0400
Message-ID: <52032EA6.8040505@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 13:37:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: fix possible memory leak in find_parent_nodes()
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20130808052211.GB644@localhost.localdomain>
In-Reply-To: <20130808052211.GB644@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 8 Aug 2013 13:22:12 +0800, Liu Bo wrote:
> On Thu, Aug 08, 2013 at 01:04:17PM +0800, Wang Shilong wrote:
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> I think I know the whys :p, but still a log is preferred.

Right, we need a explanation, we will update this patch soon.

Thanks
Miao

> 
> -liubo
> 
>> ---
>>  fs/btrfs/backref.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index cb73a12..54e7610 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -911,7 +911,6 @@ again:
>>  
>>  	while (!list_empty(&prefs)) {
>>  		ref = list_first_entry(&prefs, struct __prelim_ref, list);
>> -		list_del(&ref->list);
>>  		WARN_ON(ref->count < 0);
>>  		if (ref->count && ref->root_id && ref->parent == 0) {
>>  			/* no parent == root of tree */
>> @@ -954,6 +953,7 @@ again:
>>  				eie->next = ref->inode_list;
>>  			}
>>  		}
>> +		list_del(&ref->list);
>>  		kfree(ref);
>>  	}
>>  
>> -- 
>> 1.8.0.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

