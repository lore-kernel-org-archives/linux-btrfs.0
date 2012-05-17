Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:57349 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751931Ab2EQNb1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 09:31:27 -0400
Message-ID: <4FB4FDC6.5070306@gmx.net>
Date: Thu, 17 May 2012 15:31:50 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: initial readahead code and prototypes
References: <20120517071446.GI14660@elgon.mountain>
In-Reply-To: <20120517071446.GI14660@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/12 09:14, Dan Carpenter wrote:
> Hi, I'm working on some new Smatch code and it complains about this
> patch from last year. -Dan
>
> ----
> This is a semi-automatic email about new static checker warnings.
>
> The patch 7414a03fbf9e: "btrfs: initial readahead code and
> prototypes" from May 23, 2011, leads to the following Smatch
> complaint:
>
> fs/btrfs/reada.c:147 __readahead_hook()
> 	 error: we previously assumed 'eb' could be null (see line 122)
>
> fs/btrfs/reada.c
>     121	
>     122		if (eb)
>                     ^^^^
> Checked here.
>
>     123			level = btrfs_header_level(eb);
>     124	
>     125		/* find extent */
>     126		spin_lock(&fs_info->reada_lock);
>     127		re = radix_tree_lookup(&fs_info->reada_tree, index);
>     128		if (re)
>     129			kref_get(&re->refcnt);
>     130		spin_unlock(&fs_info->reada_lock);
>     131	
>     132		if (!re)
>     133			return -1;
>     134	
>     135		spin_lock(&re->lock);
>     136		/*
>     137		 * just take the full list from the extent. afterwards we
>     138		 * don't need the lock anymore
>     139		 */
>     140		list_replace_init(&re->extctl,&list);
>     141		for_dev = re->scheduled_for;
>     142		re->scheduled_for = NULL;
>     143		spin_unlock(&re->lock);
>     144	
>     145		if (err == 0) {
>     146			nritems = level ? btrfs_header_nritems(eb) : 0;
>                                    ^^^^^
> Checked here again indirectly.
>
>     147			generation = btrfs_header_generation(eb);
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Dereferenced inside function without checking.

The assumption here is that if err == 0, eb is always != NULL. There's
even a tiny comment above the function stating this:

       107              /* in case of err, eb might be NULL */

This code changes significantly with the patch

btrfs: extend readahead interface

Where it is written in a more obvious way.

-Arne

>
>     148			/*
>     149			 * FIXME: currently we just set nritems to 0 if this is a leaf,
>
> regards,
> dan carpenter
>

