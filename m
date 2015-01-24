Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:58859 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbAXOcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 09:32:50 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id BB184156BE
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Jan 2015 14:32:47 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id MVP1TZr0hUqo for <linux-btrfs@vger.kernel.org>;
	Sat, 24 Jan 2015 14:32:45 +0000 (GMT)
Message-ID: <54C3AD0C.7080407@pocock.pro>
Date: Sat, 24 Jan 2015 15:32:44 +0100
From: Daniel Pocock <daniel@pocock.pro>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: RAID1 migrate to bigger disks
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




I've got a RAID1 on two 1TB partitions, /dev/sda3 and /dev/sdb3

I'm adding two new disks, they will have bigger partitions /dev/sdc3 and
/dev/sdd3

I'd like the BtrFs to migrate from the old partitions to the new ones as
safely and quickly as possible and if it is reasonable to do so, keeping
it online throughout the migration.

Should I do the following:

btrfs device add /dev/sdc3 /dev/sdd3 /mnt/btrfs0
btrfs device delete /dev/sda3 /dev/sdb3 /mnt/btrfs0

or should I do it this way:

btrfs device add /dev/sdc3 /mnt/btrfs0
btrfs device delete /dev/sda3 /mnt/btrfs0
btrfs device add /dev/sdd3 /mnt/btrfs0
btrfs device delete /dev/sdb3 /mnt/btrfs0

or is there some other way to go about it?

