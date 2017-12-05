Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53521 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdLEBwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 20:52:50 -0500
Subject: Re: [PATCH] btrfs: add helper for device path or missing
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171128024310.31095-1-anand.jain@oracle.com>
 <20171204193116.GA3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3dee80c1-2208-81ef-f315-dfa6e7e6d6cf@oracle.com>
Date: Tue, 5 Dec 2017 09:19:04 +0800
MIME-Version: 1.0
In-Reply-To: <20171204193116.GA3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/05/2017 03:31 AM, David Sterba wrote:
> On Tue, Nov 28, 2017 at 10:43:10AM +0800, Anand Jain wrote:
>> This patch creates a helper function to get either the rcu device path
>> or missing.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 22 +++++++++++-----------
>>   1 file changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 7c655f9a7a50..4b6ceb38cb5f 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -304,6 +304,11 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
>>   		dev_replace->cursor_left_last_write_of_item;
>>   }
>>   
>> +static inline char *dev_missing_or_rcu_str(struct btrfs_device *device)
>> +{
>> +	return device->missing ? "<missing disk>" : rcu_str_deref(device->name);
>> +}
> 
> I'd change it to dev_name, as long as it stays a local helper in
> dev-replace. I'm now merging the dev_state patches which depend on this
> patch so I'll rename it myself so you don't have to refresh and resend
> the patches.

    I am not good at naming, thanks for fixing David.
  - Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
