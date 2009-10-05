From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: system hang with btrfs master
Date: Mon, 5 Oct 2009 14:40:49 +0200
Message-ID: <200910051440.50155.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs on two devices here, /usr on sda3 and /home on sdb (dm-crypt 
device on the whole disk). With btrfs-master the whole system hangs when 
accessing /home. The system hangs when I'm logging in into my account with KDE 
and is easily reproducible with dbench. On /usr the hangs appeared also but 
not as often as on the /home-device. I've tested on a third device with new 
created btrfs on top of dm-crypt, but wasn't able to reproduce the hangs. The 
filesystems are created without metadata-mirroring (-m single). I've bisected 
this to:

commit 11833d66be94b514652466802100378046c16b72
Author: Yan Zheng <zheng.yan@oracle.com>
Date:   Fri Sep 11 16:11:19 2009 -0400

    Btrfs: improve async block group caching
