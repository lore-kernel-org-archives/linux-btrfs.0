Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bear.techie.net ([205.134.185.202]:52277 "EHLO bear.techie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbcAVOyF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 09:54:05 -0500
Date: Fri, 22 Jan 2016 09:53:55 -0500 (EST)
From: Scott Talbert <swt@techie.net>
To: Anand Jain <anand.jain@oracle.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 root filesystem - same device shows up twice in 'btrfs fi
 show'
In-Reply-To: <56A1B312.1010105@oracle.com>
Message-ID: <alpine.DEB.2.10.1601220946210.16794@bear.techie.net>
References: <alpine.DEB.2.10.1601211432430.9575@bear.techie.net> <56A1B312.1010105@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Jan 2016, Anand Jain wrote:

> Thanks for the report.
> Strange. but interesting. Can you pls help to isolate...
>
> On 01/22/2016 03:50 AM, Scott Talbert wrote:
>> Hi,
>> 
>> I'm using:
>> 
>> Kernel 4.2.6
>> btrfs-progs v4.3
>> Debian Wheezy
>> 
>> I have a RAID1 root filesystem with two devices.  When the system
>> initially boots up, "btrfs fi show" will show the same device twice:
>> 
>> Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
>>      Total devices 2 FS bytes used 1.19GiB
>>      devid    1 size 7.60GiB used 3.03GiB path /dev/sdf2
>>      devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2
>> 
>> The filesystem seems to work fine (as best as I can tell) in this state.
>> If I then run another "btrfs device scan", it will correct itself:
>
>
>
>> Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
>>          Total devices 2 FS bytes used 1.19GiB
>>          devid    1 size 7.60GiB used 3.03GiB path /dev/sde2
>>          devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2
>> 
>> Any idea what might be going on here?  On Debian it appears that the
>> initial "btrfs device scan" is being done by an initramfs local-premount
>> script where it does:
>> 
>> modprobe btrfs
>> /bin/btrfs device scan 2>/dev/null
>> 
>> Does there perhaps need to be some delay between inserting the kernel
>> module and running a scan?
>
> May be dev1 is known as sdf initially before bootup and later when
> system boots its known as sde.
>
> I believe /boot is on non btrfs FS?

/boot is on the btrfs rootfs, ie, /dev/sde2 / /dev/sdf2.  I do have a 
bios_grub partition as partition #1 but not a separate /boot partition.

> As this is a root device, Can you tell which "one" device is used for
> the mount in fstab ?

I am using the UUID to mount in fstab:
UUID=49f7413a-99ad-41b0-8783-06c9406e2280 /               btrfs 
defaults 0       1

> Do you see the following log in the bootup logs / dmesg ?
> ------
> printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s %s\n",
> disk_super->fsid, devid, transid, path,
> ret == 2 ? "(overwritten)":"");
> -------

Interestingly, the kernel logs show both devices...

[   10.225915] BTRFS: device fsid 49f7413a-99ad-41b0-8783-06c9406e2280 
devid 2 transid 1033 /dev/sdf2
[   10.226297] BTRFS: device fsid 49f7413a-99ad-41b0-8783-06c9406e2280 
devid 1 transid 1033 /dev/sde2

> Can you provide..
> blkid output

/dev/sde2: UUID="49f7413a-99ad-41b0-8783-06c9406e2280" 
UUID_SUB="692ba0c4-05b9-4681-86c4-b4af9028a533" TYPE="btrfs"
/dev/sdf2: UUID="49f7413a-99ad-41b0-8783-06c9406e2280" 
UUID_SUB="63ee640c-0df0-490c-bff6-91d71a246ed6" TYPE="btrfs"

Thanks,
Scott
