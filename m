Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55818 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755806AbdKCI26 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 04:28:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 618BD48089C8
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Nov 2017 16:28:50 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 4/4] btrfs-progs: test: Add test image for lowmem mode referencer count mismatch false alert
Date: Fri, 3 Nov 2017 16:28:06 +0800
Message-ID: <20171103082806.22448-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
References: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a image which can reproduce the extent item referencer count
mismatch false alert for lowmem mode.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../ref_count_mismatch_false_alert.img                   | Bin 0 -> 4096 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/ref_count_mismatch_false_alert.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/ref_count_mismatch_false_alert.img b/tests/fsck-tests/020-extent-ref-cases/ref_count_mismatch_false_alert.img
new file mode 100644
index 0000000000000000000000000000000000000000..85110a813b5d00cb35d23babc70d57510cae19b0
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

-- 
2.15.0



