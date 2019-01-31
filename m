Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80634C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 11:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C105218DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732363AbfAaLuE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 06:50:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:37738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbfAaLuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 06:50:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17D6EAF25;
        Thu, 31 Jan 2019 11:50:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B0683DA78C; Thu, 31 Jan 2019 12:49:26 +0100 (CET)
Date:   Thu, 31 Jan 2019 12:49:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
Message-ID: <20190131114926.GA2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190131023016.GA3413@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131023016.GA3413@embeddedor>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 08:30:16PM -0600, Gustavo A. R. Silva wrote:
> Fix inconsistent IS_ERR and PTR_ERR in btrfs_qgroup_trace_subtree_after_cow
> 
> The proper pointer to be passed as argument is reloc_eb.
> 
> This bug was detected with the help of Coccinelle.
> 
> Fixes: 2b35a512e9cf ("btrfs: qgroup: Use delayed subtree rescan for balance")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/btrfs/qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8559ed92d708..16d7ec8e4a06 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3931,7 +3931,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
>  				   block->reloc_generation, block->level,
>  				   &block->first_key);
>  	if (IS_ERR(reloc_eb)) {
> -		ret = PTR_ERR(subv_eb);
> +		ret = PTR_ERR(reloc_eb);

Thanks, this was reported and fixed but the change has not propagated to
for-next yet.
