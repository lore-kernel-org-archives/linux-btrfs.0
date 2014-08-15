Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47533 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaHOC7L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 22:59:11 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com, hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v3 0/2] vfs / btrfs: add support for ustat()
Date: Thu, 14 Aug 2014 19:58:56 -0700
Message-Id: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v3 has this small fix identified by Filipe Manana on the
btrfs specific patch. The v2 series was briefly discussed but
upon providing a use case and reasoning for the way things
were changed I haven't gotten any more further advice or
feedback.

Christoph had noted that this seemed associated to the problem
that the btrfs uses different assignments for st_dev than s_dev,
but much as I'd like to see that changed based on discussions so
far its unclear if this is going to be possible unless strong
commitment is reached. What this tries to do was to take the
other way around the problem, by slowly shifting out junk. I
think this approach might be more feasible over time. I see this
as an extension to Al's original commit 0ee5dc676 but more in line
with how they are really are used and exposes more information to
the VFS. As it stands now other filesystems can pop up and do
similar things, this at least extends the original API to fit
the use case a bit more closely to how its used and allows more
room to grow.

Let's consider this userspace case:

        struct stat buf;
        struct ustat ubuf;

        /* Find a valid device number */
        if (stat("/", &buf)) {
                fprintf(stderr, "Stat failed: %s\n", strerror(errno));
                return 1;
        }

        /* Call ustat on it */
        if (ustat(buf.st_dev, &ubuf)) {
                fprintf(stderr, "Ustat failed: %s\n", strerror(errno));
                return 1;
        }

In the btrfs case it has an inode op for getattr, that is used and we set
the dev to anonymous dev_t. Later ustat will use user_get_super() which
will only be able to work with a userblock if the super block's only
dev_t is assigned to it. Since we have many anonymous to dev_t mapping
to super block though we can't complete the search for btfs and ustat()
fails with -EINVAL. The series expands the number of dev_t's that a super
block can have and allows this search to complete.

Luis R. Rodriguez (2):
  fs/super.c: add new super block sub devices super_block_dev
  btrfs: use the new VFS super_block_dev

 fs/btrfs/ctree.h   |  7 ++----
 fs/btrfs/disk-io.c |  7 +++---
 fs/btrfs/inode.c   |  2 +-
 fs/super.c         | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h | 10 ++++++++
 5 files changed, 82 insertions(+), 12 deletions(-)

-- 
2.0.3

