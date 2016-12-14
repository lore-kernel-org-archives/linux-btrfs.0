Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755167AbcLNNQX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 08:16:23 -0500
Date: Wed, 14 Dec 2016 14:15:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/4] Lowmem fsck false alert fixes
Message-ID: <20161214131555.GD3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2016 at 05:07:52PM +0800, Qu Wenruo wrote:
> Btrfs-progs test case 023 will cause assert and a lot of false alerts
> for lowmem mode.
> 
> The problems are caused by several reasons, from bad handler for tree
> reloc root(calling btrfs_read_fs_root on tree reloc tree) to too
> restrict check.
> 
> Fix the lowmem mode bugs.
> 
> There is another bug which affects both original mode and lowmem mode,
> it seems to be caused by this commit:
> commit 00e769d04c2c83029d6c71fbded133597d93ad55
> Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Date:   Tue Nov 29 10:24:52 2016 -0600
> 
>     btrfs-progs: Correct value printed by assertions/BUG_ON/WARN_ON
> 
> Informed Goldwyn to fix it.
> So the fix for the common assert is not included in this patchset.
> 
> Qu Wenruo (4):
>   btrfs-progs: check: Fix assert when using lowmem on fs with tree reloc
>     tree
>   btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023
>   btrfs-progs: check: Fix lowmem false alert on tree reloc tree
>   btrfs-progs: check: Fix false alert on generation mismatch for tree
>     reloc tree

1-4 applied, thanks.
