Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcGGMCQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 08:02:16 -0400
Date: Thu, 7 Jul 2016 14:02:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup BUG_ON in merge_bio
Message-ID: <20160707120229.GV13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466645509-26910-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466645509-26910-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 06:31:49PM -0700, Liu Bo wrote:
> One can use btrfs-corrupt-block to hit BUG_ON() in merge_bio(),
> thus this aims to stop anyone to panic the whole system by using
>  their btrfs.
> 
> Since the error in merge_bio can only come from __btrfs_map_block()
> when chunk tree mapping has something insane and __btrfs_map_block()
> has already had printed the reason, we can just return errors in
> merge_bio.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
