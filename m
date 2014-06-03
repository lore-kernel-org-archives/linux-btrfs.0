Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27082 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaFCDsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:48:02 -0400
Message-ID: <538D455E.90507@oracle.com>
Date: Tue, 03 Jun 2014 11:47:42 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 3/4] btrfs: dev replace should replace the sysfs entry
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com> <1401096626-13210-4-git-send-email-anand.jain@oracle.com> <20140529132939.GD29992@twin.jikos.cz> <538835DB.5040900@oracle.com>
In-Reply-To: <538835DB.5040900@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

inline below.


On 30/05/2014 15:40, Anand Jain wrote:
>
>
>
> On 29/05/14 21:29, David Sterba wrote:
>> On Mon, May 26, 2014 at 05:30:25PM +0800, Anand Jain wrote:
>>> when we replace the device its corresponding sysfs
>>> entry has to be replaced as well
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/dev-replace.c |    5 +++++
>>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>>> index 9f22905..f4f8728 100644
>>> --- a/fs/btrfs/dev-replace.c
>>> +++ b/fs/btrfs/dev-replace.c
>>> @@ -36,6 +36,7 @@
>>>   #include "check-integrity.h"
>>>   #include "rcu-string.h"
>>>   #include "dev-replace.h"
>>> +#include "sysfs.h"
>>>
>>>   static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>>                          int scrub_ret);
>>> @@ -562,6 +563,10 @@ static int btrfs_dev_replace_finishing(struct
>>> btrfs_fs_info *fs_info,
>>>           fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>>>       list_add(&tgt_device->dev_alloc_list,
>>> &fs_info->fs_devices->alloc_list);
>>>
>>> +    /* replace the sysfs entry */
>>> +    rm_device_membership(fs_info, src_device);
>>> +    add_device_membership(fs_info, tgt_device);
>>> +
>>>       btrfs_rm_dev_replace_blocked(fs_info);
>>>
>>>       btrfs_rm_dev_replace_srcdev(fs_info, src_device);
>>
>> 569         btrfs_rm_dev_replace_unblocked(fs_info);
>> 570
>>
>> The comment that follows says
>>
>> 571         /*
>> 572          * this is again a consistent state where no dev_replace
>> procedure
>> 573          * is running, the target device is part of the
>> filesystem, the
>> 574          * source device is not part of the filesystem anymore and
>> its 1st
>> 575          * superblock is scratched out so that it is no longer
>> marked to
>> 576          * belong to this filesystem.
>> 577          */
>>
>> and I think this is the right place to put the sysfs updates, because the
>> srcdev is processed.
>
> Looking into this, will update. Thanks for the review.

  btrfs_rm_dev_replace_srcdev()  would destroy the btrfs_device of
  src_device, and I am removing its sys/fs entry before we destroy
  btrfs_device of src_device. Which is logically correct.

  Further, RFC like 6/6 would depend on the btrfs_device struct,
  so we have to call btrfs_kobj_rm_device() before
  btrfs_rm_dev_replace_srcdev()

  Also I did some extra tests and code walk I don't see any case
  which it would fail by calling btrfs_rm_dev_replace_srcdev()
  before btrfs_rm_dev_replace_srcdev().

  V2 for this patch-set has been sent out.

Thanks, Anand

>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
