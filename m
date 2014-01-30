Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62164 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaA3PYN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:13 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so1724914eak.14
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:12 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id 8sm18302170eef.1.2014.01.30.07.24.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:11 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 1/7] btrfs: tree_search: eliminate redundant nr_items check
Date: Thu, 30 Jan 2014 16:23:57 +0100
Message-Id: <1391095443-20287-2-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the amount of items reached the given limit of nr_items, we can leave
copy_to_sk without updating the key. Also by returning 1 we leave the loop in
search_ioctl without rechecking if we reached the given limit.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 34772cb..b1c5b4f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1892,7 +1892,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		if (sizeof(sh) + item_len + *sk_offset >
 		    BTRFS_SEARCH_ARGS_BUFSIZE) {
 			ret = 1;
-			goto overflow;
+			goto out;
 		}
 
 		sh.objectid = key->objectid;
@@ -1914,8 +1914,10 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 		}
 		(*num_found)++;
 
-		if (*num_found >= sk->nr_items)
-			break;
+		if (*num_found >= sk->nr_items) {
+			ret = 1;
+			goto out;
+		}
 	}
 advance_key:
 	ret = 0;
@@ -1930,7 +1932,7 @@ advance_key:
 		key->objectid++;
 	} else
 		ret = 1;
-overflow:
+out:
 	return ret;
 }
 
@@ -1982,7 +1984,7 @@ static noinline int search_ioctl(struct inode *inode,
 		ret = copy_to_sk(root, path, &key, sk, args->buf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
-		if (ret || num_found >= sk->nr_items)
+		if (ret)
 			break;
 
 	}
-- 
1.8.5.3

