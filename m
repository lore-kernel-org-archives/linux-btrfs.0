From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Cannot set-default back to ID 0
Date: Sun, 20 Feb 2011 20:20:25 +0000 (UTC)
Message-ID: <ijrt29$onm$1@dough.gmane.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a recent Ubuntu upgrade killed my system. Luckily I had done a btrfs
snapshot before, so I set the particular subvolume as default using

# btrfs subvolume set-default 261 /mnt

from a rescue system and was back up in no time. I then mounted the
original volume with subvolid=0 and repaired it. So far so good.
However, I fail to set the default volume back to the original.

# btrfs subvolume set-default 0 /

apparently does nothing, I don't get an error but I'm still on the
snapshot after reboot. Currently I'm working around this adding
rootflag=subvolid=0 on the kernel command line, but that is kind of
inconvenient.

Is this expected?

Ubuntu natty amd64, Kernel 2.6.38-rc5, btrfs-tools 0.19+20100601 

Thanks
Bernhard

