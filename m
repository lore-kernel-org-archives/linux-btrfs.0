Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51488 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbbEKNi6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 09:38:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, fdmanana@gmail.com
Subject: [PATCH v3 0/3] dm error based test cases
Date: Mon, 11 May 2015 21:49:08 +0800
Message-Id: <1431352151-3117-1-git-send-email-anand.jain@oracle.com>
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

v2->v3: accepts Filipe Manana's review comments, thanks.
v1->v2: accepts Dave Chinner's review comments, thanks.

Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      |   69 +++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |   21 ++++++++++++++
 tests/btrfs/087     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/087.out |   10 ++++++
 tests/btrfs/088     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/088.out |   10 ++++++
 tests/btrfs/group   |    2 +
 7 files changed, 265 insertions(+), 0 deletions(-)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/087
 create mode 100644 tests/btrfs/087.out
 create mode 100755 tests/btrfs/088
 create mode 100644 tests/btrfs/088.out

