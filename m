Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:56130 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2HLQw4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Aug 2012 12:52:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 6753D150C1
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Aug 2012 18:37:05 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id yK1gK3Ihqcio for <linux-btrfs@vger.kernel.org>;
	Sun, 12 Aug 2012 18:36:52 +0100 (BST)
Message-ID: <5027DDFC.60504@pocock.com.au>
Date: Sun, 12 Aug 2012 16:46:52 +0000
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: raw partition or LV for btrfs?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I notice this question on the wiki/faq:


https://btrfs.wiki.kernel.org/index.php/UseCases#What_is_best_practice_when_partitioning_a_device_that_holds_one_or_more_btr-filesystems

and as it hasn't been answered, can anyone make any comments on the subject

Various things come to mind:

a) partition the disk, create an LVM partition, and create lots of small
LVs, format each as btrfs

b) partition the disk, create an LVM partition, and create one big LV,
format as btrfs, make subvolumes

c) what about using btrfs RAID1?  Does either approach (a) or (b) seem
better for someone who wants the RAID1 feature?

d) what about booting from a btrfs system?  Is it recommended to follow
the ages-old practice of keeping a real partition of 128-500MB,
formatting it as btrfs, even if all other data is in subvolumes as per (b)?

