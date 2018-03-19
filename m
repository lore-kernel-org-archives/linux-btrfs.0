Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969072AbeCSSRA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 14:17:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5D85EAF07
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 18:16:59 +0000 (UTC)
Date: Mon, 19 Mar 2018 19:14:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
Message-ID: <20180319181435.GK6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180319102810.24356-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180319102810.24356-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 06:28:10PM +0800, Qu Wenruo wrote:
> Commit Fixes: 8c36786c8198 ("btrfs-progs: print-tree: Print offset as tree objectid for ROOT_ITEM")
> changes how we translate offset of ROOT_ITEM.
> 
> However the fact is, even for ROOT_ITEM, we have different meaning of
> offset.
> 
> For tree reloc tree, it's indeed subvolume id.
> But for other trees, it's the transid of when it's created.
> 
> Fix it.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
