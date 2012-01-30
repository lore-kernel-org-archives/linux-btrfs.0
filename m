From: Rohit Mehta <pigdog@gmail.com>
Subject: newbie problems (difficulty with mkfs.btrfs and learning how to
 navigate trees
Date: Sun, 29 Jan 2012 22:06:59 -0500
Message-ID: <CAHb3AmJiv3Leq1QUO3JNQ3tuZ06jFQXWv=Jba65AW9qbk-T4Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone, I'm trying to learn about btrfs and the various trees and data
structures.  To that end I have been trying to create a small RAID 1
filesystem (with 2 10MB devices), and it appears mkfs.btrfs does not like
this. (output follows

  # ./mkfs.btrfs -d raid1 -m raid1 -b 10485760 /dev/ubdc /dev/ubdb
  SMALL VOLUME: forcing mixed metadata/data groups

  WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
  WARNING! - see http://btrfs.wiki.kernel.org before using

  Created a data/metadata chunk of size 1048576
  adding device /dev/ubdb id 2
  mkfs.btrfs: mkfs.c:221: create_one_raid_group: Assertion `!(ret)' failed.
  Aborted

However if I don't set the raid1 options, I can create a 20 MB RAID0
filesystem, or I can also create a 10 MB filesystem on one disk
without any errors.  Large disk devices also seem to work as RAID1 or
RAID0)

I'm really just trying to start to dig in and understand the code, but I
figured a small filesystem would be easier to walk. I might just mess
with a single disk for now, but I would appreciate any advice.

Thanks,

Rohit
