Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F68FC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD48E2171F
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfABRGY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 12:06:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:49290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729909AbfABRGY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 12:06:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40E9CAE1D
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Jan 2019 17:06:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B7E2EDA781; Wed,  2 Jan 2019 18:05:53 +0100 (CET)
Date:   Wed, 2 Jan 2019 18:05:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Refactor retval handling of
 btrfs_lookup_file_extent in btrfs_get_extent
Message-ID: <20190102170553.GA23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181217083602.10166-1-nborisov@suse.com>
 <20181217083602.10166-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217083602.10166-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 10:36:01AM +0200, Nikolay Borisov wrote:
> The code which executes if path->slots[0] points to an item not
> belonging to the inode we are interested in or is not na extent at all
> could really trigger if btrfs_lookup_file_extent returned > 0 and
> subsequently path->slots[0] was decremented. Make this explicit by
> moving the respective code in the correct if branch. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 36 ++++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 511d3b314af2..e8284cd0a122 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6805,22 +6805,26 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  		if (path->slots[0] == 0)
>  			goto not_found;
>  		path->slots[0]--;
> -	}
> -
> -	leaf = path->nodes[0];
> -	item = btrfs_item_ptr(leaf, path->slots[0],
> -			      struct btrfs_file_extent_item);
> -	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> -	if (found_key.objectid != objectid ||
> -	    found_key.type != BTRFS_EXTENT_DATA_KEY) {
> -		/*
> -		 * If we backup past the first extent we want to move forward
> -		 * and see if there is an extent in front of us, otherwise we'll
> -		 * say there is a hole for our whole search range which can
> -		 * cause problems.
> -		 */
> -		extent_end = start;
> -		goto next;
> +		leaf = path->nodes[0];
> +		item = btrfs_item_ptr(leaf, path->slots[0],
> +				      struct btrfs_file_extent_item);
> +		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> +		if (found_key.objectid != objectid ||
> +		    found_key.type != BTRFS_EXTENT_DATA_KEY) {
> +			/*
> +			 * If we backup past the first extent we want to move
> +			 * forward and see if there is an extent in front of us,
> +			 * otherwise we'll say there is a hole for our whole
> +			 * search range which can cause problems.
> +			 */
> +			extent_end = start;
> +			goto next;
> +		}
> +	} else {
> +		leaf = path->nodes[0];
> +		item = btrfs_item_ptr(leaf, path->slots[0],
> +				      struct btrfs_file_extent_item);

This is repeating code and could be simplified ... to the original code.
I'm not sure this patch is an improvement.
