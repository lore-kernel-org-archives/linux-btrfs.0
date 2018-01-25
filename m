Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44767 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeAYStf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 13:49:35 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BCD2FACC4
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 18:49:34 +0000 (UTC)
Date: Thu, 25 Jan 2018 19:47:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: Remove unnecessary parameter for
 btrfs_add_block_group
Message-ID: <20180125184724.GB19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180124023028.23119-1-wqu@suse.com>
 <31930acc-6bfa-f525-1c03-8e6730d0859d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <31930acc-6bfa-f525-1c03-8e6730d0859d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 24, 2018 at 11:37:23AM +0200, Nikolay Borisov wrote:
> 
> 
> On 24.01.2018 04:30, Qu Wenruo wrote:
> > @chunk_objectid of btrfs_make_block_group() function is always fixed to
> > BTRFS_FIRST_FREE_OBJECTID, so there is no need to pass it as parameter
> > explicitly.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
