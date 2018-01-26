Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2977 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752400AbeAZIa5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:57 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 5791D49F19BA
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:53 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 15/15] btrfs-progs: fsck-tests: add image for original and lowmem check
Date: Fri, 26 Jan 2018 16:35:19 +0800
Message-ID: <20180126083519.28373-16-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This image have two cases mixed:
1) Both filetypes of dir_item and dir_index about inode 258
   are corrupted.
2) inode item 258 is missing.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 .../029-mismatched-filetype-no-inode/default_case.img    | Bin 0 -> 3072 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/029-mismatched-filetype-no-inode/default_case.img

diff --git a/tests/fsck-tests/029-mismatched-filetype-no-inode/default_case.img b/tests/fsck-tests/029-mismatched-filetype-no-inode/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..57fc55b13c18bb9e5098a2fc4cb78f44fcf4abd9
GIT binary patch
literal 3072
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
HufV?n{Xac9

literal 0
HcmV?d00001

-- 
2.16.1



