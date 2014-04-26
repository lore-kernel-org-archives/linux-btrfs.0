Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41569 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbaDZXbQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 19:31:16 -0400
Message-ID: <535C41EA.5070408@fb.com>
Date: Sat, 26 Apr 2014 19:31:54 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull these fixes from my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Wang Shilong (3) commits (+24/-20):
    Btrfs: avoid triggering bug_on() when we fail to start inode caching task (+5/-1)
    Btrfs: move btrfs_{set,clear}_and_info() to ctree.h (+14/-14)
    Btrfs: fix possible memory leaks in open_ctree() (+5/-5)

Filipe Manana (2) commits (+5/-1):
    Btrfs: use correct key when repeating search for extent item (+2/-0)
    Btrfs: correctly set profile flags on seqlock retry (+3/-1)

Christoph Jaeger (1) commits (+6/-2):
    btrfs: fix use-after-free in mount_subvol()

Chris Mason (1) commits (+5/-0):
    Btrfs: limit the path size in send to PATH_MAX

Qu Wenruo (1) commits (+1/-1):
    btrfs: Change the hole range to a more accurate value.

David Sterba (1) commits (+5/-5):
    btrfs: replace error code from btrfs_drop_extents

Miao Xie (1) commits (+2/-16):
    Btrfs: fix inode caching vs tree log

Total: (10) commits (+48/-45)

 fs/btrfs/ctree.h       | 14 ++++++++++++++
 fs/btrfs/disk-io.c     | 10 +++++-----
 fs/btrfs/extent-tree.c |  6 +++++-
 fs/btrfs/file.c        |  8 ++++----
 fs/btrfs/inode-map.c   | 24 +++++++-----------------
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/send.c        |  5 +++++
 fs/btrfs/super.c       | 22 ++++++----------------
 8 files changed, 48 insertions(+), 45 deletions(-)
