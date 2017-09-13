Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751123AbdIMPx1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:53:27 -0400
Date: Wed, 13 Sep 2017 17:51:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] Btrfs: make plug in writing meta blocks
 really work
Message-ID: <20170913155155.GP29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170821215000.2987-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821215000.2987-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 03:49:59PM -0600, Liu Bo wrote:
> We have started plug in btrfs_write_and_wait_marked_extents() but the
> generated IOs actually go to device's schedule IO list where the work
> is doing in another task, thus the started plug doesn't make any
> sense.
> 
> And since we wait for IOs immediately after writing meta blocks, it's
> the same case as writing log tree, doing sync submit can merge more
> IOs.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

The original patch c6adc9cc082e3 adds too many randomly scattered
blg_plugs that, we could use some high-level comments about the purpose.
