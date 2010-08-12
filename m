From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: machine gets unresponsive during btrfs balance
Date: Thu, 12 Aug 2010 09:14:10 +0200
Message-ID: <4C639F42.3050206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using a btrfs filesystem created with raid0 for data and metadata
for (temporary) storage of tv recordings from my vdr. The filesystem was
created under kernel version 2.6.34. An initial btrfs balance command
succeeded. Since I upgraded to 2.6.35-rcX and 2.6.35 btrfs balance no
longer finishes but puts the machine in some unresponsive state.
Unfortunately, I do not see any kernel oops or other debug information
because even the display freezes. The last thing that happens are that
those two lines are written to /var/log/messages:
Aug 11 21:42:23 thor kernel: btrfs: found 62911 extents
Aug 11 21:42:24 thor kernel: btrfs: relocating block group 1723913469952
flags 9
After that the machine becomes immediately unresponsive.

As I did not see anything that might be related to my problem in the
changelog for 2.6.35.1 I did not try again with this version.

Thanks,
Andreas

