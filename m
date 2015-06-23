Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbbFWV2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 17:28:49 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: dedupe fixes, features V3
Date: Tue, 23 Jun 2015 14:28:35 -0700
Message-Id: <1435094920-22442-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

   The following patches are based on top of my patch titled "btrfs:
Handle unaligned length in extent_same" which you have in your
'integration-4.2' branch:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=e1d227a42ea2b4664f94212bd1106b9a3413ffb8

The series contains three fixes and two features.

The first patch in the series fixes a bug where we were sometimes
passing the aligned length to our comparison function. We actually can
stop at the user passed length for this as we don't need to compare
data past i_size (and we only align if the extents go out to i_size).

The 2nd patch fixes a deadlock between btrfs readpage and
btrfs_extent_same. This was reported on the list some months ago -
basically we had the page and extent locking reversed. My patch fixes
up the locking to be in the right order.

The 3rd patch fixes a deadlocks in clone() (wrt extent-same) which
David found while reviewing my fixes. I also found that clone doesn't
lock extent ranges in any particular order which could obvioulsy be a
problem so that is fixed there too.

The last two patches add features which have been requested often by
users - the 4th adds the ability to dedupe within the same inode, and
the last patch adds a dedupe flag to avoid mtime updates (this helps
with backup software).

These patches have been tested with the 'btrfs-extent-same' tool that
can be found at:

https://github.com/markfasheh/duperemove/blob/nomtime/btrfs-extent-same.c

Changes from V2 to V3:
  - better flag naming in patch #5, thanks to David

Changes from V1 to V2:
  - added patches 3-5

Thanks,
   --Mark
