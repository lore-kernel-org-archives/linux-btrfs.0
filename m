Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EACC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C70B92085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfAVQjA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:39:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:45812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729092AbfAVQjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 11:39:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05985B083
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 16:38:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C5B9DDA84A; Tue, 22 Jan 2019 17:38:26 +0100 (CET)
Date:   Tue, 22 Jan 2019 17:38:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 4/7] btrfs: qgroup: Refactor
 btrfs_qgroup_trace_subtree_swap()
Message-ID: <20190122163824.GN2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-5-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:16:01PM +0800, Qu Wenruo wrote:
> Refactor btrfs_qgroup_trace_subtree_swap() into
> qgroup_trace_subtree_swap(), which only needs two extent buffer and some
> other bool to control the behavior.
> 
> This provides the basis for later delayed subtree scan work.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 78 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 57 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index ba30adac88a7..8fe6ebe9aef8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1994,6 +1994,60 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
>  	return ret;
>  }
>  
> +static int qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
> +				struct extent_buffer *src_eb,
> +				struct extent_buffer *dst_eb,
> +				u64 last_snapshot, bool trace_leaf)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct btrfs_path *dst_path = NULL;
> +	int level;
> +	int ret;
> +
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
> +		return 0;
> +
> +	/* Wrong parameter order */
> +	if (btrfs_header_generation(src_eb) > btrfs_header_generation(dst_eb)) {
> +		btrfs_err_rl(fs_info,
> +		"%s: bad parameter order, src_gen=%llu dst_gen=%llu", __func__,
> +			     btrfs_header_generation(src_eb),
> +			     btrfs_header_generation(dst_eb));
> +		return -EUCLEAN;
> +	}
> +
> +	if (!extent_buffer_uptodate(src_eb) ||
> +	    !extent_buffer_uptodate(dst_eb)) {
> +		ret = -EINVAL;

Why is this EINVAL and not EIO or EUCLEAN? There's a similar pattern in
btrfs_qgroup_trace_subtree_swap that also does not look correct.

> +		goto out;
> +	}
> +
> +	level = btrfs_header_level(dst_eb);
> +	dst_path = btrfs_alloc_path();
> +	if (!dst_path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	/* For dst_path */
> +	extent_buffer_get(dst_eb);
> +	dst_path->nodes[level] = dst_eb;
> +	dst_path->slots[level] = 0;
> +	dst_path->locks[level] = 0;
> +
> +	/* Do the generation aware breadth-first search */
> +	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
> +					      level, last_snapshot, trace_leaf);
> +	if (ret < 0)
> +		goto out;
> +	ret = 0;
> +
> +out:
> +	btrfs_free_path(dst_path);
> +	if (ret < 0)
> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	return ret;
> +}
