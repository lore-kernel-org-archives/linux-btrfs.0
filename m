From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: btrfs on small (embedded) systems
Date: Mon, 28 Sep 2009 14:47:51 +0200
Message-ID: <4AC0B077.6080809@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

FYI - I've been using btrfs with 2.6.31.1 kernel for a few days as a 
rootfs on a small mips system (ASUS WL-500gP - 32 MB RAM, 266 MHz CPU).

btrfs filesystem is placed on a USB-stick connected to the device 
(internal flash only contains the kernel).


My main motivation for using btrfs on this small system was compression 
this filesystem offers - flash storage is still prohibitively expensive 
when compared to traditional hard disks (i.e. 32 GB USB-stick costs as 
much as a 1 TB HDD).


So far, everything looks fine, although I didn't try to stress it much 
(or use snapshots and/or make the filesystem full).


Certainly one thing I'm missing in btrfs is the ability to use swapfiles 
- is it planned one day (or perhaps some serious surgery in MM would be 
needed first)?


-- 
Tomasz Chmielewski
http://wpkg.org


