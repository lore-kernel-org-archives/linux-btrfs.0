Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLEDON (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 22:14:13 -0500
Message-ID: <54812391.3090505@oracle.com>
Date: Fri, 05 Dec 2014 11:16:33 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
References: <547B5724.1060507@libero.it> <547FC24A.9000107@oracle.com> <5480A0C3.5050708@inwind.it>
In-Reply-To: <5480A0C3.5050708@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/12/2014 01:58, Goffredo Baroncelli wrote:
> On 12/04/2014 03:09 AM, Anand Jain wrote:
>>
>>
>> On 01/12/2014 01:43, Goffredo Baroncelli wrote:
>>> Hi all,
>>>
>>> this patch provides a "mount.btrfs" helper for the mount command. A
>>> btrfs filesystem could span several disks. This helper scans all
>>> the partitions to discover all the disks required to mount a
>>> filesystem. So it would not necessary any-more to "scan" the
>>> partitions to mount a filesystem.
>>>
>>> mount.btrfs passes in the option parameters the devices required to
>>> mount a filesystem. Supposing that a filesystem is composed by
>>> several disks (/dev/sd[cdef]), when the user runs "mount /dev/sdd
>>> /mnt", mount.btrfs is called and it executes the the mount(2)
>>> syscall as below:
>>>
>>> mount("/dev/sdd", "/mnt", "btrfs", 0, "device=/dev/sdc,device=/dev/sde,device=/de/vsdf").
>>
>>
>> in linux its bit messy that there are different name/paths to the
>> same device, its the way it is. So btrfs-progs normalizes these paths
>> to "a" thing and provide it to the kernel during btrfs dev scan.
>> since device path normalization is done at the user space level not
>> in the kernel, the device paths sent using mount option would miss
>> this part.
>
> Good point. I have to normalize the path. I put this in my todo list.


for normalization to be effective in the long term it has to be at a 
single common place, kernel ? Jeff Mahoney seems to agree as well.. 
follow ups of this patch.. may help.
    [PATCH] btrfs-progs: canonicalize pathnames for device commands


Thanks, Anand

> What I am not sure is the case when the user passes the devices via
> device=.... options explicitly.
> In this case I prefer to leave these as are... The (super user) know what
> he is doing....
>
>>
>> -Anand
>>
>>
> [...]
>
>
