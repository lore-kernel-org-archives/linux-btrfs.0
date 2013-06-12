Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35439 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FLLxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 07:53:39 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id F09153A1C7D
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 13:53:34 +0200 (CEST)
Received: from localhost (unknown [123.109.194.100])
	by mail.virtall.com (Postfix) with ESMTPSA id 349F93A1A8F
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 13:53:31 +0200 (CEST)
Date: Wed, 12 Jun 2013 20:53:03 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Subject: can't mount a newly created fs after reboot
Message-ID: <20130612205303.308095ca@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've created two btrfs fileystems using these commands:

mkfs.btrfs -d raid1 -m raid1 -L btrfs1 /dev/sda5 /dev/sdb5
mkfs.btrfs -d raid1 -m raid1 -L btrfs2 /dev/sdc1 /dev/sdd1


Then, added these to /etc/fstab:

LABEL=btrfs1 /mnt/btrfs1 btrfs noatime,compress-force=zlib 0 0
LABEL=btrfs2 /mnt/btrfs2 btrfs noatime,compress-force=zlib 0 0

I mounted these filesystems with:

mount -a


And enabled quotas:

btrfs quota enable /mnt/btrfs1
btrfs quota enable /mnt/btrfs2


I'm using Linux 3.9.5.


After that I've rebooted and I'm no longer able to mount these two
fileystems:

- mounted from /etc/fstab (where it uses LABEL=):

[  149.763638] device label btrfs1 devid 2 transid 7 /dev/sdb5
[  149.764127] btrfs: force zlib compression
[  149.764170] btrfs: disk space caching is enabled
[  149.765271] btrfs: failed to read the system array on sdb5
[  149.830891] btrfs: open_ctree failed
[  149.836563] device label btrfs2 devid 1 transid 7 /dev/sdc1
[  149.837005] btrfs: force zlib compression
[  149.837050] btrfs: disk space caching is enabled
[  149.837660] btrfs: failed to read the system array on sdc1
[  149.910828] btrfs: open_ctree failed


- mounted with /dev/sdc1 only:

[  173.688956] device label btrfs2 devid 1 transid 7 /dev/sdc1
[  173.689393] btrfs: disk space caching is enabled
[  173.690195] btrfs: failed to read the system array on sdc1
[  173.796816] btrfs: open_ctree failed


Is it expected behaviour that the fs is mountable only once?

-- 
Tomasz Chmielewski
http://www.ptraveler.com
