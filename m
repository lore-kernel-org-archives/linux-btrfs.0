Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47926 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756826Ab3JOTXp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 15:23:45 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:62346 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VWADX-0000i7-04
	for linux-btrfs@vger.kernel.org; Tue, 15 Oct 2013 13:23:43 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: regression, can't mount subvol if default subvol is changed
Message-Id: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
Date: Tue, 15 Oct 2013 13:23:44 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After changing the default subvolume, I can't mount a nested subvolume with a correct relative pathname to the default subvolume; it can only be mounted by absolute path or subvolid.

Setup: 
3.11.4-302.fc20.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64
dir = a directory, sub=a subvolume, nested=a subvolume; set-default is top level 5


# mount -o subvol=dir/sub /dev/vda1 /mnt
# btrfs subvol list /mnt
ID 263 gen 140 top level 5 path dir/sub
ID 264 gen 140 top level 263 path nested

# btrfs subvol set-default 263 /mnt
# umount /mnt
# mount -o subvol=nested /dev/vda1 /mnt
mount: mount(2) failed: No such file or directory
# mount -o subvol=/nested /dev/vda1 /mnt
mount: mount(2) failed: No such file or directory

# mount -o subvol=/dir/sub/nested /dev/vda1 /mnt
[works]
# umount  /mnt
# mount -o subvolid=264 /dev/vda1 /mnt
[works]


The subvol nested is under dir/sub which is ID 263. So if set-default is 263, I should be able to mount with subvol=nested as a relative path to the default subvolume, but it fails. There's no meaningful kernel message at the time of the failed mount, just:
[ 4265.386990] device label fedora devid 1 transid 165 /dev/vda1

But I get the exact same message with a successful mount.

So should the mounting of relative pathnames still work?

Chris Murphy