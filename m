Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752112AbeGDNgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 09:36:11 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD76DAE60
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 13:36:09 +0000 (UTC)
Date: Wed, 4 Jul 2018 15:36:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Enhancement for block group/chunk verification
Message-ID: <20180704133607.GQ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703091009.16399-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 05:10:04PM +0800, Qu Wenruo wrote:
> Can be fetched from github, which is based on v4.18-rc1 tag:
> https://github.com/adam900710/linux/tree/tree_checker_enhance
> 
> Reported by Xu Wen <wen.xu@gatech.edu>, some crafted btrfs image can
> cause unexpected kernel behavior.
> 
> All of them are related to block group and chunk, so this patchset will
> enhance block group and chunk verification, so kernel can detect them
> and error out gracefully (with user friendly error message showing
> what's going wrong)
> 
> Obvious corruption (don't need to cross check with chunk/block group),
> will be addressed by enhanced tree-checker.
> (Most crafted images will be caught by tree-checker)
> 
> More complex corruption will be addressed mostly at
> btrfs_read_block_groups(), doing extra cross reference check for
> chunk<->block group mapping.
> It may cause extra mount time, but compared to the existing time
> consuming block group items search, all added check is done completely
> in memory using rb_tree, so it shouldn't add too much overhead.
> 
> Qu Wenruo (5):
>   btrfs: tree-checker: Verify block_group_item
>   btrfs: tree-checker: Detect invalid empty essential tree
>   btrfs: relocation: Only remove reloc rb_trees if reloc control has
>     been initialized
>   btrfs: Check each block group has corresponding chunk at mount time
>   btrfs: Verify every chunk has corresponding block group at mount time

Patches 1-3 queued, thanks. 4 and 5 have some comments.
