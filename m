Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02065C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C904C20866
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 17:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfAVRFk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:05:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:50112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729316AbfAVRFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 12:05:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 891ECABCB
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 17:05:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 713FADA84A; Tue, 22 Jan 2019 18:05:07 +0100 (CET)
Date:   Tue, 22 Jan 2019 18:05:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 6/7] btrfs: qgroup: Use delayed subtree rescan for
 balance
Message-ID: <20190122170506.GP2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-7-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-7-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:16:03PM +0800, Qu Wenruo wrote:
> +int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
> +					 struct btrfs_root *root,
> +					 struct extent_buffer *subv_eb)
> +{
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_qgroup_swapped_blocks *blocks = &root->swapped_blocks;
> +	struct btrfs_qgroup_swapped_block *block;
> +	struct extent_buffer *reloc_eb = NULL;
> +	struct rb_node *n;

Please don't use single letter variable here

> +	bool found = false;
> +	bool swapped = false;
> +	int level = btrfs_header_level(subv_eb);
> +	int ret = 0;
> +	int i;
> +
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
> +		return 0;
> +	if (!is_fstree(root->root_key.objectid) || !root->reloc_root)
> +		return 0;
> +
> +	spin_lock(&blocks->lock);
> +	if (!blocks->swapped) {
> +		spin_unlock(&blocks->lock);
> +		goto out;

I think you can return here directly, as this is a shortcut and there's
no state that would need to be cleaned up (ret is still 0).

> +	}
> +	n = blocks->blocks[level].rb_node;
> +
> +	while (n) {
> +		block = rb_entry(n, struct btrfs_qgroup_swapped_block, node);
> +		if (block->subv_bytenr < subv_eb->start)
> +			n = n->rb_left;
> +		else if (block->subv_bytenr > subv_eb->start)
> +			n = n->rb_right;
> +		else {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found) {
> +		spin_unlock(&blocks->lock);
> +		goto out;
> +	}
> +	/* Found one, remove it from @blocks first and update blocks->swapped */
> +	rb_erase(&block->node, &blocks->blocks[level]);
> +	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> +		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
> +			swapped = true;
> +			break;
> +		}
> +	}
> +	blocks->swapped = swapped;
> +	spin_unlock(&blocks->lock);
> +
> +	/* Read out reloc subtree root */
> +	reloc_eb = read_tree_block(fs_info, block->reloc_bytenr,
> +				   block->reloc_generation, block->level,
> +				   &block->first_key);
> +	if (IS_ERR(reloc_eb)) {
> +		ret = PTR_ERR(subv_eb);
> +		reloc_eb = NULL;
> +		goto free_out;
> +	}
> +	if (!extent_buffer_uptodate(reloc_eb)) {
> +		ret = -EIO;
> +		goto free_out;
> +	}
> +
> +	ret = qgroup_trace_subtree_swap(trans, reloc_eb, subv_eb,
> +			block->last_snapshot, block->trace_leaf);
> +free_out:
> +	kfree(block);
> +	free_extent_buffer(reloc_eb);
> +out:
> +	if (ret < 0) {
> +		btrfs_err_rl(fs_info,
> +			     "failed to account subtree at bytenr %llu: %d",
> +			     subv_eb->start, ret);
> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	}
> +	return ret;
> +}
