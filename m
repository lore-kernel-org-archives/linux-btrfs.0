From: bchociej@gmail.com
Subject: [PATCH 0/2] Btrfs-progs: Add support for hot data migration
Date: Thu, 12 Aug 2010 17:29:35 -0500
Message-ID: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch set introduces functionality into btrfsctl and mkfs.btrfs to
support the kernel patches for hot data tracking and migration to SSD
with Btrfs. New functionality includes a -h option to mkfs.btrfs to
preallocate approrpiate block group types for SSD data migration, and
also includes additional options for btrfsctl to interact with the new
ioctls introduced by the kernel patches.


DIFFSTAT:

 btrfsctl.c    |  111 +++++++++++++++++++++++++++++++++++++++-
 ctree.h       |    2 +
 extent-tree.c |    2 +-
 ioctl-test.c  |    3 +
 ioctl.h       |   24 +++++++++
 mkfs.c        |  131 ++++++++++++++++++++++++++++++++++++++++-------
 utils.c       |    1 +
 volumes.c     |   73 +++++++++++++++++++++++++-
 volumes.h     |    3 +-
 9 files changed, 326 insertions(+), 24 deletions(-)


Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Tested-by: Conor Scott <conscott@vt.edu>
