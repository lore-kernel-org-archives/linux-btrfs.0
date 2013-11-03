Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44401 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3KCSip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 13:38:45 -0500
Received: by mail-ea0-f169.google.com with SMTP id k11so3004103eaj.14
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 10:38:43 -0800 (PST)
Received: from venice.bhome (ppp-140-57.24-151.libero.it. [151.24.57.140])
        by mx.google.com with ESMTPSA id w6sm36385639eeo.12.2013.11.03.10.38.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2013 10:38:43 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC][PATCH] BTRFS_PROG: mount.btrfs helper
Date: Sun,  3 Nov 2013 19:38:40 +0100
Message-Id: <1383503921-6694-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this patch provides a mount.btrfs helper for the mount command to
mounting a btrfs filesystem.
A btrfs filesystem could spans several disks. This helper scans all
the partition to discover all the disks required to mount a filesystem.
So it is not necessary any-more to "scan" manually the partitions to mount
a filesystem via the "btrfs device scan" command.

It adds in the option parameters the devices required to mount a
filesystem. Supposing that a filesystem is composed by several disks
(/dev/sd[cdef]), when the user does "mount /dev/sdd /mnt", mount calls
mount.btrfs which int turn calls the mount(2) syscall like:
mount("/dev/sdd", "/mnt", "btrfs", 0,
"device=/dev/sdc,device=/dev/sde,device=/de/vsdf").

This helper uses both the libblkid and libmount to discover the
devices, to compute the parameters manipulation and to update the mtab
file.

I got the idea from the btrfs.wiki; its biggest gains is to avoid the
separation of scanning phases (at boot time or during the block device
discovery) from the mounting. Also mkfs.btrfs could avoid to re-do a
rescan of the devices after a formatting.

mount.btrfs doesn't add more requirement than the mount command. It
would be possible to remove the "btrfs" command from the initramfs, and
all the related scripts (in my debian both udev and btrfs-tools
packages contains three udev rules for btrfs).

Comments are welcome.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it> 
Key fingerprint BBF5 1610 0B64 DAC6 5F7D 17B2 0EDA 9B37 8B82 E0B5 
