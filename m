Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46305 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755782AbdKCI2v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:28:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EF44348089D4
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Nov 2017 16:28:48 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 1/4] btrfs-progs: test: Add test image for lowmem mode file extent interrupt
Date: Fri, 3 Nov 2017 16:28:03 +0800
Message-ID: <20171103082806.22448-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
References: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a image that the inlined extent coexist with the regular extent.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../020-extent-ref-cases/inline_regular_coexist.img      | Bin 0 -> 4096 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/inline_regular_coexist.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/inline_regular_coexist.img b/tests/fsck-tests/020-extent-ref-cases/inline_regular_coexist.img
new file mode 100644
index 0000000000000000000000000000000000000000..cf15cc14539f8759d18457d66b1f604244375b73
GIT binary patch
literal 4096
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
B^{)T`

literal 0
HcmV?d00001

-- 
2.15.0



