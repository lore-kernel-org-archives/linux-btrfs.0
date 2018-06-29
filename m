Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932676AbeF2MfK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 08:35:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9DACCAE00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 12:35:09 +0000 (UTC)
Date: Fri, 29 Jun 2018 14:35:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: Refactor loop in
 btrfs_release_extent_buffer_page
Message-ID: <20180629123508.GQ2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530106705-27186-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 04:38:22PM +0300, Nikolay Borisov wrote:
> The purpose of the function is to free all the pages comprising an
> extent buffer. This can be achieved with a simple for loop rather than
> the slitghly more involved 'do {} while' construct. So rewrite the
> loop using a 'for' construct. Additionally we can never have an
> extent_buffer that is 0 pages so remove the check for index == 0. No
> functional changes.

The reversed loop makes sense, the first page is special and used for
locking the whole extent buffer's pages, as can be seen eg.
897ca6e9b4fef86d5dfb6b31 or 4f2de97acee6532b36dd6e99 . Also see current
alloc_extent_buffer for the locking and managing the private bit.

So you can still rewrite it as a for loop but would have to preserve the
logic or provide the reason that it's correct to iterate from 0 to
num_pages. There are some subltle races regarding pages and extents and
their presence in various trees, so I'd rather be careful here.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent_io.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index cce6087d6880..4180a3b7e725 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4641,19 +4641,14 @@ int extent_buffer_under_io(struct extent_buffer *eb)
>   */
>  static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
>  {
> -	unsigned long index;
> -	struct page *page;
> +	int i;
>  	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
>  
>  	BUG_ON(extent_buffer_under_io(eb));
>  
> -	index = num_extent_pages(eb->start, eb->len);
> -	if (index == 0)
> -		return;

This check does seem to be redundant.

> +	for (i = 0; i < num_extent_pages(eb->start, eb->len); i++) {

I think that the num_extent_pages(...) would be better put to a
temporary variable so it's not evaluated each time the loop termination
condition is checked.

> +		struct page *page = eb->pages[i];
>  
> -	do {
> -		index--;
> -		page = eb->pages[index];
>  		if (!page)
>  			continue;
>  		if (mapped)
