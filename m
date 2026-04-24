Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E26388E6D;
	Fri, 24 Apr 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777039935; cv=none; b=Bm7NcKv5ee5OF7pqdP8zCdiDML3097pyvbZ8ZRalA7h4BPrHNGCtu+z9nz9YgSlJrWNIFcqVr0oXJOZ1llK2GE2qzEZkMrTAg9QrHKvl6863DBsI9QnEPJPaLvhL9vh7x2KzKzbb02vYlikJepzjsEx9AwG7GS9sLU3/vX8olco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777039935; c=relaxed/simple;
	bh=u9/Wkb63jLF+zcVALWLBvUNFpcIo9WMQy4jJcb9m8Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ch5VS1CR7Ohhw4dWxWlEh9YVKhpJ+fLD14ipGuiBZUJANo827akIAmLDUxm4uGN6I5SvbNQZd1k1WXYw8aA93rRR1z3VsyrqZ9XEd2bzS5cLN25V+CnuzVxomyjULtGGhaQ38F+0dApDVYjccYwRYNOLRoN+KedJAczEtTiHIeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFlZAiWI; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFlZAiWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777039934; x=1808575934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u9/Wkb63jLF+zcVALWLBvUNFpcIo9WMQy4jJcb9m8Lc=;
  b=oFlZAiWIZvgNdBmUBGqc5vyJUglVj/khrS4U7+KPkxSsEmtXakcVV9bZ
   uOV+zNFDRFoQVN9+LmNdhKV3f5KMg/zXV97f9TXMVRaU4xXo45g6DT1XD
   H73c2BQZUDi+l7COwGcxUALMUiiddjTCw0xUOc+Y12tH+aXDkoOjJiSuM
   YEti51sxC1rAMg3hsx/x2tUtPHk8FBbqB/8iifpC0iRyqyNRoeahiWiW5
   rkxF3CNbor1ZpW/VDXv83M9bIiilMjMTVVp+zbdLiMu9as3MSaoc9uIy9
   Q8Pvo82dlyiBsvNBG7RiIGC4muGDxA7mCTEgy9P9D8wNhxg9ZHasf12Ep
   A==;
X-CSE-ConnectionGUID: DalDazAzSr6/VEEvrORtjw==
X-CSE-MsgGUID: H5KtCOxrR0a4MQ/qYWYXPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="88718845"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="88718845"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 07:12:13 -0700
X-CSE-ConnectionGUID: DfCLTN4jSdiziRd3gnLTYg==
X-CSE-MsgGUID: IKAJ4xP/Qnao3zvYk9NkSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="234753175"
Received: from arjan-box.jf.intel.com ([10.88.27.153])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 07:12:13 -0700
From: arjan@linux.intel.com
To: linux-btrfs@vger.kernel.org
Cc: syzbot+768687d6d7c96a124e24@syzkaller.appspotmail.com,
	clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [syzbot] [btrfs?] WARNING in __btrfs_update_delayed_inode (4)
Date: Fri, 24 Apr 2026 07:13:28 -0700
Message-ID: <20260424141331.331289-1-arjan@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <69eb21b8.a00a0220.17a17.0056.GAE@google.com>
References: <69eb21b8.a00a0220.17a17.0056.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arjan van de Ven <arjan@linux.intel.com>

On Fri, 24 Apr 2026 00:54:32 -0700
syzbot <syzbot+768687d6d7c96a124e24@syzkaller.appspotmail.com> wrote:

> WARNING: fs/btrfs/delayed-inode.c:1027 at
> __btrfs_update_delayed_inode+0xe3d/0x1070

Analyzed this WARNING; here are the findings.

Decoded backtrace source listings
----------------------------------

--- __btrfs_update_delayed_inode (crash site, fs/btrfs/delayed-inode.c:1027) ---

  996 static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
  997                                         struct btrfs_root *root,
  998                                         struct btrfs_path *path,
  999                                         struct btrfs_delayed_node *node)
 1000 {
 1001     struct btrfs_fs_info *fs_info = root->fs_info;
 1002     struct btrfs_key key;
 1003     struct btrfs_inode_item *inode_item;
 1004     struct extent_buffer *leaf;
 1005     int mod;
 1006     int ret;
      ...
 1012     if (test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &node->flags))
 1013         mod = -1;
 1014     else
 1015         mod = 1;
 1016
 1017     ret = btrfs_lookup_inode(trans, root, path, &key, mod);  // returns -28 (-ENOSPC)
 1018     if (ret > 0)
 1019         ret = -ENOENT;
 1020     if (ret < 0) {
 1021         /*
 1022          * If we fail to update the delayed inode we need to abort the
 1023          * transaction, because we could leave the inode with the
 1024          * improper counts behind.
 1025          */
 1026         if (unlikely(ret != -ENOENT))
 1027             btrfs_abort_transaction(trans, ret);  // <- WARNING fires here
 1028         goto out;
 1029     }
      ...
 1088 }

