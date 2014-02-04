Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32835 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbaBDR6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 12:58:19 -0500
Message-ID: <52F12A66.3000707@fb.com>
Date: Tue, 4 Feb 2014 12:59:02 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull my for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Filipe is fixing compile and boot problems with our crc32c rework, and
Josef has disabled snapshot aware defrag for now.  As the number of
snapshots increases, we're hitting OOM.  For the short term we're
disabling things until a bigger fix is ready.

Filipe David Borba Manana (2) commits (+7/-7):
    Btrfs: use btrfs_crc32c everywhere instead of libcrc32c (+6/-6)
    Btrfs: use late_initcall instead of module_init (+1/-1)

Josef Bacik (1) commits (+1/-1):
    Btrfs: disable snapshot aware defrag for now

Total: (3) commits (+8/-8)

 fs/btrfs/check-integrity.c | 4 ++--
 fs/btrfs/disk-io.c         | 4 ++--
 fs/btrfs/inode.c           | 2 +-
 fs/btrfs/send.c            | 4 ++--
 fs/btrfs/super.c           | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)
