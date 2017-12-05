Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752943AbdLEJQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:16:29 -0500
Subject: Re: [PATCH 4/7] btrfs-progs: Use list_for_each_entry in
 write_dev_all_supers
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-5-git-send-email-nborisov@suse.com>
 <21bc180f-83ca-2be8-8c41-ea1e86dca0fe@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cdf2b011-96ee-5114-87ea-a905c011a0ba@suse.com>
Date: Tue, 5 Dec 2017 11:16:26 +0200
MIME-Version: 1.0
In-Reply-To: <21bc180f-83ca-2be8-8c41-ea1e86dca0fe@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.12.2017 11:14, Qu Wenruo wrote:
> 
> 
> On 2017年12月05日 16:39, Nikolay Borisov wrote:
>> No need to use extra variable and 2 macros when we can succintly use 1.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Straightforward cleanup.
> 
> Although I found several other places with the same problem.
> 
> It would be better to address them all in one patch.
> (3 in volumes.c 1 in utils.c and 1 in cmds-filesystem.c)

I will fold them then and resend this patch.

> 
> Thanks,
> Qu
>> ---
>>  disk-io.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index f5edc4796619..3d8785d5bb37 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1556,7 +1556,6 @@ static int write_dev_supers(struct btrfs_fs_info *fs_info,
>>  
>>  int write_all_supers(struct btrfs_fs_info *fs_info)
>>  {
>> -	struct list_head *cur;
>>  	struct list_head *head = &fs_info->fs_devices->devices;
>>  	struct btrfs_device *dev;
>>  	struct btrfs_super_block *sb;
>> @@ -1566,8 +1565,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
>>  
>>  	sb = fs_info->super_copy;
>>  	dev_item = &sb->dev_item;
>> -	list_for_each(cur, head) {
>> -		dev = list_entry(cur, struct btrfs_device, dev_list);
>> +	list_for_each_entry(dev, head, dev_list) {
>>  		if (!dev->writeable)
>>  			continue;
>>  
>>
> 
