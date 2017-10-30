Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49155 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdJ3NfT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:35:19 -0400
Date: Mon, 30 Oct 2017 14:33:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add write_flags for compression bio
Message-ID: <20171030133328.GU3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171013211035.26765-1-bo.li.liu@oracle.com>
 <20171024051816.8269-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171024051816.8269-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 23, 2017 at 11:18:16PM -0600, Liu Bo wrote:
> Compression code path has only flaged bios with REQ_OP_WRITE no matter
> where the bios come from, but it could be a sync write if fsync starts
> this writeback or a normal writeback write if wb kthread starts a
> periodic writeback.
> 
> It breaks the rule that sync writes and writeback writes need to be
> differentiated from each other, because from the POV of block layer,
> all bios need to be recognized by these flags in order to do some
> management, e.g. throttlling.
> 
> This passes writeback_control to compression write path so that it can
> send bios with proper flags to block layer.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
