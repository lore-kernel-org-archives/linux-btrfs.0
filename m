Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35855 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932696AbcKDR23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Nov 2016 13:28:29 -0400
Date: Fri, 4 Nov 2016 11:28:17 -0600
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20161104172816.GA62582@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.9 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.9

Has some fixes that Dave Sterba collected.  We held off on these last 
week because I was focused on the memory corruption testing.

I had asked you about pulling this directly from Dave, and you can skip
my merge commit here:

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.9-rc3

I'll probably have the merge commit when I nail down a fix for the crash 
Dave Jones triggered with trinity, but wanted to let you pick.

Wang Xiaoguang (3) commits (+10/-2):
     btrfs: pass correct args to btrfs_async_run_delayed_refs() (+2/-2)
     btrfs: fix WARNING in btrfs_select_ref_head() (+3/-0)
     btrfs: make file clone aware of fatal signals (+5/-0)

Dan Carpenter (1) commits (+4/-4):
     Btrfs: remove some no-op casts

Liu Bo (1) commits (+8/-1):
     Btrfs: kill BUG_ON in do_relocation

Goldwyn Rodrigues (1) commits (+7/-2):
     btrfs: qgroup: Prevent qgroup->reserved from going subzero

Total: (6) commits (+29/-9)

  fs/btrfs/extent-tree.c |  3 +++
  fs/btrfs/extent_io.c   |  8 ++++----
  fs/btrfs/inode.c       | 13 +++++++++----
  fs/btrfs/ioctl.c       |  5 +++++
  fs/btrfs/relocation.c  |  9 ++++++++-
  5 files changed, 29 insertions(+), 9 deletions(-)
