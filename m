Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbbJZGGU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 02:06:20 -0400
Date: Mon, 26 Oct 2015 15:06:19 +0900 (KST)
From: Jiri Kosina <jikos@kernel.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: clear PF_NOFREEZE in cleaner_kthread()
Message-ID: <alpine.LNX.2.00.1510261458070.8998@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jiri Kosina <jkosina@suse.cz>

cleaner_kthread() kthread calls try_to_freeze() at the beginning of every 
cleanup attempt. This operation can't ever succeed though, as the kthread 
hasn't marked itself as freezable.

Before (hopefully eventually) kthread freezing gets converted to fileystem 
freezing, we'd rather mark cleaner_kthread() freezable (as my 
understanding is that it can generate filesystem I/O during suspend).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 295795a..173970d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1759,6 +1759,7 @@ static int cleaner_kthread(void *arg)
 	int again;
 	struct btrfs_trans_handle *trans;
 
+	set_freezable();
 	do {
 		again = 0;
 
-- 
Jiri Kosina
SUSE Labs

