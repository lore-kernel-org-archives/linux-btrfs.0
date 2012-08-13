Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:26971 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2HMK6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 06:58:18 -0400
Message-ID: <5028DDC8.4050900@giantdisaster.de>
Date: Mon, 13 Aug 2012 12:58:16 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make filesystem read-only when submitting barrier
 fails
References: <1344605915-22526-1-git-send-email-sbehrens@giantdisaster.de> <5025C521.2010707@oracle.com>
In-Reply-To: <5025C521.2010707@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 11 Aug 2012 10:36:17 +0800, Liu Bo wrote:
> On 08/10/2012 09:38 PM, Stefan Behrens wrote:
[...]
>> +				flags = space.flags;
>> +				/*
>> +				 * return
>> +				 * 0: if dup, single or RAID0 is configured for
>> +				 *    any of metadata, system or data, else
>> +				 * 1: if RAID5 is configured, or if RAID1 or
>> +				 *    RAID10 is configured and only two mirrors
>> +				 *    are used, else
>> +				 * 2: if RAID6 is configured, else
>> +				 * num_mirrors - 1: if RAID1 or RAID10 is
>> +				 *                  configured and more than
>> +				 *                  2 mirrors are used.
>> +				 */
>> +				if (num_tolerated_disk_barrier_failures > 0 &&
>> +				    ((flags & (BTRFS_BLOCK_GROUP_DUP |
>> +					       BTRFS_BLOCK_GROUP_RAID0)) ||
>> +				     ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK)
>> +				      == 0)))
> 
> Good work.
> 
> We already have __get_block_group_index(), for dup, single, raid0 we can do the same thing like
> this:
> __get_block_group_index(flags) > 1
> 
> the only problem is to make the function public :)

Thanks for your comments Liu Bo. And good luck with Oracle (please
correct me if I misinterpreted your updated email address).

That's correct that "__get_block_group_index() > 1" would be a little
bit shorter way to evaluate the RAID flags. But the rest of the btrfs
code (except for btrfs_can_relocate()) also explicitly evaluates the
flags instead of using the array index that __get_block_group_index()
returns. It is just following the convention.


>> +					num_tolerated_disk_barrier_failures = 0;
>> +				else if (num_tolerated_disk_barrier_failures > 1
>> +					 &&
>> +					 (flags & (BTRFS_BLOCK_GROUP_RAID1 |
>> +						   BTRFS_BLOCK_GROUP_RAID10)))
>> +					num_tolerated_disk_barrier_failures = 1;
>> +			}
[...]
>> @@ -2807,6 +2812,26 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>>  		}
>>  	}
>>  
>> +	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int num_tolerated_disk_barrier_failures;
>> +		u64 target = bctl->sys.target;
>> +
>> +		num_tolerated_disk_barrier_failures =
>> +			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
>> +		if (num_tolerated_disk_barrier_failures > 0 &&
>> +		    (target &
>> +		     (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
>> +		      BTRFS_AVAIL_ALLOC_BIT_SINGLE)))
> 
> ditto.

Same as before + this time the code is working on the balance conversion
parameters where SINGLE is encoded in a different way.
