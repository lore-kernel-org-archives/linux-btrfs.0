Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AD9C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 16:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DB5B2098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 16:21:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DB5B2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbeJSAWt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 20:22:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:34912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727274AbeJSAWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 20:22:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76906AF13
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 16:21:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B0C1DDAE03; Thu, 18 Oct 2018 18:20:59 +0200 (CEST)
Date:   Thu, 18 Oct 2018 18:20:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
Message-ID: <20181018162059.GJ29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018111729.11128-5-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 07:17:27PM +0800, Qu Wenruo wrote:
> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
> +{
> +	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
> +	struct btrfs_qgroup_swapped_block *cur, *next;
> +	int i;
> +
> +	swapped_blocks = &root->swapped_blocks;
> +
> +	spin_lock(&swapped_blocks->lock);
> +	if (!swapped_blocks->swapped)
> +		goto out;
> +	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> +		struct rb_root *cur_root = &swapped_blocks->blocks[i];
> +
> +		rbtree_postorder_for_each_entry_safe(cur, next, cur_root,
> +						     node) {
> +			rb_erase(&cur->node, cur_root);

https://elixir.bootlin.com/linux/latest/source/include/linux/rbtree.h#L141

rb_erase must not be used on the same pointer that
rbtree_postorder_for_each_entry_safe iterates, here it's cur.
