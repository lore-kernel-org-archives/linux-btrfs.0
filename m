Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbdKFPwr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:52:47 -0500
Date: Mon, 6 Nov 2017 16:50:54 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use cached state when dirtying pages during
 buffered write
Message-ID: <20171106155054.GM28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031185540.30649-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031185540.30649-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 06:55:40PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> During a buffered IO write, we can have an extent state that we got when
> we locked the range (if the range starts at an offset lower than eof), so
> always pass it to btrfs_dirty_pages() so that setting the delalloc bit
> in the range does not need to do a full search in the inode's io tree,
> saving time and reducing the amount of time we hold the io tree's lock.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
