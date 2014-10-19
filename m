Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9060 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbaJSKBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 06:01:38 -0400
Message-ID: <54438BEC.4090708@fb.com>
Date: Sun, 19 Oct 2014 06:01:16 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [GIT PULL] Btrfs for stable (mostly 3.17)
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pulled out some of the btrfs commits from the merge window that
we'd like to see in stable.  The full list of sha's from Linus is below,
you can see 4 of them are only needed on 3.17

2fad4e83e12591eb3bd213875b9edc2d18e93383
0b4699dcb65c2cff793210b07f40b98c2d423a43 # v3.17
12b894cb288d57292b01cf158177b6d5c89a6272
78a017a2c92df9b571db0a55a016280f9019c65e
4d1a40c66bed0b3fa43b9da5fbd5cbe332e4eccf
e6c4efd87ab04e5ead363f24e6ac35ed3506d401 # v3.17
f6acfd50110b335c7af636cf1fc8e55319cae5fc
1d52c78afbbf80b58299e076a159617d6b42fe3c
75bfb9aff45e44625260f52a5fd581b92ace3e62
bbe9051441effce51c9a533d2c56440df64db2d7
32be3a1ac6d09576c57063c6c350ca36eaebdbd3 # v3.17
42383020beb1cfb05f5d330cc311931bc4917a97
d37973082b453ba6b89ec07eb7b84305895d35e1 # v3.17

I've made a git branch (stable-3.17) with all of these cherry picked out:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git stable-3.17

They all cherry pick cleanly, so the git tree is mostly for btrfs users
who wanted a recent corruption fix.  Feel free to pull or feed the shas
into your scripts.  The last one (d37973082b) was already tagged for
stable, so you've probably got it already through the regular channels.
It shouldn't need special ordering.

Josef Bacik (4) commits (+72/-32):
    Btrfs: fix build_backref_tree issue with multiple shared blocks (+4/-1)
    Btrfs: cleanup error handling in build_backref_tree (+59/-29)
    Btrfs: don't do async reclaim during log replay (+7/-1)
    Btrfs: try not to ENOSPC on log replay (+2/-1)

Qu Wenruo (3) commits (+60/-24):
    btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map (+57/-22)
    btrfs: Fix the wrong condition judgment about subset extent map (+1/-1)
    btrfs: Fix a deadlock in btrfs_dev_replace_finishing() (+2/-1)

Filipe Manana (1) commits (+3/-0):
    Btrfs: add missing compression property remove in btrfs_ioctl_setflags

Sage Weil (1) commits (+9/-3):
    Btrfs: fix race in WAIT_SYNC ioctl

Mark Fasheh (1) commits (+8/-2):
    btrfs: don't go readonly on existing qgroup items

Liu Bo (1) commits (+15/-10):
    Btrfs: fix up bounds checking in lseek

Chris Mason (1) commits (+33/-36):
    Revert "Btrfs: race free update of commit root for ro snapshots"

David Sterba (1) commits (+6/-0):
    btrfs: wake up transaction thread from SYNC_FS ioctl

Total: (13) commits (+206/-107)

 fs/btrfs/dev-replace.c |   3 +-
 fs/btrfs/extent-tree.c |   8 +++-
 fs/btrfs/file.c        |  25 ++++++-----
 fs/btrfs/inode.c       | 118 ++++++++++++++++++++++++-------------------------
 fs/btrfs/ioctl.c       |  42 ++++++++++++++++++
 fs/btrfs/qgroup.c      |  10 ++++-
 fs/btrfs/relocation.c  |  93 +++++++++++++++++++++++++-------------
 fs/btrfs/transaction.c |  12 +++--
 8 files changed, 205 insertions(+), 106 deletions(-)
