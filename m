Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F30C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3F620842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 12:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfBYMYu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 07:24:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:53018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbfBYMYu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:24:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A9F9CACBA
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 12:24:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5352ADAA70; Mon, 25 Feb 2019 13:26:11 +0100 (CET)
Date:   Mon, 25 Feb 2019 13:26:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't panic when we can't find a root key
Message-ID: <20190225122611.GO9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190225051106.22091-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225051106.22091-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 01:11:06PM +0800, Qu Wenruo wrote:
> When we failed to find a root key in btrfs_update_root(), we just panic.
> 
> That's definitely not cool, fix it by aborting current transaction and
> return an error value.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/root-tree.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 65bda0682928..c48a3e18866d 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -137,11 +137,15 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  		goto out;
>  	}
>  
> -	if (ret != 0) {
> +	if (ret > 0) {
>  		btrfs_print_leaf(path->nodes[0]);

You leave the leaf dump here, which I believe was related to the BUG_ON
so there's information for later analysis. This is not usually done
where transaction is aborted and error returned. I'm not saying it's not
worth keeping it here, as the logic that would lead to this error is
in the 'never happens' category. But we know such things happen due to
the bitflips and random memory corruptions so a dump might make sense.

If you think this makes sense, please put it to the changelog and write
a comment before the leaf dump. This will be a good pattern to follow as
there are many instances of leaf_dump/BUG to clean up or review.
