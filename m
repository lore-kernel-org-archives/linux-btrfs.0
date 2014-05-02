Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40225 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEBBvJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 21:51:09 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: SELinux on btrfs
Date: Fri, 2 May 2014 11:51:05 +1000
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <4DB89922-7B01-405A-9E63-0CCBBB6481B3@colorremedies.com> <3219639.10M590kytU@russell.coker.com.au> <1334991E-DB91-4AA8-AF51-E11C881AB8C2@colorremedies.com>
In-Reply-To: <1334991E-DB91-4AA8-AF51-E11C881AB8C2@colorremedies.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201405021151.06080.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 1 May 2014, Chris Murphy <lists@colorremedies.com> wrote:
> That has not been my experience. I changed /boot files to have the wrong
> selinux labels, set .autorelabel, rebooted, and those files were fixed
> despite /boot being a mount point for a btrfs subvolume named boot located
> at the top level of the file system, and mounted with an fstab using
> subvol=boot option.
> 
> I can see how unmounted subvolumes won't be visible to any scripts or even
> restorecon, so maybe that's what's being referred to?

Yes I believe that the problem is anything that looks like a separate 
filesystem to stat() but doesn't have an entry in /proc/mounts.  So if you 
mount the subvols separately then there's no problem.

Another thing is that if the subvols aren't needed for booting (IE /home) then 
you can just manually label them either before or after the autorelabel boot.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
