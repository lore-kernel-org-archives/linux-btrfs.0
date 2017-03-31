Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933286AbdCaReB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:34:01 -0400
Date: Fri, 31 Mar 2017 19:33:11 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH 2/7] btrfs: use simpler readahead zone lookups
Message-ID: <20170331173311.GP4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1489593696.git.dsterba@suse.com>
 <28edb65e1e98d9f815f3b64cdd2489d4be78e681.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <28edb65e1e98d9f815f3b64cdd2489d4be78e681.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:26PM +0100, David Sterba wrote:
> No point using radix_tree_gang_lookup if we're looking up just one slot.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

I've bisected to this patch, causes a hang in btrfs/011. I'll revert it
for until I find out the cause.
