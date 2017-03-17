Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62794 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdCQCHx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 22:07:53 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <chris@colorremedies.com>
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: Add SHARED_DATA_REF test image for lowmem mode
Date: Fri, 17 Mar 2017 10:06:34 +0800
Message-ID: <20170317020634.29287-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170317020634.29287-1-quwenruo@cn.fujitsu.com>
References: <20170317020634.29287-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new image, which contains external SHARED_DATA_REF items to
trigger a lowmem mode false alert.

The image only contains external SHARED_DATA_REF and no inlined data
backref.

Before the image, we only have inlined shared data ref, which is not
enough to trigger lowmem mode false alert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .../020-extent-ref-cases/shared_data_ref_only.img        | Bin 0 -> 7168 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/shared_data_ref_only.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/shared_data_ref_only.img b/tests/fsck-tests/020-extent-ref-cases/shared_data_ref_only.img
new file mode 100644
index 0000000000000000000000000000000000000000..6d2b95e475188dba11fb4cd0996701e0a09bbf82
GIT binary patch
literal 7168
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
X^PEx6o#Z?pRS+XyBERDH|8w<!mO~C1

literal 0
HcmV?d00001

-- 
2.12.0



