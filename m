Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36131 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754903AbcLNMia (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 07:38:30 -0500
Date: Wed, 14 Dec 2016 13:38:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Subject: Re: [PATCH 1/2] btrfs-progs: btrfs-convert: Prevent accounting
 blocks beyond end of device
Message-ID: <20161214123813.GC3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
 <799009dd-e227-4c84-ab6a-08883e6a32c7@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <799009dd-e227-4c84-ab6a-08883e6a32c7@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 09, 2016 at 09:03:57AM +0800, Qu Wenruo wrote:
> Hi Chandan,
> 
> Thanks for the patch.
> 
> At 12/08/2016 09:56 PM, Chandan Rajendra wrote:
> > When looping across data block bitmap, __ext2_add_one_block() may add
> > blocks which do not exist on the underlying disk. This commit prevents
> > this from happening by checking the block index against the maximum
> > block count that was present in the ext4 filesystem instance that is
> > being converted.
> 
> The patch looks good to me.
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
