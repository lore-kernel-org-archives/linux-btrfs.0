Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbbCMNbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 09:31:49 -0400
Date: Fri, 13 Mar 2015 14:31:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs: fix race on ENOMEM in alloc_extent_buffer
Message-ID: <20150313133146.GJ20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1424773781.git.osandov@osandov.com>
 <bb30d69d671243192fb08002b31375e55afe9644.1424773781.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bb30d69d671243192fb08002b31375e55afe9644.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2015 at 02:47:05AM -0800, Omar Sandoval wrote:
> Consider the following interleaving of overlapping calls to
> alloc_extent_buffer:
> 
> Call 1:
> 
> - Successfully allocates a few pages with find_or_create_page
> - find_or_create_page fails, goto free_eb
> - Unlocks the allocated pages
> 
> Call 2:
> - Calls find_or_create_page and gets a page in call 1's extent_buffer
> - Finds that the page is already associated with an extent_buffer
> - Grabs a reference to the half-written extent_buffer and calls
>   mark_extent_buffer_accessed on it
> 
> mark_extent_buffer_accessed will then try to call mark_page_accessed on
> a null page and panic.
> 
> The fix is to decrement the reference count on the half-written
> extent_buffer before unlocking the pages so call 2 won't use it. We
> should also set exists = NULL in the case that we don't use exists to
> avoid accidentally returning a freed extent_buffer in an error case.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
