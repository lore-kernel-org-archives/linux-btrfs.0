Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57338 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752222AbeBHDXc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:32 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 9233448AE769
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:24 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 18/18] btrfs-progs: fsck-tests: add image no extent with normal device size
Date: Thu, 8 Feb 2018 11:27:37 +0800
Message-ID: <20180208032737.31561-19-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new image only misses one extent which leads lowmem mode to
allocate new chunk in repair.
Original image renamed to no_extent_bad_dev.img should let lowmem mode
exclude blocks in repair.

Due to problems of btrfs-image, choose xz as compression tool.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 tests/fsck-tests/014-no-extent-info/.lowmem_repairable  |   0
 tests/fsck-tests/014-no-extent-info/no_extent.raw.xz    | Bin 0 -> 28084 bytes
 .../{default_case.img => no_extent_bad_dev.img}         | Bin
 3 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/014-no-extent-info/.lowmem_repairable
 create mode 100644 tests/fsck-tests/014-no-extent-info/no_extent.raw.xz
 rename tests/fsck-tests/014-no-extent-info/{default_case.img => no_extent_bad_dev.img} (100%)

diff --git a/tests/fsck-tests/014-no-extent-info/.lowmem_repairable b/tests/fsck-tests/014-no-extent-info/.lowmem_repairable
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/fsck-tests/014-no-extent-info/no_extent.raw.xz b/tests/fsck-tests/014-no-extent-info/no_extent.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..6e568a9cf1f0a1d1bcd00222b07cf14d3c09afc5
GIT binary patch
literal 28084
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

literal 0
HcmV?d00001

diff --git a/tests/fsck-tests/014-no-extent-info/default_case.img b/tests/fsck-tests/014-no-extent-info/no_extent_bad_dev.img
similarity index 100%
rename from tests/fsck-tests/014-no-extent-info/default_case.img
rename to tests/fsck-tests/014-no-extent-info/no_extent_bad_dev.img
-- 
2.16.1



