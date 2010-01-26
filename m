From: Yang Hongyang <yanghy@cn.fujitsu.com>
Subject: [PATCH]btrfs:fix a memory leak in acl
Date: Tue, 26 Jan 2010 08:48:23 +0800
Message-ID: <4B5E3BD7.9000001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752217Ab0AZArN@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_init_acl(),cloned acl is not released.Fix that.

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>

---
 fs/btrfs/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 54f4798..6df6d6e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -244,6 +244,7 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 						    ACL_TYPE_ACCESS);
 			}
 		}
+		posix_acl_release(clone);
 	}
 failed:
 	posix_acl_release(acl);
-- 
1.6.5.2

-- 
Regards
Yang Hongyang
