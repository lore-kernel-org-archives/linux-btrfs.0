Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeITOqj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 10:46:39 -0400
Subject: Re: Punch hole on full fs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
 <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
Date: Thu, 20 Sep 2018 17:04:05 +0800
MIME-Version: 1.0
In-Reply-To: <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/20/2018 04:45 PM, Qu Wenruo wrote:
> 
> 
> On 2018/9/20 下午1:26, anand.jain@oracle.com wrote:
>>
>>
>> Test script [1] tries to punch hole on a full FS and it works fine as
>> long as the hole size and the offset is aligned with the sectorsize and
>> the extent, so that it could just drop the relevant extent to create the
>> hole.
>>
>> The reason why this test fails for non aligned hole size and offset is
>> because, as it rightfully tries to truncate the non aligned extent at
>> the front and back of the hole, it tries to create new extent which ends
>> up with ENOSPC.
> 
> This is what btrfs should do, I don't see any problem though.
> 
>>
>> Any idea, how do we solve this?
> 
> I don't really think this is a problem though.
> 
> As long as we need to do data COW, such ENOSPC would happen.

It happens even with '-o max_inline=0 -o nodatacow' so certainly there 
is some problem, but looking at btrfs_punch_hole() it apparently looks 
like there is no way to fix this as sub-sectorsize hole-size depends on 
the truncate which needs to alloc space.

>>
>> xfs is fine.
> 
> Of course xfs is fine, XFS defaults to do NODATACOW, in contrast to
> btrfs' default DATACOW.
> 
> Have you tried to do the same when the file is reflinked?

  No but I presume it will rightfully fail.

Thanks, -Anand

> Thanks,
> Qu
> 
>>
>> [1]
>> cat ./punch-hole-on-full-fs
>> ------------------------
>> cleanup()
>> {
>>      umount /dev/sdb > /dev/null 2>&1
>>      btrfs_reload
>> }
>>
>> full_fs_setup()
>> {
>>      btrfs-dyndbg disable
>>      mkfs.$fs -b 200M -fq $mkfs_options /dev/sdb || exit
>>      mount $mount_options /dev/sdb /mnt/scratch || exit
>>      dd status=none if=/dev/zero of=/mnt/scratch/filler bs=512 >
>> /dev/null 2>&1
>> }
>>
>> test()
>> {
>>      cleanup
>>      full_fs_setup
>>
>>      btrfs-dyndbg enable
>>      echo "---- fallocate -p -o 0 -l $punch_hole_size /mnt/scratch/filler
>> ----"
>>      fallocate -p -o 0 -l $punch_hole_size /mnt/scratch/filler
>> }
>>
>> fs=btrfs; mkfs_options=""; mount_options="";
>> [[ $1 ]] || { echo "usage: $0 <hole-len>"; exit; }
>> punch_hole_size=$1 && test
>> ------------------------
>>
>> ./punch-hole-on-full-fs 512
>> -- fallocate -p -o 0 -l 512 /mnt/scratch/filler --
>> fallocate: /mnt/scratch/filler: fallocate failed: No space left on device
>>
>> ./punch-hole-on-full-fs 8000
>> -- fallocate -p -o 0 -l 8000 /mnt/scratch/filler --
>> fallocate: /mnt/scratch/filler: fallocate failed: No space left on device
>>
>>
>> Thanks, Anand
> 
