Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50160 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbaEOUoF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 16:44:05 -0400
Message-ID: <5375277C.8040008@fb.com>
Date: Thu, 15 May 2014 16:45:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/locking.c when mounting with previously
 missing device
References: <237483C1-00DF-4576-8C44-56EBCF077B9B@colorremedies.com>
In-Reply-To: <237483C1-00DF-4576-8C44-56EBCF077B9B@colorremedies.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/15/2014 04:40 PM, Chris Murphy wrote:
> Summary: Two device btrfs raid1, as data device not boot/rootfs, mounted and filled with some data. Power off and remove one device. Reboot and mount the single device available with -o degraded. Create new subvolume and fill with some data. Poweroff and reattach previously removed device. Reboot and attempt to mount volume normally and I get a segfault.
> 
> Setup:
> VBox VM, Fedora Rawhide
> 2x 2TB VDIs
> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
> btrfs-progs 3.14-1
> mkfs.btrfs -d raid1 -m raid1 /dev/sd[bc]
> 
> Reproduce steps:
> 1. Mount /dev/sdb /mnt
> 2. btrfs sub create /mnt/subv1
> 3. cp -a /var /mnt/prefill/
> 4. poweroff, remove /dev/sdc
> 5. Boot, mount /dev/sdb /mnt -o degraded
> 6. btrfs sub create /mnt/subv2
> 7. cp -a /boot /mnt/sub2/
> 8. poweroff, reattach /dev/sdc
> 9. Boot, mount /dev/sdb /mnt
> Segmentation fault
> 
> Regression: I know I've done this recently with existing subvolumes (without making new ones while mounting degraded) and it worked OK so I'm not sure how reproducible it is.
> 

Yes, this used to work.  I'll reproduce, things for sending it!

-chris
