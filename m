Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:55168 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757412AbdIIIfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 04:35:53 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id B7E0588EB
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 10:35:51 +0200 (MEST)
Date: Sat, 9 Sep 2017 10:35:51 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: generic name for volume and subvolume root?
Message-ID: <20170909083551.GC22060@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I am writing some documentation abount creating snapshots:
Is there a generic name for both volume and subvolume root?

Example:

root@fex:~# btrfs subvol show /mnt
ERROR: not a subvolume: /mnt

root@fex:~# btrfs subvol show /mnt/test
/mnt/test is toplevel subvolume

root@fex:~# btrfs subvol show /mnt/test/data
/mnt/test/data
        Name:                   data
        UUID:                   b32a5949-dfd6-ef45-8616-34ae4cdf6fb8
(...)

root@fex:~# btrfs subvol show /mnt/test/data/sw
ERROR: not a subvolume: /mnt/test/data/sw


I can create snapshots of /mnt/test and /mnt/test/data, but not of /mnt
and /mnt/test/data/sw

Is there a simple name for directories I can snapshot?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170909083551.GC22060@rus.uni-stuttgart.de>
