Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46003 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbaFMT40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 15:56:26 -0400
Message-ID: <539B57EF.5080207@fb.com>
Date: Fri, 13 Jun 2014 15:58:39 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs #2 for 3.16
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This has a few fixes since our last pull and a new ioctl for doing btree
searches from userland.  It's very similar to the existing ioctl, but
lets us return larger items back down to the app.

Gerhard Heift (7) commits (+183/-38):
    btrfs: tree_search, copy_to_sk: return EOVERFLOW for too small buffer (+26/-2)
    btrfs: tree_search, copy_to_sk: return needed size on EOVERFLOW (+15/-9)
    btrfs: tree_search, search_ioctl: direct copy to userspace (+33/-15)
    btrfs: tree_search, search_ioctl: accept varying buffer (+11/-7)
    btrfs: tree_search: eliminate redundant nr_items check (+7/-5)
    btrfs: new function read_extent_buffer_to_user (+40/-0)
    btrfs: new ioctl TREE_SEARCH_V2 (+51/-0)

Eric Sandeen (3) commits (+11/-7):
    btrfs: free ulist in qgroup_shared_accounting() error path (+3/-1)
    btrfs: fix use of uninit "ret" in end_extent_writepage() (+1/-1)
    btrfs: fix error handling in create_pending_snapshot (+7/-5)

Wang Shilong (1) commits (+7/-2):
    Btrfs: fix unfinished readahead thread for raid5/6 degraded mounting

Filipe Manana (1) commits (+2/-0):
    Btrfs: fix qgroups sanity test crash or hang

Sasha Levin (1) commits (+1/-1):
    btrfs: prevent RCU warning when dereferencing radix tree slot

Total: (13) commits

 fs/btrfs/extent_io.c          |  39 ++++++++++-
 fs/btrfs/extent_io.h          |   3 +
 fs/btrfs/ioctl.c              | 147 ++++++++++++++++++++++++++++++++++--------
 fs/btrfs/qgroup.c             |   4 +-
 fs/btrfs/reada.c              |   9 ++-
 fs/btrfs/tests/btrfs-tests.c  |   2 +-
 fs/btrfs/tests/qgroup-tests.c |   2 +
 fs/btrfs/transaction.c        |  12 ++--
 include/uapi/linux/btrfs.h    |  10 +++
 9 files changed, 192 insertions(+), 36 deletions(-)
