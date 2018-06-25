Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36807 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932089AbeFYLNY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 07:13:24 -0400
Date: Mon, 25 Jun 2018 13:10:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] Btrfs: fix file data corruptions due to lost
 dirty bits
Message-ID: <20180625111031.GA27958@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180620145612.1644763-1-clm@fb.com>
 <20180620193310.GG24375@twin.jikos.cz>
 <36F766B7-6388-4B93-A39F-A977F6F805D3@fb.com>
 <20180620202431.GH24375@suse.cz>
 <EFA3EBA7-D9B0-472E-8D70-96B756AE1677@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <EFA3EBA7-D9B0-472E-8D70-96B756AE1677@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 05:25:54PM -0400, Chris Mason wrote:
> The bug came here:
> 
> commit a528a24150870c5c16cbbbec69dba7e992b08456
> Author: Souptick Joarder <jrdr.linux@gmail.com>
> Date:   Wed Jun 6 19:54:44 2018 +0530
> 
>      btrfs: change return type of btrfs_page_mkwrite to vm_fault_t
> 
> When page->mapping != mapping, we improperly return success because ret2 
> is zero on goto out_unlock.
> 
> I'm running a fix through a full xfstests and I'll post soon.

The ret/ret2 pattern is IMO used in the wrong way, the ret2 is some
temporary value and it should be set and tested next to each other, not
holding the state accross the function.

The fix I'd propose is to avoid relying on it and add a separate exit
block, similar to out_noreserve:

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8981,7 +8981,6 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
                ret = VM_FAULT_SIGBUS;
                goto out_unlock;
        }
-       ret2 = 0;
 
        /* page is wholly or partially inside EOF */
        if (page_start + PAGE_SIZE > size)
@@ -9004,14 +9003,6 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
        BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 
        unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
-
-out_unlock:
-       if (!ret2) {
-               btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
-               sb_end_pagefault(inode->i_sb);
-               extent_changeset_free(data_reserved);
-               return VM_FAULT_LOCKED;
-       }
        unlock_page(page);
 out:
        btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
@@ -9021,6 +9012,12 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
        sb_end_pagefault(inode->i_sb);
        extent_changeset_free(data_reserved);
        return ret;
+
+out_unlock:
+       btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
+       sb_end_pagefault(inode->i_sb);
+       extent_changeset_free(data_reserved);
+       return VM_FAULT_LOCKED;
 }
 
 static int btrfs_truncate(struct inode *inode, bool skip_writeback)
