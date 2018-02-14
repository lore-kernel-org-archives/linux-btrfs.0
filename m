Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44803 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032578AbeBNQgn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 11:36:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 430F3AE1E
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 16:36:42 +0000 (UTC)
Date: Wed, 14 Feb 2018 17:34:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: mkfs/rootdir: Fix memory leak in
 traverse_directory()
Message-ID: <20180214163426.GI3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180214075006.6576-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180214075006.6576-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 14, 2018 at 03:50:06PM +0800, Qu Wenruo wrote:
> The bug is exposed by mkfs test case 009, with D=asan.
> 
> We are leaking memory of parent_dir_entry->path() which ,except the
> rootdir, is allocated by strdup().
> 
> Before fixing it, unifiy the allocation of parent_dir_entry() to heap
> allocation.
> 
> Then fix it by adding "free(parent_dir_entry->path);" in
> traverse_directory() and error handler.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
