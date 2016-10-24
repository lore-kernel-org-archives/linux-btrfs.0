Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935881AbcJXRrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 13:47:01 -0400
Date: Mon, 24 Oct 2016 19:46:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v13.1 00/14] Btrfs In-band De-duplication
Message-ID: <20161024174658.GI22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161020020339.21208-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161020020339.21208-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 10:03:39AM +0800, Qu Wenruo wrote:
> Qu Wenruo (4):
>   btrfs: delayed-ref: Add support for increasing data ref under spinlock
>   btrfs: dedupe: Inband in-memory only de-duplication implement
>   btrfs: relocation: Enhance error handling to avoid BUG_ON
>   btrfs: dedupe: Introduce new reconfigure ioctl
> 
> Wang Xiaoguang (10):
>   btrfs: dedupe: Introduce dedupe framework and its header
>   btrfs: dedupe: Introduce function to initialize dedupe info
>   btrfs: dedupe: Introduce function to add hash into in-memory tree
>   btrfs: dedupe: Introduce function to remove hash from in-memory tree
>   btrfs: dedupe: Introduce function to search for an existing hash
>   btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
>   btrfs: ordered-extent: Add support for dedupe
>   btrfs: dedupe: Add ioctl for inband dedupelication
>   btrfs: improve inode's outstanding_extents computation

I've noticed that this patch is different from what Wang sent
independently. Is the patch necessary for the dedupe patchset? If not,
please drop it.

The merge conflict is in the checks for free space inode,

  if (root == root->fs_info->tree_root)

vs

  if (!btrfs_is_free_space_inode(...))

If you need the patch, then please update it to the latest version. I
won't get the merge conflicts at least, this is acceptable for the
testing 'for-next' branch.
