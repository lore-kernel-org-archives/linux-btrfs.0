Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9136 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbbEAOIZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 May 2015 10:08:25 -0400
Date: Fri, 1 May 2015 10:08:05 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150501140750.GA16744@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have a few more btrfs fixes in my for-linus-4.1 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1

These range from corners Filipe found in the new free space cache
writeback to a grab bag of fixes from the list.

Omar Sandoval (4) commits (+38/-19):
    btrfs: unlock i_mutex after attempting to delete subvolume during send (+2/-1)
    btrfs: check io_ctl_prepare_pages return in __btrfs_write_out_cache (+6/-4)
    btrfs: fix race on ENOMEM in alloc_extent_buffer (+2/-1)
    btrfs: handle ENOMEM in btrfs_alloc_tree_block (+28/-13)

Forrest Liu (2) commits (+37/-29):
    Btrfs: btrfs_release_extent_buffer_page didn't free pages of dummy extent (+26/-25)
    Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole (+11/-4)

Filipe Manana (2) commits (+28/-18):
    Btrfs: fix race between start dirty bg cache writeout and bg deletion (+27/-17)
    Btrfs: fix deadlock when starting writeback of bg caches (+1/-1)

Yang Dongsheng (1) commits (+14/-9):
    Btrfs: fill ->last_trans for delayed inode in btrfs_fill_inode.

Chris Mason (1) commits (+1/-2):
    Btrfs: don't check for delalloc_bytes in cache_save_setup

Total: (10) commits (+118/-77)

 fs/btrfs/delayed-inode.c    |  2 +
 fs/btrfs/extent-tree.c      | 90 ++++++++++++++++++++++++++++-----------------
 fs/btrfs/extent_io.c        | 54 ++++++++++++++-------------
 fs/btrfs/free-space-cache.c | 10 +++--
 fs/btrfs/inode.c            | 21 ++++++-----
 fs/btrfs/ioctl.c            |  3 +-
 fs/btrfs/volumes.c          | 15 ++++++--
 7 files changed, 118 insertions(+), 77 deletions(-)
