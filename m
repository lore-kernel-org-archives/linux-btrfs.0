Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53341 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaISIw2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 04:52:28 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DBA213EE0BB
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:52:26 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id EDC56AC0A33
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:52:25 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8FBA71DB8037
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 17:52:25 +0900 (JST)
Message-ID: <541BEEC1.9030606@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 17:52:17 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 3/4] btrfs: export __btrfs_set_prop
References: <541BED3D.5020803@jp.fujitsu.com> <541BEDF8.7010009@jp.fujitsu.com>
In-Reply-To: <541BEDF8.7010009@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

Export __btrfs_set_prop() to be able to call it
with running transaction.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/props.c | 2 +-
 fs/btrfs/props.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 38efbe1..6f56f5b 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -99,7 +99,7 @@ find_prop_handler(const char *name,
 	return NULL;
 }
 
-static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
+int __btrfs_set_prop(struct btrfs_trans_handle *trans,
 			    struct inode *inode,
 			    const char *name,
 			    const char *value,
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 100f188..cff91e0 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -28,6 +28,12 @@ int btrfs_set_prop(struct inode *inode,
 		   const char *value,
 		   size_t value_len,
 		   int flags);
+int __btrfs_set_prop(struct btrfs_trans_handle *trans,
+			    struct inode *inode,
+			    const char *name,
+			    const char *value,
+			    size_t value_len,
+			    int flags);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
 
-- 1.8.3.1 

