Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425488AbcFHNDh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jun 2016 09:03:37 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs, misc fixes for 4.7-rc3
Date: Wed,  8 Jun 2016 15:04:09 +0200
Message-Id: <cover.1465390735.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a small set of fixes, a build fix and one minor enhancemen that will tell us
the crc32 implementation used. Please pull, thanks.

The following changes since commit 56244ef151c3cd11f505020ab0b3f45454363bcc:

  Btrfs: fix handling of faults from btrfs_copy_from_user (2016-05-26 13:23:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-fixes-4.7

for you to fetch changes up to 5f9e1059d9347191b271bf7d13bd83db57594d2a:

  btrfs: advertise which crc32c implementation is being used at module load (2016-06-06 14:08:28 +0200)

----------------------------------------------------------------
Jeff Mahoney (1):
      btrfs: advertise which crc32c implementation is being used at module load

Josef Bacik (1):
      Btrfs: end transaction if we abort when creating uuid root

Liu Bo (3):
      Btrfs: clear uptodate flags of pages in sys_array eb
      Btrfs: add more validation checks for superblock
      Btrfs: add validadtion checks for chunk loading

Vinson Lee (1):
      btrfs: Use __u64 in exported linux/btrfs.h.

 fs/btrfs/disk-io.c         |  11 +++++
 fs/btrfs/hash.c            |   5 +++
 fs/btrfs/hash.h            |   1 +
 fs/btrfs/super.c           |   5 ++-
 fs/btrfs/volumes.c         | 109 ++++++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/btrfs.h |   2 +-
 6 files changed, 115 insertions(+), 18 deletions(-)
