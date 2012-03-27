From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [GIT PULL] Btrfs fixes for 3.4
Date: Tue, 27 Mar 2012 16:11:57 +0200
Message-ID: <cover.1332852833.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

please pull my three current patches from my repo, based on your
for-linus branch (I can rebase them to the integration branch if that
helps):

	git://git.jan-o-sch.net/btrfs-unstable for-chris

It's two really small fixes both mentioned earlier and a more or less
imporant fixup for scrub. While working fine in 3.2, name resolving can
deadlock since the first rc of 3.3. I suggest we queue that patch 3/3
for submission to 3.3-stable.

I'm passing xfstests just as good as for-linus is doing without my
patches (which is not really good). I also made some manual error
insertion tests to verify that the scrub deadlock chance is really gone.

And, we really should have an xfstest for raid-repair and scrub-repair.
Anyone? :-)

-Jan

Jan Schmidt (3):
  Btrfs: actually call btrfs_init_lockdep
  Btrfs: check return value of btrfs_cow_block()
  Btrfs: fix regression in scrub path resolving

 fs/btrfs/backref.c     |  115 +++++++++++++++++++++++++++--------------------
 fs/btrfs/backref.h     |    5 +-
 fs/btrfs/ioctl.c       |    4 +-
 fs/btrfs/scrub.c       |    4 +-
 fs/btrfs/super.c       |    2 +
 fs/btrfs/transaction.c |    6 ++-
 6 files changed, 79 insertions(+), 57 deletions(-)

-- 
1.7.3.4

