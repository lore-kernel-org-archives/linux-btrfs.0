Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18527 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbbHNPcH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:32:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, eguan@redhat.com,
        fdmanana@gmail.com
Subject: [PATCH v6 0/3] dm error based test cases
Date: Fri, 14 Aug 2015 23:31:42 +0800
Message-Id: <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is v6 of this patch set. Mainly accepts Filipe latest review comments and Eryu's review comments with thanks.


Anand Jain (3):
  xfstests: btrfs: add functions to create dm-error device
  xfstests: btrfs: test device replace, with EIO on the src dev
  xfstests: btrfs: test device delete with EIO on src dev

 common/dmerror      | 69 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           | 16 +++++++++++
 tests/btrfs/098     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out | 11 +++++++
 tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/099.out | 11 +++++++
 tests/btrfs/group   |  2 ++
 7 files changed, 272 insertions(+)
 create mode 100644 common/dmerror
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out
 create mode 100755 tests/btrfs/099
 create mode 100644 tests/btrfs/099.out

-- 
2.4.1

