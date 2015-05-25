Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbbEYMb6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 08:31:58 -0400
Date: Mon, 25 May 2015 14:31:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing free_extent_buffer
Message-ID: <20150525123156.GE23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432545400-31871-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432545400-31871-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 25, 2015 at 05:16:40PM +0800, Liu Bo wrote:
> read_tree_block may take a reference on the 'eb', a following
> free_extent_buffer is necessary.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

And I've spotted one more in btrfs_read_tree_root and 2 other
where it was not outright obvious from the code logic.
