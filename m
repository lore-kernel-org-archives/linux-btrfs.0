From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] various updates for -rc3
Date: Tue, 15 Nov 2011 15:07:11 -0500
Message-ID: <20111115200711.GC1944@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

Here are the cluster rework patches from Alexandre along with my tracepoints
patch and a couple of bugfixes.  This should fix the panics we've been seeing
when running xfstests 13 in a loop.  The cluster fixes I've been testing for a
while, and the tracepoints patch I used to profile the new clustering stuff to
make sure it was giving us a good behavior.  I have a repo with some tools to
use the allocator tracepoints

git://github.com/josefbacik/btrfs-tracing.git

In all respects Alexandre's patches work wonders.  You can pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git for-chris

which is based off of your for-linus branch.  The shortlog and diffstat is
attached below.  Thanks,

Josef

Alexandre Oliva (3):
      Revamp btrfs cluster creation logic.
      Drop gap detection from btrfs.
      Require at least one extent of the requested size, but accept other smaller ones except when SSD_SPREAD is enabled.

Josef Bacik (3):
      Btrfs: add allocator tracepoints
      Btrfs: wait on caching if we're loading the free space cache
      Btrfs: clear pages dirty for io and set them extent mapped

 fs/btrfs/ctree.h             |    3 +-
 fs/btrfs/extent-tree.c       |  130 ++++++++++++++++++++++----------
 fs/btrfs/free-space-cache.c  |  130 ++++++++++++++++----------------
 include/trace/events/btrfs.h |  173 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 329 insertions(+), 107 deletions(-)
