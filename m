From: ibm-main@tpg.com.au
Subject: How to un degrade RAID10.
Date: Mon, 21 Jun 2010 15:43:02 +1000
Message-ID: <1277098982.4c1efbe612349@postoffice.tpg.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I see I'm not the only one to flounder with this. Btrfs v0.19 on
openSuSE 11.3-RC1 (2.6.34-9-default).
I created a RAID10 across 4 partitions - worked fine. Unmounted it and
zeroed one complete partition (as in of=/dev/sda8). Remounted degraded,
looked around, data seemed safe.
Attempted to remove sda8 from the array, but got an ioctl=1. Hmmm.

Did a (normal, non-RAID) mkfs on the partition, then attempted to add it
back as per the wiki. Won't mount without the degraded option even
though the 4 partitions are accepted o.k, and a re-balance worked.
The array now reports as 5 devices with #2 (the original slot for sda8)
now vacant - dare I say "missing". It reports as "*** Some devices missng"
This seems counter intuitive to me. Suggestions ?.
