From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 0/8] Balance mangement
Date: Sun, 10 Apr 2011 22:06:03 +0100
Message-ID: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   Hi, Chris,

   Another iteration of the balance management patches. This includes
suggestions from David Sterba, who did a fairly comprehensive review
of the patch series on IRC. It also includes fixes for comments from
Josef, and Li Zefan. The only thing I've not included here is Li's
suggestion of keeping track of the size of the chunks and the data in
them -- I'm working on the patch for that, and it'll be along once
I've had a chance to test it sensibly.

   Hugo.

---

Hugo Mills (8):
  btrfs: Balance progress monitoring
  btrfs: Cancel filesystem balance
  btrfs: Factor out enumeration of chunks to a separate function
  btrfs: Implement filtered balance ioctl
  btrfs: Balance filter for device ID
  btrfs: Balance filter for virtual address ranges
  btrfs: Replication-type information
  btrfs: Balance filter for physical device address

 fs/btrfs/ctree.h   |   10 ++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |  104 +++++++++++++++-
 fs/btrfs/ioctl.h   |   49 +++++++
 fs/btrfs/super.c   |   16 +--
 fs/btrfs/volumes.c |  354 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   21 +++-
 7 files changed, 468 insertions(+), 88 deletions(-)

-- 
1.7.2.5

