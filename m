Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB85FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8267520828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfCYQZk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:25:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:43144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCYQZk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 12:25:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0EAB0AEB2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 16:25:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2C175DA825; Mon, 25 Mar 2019 17:26:52 +0100 (CET)
Date:   Mon, 25 Mar 2019 17:26:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v3 07/12] btrfs: replace pending/pinned chunks lists with
 io tree
Message-ID: <20190325162651.GI10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-8-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123132.27835-8-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 02:31:27PM +0200, Nikolay Borisov wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> The pending chunks list contains chunks that are allocated in the
> current transaction but haven't been created yet. The pinned chunks
> list contains chunks that are being released in the current transaction.
> Both describe chunks that are not reflected on disk as in use but are
> unavailable just the same.
> 
> The pending chunks list is anchored by the transaction handle, which
> means that we need to hold a reference to a transaction when working
> with the list.
> 
> We use these lists to ensure that we don't end up discarding chunks
> that are allocated or released in the current transaction.  What we r
> 
> The way we use them is by iterating over both lists to perform
> comparisons on the stripes they describe for each device. This is
> backwards and requires that we keep a transaction handle open while
> we're trimming.
> 
> This patchset adds an extent_io_tree to btrfs_device that maintains
> the allocation state of the device.  Extents are set dirty when
> chunks are first allocated -- when the extent maps are added to the
> mapping tree. They're cleared when last removed -- when the extent
> maps are removed from the mapping tree. This matches the lifespan
> of the pending and pinned chunks list and allows us to do trims
> on unallocated space safely without pinning the transaction for what
> may be a lengthy operation. We can also use this io tree to mark
> which chunks have already been trimmed so we don't repeat the operation.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h            |  6 ---
>  fs/btrfs/disk-io.c          | 11 -----
>  fs/btrfs/extent-tree.c      | 28 -----------
>  fs/btrfs/extent_io.c        |  2 +-
>  fs/btrfs/extent_io.h        |  6 ++-
>  fs/btrfs/extent_map.c       | 36 ++++++++++++++
>  fs/btrfs/extent_map.h       |  1 -
>  fs/btrfs/free-space-cache.c |  4 --
>  fs/btrfs/transaction.c      |  9 ----
>  fs/btrfs/transaction.h      |  1 -
>  fs/btrfs/volumes.c          | 96 +++++++++++++------------------------
>  fs/btrfs/volumes.h          |  2 +
>  12 files changed, 76 insertions(+), 126 deletions(-)
> 
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -918,7 +918,7 @@ static void cache_state(struct extent_state *state,
>   * [start, end] is inclusive This takes the tree lock.
>   */
>  
> -static int __must_check
> +int __must_check
>  __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>  		 unsigned bits, unsigned exclusive_bits,
>  		 u64 *failed_start, struct extent_state **cached_state,

Does this really need to be exported again? There are helpers that can
wrap specific combinations of parameters.

> @@ -335,6 +335,8 @@ void btrfs_free_device(struct btrfs_device *device)
>  {
>  	WARN_ON(!list_empty(&device->post_commit_list));
>  	rcu_string_free(device->name);
> +	if (!in_softirq())
> +		extent_io_tree_release(&device->alloc_state);

This needs a comment

>  	bio_put(device->flush_bio);
>  	kfree(device);
>  }

The commit is quite big but I don't see how to shrink it, the changes
need to be done in several places. So, probably ok.
