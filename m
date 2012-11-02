Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762715Ab2KBD7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 23:59:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qA23xlsh003803
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Nov 2012 11:59:48 +0800
Message-ID: <5093454C.4010007@cn.fujitsu.com>
Date: Fri, 02 Nov 2012 12:00:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix missing log when BTRFS_INODE_NEEDS_FULL_SYNC
 is set
References: <5092263B.7070500@cn.fujitsu.com> <20121101092111.GE2554@liubo.cn.oracle.com>
In-Reply-To: <20121101092111.GE2554@liubo.cn.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 1 Nov 2012 17:21:12 +0800, Liu Bo wrote:
> On Thu, Nov 01, 2012 at 03:35:23PM +0800, Miao Xie wrote:
>> If we set BTRFS_INODE_NEEDS_FULL_SYNC, we should log all the extent,
>> but now we forget to take it into account, and set a wrong max key,
>> if so, we will skip the file extent metadata when doing logging. Fix it.
>>
> 
> But it's along with LOG_INODE_EXISTS, which is set by rename and link
> and means we need to log just enough to rebuild the inode during log replay.
> 
> On the other side, if we do log all the extents because of having set
> BTRFS_INODE_NEEDS_FULL_SYNC, we don't know if we actually get what we
> want because rename and link do not wait for dirty pages as fsync does.

Full sync is the safest way to log. I think we should not ignore it since it
is set. 

Thanks
Miao

> 
> thanks,
> liubo
> 
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/tree-log.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index f7e9387..c495b47 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -3394,7 +3394,10 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>>  
>>  
>>  	/* today the code can only do partial logging of directories */
>> -	if (inode_only == LOG_INODE_EXISTS || S_ISDIR(inode->i_mode))
>> +	if (S_ISDIR(inode->i_mode) ||
>> +	    (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>> +		       &BTRFS_I(inode)->runtime_flags) &&
>> +	     inode_only == LOG_INODE_EXISTS))
>>  		max_key.type = BTRFS_XATTR_ITEM_KEY;
>>  	else
>>  		max_key.type = (u8)-1;
>> -- 
>> 1.7.6.5
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


