Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longnose.sharkbay.at ([78.46.205.195]:37155 "EHLO
	smtp.sharkbay.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3K2MJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 07:09:16 -0500
Message-ID: <1385726351.1297.11.camel@mako.sharkbay.at>
Subject: [BUG] btrfs-progs: btrfs send does not work inside mounted non root
 subvolume
From: Thomas Scheiblauer <tom@sharkbay.at>
To: linux-btrfs@vger.kernel.org
Date: Fri, 29 Nov 2013 12:59:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When operating from inside a mounted btrfs subvolume which is not the
root subvolume "btrfs send" exits with the error:
ERROR: open <subvolume path> failed. No such file or directory

Steps to reproduce:
     1. mkfs.btrfs /dev/sda1
     2. mount /dev/sda1 /mnt
     3. btrfs subvolume create /mnt/foo
     4. umount /mnt
     5. mount -o subvol=foo /dev/sda1 /mnt
     6. btrfs subvolume snapshot -r /mnt /mnt/snap
     7. btrfs send /mnt/snap > /dev/null
-> ERROR: open foo/snap failed. No such file or directory



