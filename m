Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab3HHLNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 07:13:39 -0400
Message-ID: <52037ACC.10502@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 19:02:36 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: fix possible memory leak in find_parent_nodes()
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52037AC6.70508@jan-o-sch.net>
In-Reply-To: <52037AC6.70508@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2013 07:02 PM, Jan Schmidt wrote:
>  
> On Thu, August 08, 2013 at 07:04 (+0200), Wang Shilong wrote:
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
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
>>
> 
> I'm not convinced, you're not calling kfree() more often. Can you please add
> some patch description?

Yeah. i will add more description in V2.

Thanks
Wang
> 
> -Jan
> 

