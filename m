Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750943AbdESRx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 13:53:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8163ABBD
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 17:53:19 +0000 (UTC)
Date: Fri, 19 May 2017 19:52:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jeffm@suse.com
Subject: Re: [RFC PATCH] btrfs: Clean up btrfs_leaf_data
Message-ID: <20170519175222.GY4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495180150-12069-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495180150-12069-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 10:49:10AM +0300, Nikolay Borisov wrote:
> Commit 5f39d397dfbe ("Btrfs: Create extent_buffer interface for large blocksizes")
> refactored btrfs_leaf_data function to take extent_buffer rather than
> struct btrfs_leaf. However, as it turns out the parameter being passed is never
> used. Help the brave souls which are going to read this code in the future
> by eliminating the parameter.

The git changelog lines should be at most 74 chars.

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Hello, 
> 
> Here is a minor cleanup, which hopefully reduces cognitive load while reading
> the extent_buffer code. After this commit btrfs_leaf_data basically becomes
> a synonym to offsetof and I can't help it but begin to wonder wouldn't it be 
> better if I nuke btrfs_leaf_data altogether or rename it to
> btrfs_leaf_data_offset?

Yes please, make it BTRFS_LEAF_DATA_OFFSET so it's consistent with other
BTRFS_LEAF_* helpers.
