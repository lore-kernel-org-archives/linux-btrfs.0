From: Mikael Andersson <mikael@develog.se>
Subject: 'ioctl:: Inappropriate ioctl for device' when trying to shrink
 partition
Date: Wed, 12 Jan 2011 19:45:15 +0100
Message-ID: <1294857915.7377.14.camel@develog-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

E.g. btrfsctl -r -4000m /dev/sda5

results in:
ioctl:: Inappropriate ioctl for device

Distribution: Ubuntu 10.10
Kernel: 2.6.35-22-generic

According to the Synaptic Package manager, the version of btrfs-tools is
0.19+20100601-3

Other information that can be of interest:
- I started Ubuntu on a live CD
- before invoking the btrfsctl command I invoked apt-get update.

I have googled but have not found anything that seems to help me.

I have searched for "resize" on the following pages but have not find
anything:
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
https://btrfs.wiki.kernel.org/index.php/Gotchas

Thanks,

Mikael

