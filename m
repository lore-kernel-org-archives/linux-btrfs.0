Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbcGZPdP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 11:33:15 -0400
Date: Tue, 26 Jul 2016 17:32:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix memory leak of reloc_root
Message-ID: <20160726153258.GG30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468967765-2238-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468967765-2238-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 19, 2016 at 03:36:05PM -0700, Liu Bo wrote:
> When some critical errors occur and FS would be flipped into RO,
> if we have an on-going balance, we can end up with a memory leak
> of root->reloc_root since btrfs_drop_snapshots() bails out
> without freeing reloc_root at the very early start.
> 
> However, we're not able to free reloc_root in btrfs_drop_snapshots()
> because its caller, merge_reloc_roots(), still needs to access it to
> cleanup reloc_root's rbtree.
> 
> This makes us free reloc_root when we're going to free fs/file roots.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
