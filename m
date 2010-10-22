From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] random bugfixes
Date: Fri, 22 Oct 2010 16:10:59 -0400
Message-ID: <20101022201059.GB4455@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a bunch of random fixes in 

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git bug-fixes

They are the ENOSPC fixes I've been working on, as well as fixes for df and
btrfs filesystem df.  Also there is a patch that fixes a panic when specifying
an invalid subvol with mount -o subvol=<foo>.  There is one patch in here that
is for mixed block groups, but it's really just to make sure the space
accounting is done properly so it isn't mixed block group specific, it's just
needed for mixed block groups to work right.  I included it because it was
easier to do my rebase with it.  Here is the shortlog

Josef Bacik (8):
      Btrfs: stop trying to shrink delalloc if there are no inodes to reclaim
      Btrfs: fix the df ioctl to report raid types
      Btrfs: fix df regression
      Btrfs: fix reservation code for mixed block groups
      Btrfs: re-work delalloc flushing
      Btrfs: don't allocate chunks as aggressively
      Btrfs: rework how we reserve metadata bytes
      Btrfs: fix error handling in btrfs_get_sb

The branch is based off of v2.6.35.  Everything has been tested with xfstests
and my enospc tests and it all passes.  Thanks,

Josef
