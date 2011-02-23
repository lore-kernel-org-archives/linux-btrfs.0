From: Tobias Brunner <tobias@tobru.ch>
Subject: Kernel 2.6.35 (Ubuntu 10.10): Unable to mount (orphan list)
Date: Wed, 23 Feb 2011 22:57:23 +0100 (CET)
Message-ID: <5a540bbf-a331-46d3-9f38-e7c9e1398152@james>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using btrfs on Ubuntu 10.10 for some test partitions.
After doing some normal operations I suddenly couldn't mount the partition anymore.
I always get the error "BTRFS: inode 120790 still on the orphan list" in the kernel log again and again and it's impossible to stop the mount command or shutdown the system.
Any ideas how to work around this issue?

Thanks!

Best Regards,
Tobias
