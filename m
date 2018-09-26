Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81D5C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733D020843
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:35:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 733D020843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbeIZUtF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:49:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:57992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbeIZUtE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 16:49:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97289AD2F
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 14:35:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 388E4DAE2F; Wed, 26 Sep 2018 16:35:48 +0200 (CEST)
Date:   Wed, 26 Sep 2018 16:35:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/7] btrfs: qgroup: Don't trace subtree if we're
 dropping reloc tree
Message-ID: <20180926143548.GM3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180911053818.10191-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180911053818.10191-6-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 11, 2018 at 01:38:16PM +0800, Qu Wenruo wrote:
> Reloc tree doesn't contribute to qgroup numbers, as we have
> accounted them at balance time (check replace_path()).
> 
> Skip such unneeded subtree trace should reduce some performance
> overhead.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index de6f75f5547b..4588153f414c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8643,7 +8643,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  			parent = 0;
>  		}
>  
> -		if (need_account) {
> +		/*
> +		 * Tree reloc tree doesn't contribute to qgroup numbers, and

As you're going to send another iteration, please update the 'tree reloc
tree' references here and in other patches too.

> +		 * we have already accounted them at merge time (replace_path),
> +		 * thus we could skip expensive subtree trace here.
> +		 */
> +		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
> +		    need_account) {
>  			ret = btrfs_qgroup_trace_subtree(trans, next,
>  							 generation, level - 1);
>  			if (ret) {
> -- 
> 2.18.0
