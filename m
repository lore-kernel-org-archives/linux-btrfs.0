From: C Anthony Risinger <anthony@extof.me>
Subject: list subvolumes with new btrfs command
Date: Sun, 25 Apr 2010 13:27:43 -0500
Message-ID: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

i maintain an unofficial initrd hook in Arch Linux that allows BTRFS
to be used as the root device.  i am trying to update the hook to use
the more extensive "btrfs" command, adding support for users to change
their default subvolume from within the initrd (i'm creating a sort of
rollback feature, in conjunction with automatic snapshotting via the
package manager), and adding support for hot spares (via a second
BTRFS pool in which devices are "stolen" to repair the primary array).

anyways, i'm having trouble getting a listing of subvolumes:

$ btrfs subvolume list /
ERROR: can't perform the search

the machine has a BTRFS root.  i have also tried creating a snapshot
and pointing the command at that, but i get the same results.  am i
using the command wrong?  relevant code is from btrfs-list.c:

ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
if (ret < 0) {
  fprintf(stderr, "ERROR: can't perform the search\n");
  return 0;
}

kernel:

$ uname -r
2.6.33-ARCH

is there a new CONFIG_* kernel parameter that needs to be set since
2.6.32?  everything seems to be in order and working fine... any help
appreciated.

thanks,
C Anthony
