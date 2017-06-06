Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45641 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdFFKod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 06:44:33 -0400
Date: Tue, 6 Jun 2017 12:44:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH 1/8] btrfs: bioset allocations will never fail, adapt
        our helpers
Message-ID: <20170606104431.GA24297@lst.de>
References: <cover.1496422340.git.dsterba@suse.com> <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com> <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 06:21:17PM +0800, Anand Jain wrote:
>
>
> On 06/03/17 00:58, David Sterba wrote:
>> Christoph pointed out that bio allocations backed by a bioset will never
>> fail.
>
> David,
>
>  Looks like this feature comes when  __GFP_DIRECT_RECLAIM is
>  set and we aren't, such as [1]. Any idea why? Looks like I am
>  missing something ?
>
>
> [1]
> -----
> static int submit_extent_page(int op, int op_flags, struct extent_io_tree 
> *tree,
> ::
>
>  bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
>                 GFP_NOFS | __GFP_HIGH);

#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))


#define GFP_NOFS        (__GFP_RECLAIM | __GFP_IO)

