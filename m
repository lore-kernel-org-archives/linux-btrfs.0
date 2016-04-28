Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34979 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbcD1L1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 07:27:01 -0400
Received: by mail-ig0-f171.google.com with SMTP id bi2so155571644igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 04:27:00 -0700 (PDT)
Subject: Re: ...in the matter of partition size
To: Chris Murphy <lists@colorremedies.com>,
        Juan Alberto Cirez <jacirez@rdcsafety.com>
References: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
 <CAJCQCtT3tQ=1SopXjbrAp7650z7H9-SpurgpUooCG6A5Kxk-hw@mail.gmail.com>
 <CAJCQCtRXv3AwyvCceO8KX-7HrFyuuysRNH5D_-6ssnJ-rEh_zw@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <69e441ed-a7f5-cea8-21a8-824c77f68018@gmail.com>
Date: Thu, 28 Apr 2016 07:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRXv3AwyvCceO8KX-7HrFyuuysRNH5D_-6ssnJ-rEh_zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-27 22:55, Chris Murphy wrote:
> On Wed, Apr 27, 2016 at 8:51 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Wed, Apr 27, 2016 at 2:18 PM, Juan Alberto Cirez
>> <jacirez@rdcsafety.com> wrote:
>>> Quick question: Supposed I have n-number of storage pods (physical
>>> servers with n-number of physical hhds). The end deployment will be
>>> btrfs at the brick/block level with a distributed file system on top.
>>> Keeping in mind that my overriding goal is to have high availability
>>> and the mechanism whereby the lost of a drive or multiple drives in a
>>> single pod will not jeopardize data.
>>>>>>>> Question<<<<<
>>> Does partitioning the physical drives and creating btrfs filesystem on
>>> each partition, then configuring each partition as individual
>>> bricks/blocks offer ANY added benefits over grouping the entire pod
>>> into a drive pool and using that pool as a single block/brick to
>>> expose to the distributed filesystem?
>>
>> No.
>>
>> Distros typically have libblkid, so 'blkid' command will show you
>> Btrfs is on the drive regardless of partitioning. If the drive might
>> ever see Windows or OS X, then a partition will tell those OS's the
>> drive isn't empty, as they will not recognize Btrfs, but will see the
>> GPT.
>>
>> Since you mention HA, you need to use something other than Btrfs only.
>> The device failure notification right now is slim to none with Btrfs,
>> it's limited really to just kernel messages. So you should looking at
>> hardware raid, or mdadm, or LVM raid, plus XFS. While XFS does not
>> offer data checksumming or snapshotting it does offer metadata
>> checksums in the most recent V5 metadata format.
>
> GlusterFS does have its own checksumming but it's a different
> implementation than ZFS and Btrfs. And it also supports snapshotting.
>
> So it's worth considering bricks be primarily XFS on hardware or mdadm
> raid. And just a smaller set of Btrfs bricks.
>
Actually, if you want to use the snapshotting in GlusterFS (at least 
last I knew), you need to be running on top of LVM, which in turn means 
you _can't_ safely use BTRFS (and possibly the same applies for XFS too) 
in such a situation, because of the UUID issues.

