Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756081AbcIAPaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 11:30:03 -0400
Date: Thu, 1 Sep 2016 17:28:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: bail out if block group has different mixed flag
Message-ID: <20160901152840.GR16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1472173707-4533-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472173707-4533-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 06:08:27PM -0700, Liu Bo wrote:
> Currently we allow inconsistence about mixed flag
>  (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA).
> 
> We'd get ENOSPC if block group has mixed flag and btrfs doesn't.
> If that happens, we have one space_info with mixed flag and another
> space_info only with BTRFS_BLOCK_GROUP_METADATA, and
> global_block_rsv.space_info points to the latter one, but all bytes
> from block_group contributes to the mixed space_info, thus all the
> allocation will fail with ENOSPC.
> 
> This adds a check for the above case.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

OK for the fix. Even if we allow combining mixed and split bg, the
incompat bit must be present. This could be also part of fsck, as we
don't give an option how to fix that.
