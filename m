Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932633AbeCJALY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 19:11:24 -0500
Subject: Re: [PATCH] btrfs-progs: dump-tree: add degraded option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180222140011.32713-1-anand.jain@oracle.com>
 <20180309162324.GY23693@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c165f69e-8701-b111-3c07-a75b0a952b6b@oracle.com>
Date: Sat, 10 Mar 2018 08:13:00 +0800
MIME-Version: 1.0
In-Reply-To: <20180309162324.GY23693@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/10/2018 12:23 AM, David Sterba wrote:
> On Thu, Feb 22, 2018 at 10:00:11PM +0800, Anand Jain wrote:
>> btrfs inspect dump-tree cli picks the disk with the largest generation
>> to read the root tree, even when all the devices were not provided in
>> the cli. But in 2 disks RAID1 you may need to know what's in the disks
>> individually, so this option -x | --degraded indicates to use only the
>> given disk to dump.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-inspect-dump-tree.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
>> index df44bb635c9c..587b6081df0c 100644
>> --- a/cmds-inspect-dump-tree.c
>> +++ b/cmds-inspect-dump-tree.c
>> @@ -198,6 +198,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
>>   	"-u|--uuid              print only the uuid tree",
>>   	"-b|--block <block_num> print info from the specified block only",
>>   	"-t|--tree <tree_id>    print only tree with the given id (string or number)",
>> +	"-x|--degraded          For RAID1, use the disk in the arg, do not scan for disks",
> 
> I find this confusing, degraded for kernel means 'mount with anything
> you have' while here it means 'use exactly that disk'.

  Agreed.

> Something that would reflect the "don't scan" would be IMHO better, but
> otherwise the goal of the patch makes sense.

  Hope this is better.

   -x|--noscan


Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
