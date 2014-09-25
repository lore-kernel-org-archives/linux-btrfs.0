Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34703 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaIYFzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 01:55:48 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DB54A3EE113
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 14:55:46 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id E5720AC0546
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 14:55:45 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 620101DB8038
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 14:55:45 +0900 (JST)
Message-ID: <5423AE51.8060701@jp.fujitsu.com>
Date: Thu, 25 Sep 2014 14:55:29 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 3/4] btrfs: Rename and export __btrfs_set_prop to be called
 from running transaction
References: <541BED3D.5020803@jp.fujitsu.com> <541BEDF8.7010009@jp.fujitsu.com> <541BEEC1.9030606@jp.fujitsu.com> <20140922120119.GK9715@twin.jikos.cz>
In-Reply-To: <20140922120119.GK9715@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

(2014/09/22 21:01), David Sterba wrote:
> On Fri, Sep 19, 2014 at 05:52:17PM +0900, Satoru Takeuchi wrote:
>> @@ -99,7 +99,7 @@ find_prop_handler(const char *name,
>>   	return NULL;
>>   }
>>
>> -static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>> +int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>
> It's common for static helpers to use the __ prefix, but please drop it
> for an exported function(s).

Sorry for the late reply. Here is the v2 patch.
Please take alook at it.

---
From: Naohiro Aota <naota@elisp.net>

Since "__" prefix means static helper, rename __btrfs_set_prop() to
btrfs_set_prop_trans.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
changelog
	v1->v2: Reflect the following comment from David.
         https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg37513.html
---
  fs/btrfs/props.c | 6 +++---
  fs/btrfs/props.h | 7 +++++++
  2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 38efbe1..bba081a 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -99,7 +99,7 @@ find_prop_handler(const char *name,
  	return NULL;
  }
  
-static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
+int btrfs_set_prop_trans(struct btrfs_trans_handle *trans,
  			    struct inode *inode,
  			    const char *name,
  			    const char *value,
@@ -153,7 +153,7 @@ int btrfs_set_prop(struct inode *inode,
  		   size_t value_len,
  		   int flags)
  {
-	return __btrfs_set_prop(NULL, inode, name, value, value_len, flags);
+	return btrfs_set_prop_trans(NULL, inode, name, value, value_len, flags);
  }
  
  static int iterate_object_props(struct btrfs_root *root,
@@ -325,7 +325,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
  					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
  		if (ret)
  			goto out;
-		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
+		ret = btrfs_set_prop_trans(trans, inode, h->xattr_name,
  				       value, strlen(value), 0);
  		btrfs_block_rsv_release(root, trans->block_rsv, num_bytes);
  		if (ret)
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 100f188..dcbccf9 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -29,6 +29,13 @@ int btrfs_set_prop(struct inode *inode,
  		   size_t value_len,
  		   int flags);
  
+int btrfs_set_prop_trans(struct btrfs_trans_handle *trans,
+			    struct inode *inode,
+			    const char *name,
+			    const char *value,
+			    size_t value_len,
+			    int flags);
+
  int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
  
  int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
-- 1.8.3.1

