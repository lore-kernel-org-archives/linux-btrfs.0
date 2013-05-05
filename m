Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:47770 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3EEJm7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 05:42:59 -0400
Date: 05 May 2013 11:42:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CWIRQXl9CXB@helmut.hullen.de>
Subject: ENOSPC during balance
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I've added a fourth device (/dev/sdf1; connected via USB) to my 3-disks- 
btrfs bundle (data raid0, metadata raid1), and then I run "balance".

That needed (for about 6 TByte data) about 17 hours.

It finished with

ERROR: error during balancing '/srv/MM' - No space left on device
There may be more info in syslog - try dmesg | tail

The last lines of "dmesg":

btrfs: found 227973 extents
btrfs: relocating block group 26872905728 flags 20
btrfs: found 217765 extents
btrfs: relocating block group 22577938432 flags 20
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
usb 1-1: reset high-speed USB device number 3 using ehci-pci
btrfs: found 226454 extents
btrfs: relocating block group 21504196608 flags 20
btrfs: found 229068 extents
btrfs: relocating block group 4324327424 flags 20
btrfs: found 214531 extents
btrfs: relocating block group 20971520 flags 18
btrfs: found 92 extents
btrfs: relocating block group 4194304 flags 4
btrfs: 1 enospc errors during balance

What does the last line mean? Is there 1 error during the 17 hours of  
balancing? Or has balance ended with "enospc"?

The actual state:

Commands

        btrfs fi show
        df


Label: 'MM'  uuid: 7e94022a-76e7-47f8-954d-1ad69a872bef
	Total devices 4 FS bytes used 6.10TB
	devid    4 size 1.82TB used 650.03GB path /dev/sdf1
	devid    3 size 2.73TB used 1.91TB path /dev/sdd
	devid    2 size 1.82TB used 1.68TB path /dev/sdc
	devid    1 size 2.73TB used 1.91TB path /dev/sdb

Btrfs Btrfs v0.19

Filesystem             1K-blocks       Used  Available Use% Mounted on
[...]
/dev/sdb              9767561292 6554878088 2815565072  70% /srv/MM


Viele Gruesse!
Helmut
