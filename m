Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:36684 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932455AbaLDR6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 12:58:31 -0500
Message-ID: <5480A0C3.5050708@inwind.it>
Date: Thu, 04 Dec 2014 18:58:27 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
References: <547B5724.1060507@libero.it> <547FC24A.9000107@oracle.com>
In-Reply-To: <547FC24A.9000107@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/04/2014 03:09 AM, Anand Jain wrote:
> 
> 
> On 01/12/2014 01:43, Goffredo Baroncelli wrote:
>> Hi all,
>> 
>> this patch provides a "mount.btrfs" helper for the mount command. A
>> btrfs filesystem could span several disks. This helper scans all
>> the partitions to discover all the disks required to mount a
>> filesystem. So it would not necessary any-more to "scan" the
>> partitions to mount a filesystem.
>> 
>> mount.btrfs passes in the option parameters the devices required to
>> mount a filesystem. Supposing that a filesystem is composed by
>> several disks (/dev/sd[cdef]), when the user runs "mount /dev/sdd
>> /mnt", mount.btrfs is called and it executes the the mount(2)
>> syscall as below:
>> 
>> mount("/dev/sdd", "/mnt", "btrfs", 0, "device=/dev/sdc,device=/dev/sde,device=/de/vsdf").
> 
> 
> in linux its bit messy that there are different name/paths to the
> same device, its the way it is. So btrfs-progs normalizes these paths
> to "a" thing and provide it to the kernel during btrfs dev scan. 
> since device path normalization is done at the user space level not
> in the kernel, the device paths sent using mount option would miss
> this part.

Good point. I have to normalize the path. I put this in my todo list.

What I am not sure is the case when the user passes the devices via 
device=.... options explicitly.
In this case I prefer to leave these as are... The (super user) know what 
he is doing....

> 
> -Anand
> 
> 
[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
