Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab3GAX3r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jul 2013 19:29:47 -0400
Date: Mon, 1 Jul 2013 16:29:44 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: rework ulist with list operation
Message-ID: <20130701232944.GS10265@lenny.home.zabbo.net>
References: <1372688084-18255-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372688084-18255-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 01, 2013 at 10:14:44PM +0800, Liu Bo wrote:
> This is actually from Zach Brown's idea.

Thanks for giving this a try.

> Instead of ulist of array+rbtree, here we introduce ulist of list+rbtree,
> memory is dynamic allocation and we can get rid of memory re-allocation dance
> and special care for rbtree node's insert/delete for inline array, so it's
> straightforward and simple.

So now that I've really sat down with ulist, I'm not convinced that
fiddling around with its data structure is the right approach.  I'd just
leave the current ulist alone now that we've hopefully fixed the worst
rbtree realloc bug.

I think the long term goal should be to rework callers to not need
ulist.  Some don't need concurrent iteration and insertion and a simple
rbtree would work.  Others probably don't even need an additional
allocated data structure.

Anyway, about this specific change:

>  struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
>  {
> +	struct list_head *next;
> +	struct ulist_node *node;
> +
>  	if (ulist->nnodes == 0)
>  		return NULL;
>  	if (uiter->i < 0 || uiter->i >= ulist->nnodes)
>  		return NULL;
>  
> -	return &ulist->nodes[uiter->i++];
> +	if (uiter->i == 0)
> +		next = ulist->nodes.next;
> +	else
> +		next = ulist->cur_node->next;
> +
> +	node = list_entry(next, struct ulist_node, list);
> +	ulist->cur_node = next;
> +	uiter->i++;
> +	return node;
>  }
>  EXPORT_SYMBOL(ulist_next);

There are two interface changes here.

Concurrent iterators would no longer work independently of each other:

	ULIST_ITER_INIT(&iter1);
	ULIST_ITER_INIT(&iter2);
	ulist_next(&ulist, &iter1);
	ulist_next(&ulist, &iter2);

And the strange state sharing between the iterator and the list's
cur_node means that someone might accidentally dereference a null
cur_node:

	ULIST_ITER_INIT(&iter);
	ulist_next(&ulist, &iter);
	ulist_reinit(&ulist);
	ulist_add(&ulist, ...);
	ulist_next(&ulist, &iter);

I don't think any callers do either of these things today, but how would
they know not to? :)  I don't think we should add this kind of subtle
fragility.

- z
