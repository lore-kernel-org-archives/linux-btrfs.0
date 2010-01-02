From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: 2.6.33-rc2+ bug in fs/btrfs/ordered-data.c:672
Date: Sat, 2 Jan 2010 11:32:27 +0100
Message-ID: <20100102103227.GA3678@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752670Ab0ABKdN@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I started testing btrfs for my /home a few days ago and yesterday
I hit a kernel bug, using 2.6.33-rc2-00187-g08d869a.

I wasn't doing any stress test with it, I was simply watching a
DVD with xine while chrome was open in another workspace.

I noticed the kernel bug when the movie was over and I typed
'echo mem > /sys/power/state' to go to sleep but it got stuck,
so I checked what was happening in dmesg and I saw the bug in there.
By looking at the printk timings the bug was there for ~16 minutes, so
that last suspend to RAM atempt was not guilty in this bug. However,
the laptop was turned on for some hours already and had already passed
through a few suspend to RAM in this period.

I tried to save the dmesg but it failed writing, so I took a picture
of the bug trace

http://www.aei.mpg.de/~crmafra/btrfs_bug.jpg

Some info about my laptop is in this dmesg from this morning

http://www.aei.mpg.de/~crmafra/dmesg-2.6.33-rc2.txt

I hope this helps.
