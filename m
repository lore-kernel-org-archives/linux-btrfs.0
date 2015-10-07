Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40602 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbJGFND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 01:13:03 -0400
Subject: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Anna.Schumaker@netapp.com, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Tue, 06 Oct 2015 22:12:57 -0700
Message-ID: <20151007051257.3260.73072.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is part of the third revision of an RFC for adding to XFS support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.

This patchset aims to make xfstests perform more rigorous testing of
the btrfs/XFS file clone, reflink, and dedupe ioctls.  There are now
tests of the basic functionality of the three ioctls; tests to ensure
that the filesystem exhibits the expected copy on write semantics;
tests to try to suss out race conditions in the new write paths; tests
to ensure that the ioctls peform basic disk accounting correctly;
tests of the interaction between reflink and the various fallocate
verbs (allocate, punch, collapse, insert zeroes); and some attempts to
test the upper limits of reflinking and ENOSPC behavior.  The tests
have been totally rewritten since the last posting to drop FIEMAP
usage; this should enable the tests to cover NFS and CIFS.

Issues: 

 * I think the race checks for dedupe could be a little sharper at
   finding mistakes.

 * I started the numbering really high to prevent the tests from
   colliding with whatever new tests might arrive; this will require
   some intervention to fix.

 * I don't have any interesting NFS/CIFS setups for test. :(

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
They should just work with the btrfs that's in 4.3.

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux-xfs-dev/commits/master
[2] https://github.com/djwong/xfsprogs/commits/for-next
[3] https://github.com/djwong/xfstests/commits/master
