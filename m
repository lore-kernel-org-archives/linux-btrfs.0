From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] fs: make i_generation a u64
Date: Wed, 11 Apr 2012 16:42:48 -0400
Message-ID: <1334176968-8687-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs stores generation numbers as 64bit numbers, which means we have to
carry around a u64 in our incore inode in addition to setting i_generation.
So convert to a u64 so btrfs can kill it's incore generation.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9be896d..40564e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -831,7 +831,7 @@ struct inode {
 		struct cdev		*i_cdev;
 	};
 
-	__u32			i_generation;
+	u64			i_generation;
 
 #ifdef CONFIG_FSNOTIFY
 	__u32			i_fsnotify_mask; /* all events this inode cares about */
-- 
1.7.7.6

