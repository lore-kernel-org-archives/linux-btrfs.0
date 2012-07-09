Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.2.175]:53007 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2GIWXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 18:23:08 -0400
Received: from [192.168.1.64] (77-216.eduroam.rwth-aachen.de [134.61.77.216])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.unitix.de (Postfix) with ESMTPSA id C945A655D
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 00:23:05 +0200 (CEST)
Message-ID: <4FFB59BF.1050104@arndnet.de>
Date: Tue, 10 Jul 2012 00:22:55 +0200
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in /proc/mounts
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

using btrfs with LVM snapshots seems to be confusing /proc/mounts
After mounting a snapshot of an original filesystem, the devicename of the
original filesystem is overwritten with that of the snapshot in /proc/mounts.

Steps to reproduce:

arnd@kallisto:/mnt$ sudo mount /dev/vg0/original /mnt/original
[  107.041432] device fsid 5c3e8ca2-da56-4ade-9fef-103a6a8a70c2 devid 1 transid 4 /dev/mapper/vg0-original
[  107.044691] btrfs: no dev_stats entry found for device /dev/mapper/vg0-original (devid 1) (OK on first mount after mkfs)

arnd@kallisto:/mnt$ cat /proc/mounts  | grep /mnt
/dev/mapper/vg0-original /mnt/original btrfs rw,relatime,ssd,space_cache 0 0

arnd@kallisto:/mnt$ sudo lvcreate -L 10M --snap --name snapshot /dev/vg0/original
arnd@kallisto:/mnt$ sudo mount /dev/vg0/testsnap /mnt/testsnap
[  215.432281] device fsid 5c3e8ca2-da56-4ade-9fef-103a6a8a70c2 devid 1 transid 4 /dev/mapper/vg0-testsnap

arnd@kallisto:/mnt$ cat /proc/mounts  | grep /mnt
/dev/mapper/vg0-testsnap /mnt/original btrfs rw,relatime,ssd,space_cache 0 0
/dev/mapper/vg0-testsnap /mnt/testsnap btrfs rw,relatime,ssd,space_cache 0 0

arnd@kallisto:/mnt$ sudo umount /dev/vg0/testsnap
arnd@kallisto:/mnt$ cat /proc/mounts | grep /mnt
/dev/mapper/vg0-testsnap /mnt/original btrfs rw,relatime,ssd,space_cache 0 0


Best regards,
Arnd
