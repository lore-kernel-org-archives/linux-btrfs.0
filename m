Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42962 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaGaHHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 03:07:48 -0400
Message-ID: <53D9EB3B.2070703@oracle.com>
Date: Thu, 31 Jul 2014 15:07:39 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-porgs: fix xfstest btrfs/023 random failure
References: <1405589304-7174-1-git-send-email-anand.jain@oracle.com> <20140729125723.GR1553@twin.jikos.cz>
In-Reply-To: <20140729125723.GR1553@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29/07/2014 20:57, David Sterba wrote:
> On Thu, Jul 17, 2014 at 05:28:24PM +0800, Anand Jain wrote:
>> xfstest btrfs/023 which does the following tests
>>
>> create_group_profile "raid0"
>> check_group_profile "RAID0"
>>
>> create_group_profile "raid1"
>> check_group_profile "RAID1"
>>
>> create_group_profile "raid10"
>> check_group_profile "RAID10"
>>
>> create_group_profile "raid5"
>> check_group_profile "RAID5"
>>
>> create_group_profile "raid6"
>> check_group_profile "RAID6"
>>
>> fails randomly with the error as below
>>
>>   ERROR: device scan failed '/dev/sde' - Invalid argument
>>
>> since failure is at random group profile it indicates to me that
>> btrfs kernel did not see the newly created btrfs on the device
>>
>> To note: I have the following patch on the kernel which
>> is not yet integrated, but its not related to this bug.
>>
>> btrfs: RFC: code optimize use btrfs_get_bdev_and_sb() at btrfs_scan_one_device
>
> I guess the error was caused by this patch,

   Yep. I got that understanding when you mentioned about the patch
       btrfs: access superblock via pagecache in scan_one_device

 > and the fsync just made the race window smaller. If you still think
 > the fsync is useful, please update the changelog.

   You mean I should put fsync at more correct places ?

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
