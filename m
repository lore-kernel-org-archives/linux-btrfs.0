Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbcGGMME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 08:12:04 -0400
Date: Thu, 7 Jul 2016 14:11:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] Btrfs: error out if generic_bin_search get invalid
 arguments
Message-ID: <20160707121130.GX13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466645539-27296-1-git-send-email-bo.li.liu@oracle.com>
 <1466724765-27364-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466724765-27364-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 04:32:45PM -0700, Liu Bo wrote:
> With btrfs-corrupt-block, one can set btree node/leaf's field, if
> we assign a negative value to node/leaf, we can get various hangs,
> eg. if extent_root's nritems is -2ULL, then we get stuck in
>  btrfs_read_block_groups() because it has a while loop and
> btrfs_search_slot() on extent_root will always return the first
>  child.
> 
> This lets us know what's happening and returns a EINVAL to callers
> instead of returning the first item.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
