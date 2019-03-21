Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D806C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 14:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4DE218E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 14:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfCUO3U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:29:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:46800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727958AbfCUO3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 10:29:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 058D6AE16;
        Thu, 21 Mar 2019 14:29:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E948DDAC2D; Thu, 21 Mar 2019 15:30:32 +0100 (CET)
Date:   Thu, 21 Mar 2019 15:30:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [PATCH] btrfs: Use raw numbers when setting passing uptodate
 parameter to btrfs_writepage_endio_finish_ordered
Message-ID: <20190321143032.GE26179@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
References: <20190320195316.27134-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320195316.27134-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 09:53:16PM +0200, Nikolay Borisov wrote:
> The uptodate parameter of btrfs_writepage_endio_finish_ordered is used
> to signal whether an error has occured while writing the given page.
> 0 signal an error, which is propagated to callees and 1 signifies
> success. In end_compressed_bio_write the ->bi_status is checked and
> based on it either BLK_STS_OK (0) or BLK_STS_NOTSUPP (1) are used. While
> from functional point of view this is ok it's a for the poor reader of
> the code, since the block layer values are conflated with the semantics
> of the parameter.
> 
> Just use plain 0 or 1. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/compression.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index eb8e20b740d6..f82441f18512 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -250,7 +250,7 @@ static void end_compressed_bio_write(struct bio *bio)
>  	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
>  	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
>  			cb->start, cb->start + cb->len - 1,
> -			bio->bi_status ? BLK_STS_OK : BLK_STS_NOTSUPP);
> +			bio->bi_status ? 0 : 1);

Essentially reverting 2dbe0c77186c691386b74391039899808a4d3f59, but
using the BLK_STS constants is definetelly wrong. The values match the
intended use of 'uptodate', but otherwise are confusing.

I actually think it can be simplified to bio->bi_staus == BLK_STS_OK.
