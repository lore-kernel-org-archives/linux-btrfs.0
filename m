Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbcBOUqP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 15:46:15 -0500
Subject: [PATCH v4.3 0/3] xfstests: minor fixes for the reflink/dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 15 Feb 2016 12:46:08 -0800
Message-ID: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a patch set against the reflink/dedupe test cases in xfstests.
All three patches fix some minor problems in the giant testcase merge
last weekend.

The zeroth patch ought to be Filipe Manana's patch ("fstests:
generic/158, test dedupe with destination offset past EOF") but as he
just resent that this morning, I won't repost it here.

The first patch, then, corrects the error output in the high offset
dedupe test (generic/304).

The second patch changes punch-alternating.c to use the filesystem
accounting block size to determine where to punch holes in the file
because that value is the internal filesystem block size.  This makes
the program behave as expected when testing with non-page-size block
sizes on XFS.

The third patch adds to _require_xfs_io_command the ability to check
that a subcommand supports a particular command line argument and adds
to xfs/24[356] the ability to check for the -c switch to the xfs_io
bmap command.

Comments and questions are, as always, welcome.  The fixes are
available on github[1].

--D

[1] https://github.com/djwong/xfstests/tree/for-dave
