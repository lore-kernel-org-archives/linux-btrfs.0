Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:40887 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965281AbdLRQtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 11:49:43 -0500
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 373968B10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 17:49:42 +0100 (MET)
Date: Mon, 18 Dec 2017 17:49:41 +0100
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs subvolume list for not mounted filesystem?
Message-ID: <20171218164941.GA22020@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to mount an alternative subvolume of a btrfs filesystem.
I can list the subvolumes when the filesystem is mounted, but how do I
know them, when the filesystem is not mounted? Is there a query command?

root@xerus:~# mount | grep /test
/dev/sdd4 on /test type btrfs (rw,relatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)

root@xerus:~# btrfs subvolume list /test
ID 258 gen 156 top level 5 path tux/zz
ID 259 gen 156 top level 5 path tux/z1
ID 260 gen 156 top level 5 path tmp/zz
ID 261 gen 19 top level 260 path tmp/zz/z1
ID 269 gen 156 top level 5 path tux/test
ID 271 gen 129 top level 269 path tux/test/.snapshot/2017-12-02_1341.test

root@xerus:~# umount /test

root@xerus:~# btrfs subvolume list /dev/sdd4
ERROR: not a btrfs filesystem: /dev/sdd4
ERROR: can't access '/dev/sdd4'



-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20171218164941.GA22020@rus.uni-stuttgart.de>
