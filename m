From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V3 0/6] random bugfixes of the space management
Date: Wed, 05 Jan 2011 18:07:11 +0800
Message-ID: <4D2442CF.8060702@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Chris

I have a bunch of random fixes of the space management in

git://repo.or.cz/linux-btrfs-devel.git space-manage

They are the ENOSPC fixes, as well as fixes for df command.
The first one and the last one fixed the wrong free space information reported
by df command. The second one fixed ENOSPC when there is tiny space in the
filesystem. And The third fixed wrong calculation of stripe size. And the 4th
and 5th patches fixed the chunk allocation problem when the block devices have
no enough space to allocate a default-size chunk.

Changelog V2 -> V3:
- fix panic caused by freeing a invalid memory address.

Changelog V1 -> V2:
- fix compiler errors on x86_32 machines.
- fix some bugs when allocating dup chunks.
- break the chunk allocation when errors happen.
- just allocate min_stripes stripes when the free space is not enough.
- cleanup redundant code.

If you want to merge this patchset to your "next" branch for testing, you can merge it
directly after dropping the top four patches of the "next" branch.

Thanks
Miao
---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |   71 +++++-
 fs/btrfs/super.c       |  147 +++++++++++-
 fs/btrfs/volumes.c     |  614 +++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.h     |   27 ++
 5 files changed, 685 insertions(+), 176 deletions(-)
