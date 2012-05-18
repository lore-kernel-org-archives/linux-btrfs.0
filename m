Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2ERDNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 23:13:40 -0400
Message-ID: <4FB5BE08.7030306@cn.fujitsu.com>
Date: Fri, 18 May 2012 11:12:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix memory leak in btrfs_pause_balance()
References: <4FB4E7FD.8050108@cn.fujitsu.com> <20120517152004.GC1934@zambezi.lan>
In-Reply-To: <20120517152004.GC1934@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 17 May 2012 18:20:04 +0300, Ilya Dryomov wrote:
> On Thu, May 17, 2012 at 07:58:53PM +0800, Miao Xie wrote:
>> We forget to free fs_info->balance_ctl in the btrfs_pause_balance()
>> when umounting the fs.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/volumes.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index c536d52..fd7fe80 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2937,6 +2937,9 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>>  		ret = -ENOTCONN;
>>  	}
>>  
>> +	if (btrfs_fs_closing(fs_info) && fs_info->balance_ctl)
>> +		unset_balance_control(fs_info);
>> +
>>  	mutex_unlock(&fs_info->balance_mutex);
>>  	return ret;
>>  }
> 
> It is kfree()'d in free_fs_info(), which should be called on unmount.
> Am I missing something here ?

It is my mistake. Sorry.

BTW I think freeing it in btrfs_pause_balance() is better because it is relative
to the balance, or the readability will become worse.

Thanks
Miao
