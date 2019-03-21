Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C399C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 14:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE2ED218D3
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 14:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfCUONm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:13:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:42740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbfCUONm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 10:13:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 932A5AEC8
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 14:13:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 947FADA9FA; Thu, 21 Mar 2019 15:14:55 +0100 (CET)
Date:   Thu, 21 Mar 2019 15:14:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v5.3 09/11] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
Message-ID: <20190321141455.GD26179@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-10-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320062749.30953-10-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:27:47PM +0800, Qu Wenruo wrote:
> In extent_write_cache_pages() since flush_write_bio() can return error,
> we need some extra error handling.
> 
> For the first flush_write_bio() since we haven't locked the page, we
> only need to exit the loop.
> 
> For the seconds flush_write_bio() call, we have the page locked, despite
> that there is nothing special need to handle.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

I'm leaving this patch out for now.

> ---
>  fs/btrfs/extent_io.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5de18900a3c3..c38058398d75 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4000,7 +4000,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
>  			 */
>  			if (!trylock_page(page)) {
>  				ret = flush_write_bio(epd);
> -				BUG_ON(ret < 0);
> +				if (ret < 0) {
> +					done = 1;
> +					break;
> +				}
>  				lock_page(page);
>  			}
>  
> @@ -4012,7 +4015,11 @@ static int extent_write_cache_pages(struct address_space *mapping,
>  			if (wbc->sync_mode != WB_SYNC_NONE) {
>  				if (PageWriteback(page)) {
>  					ret = flush_write_bio(epd);
> -					BUG_ON(ret < 0);
> +					if (ret < 0) {
> +						unlock_page(page);
> +						done = 1;

I'm not sure about the semantics of 'done' here, in the normal case it
clear, but error handling needs to be taken to context of the whole
writeback and the state.

Your patch looks correct though, so it's a matter of making sure we're
not missing something subtle.
