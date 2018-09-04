Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbeIDRGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Sep 2018 13:06:32 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F595AFCE
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Sep 2018 12:41:33 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Continue checking even we found something wrong in free space cache
Date: Tue,  4 Sep 2018 20:41:28 +0800
Message-Id: <20180904124128.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to abort checking, especially for RO check free space cache is
meaningless, the errors in fs/extent tree is more interesting for
developers.

So continue checking even something in free space cache is wrong.

Reported-by: Etienne Champetier <champetier.etienne@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index b361cd7e26a0..4f720163221e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
 			error("errors found in free space tree");
 		else
 			error("errors found in free space cache");
-		goto out;
 	}
 
 	/*
-- 
2.18.0
