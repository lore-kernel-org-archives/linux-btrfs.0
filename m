Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37613 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3AJCH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 21:07:59 -0500
Date: Thu, 10 Jan 2013 10:05:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130110020517.GA4456@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108200734.GD12288@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 12:07:34PM -0800, Zach Brown wrote:
> > This is for detecting extent map leak.
> 
> Hmm, I guess it's cool to get the allocation-specific decoding which you
> don't get from the generic kernel leak tracking?

Hi Zach,

Thanks for the advice, but what allocation-specific decoding do you refer to?
Could you please show me any examples?

> 
> > +static LIST_HEAD(emaps);
> 
> > +	while (!list_empty(&emaps)) {
> > +		em = list_entry(emaps.next, struct extent_map, leak_list);
> > +		printk(KERN_ERR "btrfs ext map leak: start %llu len %llu block %llu flags %llu refs %d in tree %d compress %d\n",
> > +			em->start, em->len, em->block_start, em->flags, atomic_read(&em->refs), em->in_tree, em->compress_type);
> > +		list_del(&em->leak_list);
> > +		kmem_cache_free(extent_map_cache, em);
> 
> > +	struct list_head leak_list;
> 
> Might as well protect all that with ifdefs, too, if you're going to do
> it that way?

All right, I'm happy to do that.

Thanks,
liubo
