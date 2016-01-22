Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24288 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcAVEmI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 23:42:08 -0500
Subject: Re: RAID1 root filesystem - same device shows up twice in 'btrfs fi
 show'
To: Scott Talbert <swt@techie.net>, linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.10.1601211432430.9575@bear.techie.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56A1B312.1010105@oracle.com>
Date: Fri, 22 Jan 2016 12:41:54 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1601211432430.9575@bear.techie.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the report.
  Strange. but interesting. Can you pls help to isolate...

On 01/22/2016 03:50 AM, Scott Talbert wrote:
> Hi,
>
> I'm using:
>
> Kernel 4.2.6
> btrfs-progs v4.3
> Debian Wheezy
>
> I have a RAID1 root filesystem with two devices.  When the system
> initially boots up, "btrfs fi show" will show the same device twice:
>
> Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
>      Total devices 2 FS bytes used 1.19GiB
>      devid    1 size 7.60GiB used 3.03GiB path /dev/sdf2
>      devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2
>
> The filesystem seems to work fine (as best as I can tell) in this state.
> If I then run another "btrfs device scan", it will correct itself:



> Label: none  uuid: 49f7413a-99ad-41b0-8783-06c9406e2280
>          Total devices 2 FS bytes used 1.19GiB
>          devid    1 size 7.60GiB used 3.03GiB path /dev/sde2
>          devid    2 size 7.60GiB used 3.01GiB path /dev/sdf2
>
> Any idea what might be going on here?  On Debian it appears that the
> initial "btrfs device scan" is being done by an initramfs local-premount
> script where it does:
>
> modprobe btrfs
> /bin/btrfs device scan 2>/dev/null
>
> Does there perhaps need to be some delay between inserting the kernel
> module and running a scan?

May be dev1 is known as sdf initially before bootup and later when
system boots its known as sde.

I believe /boot is on non btrfs FS?

As this is a root device, Can you tell which "one" device is used for
the mount in fstab ?

Do you see the following log in the bootup logs / dmesg ?
------
printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s %s\n",
disk_super->fsid, devid, transid, path,
ret == 2 ? "(overwritten)":"");
-------

Can you provide..
  blkid output



Thanks, Anand

