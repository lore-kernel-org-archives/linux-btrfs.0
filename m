Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbeCOT0o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 15:26:44 -0400
Date: Thu, 15 Mar 2018 20:24:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Verify extent allocated by find_free_extent()
 won't overlap with extents from previous transaction
Message-ID: <20180315192420.GW32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213011332.13287-1-wqu@suse.com>
 <20180314210929.GU32007@twin.jikos.cz>
 <278a00f5-09aa-a261-29f4-9676820beb87@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <278a00f5-09aa-a261-29f4-9676820beb87@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 09:02:28AM +0800, Qu Wenruo wrote:
> > The sanity tests are run at module load time, but the new check you are
> > adding is a runtime one, so I think the right ifdef is
> > CONFIG_BTRFS_DEBUG.
> 
> I'll use CONFIG_BTRFS_DEBUG.
> 
> But the patch is causing rcu problems under heavy load, so I'm afraid it
> is not suitable to be merged.
> 
> Please discard this until I found a solution to the RCU problem.

Ok, understood.
