Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F418FC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF3420880
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfDHQsI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:48:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:59820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbfDHQsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 12:48:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3629FB03B
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Apr 2019 16:48:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B991CDA88B; Mon,  8 Apr 2019 18:49:14 +0200 (CEST)
Date:   Mon, 8 Apr 2019 18:49:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Record error in btree_csum_one_bio()
Message-ID: <20190408164914.GA29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190406102005.5420-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406102005.5420-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 06:20:05PM +0800, Qu Wenruo wrote:
> Since commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
> iterate over multi-page bvec"), break will only break the inner loop of
> bio_for_each_segment_all(), unable to break the outer loop.
> 
> This patch will break out by utilizing goto command.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6fe9197f6ee4..e20b952d3cde 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -840,9 +840,10 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
>  		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
>  		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
>  		if (ret)
> -			break;
> +			goto out;

This being fixed in the block layer macros, but note that 'break' is not
the only thing that's broken, also 'continue' and we do have a few
instances of that in btrfs code.

Once this is fixed in the macros, this patch is not necessary.
