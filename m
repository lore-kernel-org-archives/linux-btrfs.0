Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15502 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751821AbdI0Gbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 02:31:48 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B42CD47CAAD7
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:31:42 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: fsck-tests: 027/bad_extent_inline_ref_type
Date: Wed, 27 Sep 2017 14:34:40 +0800
Message-ID: <20170927063440.25961-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This case is for avoiding crash in lowmem check mode.
Field type of extent_inline_ref in an extent is corrupted.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../bad-extent-inline-ref-type.raw.xz                   | Bin 0 -> 17144 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/027-bad-extent-inline-ref-type/bad-extent-inline-ref-type.raw.xz

diff --git a/tests/fsck-tests/027-bad-extent-inline-ref-type/bad-extent-inline-ref-type.raw.xz b/tests/fsck-tests/027-bad-extent-inline-ref-type/bad-extent-inline-ref-type.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..09d820196b11a88557b4cb92b5b3533e80eb5d14
GIT binary patch
literal 17144
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

literal 0
HcmV?d00001

-- 
2.14.1



