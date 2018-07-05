Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753015AbeGEFl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 01:41:28 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8C734AD5D
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 05:41:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: tests/fuzz: Use correct suffix for raw image
Date: Thu,  5 Jul 2018 13:41:24 +0800
Message-Id: <20180705054124.12137-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* Please fold this patch into original commit in devel branch *

It's raw image, so it should be ".raw.xz" not ".img.xz"

Fixes: 19154c230314 ("btrfs-progs: tests: add fuzzed image that triggers crash in reloc setup on mount")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ...mg.xz => bko-199833-reloc-recovery-crash.raw.xz} | Bin
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tests/fuzz-tests/images/{bko-199833-reloc-recovery-crash.img.xz => bko-199833-reloc-recovery-crash.raw.xz} (100%)

diff --git a/tests/fuzz-tests/images/bko-199833-reloc-recovery-crash.img.xz b/tests/fuzz-tests/images/bko-199833-reloc-recovery-crash.raw.xz
similarity index 100%
rename from tests/fuzz-tests/images/bko-199833-reloc-recovery-crash.img.xz
rename to tests/fuzz-tests/images/bko-199833-reloc-recovery-crash.raw.xz
-- 
2.18.0

