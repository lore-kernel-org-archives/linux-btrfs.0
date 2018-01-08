Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755418AbeAHTFN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:05:13 -0500
Date: Mon, 8 Jan 2018 20:03:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: check: record last checked root_item in
 original mode
Message-ID: <20180108190304.GJ13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
 <20171121101524.2014-3-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171121101524.2014-3-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 06:15:24PM +0800, Su Yue wrote:
> check_fs_roots() will check all fs trees again if fs_info->tree_root
> have been cowed.
> It is inefficient if there are many subvolumes in filesystem.
> 
> And it also causes dead loop while repairing
> fuzz-tests/images/bko-161811.raw:
> =============================
> ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283096 have 709597396
> invalid location in dir item 0
> root 5 root dir 256 error
> root 5 inode 256 errors 10, odd dir item
> Failed to reset nlink for inode 18446744073709551361: No such file or directory
>         unresolved ref dir 256 index 0 namelen 32 name  filetype 1 errors 106, no dir index, no inode ref, name too long
> ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283096 have 709597396
> invalid location in dir item 0
> root 5 root dir 256 error
> root 5 inode 256 errors 10, odd dir item
> Failed to reset nlink for inode 18446744073709551361: No such file or directory
>         unresolved ref dir 256 index 0 namelen 32 name  filetype 1 errors 106, no dir index, no inode ref, name too long
> ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283
> ...
> ==============================
> 
> Process of the dead loop:
> 1) check_fs_root() failed to repair the inode.
> 2) btrfs_commit_transaction() did cow of the fs_info->tree_root
> 3) check_fs_roots() restarted to check fs tree.
> 4) goto 1).
> 
> Introduce a variable @prev_key to record last checked root_item.
> If check_fs_root() failed, go to check the next fs_tree instead of
> trying it again and again.

Patch looks good to me, do you have a test image?
