Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35355 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbGFQXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 12:23:01 -0400
Received: by wgjx7 with SMTP id x7so144831080wgj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 09:23:00 -0700 (PDT)
Received: from [192.168.11.26] (p54AA2329.dip0.t-ipconnect.de. [84.170.35.41])
        by mx.google.com with ESMTPSA id ex8sm28963513wjc.34.2015.07.06.09.22.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2015 09:22:59 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Johannes Pfrang <johannespfrang@gmail.com>
Subject: Btrfs - distribute files equally across multiple devices
Message-ID: <559AAB5C.1030001@gmail.com>
Date: Mon, 6 Jul 2015 18:22:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cross-posting my unix.stackexchange.com question[1] to the btrfs list
(slightly modified):

[1]
https://unix.stackexchange.com/questions/214009/btrfs-distribute-files-equally-across-multiple-devices

---------------------------------------------------------------------------------

I have a btrfs volume across two devices that has metadata RAID 1 and
data RAID 0. AFAIK, in the event one drive would fail, practically all
files above the 64KB default stripe size would be corrupted. As this
partition isn't performance critical, but should be space-efficient,
I've thought about re-balancing the filesystem to distribute files
equally across disks, but something like that doesn't seem to exist. The
ultimate goal would be to be able to still read some of the files in the
event of a drive failure.

AFAIK, using "single"/linear data allocation just fills up drives one by
one (at least that's what the wiki says).

Simple example (according to my best knowledge):

Write two 128KB files (file0, file1) to two devices (dev0, dev1):

RAID0:

    file0/chunk0 (64KB): dev0
    file0/chunk1 (64KB): dev1
    file1/chunk0 (64KB): dev0
    file1/chunk1 (64KB): dev1

Linear:

    file0 (128KB): dev0
    file1 (128KB): dev0

distribute files:

    file0 (128KB): dev0
    file1 (128KB): dev1

The simplest implementation would probably be something like: Always
write files to the disk with the least amount of space used. I think
this may be a valid software-raid use-case, as it combines RAID 0 (w/o
some of the performance gains[2]) with recoverability of about half of
the data/files (balanced by filled space or amount of files) in the
event of a drive-failure[3] by using filesystem information a
hardware-raid doesn't have. In the end this is more or less JBOD with
balanced disk usage + filesystem intelligence.

Is there something like that already in btrfs or could this be something
the btrfs-devs would consider?


[2] Still can read/write multiple files from/to different disks, so less
performance only for "single-file-reads/writes"
[3] using two disks, otherwise (totalDisks-failedDisks)/totalDisks
