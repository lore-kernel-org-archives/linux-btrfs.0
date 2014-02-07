Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46163 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGWUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 17:20:39 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WBtmo-0006om-Kt
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 14:20:38 -0800
Date: Fri, 7 Feb 2014 14:20:38 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs snapshot is killing IO and hanging my device with delayed writes for 10mn+
Message-ID: <20140207222038.GZ9265@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On my workstation, which unfortunately I can't easily upgrade the kernel on,
so it's running 3.8.0 for now, I've had pretty perpelexing hangs from btrfs snapshot
when I make a new snapshot every hour.

I see the btrfs snapshot command in iotop for over a minute, and it completes eventually.
Other times, it just runs with virtually no IO.

When it takes a while, I see this next in iotop for several minutes:
Total DISK READ:       0.00 B/s | Total DISK WRITE:       2.12 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND           
 1620 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 % [btrfs-transacti]
  658 be/3 root        0.00 B/s   28.46 K/s  0.00 % 62.35 % [jbd2/dm-0-8]

The device is indeed on top of an LVM, which likely isn't helping performance
(I see only 2.12 M/s of writes in the iotop above):
sda                                     8:0    0 931.5G  0 disk  
├─sda1                                  8:1    0   243M  0 part  /boot
├─sda2                                  8:2    0     1K  0 part  
└─sda5                                  8:5    0 931.3G  0 part  
  ├─moremagic-root (dm-0)             252:0    0  37.3G  0 lvm   /
  ├─moremagic-usr+local (dm-1) 252:1    0   878G  0 lvm   

Today, it took about 10mn for IO to go back to normal (stop blocking) to that
partition during my noon snapshot. The later ones didn't hang.
Why would a snapshot cause hangs and so much IO?


hdparm shows that basic IO seems ok:
root@polgara:/tmp# hdparm -t /dev/mapper/moremagic-usr+local 
/dev/mapper/moremagic-usr+local:
 Timing buffered disk reads: 566 MB in  3.00 seconds = 188.49 MB/sec

root@polgara:/tmp# btrfs fi show
Label: 'btrfs_pool1'  uuid: 64eafeba-603e-483f-bff9-395b9907b415
	Total devices 1 FS bytes used 443.76GB
	devid    1 size 877.98GB used 541.54GB path /dev/dm-1

root@polgara:/tmp# btrfs device stats /mnt/btrfs_pool1
[/dev/mapper/moremagic-usr+local].write_io_errs   0
[/dev/mapper/moremagic-usr+local].read_io_errs    0
[/dev/mapper/moremagic-usr+local].flush_io_errs   0
[/dev/mapper/moremagic-usr+local].corruption_errs 0
[/dev/mapper/moremagic-usr+local].generation_errs 0

Is there other data I can provide?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
