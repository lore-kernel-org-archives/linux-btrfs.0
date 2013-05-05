Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36049 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3EEK1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 06:27:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYwA7-0003fw-7x
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 12:27:23 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:27:23 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:27:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: hard freezes with 3.9.0 during io-intensive loads
Date: Sun, 05 May 2013 12:25:45 +0200
Message-ID: <6moh5a-knf.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I've upgraded to 3.9.0 mainly for the snapshot-aware defragging patches. I'm 
running bedup[1] on a regular basis and it is now the third time that I got 
back to my PC just to find it hard-frozen and I needed to use the reset 
button.

It looks like this happens only while running bedup on my two btrfs 
filesystems but I'm not sure if it happens for any of the filesystems or 
only one. This is my setup:

# cat /etc/fstab (shortened)
UUID=d2bb232a-2e8f-4951-8bcc-97e237f1b536 / btrfs compress=lzo,subvol=root64 
0 1 # /dev/sd{a,b,c}3
LABEL=usb-backup /mnt/private/usb-backup btrfs noauto,compress-
force=zlib,subvolid=0,autodefrag,comment=systemd.automount 0 0 # external 
usb3 disk

# btrfs filesystem show
Label: 'usb-backup'  uuid: 7038c8fa-4293-49e9-b493-a9c46e5663ca
        Total devices 1 FS bytes used 1.13TB
        devid    1 size 1.82TB used 1.75TB path /dev/sdd1

Label: 'system'  uuid: d2bb232a-2e8f-4951-8bcc-97e237f1b536
        Total devices 3 FS bytes used 914.43GB
        devid    3 size 927.26GB used 426.03GB path /dev/sdc3
        devid    2 size 927.26GB used 426.03GB path /dev/sdb3
        devid    1 size 927.26GB used 427.07GB path /dev/sda3

Btrfs v0.20-rc1

Since the system hard-freezes I have no messages from dmesg. But I suspect 
it to be related to the defragmentation option in bedup (I've switched to 
bedub with --defrag since 3.9.0, and autodefrag for the backup drive). Just 
in case, I'm going to try without this option now and see if it won't 
freeze.

I was able to take a "physical" screenshot with a real camera of a kernel 
backtrace one time when the freeze happened. I wonder if it is useful to you 
and where to send it. I just don't want to upload jpegs right here to the 
list without asking first.

The big plus is: Altough I had to hard-reset the frozen system several times 
now, btrfs survived the procedure without any impact (just boot times 
increases noticeably, probably due to log-replays or something). So thumbs 
up for the developers on that point.

[1]: https://github.com/g2p/bedup

