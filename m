Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28622 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbaLYBeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:34:15 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1XjWY020161
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:33:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs-progs: Move btrfs-image dump to corresponding dir
Date: Thu, 25 Dec 2014 09:32:12 +0800
Message-ID: <1419471135-10878-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move these obvious btrfs-image to its corresponding dir to use the new
infrastructure.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 .../default_case.img}                                       | Bin
 10 files changed, 0 insertions(+), 0 deletions(-)
 rename tests/fsck-tests/{001-bad-file-extent-bytenr.img => 001-bad-file-extent-bytenr/default_case.img} (100%)
 rename tests/fsck-tests/{002-bad-transid.img => 002-bad-transid/default_case.img} (100%)
 rename tests/fsck-tests/{003-shift-offsets.img => 003-shift-offsets/default_case.img} (100%)
 rename tests/fsck-tests/{004-no-dir-index.img => 004-no-dir-index/default_case.img} (100%)
 rename tests/fsck-tests/{005-bad-item-offset.img => 005-bad-item-offset/default_case.img} (100%)
 rename tests/fsck-tests/{008-bad-offset-snapshots.img => 007-bad-offset-snapshots/default_case.img} (100%)
 rename tests/fsck-tests/{009-bad-dir-index-name.img => 008-bad-dir-index-name/default_case.img} (100%)
 rename tests/fsck-tests/{010-no-dir-item-or-index.img => 009-no-dir-item-or-index/default_case.img} (100%)
 rename tests/fsck-tests/{011-no-rootdir-inode-item.img => 010-no-rootdir-inode-item/default_case.img} (100%)
 rename tests/fsck-tests/{012-no-inode-item.img => 011-no-inode-item/default_case.img} (100%)

diff --git a/tests/fsck-tests/001-bad-file-extent-bytenr.img b/tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
similarity index 100%
rename from tests/fsck-tests/001-bad-file-extent-bytenr.img
rename to tests/fsck-tests/001-bad-file-extent-bytenr/default_case.img
diff --git a/tests/fsck-tests/002-bad-transid.img b/tests/fsck-tests/002-bad-transid/default_case.img
similarity index 100%
rename from tests/fsck-tests/002-bad-transid.img
rename to tests/fsck-tests/002-bad-transid/default_case.img
diff --git a/tests/fsck-tests/003-shift-offsets.img b/tests/fsck-tests/003-shift-offsets/default_case.img
similarity index 100%
rename from tests/fsck-tests/003-shift-offsets.img
rename to tests/fsck-tests/003-shift-offsets/default_case.img
diff --git a/tests/fsck-tests/004-no-dir-index.img b/tests/fsck-tests/004-no-dir-index/default_case.img
similarity index 100%
rename from tests/fsck-tests/004-no-dir-index.img
rename to tests/fsck-tests/004-no-dir-index/default_case.img
diff --git a/tests/fsck-tests/005-bad-item-offset.img b/tests/fsck-tests/005-bad-item-offset/default_case.img
similarity index 100%
rename from tests/fsck-tests/005-bad-item-offset.img
rename to tests/fsck-tests/005-bad-item-offset/default_case.img
diff --git a/tests/fsck-tests/008-bad-offset-snapshots.img b/tests/fsck-tests/007-bad-offset-snapshots/default_case.img
similarity index 100%
rename from tests/fsck-tests/008-bad-offset-snapshots.img
rename to tests/fsck-tests/007-bad-offset-snapshots/default_case.img
diff --git a/tests/fsck-tests/009-bad-dir-index-name.img b/tests/fsck-tests/008-bad-dir-index-name/default_case.img
similarity index 100%
rename from tests/fsck-tests/009-bad-dir-index-name.img
rename to tests/fsck-tests/008-bad-dir-index-name/default_case.img
diff --git a/tests/fsck-tests/010-no-dir-item-or-index.img b/tests/fsck-tests/009-no-dir-item-or-index/default_case.img
similarity index 100%
rename from tests/fsck-tests/010-no-dir-item-or-index.img
rename to tests/fsck-tests/009-no-dir-item-or-index/default_case.img
diff --git a/tests/fsck-tests/011-no-rootdir-inode-item.img b/tests/fsck-tests/010-no-rootdir-inode-item/default_case.img
similarity index 100%
rename from tests/fsck-tests/011-no-rootdir-inode-item.img
rename to tests/fsck-tests/010-no-rootdir-inode-item/default_case.img
diff --git a/tests/fsck-tests/012-no-inode-item.img b/tests/fsck-tests/011-no-inode-item/default_case.img
similarity index 100%
rename from tests/fsck-tests/012-no-inode-item.img
rename to tests/fsck-tests/011-no-inode-item/default_case.img
-- 
2.2.1

