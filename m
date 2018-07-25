Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46610 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbeGYO3h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 10:29:37 -0400
Subject: Re: [PATCH v2 2/2] btrfs: fix missing superblock update in the device
 delete commit transaction
To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180703090724.22023-1-anand.jain@oracle.com>
 <20180703090724.22023-2-anand.jain@oracle.com>
 <20180721060113.GC575@fnst.localdomain>
 <4eba0d60-ef13-314e-0725-634a6113331a@oracle.com>
 <20180724092803.GG575@fnst.localdomain>
 <20180724110143.GU26141@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2099801d-e375-42b2-85b6-3be36dd248b5@oracle.com>
Date: Wed, 25 Jul 2018 21:21:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180724110143.GU26141@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/24/2018 07:01 PM, David Sterba wrote:
> On Tue, Jul 24, 2018 at 05:28:03PM +0800, Lu Fengqi wrote:
>>> I can't reproduce the issue. Do you reproduce consistently? and I
>>
>> Sorry I've taken so long to reply.
>>
>> There are four virtual machines with the different storage backend here.
>> And I can reproduce this issue consistently on the virtual machines (with
>> HDD or qcow2 file in HDD), however, I can't reproduce on the virtual machine
>> (with SSD or qcow2 file in SSD). So this may depend on the disk IO speed.
>>
>>> wonder if your workspace contains the latest changes from
>>> kdave/misc-next? Because last weeks kdave/misc had some issues.
>>> Can you please give a try?
>>
>> I used the latest kdave/misc-next branch on July 21, 2018, when I send
>> the previous mail. Just as David replied to Nikolay's thread, the current
>> latest kdave/misc-next still has the same problem.
> 
> I hit that on a physical machine with a mix of HDD and SSD drives under
> fstests. The VM tests did not hit the problem.


I couldn't reproduce this no matter what I try (physical machine, HDD
SDD,vbox, etc). But theoretically I have found what is going wrong.

This patch only let the problem in the btrfs_shrink_device() to
surface and it did not create it. The problem is due to
btrfs_shrink_device() did not call the commit transaction after the
device has been added to the fs_devices::resize_devices, which before
(this patch) the btrfs_rm_dev_item() did the commit transaction for the
btrfs_shrink_device().

I am sending a patch to fix. Thanks;

Anand





> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
