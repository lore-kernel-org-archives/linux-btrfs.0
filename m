From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 0/6] random bugfixes of the space management
Date: Wed, 22 Dec 2010 18:47:08 +0800
Message-ID: <4D11D72C.7010704@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a bunch of random fixes of the space management in

git://repo.or.cz/linux-btrfs-devel.git space-manage

They are the ENOSPC fixes, as well as fixes for df command.
The first one and the last one fixed the wrong free space information reported
by df command. The second one fixed ENOSPC when there is tiny space in the
filesystem. And The third fixed wrong calculation of stripe size. And the 4th
and 5th patches fixed the chunk allocation problem when the block devices have
no enough space to allocate a default-size chunk.

---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |   71 ++++++-
 fs/btrfs/super.c       |  147 +++++++++++-
 fs/btrfs/volumes.c     |  606 +++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.h     |   27 +++
 5 files changed, 682 insertions(+), 171 deletions(-)
