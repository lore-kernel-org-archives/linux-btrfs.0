Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36421 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcFQJSO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 05:18:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bDpuk-0002Fk-7t
	for linux-btrfs@vger.kernel.org; Fri, 17 Jun 2016 11:18:10 +0200
Received: from 168.159.160.57 ([168.159.160.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 11:18:10 +0200
Received: from toyours_sridhar by 168.159.160.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 11:18:10 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs multi device handling
Date: Fri, 17 Jun 2016 09:18:04 +0000 (UTC)
Message-ID: <loom.20160617T110624-71@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to understand how btrfs handles multiple devices configured to 
a single btrfs file system.

As compared to traditinal LVM2, say 2 physical disks /dev/sda, /dev/sdb 
are configured as single LVM2 pool and lvm provide an abstract view say 
/dev/mapper/VG1-LV1 where VG1 is name of volume ground created on top of 
/dev/sda and /dev/sdb and LV1 is logical volume.

for mkfs, we can provide /dev/mapper/VG1-LV1 to create file system. This 
path is kind of virtual device managed by LVM2. and Using dm, I/Os are 
transferred to respective devices /dev/sda or /dev/sdb.

Does btrfs also creates such virtual view of all devices provided while 
operating on disks under the file system?

To support my question, example is mkfs.btrfs /dev/sdc /dev/sdd creates 
btrfs.  Both disks are of size 5GB. Hence around 10GB btrfs fs is created.

For this btrfs internally creates any virtual path for 10GB view? or how 
btrfs internally manages?

I am looking at scrub code where struct btrfs_device structure contains
struct block_device *bdev and also struct btrfs_fs_devices *fs_devices 
fields.

If I relate my question does bdev filed in btrfs_device is virtual view of 
all devices? and fs_devices represents  list of individual devices (in 
above example /dev/sdc and /dev/sdd) ?

Thank you in advance.

