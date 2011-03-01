From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.38-rc6, patch] fix delayed_refs locking on error path...
Date: Wed, 2 Mar 2011 00:08:06 +0800
Message-ID: <AANLkTi=2r1pzBXiYjZifKrWFUXcUtNE3nBwspRM37DYx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Correctly unlock delayed_refs in the error case.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..c48d699 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2787,6 +2787,7 @@ static int btrfs_destroy_delayed_refs(struct
btrfs_transaction *trans,
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		printk(KERN_INFO "delayed_refs has NO entry\n");
+		spin_unlock(&delayed_refs->lock);
 		return ret;
 	}

-- 
Daniel J Blueman
