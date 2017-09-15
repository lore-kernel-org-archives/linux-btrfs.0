Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:63842 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdIOQhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 12:37:38 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id EAD272558
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 18:37:36 +0200 (MEST)
Date: Fri, 15 Sep 2017 18:37:36 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: A user cannot remove his readonly snapshots?!
Message-ID: <20170915163736.GD32347@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have my btrfs filesystem mounted with option user_subvol_rm_allowed

tux@xerus: btrfs --version
btrfs-progs v4.4

tux@xerus: uname -a
Linux xerus 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

tux@xerus: id
uid=1000(tux) gid=100(users) groups=100(users)

tux@xerus: btrfs subvolume snapshot -r /test/tux/zz /test/tux/zz/.snapshot/2017-09-15_1824.test
tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system

root can delete this snapshot, but not the user. Why?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170915163736.GD32347@rus.uni-stuttgart.de>
