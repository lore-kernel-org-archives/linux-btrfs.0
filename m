Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38659 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751345AbdFFKww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 06:52:52 -0400
Date: Tue, 6 Jun 2017 12:51:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs: bioset allocations will never fail, adapt our
 helpers
Message-ID: <20170606105149.GZ12135@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496422340.git.dsterba@suse.com>
 <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
 <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 06:21:17PM +0800, Anand Jain wrote:
> On 06/03/17 00:58, David Sterba wrote:
> > Christoph pointed out that bio allocations backed by a bioset will never
> > fail.
> 
>   Looks like this feature comes when  __GFP_DIRECT_RECLAIM is
>   set and we aren't, such as [1]. Any idea why? Looks like I am
>   missing something ?

bio_alloc_bioset:

 406  *   When @bs is not NULL, if %__GFP_DIRECT_RECLAIM is set then bio_alloc will
 407  *   always be able to allocate a bio. This is due to the mempool guarantees.

> [1]
> -----
> static int submit_extent_page(int op, int op_flags, struct 
> extent_io_tree *tree,
> ::
> 
>   bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
>                  GFP_NOFS | __GFP_HIGH);

GFP_NOFS contains __GFP_DIRECT_RECLAIM, so what's the problem? __GFP_HIGH
allows using the reserves, but should not otherwise change the constraints.
And it's use seems unnecessary, as far as I could track in the history.
