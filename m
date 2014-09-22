Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaIVNDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 09:03:36 -0400
Date: Mon, 22 Sep 2014 15:03:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: linux-btrfs@vger.kernel.org, Shawn Landen <shawnlandden@gmail.com>
Subject: Re: [PATCH 3/4] Fixing unaligned memory accesses.
Message-ID: <20140922130334.GM9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
 <1411261282-26831-3-git-send-email-xnox@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411261282-26831-3-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 21, 2014 at 02:01:21AM +0100, Dimitri John Ledkov wrote:
> From: Shawn Landen <shawnlandden@gmail.com>
> 
> Bug-Debian: http://bugs.debian.org/656955

The bug seems old (2012) and agains 0.19. We've fixed a few unaligned
access bugs in the meantime. Can you please retest with 3.16?

> --- a/ctree.h
> +++ b/ctree.h
> @@ -19,6 +19,8 @@
>  #ifndef __BTRFS__
>  #define __BTRFS__
>  
> +#include <stdint.h>
> +
>  #if BTRFS_FLAT_INCLUDES
>  #include "list.h"
>  #include "kerncompat.h"
> @@ -1191,13 +1193,17 @@ struct btrfs_root {
>  static inline u##bits btrfs_##name(const struct extent_buffer *eb)	\
>  {									\
>  	const struct btrfs_header *h = (struct btrfs_header *)eb->data;	\
> -	return le##bits##_to_cpu(h->member);				\
> +	uint##bits##_t t;						\
> +	memcpy(&t, &h->member, sizeof(h->member));			\
> +	return le##bits##_to_cpu(t);					\

The change to memcpy is safe, the compiler is smart enough to not emit
any memcpy call for x86_64 and there's no change to the leXX_to_cpu
macros.

However, I'd like to check first if this is really necessary due to the
old version in the bugreport. I'd prefer using the u8/.../u64 types
instead of the stdint.h ones, for sake of consistency with the rest of
the codebase.

> --- a/volumes.c
> +++ b/volumes.c
> @@ -472,10 +472,11 @@ static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
>  		if (found_key.objectid != objectid)
>  			*offset = 0;
>  		else {
> +			u64 t;
>  			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
>  					       struct btrfs_chunk);
> -			*offset = found_key.offset +
> -				btrfs_chunk_length(path->nodes[0], chunk);
> +			t = found_key.offset + btrfs_chunk_length(path->nodes[0], chunk);
> +			memcpy(offset, &t, sizeof(found_key.offset));

That's not enough, there are more direct assignments to *offset in that
function. The preferred way is to add 'put_unaligned' helper into
kerncompat.h and use it.
