Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727261AbeGMLmd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 07:42:33 -0400
Subject: Re: [PATCH 3/3] btrfs: add helper function check device delete able
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180710182241.23754-1-anand.jain@oracle.com>
 <20180710182241.23754-3-anand.jain@oracle.com>
 <caf594a1-0c04-ef34-a653-50b7210cf340@suse.com>
 <bda57fbe-9451-42f4-391d-a6b5eb52dfa8@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1bacfda8-7975-c422-3891-73c8743e2739@suse.com>
Date: Fri, 13 Jul 2018 14:28:14 +0300
MIME-Version: 1.0
In-Reply-To: <bda57fbe-9451-42f4-391d-a6b5eb52dfa8@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.07.2018 14:27, Anand Jain wrote:
> 
> 
> On 07/12/2018 03:43 PM, Nikolay Borisov wrote:
>>
>>
>> On 10.07.2018 21:22, Anand Jain wrote:
>>> Move the section of the code which performs the check if the device is
>>> indelible, move that into a helper function.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/volumes.c | 49
>>> ++++++++++++++++++++++++++++++-------------------
>>>   1 file changed, 30 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 59a6d8f42c98..feb29c5b44f6 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -1945,6 +1945,33 @@ static inline u64 btrfs_num_devices(struct
>>> btrfs_fs_info *fs_info)
>>>       return num_devices;
>>>   }
>>>   +static struct btrfs_device *btrfs_device_delete_able(
>>
>> Ugliest name ever! So this function is not really a predicate, rather
>> it's used to fetch the struct btrfs_device * to delete. So a more
>> becoming name would be:
>>
>> btrfs_get_device_for_delete - though this a bit verbose.
>>
>> I guess btrfs_can_delete_device is more suitable if you want to follow
>> this predicate style. At the very least, though, the correct form of the
>> adjective is deletable so it should be btrfs_device_deletable. But as I
>> said this function is not really used as a predicate.
> 
>  Its a predicate, return of the device pointer is just a by-product.
>  Will use btrfs_device_deletable().

Then it's fundamentally wrong, a predicate should really return true or
false. This function actually tries to acquire a device which will only
happen if it meets certain criterion, so I'm inclined to say it's not
really a predicate but rather tries to acquire a reference to a device
which meets certain criteria.

<snip>
