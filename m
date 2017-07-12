Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751135AbdGLWa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:30:57 -0400
Date: Thu, 13 Jul 2017 00:29:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [Patch v2] Btrfs-progs: fix infinite loop in find_free_extent
Message-ID: <20170712222943.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170626173441.28275-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170626173441.28275-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 11:34:41AM -0600, Liu Bo wrote:
> If the found %ins is crossing a stripe len, ie. BTRFS_STRIPE_LEN, we'd
> search again with a stripe-aligned %search_start.  The current code
> calculates %search_start by adding a wrong offset, in order to fix it, the
> start position of the block group should be taken, otherwise, it'll end up
> with looking at the same block group forever.
> 
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied, thanks.
