Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbbFONcx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:32:53 -0400
Date: Mon, 15 Jun 2015 15:32:51 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use kmem_cache_free when freeing entry in
 inode cache
Message-ID: <20150615133251.GN6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434174777-14409-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434174777-14409-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 13, 2015 at 06:52:56AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The free space entries are allocated using kmem_cache_zalloc(),
> through __btrfs_add_free_space(), therefore we should use
> kmem_cache_free() and not kfree() to avoid any confusion and
> any potential problem. Looking at the kfree() definition at
> mm/slab.c it has the following comment:
> 
>   /*
>    * (...)
>    *
>    * Don't free memory not originally allocated by kmalloc()
>    * or you will run into trouble.
>    */
> 
> So better be safe and use kmem_cache_free().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
