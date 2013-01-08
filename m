Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:35732 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3AHUHe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 15:07:34 -0500
Date: Tue, 8 Jan 2013 12:07:34 -0800
From: Zach Brown <zab@zabbo.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130108200734.GD12288@lenny.home.zabbo.net>
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> This is for detecting extent map leak.

Hmm, I guess it's cool to get the allocation-specific decoding which you
don't get from the generic kernel leak tracking?

> +static LIST_HEAD(emaps);

> +	while (!list_empty(&emaps)) {
> +		em = list_entry(emaps.next, struct extent_map, leak_list);
> +		printk(KERN_ERR "btrfs ext map leak: start %llu len %llu block %llu flags %llu refs %d in tree %d compress %d\n",
> +			em->start, em->len, em->block_start, em->flags, atomic_read(&em->refs), em->in_tree, em->compress_type);
> +		list_del(&em->leak_list);
> +		kmem_cache_free(extent_map_cache, em);

> +	struct list_head leak_list;

Might as well protect all that with ifdefs, too, if you're going to do
it that way?

- z
