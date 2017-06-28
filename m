Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750934AbdF1Gtw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 02:49:52 -0400
Subject: Re: [PULL] Btrfs for 4.13, part 1
To: David Sterba <dsterba@suse.com>, clm@fb.com
Cc: linux-btrfs@vger.kernel.org
References: <cover.1498229425.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1ad1fcee-d7de-452d-3e9f-a87fe5d6117e@suse.com>
Date: Wed, 28 Jun 2017 09:49:49 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1498229425.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.06.2017 18:16, David Sterba wrote:
> Hi,
> 
> this is the main batch for 4.13. There are some user visible changes, see
> below. The core updates improve error handling (mostly related to bios), with
> the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
> been in for-next for an extensive amount of time.
> 
> Thre will be followups but I want push the series (111 patches) forward. There
> are also some updates to adjacent subsystems (writeback and blocklayer), so I
> want to give some stable point for merging in the upcoming weeks.
> 
> User visible changes:
> * quota override tunable
> * improved compression thresholds
> * statx support
> * obsoleted mount option alloc_start
> 
> Core updates:
> * bio-related updates
>   - faster bio cloning
>   - no allocation failures
>   - preallocated flush bios
> * more kvzalloc use, memalloc_nofs protections, GFP_NOFS updates
> * prep work for btree_inode removal
> * dir-item validation
> * qgoup fixes and updates
> * cleanups
>   - removed unused struct members, unused code, refactoring
>   - argument refactoring (fs_info/root, caller -> callee sink)
>   - SEARCH_TREE docs
> 
> ----------------------------------------------------------------
> The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:
> 
>   Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part1
> 
> for you to fetch changes up to f3f000297be88b1b75fde5027d660a8d8a44de14:
> 
>   btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges (2017-06-21 20:56:14 +0200)
> 

Dave I run bisection of all failures between -rc6 and your 
pull request and here are the results: 

btrfs/048 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
btrfs/053 - b780e22768d3 ("btrfs: fix validation of XATTR_ITEM dir items")
generic/273 - 28785f70ef88 ("Btrfs: skip commit transaction if we don't have enough pinned bytes")
generic/337 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")
shared/002 - e79a33270d05 ("btrfs: Check name_len with boundary in verify dir_item")

So those are tests which are failing as a direct of 
the listed patches. 
