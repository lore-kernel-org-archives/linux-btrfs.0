Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60385 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932510AbeFRNA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 09:00:59 -0400
Date: Mon, 18 Jun 2018 06:00:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs balance did not progress after 12H
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I ran this:
gargamel:/mnt/btrfs_pool2# btrfs balance start -dusage=60 -v .  &
[1] 24450
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=60
gargamel:/mnt/btrfs_pool2# while :; do btrfs balance status .; sleep 60; done
0 out of about 0 chunks balanced (0 considered), -nan% left
Balance on '.' is running
0 out of about 73 chunks balanced (2 considered), 100% left
Balance on '.' is running

After about 20mn, it changed to this:
1 out of about 73 chunks balanced (6724 considered),  99% left
Balance on '.' is running

Now, 12H later, it's still there, only 1 out of 73.

gargamel:/mnt/btrfs_pool2# btrfs fi show .
Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
        Total devices 1 FS bytes used 12.72TiB
        devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2

gargamel:/mnt/btrfs_pool2# btrfs fi df .
Data, single: total=13.57TiB, used=12.60TiB
System, DUP: total=32.00MiB, used=1.55MiB
Metadata, DUP: total=121.50GiB, used=116.53GiB
GlobalReserve, single: total=512.00MiB, used=848.00KiB

kernel: 4.16.8

Is that expected? Should I be ready to wait days possibly for this
balance to finish?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
