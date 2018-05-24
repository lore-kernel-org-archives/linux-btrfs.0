Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50601 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030888AbeEXQp7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 12:45:59 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 241F4AEE2
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 16:45:58 +0000 (UTC)
Date: Thu, 24 May 2018 18:43:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
Message-ID: <20180524164313.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-4-wqu@suse.com>
 <20180522150636.GN6649@twin.jikos.cz>
 <34f13170-f2cb-4efe-7f11-72ce7aa5c622@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <34f13170-f2cb-4efe-7f11-72ce7aa5c622@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 07:38:28AM +0800, Qu Wenruo wrote:
> >> --- a/fs/btrfs/lzo.c
> >> +++ b/fs/btrfs/lzo.c
> >> @@ -281,6 +281,7 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
> >>  	unsigned long working_bytes;
> >>  	size_t in_len;
> >>  	size_t out_len;
> >> +	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
> > 
> > The value is a compile-time constant, it does not need to be stored in a
> > variable.
> 
> Just to save some long lines, as it's used several times.

My concern is about the eventual stack consumption by the variable. I
haven't measured that as the stack-bloat-script is now somehow broken so
I'm basing this on my previous evaluations. The long term plan is to
remove unnecessary variables or at least help the compiler to optimize
them out, every few bytes help and we hope for the cumulative effect.

The replacement by local variable sort of does not need to be in this
patch as it's not used for the header length check itself.

> >> @@ -294,6 +295,18 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
> >>  
> >>  	data_in = kmap(pages_in[0]);
> >>  	tot_len = read_compress_length(data_in);
> >> +	/*
> >> +	 * Compressed data header check.
> >> +	 *
> >> +	 * The real compressed size can't exceed extent length, and all pages
> >> +	 * should be used (a full pending page is not possible).
> >> +	 * If this happens it means the compressed extent is corrupted.
> >> +	 */
> >> +	if (tot_len > min_t(size_t, BTRFS_MAX_COMPRESSED, srclen) ||
> >> +	    tot_len < srclen - PAGE_SIZE) {
> > 
> > All such conditions can be put into unlikely() as this is an error
> > handling shortcut.
> 
> I'm OK to put it into unlikely().
> 
> I'll update this in next version.

I don't see the unlikely() in the most recent version but after some
considerations, I don't think it's needed. I'd rather look at the final
assembly if the compiler is smart enough to recognize the pattern.

Adding likely/unlikely without some proof is not welcome in general,
though in this case it's the allowed "jump to error handling".
