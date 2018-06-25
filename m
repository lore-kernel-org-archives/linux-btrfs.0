Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57526 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754918AbeFYRDx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 13:03:53 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w5PGx7tT023543
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 10:03:52 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ju3s004kw-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 10:03:52 -0700
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: [PATCH v2] Btrfs: fix regression in btrfs_page_mkwrite() from vm_fault_t conversion
Date: Mon, 25 Jun 2018 10:03:41 -0700
Message-ID: <20180625170341.101319-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The vm_fault_t conversion commit introduced a ret2 variable for tracking
the integer return values from internal btrfs functions.  It was
sometimes returning VM_FAULT_LOCKED for pages that were actually invalid
and had been removed from the radix.  Something like this:

    ret2 = btrfs_delalloc_reserve_space() // returns zero on success

    lock_page(page)
    if (page->mapping != inode->i_mapping)
	goto out_unlock;

...

out_unlock:
    if (!ret2) {
	    ...
	    return VM_FAULT_LOCKED;
    }

This ends up triggering this WARNING in btrfs_destroy_inode()
    WARN_ON(BTRFS_I(inode)->block_rsv.size);

xfstests generic/095 was able to reliably reproduce the errors.

Since out_unlock: is only used for errors, this fix moves it below the
if (!ret2) check we use to return VM_FAULT_LOCKED for success.

Fixes: a528a2415087 (btrfs: change return type of btrfs_page_mkwrite to vm_fault_t)
Signed-off-by: Chris Mason <clm@fb.com>
---

 Changes since v1: don't set the vmfault_t 'ret' to zero, just move our
 goto taret around around instead.

 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 193f933..63f713a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9036,13 +9036,14 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
-out_unlock:
 	if (!ret2) {
 		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
 		return VM_FAULT_LOCKED;
 	}
+
+out_unlock:
 	unlock_page(page);
 out:
 	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
-- 
2.9.5

