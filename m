Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47486 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbeDYLB7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 07:01:59 -0400
Subject: Re: [PATCH v2] btrfs: kill btrfs_raid_type_names[]
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180425094413.2255-1-anand.jain@oracle.com>
 <20180425094540.GM21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <02419b6a-8745-72a3-3c0e-36f5436c344b@oracle.com>
Date: Wed, 25 Apr 2018 19:04:09 +0800
MIME-Version: 1.0
In-Reply-To: <20180425094540.GM21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/25/2018 05:45 PM, David Sterba wrote:
> On Wed, Apr 25, 2018 at 05:44:13PM +0800, Anand Jain wrote:
>> Add a new member struct btrfs_raid_attr::raid_name so that
>> btrfs_raid_array[] can maintain the name of the raid type,
>> and so we can kill btrfs_raid_type_names[].
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>> v1->v2:
>>   add space after =. Such as..
>>     +               .raid_name      = "raid10",
>>                                      ^
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -342,6 +342,7 @@ struct btrfs_raid_attr {
>>   	int tolerated_failures; /* max tolerated fail devs */
>>   	int devs_increment;	/* ndevs has to be a multiple of this */
>>   	int ncopies;		/* how many copies to data has */
>> +	char *raid_name;	/* name of the raid */
> 
> There was another comment under v1:
> 
> 	const char raid_name[8]

  Thanks. I fixed this in v3.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
