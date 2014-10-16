Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65264 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaJPHvU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 03:51:20 -0400
Message-ID: <543F78F1.6040203@fb.com>
Date: Thu, 16 Oct 2014 03:51:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs corruption fix
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I'm testing a pull with more fixes, but wanted to get this one out so
Greg can pick it up.  The corruption isn't easy to hit, you have to do a
readonly snapshot and have orphans in the snapshot.  But my review and
testing missed the bug.  Filipe has added a better xfstest to cover it.

Please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (1) commits (+33/-36):
    Revert "Btrfs: race free update of commit root for ro snapshots"

Total: (1) commits (+33/-36)

 fs/btrfs/inode.c | 36 ------------------------------------
 fs/btrfs/ioctl.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 36 deletions(-)
