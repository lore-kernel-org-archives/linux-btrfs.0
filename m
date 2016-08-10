Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16512 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934063AbcHJSgb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:36:31 -0400
Date: Wed, 10 Aug 2016 08:10:44 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160810121044.jonlekiaswudzrsh@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.8 branch has some fixes for btrfs send/recv and fsync
from Filipe and Robbie Ko:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

Bonus points to Filipe for already having xfstests in place for many of
these.

Filipe Manana (8) commits (+172/-52):
    Btrfs: improve performance on fsync against new inode after rename/unlink (+95/-9)
    Btrfs: send, avoid incorrect leaf accesses when sending utimes operations (+2/-0)
    Btrfs: remove unused function btrfs_add_delayed_qgroup_reserve() (+0/-30)
    Btrfs: be more precise on errors when getting an inode from disk (+18/-9)
    Btrfs: incremental send, fix invalid paths for rename operations (+2/-1)
    Btrfs: send, add missing error check for calls to path_loop() (+2/-0)
    Btrfs: add missing check for writeback errors on fsync (+8/-0)
    Btrfs: send, don't bug on inconsistent snapshots (+45/-3)

Robbie Ko (4) commits (+111/-7):
    Btrfs: send, fix invalid leaf accesses due to incorrect utimes operations (+11/-1)
    Btrfs: send, fix warning due to late freeing of orphan_dir_info structures (+4/-0)
    Btrfs: send, fix failure to move directories with the same name around (+95/-5)
    Btrfs: incremental send, fix premature rmdir operations (+1/-1)

Total: (12) commits (+283/-59)

 fs/btrfs/delayed-ref.c |  27 --------
 fs/btrfs/delayed-ref.h |   3 -
 fs/btrfs/file.c        |   8 +++
 fs/btrfs/inode.c       |  46 ++++++++++---
 fs/btrfs/send.c        | 173 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/tree-log.c    |  85 +++++++++++++++++++++---
 6 files changed, 283 insertions(+), 59 deletions(-)
