From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 4/6] btrfs: update stats when allocating from a cluster
Date: Tue, 24 Aug 2010 08:50:57 +0800
Message-ID: <4C731771.1060904@cn.fujitsu.com>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD91.4050703@cn.fujitsu.com> <20100823130932.GD2404@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100823130932.GD2404@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

>>  	spin_unlock(&cluster->lock);
>>  
>> +	if (!ret)
>> +		return 0;
>> +
>> +	spin_lock(&block_group->tree_lock);
>> +
>> +	block_group->free_space -= bytes;
>> +	if (entry->bytes == 0) {
>> +		block_group->free_extents--;
>> +		kfree(entry);
>> +	}
>> +
>> +	spin_unlock(&block_group->tree_lock);
>> +
> 
> Move this part up so we don't drop the spinlock and then re-grab it.  Thanks,
> 

But they are 2 different locks. ;)

And we can't grab block_group->tree_lock when holding cluster->lock.
