Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49671 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753299AbcJ3Sr4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 14:47:56 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.87 #1)
        id 1c0uwI-00013I-3K by authid <merlin>
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Oct 2016 11:34:38 -0700
Date: Sun, 30 Oct 2016 11:34:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161030183437.GA3287@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a filesystem on top of md raid5 that got a few problems due to the
underlying block layer (bad data cable).
The filesystem mounts fine, but had a few issues
Scrub runs (I didn't let it finish, it takes a _long_ time)
But check --repair won't even run at all:

myth:~# btrfs --version
btrfs-progs v4.7.3
myth:~# uname -r
4.8.5-ia32-20161028

myth:~# btrfs check -p --repair  /dev/mapper/crypt_bcache0  2>&1 | tee
/var/spool/repair
bytenr mismatch, want=13835462344704, have=0
ERROR: cannot read chunk root
Couldn't open file system
enabling repair mode
myth:~#

myth:~# btrfs rescue super-recover -v /dev//mapper/crypt_bcache0 
All Devices:
        Device: id = 1, name = /dev//mapper/crypt_bcache0

Before Recovering:
        [All good supers]:
                device name = /dev//mapper/crypt_bcache0
                superblock bytenr = 65536

                device name = /dev//mapper/crypt_bcache0
                superblock bytenr = 67108864

                device name = /dev//mapper/crypt_bcache0
                superblock bytenr = 274877906944

        [All bad supers]:

All supers are valid, no need to recover


I don't care about the data, it's a backup array, but I'd still like to know
if I can recover from this state and do a repair to see how much data got
damaged

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
