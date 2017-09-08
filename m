Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:56771 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754719AbdIHIyr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 04:54:47 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 80E1480B1
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 10:54:46 +0200 (MEST)
Date: Fri, 8 Sep 2017 10:54:46 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: test if a subvolume is a snapshot?
Message-ID: <20170908085446.GA7876@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How can I test if a subvolume is a snapshot?

Example:

/test/.snapshot/2017-09-08_1037.single is a snapshot (of /test)
/test/data is a regular subvolume

I know this, because I have created them with suitable names :-)

But how can I see/test it?

root@fex:~/bin# btrfs subvol show /test/.snapshot/2017-09-08_1037.single
/test/.snapshot/2017-09-08_1037.single
        Name:                   2017-09-08_1037.single
        UUID:                   eff1cebb-b885-6b47-ae69-36a7c3f266eb
        Parent UUID:            -
        Received UUID:          -
        Creation time:          2017-09-08 10:37:04 +0200
        Subvolume ID:           354
        Generation:             237
        Gen at creation:        237
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):

root@fex:~/bin# btrfs subvol show /test/data
/test/data
        Name:                   data
        UUID:                   b32a5949-dfd6-ef45-8616-34ae4cdf6fb8
        Parent UUID:            -
        Received UUID:          -
        Creation time:          2017-09-06 18:30:33 +0200
        Subvolume ID:           257
        Generation:             224
        Gen at creation:        8
        Parent ID:              5
        Top level ID:           5
        Flags:                  -

root@fex:~/bin# btrfs subvol show /test
/test is toplevel subvolume

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170908085446.GA7876@rus.uni-stuttgart.de>
