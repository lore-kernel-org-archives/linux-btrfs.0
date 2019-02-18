Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C13CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF2F2146F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfBRRLw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:11:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:59108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730949AbfBRRLw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 12:11:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D585ADD3;
        Mon, 18 Feb 2019 17:11:50 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] Btrfs: add missing error handling after doing
 leaf/node binary search
To:     fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20190218165726.22884-1-fdmanana@kernel.org>
 <20190218170730.19965-1-fdmanana@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <58076ee3-c636-698f-9499-7b18d78ab241@suse.com>
Date:   Mon, 18 Feb 2019 19:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218170730.19965-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 18.02.19 г. 19:07 ч., fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The function map_private_extent_buffer() can return an -EINVAL error, and
> it is called by generic_bin_search() which will return back the error. The
> btrfs_bin_search() function in turn calls generic_bin_search() and the
> key_search() function calls btrfs_bin_search(), so both can return the
> -EINVAL error coming from the map_private_extent_buffer() function. Some
> callers of these functions were ignoring that these functions can return
> an error, so fix them to deal with error return values.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> 
> V2: Fixed error handling in relocation, missed assignment of ret to err.
> 
>  fs/btrfs/ctree.c      |  6 ++++++
>  fs/btrfs/relocation.c | 10 ++++++++++
>  fs/btrfs/tree-log.c   |  2 ++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5a6c39b44c84..5b9f602fb9e2 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3005,6 +3005,8 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>  		 */
>  		prev_cmp = -1;
>  		ret = key_search(b, key, level, &prev_cmp, &slot);
> +		if (ret < 0)
> +			goto done;
>  
>  		if (level != 0) {
>  			int dec = 0;
> @@ -5156,6 +5158,10 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>  		nritems = btrfs_header_nritems(cur);
>  		level = btrfs_header_level(cur);
>  		sret = btrfs_bin_search(cur, min_key, level, &slot);
> +		if (sret < 0) {
> +			ret = sret;
> +			goto out;
> +		}>
>  		/* at the lowest level, we're done, setup the path and exit */
>  		if (level == path->lowest_level) {
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 272b287f8cf0..628ba528516d 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1802,6 +1802,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
>  		BUG_ON(level < lowest_level);
>  
>  		ret = btrfs_bin_search(parent, &key, level, &slot);
> +		if (ret < 0)
> +			break;
>  		if (ret && slot > 0)
>  			slot--;
>  
> @@ -2685,6 +2687,10 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>  			if (!lowest) {
>  				ret = btrfs_bin_search(upper->eb, key,
>  						       upper->level, &slot);
> +				if (ret < 0) {
> +					err = ret;
> +					goto next;
> +				}
>  				BUG_ON(ret);
>  				bytenr = btrfs_node_blockptr(upper->eb, slot);
>  				if (node->eb->start == bytenr)
> @@ -2720,6 +2726,10 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>  		} else {
>  			ret = btrfs_bin_search(upper->eb, key, upper->level,
>  					       &slot);
> +			if (ret < 0) {
> +				err = ret;
> +				goto next;
> +			}
>  			BUG_ON(ret);

Ideally those BUG_ON should disappear and be replaced with, perhahps
-EUCLEAN or somesuch?

>  		}
>  
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 8c9e87f5ec58..81a357a32837 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3772,6 +3772,8 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
>  		found_key.type = 0;
>  		ret = btrfs_bin_search(path->nodes[0], &found_key, 0,
>  				       &start_slot);
> +		if (ret < 0)
> +			break;
>  
>  		ret = btrfs_del_items(trans, log, path, start_slot,
>  				      path->slots[0] - start_slot + 1);
> 
