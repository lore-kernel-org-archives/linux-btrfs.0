Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:40828 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932706AbdHVMaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 08:30:02 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 976978150
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 14:23:50 +0200 (MEST)
Date: Tue, 22 Aug 2017 14:23:50 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: finding root filesystem of a subvolume?
Message-ID: <20170822122350.GA14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How do I find the root filesystem of a subvolume?
Example:

root@fex:~# df -T 
Filesystem     Type  1K-blocks      Used Available Use% Mounted on
-              -    1073740800 104244552 967773976  10% /local/.backup/home

root@fex:~# btrfs subvolume show /local/.backup/home
/local/.backup/home
        Name:                   home
        uuid:                   f86a2db0-6a82-124f-9a71-1cd4c20fd6fb
        Parent uuid:            ba4d388f-44bf-7b46-b2b8-00e2a9a87181
        Creation time:          2017-08-10 22:19:15
        Object ID:              383
        Generation (Gen):       148
        Gen at creation:        148
        Parent:                 5
        Top Level:              5
        Flags:                  readonly
        Snapshot(s):


I know, the root filesystem is /local, but who can I show it by command?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170822122350.GA14804@rus.uni-stuttgart.de>
