From: Felix Blanke <felixblanke@gmail.com>
Subject: Bug in mkfs.btrfs?!
Date: Sat, 22 Jan 2011 15:45:13 +0100
Message-ID: <20110122144513.GA2539@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I wanted to create a new btrfs fs for my backups.
When trying to mkfs.btrfs for that  device, I'm getting

"error checking /dev/loop2 mount status"


With strace I see where the problem is:

lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par",
0x7fffa30b3cf0) = -1 ENOENT (No such file or directory)



The problem is there is something missing at the end of the link, should be
something like "-part1", "-part2" etc.


I'll try the patch with the --foce option.

Regards,
Felix

