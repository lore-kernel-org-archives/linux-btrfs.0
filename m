Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45019 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754731AbeEaL4r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 07:56:47 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84395AEA1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 11:56:46 +0000 (UTC)
Date: Thu, 31 May 2018 13:54:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree()
 check to avoid out-of-boundary memory access
Message-ID: <20180531115402.GR3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430031545.29891-3-wqu@suse.com>
 <20180510015001.31200-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180510015001.31200-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 09:50:01AM +0800, Qu Wenruo wrote:
> For btrfs_print_tree(), if nr_items is corrupted, it can easily go
> beyond extent buffer boundary.
> 
> Add extra nr_item check, and only print as many valid slots as possible.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
