Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44339 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbbCFVpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Mar 2015 16:45:52 -0500
Date: Fri, 6 Mar 2015 16:45:48 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150306214521.GA13213@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has some btrfs fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I did rebase a patch out of the queue last night after tracking down
some problems Dave Sterba was seeing during xfstests (the top three are
obviously rebased).  It was an isolated patch and we've retested since I
removed it.

Outside of misc fixes, Filipe has a few fsync corners and we're pulling in
one more of Josef's fixes from production use here.

Filipe Manana (6) commits (+224/-57):
    Btrfs: do not ignore errors from btrfs_lookup_xattr in do_setxattr (+6/-2)
    Btrfs: incremental send, don't rename a directory too soon (+156/-15)
    Btrfs: fix fsync race leading to ordered extent memory leaks (+2/-5)
    Btrfs: fix off-by-one logic error in btrfs_realloc_node (+4/-4)
    Btrfs: add missing inode update when punching hole (+28/-3)
    Btrfs: fix data loss in the fast fsync path (+28/-28)

Josef Bacik (2) commits (+16/-3):
    Btrfs: abort the transaction if we fail to update the free space cache inode (+16/-0)
    Btrfs: remove extra run_delayed_refs in update_cowonly_root (+0/-3)

David Sterba (1) commits (+0/-1):
    btrfs: fix lost return value due to variable shadowing

Quentin Casasnovas (1) commits (+1/-1):
    Btrfs:__add_inode_ref: out of bounds memory read when looking for extended ref.

Total: (10) commits (+241/-62)

 fs/btrfs/ctree.c        |   8 +--
 fs/btrfs/extent-tree.c  |  16 +++++
 fs/btrfs/file.c         |  87 +++++++++++++++---------
 fs/btrfs/inode.c        |   1 -
 fs/btrfs/ordered-data.c |   7 +-
 fs/btrfs/send.c         | 171 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/transaction.c  |   3 -
 fs/btrfs/tree-log.c     |   2 +-
 fs/btrfs/xattr.c        |   8 ++-
 9 files changed, 241 insertions(+), 62 deletions(-)
