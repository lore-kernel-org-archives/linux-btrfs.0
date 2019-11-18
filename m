Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BA7C43215
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D27EC20727
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfKRGbB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 01:31:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:38342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbfKRGbB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 01:31:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89B5EB256;
        Mon, 18 Nov 2019 06:30:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     osandov@osandov.com
Subject: [PATCH 1/4] btrfs-progs: check/lowmem: Fix a false alert on uninitialized value
Date:   Mon, 18 Nov 2019 14:30:49 +0800
Message-Id: <20191118063052.56970-2-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191118063052.56970-1-wqu@suse.com>
References: <20191118063052.56970-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When compiling the devel branch with commit fb8f05e40b458
("btrfs-progs: check: Make repair_imode_common() handle inodes in
subvolume trees"), the following warning will be reported:

  check/mode-common.c: In function ‘detect_imode’:
  check/mode-common.c|1071 col 23| warning: ‘imode’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  1071 |   *imode_ret = (imode | 0700);
       |                ~~~~~~~^~~~~~~

This only occurs for regular build. If compiled with D=1, the warning
just disappears.

[CAUSE]
Looks like a bug in gcc optimization.
The code will only set @imode_ret when @found is true.
And for every "found = true" assignment we have assigned @imode.
So this is just a false alert.

[FIX]
I hope I can fix the problem of GCC, but obviously I can't (at least for
now).

So let's assign an initial value 0 to @imode to suppress the false
alert.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index 10ad6d228a03..9e81082b10aa 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -972,7 +972,7 @@ int detect_imode(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_inode_item iitem;
 	bool found = false;
 	u64 ino;
-	u32 imode;
+	u32 imode = 0;
 	int ret = 0;
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-- 
2.24.0

