Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60909 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750989AbdBFFrt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:47:49 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 07/12] btrfs-progs: tests: Move fsck-tests/015 to fuzz tests
Date: Mon, 6 Feb 2017 13:47:30 +0800
Message-ID: <20170206054735.5227-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test case fsck-tests/015-check-bad-memory-access can't be repair by
btrfs check, and it's a fortunate bug makes original mode to forget the
error code from extent tree, making original mode pass it.

So fuzz-tests is more suitable for it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../images}/bko-97171-btrfs-image.raw.txt                   |   0
 .../images}/bko-97171-btrfs-image.raw.xz                    | Bin
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.txt (100%)
 rename tests/{fsck-tests/015-check-bad-memory-access => fuzz-tests/images}/bko-97171-btrfs-image.raw.xz (100%)

diff --git a/tests/fsck-tests/015-check-bad-memory-access/bko-97171-btrfs-image.raw.txt b/tests/fuzz-tests/images/bko-97171-btrfs-image.raw.txt
similarity index 100%
rename from tests/fsck-tests/015-check-bad-memory-access/bko-97171-btrfs-image.raw.txt
rename to tests/fuzz-tests/images/bko-97171-btrfs-image.raw.txt
diff --git a/tests/fsck-tests/015-check-bad-memory-access/bko-97171-btrfs-image.raw.xz b/tests/fuzz-tests/images/bko-97171-btrfs-image.raw.xz
similarity index 100%
rename from tests/fsck-tests/015-check-bad-memory-access/bko-97171-btrfs-image.raw.xz
rename to tests/fuzz-tests/images/bko-97171-btrfs-image.raw.xz
-- 
2.11.0



