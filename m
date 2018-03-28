Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751166AbeC1GMo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 02:12:44 -0400
Subject: Re: [PATCH 6/8] btrfs: verify checksum when superblock is read for
 scan
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-7-anand.jain@oracle.com>
 <d44f6480-016f-2f32-c823-013011d66788@suse.com>
 <e64a1c27-1dee-ce15-1ad2-738d98d19723@suse.com>
 <761e4a64-0e33-11a7-b265-3428eb12c626@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4219f6b9-0e8d-d6a7-1fb8-f526b267e290@suse.com>
Date: Wed, 28 Mar 2018 09:12:41 +0300
MIME-Version: 1.0
In-Reply-To: <761e4a64-0e33-11a7-b265-3428eb12c626@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.03.2018 02:01, Anand Jain wrote:
> 
> 
>>>> Test script:
>>>>
>>>>   Corrupt primary superblock and check if device scan and mount
>>>>   fails:
>>>>   mkfs.btrfs -fq /dev/sdc
>>>>   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
>>>>   btrfs dev scan
>>>>   mount /dev/sdb /btrfs
>>>>
>>>>   Corrupt secondary superblock and check if device scan and mount
>>>>   is succcessful, check for the dmesg for errors.
>>>>   mkfs.btrfs -fq /dev/sdc
>>>>   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
>>>>   btrfs dev scan
>>>>   mount /dev/sdb /btrfs
>>>
>>> Have you considered adding fstests, it will be very easy to test for
>>> this behavior?
> 
>  This is one off kind of bug, not sure if it would value add
>  for checking it all the time in xfstests?
> 

It's some btrfs-specific behavior which in order to not regress in the
future it will be best to have tests for. IMO whatever we can test
should be tested to ensure maintainability. I think a btrfs-specific
test wouldn't hurt here.

> 
>>> Same comment as before regarding string literals splitting across lines.
> 
> accepted.
> 
> 
>>>> +        else
>>>> +            pr_err("BTRFS error (device %pg): "\
>>>> +                "superblock checksum failed, bytenr=%llu",
>>>> +                bdev, bytenr);
>>>> +        btrfs_release_disk_super(*page);
>>>> +        return err;
>>>> +    }
>>
>> Also it will be better to have the checksum check after we have verified
>> some basic invariants - that bytenr and magic have sane values.
> 
>  accepted.
> 
> Thanks,
> Anand
> 
