Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kawka.in.waw.pl ([178.63.212.103]:59258 "EHLO kawka.in.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3KOAFV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 19:05:21 -0500
Date: Fri, 15 Nov 2013 00:32:10 +0100
From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>
To: linux-btrfs@vger.kernel.org
Cc: systemd-devel@lists.freedesktop.org
Subject: is mounting subvolumes with a read-only root subvolume allowed?
Message-ID: <20131114233210.GU30929@in.waw.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have a box with / and /home being subvolumes from the same btrfs filesystem.

/etc/fstab:
UUID=c0686...      /      btrfs subvol=root,x-systemd.device-timeout=0 1 1
UUID=c0686...      /home  btrfs subvol=home,x-systemd.device-timeout=0 1 1
...

/ is initially mounted readonly by the initramfs, and then after switching
to the real system, /home is attempted to be mounted in parallel with /
being remounted rw. If remounting rw happens first, boot proceeds. If
mounting /home is attempted to realy, it fails.

$ /bin/mount /home
mount: /dev/mapper/luks-765... is already mounted or /home busy
       /dev/mapper/luks-765... is already mounted on /
$ /bin/mount -o remount,rw /
$ /bin/mount /home
$

So, is this expected that the other subvolume must be mounted rw?

Zbyszek


