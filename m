From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 10/10] Btrfs: drop cache with VACANCY em when we fail
 to start a transaction
Date: Fri, 30 Mar 2012 09:08:35 +0800
Message-ID: <4F750793.9040402@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com> <1332830678-3992-11-git-send-email-liubo2009@cn.fujitsu.com> <20120329140156.GN755@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120329140156.GN755@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29/2012 10:01 PM, Chris Mason wrote:
> On Tue, Mar 27, 2012 at 02:44:38PM +0800, Liu Bo wrote:
>> We need to clean a VACANCY em(if we have) when we fail to start a transaction.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index bacf441..2b2f0b6 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3406,9 +3406,6 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>>  				break;
>>  			}
>>  
>> -			btrfs_drop_extent_cache(inode, hole_start,
>> -					last_byte - 1, 0);
>> -
>>  			btrfs_update_inode(trans, root, inode);
>>  			btrfs_end_transaction(trans, root);
>>  		}
>> @@ -3419,6 +3416,9 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>>  			break;
>>  	}
>>  
>> +	if (em && test_bit(EXTENT_FLAG_VACANCY, &em->flags))
>> +		btrfs_drop_extent_cache(inode, hole_start, last_byte - 1, 0);
>> +
> 
> Hmmm, last_byte isn't always setup at this point (uninit variable).  I'm
> a little uncertain about what this one is fixing?
> 

err, sorry, plz drop this one, it's just a cleanup.

I was just thinking when we create a VACANCY em and fail to start a transaction(break out from while loop),
we'll leave a VACANCY em behind.

thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

