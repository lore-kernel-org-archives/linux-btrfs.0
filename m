Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58333 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752800AbcJaBJD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 21:09:03 -0400
Date: Sun, 30 Oct 2016 16:13:35 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, david@fromorbit.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Subject: Re: [PATCH 2/5] writeback: convert WB_WRITTEN/WB_DIRITED counters to
 bytes
Message-ID: <20161030151335.GA17039@quack2.suse.cz>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477420904-1399-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 25-10-16 14:41:41, Josef Bacik wrote:
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 121a6e3..e09b3ad 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -596,11 +596,11 @@ static void wb_domain_writeout_inc(struct wb_domain *dom,
>   * Increment @wb's writeout completion count and the global writeout
>   * completion count. Called from test_clear_page_writeback().
>   */
> -static inline void __wb_writeout_inc(struct bdi_writeback *wb)
> +static inline void __wb_writeout_inc(struct bdi_writeback *wb, long bytes)

Please keep the names consistent - i.e. when you rename wb_writeout_inc to
wb_writeout_add, then you should do the same with __wb_writeout_inc...

>  {
>  	struct wb_domain *cgdom;
>  
> -	__inc_wb_stat(wb, WB_WRITTEN);
> +	__add_wb_stat(wb, WB_WRITTEN_BYTES, bytes);
>  	wb_domain_writeout_inc(&global_wb_domain, &wb->completions,
>  			       wb->bdi->max_prop_frac);

Also I think you will need to change the per-domain writeback statistics to
bytes as well. Otherwise the proportions can get skewed.

Other than that the patch looks good to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
