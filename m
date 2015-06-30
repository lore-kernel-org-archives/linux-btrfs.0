Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbF3EPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 00:15:32 -0400
Subject: [RFC 00/11] xfstests: test the btrfs/xfs reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 29 Jun 2015 21:15:20 -0700
Message-ID: <20150630041519.2476.23059.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is a RFC-quality pass at making xfstests perform more rigorous
testing of the btrfs/xfs file clone, reflink, and dedupe ioctls.
There are now tests of the basic functionality of the three ioctls;
tests to ensure that the filesystem exhibits the expected copy on
write semantics; tests to try to suss out race conditions in the new
write paths; tests to ensure that the ioctls peform basic disk
accounting correctly; tests of the interaction between reflink and the
various fallocate verbs (allocate, punch, collapse, insert zeroes);
and some attempts to test the upper limits of reflinking.  The first
patch in the series adds fuzz testing to ext4 and XFS; aside from
being first in line, it isn't tied to any of the reflink
functionality.

To run these tests, you'll have to patch xfsprogs to have reflink and
dedupe support[1]; the patch ought to apply fairly cleanly against the
upstream git.  They should more or less work with the btrfs that
appears in 4.1, though if you want to test the XFS implementation,
you're going to have to apply a lot of patches to the kernel and
xfsprogs.  See the cover letters[2][3] for those patchsets for more
information.

Known issues: 
 * I think the race checks for dedupe could be a little sharper at
   finding mistakes.
 * I started the numbering really high to prevent the tests from
   colliding with whatever new tests might arrive; this will require
   some intervention to fix.
 * When ext4 gains reflink support, it shouldn't be difficult to make
   these tests run on it.  The patch set is based on the current
   xfstest master on kernel.org.
 * If the copy_file_range syscall ever comes around, we'll have to
   adapt xfs_io to use that in addition to the btrfs ioctls.

Comments and questions are, as always, welcome.

--D

[1] http://djwong.org/docs/03-xfs_io-reflink-and-dedupe.patch
[2] See thread "[RFC 00/15] xfsprogs: support the reflink btree" dated today.
[3] http://oss.sgi.com/archives/xfs/2015-06/msg00407.html
