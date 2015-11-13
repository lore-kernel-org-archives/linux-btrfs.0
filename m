Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45370 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932787AbbKMUhR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 15:37:17 -0500
Date: Fri, 13 Nov 2015 15:37:00 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151113203700.GC17545@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.4 branch is ready for pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.4

Some of this got cherry-picked from a github repo this week, but I
verified the patches.  We have three small scrub cleanups and a
collection of fixes.

Zhao Lei (9) commits (+97/-122):
    btrfs: Use scrub_checksum_data and scrub_checksum_tree_block for scrub_recheck_block_checksum (+36/-94)
    btrfs: Reset sblock->xxx_error stats before calling scrub_recheck_block_checksum (+4/-0)
    btrfs: scrub: set error stats when tree block spanning stripes (+6/-0)
    btrfs: Reduce unnecessary arguments in scrub_recheck_block (+8/-20)
    btrfs: Fix lost-data-profile caused by auto removing bg (+5/-2)
    btrfs: Use fs_info directly in btrfs_delete_unused_bgs (+2/-2)
    btrfs: scrub: setup all fields for sblock_to_check (+12/-0)
    btrfs: Fix lost-data-profile caused by balance bg (+21/-0)
    btrfs: Remove len argument from scrub_find_csum (+3/-4)

Filipe Manana (6) commits (+61/-25):
    Btrfs: fix race leading to incorrect item deletion when dropping extents (+12/-4)
    Btrfs: fix race leading to BUG_ON when running delalloc for nodatacow (+8/-2)
    Btrfs: fix sleeping inside atomic context in qgroup rescan worker (+0/-1)
    Btrfs: fix extent accounting for partial direct IO writes (+37/-15)
    Btrfs: fix race waiting for qgroup rescan worker (+1/-2)
    Btrfs: fix race when listing an inode's xattrs (+3/-1)

Justin Maggard (1) commits (+9/-3):
    btrfs: qgroup: exit the rescan worker during umount

Total: (16) commits (+167/-150)

 fs/btrfs/disk-io.c     |   3 +
 fs/btrfs/extent-tree.c |  11 +--
 fs/btrfs/file.c        |  16 +++--
 fs/btrfs/inode.c       |  62 ++++++++++++-----
 fs/btrfs/qgroup.c      |  13 ++--
 fs/btrfs/scrub.c       | 179 ++++++++++++++++++-------------------------------
 fs/btrfs/volumes.c     |  21 ++++++
 fs/btrfs/xattr.c       |   4 +-
 8 files changed, 163 insertions(+), 146 deletions(-)
