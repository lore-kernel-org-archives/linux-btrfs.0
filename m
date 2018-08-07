Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeHHA47 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2018 20:56:59 -0400
Subject: Re: [PATCH v3 4/4] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180726065334.30594-5-anand.jain@oracle.com>
 <20180802100934.12468-1-anand.jain@oracle.com>
 <b1c8c566-5850-da69-b756-5036dca33975@suse.com>
 <20180802122136.GM3218@twin.jikos.cz>
 <f2f5a582-1bc4-617a-0d38-6c212d93bb56@oracle.com>
 <20180807150227.GI3218@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3077d216-9eed-5b32-6c89-bffa249da6a6@oracle.com>
Date: Wed, 8 Aug 2018 06:43:53 +0800
MIME-Version: 1.0
In-Reply-To: <20180807150227.GI3218@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/07/2018 11:02 PM, David Sterba wrote:
> On Thu, Aug 02, 2018 at 09:07:00PM +0800, Anand Jain wrote:
>>>>> -	num_devices = fs_devices->num_devices;
>>>>> -	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>>>> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>>>>> -		BUG_ON(num_devices < 1);
>>>>> -		num_devices--;
>>>>> -	}
>>>>> -	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>>>> +	num_devices = btrfs_num_devices(fs_info);
>>>>
>>>> How about lifting the BUG_ON from btrfs_num_devices into a check in this
>>>> function, so if num_devices < 1 then we just exit with -EINVAL or some
>>>> such. We should be aiming at eliminating BUG_ONs.
>>>
>>> Right, in both cases it's possible to return with an error instead of
>>> the BUG_ON.
>>
>> Actually we should just remove it as its a logical bug if num_devices <
>> 1, so long we didn't hit this bug which means its stable OR keep BUG_ON
>> it until we add RAID-N. ?
> 
> I think the BUG_ON is redundant, all the sanity checks at mount time or
> ioctl remove/replace make sure that there are enough devices to perform
> the action. Still, it can be an assert, such things do not hurt and may
> be catch other errors someday.

  Assert makes sense to me. Patch [1] shall be dropped
  [1]
  [PATCH] btrfs: handle the BUG_ON in btrfs_num_devices()

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
