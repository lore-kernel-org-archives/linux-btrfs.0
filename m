Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdEBOau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 10:30:50 -0400
Date: Tue, 2 May 2017 16:30:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix fuzz-test for bko-161821.raw.txt
Message-ID: <20170502143043.GI23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170502073609.23559-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502073609.23559-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 03:36:09PM +0800, Lu Fengqi wrote:
> Fuzzed image bko-161821.raw cause btrfs check to get segmentation fault.
> 
> The function check_owner_ref attempts to access a non-exist quota tree
> when dealing with extent_item [4198400 4096] in the corrupted filesystem.
> 
> The function btrfs_new_fs_info always allocate memory for
> fs_info->quota_root regardless of whether quota_tree exists or not.
> Additionally, the function btrfs_read_fs_root will directly return
> fs_info->quota_root if location->objectid == BTRFS_QUOTA_TREE_OBJECTID.
> 
> This patch does the following things:
> 1. Do extra check and return ENOENT if quota tree does not exist in the
> function btrfs_read_fs_root.
> 2. Free useless fs_info->quota_root in the function btrfs_setup_all_roots
> to reduce confusion.
> 3. free_extent_buffer even if check_child_node failed in the function
> walk_down_tree.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
