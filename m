Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:57817 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934676AbdJQJNf (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:35 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 5/6] btrfs-progs: test/fsck: Add test case image for --fix-dev-size
Date: Tue, 17 Oct 2017 17:13:11 +0800
Message-Id: <20171017091312.31045-6-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo.btrfs@gmx.com>

The image has 2 problems mixed:

1) Too small super total_bytes
   This super total_bytes is manually modified to create such problem.

2) Unaligned dev item total_bytes
   This is created by v4.12 kernel, with 128M + 2K device added, and
   original device removed.
   Then we can create such image with unaligned dev item total_bytes.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 .../dev_and_super_mismatch_unaligned.raw.xz             | Bin 0 -> 21536 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz

diff --git a/tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz b/tests/fsck-tests/027-unaligned-super-dev-sizes/dev_and_super_mismatch_unaligned.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..153e514a89d5f50a7e6b4f9c3d3214896a4070cd
GIT binary patch
literal 21536
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

literal 0
HcmV?d00001

-- 
2.14.2

