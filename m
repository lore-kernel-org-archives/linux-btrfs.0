Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59585 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2JVJHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 05:07:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TQDz4-0004Lr-FL
	for linux-btrfs@vger.kernel.org; Mon, 22 Oct 2012 11:07:42 +0200
Received: from cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com ([81.97.59.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 11:07:42 +0200
Received: from samtygier by cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 11:07:42 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: problem replacing failing drive
Date: Mon, 22 Oct 2012 10:07:22 +0100
Message-ID: <k632c9$3df$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

I have a 2 drive btrfs raid set up. It was created first with a single drive, and then adding a second and doing
btrfs fi balance start -dconvert=raid1 /data

the original drive is showing smart errors so i want to replace it. i dont easily have space in my desktop for an extra disk, so i decided to proceed by shutting down. taking out the old failing drive and putting in the new drive. this is similar to the description at
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_Failed_Devices
(the other reason to try this is to simulate what would happen if a drive did completely fail).

so after swapping the drives and rebooting, i try to mount as degraded. i instantly get a kernel panic, http://www.hep.man.ac.uk/u/sam/pub/IMG_5397_crop.png

so far all this has been with 3.5 kernel. so i upgraded to 3.6.2 and tried to mount degraded again.

first with just sudo mount /dev/sdd2 /mnt, then with sudo mount -o degraded /dev/sdd2 /mnt

[  582.535689] device label bdata devid 1 transid 25342 /dev/sdd2
[  582.536196] btrfs: disk space caching is enabled
[  582.536602] btrfs: failed to read the system array on sdd2
[  582.536860] btrfs: open_ctree failed
[  606.784176] device label bdata devid 1 transid 25342 /dev/sdd2
[  606.784647] btrfs: allowing degraded mounts
[  606.784650] btrfs: disk space caching is enabled
[  606.785131] btrfs: failed to read chunk root on sdd2
[  606.785331] btrfs warning page private not zero on page 3222292922368
[  606.785408] btrfs: open_ctree failed
[  782.422959] device label bdata devid 1 transid 25342 /dev/sdd2

no panic is good progress, but something is still not right.

my options would seem to be
1) reconnect old drive (probably in a USB caddy), see if it mounts as if nothing ever happened. or possibly try and recover it back to a working raid1. then try again with adding the new drive first, then removing the old one.
2) give up experimenting and create a new btrfs raid1, and restore from backup

both leave me with a worry about what would happen if a disk in a raid 1 did die. (unless is was the panic that did some damage that borked the filesystem.)

thanks.

sam

