From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 0/2] Btrfs-progs: commands "resolve inode" and "resolve logical"
Date: Thu,  7 Jul 2011 18:01:38 +0200
Message-ID: <cover.1310053983.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The kernel patch series just sent (Subject: "Btrfs: scrub: print path to
corrupted files and trigger nodatasum fixup") introduces two new ioctls to
do in-kernel filesystem path construction. This series provides the
corresponding userspace changes, adding two new commands to the btrfs utility:

--
btrfs resolve inode [-v] <inode> <path>
	resolves an <inode> to all filesystem paths local to the fs mounted
	at <path>.
		-v  print count of returned and missed paths

btrfs resolve logical [-v] [-P] <logical> <path>
	resolves a <logical> address to all filesystem paths in the file
	system mounted at <path> and all its subvolumes.
		-v  print count of returned and missed inode/offset/root
		    triples
		-P  do not resolve the path but stop after finding all
		    inodes at this logical address and print them instead
--

These patches are based on Hugo's current integration branch.

Please try them out and report bugs here. I'll send an update to the manpages
later.

-Jan

Jan Schmidt (2):
  btrfs-list: split list_subvols
  added ioctls and commands to resolve inodes and logical addresses

 btrfs-list.c |  139 ++++++++++++++++++++++++++++++++++------------
 btrfs.c      |   10 +++
 btrfs_cmds.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs_cmds.h |    3 +
 ioctl.h      |   29 ++++++++++
 5 files changed, 323 insertions(+), 35 deletions(-)

-- 
1.7.3.4

