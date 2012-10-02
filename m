Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59350 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2JBOON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 10:14:13 -0400
Date: Tue, 2 Oct 2012 16:14:04 +0200
From: David Sterba <dave@jikos.cz>
To: Gordon Ng <gfng1@student.monash.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [Btrfs-next] bulid failure at fs/btrfs/ctree.h
Message-ID: <20121002141404.GU14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ09SM8fTkek=jN1QY1SHOs0uRiuUf4ug4+DRwJBYd0Yj3axfg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 02, 2012 at 10:50:26PM +1000, Gordon Ng wrote:
> Hello Josef,
> 
> FYI build failure occured in fs/btrfs/ctree.h.
>   CC      fs/btrfs/super.o
> In file included from fs/btrfs/delayed-inode.h:30:0,
>                  from fs/btrfs/super.c:45:
> fs/btrfs/ctree.h:3235:1: error: expected identifier or ?(? before ?<<? token

Can you please paste the sources from your tree? It's possible that it's
leftover from a local merge conflict.

>From my fresh 3.6 tree:

3232 static inline void btrfs_force_ra(struct address_space *mapping,
3233                                   struct file_ra_state *ra, struct file *file,
3234                                   pgoff_t offset, unsigned long req_size)
3235 {
3236         page_cache_sync_readahead(mapping, ra, file, offset, req_size);
3237 }


david
