Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54880 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaJLXu7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 19:50:59 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so7425868wgg.18
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 16:50:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Oct 2014 16:50:58 -0700
Message-ID: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
Subject: what is the best way to monitor raid1 drive failures?
From: Suman C <schakrava@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am testing some disk failure scenarios in a 2 drive raid1 mirror.
They are 4GB each, virtual SATA drives inside virtualbox.

To simulate the failure, I detached one of the drives from the system.
After that, I see no sign of a problem except for these errors:

Oct 12 15:37:14 rock-dev kernel: btrfs: bdev /dev/sdb errs: wr 0, rd
0, flush 1, corrupt 0, gen 0
Oct 12 15:37:14 rock-dev kernel: lost page write due to I/O error on /dev/sdb

/dev/sdb is gone from the system, but btrfs fi show still lists it.

Label: raid1pool  uuid: 4e5d8b43-1d34-4672-8057-99c51649b7c6
    Total devices 2 FS bytes used 1.46GiB
    devid    1 size 4.00GiB used 2.45GiB path /dev/sdb
    devid    2 size 4.00GiB used 2.43GiB path /dev/sdc

I am able to read and write just fine, but do see the above errors in dmesg.

What is the best way to find out that one of the drives has gone bad?

Suman
