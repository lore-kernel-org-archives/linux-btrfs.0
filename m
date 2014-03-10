Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbaCJXZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 19:25:55 -0400
Message-ID: <531E4A02.5010404@linux.intel.com>
Date: Mon, 10 Mar 2014 16:25:54 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Building a brtfs filesystem < 70M?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi There

There seems to be an issue if we try to build a btrfs based FS that is 
less than 70M, we get the following assertion failure:

mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion `!(ret)' 
failed.

I tried to do a search on this and did not find anything obvious.

Further, if I do build a 70M image, it will not mount until I get to I 
increase  the about 100M!

# mount -o loop -v rootfs.btrfs mnt
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

I can provide a small rootfs (~4M) example if needed

Builds and mounts correct:
mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs

Builds, but does not mount:
mkfs.btrfs -b 73400320 -r rootfs rootfs.btrfs

Does not build, gives the above assertion error:
mkfs.btrfs -b 10889216 -r rootfs rootfs.btrfs


Thanks


-- 
     Sau!

Saul Wold
Yocto Component Wrangler @ Intel
Yocto Project / Poky Build System

