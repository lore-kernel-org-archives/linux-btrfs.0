Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:34284 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750773AbdHRHE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 03:04:26 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Piotr Szymaniak <szarpaj@grubelek.pl>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/2] Reset the ret value when ignore an error from du_add_file()
Date: Fri, 18 Aug 2017 09:04:20 +0200
Message-Id: <20170818070421.2696-2-kreijack@libero.it>
In-Reply-To: <20170818070421.2696-1-kreijack@libero.it>
References: <20170818070421.2696-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

In du_walk_dir(), when du_add_file() returns an error it is
usually ignored. However if the error is returned querying
the last item, the error is returned to the caller.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-fi-du.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index f106f45b..4bf6af3e 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -403,6 +403,7 @@ static int du_walk_dir(struct du_dir_ctxt *ctxt, struct rb_root *shared_extents)
 						  shared_extents, &tot, &shr,
 						  0);
 				if (ret == -ENOTTY) {
+					ret = 0;
 					continue;
 				} else if (ret) {
 					fprintf(stderr,
-- 
2.14.1

