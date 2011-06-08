From: Arne Jansen <sensille@gmx.net>
Subject: [GIT PULL] scrub fixes for -rc3
Date: Wed, 08 Jun 2011 10:58:40 +0200
Message-ID: <4DEF39C0.8040405@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
for-chris

It contains the 2 commits

Arne Jansen (1):
      btrfs: scrub: errors in tree enumeration

Li Zefan (1):
      Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()

It also reverts

commit cb25c2ea6a79702ab7895b873c6c43e0d3bc3c72
Author: Josef Bacik <josef@redhat.com>
Date:   Wed May 11 12:17:34 2011 -0400

    Btrfs: map the node block when looking for readahead targets

because it breaks readahead and with it scrub. This went unnoticed,
because another commit disabled reada in many calling sites. Scrub
is a heavy user of reada.

Thanks,
Arne
