Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51023 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbeEVP3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 11:29:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C691AB35
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:29:39 +0000 (UTC)
Date: Tue, 22 May 2018 17:26:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Cleanup alloc_reserved_tree_block signature
Message-ID: <20180522152656.GS6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 12:27:19PM +0300, Nikolay Borisov wrote:
> At the moment alloc_reserved_tree_block takes 8 friggin arguments. The irony 
> is that all of those are really derived from 3 structures. This series ends up 
> reducing the arguments to 3. As a result some code, private to alloc_reserved_tree_block
> is moved from run_delayed_tree_ref. Patch 1 removes the fs_info argument, 
> Patch 2 replaces all arguments derived from btrfs_delayed_ref_node with the 
> nodes itself, Patch 3 replaces the last 2 arguments with btrfs_delayed_extent_op
> and finally, Patch 4 simplifies the code a bit by removing one extra check.
> 
> All in all this doesn't provide any functional changes but makes the code 
> easier to follow. Also it has survived 2 xfstest runs. 
> 
> Nikolay Borisov (4):
>   btrfs: Remove fs_info argument from alloc_reserved_tree_block
>   btrfs: Simplify alloc_reserved_tree_block interface
>   btrfs: Pass btrfs_delayed_extent_op to alloc_reserved_tree_block
>   btrfs: Streamline shared ref check in alloc_reserved_tree_block

Passed fstests and added to misc-next, thanks.
