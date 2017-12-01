Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:42138 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbdLAQci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 11:32:38 -0500
Date: Fri, 1 Dec 2017 17:15:55 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: exclusive subvolume space missing
Message-ID: <20171201161555.GA11892@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I got a problem with btrfs running out of space (not THE
Internet-wide, well known issues with interpretation).

The problem is: something eats the space while not running anything that
justifies this. There were 18 GB free space available, suddenly it
dropped to 8 GB and then to 63 MB during one night. I recovered 1 GB
with rebalance -dusage=5 -musage=5 (or sth about), but it is being eaten
right now, just as I'm writing this e-mail:

/dev/sda2        64G   63G  452M 100% /
/dev/sda2        64G   63G  365M 100% /
/dev/sda2        64G   63G  316M 100% /
/dev/sda2        64G   63G  287M 100% /
/dev/sda2        64G   63G  268M 100% /
/dev/sda2        64G   63G  239M 100% /
/dev/sda2        64G   63G  230M 100% /
/dev/sda2        64G   63G  182M 100% /
/dev/sda2        64G   63G  163M 100% /
/dev/sda2        64G   64G  153M 100% /
/dev/sda2        64G   64G  143M 100% /
/dev/sda2        64G   64G   96M 100% /
/dev/sda2        64G   64G   88M 100% /
/dev/sda2        64G   64G   57M 100% /
/dev/sda2        64G   64G   25M 100% /

while my rough calculations show, that there should be at least 10 GB of
free space. After enabling quotas it is somehow confirmed:

# btrfs qgroup sh --sort=excl / 
qgroupid         rfer         excl 
--------         ----         ---- 
0/5          16.00KiB     16.00KiB 
[30 snapshots with about 100 MiB excl]
0/333        24.53GiB    305.79MiB 
0/298        13.44GiB    312.74MiB 
0/327        23.79GiB    427.13MiB 
0/331        23.93GiB    930.51MiB 
0/260        12.25GiB      3.22GiB 
0/312        19.70GiB      4.56GiB 
0/388        28.75GiB      7.15GiB 
0/291        30.60GiB      9.01GiB <- this is the running one

This is about 30 GB total excl (didn't find a switch to sum this up). I
know I can't just add 'excl' to get usage, so tried to pinpoint the
exact files that occupy space in 0/388 exclusively (this is the last
snapshots taken, all of the snapshots are created from the running fs).


Now, the weird part for me is exclusive data count:

# btrfs sub sh ./snapshot-171125
[...]
        Subvolume ID:           388
# btrfs fi du -s ./snapshot-171125 
     Total   Exclusive  Set shared  Filename
  21.50GiB    63.35MiB    20.77GiB  snapshot-171125


How is that possible? This doesn't even remotely relate to 7.15 GiB
from qgroup.~The same amount differs in total: 28.75-21.50=7.25 GiB.
And the same happens with other snapshots, much more exclusive data
shown in qgroup than actually found in files. So if not files, where
is that space wasted? Metadata?

btrfs-progs-4.12 running on Linux 4.9.46.

best regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
