Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49257 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdKVJED (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:04:03 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 05/11] btrfs-progs: fsck-test: Introduce test case for false data extent backref lost
Date: Wed, 22 Nov 2017 17:03:19 +0800
Message-Id: <20171122090325.29458-6-wqu@suse.com>
In-Reply-To: <20171122090325.29458-1-wqu@suse.com>
References: <20171122090325.29458-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new test image, which has an extent item with no inlined
extent data ref, but all keyed extent data ref.

Only in this case we can trigger fase data extent backref lost bug in
lowmem mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../020-extent-ref-cases/keyed_data_ref_only.img         | Bin 0 -> 4096 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_only.img

diff --git a/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_only.img b/tests/fsck-tests/020-extent-ref-cases/keyed_data_ref_only.img
new file mode 100644
index 0000000000000000000000000000000000000000..668589f46d330cb5d6ff10b108e62585875548ca
GIT binary patch
literal 4096
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
PIdseYuX)P<UsnDL3U>9z

literal 0
HcmV?d00001

-- 
2.15.0

