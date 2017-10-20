Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34459 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdJTB7R (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 21:59:17 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/7] btrfs-progs: mkfs: Reword --rootdir
Date: Fri, 20 Oct 2017 09:59:00 +0800
Message-Id: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/mkfs_rootdir_rework

And fetching from github is preferred method to test, as this patchset
has 2 prerequisite:

1) Minimal device size patchset
   The image size estimate algorithm heavily relies on the minimal
   device size calculation

2) Rootdir refactor
   To make life a little easier.

Both the prerequisite has no further modification in this patchset, just the
version submitted to mail list, and rebased to v4.13.3 without any
conflict.

Rework 'mkfs.btrfs --rootdir' by:

1) Not using custom chunk allocator
   Use btrfs_alloc_chunk() only.
   Although currently chunk allocator in btrfs-progs is not small device
   friendly, which will try to allocate large chunk.
   This can be addressed by image size estimate algorithm, so it won't
   cause too much problem.
   (But still, it follow the minimal device size from normal mkfs, which
    is over 100M for default profile)

2) New image size estimate algorithm
   Use over-reserve-for-metadata method, which should ensure we can write
   all content into the image.
   And rely later shrink the shrink the fs size to minimal.

   Although the method itself is based on over-reserve, but in fact it's
   quite space efficient in most case.
   For empty file case, we will use the allocated data/meta space
   allocated in normal mkfs, so no shrink really needed.

   For large file and small metadata case, the size difference between
   shrunk and unshrunk image is less than 1%.

   Although due to the nature we over-reserve for metadata, for
   extremely unbalanced data/meta case, like tons of empty files, we
   really need to rely shrink functionality.

   And the algorithm itself only needs minimal amount of data.
   It only uses number of inodes and file size of each regular inode.

3) Shrinking the fs by device extent
   As implemented in almost all version of rework which includes
   shrinking, tried and true, and easier to implement.
   And shrinking is completely independent now, can be easily modified
   to shrink multi-device btrfs.

4) Separate shrink functionality to '--shrink' option
   This causes less confusion.
   And due to my poor English, I only added basic explanation to the
   mkfs doc. Although I think this is enough since each functionality
   is easier to understand.

5) Not wasting IO to wipe the whole image
   Only to wipe the first 1M and create sparse file.

Qu Wenruo (7):
  btrfs-progs: mkfs: Don't use custom chunk allocator for rootdir
  btrfs-progs: mkfs/rootdir: Use over-reserve method to make size
    estimate easier
  btrfs-progs: mkfs: Only zero out the first 1M for rootdir
  btrfs-progs: mkfs/rootdir: Introduce function to get end position of
    last device extent
  btrfs-progs: mkfs/rootdir: Shrink fs for rootdir option
  btrfs-progs: mkfs: Update allocation info before verbose output
  btrfs-progs: mkfs: Separate shrink from rootdir

 Documentation/mkfs.btrfs.asciidoc |  11 ++
 mkfs/main.c                       | 260 ++++++++++++++++-----------------
 mkfs/rootdir.c                    | 292 +++++++++++++++++++++++++++++++++-----
 mkfs/rootdir.h                    |   6 +-
 4 files changed, 400 insertions(+), 169 deletions(-)

-- 
2.14.2

