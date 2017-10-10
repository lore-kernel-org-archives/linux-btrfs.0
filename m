Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47694 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdJJIrm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 04:47:42 -0400
Subject: Re: [PATCH] btrfs: prefix sysfs attribute struct names
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171008203058.28931-1-hans.van.kranenburg@mendix.com>
 <20171009161758.GH3521@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <7e436e83-e493-53a9-5f83-e17b0bf69b36@mendix.com>
Date: Tue, 10 Oct 2017 10:47:40 +0200
MIME-Version: 1.0
In-Reply-To: <20171009161758.GH3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/09/2017 06:17 PM, David Sterba wrote:
> On Sun, Oct 08, 2017 at 10:30:58PM +0200, Hans van Kranenburg wrote:
>> Currently struct names for sysfs are generated only based on the
>> attribute names. This means that attribute names cannot be reused in
>> multiple places throughout the complete btrfs sysfs hierarchy.
>>
>> E.g. allocation/data/total_bytes and allocation/data/single/total_bytes
>> result in the same struct name btrfs_attr_total_bytes. A workaround for
>> this case was made in the past by ad hoc creating an extra macro
>> wrapper, BTRFS_RAID_ATTR, that inserts some extra text in the struct
>> name.
>>
>> Instead of polluting sysfs.h with such kind of extra macro definitions,
>> and only doing so when there are collisions, use a prefix which gets
>> inserted in the struct name, so we keep everything nicely grouped
>> together by default.
>>
>> Current collections of attributes are:
>> * (the toplevel, empty prefix)
>> * allocation
>> * space_info
>> * raid
>> * features
>>
>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Thanks! If anyone wonders why...

Last summer I was trying to build in some metadata cow counters per
tree, and initially put them in sysfs, then I ran into the fact that I
couldn't use the field free_space_tree as a counter because it was also
used in the features.

It was a nice exercise and the results clearly showed that my suspicions
about extent tree rumination problems were right.

However, then I discovered tracepoints and could throw away the code again.

But I still finished this part, because it makes sysfs nicer for a
future developer who wants to change something :D

>> @@ -277,7 +277,8 @@ static ssize_t raid_bytes_show(struct kobject *kobj,
>>  
>>  	down_read(&sinfo->groups_sem);
>>  	list_for_each_entry(block_group, &sinfo->block_groups[index], list) {
>> -		if (&attr->attr == BTRFS_RAID_ATTR_PTR(total_bytes))
>> +		if (&attr->attr == \
> 
> the \ is not needed here, only in macro defintions that must be on one
> logical line

Ha, yes... At some point the backslashes were dancing around before my
eyes while getting all those macros in shape again. Some started
wandering off it seems.

> 
>> +		    BTRFS_ATTR_PTR(raid, total_bytes))
>>  			val += block_group->key.offset;
>>  		else
>>  			val += btrfs_block_group_used(&block_group->item);
>> @@ -331,19 +332,20 @@ SPACE_INFO_ATTR(bytes_may_use);
>>  SPACE_INFO_ATTR(bytes_readonly);
>>  SPACE_INFO_ATTR(disk_used);
>>  SPACE_INFO_ATTR(disk_total);
>> -BTRFS_ATTR(total_bytes_pinned, btrfs_space_info_show_total_bytes_pinned);
>> +BTRFS_ATTR(space_info, total_bytes_pinned, \
> 
> same here. will be fixed at commit time.
> 
>> +	   btrfs_space_info_show_total_bytes_pinned);
>>  


-- 
Hans van Kranenburg
