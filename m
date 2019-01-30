Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5F8C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626F620855
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbfA3O5z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:57:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:39306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfA3O5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:57:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6974B055
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:57:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00B00DA78C; Wed, 30 Jan 2019 15:57:19 +0100 (CET)
Date:   Wed, 30 Jan 2019 15:57:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v4 03/12] btrfs: disk-io: Show the timing of corrupted
 tree block explicitly
Message-ID: <20190130145719.GS2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125050925.30754-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 25, 2019 at 01:09:16PM +0800, Qu Wenruo wrote:
> Just add one extra line to show when the corruption is detected.
> Currently only read time detection is possible.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 794d5bb7fe33..426e9f450f70 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -658,6 +658,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  
>  	if (!ret)
>  		set_extent_buffer_uptodate(eb);
> +	else
> +		btrfs_err(fs_info, "read time tree block corrupted detected");

I'm not sure the 'read time' is clear enoug, my suggestion is to use
'post-read' (and pre-write analogicaly). What do you think?
