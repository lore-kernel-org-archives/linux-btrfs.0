Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48202 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934677AbdJQJNf (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 17 Oct 2017 05:13:35 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 6/6] btrfs-progs: rescue: Fix zero-log mounted branch
Date: Tue, 17 Oct 2017 17:13:12 +0800
Message-Id: <20171017091312.31045-7-wqu@suse.com>
In-Reply-To: <20171017091312.31045-1-wqu@suse.com>
References: <20171017091312.31045-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seems to be a typo that, in (ret > 0) branch of check_mounted(),
zero-log set the return value but doesn't return.

Fix it by adding back the missing return.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-rescue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index 5b51952cdc10..c40088ad374e 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -178,6 +178,7 @@ static int cmd_rescue_zero_log(int argc, char **argv)
 	} else if (ret) {
 		error("%s is currently mounted", devname);
 		ret = -EBUSY;
+		goto out;
 	}
 
 	root = open_ctree(devname, 0, OPEN_CTREE_WRITES | OPEN_CTREE_PARTIAL);
-- 
2.14.2

