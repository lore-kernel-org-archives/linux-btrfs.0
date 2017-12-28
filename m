Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34543 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752062AbdL1Bqt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 20:46:49 -0500
Received: by mail-io0-f182.google.com with SMTP id q188so12692298iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Dec 2017 17:46:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
From: Stirling Westrup <swestrup@gmail.com>
Date: Wed, 27 Dec 2017 20:46:48 -0500
Message-ID: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
Subject: Hand Patching a BTRFS Superblock?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's my situation: I have a network file server containing a 12TB
BTRFS spread out over four devices (sda-sdd) which I am trying to
recover. I do have a backup, but it's about 3 months old, and while I
could certainly rebuild everything from that if I really had to, I
would far rather not have to rerip my latest DVDs. So, I am willing to
experiment if it might save me a few hundred hours of reconstruction.
I don't currently have another 12 TB of space anywhere for making a
scratch copy.

A few days ago sdb developed hard errors and I can no longer mount the
filesystem. sdb is no longer even recognized as a valid btrfs drive.
However, when I ran ddrescue over the drive I managed to make a clone
(sdf) which contains all but 12K of the original drive. However, those
missing 12K are all in the various superblocks, so the cloned drive is
still unreadable.

In the hopes that I was only missing a few bits of the superblocks, I
started out by dd-ing the first 4M of sdd into sdf in the hopes that
ddrescue would overwrite much of the superblocks, and the final bits
from sdd would make things usable.

No such luck. I now have a drive sdf which claims to be identical to
sdd but which is a clone of sdb. In case it matters, sda and sdc are
each 4TB while sdb and sdd are each 2TB drives; sde is my boot drive
and sdf is a 2TB clone of sdb.

What I need to do is to somehow patch sdf's primary superblock so it
contains the correct device number and UUID_SUB for sdb, so that I can
attempt some sort of recovery. Right now my linux is (understandably)
quite confused by the situation:

videon:~ # uname -a
Linux videon 4.4.103-18.41-default #1 SMP Wed Dec 13 14:06:33 UTC 2017
(f66c68c) x86_64 x86_64 x86_64 GNU/Linux

videon:~ # btrfs --version
btrfs-progs v4.5.3+20160729

videon:~ # btrfs fi show
Label: 'Storage'  uuid: 33d2890d-f07d-4ba8-b1fc-7b4f14463b1f
        Total devices 4 FS bytes used 10.69TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sdd
        devid    3 size 3.64TiB used 3.54TiB path /dev/sdc
        devid    4 size 3.64TiB used 3.54TiB path /dev/sda
        *** Some devices missing

Any suggestions on how to proceed would be appreciated.

-- 
Stirling Westrup
Programmer, Entrepreneur.
