From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Thu, 27 Oct 2011 20:32:09 -0400
Message-ID: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Cc: <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> some of us make use of snapshot/clone, whether it's using btrfs or zfs :)

No, this is just flat my fault: it doesn't matter what backup method you use if
you do it wrong.  (I actually have three snapshots of each of my two
partitions.)

> What do you mean don't let you do anything? Can you mount it read-only
> and copy the data off the disk?

You can mount it on the older kernels, but, once you try any form of access,
you can watch your load spike as it spews errors into dmesg.

> I'd try 3.1. If you use 11.10 try
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.1-oneiric/

3.1 is what the system had been running; it simply panics when trying to mount
the FS.

> Try getting source of btrfs-progs, do "make btrfs-zero-log", and use it.

Already got 'em.  Everything that tries to even think about modifying stuff
(btrfs-zero-log, btrfsck, and btrfs-debug-tree) all dump core:

root@ubuntu:/tmp/btrfs-progs# ./btrfs-zero-log /dev/sda1
parent transid verify failed on 100695031808 wanted 217713 found 217732
parent transid verify failed on 100695031808 wanted 217713 found 217732
parent transid verify failed on 100695031808 wanted 217713 found 217732
btrfs-zero-log: disk-io.c:413: find_and_setup_root: Assertion '!(!root->node)'
failed.
Aborted (core dumped)


-Ken





