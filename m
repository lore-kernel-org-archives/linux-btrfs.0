Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755970AbdLPCOt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 21:14:49 -0500
Subject: Re: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument
 optional
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-5-anand.jain@oracle.com>
 <b3a90794-2186-8740-186f-ad84733595d3@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ad4808f1-1ab4-df47-a45a-f3bf6837b813@oracle.com>
Date: Sat, 16 Dec 2017 10:14:04 +0800
MIME-Version: 1.0
In-Reply-To: <b3a90794-2186-8740-186f-ad84733595d3@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

		/*
>> @@ -637,8 +632,11 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>>   			 * either use mapper or non mapper path throughout.
>>   			 */
>>   			rcu_read_lock();
>> -			not_found = strcmp(rcu_str_deref(dev->name),
>> -						rcu_str_deref(cur_dev->name));
>> +			if (cur_dev)
>> +				not_found = strcmp(rcu_str_deref(dev->name),
>> +						   rcu_str_deref(cur_dev->name));
>> +			else
>> +				not_found = 0;
> 
> nit: Perhaps put a proper documentation header at the beginning of the
> function detailing this behavior. I.e.
> 
> /*
>   * btrfs_free_stale_device
>   * ....
> 

  Right. Will add.

Thanks, Anand

