From: Cheng Renquan <crquan@gmail.com>
Subject: [RFC] why define "static int btrfs_csum_sizes[]" in a header file
	(ctree.h) ?
Date: Thu, 12 Aug 2010 08:46:54 +0800
Message-ID: <AANLkTik7dgX=EppkoSTjiU_Wz4b35r3=FaYFPcDdwbNo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

commit 607d432d referred a static int array defined in a header file,
and a static inline function (btrfs_super_csum_size) using this array,
the obvious result is every c file using that function would have
a local copy of that int array, multiple c files referred multiple copies
of that array:

$ nm fs/btrfs/btrfs.ko | grep btrfs_csum_sizes
0000010c r btrfs_csum_sizes
00000114 r btrfs_csum_sizes
000001c0 r btrfs_csum_sizes
000005a0 r btrfs_csum_sizes

the original commit has 4 c files called this static inline function, so
till now there are still those 4 c files calling it, so there are 4 copies
of btrfs_csum_sizes; but future code may call it in more c files;

 fs/btrfs/ctree.h     |   19 ++++++++++++++++-
 fs/btrfs/disk-io.c   |   25 +++++++++++++++++----
 fs/btrfs/file-item.c |   56 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/ioctl.c     |    9 ++++---
 fs/btrfs/tree-log.c  |   10 +++++---
 5 files changed, 81 insertions(+), 38 deletions(-)

multiple copies are just wasting memory; fixing that need to move
that int array and inline function to a c file, because that inline function
is using ARRAY_SIZE that need to know the array size at compile time;
and then the code would suffer uninlined btrfs_super_csum_size function call;

I wonder if here the community think those useless copies are worthy, or to
suffer uninlined fuunction call is better?

Cheers,

--
Cheng Renquan, Singapore
