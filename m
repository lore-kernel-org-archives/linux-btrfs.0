Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36354 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933829AbaD3QEP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 12:04:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: SELinux on btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <3219639.10M590kytU@russell.coker.com.au>
Date: Wed, 30 Apr 2014 10:04:13 -0600
Cc: Russell Coker <russell@coker.com.au>
Message-Id: <1334991E-DB91-4AA8-AF51-E11C881AB8C2@colorremedies.com>
References: <4DB89922-7B01-405A-9E63-0CCBBB6481B3@colorremedies.com> <3219639.10M590kytU@russell.coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 30, 2014, at 2:01 AM, Russell Coker <russell@coker.com.au> wrote:

> On Sat, 12 Apr 2014 10:15:25 Chris Murphy wrote:
>>> I'm already aware that SELinux's automatic labelling of files is not
>>> aware of subvolumes[*].> 
>>> [*] https://wiki.debian.org/SELinux/Setup#btrfs
>> 
>> I'm not sure exactly what it means since there is always a subvolume (ID 5),
>> and I don't understand why autorelabel behavior would differ from manually
>> running fixfiles or restorecon.
> 
> When you initially setup SE Linux on Debian you run the command "selinux-
> activate" which configures GRUB and creates a 0 byte file named /.autorelabel .
> 
> On boot if /.autorelabel is detected (as it will on a first install of SE Linux 
> or any time you have a serious labelling problem you want to fix) then a script 
> will run that labels all files and reboots the system (to make daemons run with 
> the correct context).  The script in question is not aware of subvolumes, so 
> if you have writable subvolumes they won't be labelled.  

That has not been my experience. I changed /boot files to have the wrong selinux labels, set .autorelabel, rebooted, and those files were fixed despite /boot being a mount point for a btrfs subvolume named boot located at the top level of the file system, and mounted with an fstab using subvol=boot option.

I can see how unmounted subvolumes won't be visible to any scripts or even restorecon, so maybe that's what's being referred to?


Chris Murphy

