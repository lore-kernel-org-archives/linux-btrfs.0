Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4144 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab3LLV5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 16:57:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20131212215704.23771.16640@ret.masoncoding.com>
From: Chris Mason <clm@fb.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 12 Dec 2013 16:57:04 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch (or for-linus signed tag):

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small collection of fixes.  It was rebased this morning, but I
was just fixing signed-off-by tags with the wrong email.

Wang Shilong (3) commits (+57/-24):
    Btrfs: skip building backref tree for uuid and quota tree when doing balance relocation (+3/-1)
    Btrfs: make sure we cleanup all reloc roots if error happens (+7/-0)
    Btrfs: fix an oops when doing balance relocation (+47/-23)

Filipe David Borba Manana (1) commits (+10/-12):
    Btrfs: don't miss skinny extent items on delayed ref head contention

Dan Carpenter (1) commits (+2/-2):
    Btrfs: fix access_ok() check in btrfs_ioctl_send()

Miao Xie (1) commits (+2/-3):
    Btrfs: don't clear the default compression type

David Sterba (1) commits (+2/-1):
    btrfs: call mnt_drop_write after interrupted subvol deletion

Total: (7) commits (+73/-42)

 fs/btrfs/extent-tree.c | 22 +++++++-------
 fs/btrfs/ioctl.c       |  3 +-
 fs/btrfs/relocation.c  | 81 +++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/send.c        |  4 +--
 fs/btrfs/super.c       |  5 ++--
 5 files changed, 73 insertions(+), 42 deletions(-)
