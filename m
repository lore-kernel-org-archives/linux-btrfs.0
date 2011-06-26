From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v8 0/8] Balance management patches, v8
Date: Sun, 26 Jun 2011 21:36:47 +0100
Message-ID: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   v7 was a real mess -- I made any number of errors in rebasing it
onto the 3.0 tree -- so I've skipped direct to v8. Thanks to David
Sterba for pointing out all the problems.

   Changes since v6: rebased to 3.0-rc4.

   This series can also be pulled from the balance-management-v8
branch of http://git.darksatanic.net/repo/btrfs-kernel.git/

   Hugo.

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
 fs/btrfs/ioctl.c   |  104 +++++++++++++-
 fs/btrfs/ioctl.h   |   49 ++++++
 fs/btrfs/super.c   |   16 +--
 fs/btrfs/volumes.c |  414 ++++++++++++++++++++++++++++++++++++----------------
 fs/btrfs/volumes.h |   23 +++-
 7 files changed, 482 insertions(+), 136 deletions(-)

-- 
1.7.2.5

