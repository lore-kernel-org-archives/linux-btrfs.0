Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:51297 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbaG3WFA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 18:05:00 -0400
Date: Thu, 31 Jul 2014 00:04:58 +0200 (CEST)
From: dptrash@arcor.de
To: linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <1368165877.1162129.1406757898943.JavaMail.ngmail@webmail06.arcor-online.net>
Subject: btrfs on bcache
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Concerning http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018, does this "bug" still exists?

Kernel 3.14
B: 2x HDD 1 TB
C: 1x SSD 256 GB

# make-bcache -B /dev/sda /dev/sdb -C /dev/sdc --cache_replacement_policy=lru
# mkfs.btrfs -d raid1 -m raid1 -L "BTRFS_RAID" /dev/bcache0 /dev/bcache1

I still have no "incomplete page write" messages in "dmesg | grep btrfs" and the checksums of some manually reviewed files are okay.

Who has more experiences about this?

Thanks,

- dp
