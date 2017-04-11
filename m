Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33068 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752497AbdDKDZU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B69D047CE240
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:06 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: fsck-check: test cases for nbytes and dir isize
Date: Tue, 11 Apr 2017 11:26:31 +0800
Message-ID: <20170411032631.24932-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create test case '026-wrong-dir-inode-isize'.
Create becon files '.lowmem_repairable' under tests/fsck-test/016 and 026.

Now 'make test-fsck' will test lowmem repairable test cases if
TEST_ENABLE_OVERRIDE=true.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable |   0
 .../026-wrong-dir-inode-isize/.lowmem_repairable         |   0
 .../026-wrong-dir-inode-isize/default_case.img           | Bin 0 -> 4096 bytes
 3 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
 create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/.lowmem_repairable
 create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/default_case.img

diff --git a/tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable b/tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/026-wrong-dir-inode-isize/.lowmem_repairable b/tests/fsck-tests/026-wrong-dir-inode-isize/.lowmem_repairable
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/fsck-tests/026-wrong-dir-inode-isize/default_case.img b/tests/fsck-tests/026-wrong-dir-inode-isize/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..a060cca86e945f2659595d812b3017c66c570d5e
GIT binary patch
literal 4096
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
R>`I?{{<B2?R{Os>@NZR9TeJWG

literal 0
HcmV?d00001

-- 
2.12.0



