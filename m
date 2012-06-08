Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:62302 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2FHEmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2012 00:42:14 -0400
Date: Fri, 8 Jun 2012 06:42:10 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-btrfs@vger.kernel.org
Subject: problem re-adding original mount block device on multi-device fs
Message-ID: <20120608044210.GY725@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(please CC on replies, I'm not subscribed to the list)

Hi!

This fails:

	# mkfs.btrfs /dev/sd[bcde]
	# mount /dev/sdb /mnt/x
	# btrfs device delete /dev/sdb /mnt/x
	# btrfs device add /dev/sdb /mnt/x
	/dev/sdb is mounted
	#

It seems that I have to unmount and remount the fs using another
constituent block device before I can re-add the original block
device that the filesystem was mounted with:

	# umount /mnt/x
	# mount /dev/sdb /mnt/x
	mount: wrong fs type, bad option, bad superblock on /dev/sdb,
	       missing codepage or helper program, or other error
	       In some cases useful info is found in syslog - try
	       dmesg | tail or so
	# mount /dev/sdc /mnt/x
	# btrfs device add /dev/sdb /mnt/x
	#

This is on up-to-date F17, kernel 3.4.0(-1.fc17) with btrfs-progs
0.19(-18.fc17).


thanks,
Lennert
