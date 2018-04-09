Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbeDIJ3b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 05:29:31 -0400
Subject: Re: [PATCH 10/16] btrfs: remove wrong use of volume_mutex from
 btrfs_dev_replace_start
To: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
 <14a1aaa2-f079-c3f0-14db-6376f90ee635@oracle.com>
 <fabf9ea7-19e9-5ce3-e529-6f6dbb38e416@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ac0e6f56-b87d-d434-4209-52a8214f7e9b@oracle.com>
Date: Mon, 9 Apr 2018 17:31:28 +0800
MIME-Version: 1.0
In-Reply-To: <fabf9ea7-19e9-5ce3-e529-6f6dbb38e416@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/09/2018 04:54 PM, Nikolay Borisov wrote:
> 
> 
> On  9.04.2018 11:39, Anand Jain wrote:
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
>>
>> Or it's not a good idea to clean up until all the features are in place
>> otherwise we end up adding the locks again at some point.
> 
> It's better that cleanups go so they leave the code in a better shape
> than it is. Then when/if the missing features are complete and the
> patches that implement them contain proper explanation how locking
> works the code can be committed.
> 
> Taking into account how there is preparatory code in btrfs for features
> which haven't landed for quite some time (i.e the in-band dedup stuff)
> I'm against people future-proofing without clear path to merging the
> feature the future-proofing pertains to.

  Ok. Lets clean it up first.

Thanks, Anand
