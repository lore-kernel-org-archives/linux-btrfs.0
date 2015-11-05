Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031773AbbKEMmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 07:42:24 -0500
Date: Thu, 5 Nov 2015 13:40:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Allow btrfs_leaf_free_space to accept
 NULL root
Message-ID: <20151105124052.GO13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2015 at 04:32:59PM +0800, Qu Wenruo wrote:
> Btrfs_leaf_free_space() function is used to determine the leaf/node
> size.
> It's OK to use root->nodesize to determine nodesize, but in fact,
> extent_buffer->len can also be used to determine the nodesize if caller
> can ensure it's a tree block.
> 
> So this patch will add support for NULL root for btrfs_leaf_free_space()
> function, to allow btrfs_print_leaf() functions to be called in gdb or
> to debug temporary btrfs in make_btrfs() without a valid root.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
