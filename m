Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9B0C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 17:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885C220659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 17:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfANRFL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 12:05:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:56836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726646AbfANRFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:05:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C135AAE22
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 17:05:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1A3A8DA847; Mon, 14 Jan 2019 18:04:40 +0100 (CET)
Date:   Mon, 14 Jan 2019 18:04:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 3/7] btrfs: relocation: Delay reloc tree deletion
 after merge_reloc_roots()
Message-ID: <20190114170440.GC2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190107054151.18662-1-wqu@suse.com>
 <20190107054151.18662-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107054151.18662-4-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 07, 2019 at 01:41:47PM +0800, Qu Wenruo wrote:
> +static int insert_dirty_root(struct btrfs_trans_handle *trans,
> +			     struct reloc_control *rc,
> +			     struct btrfs_root *root)
> +{
> +	struct rb_node **p = &rc->dirty_roots.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct dirty_source_root *entry;
> +	struct btrfs_root *reloc_root = root->reloc_root;
> +	struct btrfs_root_item *reloc_root_item;
> +	u64 root_objectid = root->root_key.objectid;
> +
> +	/* @root must be a file tree root*/
> +	ASSERT(root_objectid != BTRFS_TREE_RELOC_OBJECTID);
> +	ASSERT(reloc_root);
> +
> +	reloc_root_item = &reloc_root->root_item;
> +	memset(&reloc_root_item->drop_progress, 0,
> +		sizeof(reloc_root_item->drop_progress));
> +	reloc_root_item->drop_level = 0;
> +	btrfs_set_root_refs(reloc_root_item, 0);
> +	btrfs_update_reloc_root(trans, root);
> +
> +	/* We're at relocation route, not writeback route, GFP_KERNEL is OK */
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);

The open transaction also mandates GFP_NOFS, so that's another thing
to the locks and writeback constraints.

> +	if (!entry)
> +		return -ENOMEM;
> +	btrfs_grab_fs_root(root);
> +	entry->root = root;
> +	while (*p) {
> +		struct dirty_source_root *cur_entry;
> +
> +		parent = *p;
> +		cur_entry = rb_entry(parent, struct dirty_source_root, node);
> +
> +		if (root_objectid < cur_entry->root->root_key.objectid)
> +			p = &(*p)->rb_left;
> +		else if (root_objectid > cur_entry->root->root_key.objectid)
> +			p = &(*p)->rb_right;

Please stick to the coding style, { } around single statement if/else in
case they're chained and there's one multi statement block.

> +		else {
> +			/* This root is already dirtied */
> +			btrfs_put_fs_root(root);
> +			kfree(entry);
> +			return 0;
> +		}
> +	}
> +	rb_link_node(&entry->node, parent, p);
> +	rb_insert_color(&entry->node, &rc->dirty_roots);
> +	return 0;
> +}
