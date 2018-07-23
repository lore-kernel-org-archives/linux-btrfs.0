Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388127AbeGWPTk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:19:40 -0400
Subject: Re: [PATCH 6/7] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-7-anand.jain@oracle.com>
 <20180719115332.GI26141@twin.jikos.cz>
 <d3fc6178-0884-28cf-ac3e-e42a00682150@oracle.com>
 <20180723135743.GM26141@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ee739366-6513-ca1a-4af8-e2bd1a8fd227@oracle.com>
Date: Mon, 23 Jul 2018 22:21:35 +0800
MIME-Version: 1.0
In-Reply-To: <20180723135743.GM26141@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/23/2018 09:57 PM, David Sterba wrote:
> On Fri, Jul 20, 2018 at 07:18:54PM +0800, Anand Jain wrote:
>>
>>
>> On 07/19/2018 07:53 PM, David Sterba wrote:
>>> On Mon, Jul 16, 2018 at 10:58:11PM +0800, Anand Jain wrote:
>>>> When the replace is running the fs_devices::num_devices also includes
>>>> the replace device, however in some operations like device delete and
>>>> balance it needs the actual num_devices without the repalce devices, so
>>>> now the function btrfs_num_devices() just provides that.
>>>
>>> We can't run any two from device delete, device replace or balance at
>>> the same time.
>>>
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>> v2: add comments. Thanks Nikolay.
>>>>
>>>>    fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
>>>>    1 file changed, 18 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 0f4c512aa6b4..1c0b56374992 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -1844,6 +1844,21 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
>>>>    		fs_info->fs_devices->latest_bdev = next_device->bdev;
>>>>    }
>>>>    
>>>> +/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
>>>> +static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +	u64 num_devices = fs_info->fs_devices->num_devices;
>>>> +
>>>> +	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>>> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>>>> +		WARN_ON(num_devices < 1);
>>>> +		num_devices--;
>>>> +	}
>>>> +	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>
>>
>>
>>> This does not make sense, besides that > btrfs_dev_replace_is_ongoing is
>>> always going to be false here,
>>
>>    No. There is a way how balance and replace could co-exists.
>>    (theoretically, I didn't experiment it yet)
>>    . Start balance and pause it
>>    . Now start the replace
>>    . power-fail
>>    . The open_ctree() first starts the balance so it must check
>>    for the replace device otherwise our num_devices calculation will
>>    be wrong. IMO its not a good idea to remove the replace check here.
> 
> I see, the paused states can lead to balance that sees device replace
> ongoing as true. This would be good to add to the function comment as
> it's not quite obvious why the helper is needed.
> 
>>    For now a consolidation as in this patch is better.
> 
> Yeah, for this context it would be good.  The function name could be
> more descriptive what devices it actually counts.

Regarding function names its tough to convince in a short form.
As of now I have the following choices, if there is anything better
I don't mind using it though.
   btrfs_num_devices_minus_replace()
   btrfs_get_num_devices_raw()
   btrfs_num_devices_raw()

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
