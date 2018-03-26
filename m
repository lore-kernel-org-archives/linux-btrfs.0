Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59855 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeCZN0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:26:38 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E616AC8D
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 13:26:37 +0000 (UTC)
Date: Mon, 26 Mar 2018 15:24:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check/original: Remove unused variable
 first_key
Message-ID: <20180326132412.GM6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180322090624.13408-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180322090624.13408-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2018 at 05:06:24PM +0800, Qu Wenruo wrote:
> This @first_key variable is introduced in f5c4c4f3b75b
> ("btrfsck: add code to rebuild extent records"), however it's not only
> unused, but also used incorrectly.
> 
> It's calling btrfs_item_key_to_cpu() on an node extent buffer.
> 
> Anyway, just remove it.
> 
> Fixes: f5c4c4f3b75b ("btrfsck: add code to rebuild extent records")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
