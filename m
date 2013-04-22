Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3DVChD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 22:37:03 -0400
Message-ID: <5174A2A9.9060709@cn.fujitsu.com>
Date: Mon, 22 Apr 2013 10:38:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: use a lock to protect incompat/compat flag
 of the super block
References: <516690B8.8020904@cn.fujitsu.com> <20130417221710.GD16427@twin.jikos.cz>
In-Reply-To: <20130417221710.GD16427@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 18 Apr 2013 00:17:11 +0200, David Sterba wrote:
> On Thu, Apr 11, 2013 at 06:30:16PM +0800, Miao Xie wrote:
>> In order to avoid this problem, we introduce a lock named super_lock into
>> the btrfs_fs_info structure. If we want to update incompat/compat flags
>> of the super block, we must hold it.
>>
>> +	/*
>> +	 * Used to protect the incompat_flags, compat_flags, compat_ro_flags
>> +	 * when they are updated.
> 
>> +	spinlock_t super_lock;
> 
> The lock name is too general for protecting just *_flags, do you have
> plans to add more items from superblock under this lock?  If no, I
> suggest to pick a different name.

Yes, I want to add more items from super block under this lock.

> 
>> @@ -3663,8 +3674,15 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
>>  	disk_super = fs_info->super_copy;
>>  	features = btrfs_super_incompat_flags(disk_super);
>>  	if (!(features & flag)) {
>> -		features |= flag;
>> -		btrfs_set_super_incompat_flags(disk_super, features);
>> +		spin_lock(&fs_info->super_lock);
>> +		features = btrfs_super_incompat_flags(disk_super);
>> +		if (!(features & flag)) {
>> +			features |= flag;
>> +			btrfs_set_super_incompat_flags(disk_super, features);
>> +			printk(KERN_INFO "btrfs: setting %llu feature flag\n",
>> +					 flag);
> 
> flag is u64, please use (unsigned long long)flag and possibly the new
> btrfs_info replacement of printks.

OK, I'll modify my patch.

Thanks for your view.

Miao

> 
>> +		}
>> +		spin_unlock(&fs_info->super_lock);
>>  	}
>>  }
> 
> otherwise ok.
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