--- btrfs_update_delayed_inode (inlined, fs/btrfs/delayed-inode.c:1103) ---

 1090 static inline int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 1091                                              struct btrfs_root *root,
 1092                                              struct btrfs_path *path,
 1093                                              struct btrfs_delayed_node *node)
 1094 {
 1095     int ret;
 1096
 1097     mutex_lock(&node->mutex);
 1098     if (!test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &node->flags)) {
 1099         mutex_unlock(&node->mutex);
 1100         return 0;
 1101     }
 1102
 1103     ret = __btrfs_update_delayed_inode(trans, root, path, node);  // <- call here
 1104     mutex_unlock(&node->mutex);
 1105     return ret;
 1106 }

--- __btrfs_commit_inode_delayed_items (fs/btrfs/delayed-inode.c:1127) ---

 1108 static inline int
 1109 __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 1110                                    struct btrfs_path *path,
 1111                                    struct btrfs_delayed_node *node)
 1112 {
 1113     int ret;
 1114
 1115     ret = btrfs_insert_delayed_items(trans, path, node->root, node);
 1116     if (ret)
 1117         return ret;
 1118
 1119     ret = btrfs_delete_delayed_items(trans, path, node->root, node);
 1120     if (ret)
 1121         return ret;
 1122
 1123     ret = btrfs_record_root_in_trans(trans, node->root);
 1124     if (ret)
 1125         return ret;
 1126
 1127     return btrfs_update_delayed_inode(trans, node->root, path, node);  // <- call here
 1128 }

--- __btrfs_run_delayed_items (fs/btrfs/delayed-inode.c:1158) ---

 1136 static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans, int nr)
 1137 {
 1138     struct btrfs_fs_info *fs_info = trans->fs_info;
      ...
 1141     struct btrfs_path *path;
 1142     struct btrfs_block_rsv *block_rsv;
      ...
 1149     path = btrfs_alloc_path();
      ...
 1153     block_rsv = trans->block_rsv;
 1154     trans->block_rsv = &fs_info->delayed_block_rsv;  // RSV switched to delayed_block_rsv
 1155
 1156     curr_node = btrfs_first_delayed_node(fs_info, &curr_delayed_node_tracker);
 1157     while (curr_node && (!count || nr--)) {
 1158         ret = __btrfs_commit_inode_delayed_items(trans, path,  // <- call here
 1159                                                  curr_node);
 1160         if (unlikely(ret)) {
 1161             btrfs_abort_transaction(trans, ret);
 1162             break;
 1163         }
      ...

The WARN() fires inside the btrfs_abort_transaction macro when
btrfs_lookup_inode() returns -ENOSPC (-28) in
__btrfs_update_delayed_inode. The macro calls
btrfs_abort_should_print_stack(-28), which returns true because -ENOSPC
is not in the exception list (-EIO, -EROFS, -ENOMEM). This causes the
WARN() to fire and print the stack trace.

The root cause is a circular ENOSPC condition: the async data-space
reclaim path commits a transaction to free data space, but that
transaction commit needs metadata space for B-tree copy-on-write
operations (allocated from delayed_block_rsv). When both data and
metadata space are critically low, btrfs_search_slot fails with
-ENOSPC even for the deletion COW path.

The transaction abort is correct behavior for this failure. The issue
is that -ENOSPC is not an exceptional/unexpected error in this context
— it is a predictable outcome under severe space pressure — yet
btrfs_abort_should_print_stack() treats it as unexpected and fires
WARN().

Proposed fix: add -ENOSPC to the exception list in
btrfs_abort_should_print_stack() in fs/btrfs/transaction.h:

  --- a/fs/btrfs/transaction.h
  +++ b/fs/btrfs/transaction.h
  @@ -236,6 +236,7 @@ static inline bool btrfs_abort_should_print_stack(int error)
   	switch (error) {
   	case -EIO:
   	case -EROFS:
  +	case -ENOSPC:
   	case -ENOMEM:
   		return false;
   	}

This matches the intent of the list (errors that are expected/normal
filesystem conditions, not programming errors). The transaction is
still aborted correctly via __btrfs_abort_transaction(); only the
spurious stack-printing WARN() is suppressed.

A deeper fix would ensure delayed_block_rsv has sufficient reservation
to avoid the ENOSPC in the first place, but that is a harder problem
touching btrfs space-reservation accounting.

Full analysis at:
http://oops.fenrus.org/reports/lkml/69eb21b8.a00a0220.17a17.0056.GAE_google.com/report.md

Arjan van de Ven
