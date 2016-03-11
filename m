Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34167 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359AbcCKIJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 03:09:09 -0500
Date: Fri, 11 Mar 2016 11:08:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: scrub: silence an uninitialized variable warning
Message-ID: <20160311080856.GB31887@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's basically harmless if "ref_level" isn't initialized since it's only
used for an error message, but it causes a static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e42aa27..39dbdcb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -611,7 +611,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	u64 flags = 0;
 	u64 ref_root;
 	u32 item_size;
-	u8 ref_level;
+	u8 ref_level = 0;
 	int ret;
 
 	WARN_ON(sblock->page_count < 1);
