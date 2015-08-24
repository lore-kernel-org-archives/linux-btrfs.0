Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36382 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbHXDws (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Aug 2015 23:52:48 -0400
Received: by igcse8 with SMTP id se8so37713505igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2015 20:52:48 -0700 (PDT)
MIME-Version: 1.0
From: Ivan <ivan98@gmail.com>
Date: Mon, 24 Aug 2015 11:52:08 +0800
Message-ID: <CAM_GSFsAAtrGE7K3LYZKShnQN0yhm-b=s5itnsfWrukL8r66Hg@mail.gmail.com>
Subject: Newbie: RAID5 available space
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying out RAID5 to understand its space usage. First off, I've 3
devices of 2GB each, in RAID5. Old school RAID5 tells me I've 4GB of
usable space. Actual fact: I've about 3.5GB, until it tells me I'm out
of space. This is understandable, as Metadata and System took up some
space.

Next, I tried device add and remove.

My "common sense" tells me, I should be able to remove a device of
size equal or smaller than one I added. (isn't it simply move all
blocks from old device to new?)

So I proceeded to add a 4th device of 2GB, and remove the 2nd device (of 2GB).
btrfs device delete tells me I'm out of space. Why?

Here are my steps:
01. dd if=/dev/zero of=/root/btrfs-test-1 bs=1G count=2
02. losetup /dev/loop1 /root/btrfs-test-1
03. dd if=/dev/zero of=/root/btrfs-test-2 bs=1G count=2
04. losetup /dev/loop2 /root/btrfs-test-2
05. dd if=/dev/zero of=/root/btrfs-test-3 bs=1G count=2
06. losetup /dev/loop3 /root/btrfs-test-3
07. mkfs.btrfs --data raid5 --metadata raid5 --label testbtrfs2
--nodiscard -f /dev/loop1 /dev/loop2 /dev/loop3
08. mount /dev/loop2 /mnt/b
09. dd if=/dev/zero of=/mnt/b/test1g1 bs=1G count=1
10. dd if=/dev/zero of=/mnt/b/test1g2 bs=1G count=1
11. dd if=/dev/zero of=/mnt/b/test1g3 bs=1G count=1
12. dd if=/dev/zero of=/mnt/b/test512M1 bs=512M count=1
13. dd if=/dev/zero of=/root/btrfs-test-4 bs=1G count=2
14. losetup /dev/loop4 /root/btrfs-test-4
15. btrfs device add --nodiscard -f /dev/loop4 /mnt/b
16. btrfs device delete /dev/loop2 /mnt/b

My kernel is 4.0.5-gentoo, btrfs-progs is 4.0.1 from Gentoo.

AFTER adding /dev/loop4. As can be seen, /dev/loop4 has lots of space,
almost 2GB.
# btrfs device usage /mnt/b
/dev/loop1, ID: 1
   Device size:             2.00GiB
   Data,single:             8.00MiB
   Data,RAID5:              1.76GiB
   Data,RAID5:             10.50MiB
   Metadata,single:         8.00MiB
   Metadata,RAID5:        204.75MiB
   System,single:           4.00MiB
   System,RAID5:            8.00MiB
   Unallocated:               0.00B

/dev/loop2, ID: 2
   Device size:             2.00GiB
   Data,RAID5:              1.78GiB
   Data,RAID5:             10.50MiB
   Metadata,RAID5:        204.75MiB
   System,RAID5:            8.00MiB
   Unallocated:             1.00MiB

/dev/loop3, ID: 3
   Device size:             2.00GiB
   Data,RAID5:              1.78GiB
   Data,RAID5:             10.50MiB
   Metadata,RAID5:        204.75MiB
   System,RAID5:            8.00MiB
   Unallocated:             1.00MiB

/dev/loop4, ID: 4
   Device size:             2.00GiB
   Data,RAID5:             10.50MiB
   Data,RAID5:             19.00MiB
   Unallocated:             1.97GiB
