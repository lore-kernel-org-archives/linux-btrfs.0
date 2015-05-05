Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbbEFDFr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 23:05:47 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v2 0/3] dm error based test cases
Date: Wed,  6 May 2015 03:03:16 +0800
Message-Id: <1430852599-22724-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most likely user would replace or delete the device when
there is a problem about it.

We want to test this condition by using the dm error target which
will help to create the EIO when needed.
Basically first create the linear device and then load the error
table to get the EIO when needed.

The fist patch will provide the helper dm functions to create such
a test case using dm error device.

2nd and 3rd patch uses it to test the device replace and delete,
respectively. Note that device delete will need kernel and progs
patch, which when not there tests will gracefully fail and 
will not run respectively.

v1->v2: accepts Dave Chinner's review comments, thanks.

Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc           | 21 ++++++++++++++++
 tests/btrfs/087     | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/087.out |  2 ++
 tests/btrfs/088     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/088.out |  2 ++
 tests/btrfs/group   |  2 ++
 7 files changed, 237 insertions(+)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/087
 create mode 100644 tests/btrfs/087.out
 create mode 100755 tests/btrfs/088
 create mode 100644 tests/btrfs/088.out

-- 
2.0.0.153.g79dcccc

