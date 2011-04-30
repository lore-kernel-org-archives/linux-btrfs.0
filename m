From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v6 0/8] Balance management
Date: Sat, 30 Apr 2011 15:23:55 +0100
Message-ID: <1304173443-29159-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   Hi, Chris,

   One more round of the balance management patches. There's very
little changed from last time -- a compilation issue spotted by David,
two minor checkpatch failures, and a re-spin against the latest
btrfs-unstable. Could you consider these patches for 2.6.40, please?

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
 fs/btrfs/ioctl.c   |  104 +++++++++++++++-
 fs/btrfs/ioctl.h   |   49 +++++++
 fs/btrfs/super.c   |   16 +--
 fs/btrfs/volumes.c |  354 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   21 +++-
 7 files changed, 468 insertions(+), 88 deletions(-)

-- 
1.7.2.5

