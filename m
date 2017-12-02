Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:53609 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751776AbdLBNAC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Dec 2017 08:00:02 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 7846A867C
        for <linux-btrfs@vger.kernel.org>; Sat,  2 Dec 2017 13:53:56 +0100 (MET)
Date: Sat, 2 Dec 2017 13:53:56 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: snaprotate
Message-ID: <20171202125356.GA1355@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Being a Netapp user for a long time, I have always missed btrfs snapshots
the way Netapp creates them.

I have now written snaprotate:

http://fex.belwue.de/snaprotate.html

snaprotate creates and manages btrfs readonly snapshots similar to Netapp.
Snapshots have names like hourly, daily, weekly, single and a date_time
prefix.

Snapshots are stored in a .snapshot/ directory in the subvolume root. 
Example: /local/home/.snapshot/2017-09-09_1200.hourly

You create a snapshot with:

snaprotate <class> <count> <subvol>

<class> is your snapshot name
<count> is the maximum number of snapshots for this class
<subvol> is the btrfs subvolume directory you want to snapshoot

If count is exceeded then the oldest snapshot will be deleted.

You can use snaprotate either as root or as normal user (for your own
subvolumes).

Example usages:

snaprotate single 3 /data             # create and rotate "single" snapshot
snaprotate test 0 /tmp                # delete all "test" snapshots
snaprotate daily 7 /home /local/share # create and rotate "daily" snapshot
snaprotate -l /home                   # list snapshots


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20171202125356.GA1355@rus.uni-stuttgart.de>
