Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbeDIOnE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 10:43:04 -0400
Subject: Re: [PATCH 10/16] btrfs: remove wrong use of volume_mutex from
 btrfs_dev_replace_start
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
 <14a1aaa2-f079-c3f0-14db-6376f90ee635@oracle.com>
 <20180409115301.GL8557@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <326c8ea1-3c76-a024-a35c-d66b36994689@oracle.com>
Date: Mon, 9 Apr 2018 22:44:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180409115301.GL8557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/09/2018 07:53 PM, David Sterba wrote:
> On Mon, Apr 09, 2018 at 04:39:03PM +0800, Anand Jain wrote:
>>
>>
>> On 04/04/2018 02:34 AM, David Sterba wrote:
>>> The volume mutex does not protect against anything in this case, the
>>> comment about scrub is right but not related to locking and looks
>>> confusing. The comment in btrfs_find_device_missing_or_by_path is wrong
>>> and confusing too.
>>>
>>> The device_list_mutex is not held here to protect device lookup, but in
>>> this case device replace cannot run in parallel with device removal (due
>>> to exclusive op protection), so we don't need further locking here.
>>
>> Agreed, usage of device_list_mutex and volume_mutex is kind of redundant.
>>
>> There are unfinished features in btrfs volume, such as device offline
>> while it was mounted (patches in the ML).
>>
>> It's better to replace volume_mutex with device_list_mutex instead of
>> removing it, as we might need it in the context mentioned above.
> 
> The device_list_mutex will not do anything useful here. It's taken in
> contexts where we need to make sure the device list is locked for writes
> or we don't want to let the device disappear (superblock write).
> 
> As dev-replace requires the device to exist throughout the whole
> operation (src_device), the EXCL_OP bit is the correct protection and we
> can't hold device_list_mutex throughout the whole
> btrfs_dev_replace_start.
 >
>> Or it's not a good idea to clean up until all the features are in place
>> otherwise we end up adding the locks again at some point.
> 
> The lock is redundant and no new code should depend on it. If you're
> going to add a more fine grained locking of devices, then we can revisit
> what's the best way to do it and I'm quite sure this will not require
> re-adding the volume_mutex as it is used now.

Agreed.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
