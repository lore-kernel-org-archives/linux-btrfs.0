Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729040AbeHWQqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 12:46:09 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6D67ADF7
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 13:16:28 +0000 (UTC)
Date: Thu, 23 Aug 2018 15:16:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2.1] btrfs: Handle owner mismatch gracefully when
 walking up tree
Message-ID: <20180823131617.GM24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180821014203.5443-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180821014203.5443-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 09:42:03AM +0800, Qu Wenruo wrote:
> [BUG]
> When mounting certain crafted image, btrfs will trigger kernel BUG_ON()
> when try to recover balance:
> ------
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent-tree.c:8956!
> invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 1 PID: 662 Comm: mount Not tainted 4.18.0-rc1-custom+ #10
> RIP: 0010:walk_up_proc+0x336/0x480 [btrfs]
> RSP: 0018:ffffb53540c9b890 EFLAGS: 00010202
> Call Trace:
>  walk_up_tree+0x172/0x1f0 [btrfs]
>  btrfs_drop_snapshot+0x3a4/0x830 [btrfs]
>  merge_reloc_roots+0xe1/0x1d0 [btrfs]
>  btrfs_recover_relocation+0x3ea/0x420 [btrfs]
>  open_ctree+0x1af3/0x1dd0 [btrfs]
>  btrfs_mount_root+0x66b/0x740 [btrfs]
>  mount_fs+0x3b/0x16a
>  vfs_kern_mount.part.9+0x54/0x140
>  btrfs_mount+0x16d/0x890 [btrfs]
>  mount_fs+0x3b/0x16a
>  vfs_kern_mount.part.9+0x54/0x140
>  do_mount+0x1fd/0xda0
>  ksys_mount+0xba/0xd0
>  __x64_sys_mount+0x21/0x30
>  do_syscall_64+0x60/0x210
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> ---[ end trace d4344e4deee03435 ]---
> ------
> 
> [CAUSE]
> Another extent tree corruption.
> 
> In this particular case, tree reloc root's owner is
> DATA_RELOC_TREE (should be TREE_RELOC_TREE), thus its backref is
> corrupted and we failed the owner check in walk_up_tree().
> 
> [FIX]
> It's pretty hard to take care of every extent tree corruption, but at
> least we can remove such BUG_ON() and exit more gracefully.
> 
> And since in this particular image, DATA_RELOC_TREE and TREE_RELOC_TREE
> shares the same root (which is obviously invalid), we needs to make
> __del_reloc_root() more robust to detect such invalid share to avoid
> possible NULL dereference as root->node can be NULL in this case.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200411
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
