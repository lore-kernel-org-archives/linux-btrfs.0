Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753973AbeGCJHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 05:07:32 -0400
Subject: Re: [PATCH 2/2] btrfs: fix missing superblock update in the device
 delete commit transaction
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180703051259.2745-1-anand.jain@oracle.com>
 <20180703051259.2745-2-anand.jain@oracle.com>
 <f78d6d0c-40b0-4716-497d-01a5404dd8aa@suse.com>
 <ea80daee-9411-40d0-6909-6d34810e5839@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5598187a-b281-b05c-364e-4afd00cca91a@suse.com>
Date: Tue, 3 Jul 2018 12:07:28 +0300
MIME-Version: 1.0
In-Reply-To: <ea80daee-9411-40d0-6909-6d34810e5839@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.07.2018 12:07, Anand Jain wrote:
> 
> 
> On 07/03/2018 01:56 PM, Nikolay Borisov wrote:
>>
>>
>> On  3.07.2018 08:12, Anand Jain wrote:
>>> When a device is deleted, the btrfs_super_block::number_devices is
>>> reduced by 1, but we do that after the commit transaction, so this
>>> change did not made it to the disk and waits for the next commit
>>> transaction whenever it happens.
>>>
>>> This can be easily demonstrated using the following test case where I
>>> use the btrfs device ready cli to read the disk and report.
>>>
>>>    mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
>>>    mount $dev1 /btrfs
>>>    btrfs dev del $dev2 /btrfs
>>>    btrfs dev ready $dev1; echo RESULT=$? <-- 1
>>>     Without this patch RESULT returns 1, indicating not ready!
>>>
>>>    Testing with a seed device:
>>>
>>>    mkfs.btrfs -fq $dev1
>>>    btrfstune -S1 $dev1
>>>    mount $dev1 /btrfs
>>>    btrfs dev add -f $dev2 /btrfs
>>>    umount /btrfs
>>>    mount $dev2 /btrfs
>>>    btrfs dev del $dev1 /btrfs
>>>    btrfs dev ready $dev2; echo RESULT=$? <-- 1
>>
>> Turn those into fully fledged xfstests
> 
>  Thanks for the review. Though that popped-up in my mind I
>  didn't do it as because its one off bug test. Anyway as you
>  think its a good idea I sent one in the ML.

IMO every bug which can be tested should be tested for. This enables
having a wide range of regressions tests and future changes passing
those regressions test will bear higher confidence of correctness.

