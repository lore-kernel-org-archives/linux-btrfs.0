Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965280Ab3HIJ64 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 05:58:56 -0400
Message-ID: <5204BD07.3090206@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 17:57:27 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [PATCH 2/3] Btrfs: move btrfs_free_qgroup_config() out of spin_lock
 and fix comments
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1375852351-11919-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <5204B974.9030402@gmx.net>
In-Reply-To: <5204B974.9030402@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/09/2013 05:42 PM, Arne Jansen wrote:
> On 07.08.2013 07:12, Wang Shilong wrote:
>> btrfs_free_qgroup_config() is not only called by open/close_ctree(),but
>> also btrfs_disable_quota().And for btrfs_disable_quota(),we have set
>> 'quota_root' to be null before calling btrfs_free_qgroup_config(),so it
>> is safe to cleanup in-memory structures without lock held.
> 
> Why do you do this? Did the spinlock gave you any trouble?

Because other places such as btrfs_qgroup_reserve() will try spin_lock.
and we should relase spin_lock as soon as possible, luckily we are safe
to move btrfs_free_qgroup_config() out of spin_lock.

> 
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/qgroup.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 3b103e2..b809616 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -432,8 +432,10 @@ out:
>>  }
>>  
>>  /*
>> - * This is only called from close_ctree() or open_ctree(), both in single-
>> - * treaded paths. Clean up the in-memory structures. No locking needed.
>> + * This is called from close_ctree() or open_ctree() or btrfs_quota_disable(),
>> + * first two are in single-treaded paths.And for the third one, we have set
> 
> You could use the opportunity and correct the typo in 'single-treaded'. Also,
> there's a space missing after the period.

I will fix typo.

Thank,
Wang
> 
> -Arne
> 
>> + * quota_root to be null with qgroup_lock held before, so it is safe to clean
>> + * up the in-memory structures without qgroup_lock held.
>>   */
>>  void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
>>  {
>> @@ -937,9 +939,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>>  	fs_info->pending_quota_state = 0;
>>  	quota_root = fs_info->quota_root;
>>  	fs_info->quota_root = NULL;
>> -	btrfs_free_qgroup_config(fs_info);
>>  	spin_unlock(&fs_info->qgroup_lock);
>>  
>> +	btrfs_free_qgroup_config(fs_info);
>> +
>>  	if (!quota_root) {
>>  		ret = -EINVAL;
>>  		goto out;
> 
> 

