From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 1/6] btrfs: Fix bugs in zlib workspace
Date: Thu, 18 Nov 2010 10:09:32 +0800
Message-ID: <4CE48ADC.6070001@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE48ABB.5070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

- Fix a race that can result in alloc_workspace > cpus.
- Fix to check num_workspace after wakeup.

Tested-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/zlib.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index b9cd544..e5b8b22 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -75,16 +75,19 @@ again:
 		return workspace;
 
 	}
-	spin_unlock(&workspace_lock);
 	if (atomic_read(&alloc_workspace) > cpus) {
 		DEFINE_WAIT(wait);
+
+		spin_unlock(&workspace_lock);
 		prepare_to_wait(&workspace_wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&alloc_workspace) > cpus)
+		if (atomic_read(&alloc_workspace) > cpus && !num_workspace)
 			schedule();
 		finish_wait(&workspace_wait, &wait);
 		goto again;
 	}
 	atomic_inc(&alloc_workspace);
+	spin_unlock(&workspace_lock);
+
 	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
 	if (!workspace) {
 		ret = -ENOMEM;
-- 1.7.3.1 
