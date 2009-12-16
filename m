From: regomodo <regomodo@googlemail.com>
Subject: BTRFS major fault
Date: Wed, 16 Dec 2009 18:29:38 +0000
Message-ID: <200912161829.38785.regomodo@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was running linux-kernel-2.6.32.1 and suspended my system using
"hibernate-ram".

When I resumed the system was OK for a moment then froze up. I managed to
get to tty1 easily and saw errors relating to btrfs.
I did not manage to get the error down but it had an abbreviation of
checksum and said maybe something about an inode/node. There was maybe 2
numbers possibly separated by  ":". I'm pretty sure the numbers were the
same at each stderr printout. Sorry for the vagueness.

Anyway. I tried to "reboot" but the errors continued and the shutdown
process wasn't happening. I r.e.i.s.u.b and reboot back into my system

The btrfs FS/volumes wouldn't mount so I tried to run a btrfsck. This is
what I got:

funtoo-pc ~ # btrfsck /dev/sda
failed to read /dev/sdf
failed to read /dev/sr0
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
failed.
Aborted
funtoo-pc ~ # btrfsck /dev/sdb
failed to read /dev/sdf
failed to read /dev/sr0
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)'
failed.
Aborted

ENV: funtoo-amd64; linux-2.6.32.1; x1 Btrfs FS, made up of x2 Samsung 500GB
sata hdd, in Raid0, and contained x2 subvolumes

I'm not trying to fix my issue -- I have a backup -- just reporting
something I found.


Cheers

Reg
