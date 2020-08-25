Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77CFC433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B6920738
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHYNzb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:55:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:43882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgHYNza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 09:55:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 526F7AFAE;
        Tue, 25 Aug 2020 13:56:00 +0000 (UTC)
Message-ID: <7482b8795905e02acf018580dfd88f59ca3dd1b3.camel@suse.de>
Subject: Re: [PATCH] btrfs: tree-checker: fix the error message for transid
 error
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Tyler Richmond <t.d.richmond@gmail.com>
Date:   Tue, 25 Aug 2020 10:55:24 -0300
In-Reply-To: <20200825134251.31609-1-wqu@suse.com>
References: <20200825134251.31609-1-wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-08-25 at 21:42 +0800, Qu Wenruo wrote:
> The error message for inode transid is the same for inode generation,
> which makes us unable to detect the real problem.

LGTM,

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
> Reported-by: Tyler Richmond <t.d.richmond@gmail.com>
> Fixes: 496245cac57e ("btrfs: tree-checker: Verify inode item")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 517b44300a05..7b1fee630f97 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -984,7 +984,7 @@ static int check_inode_item(struct extent_buffer
> *leaf,
>  	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
>  	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
>  		inode_item_err(leaf, slot,
> -			"invalid inode generation: has %llu expect [0,
> %llu]",
> +			"invalid inode transid: has %llu expect [0,
> %llu]",
>  			       btrfs_inode_transid(leaf, iitem),
> super_gen + 1);
>  		return -EUCLEAN;
>  	}

