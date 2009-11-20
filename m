From: Albert Strasheim <fullung@gmail.com>
Subject: fsck.btrfs assertion failure with large number of disks in fs
Date: Fri, 20 Nov 2009 08:31:58 +0200
Message-ID: <5eec5f300911192231m33ea0ad4ye9a7fd5eec085cc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all

We are experimenting with btrfs and we've run into some problems.

We are running on two Sun Storage J4400 Arrays containing a total of
48 1 TB disks.

With 24 disks in the btrfs:

# mkfs.btrfs /dev/sd[b-y]

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdc id 2
...
adding device /dev/sdy id 24
fs created label (null) on /dev/sdb
        nodesize 4096 leafsize 4096 sectorsize 4096 size 21.83TB
Btrfs Btrfs v0.19

fsck.btrfs runs fine:

# sudo fsck.btrfs /dev/sdb
found 36864 bytes used err is 0
total csum bytes: 0
total tree bytes: 36864
total fs tree bytes: 4096
btree space waste bytes: 26174
file data blocks allocated: 0
 referenced 0
Btrfs Btrfs v0.19

Now with one more disk:

# mkfs.btrfs /dev/sd[b-z]

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdc id 2
...
adding device /dev/sdz id 25
fs created label (null) on /dev/sdb
        nodesize 4096 leafsize 4096 sectorsize 4096 size 22.74TB
Btrfs Btrfs v0.19

# fsck.btrfs /dev/sdb
fsck.btrfs: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.
Aborted

mkfs.btrfs compiled from the Git repository fails with the same error message.

Other pertinent information:

# uname -a
Linux blade1 2.6.31-14-generic #48-Ubuntu SMP Fri Oct 16 14:05:01 UTC
2009 x86_64 GNU/Linux

We are investigating btrfs for a long term project, so we would be
happy to provide any debug information or test any kernel or
btrfs-progs patches.

Regards,

Albert
