Return-Path: <SRS0=p/S3=UN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D51C31E4B
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Jun 2019 15:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A689021744
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Jun 2019 15:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfFNPOh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Jun 2019 11:14:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:51726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbfFNPOh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jun 2019 11:14:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76E96AB42;
        Fri, 14 Jun 2019 15:14:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AFF59DA8D6; Fri, 14 Jun 2019 17:15:24 +0200 (CEST)
Date:   Fri, 14 Jun 2019 17:15:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Tejun Heo <tj@kernel.org>
Cc:     dsterba@suse.com, clm@fb.com, josef@toxicpanda.com,
        axboe@kernel.dk, jack@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 7/8] Btrfs: use REQ_CGROUP_PUNT for worker thread
 submitted bios
Message-ID: <20190614151524.GZ3563@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Tejun Heo <tj@kernel.org>,
        dsterba@suse.com, clm@fb.com, josef@toxicpanda.com, axboe@kernel.dk,
        jack@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
References: <20190614003350.1178444-1-tj@kernel.org>
 <20190614003350.1178444-8-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190614003350.1178444-8-tj@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 13, 2019 at 05:33:49PM -0700, Tejun Heo wrote:
> @@ -1251,12 +1258,29 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>  		 * to unlock it.
>  		 */
>  		if (locked_page) {
> +			/*
> +			 * Depending on the compressibility, the pages
> +			 * might or might not go through async.  We want
> +			 * all of them to be accounted against @wbc once.
> +			 * Let's do it here before the paths diverge.  wbc
> +			 * accounting is used only for foreign writeback
> +			 * detection and doesn't need full accuracy.  Just
> +			 * account the whole thing against the first page.
> +			 */
> +			wbc_account_io(wbc, locked_page, cur_end - start);
>  			async_chunk[i].locked_page = locked_page;
>  			locked_page = NULL;
>  		} else {
>  			async_chunk[i].locked_page = NULL;
>  		}
>  
> +		if (blkcg_css != blkcg_root_css) {
> +			css_get(blkcg_css);

fs/btrfs/inode.c: In function ‘cow_file_range_async’:
fs/btrfs/inode.c:1278:4: error: implicit declaration of function ‘css_get’; did you mean ‘css_put’? [-Werror=implicit-function-declaration]
 1278 |    css_get(blkcg_css);
      |    ^~~~~~~
      |    css_put

I don't have CONFIG_CGROUPS enabled in the testing kernel so this probably
needs a wrapper so the ifdef is not in the middle of the function.
