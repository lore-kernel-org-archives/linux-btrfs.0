Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:52450 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3DJLXV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 07:23:21 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so173171dak.6
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 04:23:20 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, list.btrfs@jan-o-sch.net
Subject: [PATCH 1/2] Btrfs: remove some BUG_ONs() when walking backref tree
Date: Wed, 10 Apr 2013 19:22:50 +0800
Message-Id: <1365592971-1535-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
References: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The only error return value of __add_prelim_ref() is -ENOMEM,
just return errors rather than trigger BUG_ON().

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..dc200f6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -582,7 +582,8 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		default:
 			WARN_ON(1);
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -680,7 +681,8 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 		default:
 			WARN_ON(1);
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ptr += btrfs_extent_inline_ref_size(type);
 	}
 
@@ -762,7 +764,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 		default:
 			WARN_ON(1);
 		}
-		BUG_ON(ret);
+		if (ret)
+			return ret;
+
 	}
 
 	return ret;
-- 
1.7.7.6

