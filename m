Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35723 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751000AbaEOUwf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 16:52:35 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: kernel BUG at fs/btrfs/locking.c when mounting with previously missing device
From: Chris Murphy <chris@colorremedies.com>
In-Reply-To: <5375277C.8040008@fb.com>
Date: Thu, 15 May 2014 14:52:31 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <52C8006F-A060-458E-A8DC-ED13BBA4428A@colorremedies.com>
References: <237483C1-00DF-4576-8C44-56EBCF077B9B@colorremedies.com> <5375277C.8040008@fb.com>
To: Chris Mason <clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 15, 2014, at 2:45 PM, Chris Mason <clm@fb.com> wrote:

> 
> 
> On 05/15/2014 04:40 PM, Chris Murphy wrote:
>> Summary: Two device btrfs raid1, as data device not boot/rootfs, mounted and filled with some data. Power off and remove one device. Reboot and mount the single device available with -o degraded. Create new subvolume and fill with some data. Poweroff and reattach previously removed device. Reboot and attempt to mount volume normally and I get a segfault.
>> 
>> Setup:
>> VBox VM, Fedora Rawhide
>> 2x 2TB VDIs
>> kernel 3.15.0-0.rc5.git0.1.fc21.x86_64
>> btrfs-progs 3.14-1
>> mkfs.btrfs -d raid1 -m raid1 /dev/sd[bc]
>> 
>> Reproduce steps:
>> 1. Mount /dev/sdb /mnt
>> 2. btrfs sub create /mnt/subv1
>> 3. cp -a /var /mnt/prefill/
>> 4. poweroff, remove /dev/sdc
>> 5. Boot, mount /dev/sdb /mnt -o degraded
>> 6. btrfs sub create /mnt/subv2
>> 7. cp -a /boot /mnt/sub2/
>> 8. poweroff, reattach /dev/sdc
>> 9. Boot, mount /dev/sdb /mnt
>> Segmentation fault
>> 
>> Regression: I know I've done this recently with existing subvolumes (without making new ones while mounting degraded) and it worked OK so I'm not sure how reproducible it is.
>> 
> 
> Yes, this used to work.  I'll reproduce, things for sending it!

The same fs mounts normally with 3.14.3-200.fc20.x86_64.

If I then umount and do a btrfs check:

# btrfs check /dev/sdb
Checking filesystem on /dev/sdb
UUID: 270f12a8-a724-494a-8131-4bf4da831239
checking extents
btrfs: cmds-check.c:2266: check_owner_ref: Assertion `!(rec->is_root)' failed.
Aborted (core dumped)

If I mount again and balance then umount and btrfs check, btrfs check is happy. And if I go back at this point to 3.15rc5 it mounts it OK.



Chris Murphy